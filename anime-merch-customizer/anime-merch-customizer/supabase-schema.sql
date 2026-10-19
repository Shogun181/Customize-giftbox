-- Run this in Supabase Dashboard > SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.gift_boxes (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  theme text not null,
  price numeric(12,2) not null default 0 check (price >= 0),
  description text not null,
  items jsonb not null default '[]'::jsonb,
  image_url text not null default '',
  status text not null default 'draft' check (status in ('published','draft')),
  contact_url text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.gift_boxes enable row level security;

-- Anyone can read published gift boxes on the storefront.
drop policy if exists "Public can read published gift boxes" on public.gift_boxes;
create policy "Public can read published gift boxes"
on public.gift_boxes for select
using (status = 'published' or auth.role() = 'authenticated');

-- Only signed-in users can create, edit, and delete. For a single-owner site,
-- only create the one admin account in Supabase Authentication.
drop policy if exists "Authenticated users can insert gift boxes" on public.gift_boxes;
create policy "Authenticated users can insert gift boxes"
on public.gift_boxes for insert to authenticated with check (true);
drop policy if exists "Authenticated users can update gift boxes" on public.gift_boxes;
create policy "Authenticated users can update gift boxes"
on public.gift_boxes for update to authenticated using (true) with check (true);
drop policy if exists "Authenticated users can delete gift boxes" on public.gift_boxes;
create policy "Authenticated users can delete gift boxes"
on public.gift_boxes for delete to authenticated using (true);

-- Public image bucket: covers are intended to appear on the storefront.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('gift-box-images', 'gift-box-images', true, 5242880, array['image/png','image/jpeg','image/webp'])
on conflict (id) do update set public = true, file_size_limit = 5242880;

drop policy if exists "Public can view gift box images" on storage.objects;
create policy "Public can view gift box images"
on storage.objects for select using (bucket_id = 'gift-box-images');
drop policy if exists "Authenticated users can upload gift box images" on storage.objects;
create policy "Authenticated users can upload gift box images"
on storage.objects for insert to authenticated with check (bucket_id = 'gift-box-images');
drop policy if exists "Authenticated users can update gift box images" on storage.objects;
create policy "Authenticated users can update gift box images"
on storage.objects for update to authenticated using (bucket_id = 'gift-box-images') with check (bucket_id = 'gift-box-images');
drop policy if exists "Authenticated users can delete gift box images" on storage.objects;
create policy "Authenticated users can delete gift box images"
on storage.objects for delete to authenticated using (bucket_id = 'gift-box-images');
