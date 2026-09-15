-- Jalankan di Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.customers (
 id uuid primary key default gen_random_uuid(), contract text unique not null, name text not null,
 priority text, pa text, address text, village text, district text, map text, rating text,
 phone text, visit_status text check (visit_status in ('Bertemu','Tidak Bertemu') or visit_status is null), updated_at timestamptz default now()
);
create table if not exists public.admin_emails (id uuid primary key default gen_random_uuid(), email text unique not null, created_at timestamptz default now());
create table if not exists public.profiles (id uuid primary key references auth.users(id) on delete cascade, email text, is_admin boolean default false, created_at timestamptz default now());

create or replace function public.is_admin() returns boolean language sql stable security definer set search_path=public as $$
 select exists(select 1 from public.admin_emails where lower(email)=lower((select email from auth.users where id=auth.uid())));
$$;

alter table public.customers enable row level security;
alter table public.admin_emails enable row level security;
alter table public.profiles enable row level security;
drop policy if exists customers_auth_select on public.customers;
create policy customers_auth_select on public.customers for select to authenticated using (true);
drop policy if exists customers_admin_write on public.customers;
create policy customers_admin_write on public.customers for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists admin_emails_admin on public.admin_emails;
create policy admin_emails_admin on public.admin_emails for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists profiles_self on public.profiles;
create policy profiles_self on public.profiles for select to authenticated using (id=auth.uid());

create or replace view public.customer_public as select id,contract,name,priority,pa,address,village,district,map,rating,visit_status,updated_at from public.customers;
-- Penting: akses phone admin dibatasi di aplikasi. Untuk keamanan tingkat database yang lebih ketat, gunakan view admin_customer_phone dan beri SELECT hanya kepada service role/backend.
create or replace view public.admin_customer_phone as select * from public.customers;

grant select on public.customer_public to authenticated;
grant select on public.admin_customer_phone to authenticated;

create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin insert into public.profiles(id,email,is_admin) values(new.id,new.email,public.is_admin()) on conflict(id) do update set email=excluded.email,is_admin=excluded.is_admin; return new; end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
