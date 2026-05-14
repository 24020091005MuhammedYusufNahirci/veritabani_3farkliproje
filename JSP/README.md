\#  Şehir Rehberi ve Gezi Rotası (JSP \& PostgreSQL)



Bu proje, "Veri Tabanı Yönetim Sistemleri" dersi kapsamında; Java Server Pages (JSP) teknolojisi ve PostgreSQL ilişkisel veritabanı yönetim sistemi kullanılarak geliştirilmiş dinamik bir seyahat ve gezi planlama platformudur.



Sistem; şehirleri, buralarda gezilmesi gereken mekanları, bu mekanlarda düzenlenen etkinlikleri ve şehirlerde görev yapan profesyonel rehberleri ilişkisel bir modelde yönetir.



\##  Proje Özellikleri (Web Ekranları)



\- \*\*Şehir Listesi (Ana Sayfa):\*\* Veritabanında kayıtlı tüm şehirlerin bölgeleri ve nüfus bilgileriyle birlikte kartlar halinde listelendiği ana giriş ekranı.

\- \*\*Şehir Detay Sayfası:\*\* Bir şehir seçildiğinde (`cityId` ile), o şehre ait görülmesi gereken mekanları (Müze, Park, Restoran) ve o şehirde aktif çalışan uzman rehberleri \*\*JOIN\*\* sorgularıyla getiren detay ekranı.

\- \*\*Mekan Detay Sayfası:\*\* Seçilen mekanın derinlemesine açıklamasını ve o mekanda gerçekleşecek dinamik etkinlik takvimini (ücret ve tarih bilgileriyle) listeleyen ekran.

\- \*\*Yeni Mekan Ekleme Formu:\*\* Seçili şehre bağımlı kalarak veya form üzerinden dinamik şehir seçimi yaparak sisteme anında yeni bir turistik mekan kazandıran CRUD formu.

\- \*\*Arama ve Gelişmiş Filtreleme:\*\* Kullanıcıların coğrafi bölgelere veya doğrudan mekan türlerine (Müze/Park/Restoran) göre arama yapmasını sağlayan dinamik sonuç sayfası.




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

**Film Düzenleme Formu**
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


```text

📦 JSP Proje Klasörü

&#x20;┣ 📂 gezi\_rotasi/        # Tüm JSP kaynak dosyaları (index.jsp, sehirDetay.jsp vb.)

&#x20;┣ 📂 image/              # Proje arayüzü ve PostgreSQL veritabanı ekran görüntüleri

&#x20;┣ 📜 PostgreSQL.sql      # Tablo şemalarını ve test verilerini barındıran SQL dosyası

&#x20;┗ 📜 README.md           # Proje dökümantasyonu





