-- ============================================================
-- TABLA: registro_limpieza
-- Registro diario de limpieza con evidencia fotográfica
-- Ejecuta este SQL en el Editor SQL de tu proyecto Supabase:
--   https://app.supabase.com → SQL Editor → New query
-- ============================================================

CREATE TABLE IF NOT EXISTS public.registro_limpieza (
  id                BIGSERIAL     PRIMARY KEY,

  -- Campos de fecha y hora de la actividad de limpieza
  fecha             DATE          NOT NULL DEFAULT CURRENT_DATE,
  hora              TIME          NOT NULL DEFAULT CURRENT_TIME,

  -- Área donde se realizó la limpieza
  area              TEXT          NOT NULL,

  -- Grado y sección del aula
  grado             TEXT          NOT NULL,
  seccion           TEXT          NOT NULL,

  -- Docente o responsable asignado
  docente           TEXT          NOT NULL,

  -- Firma digital (nombre completo o clave del responsable)
  firma             TEXT          NOT NULL,

  -- Descripción de las tareas realizadas
  tarea_realizada   TEXT          NOT NULL,

  -- URL pública de la imagen/foto evidencia almacenada en Supabase Storage
  evidencia_url     TEXT,

  -- Metadatos adicionales del archivo de evidencia
  evidencia_nombre  TEXT,         -- nombre original del archivo
  evidencia_tipo    TEXT,         -- MIME type, e.g. image/jpeg

  -- Registro automático de creación
  created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- ============================================================
-- SEGURIDAD: Row Level Security
-- ============================================================

ALTER TABLE public.registro_limpieza ENABLE ROW LEVEL SECURITY;

-- Política: cualquier usuario anónimo puede INSERTAR un registro
CREATE POLICY "Insertar registro limpieza públicamente"
  ON public.registro_limpieza
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Política: cualquier usuario (incluso anónimo) puede VER los registros
CREATE POLICY "Leer registros de limpieza públicamente"
  ON public.registro_limpieza
  FOR SELECT
  TO anon
  USING (true);

-- Política: solo usuarios autenticados pueden ACTUALIZAR registros
CREATE POLICY "Actualizar registros de limpieza autenticado"
  ON public.registro_limpieza
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Política: solo usuarios autenticados pueden ELIMINAR registros
CREATE POLICY "Eliminar registros de limpieza autenticado"
  ON public.registro_limpieza
  FOR DELETE
  TO authenticated
  USING (true);

-- ============================================================
-- ÍNDICES para optimizar consultas frecuentes
-- ============================================================

-- Búsquedas por fecha
CREATE INDEX IF NOT EXISTS registro_limpieza_fecha_idx
  ON public.registro_limpieza (fecha DESC);

-- Búsquedas por área
CREATE INDEX IF NOT EXISTS registro_limpieza_area_idx
  ON public.registro_limpieza (area);

-- Búsquedas por docente
CREATE INDEX IF NOT EXISTS registro_limpieza_docente_idx
  ON public.registro_limpieza (docente);

-- ============================================================
-- BUCKET DE STORAGE para evidencias fotográficas
-- Ejecuta esto por separado si usas Supabase Storage:
-- ============================================================

-- Crear bucket público para las imágenes de evidencia
INSERT INTO storage.buckets (id, name, public)
VALUES ('evidencias-limpieza', 'evidencias-limpieza', true)
ON CONFLICT (id) DO NOTHING;

-- Política de storage: subida pública de imágenes
CREATE POLICY "Subida pública de evidencias"
  ON storage.objects
  FOR INSERT
  TO anon
  WITH CHECK (bucket_id = 'evidencias-limpieza');

-- Política de storage: lectura pública de imágenes
CREATE POLICY "Lectura pública de evidencias"
  ON storage.objects
  FOR SELECT
  TO anon
  USING (bucket_id = 'evidencias-limpieza');

-- ============================================================
-- MIGRACIÓN: Si la tabla YA EXISTE, ejecuta solo estas líneas
-- para añadir las nuevas columnas grado y seccion:
-- ============================================================

/*
ALTER TABLE public.registro_limpieza
  ADD COLUMN IF NOT EXISTS grado   TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS seccion TEXT NOT NULL DEFAULT '';
*/

-- ============================================================
-- DATOS DE EJEMPLO (opcional – eliminar en producción)
-- ============================================================

/*
INSERT INTO public.registro_limpieza
  (fecha, hora, area, grado, seccion, docente, firma, tarea_realizada, evidencia_url, evidencia_nombre, evidencia_tipo)
VALUES
  (
    CURRENT_DATE,
    '08:00:00',
    'Aula 101',
    '2°',
    'A',
    'Prof. María López',
    'Maria Lopez',
    'Barrido y trapeado del piso, limpieza de pizarras y escritorios.',
    'https://<project>.supabase.co/storage/v1/object/public/evidencias-limpieza/aula101_2026-03-07.jpg',
    'aula101_2026-03-07.jpg',
    'image/jpeg'
  );
*/
