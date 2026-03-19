// TR: KUBBE V4 Lale Bahçesi - Namaz Takibi Ekranı - V1'den miras alındı
// EN: KUBBE V4 Lale Bahçesi - Prayer Tracking Screen - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: 5 vakit namaz için 32dp radius'lu şık kartlar
// EN: 32dp radius elegant cards for 5 prayer times
// TR: V1'deki gibi her işaretlemede bir lale animasyonu veya ikon değişimi (Lottie desteğiyle)
// EN: Like V1, lottie animation or icon change on each marking (with Lottie support)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../tracker/prayer_tracker_provider.dart';

/// TR: KUBBE V4 Lale Bahçesi Widget'ı
/// EN: KUBBE V4 Lale Bahçesi Widget
/// TR: V1'deki namaz takibi mantığını modern Flutter ile birleştirir
/// EN: Combines V1's prayer tracking logic with modern Flutter
/// TR: 5 vakit namaz için şık kartlar ve lale animasyonları
/// EN: Elegant cards for 5 prayer times with lottie animations
/// TR: 32dp radius ve V4 estetiği
/// EN: 32dp radius and V4 aesthetics
/// TR: Sy-OS design language
/// EN: Sy-OS design language
class LaleBahcesiScreen extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const LaleBahcesiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TR: Namaz takibi durumunu izle
    // EN: Watch prayer tracker state
    final prayerTrackerState = ref.watch(prayerTrackerStateProvider);

    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'Lale Bahçesi',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // TR: Arka plan
        // EN: Background
        backgroundColor: KubbeTheme.kubbeIndigo,
        // TR: Gölge kaldır
        // EN: Remove shadow
        elevation: 0,
        // TR: Eylemler
        // EN: Actions
        actions: [
          // TR: İstatistikler ikonu
          // EN: Statistics icon
          IconButton(
            onPressed: () {
              // TR: İstatistikler dialog'u göster
              // EN: Show statistics dialog
              _showStatisticsDialog(context, ref);
            },
            // TR: İkon
            // EN: Icon
            icon: const Icon(
              Icons.bar_chart,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),

      // TR: Gövde
      // EN: Body
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // TR: Gradient arka plan
        // EN: Gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              KubbeTheme.kubbeIndigo,
              KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // TR: İçerik
        // EN: Content
        child: SafeArea(
          // TR: Ana içerik
          // EN: Main content
          child: Column(
            children: [
              // TR: Üst bilgi bölümü
              // EN: Top info section
              _buildTopInfo(context, ref, prayerTrackerState),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 20.0),

              // TR: Namaz kartları
              // EN: Prayer cards
              Expanded(
                // TR: Namaz kartları listesi
                // EN: Prayer cards list
                child: _buildPrayerCards(context, ref, prayerTrackerState),
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 20.0),

              // TR: Alt kontrol bölümü
              // EN: Bottom control section
              _buildBottomControls(context, ref, prayerTrackerState),
            ],
          ),
        ),
      ),
    );
  }

  // TR: Üst bilgi bölümü oluştur
  // EN: Build top info section
  Widget _buildTopInfo(
      BuildContext context, WidgetRef ref, PrayerTrackerState state) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(32.0),
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
      // TR: İçerik
      // EN: Content
      child: Column(
        children: [
          // TR: Başlık
          // EN: Title
          Text(
            'Namaz Takibi',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 8.0),

          // TR: İlerleme bilgisi
          // EN: Progress info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TR: Tamamlanan namazlar
              // EN: Completed prayers
              Column(
                children: [
                  Text(
                    'Tamamlanan',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    '${state.completedCount}/${state.totalCount}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              // TR: İlerleme yüzdesi
              // EN: Progress percentage
              Column(
                children: [
                  Text(
                    'İlerleme',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    '%${(ref.read(prayerTrackerProvider.notifier).getProgressPercentage() * 100).toInt()}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 16.0),

          // TR: İlerleme çubuğu
          // EN: Progress bar
          Container(
            width: double.infinity,
            height: 8.0,
            decoration: BoxDecoration(
              // TR: 16dp radius
              // EN: 16dp radius
              borderRadius: BorderRadius.circular(16.0),
              // TR: Arka plan
              // EN: Background
              color: Colors.white.withValues(alpha: 0.2),
            ),
            // TR: İlerleme
            // EN: Progress
            child: FractionallySizedBox(
              // TR: İlerleme yüzdesi
              // EN: Progress percentage
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  // TR: 16dp radius
                  // EN: 16dp radius
                  borderRadius: BorderRadius.circular(16.0),
                  // TR: Gradient
                  // EN: Gradient
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TR: Namaz kartları oluştur
  // EN: Build prayer cards
  Widget _buildPrayerCards(
    BuildContext context,
    WidgetRef ref,
    PrayerTrackerState state,
  ) {
    // TR: Namaz bilgileri
    // EN: Prayer information
    final prayers = [
      {
        'key': 'fajr',
        'name': 'İmsak',
        'icon': Icons.wb_sunny,
        'color': const Color(0xFF2196F3)
      },
      {
        'key': 'dhuhr',
        'name': 'Öğle',
        'icon': Icons.wb_sunny,
        'color': const Color(0xFF4CAF50)
      },
      {
        'key': 'asr',
        'name': 'İkindi',
        'icon': Icons.wb_cloudy,
        'color': const Color(0xFF9C27B0)
      },
      {
        'key': 'maghrib',
        'name': 'Akşam',
        'icon': Icons.nights_stay,
        'color': const Color(0xFFFF5722)
      },
      {
        'key': 'isha',
        'name': 'Yatsı',
        'icon': Icons.bedtime,
        'color': const Color(0xFF3F51B5)
      },
    ];

    // TR: Grid yapısı
    // EN: Grid layout
    return GridView.builder(
      // TR: Padding
      // EN: Padding
      padding: const EdgeInsets.all(16.0),
      // TR: Grid delegate
      // EN: Grid delegate
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.2,
      ),
      // TR: Eleman sayısı
      // EN: Item count
      itemCount: prayers.length,
      // TR: Builder
      // EN: Builder
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        final isCompleted = ref
            .read(prayerTrackerProvider.notifier)
            .getPrayerStatus(prayer['key'] as String);

        // TR: Namaz kartı
        // EN: Prayer card
        return GestureDetector(
          // TR: Dokunma
          // EN: On tap
          onTap: () {
            // TR: Namaz durumunu değiştir
            // EN: Toggle prayer status
            ref
                .read(prayerTrackerProvider.notifier)
                .togglePrayerStatus(prayer['key'] as String);
          },
          // TR: Kart
          // EN: Card
          child: Container(
            // TR: Kart dekorasyonu
            // EN: Card decoration
            decoration: BoxDecoration(
              // TR: 32dp radius
              // EN: 32dp radius
              borderRadius: BorderRadius.circular(32.0),
              // TR: Beyaz arka plan
              // EN: White background
              color: Colors.white,
              // TR: Gölge
              // EN: Shadow
              boxShadow: [
                BoxShadow(
                  color: (prayer['color'] as Color).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            // TR: İçerik
            // EN: Content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TR: İkon ve durum
                // EN: Icon and status
                Stack(
                  // TR: Alignment
                  // EN: Alignment
                  alignment: Alignment.center,
                  children: [
                    // TR: Namaz ikonu
                    // EN: Prayer icon
                    Icon(
                      prayer['icon'] as IconData,
                      color: isCompleted
                          ? (prayer['color'] as Color)
                          : (prayer['color'] as Color).withValues(alpha: 0.3),
                      size: 40,
                    ),

                    // TR: Tamamlanma durumu
                    // EN: Completion status
                    if (isCompleted)
                      // TR: Lale ikonu (geçici)
                      // EN: Lale icon (temporary)
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          // TR: Yuvarlak
                          // EN: Circle
                          shape: BoxShape.circle,
                          // TR: Yeşil arka plan
                          // EN: Green background
                          color: Colors.green,
                        ),
                        // TR: Beyaz ikon
                        // EN: White icon
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(height: 12.0),

                // TR: Namaz adı
                // EN: Prayer name
                Text(
                  prayer['name'] as String,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        isCompleted ? (prayer['color'] as Color) : Colors.grey,
                  ),
                ),

                // TR: Durum metni
                // EN: Status text
                Text(
                  isCompleted ? 'Tamamlandı' : 'Bekleniyor',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isCompleted
                        ? (prayer['color'] as Color).withValues(alpha: 0.7)
                        : Colors.grey.withValues(alpha: 0.7),
                  ),
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(height: 8.0),

                // TR: Durum göstergesi
                // EN: Status indicator
                Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    // TR: 16dp radius
                    // EN: 16dp radius
                    borderRadius: BorderRadius.circular(16.0),
                    // TR: Arka plan
                    // EN: Background
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                  // TR: Durum
                  // EN: Status
                  child: FractionallySizedBox(
                    // TR: Tamamlanma durumu
                    // EN: Completion status
                    alignment: isCompleted
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        // TR: 16dp radius
                        // EN: 16dp radius
                        borderRadius: BorderRadius.circular(16.0),
                        // TR: Renk
                        // EN: Color
                        color: isCompleted
                            ? (prayer['color'] as Color)
                            : Colors.grey.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // TR: Alt kontrol bölümü oluştur
  // EN: Build bottom control section
  Widget _buildBottomControls(
    BuildContext context,
    WidgetRef ref,
    PrayerTrackerState state,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(32.0),
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
      // TR: İçerik
      // EN: Content
      child: Column(
        children: [
          // TR: Kontrol butonları
          // EN: Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TR: Tümünü tamamla butonu
              // EN: Mark all as completed button
              GestureDetector(
                onTap: () {
                  // TR: Tüm namazları tamamlandı olarak işaretle
                  // EN: Mark all prayers as completed
                  ref
                      .read(prayerTrackerProvider.notifier)
                      .markAllPrayersCompleted();
                },
                // TR: Buton
                // EN: Button
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    // TR: Yuvarlak
                    // EN: Circle
                    shape: BoxShape.circle,
                    // TR: Yeşil arka plan
                    // EN: Green background
                    color: Colors.green.withValues(alpha: 0.2),
                  ),
                  // TR: İkon
                  // EN: Icon
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),

              // TR: Sıfırla butonu
              // EN: Reset button
              GestureDetector(
                onTap: () {
                  // TR: Tüm namazları sıfırla
                  // EN: Reset all prayers
                  ref.read(prayerTrackerProvider.notifier).resetAllPrayers();
                },
                // TR: Buton
                // EN: Button
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    // TR: Yuvarlak
                    // EN: Circle
                    shape: BoxShape.circle,
                    // TR: Kırmızı arka plan
                    // EN: Red background
                    color: Colors.red.withValues(alpha: 0.2),
                  ),
                  // TR: İkon
                  // EN: Icon
                  child: const Center(
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),

              // TR: İstatistikler butonu
              // EN: Statistics button
              GestureDetector(
                onTap: () {
                  // TR: İstatistikler dialog'u göster
                  // EN: Show statistics dialog
                  _showStatisticsDialog(context, ref);
                },
                // TR: Buton
                // EN: Button
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    // TR: Yuvarlak
                    // EN: Circle
                    shape: BoxShape.circle,
                    // TR: Mavi arka plan
                    // EN: Blue background
                    color: Colors.blue.withValues(alpha: 0.2),
                  ),
                  // TR: İkon
                  // EN: Icon
                  child: const Center(
                    child: Icon(
                      Icons.bar_chart,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 16.0),

          // TR: Durum metni
          // EN: Status text
          Text(
            ref.read(prayerTrackerProvider.notifier).areAllPrayersCompleted()
                ? '🌸 MashaAllah! Tüm namazlarınızı tamamlayarak Allah\'ın rızasına nail oldunuz.'
                : 'Namazlarınızı eksiksiz bırakmayın. Allah (cc) sizinle olsun.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // TR: İstatistikler dialog'u göster
  // EN: Show statistics dialog
  void _showStatisticsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      // TR: Dialog
      // EN: Dialog
      context: context,
      builder: (BuildContext context) {
        // TR: AlertDialog
        // EN: AlertDialog
        return AlertDialog(
          // TR: Başlık
          // EN: Title
          title: Text(
            'Namaz Takibi İstatistikleri',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),
          // TR: İçerik
          // EN: Content
          content: SizedBox(
            // TR: Boyut
            // EN: Size
            width: double.maxFinite,
            // TR: İçerik
            // EN: Content
            child: Column(
              // TR: Ana içerik
              // EN: Main content
              mainAxisSize: MainAxisSize.min,
              children: [
                // TR: Bugünkü durum
                // EN: Today's status
                ListTile(
                  // TR: Başlık
                  // EN: Title
                  title: Text(
                    'Bugün',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // TR: Alt başlık
                  // EN: Subtitle
                  subtitle: Text(
                    'Tamamlanan namazlar: ${ref.read(prayerTrackerStateProvider).completedCount}/${ref.read(prayerTrackerStateProvider).totalCount}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  // TR: İkon
                  // EN: Icon
                  trailing: const Icon(
                    Icons.today,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                ),

                // TR: Son 7 gün
                // EN: Last 7 days
                FutureBuilder(
                  // TR: Future builder
                  // EN: Future builder
                  future:
                      ref.read(prayerTrackerProvider.notifier).getStatistics(),
                  // TR: Builder
                  // EN: Builder
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final stats = snapshot.data!;
                      final last7Days =
                          stats['last7Days'] as List<Map<String, dynamic>>;

                      // TR: Son 7 gün başlığı
                      // EN: Last 7 days header
                      return Column(
                        // TR: Başlık
                        // EN: Header
                        children: [
                          // TR: Başlık metni
                          // EN: Title text
                          Text(
                            'Son 7 Gün',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: KubbeTheme.kubbeIndigo,
                            ),
                          ),

                          // TR: Liste
                          // EN: List
                          ...last7Days.map((day) => ListTile(
                                // TR: Başlık
                                // EN: Title
                                title: Text(
                                  _formatDate(DateTime.parse(day['date'])),
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                // TR: Alt başlık
                                // EN: Subtitle
                                subtitle: Text(
                                  '${day['completedCount']}/${day['totalCount']} namaz',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                // TR: İkon
                                // EN: Icon
                                trailing: const Icon(
                                  Icons.history,
                                  color: KubbeTheme.kubbeIndigo,
                                ),
                              )),
                        ],
                      );
                    } else {
                      // TR: Yükleniyor
                      // EN: Loading
                      return const Center(
                        // TR: Yükleniyor ikonu
                        // EN: Loading icon
                        child: CircularProgressIndicator(
                          color: KubbeTheme.kubbeIndigo,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // TR: Butonlar
          // EN: Actions
          actions: [
            // TR: Kapat butonu
            // EN: Close button
            TextButton(
              // TR: Metin
              // EN: Text
              onPressed: () {
                // TR: Dialog'u kapat
                // EN: Close dialog
                Navigator.of(context).pop();
              },
              // TR: Stil
              // EN: Style
              style: TextButton.styleFrom(
                // TR: Metin rengi
                // EN: Text color
                foregroundColor: KubbeTheme.kubbeIndigo,
              ),
              // TR: Metin
              // EN: Text
              child: Text(
                'Kapat',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
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

    return '${date.day} ${monthsTR[date.month - 1]}';
  }
}
