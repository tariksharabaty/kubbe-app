// TR: KUBBE V4 Worship Hub - V1'den miras alındı
// EN: KUBBE V4 Worship Hub - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: 'İbadetler' sekmesi için ana merkez
// EN: Main center for 'Worship' tab
// TR: Grid yapısında (2 sütun) büyük kartlar: [Zikirmatik, Namaz Takibi, Kıble, Zekatmatik]
// EN: Large cards in grid layout (2 columns): [Zikirmatik, Prayer Tracking, Qibla, Zekatmatik]
// TR: Her kart 32dp radius ve hafif mor gölgeye sahip olmalı
// EN: Each card should have 32dp radius and light purple shadow

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptic_utils.dart';
import 'zikirmatik/zikirmatik_screen.dart';
import 'tracker/lale_bahcesi_screen.dart';
import 'qibla/qibla_screen.dart';
import 'zekat/zekat_screen.dart';

/// TR: KUBBE V4 Worship Hub Widget'ı
/// EN: KUBBE V4 Worship Hub Widget
/// TR: V1'deki ibadet mantığını modern Flutter ile birleştirir
/// EN: Combines V1's worship logic with modern Flutter
/// TR: Grid yapısında büyük kartlar ve V4 estetiği
/// EN: Large cards in grid layout with V4 aesthetics
/// TR: 32dp radius ve hafif mor gölge
/// EN: 32dp radius and light purple shadow
/// TR: Sy-OS design language
/// EN: Sy-OS design language
class WorshipScreen extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const WorshipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'İbadetler',
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
          // TR: Yardım ikonu
          // EN: Help icon
          IconButton(
            onPressed: () {
              // TR: Yardım dialog'u göster
              // EN: Show help dialog
              _showHelpDialog(context);
            },
            // TR: İkon
            // EN: Icon
            icon: const Icon(Icons.help, color: Colors.white, size: 24),
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
              _buildTopInfo(context),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 20.0),

              // TR: Grid kartları
              // EN: Grid cards
              Expanded(
                // TR: Grid kartları listesi
                // EN: Grid cards list
                child: _buildGridCards(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TR: Üst bilgi bölümü oluştur
  // EN: Build top info section
  Widget _buildTopInfo(BuildContext context) {
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
            'İbadetler Merkezi',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 8.0),

          // TR: Açıklama
          // EN: Description
          Text(
            'Dini ibadetlerinizi takip edin ve tamamlayın. Zikirmatik, namaz takibi ve daha fazlası.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // TR: Grid kartları oluştur
  // EN: Build grid cards
  Widget _buildGridCards(BuildContext context) {
    // TR: İbadet kartları bilgileri
    // EN: Worship cards information
    final worshipCards = [
      {
        'title': 'Zikirmatik',
        'subtitle': 'Tesbih ve zikir sayacı',
        'icon': Icons.favorite,
        'color': const Color(0xFFFF5722),
        'screen': const EliteZikirmatikScreen(),
        'description': '33 ve 99 sayılarında özel titreşimler',
      },
      {
        'title': 'Namaz Takibi',
        'subtitle': 'Lale Bahçesi',
        'icon': Icons.access_time,
        'color': const Color(0xFF4CAF50),
        'screen': const LaleBahcesiScreen(),
        'description': '5 vakit namaz takibi ve istatistikler',
      },
      {
        'title': 'Kıble',
        'subtitle': 'Kıble yönü bulma',
        'icon': Icons.explore,
        'color': const Color(0xFF2196F3),
        'screen': const QiblaScreen(),
        'description': 'GPS ile kıble yönü belirleme',
      },
      {
        'title': 'Zekatmatik',
        'subtitle': 'Zekat hesaplama',
        'icon': Icons.calculate,
        'color': const Color(0xFF9C27B0),
        'screen': const ZekatmatikScreen(),
        'description': 'Zekat ve sadaka hesaplama araçları',
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
        childAspectRatio: 1.1,
      ),
      // TR: Eleman sayısı
      // EN: Item count
      itemCount: worshipCards.length,
      // TR: Builder
      // EN: Builder
      itemBuilder: (context, index) {
        final card = worshipCards[index];

        // TR: İbadet kartı
        // EN: Worship card
        return GestureDetector(
          // TR: Dokunma
          // EN: On tap
          onTap: () {
            // TR: Titreşim ver
            // EN: Give haptic feedback
            HapticUtils.mediumImpact();

            // TR: Sayfaya git
            // EN: Navigate to screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => card['screen'] as Widget),
            );
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
              // TR: Hafif mor gölge
              // EN: Light purple shadow
              boxShadow: [
                BoxShadow(
                  color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.2),
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
                // TR: İkon
                // EN: Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    // TR: Yuvarlak
                    // EN: Circle
                    shape: BoxShape.circle,
                    // TR: Gradient arka plan
                    // EN: Gradient background
                    gradient: LinearGradient(
                      colors: [
                        card['color'] as Color,
                        (card['color'] as Color).withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    // TR: Hafif gölge
                    // EN: Light shadow
                    boxShadow: [
                      BoxShadow(
                        color: (card['color'] as Color).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  // TR: İkon içeriği
                  // EN: Icon content
                  child: Center(
                    // TR: İkon
                    // EN: Icon
                    child: Icon(
                      card['icon'] as IconData,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(height: 16.0),

                // TR: Başlık
                // EN: Title
                Text(
                  card['title'] as String,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                ),

                // TR: Alt başlık
                // EN: Subtitle
                Text(
                  card['subtitle'] as String,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(height: 8.0),

                // TR: Açıklama
                // EN: Description
                Text(
                  card['description'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.grey.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // TR: Yardım dialog'u göster
  // EN: Show help dialog
  void _showHelpDialog(BuildContext context) {
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
            'İbadetler Yardım',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),
          // TR: İçerik
          // EN: Content
          content: Column(
            // TR: Ana içerik
            // EN: Main content
            mainAxisSize: MainAxisSize.min,
            children: [
              // TR: Zikirmatik açıklaması
              // EN: Zikirmatik description
              ListTile(
                // TR: Başlık
                // EN: Title
                title: Text(
                  'Zikirmatik',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // TR: Alt başlık
                // EN: Subtitle
                subtitle: Text(
                  '33 ve 99 sayılarında özel titreşimler ile zikir sayacı',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                ),
                // TR: İkon
                // EN: Icon
                leading: const Icon(Icons.favorite, color: Color(0xFFFF5722)),
              ),

              // TR: Namaz Takibi açıklaması
              // EN: Prayer Tracking description
              ListTile(
                // TR: Başlık
                // EN: Title
                title: Text(
                  'Namaz Takibi',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // TR: Alt başlık
                // EN: Subtitle
                subtitle: Text(
                  '5 vakit namaz takibi ve istatistikler',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                ),
                // TR: İkon
                // EN: Icon
                leading: const Icon(
                  Icons.access_time,
                  color: Color(0xFF4CAF50),
                ),
              ),

              // TR: Kıble açıklaması
              // EN: Qibla description
              ListTile(
                // TR: Başlık
                // EN: Title
                title: Text(
                  'Kıble',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // TR: Alt başlık
                // EN: Subtitle
                subtitle: Text(
                  'GPS ile kıble yönü belirleme',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                ),
                // TR: İkon
                // EN: Icon
                leading: const Icon(Icons.explore, color: Color(0xFF2196F3)),
              ),

              // TR: Zekatmatik açıklaması
              // EN: Zekatmatik description
              ListTile(
                // TR: Başlık
                // EN: Title
                title: Text(
                  'Zekatmatik',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // TR: Alt başlık
                // EN: Subtitle
                subtitle: Text(
                  'Zekat ve sadaka hesaplama araçları',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                ),
                // TR: İkon
                // EN: Icon
                leading: const Icon(Icons.calculate, color: Color(0xFF9C27B0)),
              ),
            ],
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
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
