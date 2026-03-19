// TR: KUBBE V4 Home Screen - V4 standartları
// EN: KUBBE V4 Home Screen - V4 standards
// TR: 'LazyColumn' veya 'SingleChildScrollView' ile akışkan (scrollable) yapı
// EN: Scrollable structure with 'LazyColumn' or 'SingleChildScrollView'
// TR: En üstte 'ic_kubbe_logo'lu şık AppBar, altında 'Vakit Kartı', 'Zaman Kubbesi' ve 'Günün Ayeti'
// EN: 'ic_kubbe_logo' AppBar at top, 'Prayer Card', 'Time Dome' and 'Verse of the Day' below
// TR: V1'den miras alınan ana ekran mantığı V4 estetiğiyle modernize edildi
// EN: Home screen logic inherited from V1 modernized with V4 aesthetics

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/components/kubbe_card.dart';
import '../../core/components/vakit_karti.dart';
import '../../core/services/prayer_service.dart';
import '../../core/storage/preferences_manager.dart';
import '../../core/theme/app_theme.dart';
import '../../features/history/data/sultan_repository.dart';
import '../../features/history/data/daily_content_repository.dart';

/// TR: KUBBE V4 Home Screen Sınıfı
/// EN: KUBBE V4 Home Screen Class
/// TR: Akışkan yapıda tüm ana bileşenleri bir araya getiren modern ana ekran
/// EN: Modern home screen that brings all main components together in a scrollable structure
/// TR: Vakit kartı, zaman kubbesi ve günlük içerik ile zengin kullanıcı deneyimi
/// EN: Rich user experience with prayer card, time dome and daily content
class HomeScreen extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      // TR: AppBar - KUBBE logo ile
      // EN: AppBar - with KUBBE logo
      appBar: AppBar(
        // TR: AppBar rengi
        // EN: AppBar color
        backgroundColor: theme.scaffoldBackgroundColor,
        // TR: Gölge kaldır
        // EN: Remove shadow
        elevation: 0,
        // TR: Toolbar
        // EN: Toolbar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TR: KUBBE Logo - Elite görünüme kavuşturulmuş
            // EN: KUBBE Logo - Enhanced with Elite appearance
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
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
                // TR: Yuvarlak köşeler
                // EN: Rounded corners
                borderRadius: BorderRadius.circular(20),
                // TR: Hafif gölge
                // EN: Light shadow
                boxShadow: [
                  BoxShadow(
                    color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 2,
                  ),
                ],
              ),
              // TR: Logo içeriği - Image.asset ile güvenli hale getirilmiş
              // EN: Logo content - with Image.asset safely wrapped
              child: Image.asset(
                'assets/icons/ic_kubbe_logo.png',
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  // TR: Hata durumunda uygulama çökmesin, güvenli fallback göster
                  // EN: Don't crash app on error, show safe fallback
                  return const SizedBox(
                    height: 40,
                    child: Icon(
                      Icons.mosque,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        // TR: Ortalanmış başlık
        // EN: Centered title
        centerTitle: true,
      ),

      // TR: Ana içerik - Scrollable yapı
      // EN: Main content - Scrollable structure
      body: RefreshIndicator(
        // TR: Refresh callback
        // EN: Refresh callback
        onRefresh: () async {
          // TR: Vakit verilerini yeniden yükle
          // EN: Reload prayer data
          final (latitude, longitude) =
              await PreferencesManager.getLastKnownLocation();
          if (latitude == null || longitude == null) {
            await PrayerService.saveLocationAndCalculate(
              latitude: 41.0082,
              longitude: 28.9784,
              cityName: 'İstanbul',
            );
          }
        },
        // TR: Scrollable içerik
        // EN: Scrollable content
        child: ListView.builder(
          // TR: Fiziksel scroll behavior
          // EN: Physics scroll behavior
          physics: const BouncingScrollPhysics(),
          // TR: Ana içerik padding
          // EN: Main content padding
          padding: const EdgeInsets.all(16.0),
          // TR: Item count
          // EN: Item count
          itemCount: 1,
          // TR: Item builder
          // EN: Item builder
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TR: Vakit Kartı - En üstte
                // EN: Prayer Card - At the top
                const VakitKarti(),

                // TR: Vakit kartı ile diğer içerik arası boşluk
                // EN: Space between prayer card and other content
                const SizedBox(height: 20.0),

                // TR: Zaman Kubbesi - Editoryal Büyük Kart
                // EN: Time Dome - Editorial Large Card
                KubbeTitledCard(
                  title: 'Zaman Kubbesi',
                  margin: const EdgeInsets.only(bottom: 20.0),
                  onTap: () {
                    // TR: Zaman Kubbesi ekranına git
                    // EN: Navigate to Time Dome screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Zaman Kubbesi açılıyor...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  // TR: Zaman Kubbesi içeriği
                  // EN: Time Dome content
                  child: _buildTimeDomeContent(),
                ),

                // TR: Günün Ayeti - Editoryal Kart
                // EN: Verse of the Day - Editorial Card
                KubbeTitledCard(
                  title: 'Günün Ayeti',
                  margin: const EdgeInsets.only(bottom: 20.0),
                  onTap: () {
                    // TR: Ayet detay ekranına git
                    // EN: Navigate to verse details screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ayet detayları açılıyor...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  // TR: Ayet içeriği
                  // EN: Verse content
                  child: _buildVerseContent(),
                ),

                // TR: Hızlı Eylemler - Mini kartlar
                // EN: Quick Actions - Mini cards
                Row(
                  children: [
                    // TR: Sol kolon
                    // EN: Left column
                    Expanded(
                      child: KubbeIconCard(
                        icon: Icons.mosque,
                        title: 'Zikir',
                        // TR: Zikir içeriği
                        // EN: Zikir content
                        child: _buildZikirContent(ref),
                        onTap: () {
                          // TR: Zikir ekranına git
                          // EN: Navigate to zikir screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Zikir sayacı açılıyor...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),

                    // TR: Kartlar arası boşluk
                    // EN: Space between cards
                    const SizedBox(width: 12.0),

                    // TR: Sağ kolon
                    // EN: Right column
                    Expanded(
                      child: KubbeIconCard(
                        icon: Icons.book,
                        title: 'Okuma',
                        // TR: Okuma içeriği
                        // EN: Reading content
                        child: _buildReadingContent(ref),
                        onTap: () {
                          // TR: Kur'an ekranına git
                          // EN: Navigate to Quran screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kur\'an açılıyor...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // TR: İstatistikler - Geniş kart
                // EN: Statistics - Wide card
                KubbeTitledCard(
                  title: 'Bugün',
                  margin: const EdgeInsets.only(bottom: 20.0),
                  // TR: İstatistik içeriği
                  // EN: Statistics content
                  child: _buildStatisticsContent(),
                ),

                // TR: Alt boşluk - Bottom padding
                // EN: Bottom padding
                const SizedBox(height: 100.0),
              ],
            );
          },
        ),
      ),
    );
  }

  // TR: Zaman Kubbesi içeriği
  // EN: Time Dome content
  static Widget _buildTimeDomeContent() {
    // TR: Günlük medeniyet bilgisi - Güvenlik kontrolü ile
    // EN: Daily civilization information - with safety check
    try {
      final dailyMedeniyet = SultanRepository.getDailyInfo();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TR: Medeniyet bilgisi
          // EN: Civilization information
          Text(
            dailyMedeniyet.baslik,
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: const Color(
                0xFF1A237E,
              ), // TR: KUBBE İndigo // EN: KUBBE Indigo
            ),
          ),
          // TR: Başlık ile açıklama arası boşluk
          // EN: Space between title and description
          const SizedBox(height: 8.0),
          // TR: Açıklama
          // EN: Description
          Text(
            dailyMedeniyet.aciklama,
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              color: const Color(0xFF757575), // TR: Gri // EN: Gray
              height: 1.4,
            ),
          ),
          // TR: Açıklama ile özellikler arası boşluk
          // EN: Space between description and features
          const SizedBox(height: 12.0),
          // TR: Özellikler
          // EN: Features
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: dailyMedeniyet.ozellikler.take(3).map((ozellik) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  // TR: Özellik arka planı
                  // EN: Feature background
                  color: const Color(
                    0xFFF3E5F5,
                  ), // TR: Açık mavi // EN: Light blue
                  borderRadius: BorderRadius.circular(16.0),
                ),
                // TR: Özellik metni
                // EN: Feature text
                child: Text(
                  ozellik,
                  style: GoogleFonts.poppins(
                    fontSize: 12.0,
                    color: const Color(0xFF1976D2), // TR: Mavi // EN: Blue
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    } catch (e) {
      // TR: Hata durumunda boş widget dön
      // EN: Return empty widget on error
      return const SizedBox();
    }
  }

  // TR: Ayet içeriği
  // EN: Verse content
  static Widget _buildVerseContent() {
    // TR: Günlük içerik bilgisi - güvenlik kontrolü ile
    // EN: Daily verse information - with safety check
    try {
      final dailyContent = DailyContentRepository.getDailyContent();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TR: Sure ve ayet bilgisi
          // EN: Surah and verse information
          Text(
            '${dailyContent.ayet.sure} ${dailyContent.ayet.ayetNo}. Ayet',
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: const Color(
                0xFF1A237E,
              ), // TR: KUBBE İndigo // EN: KUBBE Indigo
            ),
          ),
          // TR: Bilgi ile ayet arası boşluk
          // EN: Space between info and verse
          const SizedBox(height: 12.0),
          // TR: Ayet metni
          // EN: Verse text
          Text(
            dailyContent.ayet.turkceMeali,
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              color: const Color(0xFF424242), // TR: Koyu gri // EN: Dark gray
              height: 1.6,
            ),
          ),
          // TR: Ayet ile konu arası boşluk
          // EN: Space between verse and topic
          const SizedBox(height: 12.0),
          // TR: Konu
          // EN: Topic
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              // TR: Konu arka planı
              // EN: Topic background
              color:
                  const Color(0xFFE8F5E8), // TR: Açık yeşil // EN: Light green
              borderRadius: BorderRadius.circular(16.0),
            ),
            // TR: Konu metni
            // EN: Topic text
            child: Text(
              dailyContent.ayet.konu,
              style: GoogleFonts.poppins(
                fontSize: 12.0,
                color: const Color(0xFF2E7D32), // TR: Yeşil // EN: Green
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      // TR: Hata durumunda boş widget dön
      // EN: Return empty widget on error
      return const SizedBox();
    }
  }

  // TR: Zikir içeriği
  // EN: Zikir content
  static Widget _buildZikirContent(WidgetRef ref) {
    // TR: Zikir sayacı
    // EN: Zikir counter
    final zikirCounter = ref.watch(zikirCounterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TR: Zikir sayacı
        // EN: Zikir counter
        Text(
          '$zikirCounter',
          style: GoogleFonts.poppins(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF9C27B0), // TR: KUBBE Mor // EN: KUBBE Purple
          ),
        ),
        // TR: Sayı ile etiket arası boşluk
        // EN: Space between number and label
        const SizedBox(height: 4.0),
        // TR: Etiket
        // EN: Label
        Text(
          'Bugün',
          style: GoogleFonts.poppins(
            fontSize: 12.0,
            color: const Color(0xFF9E9E9E), // TR: Açık gri // EN: Light gray
          ),
        ),
      ],
    );
  }

  // TR: Okuma içeriği
  // EN: Reading content
  static Widget _buildReadingContent(WidgetRef ref) {
    // TR: Son okunan sure
    // EN: Last read surah
    final lastReadSurah = ref.watch(lastReadSurahProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TR: Sure numarası
        // EN: Surah number
        Text(
          'Sure $lastReadSurah',
          style: GoogleFonts.poppins(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2196F3), // TR: Mavi // EN: Blue
          ),
        ),
        // TR: Sayı ile etiket arası boşluk
        // EN: Space between number and label
        const SizedBox(height: 4.0),
        // TR: Etiket
        // EN: Label
        Text(
          'Son Okunan',
          style: GoogleFonts.poppins(
            fontSize: 12.0,
            color: const Color(0xFF9E9E9E), // TR: Açık gri // EN: Light gray
          ),
        ),
      ],
    );
  }

  // TR: İstatistikler içeriği
  // EN: Statistics content
  static Widget _buildStatisticsContent() {
    return Row(
      children: [
        // TR: Sol sütun
        // EN: Left column
        Expanded(
          child: Column(
            children: [
              // TR: Namaz sayısı
              // EN: Prayer count
              _buildStatItem('Bugün 5 Vakit', Icons.mosque),
              // TR: Boşluk
              // EN: Space
              const SizedBox(height: 16.0),
              // TR: Zikir sayısı
              // EN: Zikir count
              _buildStatItem('33 Zikir', Icons.favorite),
            ],
          ),
        ),

        // TR: Sağ sütun
        // EN: Right column
        Expanded(
          child: Column(
            children: [
              // TR: Okuma süresi
              // EN: Reading progress
              _buildStatItem('15% Tamamlandı', Icons.book),
              // TR: Boşluk
              // EN: Space
              const SizedBox(height: 16.0),
              // TR: Haftalık hedef
              // EN: Weekly goal
              _buildStatItem('7/7 Gün', Icons.calendar_today),
            ],
          ),
        ),
      ],
    );
  }

  // TR: İstatistik öğesi
  // EN: Statistics item
  static Widget _buildStatItem(String title, IconData icon) {
    return Row(
      children: [
        // TR: İkon
        // EN: Icon
        Icon(
          icon,
          size: 20.0,
          color: const Color(0xFF9C27B0), // TR: KUBBE Mor // EN: KUBBE Purple
        ),
        // TR: İkon ile metin arası boşluk
        // EN: Space between icon and text
        const SizedBox(width: 8.0),
        // TR: Metin
        // EN: Text
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14.0,
            color: const Color(0xFF424242), // TR: Koyu gri // EN: Dark gray
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// TR: Provider'lar - Geçici çözüm
// EN: Providers - Temporary solution
// TR: Gerçek uygulama Riverpod provider'ları ile entegre edilecek
// EN: Will be integrated with Riverpod providers in the real application

// TR: Zikir sayacı provider
// EN: Zikir counter provider
final zikirCounterProvider = Provider<int>((ref) => 33);

// TR: Son okunan sure provider
// EN: Last read surah provider
final lastReadSurahProvider = Provider<int>((ref) => 1);
