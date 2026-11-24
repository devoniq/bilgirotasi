-- Bilgi Rotası: öğretmen soruları için Supabase kurulumu
-- Öğrenciler soruları giriş yapmadan okur; yalnızca "ogretmenler" tablosundaki
-- e-posta adresleriyle giriş yapan öğretmenler soru ekleyip silebilir.

create table if not exists public.ogretmenler (
  email text primary key,
  eklenme timestamptz not null default now()
);

create table if not exists public.sorular (
  id uuid primary key default gen_random_uuid(),
  lvl text not null check (lvl in ('ilk','orta','lise')),
  cat text not null check (cat in ('cog','tarih','fen','mat','spor','sanat','gk')),
  q text not null check (char_length(q) between 3 and 300),
  a text not null check (char_length(a) between 1 and 120),
  w text[] not null check (array_length(w, 1) = 3),
  e text not null default '' check (char_length(e) <= 400),
  ekleyen text default (auth.jwt() ->> 'email'),
  eklenme timestamptz not null default now()
);

-- Giriş yapan kişi öğretmen listesinde mi?
create or replace function public.ogretmen_mi()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.ogretmenler
    where lower(email) = lower(auth.jwt() ->> 'email')
  );
$$;

alter table public.ogretmenler enable row level security;
alter table public.sorular enable row level security;

-- Öğretmen listesi dışarıdan okunamaz ve değiştirilemez (yalnızca Supabase paneli / SQL).
-- Sorular: herkes okur, yalnızca öğretmenler ekler ve siler.
drop policy if exists "herkes okur" on public.sorular;
create policy "herkes okur" on public.sorular
  for select to anon, authenticated using (true);

drop policy if exists "ogretmen ekler" on public.sorular;
create policy "ogretmen ekler" on public.sorular
  for insert to authenticated with check (public.ogretmen_mi());

drop policy if exists "ogretmen siler" on public.sorular;
create policy "ogretmen siler" on public.sorular
  for delete to authenticated using (public.ogretmen_mi());

grant execute on function public.ogretmen_mi() to authenticated;

-- Veri API erişimi (proje "yeni tablolara otomatik erişim" kapalı açıldığı için açıkça veriliyor)
grant usage on schema public to anon, authenticated;
grant select on public.sorular to anon, authenticated;
grant insert, delete on public.sorular to authenticated;
revoke all on public.ogretmenler from anon, authenticated;

-- Öğretmen eklemek için (e-postayı değiştirin):
-- insert into public.ogretmenler (email) values ('ogretmen@okul.k12.tr');
