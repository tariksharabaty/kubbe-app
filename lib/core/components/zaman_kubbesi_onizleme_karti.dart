// TR: KUBBE V4 Zaman Kubbesi Önizleme Kartı - V4 standartları
// EN: KUBBE V4 Time Dome Preview Card - V4 standards
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Ana sayfada görünecek, zaman gösteren, Poppins fontlu, 32dp radius'lu asil zaman kartı.
// EN: Time preview card that will appear on home page, showing time, with Poppins font and 32dp radius.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// TR: Location result model
/// EN: Location result model
class LocationResult {
  final double latitude;
  final double longitude;
  final String? cityName;
  final double? accuracy;
  final DateTime? timestamp;
  final bool success;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.accuracy,
    this.timestamp,
    this.success = true,
  });
}

/// TR: KUBBE V4 Zaman Kubbesi Önizleme Widget'ı
/// EN: KUBBE V4 Time Dome Preview Widget
/// TR: Mevcut zamanı gösteren asil kart
/// EN: Elegant card showing current time
/// TR: 32dp radius ve Poppins font ile V4 estetiği
/// EN: V4 aesthetics with 32dp radius and Poppins font
/// TR: Konum bilgisi ve zaman gösterimi
/// EN: Location information and time display
/// TR: Sy-OS design language
/// EN: Sy-OS design language
class ZamanKubbesiOnizlemeKarti extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const ZamanKubbesiOnizlemeKarti({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TR: Mock location data for now
    // EN: Mock location data for now
    const locationResult = LocationResult(
      latitude: 41.015137,
      longitude: 28.979530,
      cityName: 'İstanbul',
      accuracy: 10.0,
      timestamp: null,
    );

    // TR: Mevcut zaman
    // EN: Current time
    final now = DateTime.now();

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
        child: locationResult.success == true
            ? _buildSuccessContent(context, locationResult, now)
            : _buildLoadingContent(context, now),
      ),
    );
  }

  // TR: Başarılı içerik oluştur
  // EN: Build success content
  Widget _buildSuccessContent(
    BuildContext context,
    LocationResult location,
    DateTime now,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TR: Üst satır - Zaman
        // EN: Top row - Time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TR: Zaman bilgisi
            // EN: Time information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TR: Tarih
                // EN: Date
                Text(
                  _formatDate(now),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(height: 4.0),

                // TR: Saat
                // EN: Time
                Text(
                  _formatTime(now),
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // TR: Zaman ikonu
            // EN: Time icon
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
                // TR: Saat ikonu
                // EN: Clock icon
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

        // TR: Konum bilgisi
        // EN: Location information
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
          // TR: Konum içeriği
          // EN: Location content
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TR: Konum ikonu
              // EN: Location icon
              Icon(
                Icons.location_on,
                color: Colors.white.withValues(alpha: 0.8),
                size: 20,
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(width: 8.0),

              // TR: Koordinatlar
              // EN: Coordinates
              Text(
                '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
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

        // TR: Ek bilgiler
        // EN: Additional info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TR: Hassasiyet bilgisi
            // EN: Accuracy info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hassasiyet',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  '${location.accuracy?.toStringAsFixed(1) ?? '0.0'}m',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // TR: Zaman damgası
            // EN: Timestamp
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Güncelleme',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  _formatTime(location.timestamp ?? now),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // TR: Yükleniyor içeriği oluştur
  // EN: Build loading content
  Widget _buildLoadingContent(BuildContext context, DateTime now) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TR: Yükleniyor satırı
        // EN: Loading row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TR: Zaman bilgisi
            // EN: Time information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TR: Tarih
                // EN: Date
                Text(
                  _formatDate(now),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(height: 4.0),

                // TR: Saat
                // EN: Time
                Text(
                  _formatTime(now),
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // TR: Yükleniyor ikonu
            // EN: Loading icon
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
                // TR: Yükleniyor ikonu
                // EN: Loading icon
                child: Icon(
                  Icons.hourglass_empty,
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

        // TR: Konum bilgisi
        // EN: Location information
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
          // TR: Yükleniyor içeriği
          // EN: Loading content
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TR: Konum ikonu
              // EN: Location icon
              Icon(
                Icons.location_searching,
                color: Colors.white.withValues(alpha: 0.8),
                size: 20,
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(width: 8.0),

              // TR: Yükleniyor metni
              // EN: Loading text
              Text(
                'Konum bekleniyor...',
                style: GoogleFonts.poppins(
                  fontSize: 16,
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

        // TR: Bekleniyor metni
        // EN: Waiting text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TR: Bekleniyor metni
            // EN: Waiting text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Durum',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  'Bekleniyor',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // TR: Zaman damgası
            // EN: Timestamp
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Güncelleme',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  _formatTime(now),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // TR: Tarihi formatla
  // EN: Format date
  String _formatDate(DateTime date) {
    final monthsTR = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];

    return '${date.day} ${monthsTR[date.month - 1]} ${date.year}';
  }

  // TR: Zamanı formatla
  // EN: Format time
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

/// TR: Zaman Kubbesi Helper - V4 yeniliği
/// EN: Time Dome Helper - V4 innovation
/// TR: Zaman kubbesi için yardımcı fonksiyonlar
/// EN: Helper functions for time dome
class ZamanKubbesiHelper {
  // TR: Zaman rengini al
  // EN: Get time color
  // TR: TR: Saate göre renk döndürür
  // EN: EN: Returns color based on time
  static Color getTimeColor(DateTime time) {
    final hour = time.hour;

    if (hour >= 6 && hour < 12) {
      // TR: Sabah - Mavi
      // EN: Morning - Blue
      return const Color(0xFF2196F3);
    } else if (hour >= 12 && hour < 17) {
      // TR: Öğle - Yeşil
      // EN: Afternoon - Green
      return const Color(0xFF4CAF50);
    } else if (hour >= 17 && hour < 20) {
      // TR: Akşam - Turuncu
      // EN: Evening - Orange
      return const Color(0xFFFF9800);
    } else {
      // TR: Gece - Mor
      // EN: Night - Purple
      return const Color(0xFF9C27B0);
    }
  }

  // TR: Zaman ikonunu al
  // EN: Get time icon
  // TR: TR: Saate göre ikon döndürür
  // EN: EN: Returns icon based on time
  static IconData getTimeIcon(DateTime time) {
    final hour = time.hour;

    if (hour >= 6 && hour < 12) {
      // TR: Sabah - Güneş
      // EN: Morning - Sun
      return Icons.wb_sunny;
    } else if (hour >= 12 && hour < 17) {
      // TR: Öğle - Güneş
      // EN: Afternoon - Sun
      return Icons.wb_sunny;
    } else if (hour >= 17 && hour < 20) {
      // TR: Akşam - Gün batımı
      // EN: Evening - Sunset
      return Icons.wb_twilight;
    } else {
      // TR: Gece - Yıldız
      // EN: Night - Stars
      return Icons.nights_stay;
    }
  }

  // TR: Zaman açıklamasını al
  // EN: Get time description
  // TR: TR: Saatin açıklamasını döndürür
  // EN: EN: Returns description of time
  static String getTimeDescription(DateTime time, {String language = 'tr'}) {
    final hour = time.hour;

    if (language == 'tr') {
      if (hour >= 6 && hour < 12) {
        return 'Sabah vakti';
      } else if (hour >= 12 && hour < 17) {
        return 'Öğle vakti';
      } else if (hour >= 17 && hour < 20) {
        return 'Akşam vakti';
      } else {
        return 'Gece vakti';
      }
    } else {
      if (hour >= 6 && hour < 12) {
        return 'Morning time';
      } else if (hour >= 12 && hour < 17) {
        return 'Afternoon time';
      } else if (hour >= 17 && hour < 20) {
        return 'Evening time';
      } else {
        return 'Night time';
      }
    }
  }

  // TR: Zaman selamlığını al
  // EN: Get time greeting
  // TR: TR: Saate göre selamlama mesajı döndürür
  // EN: EN: Returns greeting message based on time
  static String getTimeGreeting(DateTime time, {String language = 'tr'}) {
    final hour = time.hour;

    if (language == 'tr') {
      if (hour >= 6 && hour < 12) {
        return 'Günaydın!';
      } else if (hour >= 12 && hour < 17) {
        return 'İyi öğlemler!';
      } else if (hour >= 17 && hour < 20) {
        return 'İyi akşamlar!';
      } else {
        return 'İyi geceler!';
      }
    } else {
      if (hour >= 6 && hour < 12) {
        return 'Good morning!';
      } else if (hour >= 12 && hour < 17) {
        return 'Good afternoon!';
      } else if (hour >= 17 && hour < 20) {
        return 'Good evening!';
      } else {
        return 'Good night!';
      }
    }
  }
}

/// TR: Zaman Kubbesi Provider - V4 yeniliği
/// EN: Time Dome Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
final zamanKubbesiProvider = Provider<ZamanKubbesiHelper>((ref) {
  return ZamanKubbesiHelper();
});
