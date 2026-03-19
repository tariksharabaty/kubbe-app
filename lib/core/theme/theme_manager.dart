import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TR: Kubbe V4 Elite Theme Tiers - V4 Yeniliği
// EN: Kubbe V4 Elite Theme Tiers - V4 Innovation

/// TR: Tema Kademeleri
/// EN: Theme Tiers
enum ThemeTier {
  /// TR: Varsayılan Kademe (#4B0082 Mor)
  /// EN: Default Tier (#4B0082 Purple)
  defaultTier,

  /// TR: Ücretsiz Renkler (6 Renk)
  /// EN: Free Colors (6 Colors)
  freeTier,

  /// TR: Premium Desenler (10 Desen)
  /// EN: Premium Patterns (10 Patterns)
  premiumTier,

  /// TR: Elite Layoutlar (4 Dinamik Düzen)
  /// EN: Elite Layouts (4 Dynamic Layouts)
  eliteTier
}

/// TR: Elite Layout Çeşitleri
/// EN: Elite Layout Variations
enum EliteLayout {
  /// TR: Klasik One UI tarzı
  /// EN: Classic One UI style
  classic,

  /// TR: Minimal detaylar
  /// EN: Minimal details
  minimal,

  /// TR: Izgara odaklı düzen
  /// EN: Grid oriented layout
  grid,

  /// TR: Kart odaklı modern düzen
  /// EN: Card oriented modern layout
  card
}

/// TR: Tema Durumu Sınıfı
/// EN: Theme State Class
class ThemeState {
  final ThemeTier tier;
  final Color baseColor;
  final String? premiumPattern;
  final EliteLayout? eliteLayout;
  final ThemeMode themeMode;
  final bool isElite;

  ThemeState({
    required this.tier,
    required this.baseColor,
    this.premiumPattern,
    this.eliteLayout,
    this.themeMode = ThemeMode.system,
    this.isElite = false,
  });

  ThemeState copyWith({
    ThemeTier? tier,
    Color? baseColor,
    String? premiumPattern,
    EliteLayout? eliteLayout,
    ThemeMode? themeMode,
    bool? isElite,
  }) {
    return ThemeState(
      tier: tier ?? this.tier,
      baseColor: baseColor ?? this.baseColor,
      premiumPattern: premiumPattern ?? this.premiumPattern,
      eliteLayout: eliteLayout ?? this.eliteLayout,
      themeMode: themeMode ?? this.themeMode,
      isElite: isElite ?? this.isElite,
    );
  }
}

/// TR: Tema Yönetim Servisi
/// EN: Theme Management Service
class ThemeManager extends StateNotifier<ThemeState> {
  ThemeManager()
      : super(ThemeState(
          tier: ThemeTier.defaultTier,
          baseColor: const Color(0xFF4B0082),
          themeMode: ThemeMode.light,
        ));

  // TR: Sabit Renkler ve Desenler
  // EN: Constant Colors and Patterns

  static const List<Color> freeColors = [
    Color(0xFF4B0082), // Default Purple
    Color(0xFF2196F3), // Blue
    Color(0xFF4CAF50), // Green
    Color(0xFFF44336), // Red
    Color(0xFFFF9800), // Orange
    Color(0xFF009688), // Teal
  ];

  static const List<String> premiumPatterns = [
    'dots_pattern.png',
    'lines_pattern.png',
    'stars_pattern.png',
    'arabesque_1.png',
    'arabesque_2.png',
    'arabesque_3.png',
    'geometric_1.png',
    'geometric_2.png',
    'islamic_star.png',
    'night_sky.png',
  ];

  // TR: Metodlar
  // EN: Methods

  /// TR: Varsayılan temaya dön
  /// EN: Reset to default theme
  void setTierDefault() {
    state = state.copyWith(
      tier: ThemeTier.defaultTier,
      baseColor: const Color(0xFF4B0082),
      isElite: false,
      premiumPattern: null,
      eliteLayout: null,
    );
  }

  /// TR: Ücretsiz renk seç
  /// EN: Select free color
  void setTierFree(int index) {
    if (index < 0 || index >= freeColors.length) return;
    state = state.copyWith(
      tier: ThemeTier.freeTier,
      baseColor: freeColors[index],
      isElite: false,
      premiumPattern: null,
      eliteLayout: null,
    );
  }

  /// TR: Premium desen seç
  /// EN: Select premium pattern
  void setTierPremium(int index) {
    if (index < 0 || index >= premiumPatterns.length) return;
    state = state.copyWith(
      tier: ThemeTier.premiumTier,
      premiumPattern: premiumPatterns[index],
      isElite: false,
      eliteLayout: null,
    );
  }

  /// TR: Elite layout seç
  /// EN: Select elite layout
  void setTierElite(EliteLayout layout) {
    state = state.copyWith(
      tier: ThemeTier.eliteTier,
      isElite: true,
      eliteLayout: layout,
    );
  }

  /// TR: Tema modunu ayarla (Açık/Koyu)
  /// EN: Set theme mode (Light/Dark)
  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  /// TR: Elite asset klasör yolunu al
  /// EN: Get elite asset directory path
  String getEliteAssetPath(EliteLayout layout) {
    switch (layout) {
      case EliteLayout.classic:
        return 'assets/themes/elite_1/';
      case EliteLayout.minimal:
        return 'assets/themes/elite_2/';
      case EliteLayout.grid:
        return 'assets/themes/elite_3/';
      case EliteLayout.card:
        return 'assets/themes/elite_4/';
    }
  }

  /// TR: Asset Fallback sistemi (Görsel varlığı kontrolü)
  /// EN: Asset Fallback system (Image existence check)
  /// TR: Not: Gerçek dosya kontrolü asenkron yapı gerektirir, 
  /// burada UI bazlı Image.asset errorBuilder ile desteklenebilir.
  Widget buildThemedAsset(String assetName, {required Widget fallback}) {
    if (state.tier == ThemeTier.eliteTier && state.eliteLayout != null) {
      final path = '${getEliteAssetPath(state.eliteLayout!)}$assetName';
      return Image.asset(
        path,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }
    return fallback;
  }
}

/// TR: Theme Manager Provider
/// EN: Theme Manager Provider
final themeManagerProvider =
    StateNotifierProvider<ThemeManager, ThemeState>((ref) {
  return ThemeManager();
});
