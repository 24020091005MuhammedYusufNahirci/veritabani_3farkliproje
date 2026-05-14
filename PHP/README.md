#  Film ve Oyuncu Veritabanı (Mini IMDb)

Bu proje, "Veri Tabanı Yönetim Sistemleri" dersi kapsamında; PHP, MySQL ve ilişkisel veritabanı mimarisini kullanarak geliştirilmiş bir film yönetim simülasyonudur.

## Proje Hakkında
Sistem, filmler ile oyuncular arasındaki **Many-to-Many (Çoka Çok)** ilişkiyi ve yönetmen/türler ile olan **One-to-Many (Bire Çok)** ilişkileri başarıyla yönetir. Kullanıcı dostu karanlık tema (Dark Mode) arayüzü ile veritabanındaki verilere erişim, filtreleme ve yönetim imkanı sunar.

## 📸 Uygulama Ekran Görüntüleri

### 1. Web Arayüzü (Frontend)

**Ana Sayfa - Film Vitrini**
![Ana Sayfa](image/anasayfa.png)

**Film Detay Sayfası (Yönetmen & Oyuncu Kadrosu)**
![Film Detay](image/filmdetay.png)

**Tüm Oyuncular Listesi**
![Tüm Oyuncular Listesi](image/oyuncular.png)

**Oyuncu Profil ve Biyografi Sayfası**
![Oyuncu Profil ve Biyografi](image/oyuncudetay.png)

**Film Düzenleme Formu **
![Film Düzenleme Formu](image/düzenleme.png)

**Kategoriye Göre Filtreleme**
![Kategoriye Göre Filtreleme](image/filmkategori.png)

---

### 2. Veritabanı Yapısı (MySQL / phpMyAdmin)

**Filmler Tablosu**
![Filmler Tablosu](image/filmler.png)

**Oyuncular Tablosu (Uzun Biyografiler)**
![Oyuncular Tablosu](image/oyunculartablo.png)

**Film_Oyunculari (İlişki / Ara Tablo)**
![Film Oyunculari Ara Tablo](image/aratablo.png)

**Türler Tablosu**
![Türler Tablosu](image/turler.png)


##  Dosya ve Klasör Yapısı
```text
📦 PHP Proje Klasörü
 ┣ 📂 Film/              # PHP Kaynak Dosyaları ve style.css
 ┣ 📂 image/             # Ekran Görüntüleri (Arayüz ve Veritabanı)
 ┣ 📜 MySql.sql          # Veritabanı Export Dosyası (DDL & DML)
 ┗ 📜 README.md          # Proje Dökümantasyonu

