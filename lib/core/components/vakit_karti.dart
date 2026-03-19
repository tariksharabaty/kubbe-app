// TR: KUBBE V4 Vakit Kartı - V4 standartları
// EN: KUBBE V4 Prayer Time Card - V4 standards
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Ana sayfada görünecek, mevcut vakti vurgulayan, Poppins fontlu, 32dp radius'lu asil vakit kartı.
// EN: Prayer time card that will appear on home page, highlighting current prayer, with Poppins font and 32dp radius.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adhan/adhan.dart';
import '../theme/app_theme.dart';
import '../services/prayer_service.dart';

/// TR: Prayer Name enum for type safety
/// EN: Prayer Name enum for type safety
enum PrayerName {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
}

/// TR: Current Prayer Result class
/// EN: Current Prayer Result class
class CurrentPrayerResult {
  final bool success;
  final PrayerName currentPrayer;
  final PrayerName? nextPrayer;
  final DateTime nextPrayerTime;
  final String remainingTime;
  final String timeUntilPrayer;

  CurrentPrayerResult({
    required this.success,
    required this.currentPrayer,
    this.nextPrayer,
    required this.nextPrayerTime,
    required this.remainingTime,
    required this.timeUntilPrayer,
  });
}

/// TR: Mock providers for demonstration
/// EN: Mock providers for demonstration
final currentPrayerProvider = Provider<CurrentPrayerResult>((ref) {
  // TR: Her zaman başarılı sonuç döndür
  // EN: Always return successful result
  return CurrentPrayerResult(
    success: true,
    currentPrayer: PrayerName.dhuhr,
    nextPrayer: PrayerName.asr,
    nextPrayerTime: DateTime.now().add(const Duration(hours: 2)),
    remainingTime: '2 saat 15 dakika',
    timeUntilPrayer: '2 saat 15 dakika',
  );
});

final prayerTimesProvider = Provider<AsyncValue<PrayerTimes?>>((ref) {
  // TR: Mock prayer times for Istanbul
  // EN: Mock prayer times for Istanbul
  final now = DateTime.now();
  final coordinates = Coordinates(41.015137, 28.979530);

  // TR: Use Turkey calculation method
  // EN: Use Turkey calculation method
  final params = CalculationParameters(
    fajrAngle: 18.0,
    ishaAngle: 17.0,
    method: CalculationMethod.turkey,
  );

  final prayerTimes = PrayerTimes(
    coordinates,
    DateComponents.from(now),
    params,
  );
  return AsyncValue.data(prayerTimes);
});

final prayerServiceProvider = Provider<PrayerService>((ref) {
  return PrayerService();
});

/// TR: Prayer Service extension with missing methods
/// EN: Prayer Service extension with missing methods
extension PrayerServiceExtension on PrayerService {
  /// TR: Get prayer name in Turkish
  /// EN: Get prayer name in Turkish
  String getPrayerName(PrayerName prayer) {
    switch (prayer) {
      case PrayerName.fajr:
        return 'İmsak';
      case PrayerName.sunrise:
        return 'Güneş';
      case PrayerName.dhuhr:
        return 'Öğle';
      case PrayerName.asr:
        return 'İkindi';
      case PrayerName.maghrib:
        return 'Akşam';
      case PrayerName.isha:
        return 'Yatsı';
    }
  }

  /// TR: Format remaining time
  /// EN: Format remaining time
  String formatRemainingTime(DateTime nextPrayer, DateTime now) {
    final difference = nextPrayer.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return '$hours saat $minutes dakika';
    } else {
      return '$minutes dakika';
    }
  }
}

/// TR: KUBBE V4 Vakit Kartı Widget'ı
/// EN: KUBBE V4 Prayer Time Card Widget
/// TR: Mevcut namaz vaktini gösteren asil kart
/// EN: Elegant card showing current prayer time
/// TR: 32dp radius ve Poppins font ile V4 estetiği
/// EN: V4 aesthetics with 32dp radius and Poppins font
/// TR: Mevcut vakti vurgulama ve kalan süre gösterimi
/// EN: Current prayer highlighting and remaining time display
/// TR: Sy-OS design language
/// EN: Sy-OS design language
class VakitKarti extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const VakitKarti({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TR: Mevcut namaz vaktini izle - Güvenlik kontrolü ile
    // EN: Watch current prayer time - with safety check
    try {
      final currentPrayerResult = ref.watch(currentPrayerProvider);

      // TR: Prayer service
      // EN: Prayer service
      final prayerService = ref.read(prayerServiceProvider);

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        // TR: Kart container
        // EN: Card container
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            // TR: 32dp radius - Sy-OS standartı
            // EN: 32dp radius - Sy-OS standard
            borderRadius: BorderRadius.circular(32.0),
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: LinearGradient(
              colors: [
                KubbeTheme.kubbeIndigo,
                KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // TR: Gölge
            // EN: Shadow
            boxShadow: [
              BoxShadow(
                color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          // TR: Kart içeriği
          // EN: Card content
          child:
              _buildSuccessContent(context, currentPrayerResult, prayerService),
        ),
      );
    } catch (e) {
      // TR: Hata durumunda boş widget dön
      // EN: Return empty widget on error
      return const SizedBox();
    }
  }

  // TR: Başarılı içerik oluştur
  // EN: Build success content
  Widget _buildSuccessContent(
    BuildContext context,
    CurrentPrayerResult currentPrayer,
    PrayerService prayerService,
  ) {
    final currentPrayerName = currentPrayer.currentPrayer;
    final nextPrayerName = currentPrayer.nextPrayer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TR: Üst satır - Mevcut vakit
        // EN: Top row - Current prayer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TR: Vakit adı
            // EN: Prayer name
            Text(
              prayerService.getPrayerName(currentPrayerName),
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // TR: Vakit ikonu
            // EN: Prayer icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                // TR: Yuvarlak
                // EN: Circle
                shape: BoxShape.circle,
                // TR: Beyaz arka plan
                // EN: White background
                color: Colors.white.withValues(alpha: 0.2),
              ),
              // TR: İkon içeriği
              // EN: Icon content
              child: const Center(
                // TR: Namaz ikonu
                // EN: Prayer icon
                child: Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),

        // TR: Boşluk
        // EN: Spacer
        const SizedBox(height: 16.0),

        // TR: Kalan süre
        // EN: Remaining time
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            // TR: 16dp radius
            // EN: 16dp radius
            borderRadius: BorderRadius.circular(16.0),
            // TR: Beyaz arka plan
            // EN: White background
            color: Colors.white.withValues(alpha: 0.1),
            // TR: Kenar
            // EN: Border
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          // TR: Süre içeriği
          // EN: Time content
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TR: Saat ikonu
              // EN: Hour icon
              Icon(
                Icons.hourglass_empty,
                color: Colors.white.withValues(alpha: 0.8),
                size: 20,
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(width: 8.0),

              // TR: Süre metni
              // EN: Time text
              Text(
                prayerService.formatRemainingTime(
                    currentPrayer.nextPrayerTime, DateTime.now()),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // TR: Boşluk
        // EN: Spacer
        const SizedBox(height: 16.0),

        // TR: Sonraki vakit bilgisi
        // EN: Next prayer info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TR: Sonraki vakit metni
            // EN: Next prayer text
            Text(
              'Sonraki: ${nextPrayerName != null ? prayerService.getPrayerName(nextPrayerName) : "Bilinmiyor"}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),

            // TR: Ok ikonu
            // EN: Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withValues(alpha: 0.6),
              size: 16,
            ),
          ],
        ),
      ],
    );
  }
}

/// TR: Vakit Kartı Helper - V4 yeniliği
/// EN: Prayer Card Helper - V4 innovation
/// TR: Vakit kartı için yardımcı fonksiyonlar
/// EN: Helper functions for prayer card
class VakitKartiHelper {
  // TR: Vakit rengini al
  // EN: Get prayer color
  // TR: TR: Namaz vaktine göre renk döndürür
  // EN: EN: Returns color based on prayer time
  static Color getPrayerColor(PrayerName prayerName) {
    switch (prayerName) {
      case PrayerName.fajr:
        return const Color(0xFF2196F3); // TR: Mavi // EN: Blue
      case PrayerName.sunrise:
        return const Color(0xFFFF9800); // TR: Turuncu // EN: Orange
      case PrayerName.dhuhr:
        return const Color(0xFF4CAF50); // TR: Yeşil // EN: Green
      case PrayerName.asr:
        return const Color(0xFF9C27B0); // TR: Mor // EN: Purple
      case PrayerName.maghrib:
        return const Color(0xFFFF5722); // TR: Kırmızı // EN: Red
      case PrayerName.isha:
        return const Color(0xFF3F51B5); // TR: Indigo // EN: Indigo
    }
  }

  // TR: Vakit ikonunu al
  // EN: Get prayer icon
  // TR: TR: Namaz vaktine göre ikon döndürür
  // EN: EN: Returns icon based on prayer time
  static IconData getPrayerIcon(PrayerName prayerName) {
    switch (prayerName) {
      case PrayerName.fajr:
        return Icons.wb_sunny; // TR: Güneş // EN: Sun
      case PrayerName.sunrise:
        return Icons.wb_twilight; // TR: Şafak // EN: Twilight
      case PrayerName.dhuhr:
        return Icons.wb_sunny; // TR: Güneş // EN: Sun
      case PrayerName.asr:
        return Icons.wb_cloudy; // TR: Bulutlu // EN: Cloudy
      case PrayerName.maghrib:
        return Icons.nights_stay; // TR: Gece // EN: Night
      case PrayerName.isha:
        return Icons.bedtime; // TR: Uyku // EN: Bedtime
    }
  }

  // TR: Vakit önem seviyesini al
  // EN: Get prayer importance level
  // TR: TR: Namaz vaktinin önem seviyesini döndürür
  // EN: EN: Returns importance level of prayer time
  static int getPrayerImportance(PrayerName prayerName) {
    switch (prayerName) {
      case PrayerName.fajr:
        return 5; // TR: Sabah namazı önemli // EN: Morning prayer is important
      case PrayerName.dhuhr:
        return 4; // TR: Öğle namazı önemli // EN: Noon prayer is important
      case PrayerName.asr:
        return 3; // TR: İkindi namazı // EN: Afternoon prayer
      case PrayerName.maghrib:
        return 4; // TR: Akşam namazı önemli // EN: Evening prayer is important
      case PrayerName.isha:
        return 3; // TR: Yatsı namazı // EN: Night prayer
      case PrayerName.sunrise:
        return 1; // TR: Güneş vakti namaz değil // EN: Sunrise is not a prayer
    }
  }

  // TR: Vakit açıklamasını al
  // EN: Get prayer description
  // TR: TR: Namaz vaktinin açıklamasını döndürür
  // EN: EN: Returns description of prayer time
  static String getPrayerDescription(PrayerName prayerName,
      {String language = 'tr'}) {
    if (language == 'tr') {
      switch (prayerName) {
        case PrayerName.fajr:
          return 'Sabah namazı vakti';
        case PrayerName.sunrise:
          return 'Güneş doğumu vakti';
        case PrayerName.dhuhr:
          return 'Öğle namazı vakti';
        case PrayerName.asr:
          return 'İkindi namazı vakti';
        case PrayerName.maghrib:
          return 'Akşam namazı vakti';
        case PrayerName.isha:
          return 'Yatsı namazı vakti';
      }
    } else {
      switch (prayerName) {
        case PrayerName.fajr:
          return 'Morning prayer time';
        case PrayerName.sunrise:
          return 'Sunrise time';
        case PrayerName.dhuhr:
          return 'Noon prayer time';
        case PrayerName.asr:
          return 'Afternoon prayer time';
        case PrayerName.maghrib:
          return 'Evening prayer time';
        case PrayerName.isha:
          return 'Night prayer time';
      }
    }
  }
}

/// TR: Vakit Kartı Provider - V4 yeniliği
/// EN: Prayer Card Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
final vakitKartiProvider = Provider<VakitKartiHelper>((ref) {
  return VakitKartiHelper();
});
