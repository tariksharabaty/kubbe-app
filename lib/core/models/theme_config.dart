import 'package:flutter/material.dart';
import 'theme_tier.dart';

/// [Tema Yapılandırma Modeli | Theme Configuration Model]
/// Her temanın kimliğini, renklerini ve erişim seviyesini tanımlar.
/// Defines each theme's ID, colors, and access level.
class ThemeConfig {
  final String id;
  final String name;
  final Color primaryColor;
  final ThemeTier tier;
  final bool isDark;

  const ThemeConfig({
    required this.id,
    required this.name,
    required this.primaryColor,
    required this.tier,
    this.isDark = false,
  });
}
