import { createClient } from '@supabase/supabase-js'

function readConfig(){
  if(typeof window==='undefined') return {url:'',key:''}
  const runtime=window.__SUPABASE_CONFIG__||{}
  const url=(runtime.url||process.env.NEXT_PUBLIC_SUPABASE_URL||'').trim()
  const key=(runtime.key||process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY||process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY||'').trim()
  return {url,key}
}

export function getSupabase(){
  const {url,key}=readConfig()
  if(!url||!key) return null
  return createClient(url,key,{auth:{persistSession:true,autoRefreshToken:true,detectSessionInUrl:true}})
}

export function getSupabaseConfigStatus(){
  const {url,key}=readConfig()
  let host=''
  let validUrl=false
  try { const u=new URL(url); host=u.host; validUrl=/\.supabase\.co$/.test(u.host); } catch {}
  return {url:Boolean(url),key:Boolean(key),host,keyPrefix:key.slice(0,16),validUrl}
}
