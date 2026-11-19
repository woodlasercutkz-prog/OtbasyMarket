-- Выполните в Supabase: SQL Editor -> New query -> Run
create table if not exists public.store_items(
  collection text not null,
  id text not null,
  data jsonb not null default '{}'::jsonb,
  deleted boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key(collection,id));
create index if not exists store_items_upd on public.store_items(collection,updated_at);
create or replace function public.touch() returns trigger language plpgsql as $$
begin new.updated_at=now(); return new; end $$;
drop trigger if exists store_items_touch on public.store_items;
create trigger store_items_touch before insert or update on public.store_items
  for each row execute function public.touch();
alter table public.store_items enable row level security;
-- ВНИМАНИЕ: тестовый режим. Любой, у кого есть anon key, может читать и писать.
-- Перед боевым запуском ужесточите политики (Supabase Auth для продавца/разработчика).
drop policy if exists "anon read" on public.store_items;
drop policy if exists "anon insert" on public.store_items;
drop policy if exists "anon update" on public.store_items;
create policy "anon read" on public.store_items for select to anon using (true);
create policy "anon insert" on public.store_items for insert to anon with check (true);
create policy "anon update" on public.store_items for update to anon using (true) with check (true);
