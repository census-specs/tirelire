-- ═══════════════════════════════════════════════════════════════
--  Tirelire v4.2 — Versements Mobile Money, validation, contributions
--  À coller UNE FOIS dans Supabase → SQL Editor → New query → Run
--  (après 01 et 02). Sans danger si vous le relancez.
-- ═══════════════════════════════════════════════════════════════

-- 1) VERSEMENTS DÉCLARÉS ----------------------------------------------------
create table if not exists public.shared_contributions (
  id         uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.shared_projects(id) on delete cascade,
  user_id    uuid not null references auth.users(id) on delete cascade,
  amount     bigint not null check (amount between 100 and 10000000),
  operator   text not null check (operator in ('mtn','orange')),
  txn_id     text not null check (txn_id ~ '^[A-Za-z0-9._-]{4,30}$'),
  note       text not null default '' check (char_length(note) <= 140),
  status     text not null default 'pending' check (status in ('pending','validated','rejected')),
  reason     text not null default '' check (char_length(reason) <= 140),
  applied    boolean not null default false,   -- true une fois crédité dans l'app du créateur
  created_at timestamptz not null default now(),
  decided_at timestamptz
);
create index if not exists shared_contrib_project_idx on public.shared_contributions(project_id, status);
create index if not exists shared_contrib_user_idx    on public.shared_contributions(user_id);
-- Un même ID de transaction ne peut être déclaré qu'une fois par projet (sauf s'il a été refusé).
create unique index if not exists shared_contrib_txn_uq
  on public.shared_contributions(project_id, operator, upper(txn_id)) where status <> 'rejected';

alter table public.shared_contributions enable row level security;
drop policy if exists "sc_lecture_auteur"   on public.shared_contributions;
drop policy if exists "sc_lecture_createur" on public.shared_contributions;
create policy "sc_lecture_auteur"   on public.shared_contributions for select to authenticated using (auth.uid() = user_id);
create policy "sc_lecture_createur" on public.shared_contributions for select to authenticated
  using (exists (select 1 from public.shared_projects sp where sp.id = project_id and sp.owner_id = auth.uid()));
-- Aucune écriture directe : tout passe par les fonctions ci-dessous.
revoke all on public.shared_contributions from anon;
revoke insert, update, delete on public.shared_contributions from authenticated;
grant select on public.shared_contributions to authenticated;

-- 2) DÉCLARER UN VERSEMENT (participant) ------------------------------------
create or replace function public.submit_contribution(p_project uuid, p_amount bigint, p_operator text, p_txn text, p_note text default '')
returns json language plpgsql security definer set search_path = public as $$
declare sp public.shared_projects; c public.shared_contributions;
begin
  if auth.uid() is null then raise exception 'Connexion requise' using errcode = '28000'; end if;
  select * into sp from public.shared_projects where id = p_project;
  if not found then raise exception 'Projet introuvable' using errcode = 'P0002'; end if;
  if sp.owner_id = auth.uid() then raise exception 'Le créateur ne déclare pas de versement' using errcode = 'P0001'; end if;
  if not exists (select 1 from public.shared_members where project_id = p_project and user_id = auth.uid()) then
    raise exception 'Rejoignez d''abord le projet' using errcode = 'P0001'; end if;
  if sp.status <> 'active' then raise exception 'Ce projet n''accepte plus de versements' using errcode = 'P0001'; end if;
  if not exists (select 1 from jsonb_array_elements(sp.momo) m where m->>'operator' = p_operator) then
    raise exception 'Ce projet n''a pas de compte %', p_operator using errcode = 'P0001'; end if;
  if (select count(*) from public.shared_contributions where project_id = p_project and user_id = auth.uid() and status = 'pending') >= 10 then
    raise exception 'Trop de versements en attente de validation' using errcode = 'P0001'; end if;
  begin
    insert into public.shared_contributions(project_id, user_id, amount, operator, txn_id, note)
    values (p_project, auth.uid(), p_amount, p_operator, trim(p_txn), left(coalesce(p_note,''), 140)) returning * into c;
  exception
    when unique_violation then raise exception 'Cet ID de transaction a déjà été déclaré' using errcode = 'P0001';
    when check_violation then raise exception 'Montant (100 à 10 000 000) ou ID de transaction (4 à 30 caractères) invalide' using errcode = 'P0001';
  end;
  return row_to_json(c);
end $$;
revoke all on function public.submit_contribution(uuid, bigint, text, text, text) from public;
grant execute on function public.submit_contribution(uuid, bigint, text, text, text) to authenticated;

-- 3) ANNULER UN VERSEMENT EN ATTENTE (participant) ---------------------------
create or replace function public.cancel_contribution(p_id uuid)
returns boolean language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null then raise exception 'Connexion requise' using errcode = '28000'; end if;
  delete from public.shared_contributions where id = p_id and user_id = auth.uid() and status = 'pending';
  return found;
end $$;
revoke all on function public.cancel_contribution(uuid) from public;
grant execute on function public.cancel_contribution(uuid) to authenticated;

-- 4) VALIDER / REFUSER (créateur) --------------------------------------------
create or replace function public.decide_contribution(p_id uuid, p_decision text, p_reason text default '')
returns json language plpgsql security definer set search_path = public as $$
declare c public.shared_contributions;
begin
  if auth.uid() is null then raise exception 'Connexion requise' using errcode = '28000'; end if;
  if p_decision not in ('validated','rejected') then raise exception 'Décision invalide' using errcode = 'P0001'; end if;
  update public.shared_contributions c2
     set status = p_decision, reason = left(coalesce(p_reason,''), 140), decided_at = now()
   where c2.id = p_id and c2.status = 'pending'
     and exists (select 1 from public.shared_projects sp where sp.id = c2.project_id and sp.owner_id = auth.uid())
  returning * into c;
  if not found then raise exception 'Versement introuvable ou déjà traité' using errcode = 'P0002'; end if;
  return row_to_json(c);
end $$;
revoke all on function public.decide_contribution(uuid, text, text) from public;
grant execute on function public.decide_contribution(uuid, text, text) to authenticated;

-- 5) MARQUER « CRÉDITÉ » (créateur, après l'écriture dans sa caisse) -----------
create or replace function public.mark_contributions_applied(p_ids uuid[])
returns integer language plpgsql security definer set search_path = public as $$
declare n integer;
begin
  if auth.uid() is null then raise exception 'Connexion requise' using errcode = '28000'; end if;
  update public.shared_contributions c set applied = true
   where c.id = any(p_ids) and c.status = 'validated' and not c.applied
     and exists (select 1 from public.shared_projects sp where sp.id = c.project_id and sp.owner_id = auth.uid());
  get diagnostics n = row_count;
  return n;
end $$;
revoke all on function public.mark_contributions_applied(uuid[]) from public;
grant execute on function public.mark_contributions_applied(uuid[]) to authenticated;

-- 6) NUMÉROS MOBILE MONEY : visibles par le créateur et les participants seulement
create or replace function public.project_momo(p_project uuid)
returns jsonb language plpgsql security definer stable set search_path = public as $$
declare sp public.shared_projects;
begin
  if auth.uid() is null then raise exception 'Connexion requise' using errcode = '28000'; end if;
  select * into sp from public.shared_projects where id = p_project;
  if not found then raise exception 'Projet introuvable' using errcode = 'P0002'; end if;
  if sp.owner_id <> auth.uid() and not exists (select 1 from public.shared_members where project_id = p_project and user_id = auth.uid()) then
    raise exception 'Accès refusé' using errcode = '42501'; end if;
  return sp.momo;
end $$;
revoke all on function public.project_momo(uuid) from public;
grant execute on function public.project_momo(uuid) to authenticated;

-- 7) MONTANT TOTAL = épargne du créateur + versements validés pas encore crédités
create or replace function public.sp_total(p_id uuid)
returns bigint language sql security definer stable set search_path = public as $$
  select sp.owner_amount + coalesce((select sum(c.amount) from public.shared_contributions c
          where c.project_id = sp.id and c.status = 'validated' and not c.applied), 0)
  from public.shared_projects sp where sp.id = p_id;
$$;
revoke all on function public.sp_total(uuid) from public;

-- 8) PAGE PUBLIQUE : contributions validées par membre (prénoms/pseudos seulement)
create or replace function public.public_project(p_slug text)
returns json language sql security definer stable set search_path = public as $$
  select json_build_object(
    'slug', sp.slug, 'title', sp.title, 'description', sp.description,
    'goal', sp.goal, 'amount', public.sp_total(sp.id), 'status', sp.status,
    'icon', sp.icon, 'color', sp.color, 'created_at', sp.created_at,
    'owner', (select username from public.profiles where id = sp.owner_id),
    'members', (select count(*) from public.shared_members m where m.project_id = sp.id),
    'contributors', coalesce((select json_agg(json_build_object('name', t.name, 'amount', t.total) order by t.total desc)
       from (select coalesce(pr.username, 'Anonyme') as name, sum(c.amount) as total
             from public.shared_contributions c left join public.profiles pr on pr.id = c.user_id
             where c.project_id = sp.id and c.status = 'validated'
             group by c.user_id, pr.username) t), '[]'::json))
  from public.shared_projects sp
  where sp.slug = lower(p_slug) and sp.is_public;
$$;
revoke all on function public.public_project(text) from public;
grant execute on function public.public_project(text) to anon, authenticated;

-- 9) MES PROJETS REJOINTS (+ ma part validée)
create or replace function public.my_joined_projects()
returns json language sql security definer stable set search_path = public as $$
  select coalesce(json_agg(json_build_object(
    'id', sp.id, 'slug', sp.slug, 'title', sp.title, 'description', sp.description,
    'goal', sp.goal, 'amount', public.sp_total(sp.id), 'status', sp.status, 'icon', sp.icon, 'color', sp.color,
    'owner', (select username from public.profiles where id = sp.owner_id),
    'mine', coalesce((select sum(c.amount) from public.shared_contributions c where c.project_id = sp.id and c.user_id = auth.uid() and c.status = 'validated'), 0),
    'joined_at', m.joined_at) order by m.joined_at desc), '[]'::json)
  from public.shared_members m join public.shared_projects sp on sp.id = m.project_id
  where m.user_id = auth.uid();
$$;
revoke all on function public.my_joined_projects() from public;
grant execute on function public.my_joined_projects() to authenticated;

-- 10) HISTORIQUE DES VERSEMENTS D'UN PROJET (créateur : avec les pseudos)
create or replace function public.owner_contributions(p_project uuid)
returns json language plpgsql security definer stable set search_path = public as $$
begin
  if auth.uid() is null then raise exception 'Connexion requise' using errcode = '28000'; end if;
  if not exists (select 1 from public.shared_projects where id = p_project and owner_id = auth.uid()) then
    raise exception 'Accès refusé' using errcode = '42501'; end if;
  return coalesce((select json_agg(x order by x.created_at desc) from (
    select c.id, c.user_id, coalesce(pr.username, 'Anonyme') as name, c.amount, c.operator, c.txn_id, c.note,
           c.status, c.reason, c.applied, c.created_at, c.decided_at
      from public.shared_contributions c left join public.profiles pr on pr.id = c.user_id
     where c.project_id = p_project order by c.created_at desc limit 100) x), '[]'::json);
end $$;
revoke all on function public.owner_contributions(uuid) from public;
grant execute on function public.owner_contributions(uuid) to authenticated;
