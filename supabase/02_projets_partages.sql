-- ═══════════════════════════════════════════════════════════════
--  Tirelire v4.1 — Projets partagés (création, lien public, participation)
--  À coller UNE FOIS dans Supabase → SQL Editor → New query → Run
--  (après 01_comptes_et_sync.sql). Sans danger si vous le relancez.
-- ═══════════════════════════════════════════════════════════════

-- 1) PROJETS PARTAGÉS ------------------------------------------------------
create table if not exists public.shared_projects (
  id           uuid primary key default gen_random_uuid(),
  owner_id     uuid not null references auth.users(id) on delete cascade,
  slug         text not null unique
               check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$' and char_length(slug) between 3 and 40
                      and slug not in ('admin','api','app','p','projet','projets','tirelire','www','login','join','config','static','assets')),
  title        text not null check (char_length(title) between 2 and 60),
  description  text not null default '' check (char_length(description) <= 300),
  goal         bigint not null default 0 check (goal >= 0),
  owner_amount bigint not null default 0,                 -- épargne du créateur (mise à jour par l'app)
  icon         text,
  color        text,
  momo         jsonb not null default '[]'::jsonb         -- [{operator:'mtn'|'orange', number:'6XXXXXXXX', holder:'Nom'}]
               check (jsonb_typeof(momo) = 'array' and jsonb_array_length(momo) <= 2),
  is_public    boolean not null default true,
  status       text not null default 'active' check (status in ('active','closed','realized')),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create index if not exists shared_projects_owner_idx on public.shared_projects(owner_id);

alter table public.shared_projects enable row level security;
drop policy if exists "sp_lecture"      on public.shared_projects;
drop policy if exists "sp_insertion"    on public.shared_projects;
drop policy if exists "sp_modification" on public.shared_projects;
drop policy if exists "sp_suppression"  on public.shared_projects;
-- Seul le créateur lit la ligne complète (numéros Mobile Money compris).
create policy "sp_lecture"      on public.shared_projects for select to authenticated using (auth.uid() = owner_id);
create policy "sp_insertion"    on public.shared_projects for insert to authenticated with check (auth.uid() = owner_id);
create policy "sp_modification" on public.shared_projects for update to authenticated using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy "sp_suppression"  on public.shared_projects for delete to authenticated using (auth.uid() = owner_id);

create or replace function public.shared_projects_touch()
returns trigger language plpgsql as $$
begin
  new.updated_at := now();
  new.owner_id   := old.owner_id;   -- le propriétaire ne change jamais
  new.created_at := old.created_at;
  return new;
end $$;
drop trigger if exists shared_projects_touch on public.shared_projects;
create trigger shared_projects_touch before update on public.shared_projects
  for each row execute function public.shared_projects_touch();

-- 2) MEMBRES (les participants qui ont cliqué « Participer ») --------------
create table if not exists public.shared_members (
  project_id uuid not null references public.shared_projects(id) on delete cascade,
  user_id    uuid not null references auth.users(id) on delete cascade,
  joined_at  timestamptz not null default now(),
  primary key (project_id, user_id)
);
create index if not exists shared_members_user_idx on public.shared_members(user_id);

alter table public.shared_members enable row level security;
drop policy if exists "sm_lecture_membre"  on public.shared_members;
drop policy if exists "sm_lecture_createur" on public.shared_members;
drop policy if exists "sm_quitter"         on public.shared_members;
create policy "sm_lecture_membre"   on public.shared_members for select to authenticated using (auth.uid() = user_id);
create policy "sm_lecture_createur" on public.shared_members for select to authenticated
  using (exists (select 1 from public.shared_projects sp where sp.id = project_id and sp.owner_id = auth.uid()));
create policy "sm_quitter"          on public.shared_members for delete to authenticated using (auth.uid() = user_id);
-- (pas de politique d'insertion : on rejoint uniquement via join_project)

-- 3) FONCTIONS PUBLIQUES ----------------------------------------------------
-- Lien disponible ?
create or replace function public.slug_available(s text)
returns boolean language sql security definer stable set search_path = public as $$
  select s ~ '^[a-z0-9]+(-[a-z0-9]+)*$' and char_length(s) between 3 and 40
     and s not in ('admin','api','app','p','projet','projets','tirelire','www','login','join','config','static','assets')
     and not exists (select 1 from public.shared_projects where slug = s);
$$;
revoke all on function public.slug_available(text) from public;
grant execute on function public.slug_available(text) to anon, authenticated;

-- Données de la page publique : uniquement des champs non sensibles (jamais les numéros).
create or replace function public.public_project(p_slug text)
returns json language sql security definer stable set search_path = public as $$
  select json_build_object(
    'slug', sp.slug, 'title', sp.title, 'description', sp.description,
    'goal', sp.goal, 'amount', sp.owner_amount, 'status', sp.status,
    'icon', sp.icon, 'color', sp.color, 'created_at', sp.created_at,
    'owner', (select username from public.profiles where id = sp.owner_id),
    'members', (select count(*) from public.shared_members m where m.project_id = sp.id),
    'contributors', '[]'::json)
  from public.shared_projects sp
  where sp.slug = lower(p_slug) and sp.is_public;
$$;
revoke all on function public.public_project(text) from public;
grant execute on function public.public_project(text) to anon, authenticated;

-- « Participer » : ajoute le projet aux projets partagés de l'utilisateur connecté.
create or replace function public.join_project(p_slug text)
returns json language plpgsql security definer set search_path = public as $$
declare sp public.shared_projects;
begin
  if auth.uid() is null then raise exception 'Connexion requise' using errcode = '28000'; end if;
  select * into sp from public.shared_projects where slug = lower(p_slug) and is_public;
  if not found then raise exception 'Projet introuvable' using errcode = 'P0002'; end if;
  if sp.owner_id <> auth.uid() then
    if sp.status <> 'active' then raise exception 'Ce projet n''accepte plus de participants' using errcode = 'P0001'; end if;
    insert into public.shared_members(project_id, user_id) values (sp.id, auth.uid()) on conflict do nothing;
  end if;
  return public.public_project(sp.slug);
end $$;
revoke all on function public.join_project(text) from public;
grant execute on function public.join_project(text) to authenticated;

-- Projets que j'ai rejoints (infos publiques + date d'arrivée).
create or replace function public.my_joined_projects()
returns json language sql security definer stable set search_path = public as $$
  select coalesce(json_agg(json_build_object(
    'id', sp.id, 'slug', sp.slug, 'title', sp.title, 'description', sp.description,
    'goal', sp.goal, 'amount', sp.owner_amount, 'status', sp.status, 'icon', sp.icon, 'color', sp.color,
    'owner', (select username from public.profiles where id = sp.owner_id),
    'joined_at', m.joined_at) order by m.joined_at desc), '[]'::json)
  from public.shared_members m join public.shared_projects sp on sp.id = m.project_id
  where m.user_id = auth.uid();
$$;
revoke all on function public.my_joined_projects() from public;
grant execute on function public.my_joined_projects() to authenticated;

-- 4) DROITS -----------------------------------------------------------------
revoke all on public.shared_projects from anon;
revoke all on public.shared_members  from anon;
grant select, insert, update, delete on public.shared_projects to authenticated;
grant select, delete                 on public.shared_members  to authenticated;
