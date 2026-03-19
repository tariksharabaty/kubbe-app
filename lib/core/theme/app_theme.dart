import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// TR: KUBBE V4 Theme Engine Sınıfı - Modernize Edildi
/// EN: KUBBE V4 Theme Engine Class - Modernized
class AppTheme {
  // TR: Font Aileleri - OFFLINE DESTEK
  // EN: Font Families - OFFLINE SUPPORT
  static const String outfitFontFamily = 'Outfit';
  static const String poppinsFontFamily = 'Poppins';
  static const String interFontFamily = 'Inter';

  // TR: Ana Renkler - KubbeIndigo palette
  // EN: Primary Colors - KubbeIndigo palette
  static const Color kubbeIndigo = Color(0xFF4B0082);
  static const Color syOsBackground = Color(0xFFF3E5F5);
  static const Color syOsSurface = Colors.white;
  static const Color syOsAccent = Color(0xFF9C27B0);
  static const Color syOsError = Color(0xFFF44336);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textOnPrimary = Colors.white;
  static const Color amberPrimary = Color(0xFFFFBF00);

  // TR: Sy-OS Design Constants
  // EN: Sy-OS Design Constants
  static const double syOsRadius = 32.0;

  // TR: Light Theme - Sy-OS ferah tasarımı
  // EN: Light Theme - Sy-OS spacious design
  static ThemeData get lightTheme => KubbeTheme.lightTheme;

  // TR: Dark Theme - Sy-OS gece modu
  // EN: Dark Theme - Sy-OS night mode
  static ThemeData get darkTheme => KubbeTheme.darkTheme;

  // TR: Amber Theme - Asil Kehribar gece modu
  // EN: Amber Theme - Noble Amber night mode
  static ThemeData get amberTheme => KubbeTheme.amberTheme;
}

/// TR: KUBBE V4 Theme Implementation
/// EN: KUBBE V4 Theme Implementation
class KubbeTheme {
  // TR: Font Aileleri - OFFLINE DESTEK
  // EN: Font Families - OFFLINE SUPPORT
  static const String outfitFontFamily = 'Outfit';
  static const String poppinsFontFamily = 'Poppins';
  static const String interFontFamily = 'Inter';

  // TR: Ana Renkler - KubbeIndigo palette
  // EN: Primary Colors - KubbeIndigo palette
  static const Color kubbeIndigo = Color(0xFF4B0082);
  static const Color syOsBackground = Color(0xFFF3E5F5);
  static const Color syOsSurface = Colors.white;
  static const Color syOsAccent = Color(0xFF9C27B0);
  static const Color syOsError = Color(0xFFF44336);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textOnPrimary = Colors.white;
  static const Color amberPrimary = Color(0xFFFFBF00);

  // TR: Sy-OS Design Constants
  // EN: Sy-OS Design Constants
  static const double syOsRadius = 32.0;

  // TR: Temel Metin Teması - Gövde metinleri için 'Inter' kullanır
  // EN: Base Text Theme - Uses 'Inter' for body texts
  static TextTheme get _baseTextTheme => GoogleFonts.interTextTheme(
        const TextTheme(
          bodyLarge: TextStyle(color: textPrimary, height: 1.5),
          bodyMedium: TextStyle(color: textPrimary, height: 1.5),
          bodySmall: TextStyle(color: textSecondary, height: 1.5),
          labelLarge: TextStyle(color: textPrimary, height: 1.4),
          labelMedium: TextStyle(color: textSecondary, height: 1.4),
          labelSmall: TextStyle(color: textTertiary, height: 1.4),
        ),
      );

  // TR: Başlık Metin Stilleri - 'Outfit' fontunu kullanır
  // EN: Headline Text Styles - Uses 'Outfit' font
  static TextTheme get _headlineTextTheme {
    final outfitTextStyle = GoogleFonts.outfit(
      fontWeight: FontWeight.bold,
      color: textPrimary,
    );
    return TextTheme(
      displayLarge: outfitTextStyle.copyWith(fontSize: 57, height: 1.2),
      displayMedium: outfitTextStyle.copyWith(fontSize: 45, height: 1.2),
      displaySmall: outfitTextStyle.copyWith(fontSize: 36, height: 1.2),
      headlineLarge: outfitTextStyle.copyWith(fontSize: 32, height: 1.3),
      headlineMedium: outfitTextStyle.copyWith(fontSize: 28, height: 1.3),
      headlineSmall: outfitTextStyle.copyWith(fontSize: 24, height: 1.3),
      titleLarge: outfitTextStyle.copyWith(fontSize: 22, height: 1.4),
      titleMedium: outfitTextStyle.copyWith(
          fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
      titleSmall: outfitTextStyle.copyWith(
          fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
    );
  }

  // TR: Light Theme - Sy-OS ferah tasarımı
  // EN: Light Theme - Sy-OS spacious design
  static ThemeData get lightTheme {
    final baseTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: kubbeIndigo,
        primary: kubbeIndigo,
        secondary: syOsAccent,
        surface: syOsSurface,
        error: syOsError,
        onPrimary: textOnPrimary,
        onSecondary: textOnPrimary,
        onSurface: textPrimary,
        onSurfaceVariant: textSecondary,
        onError: textOnPrimary,
        brightness: Brightness.light,
      ),
      textTheme: _baseTextTheme
          .apply(
            bodyColor: textPrimary,
            displayColor: textPrimary,
          )
          .merge(_headlineTextTheme),
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: baseTheme.colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: baseTheme.colorScheme.surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _headlineTextTheme.titleLarge,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: syOsSurface,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(syOsRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kubbeIndigo,
          foregroundColor: textOnPrimary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
              fontFamily: interFontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: textTertiary.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),
    );
  }

  // TR: Dark Theme - Sy-OS gece modu
  // EN: Dark Theme - Sy-OS night mode
  static ThemeData get darkTheme {
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: kubbeIndigo,
      primary: kubbeIndigo,
      secondary: syOsAccent,
      surface: const Color(0xFF1A1A1A),
      error: syOsError,
      onPrimary: textOnPrimary,
      onSecondary: textOnPrimary,
      onSurface: textOnPrimary,
      onSurfaceVariant: const Color(0xFFCCCCCC),
      onError: textOnPrimary,
      brightness: Brightness.dark,
    );

    final darkBaseTextTheme = _baseTextTheme.apply(
      bodyColor: textOnPrimary,
      displayColor: textOnPrimary,
    );
    final darkHeadlineTextTheme = _headlineTextTheme.apply(
      bodyColor: textOnPrimary,
      displayColor: textOnPrimary,
    );

    return ThemeData.from(
      colorScheme: darkColorScheme,
      textTheme: darkBaseTextTheme.merge(darkHeadlineTextTheme),
      useMaterial3: true,
    ).copyWith(
      scaffoldBackgroundColor: darkColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: textOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: darkHeadlineTextTheme.titleLarge,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkColorScheme.surface,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(syOsRadius),
        ),
      ),
    );
  }

  // TR: Amber Theme - Asil Kehribar gece modu
  // EN: Amber Theme - Noble Amber night mode
  static ThemeData get amberTheme {
    final amberColorScheme = ColorScheme.fromSeed(
      seedColor: amberPrimary,
      primary: amberPrimary,
      secondary: const Color(0xFFFFD54F),
      surface: const Color(0xFF1A1A1A),
      error: syOsError,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: amberPrimary,
      onSurfaceVariant: const Color(0xFFFFD54F),
      brightness: Brightness.dark,
    );

    final amberBaseTextTheme = _baseTextTheme.apply(
      bodyColor: amberPrimary,
      displayColor: amberPrimary,
    );
    final amberHeadlineTextTheme = _headlineTextTheme.apply(
      bodyColor: amberPrimary,
      displayColor: amberPrimary,
    );

    return ThemeData.from(
      colorScheme: amberColorScheme,
      textTheme: amberBaseTextTheme.merge(amberHeadlineTextTheme),
      useMaterial3: true,
    ).copyWith(
      scaffoldBackgroundColor: amberColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: amberColorScheme.surface,
        foregroundColor: amberPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: amberHeadlineTextTheme.titleLarge,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: amberColorScheme.surface,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(syOsRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: amberPrimary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
              fontFamily: interFontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
