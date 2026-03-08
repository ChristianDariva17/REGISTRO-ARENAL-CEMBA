import { createClient } from '@supabase/supabase-js'

// Las variables de entorno deben estar en tu archivo .env
// (copia .env.example a .env y agrega tus credenciales reales)
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  console.warn(
    '⚠️ Supabase no configurado. Copia .env.example a .env y agrega tus credenciales.'
  )
}

export const supabase = createClient(
  supabaseUrl || 'https://placeholder.supabase.co',
  supabaseAnonKey || 'placeholder-key'
)
