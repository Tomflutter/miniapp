# 📚 Aplikasi Manajemen Siswa (Flutter + Bloc)

Aplikasi **Manajemen Siswa** berbasis **Flutter** dengan arsitektur **Sederhana** dan **State Management Bloc**.  
Aplikasi ini mendukung login admin (dummy), pengelolaan data siswa secara lokal, dark mode global, dan simulasi notifikasi.

---

## ✨ Fitur Utama

### 🔐 Autentikasi
- Login Admin (Dummy)
- Validasi input username & password
- Penyimpanan status login menggunakan **SharedPreferences**
- Auto redirect:
  - Sudah login → Dashboard
  - Belum login → Login Page
- Logout

**Dummy Login**
Username : admin
Password : 123456



---

### 👨‍🎓 Manajemen Siswa
- Tambah data siswa
- Simpan data siswa ke **local storage**
- Tampilkan daftar siswa
- Halaman detail siswa
- Pull to refresh
- Empty state handling
- Validasi field kosong
- Pesan error yang jelas

## Data Siswa
- Nama Lengkap
- NISN
- Tanggal Lahir
- Jurusan

---

### 🌗 Dark Mode Global
- Toggle Light / Dark Mode
- State disimpan ke local storage
- Berlaku global di seluruh aplikasi

---

### 🧠 State Management
- Menggunakan **flutter_bloc**
- Bloc terpisah:
  - AuthBloc
  - StudentBloc
  - ThemeBloc
  - NotificationBloc

---

## 🗂 Struktur Folder

```text
lib/
├── core
│   ├── failure.dart
│   └── validators.dart
├── data
│   ├── auth_local_datasource.dart
│   ├── student_local_datasource.dart
│   ├── student_model.dart
│   └── theme_local_datasource.dart
├── presentation
│   ├── auth_bloc.dart
│   ├── auth_event.dart
│   ├── auth_state.dart
│   ├── register_page.dart
│   ├── auth_gate.dart
│   └── student
│       ├── student_bloc.dart
│       ├── student_event.dart
│       └── student_state.dart
├── theme
│   ├── theme_bloc.dart
│   ├── theme_event.dart
│   └── theme_state.dart
├── notification
│   ├── notification_bloc.dart
│   ├── notification_event.dart
│   └── notification_state.dart
├── login_page.dart
├── student_list_page.dart
├── student_detail_page.dart
└── main.dart

```

### 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  shared_preferences: ^2.2.2


```

### ▶️ Cara Menjalankan Aplikasi

**Clone repository**

```bash
git clone https://github.com/Tomflutter/miniapp.git
```

Masuk ke folder project
```bash
cd miniapp
```

Install dependency
```bash
flutter pub get
```

Jalankan aplikasi
```bash
flutter run
```
---
# ⚠️ Catatan

Aplikasi ini tidak menggunakan backend

Semua data disimpan secara lokal

Login hanya untuk simulasi / demo
