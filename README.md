# Visit Control Kendal V5

Versi ini mengganti client Supabase browser dari `@supabase/ssr` menjadi `@supabase/supabase-js` langsung dan mendukung dua nama key:
- NEXT_PUBLIC_SUPABASE_ANON_KEY
- NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY

Tambahan endpoint `/api/config` hanya menampilkan status keberadaan konfigurasi (bukan nilai key penuh).

Vercel Environment Variables yang diperlukan:
- NEXT_PUBLIC_SUPABASE_URL
- NEXT_PUBLIC_SUPABASE_ANON_KEY (isi Publishable Key Supabase)

Setelah commit, lakukan Redeploy Production. Jangan rotate/unlink variable.
