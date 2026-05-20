# History Vault

Aplikasi mobile yang memungkinkan pengguna menjelajahi peristiwa sejarah dari seluruh dunia dengan antarmuka modern dan intuitif.

---

## Deskripsi Aplikasi

**History Vault** adalah aplikasi Flutter yang dirancang untuk memberikan pengalaman belajar sejarah yang menyenangkan dan interaktif. Aplikasi ini mengintegrasikan data dari Wikipedia API untuk menyediakan informasi sejarah yang akurat dan terkini. Dengan desain UI modern dan minimalis, pengguna dapat dengan mudah menemukan, membaca, dan menyimpan artikel sejarah yang menarik.

### Fitur Utama:
- **Hari Ini dalam Sejarah**: Tampilkan peristiwa sejarah yang terjadi pada hari ini
- **Artikel Acak**: Jelajahi artikel Wikipedia secara acak dengan sekali klik
- **Pencarian Canggih**: Cari artikel sejarah berdasarkan kata kunci
- **Timeline Explorer**: Jelajahi peristiwa sejarah berdasarkan tahun
- **Favorit**: Simpan artikel favorit untuk dibaca kemudian
- **Filter Kategori**: Filter peristiwa berdasarkan kategori (Tempat, Orang, Penemuan, Peristiwa)
- **Desain Responsif**: Interface yang indah dan user-friendly di semua ukuran layar

---

## Alur Pengguna (User Flow)

### 1. **Onboarding & Home Screen**
```
Pengguna Membuka Aplikasi
         ↓
   Halaman Beranda (Home Screen)
         ↓
   Tampil: Peristiwa "Hari Ini dalam Sejarah"
         ↓
   Pilihan User:
   ├─→ Klik Event → Detail Screen
   ├─→ Filter Kategori (All/Place/Person/Discovery/Event)
   ├─→ Navigasi ke Menu Lain (Bottom Navigation)
   └─→ Klik Random FAB → Artikel Acak
```

### 2. **Home Screen - Peristiwa Hari Ini**
- Menampilkan daftar peristiwa sejarah yang terjadi pada hari yang sama (bulan dan tanggal) tetapi di tahun berbeda
- Setiap event card menampilkan:
  - **Tahun**: Badge di kiri atas dengan background gelap
  - **Judul Event**: Nama peristiwa sejarah
  - **Deskripsi**: Ringkasan singkat peristiwa
  - **Thumbnail**: Gambar representatif jika tersedia
  - **Tombol Favorit**: Simpan ke daftar favorit

**Filter Kategori:**
- **All**: Tampilkan semua event
- **Place**: Event terkait tempat/lokasi geografis
- **Person**: Event terkait tokoh/orang terkenal
- **Discovery**: Event penemuan dan inovasi
- **Event**: Peristiwa penting lainnya

Sistem kategorisasi otomatis mendeteksi kategori berdasarkan keyword dalam judul dan deskripsi event.

### 3. **Detail Screen - Baca Artikel Lengkap**
```
User Klik pada Event/Search Result/Random Article
         ↓
   Detail Screen Membuka
         ↓
   Konten dimuat:
   ├─→ Judul Artikel
   ├─→ Thumbnail/Gambar
   ├─→ Extract (Ringkasan)
   ├─→ Tombol "Baca Lengkap" (Buka di Wikipedia)
   └─→ AppBar dengan Tombol Favorit
   
   Pilihan User:
   ├─→ Klik "Favorit" → Simpan artikel
   ├─→ Klik "Random" (Extended FAB) → Load artikel acak baru
   └─→ Klik "Baca Lengkap" → Buka di Wikipedia (External App)
```

**Fitur Detail Screen:**
- Menampilkan konten lengkap dengan loading state
- Tombol untuk membuka artikel di Wikipedia
- Tombol untuk menambah/menghapus dari favorit
- Extended FAB untuk mendapatkan artikel acak baru
- Handling error dengan UI yang user-friendly

### 4. **Search Screen - Cari Artikel**
```
User Tap "Search" Tab
         ↓
   Search Screen
         ↓
   User Ketik Query Pencarian
         ↓
   Sistem Mencari & Menampilkan Suggestions (Debounced)
         ↓
   User Pilih dari Suggestions / Tekan Search
         ↓
   Tampil Hasil Pencarian
         ↓
   User Klik Hasil → Detail Screen
```

**Fitur Pencarian:**
- Real-time search suggestions dengan delay debounce 400ms
- Menampilkan hasil relevan dari Wikipedia
- Filter chips untuk saran popular
- Loading indicator selama proses pencarian
- Empty state jika tidak ada hasil

### 5. **Timeline Screen - Jelajahi Berdasarkan Tahun**
```
User Tap "Timeline" Tab
         ↓
   Timeline Explorer
         ↓
   Input Tahun (Rentang Tahun Tertentu)
         ↓
   Sistem Mencari Event pada Tahun Tersebut
         ↓
   Tampil Daftar Event Tahun Tersebut
         ↓
   User Klik Event → Detail Screen
```

**Fitur Timeline:**
- Cari peristiwa berdasarkan tahun atau rentang tahun
- Tampilkan events dalam urutan kronologis
- Quick access ke tahun tertentu
- Card preview dengan informasi event

### 6. **Favorites Screen - Artikel Tersimpan**
```
User Tap "Favorites" Tab
         ↓
   Favorites Screen
         ↓
   Tampil: Daftar Artikel yang Disimpan
         ↓
   Pilihan User:
   ├─→ Klik Artikel → Detail Screen
   ├─→ Swipe/Hapus → Hapus dari Favorit
   └─→ Berbagi Artikel
```

**Fitur Favorit:**
- Menyimpan artikel favorit menggunakan SharedPreferences (local storage)
- Menampilkan daftar semua artikel yang disimpan
- Menghapus artikel dari favorit
- Sinkronisasi data lokal dengan provider

---

## Cara Kerja Teknis

### Arsitektur Aplikasi

```
┌─────────────────────────────────────────────────────────────┐
│                        Flutter App                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐          ┌──────────────────────────┐ │
│  │   Screens        │          │     Widgets              │ │
│  │ ─────────────    │          │ ─────────────────────    │ │
│  │ • Home           │          │ • EventCard              │ │
│  │ • Detail         │          │ • ArticleCard            │ │
│  │ • Search         │          │ • RandomFAB              │ │
│  │ • Timeline       │          │ • EmptyState             │ │
│  │ • Favorites      │          └──────────────────────────┘ │
│  └────────┬─────────┘                                       │
│           │                                                  │
│           └─────────────┬──────────────────┬────────┐       │
│                         │                  │        │       │
│  ┌──────────────────────▼──────────────────▼───┐    │       │
│  │           Provider (State Management)       │    │       │
│  │ ──────────────────────────────────────────  │    │       │
│  │ • FavoritesProvider (Favorit)               │    │       │
│  │ • HistoryProvider (Home/Timeline Events)    │    │       │
│  │ • SearchProvider (Pencarian)                │    │       │
│  │ • RandomProvider (Artikel Acak)             │    │       │
│  └──────────────────────┬──────────────────────┘    │       │
│                         │                           │       │
│  ┌──────────────────────▼────────────────────────┐  │       │
│  │         Wikipedia Service (API)               │  │       │
│  │ ────────────────────────────────────────────  │  │       │
│  │ • fetchOnThisDay()  → GET /feed/onthisday    │  │       │
│  │ • searchArticles()  → POST /w/api.php         │  │       │
│  │ • fetchPageSummary() → GET /page/summary     │  │       │
│  │ • fetchRandomArticle() → GET /page/random    │  │       │
│  └──────────────────────┬──────────────────────┘  │       │
│                         │                          │       │
│                  ┌──────▼──────┐                   │       │
│                  │ HTTP Client  │                  │       │
│                  │              │                  │       │
│                  └──────┬───────┘                  │       │
│                         │                         │       │
│              ┌──────────▼──────────┐              │       │
│              │ Wikipedia REST API  │              │       │
│              │ en.wikipedia.org    │              │       │
│              └────────────────────┘               │       │
│                                                    │       │
│  ┌───────────────────────────────────────────────┘       │
│  │          Local Storage (SharedPreferences)          │
│  │          └─→ Menyimpan Favorit                      │
│  └──────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Data Models

#### **1. EventModel**
```dart
EventModel {
  title: String          // Judul event
  text: String           // Deskripsi lengkap
  year: int              // Tahun terjadinya
  category: String       // Kategori (Place/Person/Discovery/Event)
  thumbnailUrl: String?  // URL gambar
  wikiUrl: String        // Link ke Wikipedia
}
```
**Kategori Auto-Detection:** Sistem secara otomatis mengidentifikasi kategori berdasarkan keywords dalam judul dan deskripsi.

#### **2. ArticleModel**
```dart
ArticleModel {
  title: String          // Judul artikel
  extract: String        // Ringkasan/preview
  thumbnailUrl: String?  // URL thumbnail
  wikiUrl: String        // Link ke halaman Wikipedia
}
```

#### **3. SearchResultModel**
```dart
SearchResultModel {
  title: String          // Judul hasil pencarian
  snippet: String        // Preview teks
  pageId: int            // ID halaman Wikipedia
}
```

### State Management dengan Provider

**FavoritesProvider:**
- Mengelola daftar artikel yang disimpan
- Menggunakan SharedPreferences untuk persistensi
- Methods: `add()`, `remove()`, `isFavorite()`, `load()`, `save()`

**HistoryProvider:**
- Mengelola peristiwa hari ini dan timeline
- Fetch data dari Wikipedia API
- States: idle, loading, loaded, error

**SearchProvider:**
- Mengelola pencarian artikel
- Debounce 400ms untuk saran
- Real-time suggestions

**RandomProvider:**
- Mengambil artikel acak dari Wikipedia
- Loading state management
- Error handling

---

## Desain & UI/UX

### Tema Warna
- **Primary**: #1F2937 (Charcoal Gelap) - Warna utama
- **Secondary**: #10B981 (Emerald Hijau) - Accent
- **Background**: #FFFFFF (Putih) - Background utama
- **Border**: #F3F4F6 (Abu-abu Terang) - Garis pemisah

### Typography
- **Font**: Inter (Google Fonts)
- **Heading**: Semi Bold, size 20-28px
- **Body**: Regular, size 14-16px
- **Caption**: Regular, size 12-13px

### Komponen UI
- **EventCard**: Animasi fade-in & slide, hover effects
- **ArticleCard**: Preview artikel dengan thumbnail
- **FilterChips**: Filter kategori dengan transisi smooth
- **ExtendedFAB**: Tombol random artikel dengan loading indicator

---

## Cara Menggunakan

### Setup Awal

**Prasyarat:**
- Flutter SDK (versi terbaru)
- Dart SDK
- Android Studio / Xcode (untuk emulator)
- Git

**Instalasi:**

```bash
# Clone repository
git clone <repository-url>
cd history_vault

# Install dependencies
flutter pub get

# Jalankan aplikasi
flutter run
```

### Tab Navigasi Utama

1. **Today (Beranda)**
   - Lihat peristiwa sejarah hari ini
   - Filter berdasarkan kategori
   - Klik event untuk baca detail

2. **Timeline**
   - Cari peristiwa berdasarkan tahun
   - Input tahun untuk eksplorasi
   - Telusuri sejarah kronologis

3. **Search**
   - Ketik kata kunci pencarian
   - Dapatkan saran real-time
   - Baca artikel yang relevan

4. **Favorites**
   - Lihat koleksi artikel favorit
   - Hapus dari favorit jika perlu
   - Akses cepat ke artikel tersimpan

### Fitur-Fitur Utama

**Random Article Button:**
- Tekan tombol "Random" untuk mendapatkan artikel acak
- Tekan berkali-kali untuk eksplorasi yang berbeda
- Judul dan konten akan terupdate otomatis

**Add to Favorites:**
- Tekan ikon bookmark di detail screen
- Artikel akan tersimpan di local storage
- Akses kembali dari tab Favorites

**Open in Wikipedia:**
- Tekan tombol "Baca Lengkap" atau "Wikipedia"
- Artikel akan dibuka di browser eksternal
- Baca konten Wikipedia lengkap

---

## Teknologi & Dependencies

```yaml
Core:
  - flutter: SDK terbaru
  - dart: 3.0+

Packages:
  - provider: 6.1.2          # State management
  - go_router: 14.0.0        # Navigation & routing
  - http: 1.2.0              # HTTP requests
  - google_fonts: 6.2.1      # Typography (Inter font)
  - cached_network_image: 3.3.1  # Image caching
  - shared_preferences: 2.2.3    # Local storage
  - url_launcher: 6.2.4      # Open external links
```

---

## Fitur Desain & UX

### Animasi & Interaksi
- Fade-in animations pada card loading
- Smooth transitions antar screen
- Hover effects pada desktop/tablet
- Loading indicators untuk async operations
- Empty states dengan messaging yang jelas

### Responsivitas
- Optimized untuk smartphone
- Supported untuk tablet
- Desktop layout (web platform)
- Adaptive UI elements

---

## Data Flow

```
User Input (Button/Tap)
    ↓
Screen/Widget Widget
    ↓
Call Provider Method
    ↓
Provider fetch dari Wikipedia Service
    ↓
HTTP Request ke Wikipedia API
    ↓
Parse Response JSON
    ↓
Update State via notifyListeners()
    ↓
Widget Rebuild dengan Data Baru
    ↓
UI Update Ditampilkan
```

---

## Handling Error

Aplikasi menangani berbagai error scenario:
- **Network Error**: Pesan user-friendly, retry option
- **API Error**: Error code dari Wikipedia API
- **Empty Results**: Empty state dengan helpful message
- **Loading State**: Circular progress indicator

---

## Catatan Pengembang

- Semua API calls menggunakan Wikipedia Public API (bebas)
- Data di-cache locally menggunakan `cached_network_image`
- Favorite articles disimpan di SharedPreferences
- Tidak ada API key yang diperlukan
- Data persisten di device (favorites)

---

## Lisensi

Proyek ini open source dan dapat digunakan sesuai kebutuhan.

---

## Kontribusi

Kontribusi sangat diterima! Silakan buat issue atau pull request untuk perbaikan dan fitur baru.

---

## Kontak & Support

Untuk pertanyaan atau laporan bug, silakan hubungi melalui issue tracker di repository.

---

**Happy Learning History!**
