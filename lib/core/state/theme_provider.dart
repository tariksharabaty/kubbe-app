import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_tier.dart';
import '../models/theme_config.dart';

/// [Tema Sağlayıcısı | Theme Provider]
/// Uygulamanın tüm tema geçişlerini, seviye kontrollerini ve SharedPreferences kayıtlarını yönetir.
/// Manages all app theme transitions, tier checks, and SharedPreferences persistence.
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'selected_theme_id';
  
  ThemeConfig _currentTheme = allThemes.first;
  ThemeConfig get currentTheme => _currentTheme;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  /// [Tüm Temalar Listesi | List of All Themes]
  static const List<ThemeConfig> allThemes = [
    ThemeConfig(id: 'default', name: 'Kubbe Klasik', primaryColor: Color(0xFF4B0082), tier: ThemeTier.defaultTier),
    ThemeConfig(id: 'emerald', name: 'Zümrüt Yeşili', primaryColor: Color(0xFF2E7D32), tier: ThemeTier.free),
    ThemeConfig(id: 'ocean', name: 'Okyanus Mavisi', primaryColor: Color(0xFF1565C0), tier: ThemeTier.free),
    ThemeConfig(id: 'rose', name: 'Gül Kurusu', primaryColor: Color(0xFFAD1457), tier: ThemeTier.free),
    ThemeConfig(id: 'amber', name: 'Kehribar', primaryColor: Color(0xFFFF8F00), tier: ThemeTier.free),
    ThemeConfig(id: 'slate', name: 'Barut Gri', primaryColor: Color(0xFF37474F), tier: ThemeTier.free),
    ThemeConfig(id: 'midnight', name: 'Gece Yarısı', primaryColor: Color(0xFF1A237E), tier: ThemeTier.free),
    
    // [Premium & Elite Tiers - Placeholders]
    // 10 Premium, 4 Elite themes will be added here.
  ];

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeId = prefs.getString(_themeKey) ?? 'default';
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    
    _currentTheme = allThemes.firstWhere((t) => t.id == themeId, orElse: () => allThemes.first);
    notifyListeners();
  }

  Future<void> setTheme(ThemeConfig theme) async {
    _currentTheme = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme.id);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  /// [Tema Seviyesine Göre Gruplanmış Temalar | Themes Grouped by Tier]
  List<ThemeConfig> getThemesByTier(ThemeTier tier) {
    return allThemes.where((t) => t.tier == tier).toList();
  }
}
