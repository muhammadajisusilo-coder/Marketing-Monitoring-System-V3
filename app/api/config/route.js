import { NextResponse } from 'next/server'
export const dynamic = 'force-dynamic'
export async function GET(){
  const url=(process.env.NEXT_PUBLIC_SUPABASE_URL||'').trim()
  const key=(process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY||process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY||'').trim()
  let host=''
  try{host=new URL(url).host}catch{}
  return NextResponse.json({urlPresent:!!url,keyPresent:!!key,host,keyPrefix:key.slice(0,16)})
}
