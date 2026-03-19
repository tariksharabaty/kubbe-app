// TR: KUBBE V4 Ana Navigasyon - V4 standartları
// EN: KUBBE V4 Main Navigation - V4 standards
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: 5 Sekmeli Modern Alt Bar: [Ev, Kur'an, Kumo AI (Merkezde hafif taşmış ve parlayan FAB), İbadetler, Kıble]
// EN: 5 Section Modern Bottom Bar: [Home, Quran, Kumo AI (Center elevated and glowing FAB), Worship, Qibla]
// TR: AppBar Tasarımı: 'ic_kubbe_logo'yu (36dp) merkeze al. Logonun renklerini korumak için 'ColorFilter' kullanma (Unspecified)
// EN: AppBar Design: Center 'ic_kubbe_logo' (36dp). Don't use 'ColorFilter' to preserve logo colors (Unspecified)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/components/lottie_manager.dart';
import '../home/home_screen.dart';
import '../quran/quran_surah_list_screen.dart';
import '../ai/kumo_chat_screen.dart';
import '../worship/screens/worship_screen.dart';
import '../worship/qibla/qibla_screen.dart';

/// TR: KUBBE V4 Ana Navigasyon Sınıfı
/// EN: KUBBE V4 Main Navigation Class
/// TR: 5 butonlu BottomBar ve merkez FAB ile modern navigasyon
/// EN: Modern navigation with 5-button BottomBar and center FAB
/// TR: Kumo AI butonu merkezde, hafifçe yukarı taşmış ve Indigo parlamalı
/// EN: Kumo AI button in center, slightly elevated and Indigo glowing
/// TR: V1'den miras alınan navigasyon mantığı V4 estetiğiyle modernize edildi
/// EN: Navigation logic inherited from V1 modernized with V4 aesthetics
class AnaNavigasyon extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const AnaNavigasyon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TR: Mevcut indeks
    // EN: Current index
    final currentIndex = ref.watch(_currentIndexProvider);

    return Scaffold(
      // TR: Ekran içeriği - Optimize IndexedStack
      // EN: Screen content - Optimized IndexedStack
      body: IndexedStack(
        key: ValueKey<int>(currentIndex),
        index: currentIndex,
        children: _screens,
      ),

      // TR: AppBar - KUBBE logo ile
      // EN: AppBar - with KUBBE logo
      appBar: AppBar(
        // TR: AppBar rengi
        // EN: AppBar color
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // TR: Gölge kaldır
        // EN: Remove shadow
        elevation: 0,
        // TR: Toolbar
        // EN: Toolbar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TR: KUBBE Logo - 36dp olarak ortalanmış
            // EN: KUBBE Logo - 36dp centered
            // TR: LottieManager ile ic_kubbe_logo.png, yoksa placeholder
            // EN: ic_kubbe_logo.png with LottieManager, placeholder if missing
            LottieManager.buildLogo(
              width: 36,
              height: 36,
            ),
          ],
        ),
        // TR: Ortalanmış başlık
        // EN: Centered title
        centerTitle: true,
      ),

      // TR: Bottom Navigation Bar ve Center FAB
      // EN: Bottom Navigation Bar and Center FAB
      bottomNavigationBar: Stack(
        children: [
          // TR: Bottom Navigation Bar
          // EN: Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80, // TR: Yükseklik // EN: Height
              decoration: BoxDecoration(
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(
                      context,
                    ).scaffoldBackgroundColor.withValues(alpha: 0.95),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                // TR: Üst gölge
                // EN: Top shadow
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              // TR: BottomBar içeriği
              // EN: BottomBar content
              child: Row(
                children: [
                  // TR: Sol bölüm - 2 sekme
                  // EN: Left section - 2 sections
                  Expanded(
                    child: Row(
                      children: [
                        // TR: Ana Sayfa
                        // EN: Home
                        Expanded(child: _buildBottomBarItem(0, context, ref)),
                        // TR: Kur'an
                        // EN: Quran
                        Expanded(child: _buildBottomBarItem(1, context, ref)),
                      ],
                    ),
                  ),

                  // TR: Merkez boşluk - FAB için
                  // EN: Center space - for FAB
                  const Expanded(
                    child: SizedBox(), // TR: Boşluk // EN: Empty space
                  ),

                  // TR: Sağ bölüm - 2 sekme
                  // EN: Right section - 2 sections
                  Expanded(
                    child: Row(
                      children: [
                        // TR: İbadetler
                        // EN: Worship
                        Expanded(child: _buildBottomBarItem(3, context, ref)),
                        // TR: Kıble
                        // EN: Qibla
                        Expanded(child: _buildBottomBarItem(4, context, ref)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TR: Merkez Kumo AI FAB
          // EN: Center Kumo AI FAB
          Positioned(
            bottom: 20, // TR: Yükseltme // EN: Elevation
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // TR: Haptic geri bildirim
                  // EN: Haptic feedback
                  HapticFeedback.lightImpact();

                  // TR: Kumo AI ekranına git
                  // EN: Navigate to Kumo AI screen
                  ref.read(_currentIndexProvider.notifier).state =
                      2; // TR: Kumo AI indeksi // EN: Kumo AI index
                },
                // TR: FAB container
                // EN: FAB container
                child: Container(
                  width: 64, // TR: Genişlik // EN: Width
                  height: 64, // TR: Yükseklik // EN: Height
                  decoration: BoxDecoration(
                    // TR: Gradient arka plan
                    // EN: Gradient background
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFF3949AB), // TR: Indigo // EN: Indigo
                        Color(
                          0xFF5E35B1,
                        ), // TR: Koyu Indigo // EN: Dark Indigo
                      ],
                    ),
                    // TR: Yuvarlak köşeler
                    // EN: Rounded corners
                    borderRadius: BorderRadius.circular(32),
                    // TR: Parlayan gölge
                    // EN: Glowing shadow
                    boxShadow: [
                      // TR: İç gölge
                      // EN: Inner shadow
                      BoxShadow(
                        color: const Color(0xFF3949AB).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 0),
                        spreadRadius: 2,
                      ),
                      // TR: Dış gölge
                      // EN: Outer shadow
                      BoxShadow(
                        color: const Color(0xFF3949AB).withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  // TR: FAB içeriği
                  // EN: FAB content
                  child: Stack(
                    children: [
                      // TR: Parlama efekti
                      // EN: Glow effect
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            // TR: Parlama gradient
                            // EN: Glow gradient
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.3),
                                Colors.transparent,
                              ],
                            ),
                            // TR: Yuvarlak köşeler
                            // EN: Rounded corners
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                      // TR: Kumo AI ikonu - LottieManager ile logo veya placeholder
                      // EN: Kumo AI icon - logo or placeholder with LottieManager
                      Center(
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            // TR: Parlayan gölge
                            // EN: Glowing shadow
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 0),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          // TR: Kumo AI ikonu - ic_kumo_logo.png ile fallback
                          // EN: Kumo AI icon - ic_kumo_logo.png with fallback
                          child: Image.asset(
                            'assets/icons/ic_kumo_logo.png',
                            width: 28,
                            height: 28,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.smart_toy,
                                color: Colors.white,
                                size: 28,
                              );
                            },
                          ),
                        ),
                      ),
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

  // TR: Ekran listesi - 5 sekme
  // EN: Screen list - 5 sections
  static final List<Widget> _screens = [
    // TR: Ana Sayfa
    // EN: Home
    const HomeScreen(),

    // TR: Kur'an - Surah listesi
    // EN: Quran - Surah list
    const QuranSurahListScreen(),

    // TR: Kumo AI (Merkez FAB)
    // EN: Kumo AI (Center FAB)
    const KumoChatScreen(),

    // TR: İbadetler
    // EN: Worship
    const WorshipScreen(),

    // TR: Kıble
    // EN: Qibla
    const QiblaScreen(),
  ];

  // TR: BottomBar ikonları
  // EN: BottomBar icons
  static const List<IconData> _bottomBarIcons = [
    Icons.home, // TR: Ana Sayfa // EN: Home
    Icons.menu_book, // TR: Kur'an // EN: Quran
    Icons.smart_toy, // TR: Kumo AI // EN: Kumo AI (placeholder)
    Icons.mosque, // TR: İbadetler // EN: Worship
    Icons.explore, // TR: Kıble // EN: Qibla
  ];

  // TR: BottomBar etiketleri
  // EN: BottomBar labels
  static const List<String> _bottomBarLabels = [
    'Ana Sayfa', // TR: Ana Sayfa // EN: Home
    'Kur\'an', // TR: Kur'an // EN: Quran
    'Kumo AI', // TR: Kumo AI // EN: Kumo AI
    'İbadetler', // TR: İbadetler // EN: Worship
    'Kıble', // TR: Kıble // EN: Qibla
  ];

  // TR: Current index provider
  // EN: Current index provider
  static final _currentIndexProvider = StateProvider<int>((ref) => 0);

  // TR: BottomBar öğesi oluşturur
  // EN: Builds BottomBar item
  Widget _buildBottomBarItem(int index, BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(_currentIndexProvider);
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        // TR: Haptic geri bildirim
        // EN: Haptic feedback
        HapticFeedback.lightImpact();

        // TR: Kumo AI için merkez FAB kullan, değilse normal geçiş
        // EN: Use center FAB for Kumo AI, normal transition otherwise
        if (index == 2) {
          return; // TR: Kumo AI FAB ile yönetilir // EN: Managed by Kumo AI FAB
        }
        // TR: State'i güncelle
        // EN: Update state
        ref.read(_currentIndexProvider.notifier).state = index;
      },
      // TR: BottomBar öğesi
      // EN: BottomBar item
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TR: İkon
          // EN: Icon
          Icon(
            _bottomBarIcons[index],
            color: isSelected
                ? KubbeTheme
                    .kubbeIndigo // TR: Seçili rengi // EN: Selected color
                : Colors.grey.withValues(
                    alpha: 0.6,
                  ), // TR: Seçili olmayan rengi // EN: Unselected color
            size: 24, // TR: İkon boyutu // EN: Icon size
          ),
          // TR: İkon ile metin arası boşluk
          // EN: Space between icon and text
          const SizedBox(height: 4.0),
          // TR: Metin
          // EN: Text
          Text(
            _bottomBarLabels[index],
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? KubbeTheme
                      .kubbeIndigo // TR: Seçili rengi // EN: Selected color
                  : Colors.grey.withValues(
                      alpha: 0.6,
                    ), // TR: Seçili olmayan rengi // EN: Unselected color
            ),
          ),
        ],
      ),
    );
  }
}
