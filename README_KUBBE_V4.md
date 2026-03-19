# KUBBE V4 - Sygrad Elite Islamic Lifestyle

KUBBE V4, Sy-OS tasarım dili ile donatılmış, modern ve kullanıcı dostu bir İslami yaşam tarzı uygulamasıdır. Namaz vakitleri, Kıble yönü, Kur'an-ı Kerim ve yapay zeka destekli Kumo AI asistanı gibi özellikler sunar.

## 🏗️ Mimari

### Clean Architecture
- **lib/core/theme**: Elite Theme Engine (Sy-OS)
- **lib/core/storage**: Preferences Manager (Riverpod Notifier)
- **lib/core/utils**: Turkish utilities (V1 stabilitesi)
- **lib/features/navigation**: AnaNavigasyon (BottomBar + FAB)
- **lib/features/**: Feature-based modüler yapı
  - **home**: Ana Ekran ve Özellikler
  - **quran**: Kur'an-ı Kerim modülü
  - **history**: Zaman Kubbesi
  - **ai**: Kumo AI Asistanı

## 🎨 Sy-OS Design System

### Renk Paleti
- **Ana Renk**: KubbeIndigo `#4B0082`
- **Arka Plan**: `#F3E5F5` (Light Purple)
- **Yüzey**: `#FFFFFF` (Açık Mod) / `#1A1A2E` (Koyu Mod)

### Tipografi (ZORUNLU)
- **Başlıklar**: Google Fonts - Outfit Bold
- **Sayılar/Sayaçlar**: Google Fonts - Poppins Bold  
- **Gövde Metinleri**: Google Fonts - Inter

### Komponentler
- **Border Radius**: 32dp (tüm kartlar ve butonlar için global)
- **Card Radius**: 32dp (tutarlı tasarım)
- **Button Radius**: 32dp (tüm butonlar)
- **Çok Hafif Gölgeler**: Hafif gölge efekti tüm kartlarda

## 🚀 Özellikler

### ✅ TAMAMLANAN ÖZELLİKLER
- [x] **Elite Theme Engine (Sy-OS)** - 32dp radius ve çok hafif gölgeler
- [x] **Clean Architecture** - Modüler ve ölçeklenebilir yapı
- [x] **Riverpod State Management** - Modern state yönetimi
- [x] **V1 Turkish Utils** - İ/i, I/ı hassasiyeti ile toTitleCase
- [x] **Preferences Manager** - Riverpod Notifier ile modernize edildi
- [x] **Ana Navigasyon** - 5 butonlu BottomBar + merkez FAB
- [x] **KUBBE Logo** - 36dp AppBar'da ortalanmış
- [x] **Feature Screens** - Tüm modüller için temel ekranlar

### 🚧 PLANLANAN ÖZELLİKLER
- [ ] Vakit Servisi (Aladhan + Diyanet API)
- [ ] Ezan sesleri ve bildirimler
- [ ] Kur'an-ı Kerim okuma modülü
- [ ] Zikir ve ibadet takibi
- [ ] Zaman Kubbesi (geçmiş vakitler)
- [ ] Kumo AI tam entegrasyonu
- [ ] Tema geçişi (Açık/Koyu)
- [ ] Widget desteği
- [ ] Çoklu dil desteği

## 📦 Kullanılan Paketler

### Core Dependencies
- `flutter_riverpod: ^2.5.1` - State management
- `google_fonts: ^6.2.1` - Sy-OS tipografisi (ZORUNLU)
- `adhan: ^2.0.0+1` - Namaz vakitleri hesaplaması
- `geolocator: ^13.0.1` - Konum servisleri
- `shared_preferences: ^2.3.2` - Yerel veri saklama
- `just_audio: ^0.9.40` - Ses oynatma
- `lottie: ^3.1.2` - Animasyonlar
- `dio: ^5.7.0` - HTTP istekleri
- `intl: ^0.19.0` - Uluslararasılaşma
- `shimmer: ^3.0.0` - Loading efektleri
- `hijri: ^3.0.0` - Hicri takvim

### Additional Dependencies
- `material_symbols_icons: ^4.2719.3` - Modern ikonlar
- `permission_handler: ^11.3.1` - İzin yönetimi
- `connectivity_plus: ^6.0.3` - İnternet bağlantısı kontrolü
- `timezone: ^0.9.4` - Zaman dilimi desteği

## 🛠️ Kurulum

### Gereksinimler
- Flutter SDK >= 3.11.1
- Dart SDK >= 3.11.1
- Android SDK (Android geliştirme için)
- Xcode (iOS geliştirme için)

### Adımlar
1. Repository'yi klonlayın:
   ```bash
   git clone <repository-url>
   cd kubbe_sygrad
   ```

2. Dependencies'leri yükleyin:
   ```bash
   flutter pub get
   ```

3. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

### Build
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# iOS Build
flutter build ios
```

## 🧪 Test

```bash
# Testleri çalıştır
flutter test

# Analiz
flutter analyze
```

## 📱 Ekran Görüntüleri

### Ana Ekran
- KUBBE V4 logosu (36dp) AppBar'da ortalanmış
- Özellik grid'i (32dp radius ile)
- Sy-OS tasarım dili

### Navigasyon
- **Ev**: Ana ekran ve özellikler
- **Kur'an**: Kur'an-ı Kerim modülü  
- **Kumo AI**: Merkezde Parlayan FAB butonu
- **Zaman**: Zaman Kubbesi
- **İbadetler**: İbadet takibi

## 🔧 V1 Stabilitesi

### Turkish Utils
V1'den miras alındı:
- `toTitleCase()` - İ/i, I/ı hassasiyeti
- `toSentenceCase()` - Türkçe cümle formatı
- `formatPrayerName()` - Namaz isimleri formatlama
- `removeDiacritics()` - Türkçe karakter temizleme

### Preferences Manager
- SharedPrefs üzerinden tüm ayarlar
- Riverpod Notifier ile modernize edildi
- V1'in `app_preferences.dart` yapısından miras alındı

## 🤝 Katkı

Katkıda bulunmak için:
1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişiklikleri commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Branch'e push edin (`git push origin feature/AmazingFeature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT Lisansı altında lisanslanmıştır.

## 🙏 Teşekkür

- **Aladhan Library**: Namaz vakitleri hesaplaması için
- **Google Fonts**: Sy-OS tipografisi için
- **Flutter Community**: Harika framework için
- **V1 KUBBE**: Temel mantık ve Turkish utils için

---

**KUBBE V4** - İslami teknolojide yenilikçi çözümler.
