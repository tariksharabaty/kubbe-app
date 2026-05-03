🕌 Kubbe - Premium İslami Yaşam ve İbadet Rehberi

![Version](https://img.shields.io/badge/version-1.2.1-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-lightgrey)

**Kubbe**, ibadetlerinize odaklanabilmeniz için karmaşadan uzak, reklamsız, minimalist ve premium bir deneyim sunmayı hedefleyen kapsamlı bir İslami yaşam uygulamasıdır. Kullanıcı deneyimini (UX) ve gizliliği ön planda tutan Kubbe, arka planda gereksiz veri tüketmez ve kullanıcıyı yormaz.

---

## ✨ Temel Özellikler

### 📍 Namaz Vakitleri & Konum
- Diyanet ve uluslararası hesaplama yöntemleriyle yüksek hassasiyetli namaz vakitleri.
- Otomatik konum algılama ve internetsiz durumlarda güvenli (fail-safe) gösterim.
- Vakit çıkmasına/girmesine kalan süreyi gösteren dinamik geri sayım arayüzü.

### 📖 Kuran-ı Kerim
- Medine Mushafı ve Osmanlı hat sanatı seçenekleriyle pürüzsüz okuma deneyimi.
- Çoklu dil destekli Kuran meali (Türkçe, İngilizce, Arapça, Fransızca, Rusça vb.).
- Ayet ayet tefsir ve detaylı sure bilgileri.

### 🧭 Akıllı Kıble Pusulası
- Cihaz sensörlerini ve GPS verilerini kullanarak %100 hassasiyetle Kıble yönü tespiti.
- Manyetik alan bozulmalarına karşı kullanıcıyı uyaran akıllı sensör mimarisi.

### 📿 Zikirmatik & Esma-ül Hüsna
- Özelleştirilebilir temalara sahip, haptik geri bildirimli modern Zikirmatik.
- Esma-ül Hüsna (Allah'ın 99 ismi), anlamları ve faziletleri.

### 🛠️ Kapsamlı İslami Araçlar
- **Zekatmatik:** Güncel kur bilgileri ile hassas zekat hesaplama.
- **Kaza Namazı Takibi:** Kılınmayan namazların kaydını tutma ve ilerleme grafiği.
- **Cuma Hutbeleri:** Güncel hutbeleri okuma ve dinleme imkanı.
- **Dini Günler & Takvim:** Hicri takvim entegrasyonu ve yaklaşan kandil/bayram uyarıları.
- **Yakındaki Camiler:** Harita üzerinden bulunulan konuma en yakın camileri listeleme.

### 🎨 Kubbe Atölyesi (Yaratıcı Modül)
- İslami mesajlar, ayetler ve duaları özel arka planlar ve hat sanatlarıyla birleştirip sosyal medyada paylaşılmaya hazır görsel kartlar oluşturma aracı.

---

## 🏗️ Mimari Yapı & Kullanılan Teknolojiler

Proje, sürdürülebilirliği ve test edilebilirliği artırmak amacıyla **Feature-First (Özellik Odaklı)** klasörleme mimarisi ile inşa edilmiştir. Her modül kendi içinde bağımsız bir yapıya sahiptir.

**Tech Stack:**
- **Framework:** Flutter (Dart)
- **State Management:** Provider (Yüksek performanslı ve reaktif durum yönetimi)
- **Localization:** easy_localization (Dinamik dil değişimi)
- **Storage:** shared_preferences & sqflite (Lokal veritabanı ve önbellekleme)
- **Location Services:** geolocator (Konum ve koordinat işlemleri)
- **Monetization/IAP:** RevenueCat (Güvenli uygulama içi satın alma altyapısı)

**Klasör Yapısı:**
```text
lib/
 ├── core/          # Ortak widgetlar, temalar, servisler ve state'ler
 ├── data/          # Lokal veritabanı (Dualar, Tarih, İlmihal)
 ├── features/      # Uygulamanın ana modülleri
 │    ├── atelier/      # Kubbe Atölyesi
 │    ├── home/         # Ana Ekran ve Vakitler
 │    ├── quran/        # Kuran-ı Kerim Okuyucu
 │    ├── qibla/        # Pusula
 │    ├── tools/        # Zekatmatik, Kaza Namazı, Esma-ül Hüsna vb.
 │    └── settings/     # Ayarlar ve Tema Yönetimi
 └── main.dart      # Uygulama başlangıç noktası
🚀 Kurulum (Getting Started)
Projeyi yerel ortamınızda çalıştırmak için aşağıdaki adımları izleyin:

Repoyu Klonlayın:

Bash
git clone [https://github.com/your-username/kubbe_app.git](https://github.com/your-username/kubbe_app.git)
Bağımlılıkları Yükleyin:

Bash
cd kubbe_app
flutter pub get
Çeviri Dosyalarını (Localization) Oluşturun (Gerekliyse):

Bash
flutter pub run easy_localization:generate -S assets/translations
Uygulamayı Başlatın:

Bash
flutter run
🛡️ Gizlilik ve Veri Güvenliği
Kubbe, kullanıcı verilerini satmaz ve analiz şirketleriyle paylaşmaz. Konum verileri yalnızca namaz vakitlerinin hesaplanması ve Kıble yönünün bulunması için anlık olarak kullanılır ve hiçbir sunucuda saklanmaz. Uygulama tamamen reklamsızdır (Google AdMob vb. SDK'lar kullanılmaz).

🤝 Katkıda Bulunma
Bu proje kapalı kaynak (proprietary) bir girişimdir. Ancak geliştirme ekibindeyseniz, lütfen branch oluştururken standart feature/ozellik-adi isimlendirme kuralına uyun ve merge request açmadan önce kodunuzu flutter analyze ile test edin.

Geliştirici: [Sygrad] | İletişim: [sygradinfo@gmail.com]
