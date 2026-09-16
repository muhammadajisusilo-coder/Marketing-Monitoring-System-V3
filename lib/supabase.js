import { createBrowserClient } from '@supabase/ssr'

export function getSupabase(){
  if(typeof window==='undefined') return null
  const runtime=window.__SUPABASE_CONFIG__||{}
  const url=runtime.url||process.env.NEXT_PUBLIC_SUPABASE_URL
  const key=runtime.key||process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
  if(!url||!key) return null
  return createBrowserClient(url,key)
}

export function getSupabaseConfigStatus(){
  if(typeof window==='undefined') return {url:false,key:false}
  const runtime=window.__SUPABASE_CONFIG__||{}
  return {
    url:Boolean(runtime.url||process.env.NEXT_PUBLIC_SUPABASE_URL),
    key:Boolean(runtime.key||process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY),
    host:runtime.url?new URL(runtime.url).host:''
  }
}
