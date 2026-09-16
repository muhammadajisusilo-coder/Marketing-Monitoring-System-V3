# Visit Control Kendal — V4

Versi V4 memperbaiki inisialisasi Supabase agar konfigurasi public Supabase dapat diinjeksi saat runtime dari Next.js, sekaligus mempertahankan fallback ke `NEXT_PUBLIC_SUPABASE_URL` dan `NEXT_PUBLIC_SUPABASE_ANON_KEY`.

## Deploy
1. Upload seluruh isi folder ini ke repository GitHub.
2. Pastikan Vercel menggunakan repository dan branch yang benar.
3. Pastikan Environment Variables tersedia untuk Production dan Preview:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
4. Setelah perubahan Environment Variables, lakukan **Redeploy** deployment terbaru.
5. Buka URL Vercel.

## Keamanan
Publishable/anon key Supabase memang digunakan di browser. Jangan pernah menaruh `service_role` key pada environment variable `NEXT_PUBLIC_*` atau kode browser.
