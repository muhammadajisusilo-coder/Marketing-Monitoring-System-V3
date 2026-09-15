# Visit Control Kendal v2

Versi ini mengubah sistem menjadi monitoring berbasis login Google + Supabase.

## Fitur
- Login Google.
- Dashboard tanpa form input visit.
- Status `Bertemu` / `Tidak Bertemu` diperbarui admin melalui Excel/CSV.
- Admin dapat upload spreadsheet dan upsert berdasarkan `NO KONTRAK`.
- Admin dapat mengatur daftar email Google yang menjadi admin.
- Nomor telepon tidak ditampilkan di dashboard pengguna.

## Setup
1. Buat project Supabase.
2. Jalankan `supabase-schema.sql` di SQL Editor.
3. Di Supabase Authentication > Providers > Google, aktifkan Google OAuth dan masukkan Client ID/Secret dari Google Cloud.
4. Set URL callback/redirect sesuai URL Supabase yang diberikan pada halaman provider.
5. Di Vercel tambahkan:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
6. Deploy ulang.
7. Login pertama dengan akun yang akan menjadi admin. Tambahkan email tersebut ke tabel `admin_emails` melalui SQL Editor, contoh:
   `insert into public.admin_emails(email) values ('admin@gmail.com');`
8. Setelah masuk sebagai admin, menu Admin dapat dipakai untuk menambah/menghapus email admin.

### Format spreadsheet
Kolom utama yang dibaca:
- `NO KONTRAK`
- `NAMA KONSUMEN`
- `DATA PRIORITY`
- `PA`
- `ALAMAT`
- `KELURAHAN`
- `KECAMATAN`
- `GOOGLE MAP`
- `RATING`
- `CEK VISIT` atau `STATUS VISIT`

Nilai status yang dikenali antara lain `Bertemu`, `Tidak Bertemu`, `Sudah Visit`, `Tidak Ditemui`, `Ya`, `Tidak`.
