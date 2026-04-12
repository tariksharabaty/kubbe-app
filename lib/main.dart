import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:easy_localization/easy_localization.dart'; // [Dil desteği için - For language support]
import 'core/theme/app_theme.dart';
import 'core/services/islamic_audio_service.dart';
import 'core/navigation/main_screen.dart'; // [Yeni ana ekran - New main screen]
import 'core/state/hatim_state.dart'; // [Hatim durum yönetimi - Hatim status management]
import 'core/services/deeplink_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'core/services/history_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:provider/provider.dart';
import 'core/state/hatim_provider.dart';
import 'core/state/quran_settings_state.dart';
import 'core/state/history_state.dart';
import 'core/state/theme_provider.dart';
import 'core/state/prayer_time_provider.dart';


// Uygulama ana giriş noktası - Application main entry point
void main() async {
  // [Flutter binding'i başlat - Initialize Flutter binding]
  WidgetsFlutterBinding.ensureInitialized();

  // [Ses Servisini Başlat - Initialize Audio Service]
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ozal.kubbe.audio',
    androidNotificationChannelName: 'Kubbe Ses Çalma',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
    androidNotificationIcon: 'drawable/ic_notification', // [Bildirim ikonu dosya yolu zorla - Enforce notification icon path]
  );

  // [Zaman Dilimi Motorunu Başlat - Initialize Timezone Engine]
  tz.initializeTimeZones();

  // [Sınırsız Ekran - Edge-to-Edge Status Bar]
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness
          .dark, // [Başlangıçta açık renk sayfalar için siyah ikonlar - Black icons for light pages initially]
      statusBarBrightness:
          Brightness.light, // [iOS: Siyah ikonlar - Dark icons]
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // [Hatim Verisini Yükle - Load Hatim Data]
  await initHatimState();

  // [Geçmiş ve Koleksiyon Verisini Yükle - Load History and Collection Data]
  await HistoryService.init();

  // [EasyLocalization başlat - Initialize EasyLocalization]

  await EasyLocalization.ensureInitialized();

  // [Türkçe tarih formatlamayı başlat - Initialize Turkish date formatting]

  try {
    await initializeDateFormatting('tr_TR', null);
  } catch (e) {
    // [Hata durumunda sessizce devam - Continue silently on error]
  }

  // [Deep Link Servisini Başlat - Initialize Deep Link Service]
  await DeepLinkService.init();

  // [İslami Ses Servisini Başlat - Initialize Islamic Audio Service]
  await IslamicAudioService().init();

  // [İlk Açılış Kontrolü - First Launch Check]
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  // [Uygulamayı Provider ve EasyLocalization ile sarmala]
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HatimProvider()..init()),
        ChangeNotifierProvider(create: (_) => QuranSettingsState()),
        ChangeNotifierProvider(create: (_) => IslamicAudioService()), // [Ses servisini küresel olarak sağla - Provide audio service globally]
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // [Tema engine sağlayıcısı - Theme engine provider]
        ChangeNotifierProvider(create: (_) => PrayerTimeProvider()), // [Yeni Namaz Vakitleri Sağlayıcısı - New Prayer Provider]
        ChangeNotifierProvider.value(value: globalHistoryState),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('tr'), Locale('en'), Locale('ar')],
        path: 'assets/translations', 
        fallbackLocale: const Locale('tr'),
        child: KubbeApp(isFirstLaunch: isFirstLaunch),
      ),
    ),
  );
}

// Kubbe uygulaması - Kubbe application
class KubbeApp extends StatelessWidget {
  final bool isFirstLaunch;
  const KubbeApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Kubbe - İslami Yaşam Tarzı Uygulaması', // [Türkçe] - [English]
      debugShowCheckedModeBanner: false,

      // [Localization delegeleri - Localization delegates]
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // Tema konfigürasyonu - Theme configuration
      theme: AppTheme.lightTheme(themeProvider.currentTheme.primaryColor),
      darkTheme: AppTheme.darkTheme(themeProvider.currentTheme.primaryColor),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // [Ana ekran - Root navigator key ensures deep link stability]
      navigatorKey: DeepLinkService.navigatorKey,
      home: isFirstLaunch ? const OnboardingScreen() : const MainScreen(),
    );
  }
}





