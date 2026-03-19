// TR: KUBBE V4 App Providers - V1'den miras alındı
// EN: KUBBE V4 App Providers - Inherited from V1
// TR: Tüm servisler için Riverpod Provider tanımları
// EN: Riverpod Provider definitions for all services
// TR: V1'deki tüm servis mantığı provider'lar ile modernize edildi
// EN: All V1 service logic modernized with providers
// TR: prayerServiceProvider, settingsProvider gibi tüm provider'lar tanımlandı
// EN: All providers defined such as prayerServiceProvider, settingsProvider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/prayer_service.dart';
import '../services/location_service.dart';
import '../storage/preferences_manager.dart';
import '../../features/history/data/sultan_repository.dart';
import '../../features/history/data/daily_content_repository.dart';

/// TR: KUBBE V4 için Riverpod Providers
/// EN: Riverpod Providers for KUBBE V4
/// TR: Tüm servisler için Provider tanımları
/// EN: Provider definitions for all services
/// TR: V1'deki tüm servis mantığını provider'lar ile modernize eder
/// EN: Modernizes all V1 service logic with providers

// TR: Namaz Servis Provider'ları - V1'den miras alındı
// EN: Prayer Service Providers - Inherited from V1
// TR: Vakit hesaplama ve namaz ile ilgili tüm provider'lar
// EN: All providers related to prayer times calculation and prayers

// TR: Namaz servisi provider'ı
// EN: Prayer service provider
final prayerServiceProvider = Provider<PrayerService>((ref) => PrayerService());

// TR: Mevcut vakit provider'ı - GPS ile anlık vakitler
// EN: Current prayer times provider - Real-time prayers with GPS
final currentPrayerTimesProvider =
    FutureProvider<PrayerTimesData?>((ref) async {
  final location = await LocationService.getSavedLocation() ??
      LocationData(
          latitude: 41.0082,
          longitude: 28.9784,
          city: 'İstanbul',
          country: 'Turkey',
          countryCode: 'TR',
          isManual: false,
          timestamp: DateTime.now());
  return await PrayerService.getPrayerTimes(location);
});

// TR: Bugünkü vakit provider'ı - Kaydedilen konum için
// EN: Today's prayer times provider - For saved location
final todayPrayerTimesProvider =
    AsyncNotifierProvider<TodayPrayerTimesNotifier, PrayerTimesData?>(
        TodayPrayerTimesNotifier.new);

// TR: Bugünkü vakit notifier'ı
// EN: Today's prayer times notifier
class TodayPrayerTimesNotifier extends AsyncNotifier<PrayerTimesData?> {
  @override
  Future<PrayerTimesData?> build() async {
    final location = await LocationService.getSavedLocation();
    if (location == null) return null;
    return await PrayerService.getPrayerTimes(location);
  }
}

// TR: Günlük namaz takvimi provider'ı
// EN: Daily prayer schedule provider
final dailyPrayerScheduleProvider = Provider<DailyPrayerSchedule?>((ref) {
  final prayerTimesAsync = ref.watch(todayPrayerTimesProvider);
  return prayerTimesAsync.maybeWhen(
    data: (prayerTimes) => prayerTimes != null
        ? DailyPrayerSchedule.fromPrayerTimes(prayerTimes)
        : null,
    orElse: () => null,
  );
});

// TR: Sonraki vakit provider'ı
// EN: Next prayer provider
final nextPrayerProvider = Provider<String?>((ref) {
  // TR: Basit bir mantıkla sonraki vakiti belirle
  // EN: Simple logic to determine next prayer
  final now = DateTime.now();
  final hour = now.hour;

  if (hour >= 21) return 'İmsak'; // Yatsıdan sonra
  if (hour >= 19) return 'Yatsı';
  if (hour >= 16) return 'Akşam';
  if (hour >= 13) return 'İkindi';
  if (hour >= 6) return 'Öğle';
  if (hour >= 4) return 'Güneş';
  return 'İmsak';
});

// TR: Sonraki vakite kalan süre provider'ı
// EN: Time until next prayer provider
final timeUntilNextPrayerProvider = Provider<Duration?>((ref) {
  // TR: Basit bir mantıkla kalan süreyi hesapla
  // EN: Simple logic to calculate remaining time
  final now = DateTime.now();
  final hour = now.hour;

  // TR: Sonraki vakite kalan süre
  // EN: Time until next prayer
  if (hour >= 21) {
    // TR: Yarınki İmsak
    // EN: Tomorrow's Imsak
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final targetTime =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 4, 0, 0);
    return targetTime.difference(now);
  } else if (hour >= 19) {
    return const Duration(hours: 2); // İmsak
  } else if (hour >= 16) {
    return const Duration(hours: 3); // Yatsı
  } else if (hour >= 13) {
    return const Duration(hours: 3); // Akşam
  } else if (hour >= 6) {
    return const Duration(hours: 7); // İkindi
  } else if (hour >= 4) {
    return const Duration(hours: 2); // Öğle
  } else {
    return const Duration(hours: 2); // Güneş
  }
});

// TR: Mevcut vakit provider'ı
// EN: Current prayer provider
final currentPrayerProvider = Provider<String?>((ref) {
  // TR: Basit bir mantıkla mevcut vakiti belirle
  // EN: Simple logic to determine current prayer
  final now = DateTime.now();
  final hour = now.hour;

  if (hour >= 21) return 'Yatsı';
  if (hour >= 19) return 'Akşam';
  if (hour >= 16) return 'İkindi';
  if (hour >= 13) return 'Öğle';
  if (hour >= 6) return 'Güneş';
  if (hour >= 4) return 'İmsak';
  return 'İmsak'; // Gece 4-6 arası
});

// TR: Kıble yönü provider'ı
// EN: Qibla direction provider
final qiblaDirectionProvider = FutureProvider<double>((ref) async {
  final location = await LocationService.getCurrentLocation();
  if (location != null) {
    // TR: Basit bir hesaplama - Türkiye için Kıble yönü güney
    // EN: Simple calculation - Qibla direction is south for Turkey
    return location.countryCode == 'TR' ? 180.0 : 0.0;
  }
  return 0.0;
});

// TR: Konum Servis Provider'ları - V1'den miras alındı
// EN: Location Service Providers - Inherited from V1
// TR: Konum ve GPS ile ilgili tüm provider'lar
// EN: All providers related to location and GPS

// TR: Konum servisi provider'ı
// EN: Location service provider
final locationServiceProvider =
    Provider<LocationService>((ref) => LocationService());

// TR: Mevcut konum provider'ı - GPS ile anlık konum
// EN: Current position provider - Real-time position with GPS
final currentPositionProvider = FutureProvider<LocationData?>((ref) async {
  return await LocationService.getCurrentLocation();
});

// TR: Son bilinen konum provider'ı - Preferences'ten
// EN: Last known position provider - From preferences
final lastKnownPositionProvider = FutureProvider<LocationData?>((ref) async {
  return await LocationService.getSavedLocation();
});

// TR: Konum izni provider'ı
// EN: Location permission provider
final locationPermissionProvider = Provider<bool>((ref) {
  return ref.watch(preferencesStateProvider).locationPermissionGranted;
});

// TR: Konum kalitesi provider'ı
// EN: Location quality provider
final locationQualityProvider = Provider<LocationQuality>((ref) {
  final positionAsync = ref.watch(lastKnownPositionProvider);
  return positionAsync.maybeWhen(
    data: (locationData) =>
        locationData != null ? LocationQuality.excellent : LocationQuality.poor,
    orElse: () => LocationQuality.poor,
  );
});

// TR: Türkiye içinde mi provider'ı - V1 mantığı
// EN: Is within Turkey provider - V1 logic
final isWithinTurkeyProvider = Provider<bool>((ref) {
  final positionAsync = ref.watch(lastKnownPositionProvider);
  return positionAsync.maybeWhen(
    data: (locationData) =>
        locationData != null ? locationData.countryCode == 'TR' : false,
    orElse: () => false,
  );
});

// TR: Sultan Repository Provider'ları - V1'den miras alındı
// EN: Sultan Repository Providers - Inherited from V1
// TR: Osmanlı medeniyet verileri ile ilgili tüm provider'lar
// EN: All providers related to Ottoman civilization data

// TR: Sultan repository provider'ı
// EN: Sultan repository provider
final sultanRepositoryProvider =
    Provider<SultanRepository>((ref) => SultanRepository());

// TR: Tüm medeniyet bilgileri provider'ı
// EN: All civilization information provider
final allMedeniyetBilgisiProvider = Provider<List<MedeniyetBilgisi>>((ref) {
  return SultanRepository.getAllMedeniyetBilgisi();
});

// TR: Günlük medeniyet bilgisi provider'ı
// EN: Daily civilization information provider
final dailyMedeniyetBilgisiProvider = Provider<MedeniyetBilgisi>((ref) {
  return SultanRepository.getDailyInfo();
});

// TR: Medeniyet kategorileri provider'ı
// EN: Civilization categories provider
final medeniyetCategoriesProvider = Provider<List<String>>((ref) {
  return SultanRepository.getCategories();
});

// TR: Kategoriye göre medeniyet bilgileri provider'ı
// EN: Civilization information by category provider
final medeniyetByCategoryProvider =
    Provider.family<List<MedeniyetBilgisi>, String>((ref, kategori) {
  return SultanRepository.getByCategory(kategori);
});

// TR: Medeniyet arama provider'ı
// EN: Civilization search provider
final medeniyetSearchProvider =
    Provider.family<List<MedeniyetBilgisi>, String>((ref, query) {
  return SultanRepository.search(query);
});

// TR: Osmanlı istatistikleri provider'ı
// EN: Ottoman statistics provider
final ottomanStatisticsProvider = Provider<OttomanStatistics>((ref) {
  return OttomanStatistics();
});

// TR: Daily Content Repository Provider'ları - V1'den miras alındı
// EN: Daily Content Repository Providers - Inherited from V1
// TR: Günlük dua ve ayet verileri ile ilgili tüm provider'lar
// EN: All providers related to daily dua and ayet data

// TR: Daily content repository provider'ı
// EN: Daily content repository provider
final dailyContentRepositoryProvider = Provider<DailyContentRepository>((ref) {
  return DailyContentRepository();
});

// TR: Tüm dualar provider'ı
// EN: All duas provider
final allDuasProvider = Provider<List<Dua>>((ref) {
  return DailyContentRepository.getAllDuas();
});

// TR: Tüm ayetler provider'ı
// EN: All ayets provider
final allAyetsProvider = Provider<List<Ayet>>((ref) {
  return DailyContentRepository.getAllAyets();
});

// TR: Günlük içerik provider'ı
// EN: Daily content provider
final dailyContentProvider = Provider<DailyContent>((ref) {
  return DailyContentRepository.getDailyContent();
});

// TR: Dua kategorileri provider'ı
// EN: Dua categories provider
final duaCategoriesProvider = Provider<List<String>>((ref) {
  return DailyContentRepository.getDuaCategories();
});

// TR: Ayet kategorileri provider'ı
// EN: Ayet categories provider
final ayetCategoriesProvider = Provider<List<String>>((ref) {
  return DailyContentRepository.getAyetCategories();
});

// TR: Kategoriye göre dualar provider'ı
// EN: Duas by category provider
final duasByCategoryProvider =
    Provider.family<List<Dua>, String>((ref, kategori) {
  return DailyContentRepository.getDuasByCategory(kategori);
});

// TR: Kategoriye göre ayetler provider'ı
// EN: Ayets by category provider
final ayetsByCategoryProvider =
    Provider.family<List<Ayet>, String>((ref, kategori) {
  return DailyContentRepository.getAyetsByCategory(kategori);
});

// TR: Zamana göre dualar provider'ı
// EN: Duas by time provider
final duasByTimeProvider = Provider.family<List<Dua>, String>((ref, zaman) {
  return DailyContentRepository.getDuasByTime(zaman);
});

// TR: Sureye göre ayetler provider'ı
// EN: Ayets by surah provider
final ayetsBySurahProvider = Provider.family<List<Ayet>, String>((ref, sure) {
  return DailyContentRepository.getAyetsBySurah(sure);
});

// TR: İçerik arama provider'ı
// EN: Content search provider
final contentSearchProvider =
    Provider.family<List<DailyContentItem>, String>((ref, query) {
  return DailyContentRepository.search(query);
});

// TR: Rastgele dua provider'ı
// EN: Random dua provider
final randomDuaProvider = Provider<Dua>((ref) {
  return DailyContentRepository.getRandomDua();
});

// TR: Rastgele ayet provider'ı
// EN: Random ayet provider
final randomAyetProvider = Provider<Ayet>((ref) {
  return DailyContentRepository.getRandomAyet();
});

// TR: Birleşik Provider'lar - V1'den miras alındı
// EN: Combined Providers - Inherited from V1
// TR: Birden fazla provider'ı birleştiren karmaşık provider'lar
// EN: Complex providers that combine multiple providers

// TR: Ana dashboard provider'ı - Tüm ana ekran verileri
// EN: Home dashboard provider - All home screen data
final homeDashboardProvider = Provider<HomeDashboardData>((ref) {
  final prayerSchedule = ref.watch(dailyPrayerScheduleProvider);
  final dailyContent = ref.watch(dailyContentProvider);
  final dailyMedeniyet = ref.watch(dailyMedeniyetBilgisiProvider);
  final nextPrayer = ref.watch(nextPrayerProvider);
  final timeUntilNext = ref.watch(timeUntilNextPrayerProvider);
  final currentPrayer = ref.watch(currentPrayerProvider);
  final prefs = ref.watch(preferencesStateProvider);
  final zikirCounter = prefs.zikirCounter;
  final lastReadSurah = prefs.lastReadSurah;

  return HomeDashboardData(
    prayerSchedule: prayerSchedule,
    dailyContent: dailyContent,
    dailyMedeniyet: dailyMedeniyet,
    nextPrayer: nextPrayer,
    timeUntilNextPrayer: timeUntilNext,
    currentPrayer: currentPrayer,
    zikirCounter: zikirCounter,
    lastReadSurah: lastReadSurah,
  );
});

// TR: Bildirim ayarları provider'ı
// EN: Notification settings provider
final notificationSettingsProvider = Provider<NotificationSettings>((ref) {
  final prefs = ref.watch(preferencesStateProvider);

  return NotificationSettings(
    showNotification: prefs.notificationsEnabled,
    playAdhan: prefs.soundEnabled,
    adhanVolume: 0.8, // TR: Mock // EN: Mock
    minutesBeforeAdhan: prefs.prayerReminderMinutes,
  );
});

// TR: Uygulama ayarları provider'ı
// EN: App settings provider
final appSettingsProvider = Provider<AppSettings>((ref) {
  final prefs = ref.watch(preferencesStateProvider);

  return AppSettings(
    themeMode: prefs.isDarkMode ? 'dark' : 'light',
    useSystemTheme: prefs.themeMode == ThemeMode.system,
    language: prefs.language,
    selectedCity: prefs.selectedCity,
    calculationMethod: prefs.calculationMethod,
    madhab: 'hanafi', // TR: Mock // EN: Mock
  );
});

// TR: Okuma ilerlemesi provider'ı - V1 verileri
// EN: Reading progress provider - V1 data
final readingProgressProvider = Provider<ReadingProgress>((ref) {
  final prefs = ref.watch(preferencesStateProvider);

  return ReadingProgress(
    lastReadSurah: prefs.lastReadSurah,
    lastReadAyah: prefs.lastReadAyet,
    progress: {}, // TR: Mock // EN: Mock
    favoriteDuas: [], // TR: Mock // EN: Mock
    favoriteVerses: [], // TR: Mock // EN: Mock
  );
});

// TR: Zikir provider'ı - V1 verileri
// EN: Zikir provider - V1 data
final zikirProvider = Provider<ZikirData>((ref) {
  final prefs = ref.watch(preferencesStateProvider);

  return ZikirData(
    counter: prefs.zikirCounter,
    lastDate: '', // TR: Mock // EN: Mock
    todayZikir: prefs.zikirCounter, // TR: Mock // EN: Mock
  );
});

// TR: Provider'lar için Veri Modelleri - V1'den miras alındı
// EN: Data Models for Providers - Inherited from V1
// TR: Provider'lar tarafından kullanılan veri modelleri
// EN: Data models used by providers

// TR: Konum kalitesi enum'u
// EN: Location quality enum
enum LocationQuality {
  excellent,
  good,
  fair,
  poor,
}

// TR: Günlük namaz takvimi
// EN: Daily prayer schedule
class DailyPrayerSchedule {
  final PrayerTimesData prayerTimes;

  const DailyPrayerSchedule({required this.prayerTimes});

  // TR: PrayerTimesData'tan oluştur
  // EN: Create from PrayerTimesData
  factory DailyPrayerSchedule.fromPrayerTimes(PrayerTimesData prayerTimes) {
    return DailyPrayerSchedule(prayerTimes: prayerTimes);
  }

  // TR: Günlük namaz vakitlerini al
  // EN: Get daily prayer times
  Map<String, String> getDailyPrayerTimes() {
    return {
      'imsak': prayerTimes.imsak.formattedTime,
      'gunes': prayerTimes.gunes.formattedTime,
      'ogle': prayerTimes.ogle.formattedTime,
      'ikindi': prayerTimes.ikindi.formattedTime,
      'aksam': prayerTimes.aksam.formattedTime,
      'yatsi': prayerTimes.yatsi.formattedTime,
    };
  }
}

// TR: Ana Dashboard Veri Modeli
// EN: Home Dashboard Data Model
class HomeDashboardData {
  final DailyPrayerSchedule?
      prayerSchedule; // TR: Günlük namaz takvimi // EN: Daily prayer schedule
  final DailyContent? dailyContent; // TR: Günlük içerik // EN: Daily content
  final MedeniyetBilgisi?
      dailyMedeniyet; // TR: Günlük medeniyet bilgisi // EN: Daily civilization info
  final String? nextPrayer; // TR: Sonraki vakit // EN: Next prayer
  final Duration?
      timeUntilNextPrayer; // TR: Sonraki vakite kalan süre // EN: Time until next prayer
  final String? currentPrayer; // TR: Mevcut vakit // EN: Current prayer
  final int zikirCounter; // TR: Zikir sayacı // EN: Zikir counter
  final int lastReadSurah; // TR: Son okunan sure // EN: Last read surah

  // TR: Constructor
  // EN: Constructor
  HomeDashboardData({
    this.prayerSchedule,
    this.dailyContent,
    this.dailyMedeniyet,
    this.nextPrayer,
    this.timeUntilNextPrayer,
    this.currentPrayer,
    required this.zikirCounter,
    required this.lastReadSurah,
  });
}

// TR: Bildirim Ayarları Veri Modeli
// EN: Notification Settings Data Model
class NotificationSettings {
  final bool showNotification; // TR: Bildirim göster // EN: Show notification
  final bool playAdhan; // TR: Ezan çal // EN: Play adhan
  final double adhanVolume; // TR: Ezan ses seviyesi // EN: Adhan volume
  final int
      minutesBeforeAdhan; // TR: Ezandan önceki dakika // EN: Minutes before adhan

  // TR: Constructor
  // EN: Constructor
  NotificationSettings({
    required this.showNotification,
    required this.playAdhan,
    required this.adhanVolume,
    required this.minutesBeforeAdhan,
  });
}

// TR: Uygulama Ayarları Veri Modeli
// EN: App Settings Data Model
class AppSettings {
  final String themeMode; // TR: Tema modu // EN: Theme mode
  final bool
      useSystemTheme; // TR: Sistem temasını kullan // EN: Use system theme
  final String language; // TR: Dil // EN: Language
  final String selectedCity; // TR: Seçili şehir // EN: Selected city
  final String
      calculationMethod; // TR: Hesaplama metodu // EN: Calculation method
  final String madhab; // TR: Mezhep // EN: Madhab

  // TR: Constructor
  // EN: Constructor
  AppSettings({
    required this.themeMode,
    required this.useSystemTheme,
    required this.language,
    required this.selectedCity,
    required this.calculationMethod,
    required this.madhab,
  });
}

// TR: Okuma İlerlemesi Veri Modeli
// EN: Reading Progress Data Model
class ReadingProgress {
  final int lastReadSurah; // TR: Son okunan sure // EN: Last read surah
  final int lastReadAyah; // TR: Son okunan ayet // EN: Last read ayah
  final Map<String, dynamic> progress; // TR: İlerleme // EN: Progress
  final List<String> favoriteDuas; // TR: Favori dualar // EN: Favorite duas
  final List<String>
      favoriteVerses; // TR: Favori ayetler // EN: Favorite verses

  // TR: Constructor
  // EN: Constructor
  ReadingProgress({
    required this.lastReadSurah,
    required this.lastReadAyah,
    required this.progress,
    required this.favoriteDuas,
    required this.favoriteVerses,
  });
}

// TR: Zikir Veri Modeli
// EN: Zikir Data Model
class ZikirData {
  final int counter; // TR: Sayıç // EN: Counter
  final String lastDate; // TR: Son tarih // EN: Last date
  final int todayZikir; // TR: Bugünkü zikir // EN: Today's zikir

  // TR: Constructor
  // EN: Constructor
  ZikirData({
    required this.counter,
    required this.lastDate,
    required this.todayZikir,
  });
}
