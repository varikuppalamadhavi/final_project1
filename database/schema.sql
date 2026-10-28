-- RentNest schema: run this complete script in Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.properties (
 id uuid primary key default gen_random_uuid(),
 title text not null check (length(trim(title)) between 2 and 120),
 address text not null,
 city text not null,
 property_type text not null check (property_type in ('Apartment','House','Studio','Villa','Commercial')),
 bedrooms integer not null default 1 check (bedrooms >= 0),
 bathrooms integer not null default 1 check (bathrooms >= 0),
 monthly_rent numeric(12,2) not null check (monthly_rent >= 0),
 status text not null default 'Available' check (status in ('Available','Occupied','Maintenance')),
 description text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.tenants (
 id uuid primary key default gen_random_uuid(),
 full_name text not null check (length(trim(full_name)) >= 2),
 email text not null unique,
 phone text,
 occupation text,
 move_in_date date,
 notes text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.leases (
 id uuid primary key default gen_random_uuid(),
 property_id uuid not null references public.properties(id) on delete restrict,
 tenant_id uuid not null references public.tenants(id) on delete restrict,
 monthly_rent numeric(12,2) not null check (monthly_rent >= 0),
 start_date date not null,
 end_date date not null,
 status text not null default 'Pending' check (status in ('Active','Ended','Pending')),
 notes text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(),
 constraint valid_lease_dates check (end_date >= start_date)
);
create index if not exists idx_properties_city on public.properties(city);
create index if not exists idx_properties_status on public.properties(status);
create index if not exists idx_tenants_email on public.tenants(email);
create index if not exists idx_leases_property on public.leases(property_id);
create index if not exists idx_leases_tenant on public.leases(tenant_id);
create index if not exists idx_leases_status on public.leases(status);
create or replace function public.set_updated_at() returns trigger language plpgsql as $$ begin new.updated_at = now(); return new; end; $$;
drop trigger if exists properties_updated_at on public.properties;
create trigger properties_updated_at before update on public.properties for each row execute function public.set_updated_at();
drop trigger if exists tenants_updated_at on public.tenants;
create trigger tenants_updated_at before update on public.tenants for each row execute function public.set_updated_at();
drop trigger if exists leases_updated_at on public.leases;
create trigger leases_updated_at before update on public.leases for each row execute function public.set_updated_at();
-- This MVP connects through a server-side secret key. Do not expose it to browsers or GitHub.
-- If switching to browser-side Supabase access, enable RLS and add policies first.
