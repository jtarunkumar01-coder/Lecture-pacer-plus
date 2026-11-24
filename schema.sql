-- Run ONCE inside Supabase Dashboard > SQL Editor.
-- This stores one JSON study plan per authenticated user.
-- Row Level Security means each signed-in user can access only their own row.
create table if not exists public.study_plans (
  user_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null default '{}'::jsonb,
  version bigint not null default 0,
  updated_at timestamptz not null default now()
);

alter table public.study_plans enable row level security;

grant select, insert, update, delete on public.study_plans to authenticated;

drop policy if exists "read_own_plan" on public.study_plans;
create policy "read_own_plan"
  on public.study_plans for select to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "insert_own_plan" on public.study_plans;
create policy "insert_own_plan"
  on public.study_plans for insert to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "update_own_plan" on public.study_plans;
create policy "update_own_plan"
  on public.study_plans for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- Deliberately no DELETE policy: accidental deletion of cloud plans isn't permitted.
