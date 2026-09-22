-- Jalankan seluruh SQL ini di Supabase SQL Editor.
-- Setelah selesai, buat 1 akun admin melalui Authentication > Users > Add user.
-- Setelah akun admin dibuat, kamu dapat login di website.
-- Untuk keamanan, setelah akun admin dibuat, nonaktifkan public sign-up
-- di Authentication > Providers > Email jika tersedia di project kamu.

create extension if not exists pgcrypto;

create table if not exists public.albums (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists public.photos (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  album_name text not null references public.albums(name) on update cascade on delete cascade,
  storage_path text not null unique,
  public_url text not null,
  created_at timestamptz not null default now()
);

alter table public.albums enable row level security;
alter table public.photos enable row level security;

drop policy if exists "Public can read albums" on public.albums;
create policy "Public can read albums" on public.albums for select using (true);

drop policy if exists "Authenticated can manage albums" on public.albums;
create policy "Authenticated can manage albums" on public.albums for all to authenticated using (true) with check (true);

drop policy if exists "Public can read photos" on public.photos;
create policy "Public can read photos" on public.photos for select using (true);

drop policy if exists "Authenticated can manage photos" on public.photos;
create policy "Authenticated can manage photos" on public.photos for all to authenticated using (true) with check (true);

insert into public.albums(name) values ('Umum') on conflict (name) do nothing;

-- Buat bucket penyimpanan foto.
insert into storage.buckets (id, name, public)
values ('photos', 'photos', true)
on conflict (id) do update set public = true;

drop policy if exists "Public can view album photos" on storage.objects;
create policy "Public can view album photos" on storage.objects
for select using (bucket_id = 'photos');

drop policy if exists "Authenticated can upload album photos" on storage.objects;
create policy "Authenticated can upload album photos" on storage.objects
for insert to authenticated with check (bucket_id = 'photos');

drop policy if exists "Authenticated can update album photos" on storage.objects;
create policy "Authenticated can update album photos" on storage.objects
for update to authenticated using (bucket_id = 'photos') with check (bucket_id = 'photos');

drop policy if exists "Authenticated can delete album photos" on storage.objects;
create policy "Authenticated can delete album photos" on storage.objects
for delete to authenticated using (bucket_id = 'photos');
