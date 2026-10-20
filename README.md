# FinFlow 💸
> **Modern Personal Finance & Category Budgeting App for Android (Flutter)**

FinFlow adalah aplikasi pencatatan keuangan pribadi dan pemantauan anggaran harian modern berbasis Flutter. Dibuat dengan arsitektur **Feature-First Clean Architecture**, **State Management Riverpod**, dan siap integrasi **Firebase Cloud Sync**.

---

## ✨ Fitur Utama

1. **Dashboard Finansial Modern**:
   - Saldo bersih (*Net Balance*) otomatis dihitung dari mutasi.
   - Kartu ringkasan Pemasukan & Pengeluaran bulan berjalan.
   - Status anggaran tercepat (*Budget Overview*) langsung di halaman depan.
   - Mutasi 5 transaksi terkini.

2. **Sistem Budgeting & Peringatan Limit**:
   - Penetapan limit nominal bulanan per kategori belanja (misal: Makan Rp 1.500.000, Transport Rp 600.000).
   - Visual progress bar real-time:
     - 🟢 **Aman**: Pengeluaran masih di bawah 80%.
     - 🟡 **Mendekati Limit**: Pengeluaran telah mencapai 80% - 99%.
     - 🔴 **Overbudget!**: Pengeluaran telah melampaui batas pagu (>= 100%).

3. **Pencatatan Transaksi Cepat**:
   - Pilihan kategori lengkap dengan ikon dan aksen warna khusus.
   - Pemilihan dompet/rekening sumber dana (BCA, Mandiri, GoPay, OVO, Cash).
   - Format nominal Rupiah (IDR) otomatis.

4. **Riwayat & Filter Mutasi**:
   - Filter cepat berdasarkan: Semua / Pengeluaran / Pemasukan.
   - Geser untuk menghapus (*Swipe to dismiss*) dengan dialog konfirmasi.

5. **Cloud Sync & Demo Mode**:
   - Sudah terstruktur untuk Firebase Auth & Cloud Firestore.
   - **Offline/Demo Mode siap pakai**: Aplikasi dapat langsung dijalankan dan dicoba tanpa crash meskipun Firebase belum dikonfigurasi.

---

## 🚀 Panduan Menjalankan Proyek di Windows

Karena Flutter SDK belum terdeteksi di PATH komputer ini, ikuti langkah mudah berikut:

### Langkah 1: Unduh & Pasang Flutter SDK
1. Kunjungi situs resmi: [https://docs.flutter.dev/get-started/install/windows/mobile](https://docs.flutter.dev/get-started/install/windows/mobile)
2. Unduh file zip Flutter SDK (misal: `flutter_windows_3.x.x-stable.zip`).
3. Ekstrak file zip ke folder aman, disarankan: `C:\src\flutter` *(Jangan ekstrak di `Program Files`)*.

### Langkah 2: Daftarkan ke System Environment PATH
1. Di keyboard, tekan tombol `Windows` lalu ketik **"env"**, pilih **"Edit the system environment variables"** (Ubah variabel lingkungan sistem).
2. Klik tombol **Environment Variables...** di kanan bawah.
3. Di bagian **User variables** atau **System variables**, cari baris bernama `Path`, lalu klik **Edit**.
4. Klik **New**, lalu masukkan lokasi folder bin Flutter:
   ```text
   C:\src\flutter\bin
   ```
5. Klik **OK** pada semua jendela. Buka terminal/PowerShell baru dan uji:
   ```bash
   flutter --version
   ```

### Langkah 3: Pasang Android Studio & Emulator
1. Unduh dan instal [Android Studio](https://developer.android.com/studio).
2. Buka Android Studio, masuk ke **Virtual Device Manager** (Device Manager), lalu buat satu emulator Android (misal: Pixel 7 dengan Google Play).
3. Jalankan perintah dokter di terminal:
   ```bash
   flutter doctor
   ```
   Pastikan ceklis hijau pada Android toolchain.

### Langkah 4: Menjalankan FinFlow
Buka terminal di dalam folder proyek ini (`c:\Users\deez\Documents\New folder`):

```bash
# 1. Unduh semua dependensi paket
flutter pub get

# 2. Jalankan aplikasi pada emulator atau HP Android fisik
flutter run
```

---

## ☁️ Menghubungkan ke Firebase Pribadi (Opsional)

Jika ingin mengaktifkan sinkronisasi cloud real-time Firebase:
1. Buat proyek baru di [Firebase Console](https://console.firebase.google.com/).
2. Aktifkan **Authentication** (Metode Email/Password & Google).
3. Buat database **Cloud Firestore** dalam test mode.
4. Di terminal proyek, jalankan:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   CLI akan otomatis men-generate file konfigurasi `google-services.json` ke dalam `android/app/`.

---

## 📁 Struktur Direktori Kode

```text
lib/
├── core/
│   ├── constants/app_colors.dart    # Palet warna Modern FinTech
│   ├── theme/app_theme.dart          # Tema Gelap Material 3 & Font Plus Jakarta Sans
│   └── utils/currency_formatter.dart # Format mata uang Rupiah (IDR)
├── features/
│   ├── auth/                         # Login & Session State
│   ├── dashboard/                    # Beranda utama, Balance Card, Navigasi
│   ├── transactions/                 # Input mutasi, Kategori, Riwayat
│   └── budgets/                      # Alokasi limit pagu & kalkulasi status limit
└── main.dart                         # Entrypoint & Inisialisasi Riverpod
```
