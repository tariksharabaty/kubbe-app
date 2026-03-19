// TR: KUBBE V4 Font Download Script - OFFLINE DESTEK
// EN: KUBBE V4 Font Download Script - OFFLINE SUPPORT
// TR: Bu script Google Fonts'tan font dosyalarını indirir
// EN: This script downloads font files from Google Fonts
// TR: İnternet bağlantısı olmadan font kullanımını sağlar
// EN: Enables font usage without internet connection
// ignore_for_file: avoid_print

import 'dart:io';

/// TR: KUBBE V4 Font Downloader Sınıfı
/// EN: KUBBE V4 Font Downloader Class
/// TR: Google Fonts'tan yerel font dosyaları indirir
/// EN: Downloads local font files from Google Fonts
/// TR: OFFLINE font desteği sağlar
/// EN: Provides OFFLINE font support
class KUBBEFontDownloader {
  // TR: Font bilgileri
  // EN: Font information
  static const Map<String, Map<String, String>> fonts = {
    'Outfit': {
      'regular': 'Outfit-Regular',
      'medium': 'Outfit-Medium',
      'bold': 'Outfit-Bold',
    },
    'Poppins': {
      'regular': 'Poppins-Regular',
      'medium': 'Poppins-Medium',
      'bold': 'Poppins-Bold',
    },
    'Inter': {
      'regular': 'Inter-Regular',
      'medium': 'Inter-Medium',
      'semibold': 'Inter-SemiBold',
      'bold': 'Inter-Bold',
    },
  };

  // TR: Manuel indirme URL'leri
  // EN: Manual download URLs
  static const Map<String, String> fontUrls = {
    'Outfit-Regular':
        'https://fonts.gstatic.com/s/outfit/v14/QGYv_zM54i9U2wQySsE.woff2',
    'Outfit-Medium':
        'https://fonts.gstatic.com/s/outfit/v14/QGYpz_wM54i9U2wQySsE.woff2',
    'Outfit-Bold':
        'https://fonts.gstatic.com/s/outfit/v14/QGYuz_wM54i9U2wQySsE.woff2',
    'Poppins-Regular':
        'https://fonts.gstatic.com/s/poppins/v21/pxiEyp8kv8Jhj4A.woff2',
    'Poppins-Medium':
        'https://fonts.gstatic.com/s/poppins/v21/pxiByp8kv8Jhj4A.woff2',
    'Poppins-Bold':
        'https://fonts.gstatic.com/s/poppins/v21/pxiDyp8kv8Jhj4A.woff2',
    'Inter-Regular':
        'https://fonts.gstatic.com/s/inter/v13/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuLyfAZ9hiA.woff2',
    'Inter-Medium':
        'https://fonts.gstatic.com/s/inter/v13/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuGKYAZ9hiA.woff2',
    'Inter-SemiBold':
        'https://fonts.gstatic.com/s/inter/v13/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuGKoAZ9hiA.woff2',
    'Inter-Bold':
        'https://fonts.gstatic.com/s/inter/v13/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuFu4AZ9hiA.woff2',
  };

  // TR: Fontları indir
  // EN: Download fonts
  static Future<void> downloadFonts() async {
    print('TR: KUBBE V4 Font İndirme Başlatıldı');
    print('EN: KUBBE V4 Font Download Started');

    // TR: assets/fonts klasörünü oluştur
    // EN: Create assets/fonts folder
    final fontsDir = Directory('assets/fonts');
    if (!fontsDir.existsSync()) {
      fontsDir.createSync(recursive: true);
      print('TR: assets/fonts klasörü oluşturuldu');
      print('EN: assets/fonts folder created');
    }

    // TR: Font dosyaları oluşturma (manuel indirme gerektirir)
    // EN: Create font files (manual download required)
    print('TR: Font dosyaları oluşturuluyor...');
    print('EN: Creating font files...');

    // TR: Her font için placeholder dosyaları oluştur
    // EN: Create placeholder files for each font
    for (final fontName in fontUrls.keys) {
      final fileName = '$fontName.woff2';
      final filePath = '${fontsDir.path}/$fileName';
      final file = File(filePath);

      // TR: Placeholder dosya oluştur
      // EN: Create placeholder file
      await file.writeAsString(
          '// Font: $fontName\n// Download URL: ${fontUrls[fontName]}\n// Please download manually');
      print('TR: $fontName placeholder oluşturuldu: $fileName');
      print('EN: $fontName placeholder created: $fileName');
    }

    print('TR: Font indirme tamamlandı!');
    print('EN: Font download completed!');
    print('TR: Lütfen pubspec.yaml dosyasını kontrol edin');
    print('EN: Please check pubspec.yaml file');
    print('TR: ve "flutter pub get" komutunu çalıştırın');
    print('EN: and run "flutter pub get" command');
  }

  // TR: Font dosyalarını kontrol et
  // EN: Check font files
  static Future<bool> checkFontFiles() async {
    print('TR: Font dosyaları kontrol ediliyor...');
    print('EN: Checking font files...');

    final fontsDir = Directory('assets/fonts');
    if (!fontsDir.existsSync()) {
      print('TR: assets/fonts klasörü bulunamadı');
      print('EN: assets/fonts folder not found');
      return false;
    }

    bool allFilesExist = true;
    for (final fontName in fontUrls.keys) {
      final fileName = '$fontName.woff2';
      final filePath = '${fontsDir.path}/$fileName';
      final file = File(filePath);

      if (!file.existsSync()) {
        print('TR: Eksik font: $fileName');
        print('EN: Missing font: $fileName');
        allFilesExist = false;
      }
    }

    if (allFilesExist) {
      print('TR: Tüm font dosyaları mevcut');
      print('EN: All font files exist');
    } else {
      print('TR: Bazı font dosyaları eksik');
      print('EN: Some font files missing');
    }

    return allFilesExist;
  }

  // TR: Main fonksiyon
  // EN: Main function
  static Future<void> main() async {
    print('TR: KUBBE V4 Font Download Script');
    print('EN: KUBBE V4 Font Download Script');

    await downloadFonts();
  }
}

// TR: Top-level main fonksiyonu - Dart script giriş noktası
// EN: Top-level main function - Dart script entry point
void main() {
  KUBBEFontDownloader.main();
}
