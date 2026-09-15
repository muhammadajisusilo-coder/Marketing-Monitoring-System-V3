-- Supabase schema for Visit Control Kendal
create extension if not exists pgcrypto;

create table if not exists public.customers (
 id uuid primary key default gen_random_uuid(),
 contract text unique not null,
 name text not null,
 priority text, pa text, address text, village text, district text, map text, rating text,
 phone text,
 visit_status text check (visit_status in ('Bertemu','Tidak Bertemu') or visit_status is null),
 updated_at timestamptz default now()
);
create table if not exists public.customer_phones (
 contract text primary key references public.customers(contract) on delete cascade,
 phone text,
 updated_at timestamptz default now()
);
create table if not exists public.admin_emails (
 id uuid primary key default gen_random_uuid(), email text unique not null, created_at timestamptz default now()
);
create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade, email text, is_admin boolean default false, created_at timestamptz default now()
);

alter table public.customers enable row level security;
alter table public.customer_phones enable row level security;
alter table public.admin_emails enable row level security;
alter table public.profiles enable row level security;

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path=public as $$
 select exists(select 1 from public.admin_emails where lower(email)=lower((select email from auth.users where id=auth.uid())));
$$;
grant execute on function public.is_admin() to authenticated;

-- Base customer table: ordinary users have no direct access; admin has full access.
revoke all on public.customers from anon;
revoke all on public.customers from authenticated;
grant select, insert, update, delete on public.customers to authenticated;
drop policy if exists customers_auth_select on public.customers;
drop policy if exists customers_admin_write on public.customers;
create policy customers_admin_all on public.customers for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Phone table is admin-only.
revoke all on public.customer_phones from anon;
revoke all on public.customer_phones from authenticated;
grant select, insert, update, delete on public.customer_phones to authenticated;
drop policy if exists customer_phones_admin_select on public.customer_phones;
drop policy if exists customer_phones_admin_write on public.customer_phones;
create policy customer_phones_admin_all on public.customer_phones for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Admin email list is admin-only.
revoke all on public.admin_emails from anon;
revoke all on public.admin_emails from authenticated;
grant select, insert, update, delete on public.admin_emails to authenticated;
drop policy if exists admin_emails_admin on public.admin_emails;
create policy admin_emails_admin on public.admin_emails for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Profiles: user can read own profile.
revoke all on public.profiles from anon;
revoke all on public.profiles from authenticated;
grant select on public.profiles to authenticated;
drop policy if exists profiles_self on public.profiles;
create policy profiles_self on public.profiles for select to authenticated using (id=auth.uid());

-- Safe public view: no phone column. Normal view intentionally runs with its owner privileges.
drop view if exists public.customer_public;
create view public.customer_public as
 select id,contract,name,priority,pa,address,village,district,map,rating,visit_status,updated_at
 from public.customers;
grant select on public.customer_public to authenticated;

-- Trigger keeps profiles current for users that sign in.
create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin
 insert into public.profiles(id,email,is_admin) values(new.id,new.email,public.is_admin())
 on conflict(id) do update set email=excluded.email,is_admin=excluded.is_admin;
 return new;
end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

-- Admin-only bulk import. Phone is written to the private table, never to the public view.
create or replace function public.admin_import_customers(payload jsonb)
returns integer
language plpgsql
security definer
set search_path=public
as $$
declare r jsonb; n integer:=0; c text; p text;
begin
 if not public.is_admin() then raise exception 'Akses admin diperlukan'; end if;
 for r in select * from jsonb_array_elements(payload) loop
   c:=trim(coalesce(r->>'contract','')); if c='' then continue; end if;
   insert into public.customers(contract,name,priority,pa,address,village,district,map,rating,visit_status,updated_at)
   values(c,coalesce(r->>'name',''),r->>'priority',r->>'pa',r->>'address',r->>'village',r->>'district',r->>'map',r->>'rating',nullif(r->>'visit_status',''),now())
   on conflict(contract) do update set
    name=excluded.name, priority=excluded.priority, pa=excluded.pa, address=excluded.address,
    village=excluded.village, district=excluded.district, map=excluded.map, rating=excluded.rating,
    visit_status=excluded.visit_status, updated_at=now();
   p:=trim(coalesce(r->>'phone',''));
   if p<>'' then
     insert into public.customer_phones(contract,phone,updated_at) values(c,p,now())
     on conflict(contract) do update set phone=excluded.phone,updated_at=now();
   end if;
   n:=n+1;
 end loop;
 return n;
end; $$;
grant execute on function public.admin_import_customers(jsonb) to authenticated;

-- Ensure existing admin email requested for this project is present.
insert into public.admin_emails(email) values('muhammadajisusilo@gmail.com') on conflict(email) do nothing;
