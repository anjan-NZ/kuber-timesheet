import { createClient } from '@supabase/supabase-js';

// Client-side Supabase client (for browser)
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://zhrsneyyczjhyastjvbq.supabase.co';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

export const supabaseClient = supabaseUrl && supabaseAnonKey ? createClient(
  supabaseUrl,
  supabaseAnonKey,
  {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true,
    },
  }
) : null;

// Server-side Supabase client factory (for API routes)
export function createServerSupabaseClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://zhrsneyyczjhyastjvbq.supabase.co';
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
  
  if (!url || !key) return null;
  
  return createClient(
    url,
    key,
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    }
  );
}

// Export types
export type SupabaseClient = ReturnType<typeof createClient>;
