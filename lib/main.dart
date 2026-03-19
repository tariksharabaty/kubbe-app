/// TR: KUBBE V4 Main Entry Point - V4 yenilikleri
/// EN: KUBBE V4 Main Entry Point - V4 innovations
/// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
/// EN: Use double language comment lines in all code
/// TR: ProviderScope ile başlat, KubbeTheme ile AnaNavigasyon'a yönlendir
/// EN: Start with ProviderScope, navigate to AnaNavigasyon with KubbeTheme
library kubbe_main;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/preferences_manager.dart';
import 'core/database/database_init.dart';
import 'features/home/home_screen.dart';

/// TR: KUBBE V4 Ana Uygulaması
/// EN: KUBBE V4 Main Application
/// TR: ProviderScope ile Riverpod state management başlatılır
/// EN: Riverpod state management is started with ProviderScope
/// TR: KubbeTheme ile Sy-OS design language uygulanır
/// EN: Sy-OS design language is applied with KubbeTheme
/// TR: AnaNavigasyon ile 5-sekmeli BottomBar ve merkez FAB yüklenir
/// EN: 5-section BottomBar and center FAB are loaded with AnaNavigasyon
/// TR: Tüm V1 mantığı V4 mimarisine taşındı
/// EN: All V1 logic is migrated to V4 architecture
/// TR: Sy-OS design language ve Riverpod modernizasyonu
/// EN: Sy-OS design language and Riverpod modernization
void main() async {
  // TR: Flutter binding'i başlat
  // EN: Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  
  // TR: EasyLocalization'ı başlat
  // EN: Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  // TR: Veritabanını başlat
  // EN: Initialize database
  await DatabaseInit.init();

  // TR: SharedPreferences'i başlat
  // EN: Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // TR: Flutter error handling - V1'den miras alındı
  // EN: Flutter error handling - Inherited from V1
  FlutterError.onError = (FlutterErrorDetails details) {
    // TR: Hata logları
    // EN: Error logs
    if (kDebugMode) {
      FlutterError.presentError(details);
    } else {
      // TR: Production'da hata raporlama
      // EN: Error reporting in production
      // TR: V1'den miras alınan hata yönetimi
      // EN: Error management inherited from V1
      // Production error reporting service
    }
  };

  // TR: ParentDataWidget hatalarını yakala
  // EN: Catch ParentDataWidget errors
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            'Bir hata oluştu. Uygulama yeniden başlatılıyor...',
            style: GoogleFonts.inter(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  };

  // TR: ProviderScope ile uygulamayı başlat
  // EN: Start application with ProviderScope
  runApp(
    // TR: EasyLocalization ile sarmala
    // EN: Wrap with EasyLocalization
    EasyLocalization(
      supportedLocales: const [Locale('tr', 'TR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr', 'TR'),
      startLocale: const Locale('tr', 'TR'),
      child: ProviderScope(
        overrides: [
          preferencesManagerProvider
              .overrideWith(() => PreferencesManager(sharedPreferences)),
        ],
        child: const KUBBEV4(),
      ),
    ),
  );
}

/// TR: KUBBE V4 Ana Uygulaması
/// EN: KUBBE V4 Main Application
/// TR: ProviderScope ile Riverpod state management başlatılır
/// EN: Riverpod state management is started with ProviderScope
/// TR: KubbeTheme ile Sy-OS design language uygulanır
/// EN: Sy-OS design language is applied with KubbeTheme
/// TR: HomeScreen V4 ile ana ekran ve V4 bileşenleri yüklenir
/// EN: Home screen and V4 components are loaded with HomeScreen V4
/// TR: V1 mantığı V4 mimarisine taşındı - Konum ve Namaz Vakti
/// EN: V1 logic migrated to V4 architecture - Location and Prayer Times
/// TR: Sy-OS design language ve Riverpod modernizasyonu
/// EN: Sy-OS design language and Riverpod modernization
class KUBBEV4 extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const KUBBEV4({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TR: Preferences state'ini al
    // EN: Get preferences state
    final preferencesState = ref.watch(preferencesManagerProvider);

    // TR: Tema seçimi - isAmberMode kontrolü
    // EN: Theme selection - isAmberMode check
    final ThemeData selectedTheme = preferencesState.isAmberMode
        ? KubbeTheme.amberTheme
        : (preferencesState.themeMode == ThemeMode.dark
            ? KubbeTheme.darkTheme
            : KubbeTheme.lightTheme);

    return MaterialApp(
      // TR: Tema - Sy-OS design language
      // EN: Theme - Sy-OS design language
      theme: selectedTheme,

      // TR: Ana sayfa - doğrudan doğru rotaya yönlendir
      // EN: Home page - direct navigation to correct route
      home: _getInitialScreen(preferencesState),

      // TR: Hata ayıklama başlığı
      // EN: Debug banner
      debugShowCheckedModeBanner: false,

      // TR: Uygulama başlığı
      // EN: Application title
      title: 'KUBBE V4',

      // TR: EasyLocalization ayarları
      // EN: EasyLocalization settings
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }

  // TR: Başlangıç ekranını belirle
  // EN: Determine initial screen
  Widget _getInitialScreen(preferencesState) {
    // TR: Geçici olarak direkt ana ekrana başla
    // EN: Temporarily start directly at home screen
    return const HomeScreen();

    // TR: termsAccepted kontrolü - doğrudan doğru ekrana yönlendir
    // EN: termsAccepted check - direct navigation to correct screen
    /*
    if (preferencesState.termsAccepted) {
      return const HomeScreen();
    } else {
      return const OnboardingScreen();
    }
    */
  }
}
