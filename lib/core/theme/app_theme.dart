import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Uygulama tema konfigürasyonu - Application theme configuration
class AppTheme {
  // Ana renkler - Primary colors
  static const Color primaryColor = Color(
    0xFF4B0082,
  ); // Mor renk - Purple color
  static const Color secondaryColor = Color(
    0xFF7C4DFF,
  ); // Açık mor renk - Light purple color

  // Tema renkleri - Theme colors
  static const Color lightBackgroundColor = Color(
    0xFFF5F5F5,
  ); // Açık tema arka planı - Light theme background
  static const Color darkBackgroundColor = Color(
    0xFF121212,
  ); // Koyu tema arka planı - Dark theme background
  static const Color lightSurfaceColor = Color(
    0xFFFFFFFF,
  ); // Açık tema yüzeyi - Light theme surface
  static const Color darkSurfaceColor = Color(
    0xFF1E1E1E,
  ); // Koyu tema yüzeyi - Dark theme surface

  // Açık tema - Light theme
  static ThemeData lightTheme(Color primary) {
    final Color secondary = primary.withValues(alpha: 0.8);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: secondary,
        surface: lightSurfaceColor,
      ),

      // [Dinamik Sistem UI Konfigürasyonu | System UI Overlay Style]
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),

      // [M3 & One UI Tipografi Sistemi | Typography System]
      textTheme: TextTheme(
        // [Outfit: Başlıklar | Headlines]
        displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.black87),
        displayMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black87),
        displaySmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black87),
        headlineLarge: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black87),
        headlineMedium: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
        headlineSmall: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
        titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87),
        titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        titleSmall: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        
        // [Inter: Gövde ve İçerik Metinleri | Body & Content]
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
        
        // [Poppins: Sayılar, Etiketler ve İstatistikler | Numbers, Labels & Stats]
        labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),
        labelMedium: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: primaryColor),
        labelSmall: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: primaryColor),
      ),

      // [M3 Tonal Surface Kart Teması | M3 Tonal Surface Card Theme]
      cardTheme: CardThemeData(
        elevation: 0, // [M3 Flat/Tonal görünümü için | For Flat/Tonal look]
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), // [One UI 24dp rounding]
        color: primaryColor.withValues(alpha: 0.04), // [Tonal Surface tint]
        surfaceTintColor: primaryColor,
      ),

      // Alt bar teması - Bottom navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
      ),

      // FAB teması - Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // Koyu tema - Dark theme
  static ThemeData darkTheme(Color primary) {
    final Color secondary = primary.withValues(alpha: 0.8);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primary,
        secondary: secondary,
        surface: darkSurfaceColor,
      ),

      // [Dinamik Sistem UI - Dark Theme için de buralar dark kalmalı (Beyaz sayfalar için)]
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),

      // [Koyu Tema Tipografi | Dark Theme Typography]
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        displaySmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        headlineLarge: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
        headlineMedium: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        headlineSmall: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70),
        titleSmall: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70),
        
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white70),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white70),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
        
        labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        labelMedium: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70),
        labelSmall: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white60),
      ),

      // Kart teması - Card theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white.withValues(alpha: 0.05), // [Koyu tonal yüzey | Dark tonal surface]
        surfaceTintColor: Colors.white,
      ),

      // Alt bar teması - Bottom navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
      ),

      // FAB teması - Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
