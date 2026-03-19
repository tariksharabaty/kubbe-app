// TR: KUBBE V4 Vakit Kartı Component - V4 standartları
// EN: KUBBE V4 Prayer Card Component - V4 standards
// TR: Ana sayfada görünecek, mevcut vakti vurgulayan, Poppins fontlu asil vakit kartı
// EN: Noble prayer card with Poppins font that highlights current prayer, visible on home screen
// TR: Vakit bilgilerini modern ve estetik bir şekilde gösterir
// EN: Displays prayer information in a modern and aesthetic way

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kubbe_card.dart';
import '../../core/utils/string_utils.dart';

/// TR: KUBBE V4 Vakit Kartı Bileşeni
/// EN: KUBBE V4 Prayer Card Component
/// TR: Mevcut vakit bilgisini gösteren, Poppins fontlu ve asil tasarım
/// EN: Shows current prayer information with Poppins font and noble design
/// TR: Vakit değişimlerini ve kalan süreyi anlık olarak gösterir
/// EN: Shows prayer changes and remaining time in real-time
class VakitKarti extends StatelessWidget {
  // TR: Mevcut vakit adı
  // EN: Current prayer name
  final String currentPrayer;

  // TR: Vakit zamanı
  // EN: Prayer time
  final String prayerTime;

  // TR: Sonraki vakit adı
  // EN: Next prayer name
  final String nextPrayer;

  // TR: Sonraki vakite kalan süre
  // EN: Time until next prayer
  final Duration timeUntilNext;

  // TR: Şehir adı
  // EN: City name
  final String city;

  // TR: Tıklama callback'i
  // EN: Tap callback
  final VoidCallback? onTap;

  // TR: Constructor
  // EN: Constructor
  const VakitKarti({
    super.key,
    required this.currentPrayer,
    required this.prayerTime,
    required this.nextPrayer,
    required this.timeUntilNext,
    required this.city,
    this.onTap,
  });

  // TR: Kalan süreyi formatla
  // EN: Format remaining time
  String _formatTimeUntilNext(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours} sa ${duration.inMinutes % 60} dk';
    } else {
      return '${duration.inMinutes} dk ${duration.inSeconds % 60} sn';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TR: Poppins font ailesi
    // EN: Poppins font family
    final poppinsFont = GoogleFonts.poppins();

    // TR: Vakit ikonu
    // EN: Prayer icon
    IconData getPrayerIcon(String prayer) {
      switch (prayer.toLowerCase()) {
        case 'sabah':
        case 'fajr':
          return Icons.wb_sunny; // TR: Güneş ikonu // EN: Sun icon
        case 'güneş':
        case 'sunrise':
          return Icons.wb_twilight; // TR: Şafak ikonu // EN: Dawn icon
        case 'öğle':
        case 'dhuhr':
          return Icons.wb_sunny_outlined; // TR: Öğlen ikonu // EN: Noon icon
        case 'ikindi':
        case 'asr':
          return Icons.wb_cloudy; // TR: İkindi ikonu // EN: Afternoon icon
        case 'akşam':
        case 'maghrib':
          return Icons.nightlight; // TR: Akşam ikonu // EN: Evening icon
        case 'yatsı':
        case 'isha':
          return Icons.nightlight_round; // TR: Yatsı ikonu // EN: Night icon
        default:
          return Icons.access_time; // TR: Varsayılan ikon // EN: Default icon
      }
    }

    // TR: Vakit rengi
    // EN: Prayer color
    Color getPrayerColor(String prayer) {
      switch (prayer.toLowerCase()) {
        case 'sabah':
        case 'fajr':
          return const Color(0xFFFF9800); // TR: Turuncu // EN: Orange
        case 'öğle':
        case 'dhuhr':
          return const Color(0xFF2196F3); // TR: Mavi // EN: Blue
        case 'ikindi':
        case 'asr':
          return const Color(0xFF4CAF50); // TR: Yeşil // EN: Green
        case 'akşam':
        case 'maghrib':
          return const Color(0xFFFF5722); // TR: Koyu turuncu // EN: Deep orange
        case 'yatsı':
        case 'isha':
          return const Color(0xFF9C27B0); // TR: Mor // EN: Purple
        default:
          return const Color(0xFF1A237E); // TR: İndigo // EN: Indigo
      }
    }

    return KubbeCard(
      onTap: onTap,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TR: Üst bölüm: Şehir ve konum bilgisi
          // EN: Top section: City and location information
          Row(
            children: [
              // TR: Konum ikonu
              // EN: Location icon
              const Icon(
                Icons.location_on,
                color: Color(
                  0xFF9C27B0,
                ), // TR: KUBBE Mor // EN: KUBBE Purple
                size: 20.0,
              ),
              // TR: Konum ikonu ile şehir adı arası boşluk
              // EN: Space between location icon and city name
              const SizedBox(width: 8.0),
              // TR: Şehir adı
              // EN: City name
              Text(
                city,
                style: poppinsFont.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF757575), // TR: Gri // EN: Gray
                ),
              ),
            ],
          ),

          // TR: Şehir ile mevcut vakit arası boşluk
          // EN: Space between city and current prayer
          const SizedBox(height: 20.0),

          // TR: Mevcut vakit bölümü
          // EN: Current prayer section
          Row(
            children: [
              // TR: Vakit ikonu
              // EN: Prayer icon
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  // TR: Vakit renginde daire
                  // EN: Circle in prayer color
                  color: getPrayerColor(currentPrayer).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getPrayerIcon(currentPrayer),
                  color: getPrayerColor(currentPrayer),
                  size: 24.0,
                ),
              ),

              // TR: İkon ile vakit bilgisi arası boşluk
              // EN: Space between icon and prayer information
              const SizedBox(width: 16.0),

              // TR: Vakit bilgisi
              // EN: Prayer information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TR: Mevcut vakit adı
                    // EN: Current prayer name
                    Text(
                      StringUtils.toTitleCase(currentPrayer),
                      style: poppinsFont.copyWith(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        color: getPrayerColor(currentPrayer),
                      ),
                    ),
                    // TR: Vakit zamanı
                    // EN: Prayer time
                    Text(
                      prayerTime,
                      style: poppinsFont.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: const Color(
                          0xFF424242,
                        ), // TR: Koyu gri // EN: Dark gray
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // TR: Mevcut vakit ile sonraki vakit arası boşluk
          // EN: Space between current prayer and next prayer
          const SizedBox(height: 24.0),

          // TR: Ayırıcı çizgi
          // EN: Divider line
          Container(
            height: 1.0,
            color: const Color(0xFFE0E0E0), // TR: Açık gri // EN: Light gray
          ),

          // TR: Ayırıcı ile sonraki vakit arası boşluk
          // EN: Space between divider and next prayer
          const SizedBox(height: 16.0),

          // TR: Sonraki vakit bölümü
          // EN: Next prayer section
          Row(
            children: [
              // TR: Sonraki vakit bilgisi
              // EN: Next prayer information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TR: Sonraki vakit etiketi
                    // EN: Next prayer label
                    Text(
                      'Sonraki Vakit',
                      style: poppinsFont.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: const Color(
                          0xFF9E9E9E,
                        ), // TR: Açık gri // EN: Light gray
                      ),
                    ),
                    // TR: Etiket ile vakit adı arası boşluk
                    // EN: Space between label and prayer name
                    const SizedBox(height: 4.0),
                    // TR: Sonraki vakit adı
                    // EN: Next prayer name
                    Text(
                      StringUtils.toTitleCase(nextPrayer),
                      style: poppinsFont.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(
                          0xFF1A237E,
                        ), // TR: KUBBE İndigo // EN: KUBBE Indigo
                      ),
                    ),
                  ],
                ),
              ),

              // TR: Kalan süre bilgisi
              // EN: Remaining time information
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // TR: Kalan süre etiketi
                  // EN: Remaining time label
                  Text(
                    'Kalan Süre',
                    style: poppinsFont.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(
                        0xFF9E9E9E,
                      ), // TR: Açık gri // EN: Light gray
                    ),
                  ),
                  // TR: Etiket ile süre arası boşluk
                  // EN: Space between label and time
                  const SizedBox(height: 4.0),
                  // TR: Kalan süre
                  // EN: Remaining time
                  Text(
                    _formatTimeUntilNext(timeUntilNext),
                    style: poppinsFont.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: const Color(
                        0xFF9C27B0,
                      ), // TR: KUBBE Mor // EN: KUBBE Purple
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// TR: Vakit Kartı Provider'ı - Riverpod ile state management
/// EN: Prayer Card Provider - State management with Riverpod
/// TR: Vakit kartı için gerekli verileri sağlar
/// EN: Provides necessary data for prayer card
class VakitKartiProvider extends StatelessWidget {
  // TR: Vakit kartı widget'i
  // EN: Prayer card widget
  final Widget child;

  // TR: Constructor
  // EN: Constructor
  const VakitKartiProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // TR: Vakit kartı verileri
    // EN: Prayer card data
    const currentPrayer = 'Öğle'; // TR: Mevcut vakit // EN: Current prayer
    const prayerTime = '13:30'; // TR: Vakit zamanı // EN: Prayer time
    const nextPrayer = 'İkindi'; // TR: Sonraki vakit // EN: Next prayer
    const timeUntilNext = Duration(
      hours: 2,
      minutes: 15,
    ); // TR: Kalan süre // EN: Remaining time
    const city = 'İstanbul'; // TR: Şehir // EN: City

    // TR: Vakit kartı oluştur
    // EN: Create prayer card
    return VakitKarti(
      currentPrayer: currentPrayer,
      prayerTime: prayerTime,
      nextPrayer: nextPrayer,
      timeUntilNext: timeUntilNext,
      city: city,
      onTap: () {
        // TR: Vakit detay sayfasına git
        // EN: Navigate to prayer details page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vakit detayları açılıyor...'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}

/// TR: Mini Vakit Kartı - Daha küçük versiyon
/// EN: Mini Prayer Card - Smaller version
/// TR: Dar alanlar için mini vakit kartı
/// EN: Mini prayer card for narrow spaces
class MiniVakitKarti extends StatelessWidget {
  // TR: Mevcut vakit adı
  // EN: Current prayer name
  final String currentPrayer;

  // TR: Vakit zamanı
  // EN: Prayer time
  final String prayerTime;

  // TR: Sonraki vakite kalan süre
  // EN: Time until next prayer
  final Duration timeUntilNext;

  // TR: Tıklama callback'i
  // EN: Tap callback
  final VoidCallback? onTap;

  // TR: Constructor
  // EN: Constructor
  const MiniVakitKarti({
    super.key,
    required this.currentPrayer,
    required this.prayerTime,
    required this.timeUntilNext,
    this.onTap,
  });

  // TR: Kalan süreyi formatla
  // EN: Format remaining time
  String _formatTimeUntilNext(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}sa ${duration.inMinutes % 60}dk';
    } else {
      return '${duration.inMinutes}dk';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TR: Poppins font ailesi
    // EN: Poppins font family
    final poppinsFont = GoogleFonts.poppins();

    // TR: Vakit rengi
    // EN: Prayer color
    Color getPrayerColor(String prayer) {
      switch (prayer.toLowerCase()) {
        case 'sabah':
        case 'fajr':
          return const Color(0xFFFF9800); // TR: Turuncu // EN: Orange
        case 'öğle':
        case 'dhuhr':
          return const Color(0xFF2196F3); // TR: Mavi // EN: Blue
        case 'ikindi':
        case 'asr':
          return const Color(0xFF4CAF50); // TR: Yeşil // EN: Green
        case 'akşam':
        case 'maghrib':
          return const Color(0xFFFF5722); // TR: Koyu turuncu // EN: Deep orange
        case 'yatsı':
        case 'isha':
          return const Color(0xFF9C27B0); // TR: Mor // EN: Purple
        default:
          return const Color(0xFF1A237E); // TR: İndigo // EN: Indigo
      }
    }

    return KubbeCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // TR: Vakit bilgisi
          // EN: Prayer information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TR: Mevcut vakit adı
                // EN: Current prayer name
                Text(
                  StringUtils.toTitleCase(currentPrayer),
                  style: poppinsFont.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: getPrayerColor(currentPrayer),
                  ),
                ),
                // TR: Vakit zamanı
                // EN: Prayer time
                Text(
                  prayerTime,
                  style: poppinsFont.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575), // TR: Gri // EN: Gray
                  ),
                ),
              ],
            ),
          ),

          // TR: Kalan süre
          // EN: Remaining time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // TR: Kalan süre etiketi
              // EN: Remaining time label
              Text(
                'Kalan',
                style: poppinsFont.copyWith(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(
                    0xFF9E9E9E,
                  ), // TR: Açık gri // EN: Light gray
                ),
              ),
              // TR: Kalan süre
              // EN: Remaining time
              Text(
                _formatTimeUntilNext(timeUntilNext),
                style: poppinsFont.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(
                    0xFF9C27B0,
                  ), // TR: KUBBE Mor // EN: KUBBE Purple
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
