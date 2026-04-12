# Kubbe - İslami Yaşam Tarzı Uygulaması
# Kubbe - Islamic Lifestyle Application

Google Material 3 ve Samsung One UI tasarım dillerinin birleşimini kullanan modern bir İslami yaşam tarzı uygulaması.

A modern Islamic lifestyle application that combines Google Material 3 and Samsung One UI design languages.

## Özellikler - Features

- **Modern Tasarım** - Material 3 ve One UI estetiği
- **5 Ana Sekme** - Home, Quran, Kumo (AI), Qibla, Tools
- **Tema Desteği** - Açık ve koyu tema desteği
- **Özel Fontlar** - Outfit, Poppins, Inter
- **Temiz Mimari** - Feature-first yapı

## Proje Yapısı - Project Structure

```
lib/
├── core/                    # Temel yapılandırma - Core configuration
│   ├── theme/              # Tema ve renkler - Theme and colors
│   └── navigation/         # Gezinme sistemi - Navigation system
├── features/               # Özellik bazlı modüller - Feature-based modules
│   ├── home/              # Ana sayfa - Home screen
│   ├── quran/             # Kuran - Quran
│   ├── kumo/              # Yapay zeka asistanı - AI assistant
│   ├── qibla/             # Kıble yönü - Qibla direction
│   └── tools/             # Araçlar - Tools
└── shared/                # Paylaşılan bileşenler - Shared components
    └── widgets/           # Özel widget'lar - Custom widgets
```

## Kurulum - Setup

1. Gerekli paketleri kur - Install required packages:
   ```bash
   flutter pub get
   ```

2. Uygulamayı çalıştır - Run the application:
   ```bash
   flutter run
   ```

## Kullanılan Teknolojiler - Technologies Used

- **Flutter** - UI framework
- **Go Router** - Navigasyon - Navigation
- **Google Fonts** - Font yönetimi - Font management
- **Provider** - State management
- **Flutter SVG** - SVG ikonlar - SVG icons

## Tasarım Kuralları - Design Rules

- **Ana Renk** - Primary Color: #4B0082 (Mor - Purple)
- **Fontlar** - Fonts: Outfit (başlıklar), Poppins (sayılar), Inter (metinler)
- **Köşeler** - Corners: Hafif yuvarlatılmış (One UI tarzı)
- **Gölgeler** - Shadows: Belgin ama göz yormayan

## Geliştirme - Development

Proje evrensel İngilizce isimlendirme standartlarına uygun olarak geliştirilmiştir. Tüm yorum satırları Türkçe ve İngilizce olarak yazılmıştır.

The project is developed according to universal English naming standards. All comment lines are written in both Turkish and English.
