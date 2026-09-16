import './globals.css';
export const metadata={title:'Visit Control — WOM Finance Kendal',description:'Kontrol aktivitas visit tim'};
export default function RootLayout({children}){
  const config={
    url:process.env.NEXT_PUBLIC_SUPABASE_URL||'',
    key:process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY||process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY||''
  };
  const safe=JSON.stringify(config).replace(/</g,'\\u003c');
  return <html lang="id"><body><script dangerouslySetInnerHTML={{__html:`window.__SUPABASE_CONFIG__=${safe};`}} />{children}</body></html>
}
