# Daily Planner

Aplikasi manajemen aktivitas harian (to-do list) berbasis Flutter dengan autentikasi dan database cloud.

## Fitur
- **Autentikasi**: Sign Up, Sign In, Sign Out menggunakan Supabase Auth
- **Validasi Input**: Email & password divalidasi, pesan error ditampilkan jika gagal
- **Session Persistence**: Status login disimpan dengan SharedPreferences, tidak perlu login ulang
- **Get Started Screen**: Hanya muncul saat pertama kali install
- **CRUD Aktivitas**: Tambah aktivitas harian dengan waktu, deskripsi, dan status selesai
- **Tandai Selesai**: Checklist aktivitas yang sudah selesai
- **Navigasi & UI**: Navigasi rapi, UI sederhana dan fungsional

## Langkah Install & Build
1. Clone repo ini
2. Jalankan perintah berikut di terminal:
   ```
   flutter pub get
   flutter run
   ```
3. Ganti `YOUR_SUPABASE_URL` dan `YOUR_SUPABASE_ANON_KEY` di file `main.dart` dengan kredensial Supabase Anda

## Teknologi yang Digunakan
- **Flutter** (UI & logic)
- **Supabase** (Auth & Database)
- **SharedPreferences** (Session persistence)
- **intl** (Format tanggal & waktu)

## Dummy User untuk Uji Login
- **Email:** c14220332@john.petra.ac.id
- **Password:** audric21

> Anda bisa membuat akun baru dengan email & password sendiri, lalu konfirmasi email melalui link yang dikirim ke email Anda.

---

Jika ada kendala, silakan hubungi pengembang.
#   u a s - a m b w - c 1 4 2 2 0 3 3 2  
 