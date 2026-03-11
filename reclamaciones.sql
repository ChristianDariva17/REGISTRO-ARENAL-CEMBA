-- ================================================================
-- Tabla: reclamaciones
-- Libro de Reclamaciones (Complaints Book)
-- Ejecutar en el SQL Editor de Supabase
-- ================================================================

create table if not exists public.reclamaciones (
  id         bigserial    primary key,
  created_at timestamptz  default now() not null,

  -- Sección 0: Fecha
  fecha      date         not null,

  -- Sección 1: Identificación del consumidor
  nombre     text         not null,
  dni        text         not null,
  telefono   text         not null,

  -- Sección 2: Tipo de bien reclamado
  tipo       text         not null check (tipo in ('producto', 'servicio')),
  desc_bien  text,

  -- Sección 3: Detalle de la reclamación
  subtipo    text         not null check (subtipo in ('reclamo', 'queja')),
  detalle    text         not null,

  -- Sección 4: Pedido del consumidor
  pedido     text,

  -- Firma manuscrita (base64 data URL PNG)
  firma      text
);

-- Habilitar Row Level Security
alter table public.reclamaciones enable row level security;

-- Permitir inserciones anónimas (formulario público)
create policy "Insertar reclamaciones públicamente"
  on public.reclamaciones
  for insert
  with check (true);

-- Solo roles autenticados pueden leer
create policy "Leer reclamaciones autenticados"
  on public.reclamaciones
  for select
  using (auth.role() = 'authenticated');

-- ================================================================
-- Si la tabla YA EXISTE y necesitas aplicar los cambios,
-- usa las siguientes sentencias ALTER TABLE en su lugar:
-- ================================================================
-- alter table public.reclamaciones drop column if exists numero_queja;
-- alter table public.reclamaciones drop column if exists titulo_institucion;
-- alter table public.reclamaciones drop column if exists domicilio;
-- alter table public.reclamaciones drop column if exists email;
-- alter table public.reclamaciones add column if not exists firma text;
