# Visit Control — WOM Finance Kendal

Web app Next.js untuk monitoring aktivitas visit tim menggunakan data sheet **DATA VISIT** dari file September 2026.

## Jalankan lokal
1. Install Node.js 18+.
2. Jalankan `npm install`.
3. Jalankan `npm run dev`.
4. Buka `http://localhost:3000`.

## Deploy ke Vercel
1. Buat repository baru di GitHub, misalnya `visit-control-kendal`.
2. Upload seluruh isi folder project ini ke repository.
3. Masuk Vercel dan pilih **Add New Project** → pilih repository tersebut.
4. Framework akan terdeteksi sebagai Next.js. Klik **Deploy**.

## Catatan MVP
Status visit disimpan di browser (localStorage), sehingga belum tersinkron antar HP/petugas. Untuk penggunaan tim multi-user, tahap berikutnya sebaiknya memakai Supabase/PostgreSQL + login per petugas agar data visit tersimpan terpusat.

Fitur saat ini: pencarian/filter customer, dashboard statistik, form hasil visit, timestamp, geolocation browser, tautan Google Maps, dan status visit.
