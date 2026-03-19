// TR: KUBBE V4 Bottom Navigation - YouTube inspired design
// EN: KUBBE V4 Bottom Navigation - YouTube inspired design
// TR: 5 butonlu modern alt navigasyon
// EN: 5-button modern bottom navigation

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

/// TR: Bottom Navigation Item Model
/// EN: Bottom Navigation Item Model
class BottomNavItem {
  final IconData icon;
  final String label;
  final int index;
  final bool isSpecial;

  const BottomNavItem({
    required this.icon,
    required this.label,
    required this.index,
    this.isSpecial = false,
  });
}

/// TR: KUBBE V4 Bottom Navigation Bar
/// EN: KUBBE V4 Bottom Navigation Bar
/// TR: YouTube inspired tasarımlı modern alt navigasyon
/// EN: Modern bottom navigation with YouTube inspired design
class KubbeBottomNavigation extends ConsumerWidget {
  const KubbeBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final Function(int) onItemSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        // TR: Blur efekti ile arka plan
        // EN: Background with blur effect
        color: isDark
            ? Colors.black.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -2),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32.0),
          bottom: Radius.zero,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20,
            sigmaY: 20,
            tileMode: TileMode.clamp,
          ),
          child: Container(
            decoration: BoxDecoration(
              // TR: İç arka plan
              // EN: Inner background
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.5),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      _buildNavItems(selectedIndex, onItemSelected, isDark),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TR: Navigasyon öğelerini oluştur
  // EN: Build navigation items
  List<Widget> _buildNavItems(
      int selectedIndex, Function(int) onItemSelected, bool isDark) {
    final navItems = [
      const BottomNavItem(
        icon: Icons.home_rounded,
        label: 'Ana Sayfa',
        index: 0,
      ),
      const BottomNavItem(
        icon: Icons.menu_book_rounded,
        label: 'Kur\'an',
        index: 1,
      ),
      const BottomNavItem(
        icon: Icons.add_circle_rounded,
        label: 'Kumlu',
        index: 2,
        isSpecial: true, // TR: Özel buton // EN: Special button
      ),
      const BottomNavItem(
        icon: Icons.explore_rounded,
        label: 'Kıble',
        index: 3,
      ),
      const BottomNavItem(
        icon: Icons.collections_bookmark_rounded,
        label: 'Kütüphane',
        index: 4,
      ),
    ];

    return navItems.map((item) {
      final isActive = selectedIndex == item.index;

      return Expanded(
        child: GestureDetector(
          onTap: () => onItemSelected(item.index),
          child: Container(
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              // TR: Aktif buton rengi
              // EN: Active button color
              color: isActive
                  ? KubbeTheme.kubbeIndigo.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16.0),
              // TR: Özel buton için vurgu
              // EN: Emphasis for special button
              border: item.isSpecial
                  ? Border.all(
                      color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.5),
                      width: 2,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TR: İkon
                // EN: Icon
                Icon(
                  item.icon,
                  size: 24,
                  color: isActive
                      ? KubbeTheme.kubbeIndigo
                      : (item.isSpecial
                          ? KubbeTheme.kubbeIndigo.withValues(alpha: 0.8)
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.black.withValues(alpha: 0.6))),
                ),

                // TR: Sadece aktif butonda etiket göster
                // EN: Show label only on active button
                if (isActive) ...[
                  const SizedBox(height: 2.0),
                  Text(
                    item.label,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: KubbeTheme.kubbeIndigo,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}

/// TR: MainWrapper - Bottom Navigation ile ana scaffold
/// EN: MainWrapper - Main scaffold with bottom navigation
class MainWrapper extends ConsumerWidget {
  const MainWrapper({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onNavigationChanged,
  });

  final Widget child;
  final int selectedIndex;
  final Function(int) onNavigationChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // TR: Ana içerik
      // EN: Main content
      body: child,

      // TR: Alt navigasyon
      // EN: Bottom navigation
      bottomNavigationBar: KubbeBottomNavigation(
        selectedIndex: selectedIndex,
        onItemSelected: onNavigationChanged,
      ),

      // TR: Extend body alt navigasyonun altına kadar
      // EN: Extend body to bottom of navigation
      extendBody: true,

      // TR: Body altına boşluk ekle
      // EN: Add padding below body
      resizeToAvoidBottomInset: true,
    );
  }
}

/// TR: Navigation Controller - Navigasyon durumunu yönetir
/// EN: Navigation Controller - Manages navigation state
class NavigationController extends Notifier<int> {
  @override
  int build() => 0; // TR: Başlangıçta Ana Sayfa // EN: Start with Home

  // TR: Sayfayı değiştir
  // EN: Change page
  void selectPage(int index) {
    state = index;
  }
}

// TR: Navigation Provider
// EN: Navigation Provider
final navigationProvider = NotifierProvider<NavigationController, int>(
  () => NavigationController(),
);
