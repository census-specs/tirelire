-- ═══════════════════════════════════════════════════════════════
--  Tirelire v4.0 — Comptes + synchronisation
--  À coller UNE FOIS dans Supabase → SQL Editor → New query → Run
--  Sans danger si vous le relancez (idempotent).
-- ═══════════════════════════════════════════════════════════════

-- 1) PROFILS : un nom d'utilisateur unique par compte ---------------------
create table if not exists public.profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  username   text not null unique check (username ~ '^[a-z0-9_]{3,20}$'),
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

drop policy if exists "profil_lecture"      on public.profiles;
drop policy if exists "profil_modification" on public.profiles;
create policy "profil_lecture"      on public.profiles for select to authenticated using (auth.uid() = id);
create policy "profil_modification" on public.profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

-- Création automatique du profil à l'inscription (nom pris dans l'inscription,
-- sinon user_xxxxxxxx ; en cas de doublon rarissime, un suffixe est ajouté).
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
declare
  u text := lower(coalesce(new.raw_user_meta_data->>'username', ''));
begin
  if u !~ '^[a-z0-9_]{3,20}$' then
    u := 'user_' || substr(replace(new.id::text, '-', ''), 1, 8);
  end if;
  begin
    insert into public.profiles (id, username) values (new.id, u);
  exception when unique_violation then
    insert into public.profiles (id, username)
    values (new.id, substr(u, 1, 11) || '_' || substr(replace(new.id::text, '-', ''), 1, 8));
  end;
  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Vérification « nom déjà pris ? » avant inscription (ne révèle rien d'autre).
create or replace function public.username_available(u text)
returns boolean language sql security definer stable set search_path = public as $$
  select not exists (select 1 from public.profiles where username = lower(u));
$$;
revoke all on function public.username_available(text) from public;
grant execute on function public.username_available(text) to anon, authenticated;

-- 2) DONNÉES : une ligne par utilisateur, privée ---------------------------
create table if not exists public.user_data (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb check (octet_length(data::text) < 8000000),
  rev        bigint not null default 1,         -- numéro de version (détecte les conflits)
  device     text,
  updated_at timestamptz not null default now()
);

alter table public.user_data enable row level security;

drop policy if exists "data_lecture"      on public.user_data;
drop policy if exists "data_insertion"    on public.user_data;
drop policy if exists "data_modification" on public.user_data;
drop policy if exists "data_suppression"  on public.user_data;
create policy "data_lecture"      on public.user_data for select to authenticated using (auth.uid() = user_id);
create policy "data_insertion"    on public.user_data for insert to authenticated with check (auth.uid() = user_id);
create policy "data_modification" on public.user_data for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "data_suppression"  on public.user_data for delete to authenticated using (auth.uid() = user_id);

-- Le serveur incrémente lui-même rev et la date (on ne se fie pas à l'horloge du téléphone).
create or replace function public.user_data_bump()
returns trigger language plpgsql as $$
begin
  new.rev        := old.rev + 1;
  new.updated_at := now();
  new.user_id    := old.user_id;
  return new;
end $$;

drop trigger if exists user_data_bump on public.user_data;
create trigger user_data_bump before update on public.user_data
  for each row execute function public.user_data_bump();

-- 3) DROITS : rien pour les visiteurs non connectés ------------------------
revoke all on public.profiles  from anon;
revoke all on public.user_data from anon;
grant select, update                 on public.profiles  to authenticated;
grant select, insert, update, delete on public.user_data to authenticated;
