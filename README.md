<<<<<<< HEAD
# tefa

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# AdminKasir
projek aplikasi admin dan kasir untuk toko
# TEFA Toko — Mobile App

Aplikasi mobile **TEFA Toko** berbasis Flutter yang digunakan untuk membantu pengelolaan toko, khususnya dalam **manajemen barang, stok, harga, diskon, transaksi penjualan, dan laporan**.

Aplikasi memiliki dua role utama:

* **Admin** — mengelola seluruh data toko
* **Kasir** — melakukan transaksi penjualan kepada pelanggan

Aplikasi menggunakan **dummy/local data** terlebih dahulu sehingga dapat langsung dijalankan dan dikembangkan lebih lanjut untuk menggunakan REST API, Firebase, atau database lainnya.

---

## Fitur Utama

### Admin

Admin memiliki akses penuh terhadap sistem toko.

* Dashboard toko
* Melihat data barang
* Menambahkan barang
* Mengedit barang
* Menghapus barang
* Menambahkan stok barang
* Mengurangi stok barang
* Mengatur harga barang
* Mengatur diskon
* Melihat barang masuk
* Melihat barang keluar
* Melihat data penjualan
* Melihat statistik penjualan
* Melihat laporan stok
* Melihat notifikasi
* Mengelola profil
* Dark Mode / Light Mode

### Kasir

Kasir memiliki akses yang berfokus pada proses penjualan.

* Dashboard kasir
* Melihat daftar barang
* Search barang
* Filter barang
* Sorting barang
* Melihat harga barang
* Melihat diskon barang
* Menambahkan barang ke keranjang
* Membuat transaksi
* Menghitung total pembayaran
* Menghitung kembalian
* Melihat riwayat transaksi
* Mengelola profil
* Dark Mode / Light Mode

> Kasir tidak memiliki izin untuk mengubah harga, diskon, stok, atau data barang.

---

# Sistem Role

Aplikasi menggunakan **Role-Based Access Control (RBAC)**.

Terdapat dua role:

```text
admin
kasir
```

### Admin

```text
Dashboard
Barang
Stok
Harga
Diskon
Penjualan
Laporan
Notifikasi
Profile
Settings
```

### Kasir

```text
Dashboard
Barang
Transaksi
Riwayat Transaksi
Profile
Settings
```

Kasir tidak dapat mengakses halaman atau fitur khusus Admin.

---

# Akun Demo

Gunakan akun berikut untuk mencoba aplikasi.

### Admin

```text
Email    : admin@gmail.com
Password : admin123
```

### Kasir

```text
Email    : kasir@gmail.com
Password : kasir123
```

---

# Alur Transaksi

Proses penjualan dilakukan oleh Kasir.

```text
Kasir Login
     |
     v
Pilih Barang
     |
     v
Masukkan Jumlah
     |
     v
Tambah ke Keranjang
     |
     v
Periksa Keranjang
     |
     v
Sistem Menghitung Total
     |
     v
Masukkan Pembayaran
     |
     v
Sistem Menghitung Kembalian
     |
     v
Konfirmasi Transaksi
     |
     v
Transaksi Berhasil
     |
     v
Stok Otomatis Berkurang
     |
     v
Dashboard Admin Diperbarui
```

### Contoh

Stok awal:

```text
Roti Cokelat = 50
```

Kasir menjual:

```text
Roti Cokelat = 4
```

Maka sistem otomatis mengubah stok menjadi:

```text
50 - 4 = 46
```

Admin dapat langsung melihat perubahan stok tersebut.

---

# Manajemen Stok

Admin dapat melakukan dua jenis perubahan stok.

## Barang Masuk

Digunakan ketika toko menerima stok baru.

```text
Stok Awal    : 20
Barang Masuk : +30
Stok Akhir   : 50
```

Rumus:

```text
Stok Akhir = Stok Awal + Barang Masuk
```

## Barang Keluar

Barang keluar dapat berasal dari:

* Penjualan
* Barang rusak
* Barang hilang
* Barang kedaluwarsa
* Koreksi stok
* Pengurangan manual oleh Admin

Rumus:

```text
Stok Akhir = Stok Awal - Barang Keluar
```

Sistem tidak mengizinkan stok menjadi nilai negatif.

---

# Harga dan Diskon

Admin dapat menentukan harga jual dan diskon barang.

Contoh:

```text
Harga Normal : Rp10.000
Diskon       : 10%
Potongan     : Rp1.000
Harga Akhir  : Rp9.000
```

Rumus:

```text
Potongan = Harga × Diskon / 100

Harga Akhir = Harga - Potongan
```

Kasir hanya dapat melihat informasi harga dan diskon.

Kasir **tidak dapat mengubahnya**.

---

# Dashboard Admin

Dashboard Admin menampilkan informasi penting mengenai kondisi toko.

Contoh statistik:

```text
Total Barang
Total Stok
Barang Stok Menipis
Penjualan Hari Ini
Transaksi Hari Ini
Total Pendapatan
```

Dashboard juga menampilkan:

* Grafik penjualan
* Barang terbaru
* Barang stok menipis
* Transaksi terbaru
* Barang paling banyak terjual
* Quick Actions

---

# Dashboard Kasir

Dashboard Kasir dibuat lebih sederhana dan fokus terhadap transaksi.

Menampilkan:

* Jumlah barang tersedia
* Jumlah transaksi hari ini
* Total transaksi hari ini
* Barang dengan stok menipis
* Transaksi terbaru

Quick Action:

```text
Mulai Transaksi
Lihat Barang
Riwayat Transaksi
```

---

# Struktur Project

Project menggunakan struktur modular agar mudah dikembangkan.

```text
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── theme_provider.dart
│   │
│   ├── routes/
│   │   └── app_routes.dart
│   │
│   └── constants/
│       └── app_constants.dart
│
├── models/
│   ├── user_model.dart
│   ├── product_model.dart
│   ├── transaction_model.dart
│   ├── stock_model.dart
│   └── notification_model.dart
│
├── services/
│   ├── auth_service.dart
│   ├── product_service.dart
│   ├── transaction_service.dart
│   └── local_storage_service.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── product_provider.dart
│   ├── transaction_provider.dart
│   └── theme_provider.dart
│
├── widgets/
│   ├── app_card.dart
│   ├── app_button.dart
│   ├── app_text_field.dart
│   ├── product_card.dart
│   ├── statistic_card.dart
│   ├── transaction_card.dart
│   ├── stock_badge.dart
│   └── empty_state.dart
│
├── screens/
│   ├── auth/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   └── forgot_password_screen.dart
│   │
│   ├── admin/
│   │   ├── admin_dashboard_screen.dart
│   │   ├── product_management_screen.dart
│   │   ├── product_form_screen.dart
│   │   ├── stock_management_screen.dart
│   │   ├── sales_report_screen.dart
│   │   ├── transaction_detail_screen.dart
│   │   ├── discount_screen.dart
│   │   ├── admin_profile_screen.dart
│   │   └── admin_settings_screen.dart
│   │
│   └── cashier/
│       ├── cashier_dashboard_screen.dart
│       ├── cashier_product_screen.dart
│       ├── cart_screen.dart
│       ├── checkout_screen.dart
│       ├── transaction_history_screen.dart
│       ├── transaction_detail_screen.dart
│       ├── cashier_profile_screen.dart
│       └── cashier_settings_screen.dart
│
└── utils/
    ├── validators.dart
    ├── currency_formatter.dart
    └── date_formatter.dart
```

---

# Teknologi yang Digunakan

| Teknologi          | Keterangan                     |
| ------------------ | ------------------------------ |
| Flutter            | Framework aplikasi mobile      |
| Dart               | Bahasa pemrograman             |
| Material 3         | Sistem desain UI               |
| Provider           | State management               |
| Shared Preferences | Penyimpanan data/session lokal |
| Intl               | Format mata uang dan tanggal   |
| UUID               | ID unik data                   |
| FL Chart           | Grafik statistik               |
| Image Picker       | Pemilihan foto profil          |

---

# Dependency

Tambahkan dependency berikut ke `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8

  provider: ^6.1.5+1
  shared_preferences: ^2.5.3
  intl: ^0.20.2
  uuid: ^4.5.1
  fl_chart: ^1.0.0
  image_picker: ^1.1.2
```

Setelah itu jalankan:

```bash
flutter pub get
```

---

# Cara Menjalankan Project

## 1. Pastikan Flutter Sudah Terinstall

Periksa dengan:

```bash
flutter doctor
```

Pastikan tidak terdapat masalah yang menghalangi proses development.

## 2. Clone Repository

```bash
git clone [URL_REPOSITORY]
```

Masuk ke folder project:

```bash
cd tefa_toko
```

## 3. Install Dependency

```bash
flutter pub get
```

## 4. Jalankan Aplikasi

Untuk melihat device yang tersedia:

```bash
flutter devices
```

Kemudian jalankan:

```bash
flutter run
```

---

# Design System

Aplikasi menggunakan prinsip desain:

* Material 3
* Clean UI
* Modern
* Minimalis
* Responsive
* Rounded corners
* Soft shadow
* Consistent spacing
* Consistent typography
* Dark Mode
* Light Mode

Warna utama digunakan secara konsisten pada seluruh aplikasi.

Status warna digunakan untuk membedakan kondisi:

```text
Success → Transaksi berhasil
Warning → Stok menipis
Error   → Kesalahan / stok tidak cukup
Info    → Informasi
```

---

# Sample Data

Aplikasi menyediakan beberapa data contoh agar dashboard tidak kosong.

Contoh barang:

| Barang           | Kategori |   Harga | Diskon | Stok |
| ---------------- | -------- | ------: | -----: | ---: |
| Indomie Goreng   | Makanan  | Rp3.500 |     0% |   50 |
| Roti Cokelat     | Makanan  | Rp7.000 |    10% |   35 |
| Teh Botol        | Minuman  | Rp5.000 |     5% |   40 |
| Air Mineral      | Minuman  | Rp3.000 |     0% |   75 |
| Keripik Singkong | Snack    | Rp8.000 |    10% |   25 |

Sample transaksi juga disediakan untuk menampilkan data pada:

* Dashboard
* Riwayat transaksi
* Laporan penjualan
* Statistik
* Aktivitas terbaru

---

# Keamanan dan Akses Role

Aplikasi menerapkan pembatasan akses berdasarkan role.

```text
Belum Login
    |
    v
Login Screen
    |
    v
Validasi Akun
    |
    v
Cek Role
    |
    +---- Admin ----> Admin Dashboard
    |
    +---- Kasir ----> Kasir Dashboard
```

Apabila Kasir mencoba membuka halaman Admin:

```text
Access Denied

Anda tidak memiliki akses
ke halaman ini.
```

Kemudian pengguna diarahkan kembali ke halaman yang sesuai dengan rolenya.

> Role-based access pada versi local/dummy ini merupakan simulasi. Saat aplikasi terhubung ke backend, validasi role juga harus dilakukan di server/API.

---

# Pengembangan Selanjutnya

Aplikasi dirancang agar dapat dikembangkan menjadi sistem production.

Pengembangan berikutnya dapat mencakup:

* REST API
* MySQL / PostgreSQL
* Firebase
* Backend Laravel
* Authentication berbasis server
* Cloud database
* Sinkronisasi stok secara realtime
* Printer struk
* Cetak laporan
* Export PDF
* Export Excel
* Barcode scanner
* QR Code
* Manajemen supplier
* Manajemen kategori
* Multi-cabang toko
* Backup database

---

# Tujuan Project

Project ini dibuat untuk membantu proses operasional **TEFA Toko**, terutama dalam:

* Pengelolaan barang
* Pengelolaan stok
* Pengaturan harga
* Pengaturan diskon
* Transaksi penjualan
* Pemantauan stok
* Pemantauan penjualan
* Pembuatan laporan

Dengan adanya aplikasi ini, proses yang sebelumnya dilakukan secara manual dapat dilakukan secara lebih **terstruktur, cepat, dan mudah dipantau**.

---

# Developer

**Alfin Dzaky Mumtazam**

Project:

**TEFA Toko — Admin & Kasir Mobile Application**

Teknologi:

**Flutter + Dart**

---

# License

Project ini dibuat untuk keperluan **pembelajaran dan project TEFA**.

© 2026 Alfin Dzaky Mumtazam. All rights reserved.
>>>>>>> d67d6a0cf2717bd3a04eb40ac35abff00fb04697
