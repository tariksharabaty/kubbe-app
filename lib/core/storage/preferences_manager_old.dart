// TR: KUBBE V4 Preferences Manager - V1'den miras alındı
// EN: KUBBE V4 Preferences Manager - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: SharedPrefs üzerinden tema, dil, son okunan sure ve zikir sayacı verilerini yöneten Riverpod 'Notifier' yapısını kur
// EN: Set up Riverpod 'Notifier' structure that manages theme, language, last read surah and zikir counter data via SharedPrefs
// TR: Her metodun amacını TR/EN açıkla
// EN: Add TR/EN descriptions to the beginning of each method

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// TR: KUBBE V4 Preferences Manager Sınıfı
/// EN: KUBBE V4 Preferences Manager Class
/// TR: V1'deki app_preferences.dart mantığını Riverpod Notifier olarak modernize eder
/// EN: Modernizes V1's app_preferences.dart logic as Riverpod Notifier
/// TR: SharedPrefs üzerinden kalıcı veri saklama ve yönetme
/// EN: Persistent data storage and management via SharedPrefs
/// TR: Tüm kullanıcı tercihlerini merkezi olarak yönetir
/// EN: Centrally manages all user preferences
/// TR: Notifier ile senkron veri yönetimi
/// EN: Synchronous data management with Notifier
class PreferencesManager extends Notifier<PreferencesState> {
  // TR: SharedPrefs instance
  // EN: SharedPrefs instance
  SharedPreferences? _prefs;

  // TR: Constructor - SharedPreferences ile başlatılır
  // EN: Constructor - Initialized with SharedPreferences
  PreferencesManager([SharedPreferences? prefs]) {
    _prefs = prefs;
  }

  // TR: Preferences'i başlat
  // EN: Initialize preferences
  // TR: SharedPrefs üzerinden tüm ayarları yükler ve state'i günceller
  // EN: Loads all settings from SharedPrefs and updates state
  @override
  PreferencesState build() {
    // TR: SharedPrefs zaten main.dart'tan enjekte edildi
    // EN: SharedPrefs already injected from main.dart
    if (_prefs == null) {
      // TR: SharedPrefs henüz hazır değilse varsayılan state döndür
      // EN: Return default state if SharedPrefs is not ready yet
      return PreferencesState.initial();
    }

    // TR: Kayıtlı tüm ayarları yükle
    // EN: Load all saved settings
    final state = PreferencesState(
      isDarkMode: _prefs?.getBool('isDarkMode') ?? false,
      themeMode: _getThemeModeFromString(
        _prefs?.getString('themeMode') ?? 'system',
      ),
      isAmberMode: _prefs?.getBool('isAmberMode') ?? false,
      language: _prefs?.getString('language') ?? 'tr',
      zikirCounter: _prefs?.getInt('zikirCounter') ?? 0,
      lastReadSurah: _prefs?.getInt('lastReadSurah') ?? 1,
      lastReadAyet: _prefs?.getInt('lastReadAyet') ?? 1,
      selectedCity: _prefs?.getString('selectedCity') ?? 'İstanbul',
      hasSeenOnboarding: _prefs?.getBool('hasSeenOnboarding') ?? false,
      cardStyle: _prefs?.getBool('cardStyle') ?? true,
      fontSize: _prefs?.getDouble('fontSize') ?? 20.0,
      selectedMushafFont: _prefs?.getString('selectedMushafFont') ?? 'husrev',
      prayerNotificationsEnabled:
          _prefs?.getBool('prayerNotificationsEnabled') ?? true,
      dailyNotificationsEnabled:
          _prefs?.getBool('dailyNotificationsEnabled') ?? true,
      zikirNotificationsEnabled:
          _prefs?.getBool('zikirNotificationsEnabled') ?? true,
      prayerTimeEnabled: _prefs?.getBool('prayerTimeEnabled') ?? true,
      locationPermissionGranted:
          _prefs?.getBool('locationPermissionGranted') ?? false,
      autoLocationEnabled: _prefs?.getBool('autoLocationEnabled') ?? true,
      notificationSoundEnabled:
          _prefs?.getBool('notificationSoundEnabled') ?? true,
      prayerReminderMinutes: _prefs?.getInt('prayerReminderMinutes') ?? 15,
      lastPrayerTime: _prefs?.getString('lastPrayerTime') != null
          ? DateTime.parse(_prefs!.getString('lastPrayerTime')!)
          : null,
      calculationMethod: _prefs?.getString('calculationMethod') ?? 'turkey',
      notificationsEnabled: _prefs?.getBool('notificationsEnabled') ?? true,
      soundEnabled: _prefs?.getBool('soundEnabled') ?? true,
      vibrationEnabled: _prefs?.getBool('vibrationEnabled') ?? true,
      autoPlayEnabled: _prefs?.getBool('autoPlayEnabled') ?? false,
      lastKnownLatitude: _prefs?.getDouble('lastKnownLatitude'),
      lastKnownLongitude: _prefs?.getDouble('lastKnownLongitude'),
      firstLaunch: _prefs?.getBool('firstLaunch') ?? true,
    );

    return state;
  }

  // TR: Tema modunu değiştir - V1'den miras alındı
  // EN: Change theme mode - Inherited from V1
  // TR: TR: Dark/Light mod arasında geçiş yapar
  // EN: EN: Switches between Dark/Light mode
  // TR: TR: Kullanıcı tercihini SharedPrefs'e kaydeder
  // EN: EN: Saves user preference to SharedPrefs
  Future<void> toggleTheme() async {
    if (_prefs == null) return;

    final newTheme = !state.isDarkMode;
    await _prefs!.setBool('isDarkMode', newTheme);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(isDarkMode: newTheme);
  }

  // TR: Tema ayarını değiştir - V1'den miras alındı
  // EN: Change theme setting - Inherited from V1
  // TR: TR: Koyu/Açık mod arasında geçiş yapar
  // EN: EN: Switches between Dark/Light mode
  // TR: TR: Kullanıcı tema tercihini SharedPrefs'e kaydeder
  // EN: EN: Saves user theme preference to SharedPrefs
  Future<void> setTheme(bool isDarkMode) async {
    if (_prefs == null) return;

    await _prefs!.setBool('isDarkMode', isDarkMode);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  // TR: Dil ayarını değiştir - V1'den miras alındı
  // EN: Change language setting - Inherited from V1
  // TR: TR: TR/EN dilleri arasında geçiş yapar
  // EN: EN: Switches between TR/EN languages
  // TR: TR: Kullanıcı dil tercihini SharedPrefs'e kaydeder
  // EN: EN: Saves user language preference to SharedPrefs
  Future<void> setLanguage(String language) async {
    if (_prefs == null) return;

    await _prefs!.setString('language', language);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(language: language);
  }

  // TR: Zikir sayacını artır - V1'den miras alındı
  // EN: Increment zikir counter - Inherited from V1
  // TR: TR: Zikir sayacını bir artırır
  // EN: EN: Increments zikir counter by one
  // TR: TR: Yeni değeri SharedPrefs'e kaydeder
  // EN: EN: Saves new value to SharedPrefs
  Future<void> incrementZikir() async {
    if (_prefs == null) return;

    final newCount = state.zikirCounter + 1;
    await _prefs!.setInt('zikirCounter', newCount);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(zikirCounter: newCount);
  }

  // TR: Zikir sayacını ayarla - V1'den miras alındı
  // EN: Set zikir counter - Inherited from V1
  // TR: TR: Zikir sayacını belirli bir değere ayarlar
  // EN: EN: Sets zikir counter to a specific value
  // TR: TR: Yeni değeri SharedPrefs'e kaydeder
  // EN: EN: Saves new value to SharedPrefs
  Future<void> setZikirCounter(int count) async {
    if (_prefs == null) return;

    await _prefs!.setInt('zikirCounter', count);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(zikirCounter: count);
  }

  // TR: Zikir sayacını sıfırla - V1'den miras alındı
  // EN: Reset zikir counter - Inherited from V1
  // TR: TR: Zikir sayacını sıfırlar
  // EN: EN: Resets zikir counter to zero
  // TR: TR: Sıfırlan değeri SharedPrefs'e kaydeder
  // EN: EN: Saves reset value to SharedPrefs
  Future<void> resetZikir() async {
    await setZikirCounter(0);
  }

  // TR: Son okunan sureyi ayarla - V1'den miras alındı
  // EN: Set last read surah - Inherited from V1
  // TR: TR: Son okunan sure numarasını kaydeder
  // EN: EN: Saves last read surah number
  // TR: TR: Okunma ilerlemesini takip etmek için
  // EN: EN: To track reading progress
  Future<void> setLastReadSurah(int surahNumber) async {
    if (_prefs == null) return;

    await _prefs!.setInt('lastReadSurah', surahNumber);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(lastReadSurah: surahNumber);
  }

  // TR: Son okunan ayeti ayarla - V1'den miras alındı
  // EN: Set last read verse - Inherited from V1
  // TR: TR: Son okunan ayet numarasını kaydeder
  // EN: EN: Saves last read verse number
  // TR: TR: Okunma ilerlemesini takip etmek için
  // EN: EN: To track reading progress
  Future<void> setLastReadAyet(int ayetNumber) async {
    if (_prefs == null) return;

    await _prefs!.setInt('lastReadAyet', ayetNumber);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(lastReadAyet: ayetNumber);
  }

  // TR: Seçili şehri ayarla - V1'den miras alındı
  // EN: Set selected city - Inherited from V1
  // TR: TR: Kullanıcının seçtiği şehri kaydeder
  // EN: EN: Saves user's selected city
  // TR: TR: Namaz vakitleri için konum bilgisi
  // EN: EN: For prayer times location information
  Future<void> setSelectedCity(String city) async {
    if (_prefs == null) return;

    await _prefs!.setString('selectedCity', city);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(selectedCity: city);
  }

  // TR: Bildirimleri etkinleştir/devre dışı bırak - V1'den miras alındı
  // EN: Enable/disable notifications - Inherited from V1
  // TR: TR: Bildirim ayarını değiştirir
  // EN: EN: Changes notification setting
  // TR: TR: Kullanıcı bildirim tercihini SharedPrefs'e kaydeder
  // EN: EN: Saves user notification preference to SharedPrefs
  Future<void> setNotificationsEnabled(bool enabled) async {
    if (_prefs == null) return;

    await _prefs!.setBool('notificationsEnabled', enabled);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(notificationsEnabled: enabled);
  }

  // TR: Sesi etkinleştir/devre dışı bırak - V1'den miras alındı
  // EN: Enable/disable sound - Inherited from V1
  // TR: TR: Ses ayarını değiştirir
  // EN: EN: Changes sound setting
  // TR: TR: Kullanıcı ses tercihini SharedPrefs'e kaydeder
  // EN: EN: Saves user sound preference to SharedPrefs
  Future<void> setSoundEnabled(bool enabled) async {
    if (_prefs == null) return;

    await _prefs!.setBool('soundEnabled', enabled);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(soundEnabled: enabled);
  }

  // TR: Titreşimi etkinleştir/devre dışı bırak - V1'den miras alındı
  // EN: Enable/disable vibration - Inherited from V1
  // TR: TR: Titreşim ayarını değiştirir
  // EN: EN: Changes vibration setting
  // TR: TR: Kullanıcı titreşim tercihini SharedPrefs'e kaydeder
  // EN: EN: Saves user vibration preference to SharedPrefs
  Future<void> setVibrationEnabled(bool enabled) async {
    if (_prefs == null) return;

    await _prefs!.setBool('vibrationEnabled', enabled);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(vibrationEnabled: enabled);
  }

  // TR: Otomatik oynatımı etkinleştir/devre dışı bırak - V1'den miras alındı
  // EN: Enable/disable auto play - Inherited from V1
  // TR: TR: Otomatik oynatma ayarını değiştirir
  // EN: EN: Changes auto play setting
  // TR: TR: Kullanıcı otomatik oynatma tercihini SharedPrefs'e kaydeder
  // EN: EN: Saves user auto play preference to SharedPrefs
  Future<void> setAutoPlayEnabled(bool enabled) async {
    if (_prefs == null) return;

    await _prefs!.setBool('autoPlayEnabled', enabled);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(autoPlayEnabled: enabled);
  }

  // TR: Font boyutunu ayarla - V1'den miras alındı
  // EN: Set font size - Inherited from V1
  // TR: TR: Font boyutunu ayarlar
  // EN: EN: Sets font size
  // TR: TR: Kullanıcı font boyutunu SharedPrefs'e kaydeder
  // EN: EN: Saves user font size preference to SharedPrefs
  Future<void> setFontSize(double fontSize) async {
    if (_prefs == null) return;

    await _prefs!.setDouble('fontSize', fontSize);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(fontSize: fontSize);
  }

  // TR: Son bilinen konumu ayarla - V1'den miras alındı
  // EN: Set last known location - Inherited from V1
  // TR: TR: GPS koordinatlarını kaydeder
  // EN: Saves GPS coordinates
  // TR: TR: Konum servisleri için kullanılır
  // EN: EN: Used by location services
  Future<void> setLastKnownLocation(double latitude, double longitude) async {
    if (_prefs == null) return;

    await _prefs!.setDouble('lastKnownLatitude', latitude);
    await _prefs!.setDouble('lastKnownLongitude', longitude);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(
      lastKnownLatitude: latitude,
      lastKnownLongitude: longitude,
    );
  }

  // TR: İlk açılış kontrolünü SharedPrefs'e kaydeder
  // EN: Saves first launch check to SharedPrefs
  Future<void> setFirstLaunchCompleted() async {
    if (_prefs == null) return;

    await _prefs!.setBool('firstLaunch', false);

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(firstLaunch: false);
  }

  // TR: Konum izni verildi mi - Statik erişim
  // EN: Is location permission granted - Static access
  static Future<bool> isLocationPermissionGranted() async {
    // TR: Static method için kendi SharedPreferences instance'ını oluştur
    // EN: Create own SharedPreferences instance for static method
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('locationPermissionGranted') ?? false;
  }

  // TR: Son bilinen konumu al - Statik erişim
  // EN: Get last known location - Static access
  static Future<(double?, double?)> getLastKnownLocation() async {
    // TR: Static method için kendi SharedPreferences instance'ını oluştur
    // EN: Create own SharedPreferences instance for static method
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('lastKnownLatitude');
    final lon = prefs.getDouble('lastKnownLongitude');
    return (lat, lon);
  }

  // TR: Son bilinen konumu ayarla - Statik erişim
  // EN: Set last known location - Static access
  static Future<void> setLastKnownLocationStatic(
    double latitude,
    double longitude,
  ) async {
    // TR: Static method için kendi SharedPreferences instance'ını oluştur
    // EN: Create own SharedPreferences instance for static method
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('lastKnownLatitude', latitude);
    await prefs.setDouble('lastKnownLongitude', longitude);
  }

  // TR: Konum izni ayarla - Statik erişim
  // EN: Set location permission granted - Static access
  static Future<void> setLocationPermissionGrantedStatic(bool granted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('locationPermissionGranted', granted);
  }

  // TR: ThemeMode string'den dönüştür
  // EN: Convert ThemeMode from string
  // TR: TR: ThemeMode string değerini ThemeMode enum'una dönüştürür
  // EN: EN: Converts ThemeMode string value to ThemeMode enum
  ThemeMode _getThemeModeFromString(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  // TR: Amber modunu ayarla
  // EN: Set amber mode
  // TR: TR: Amber modunu ayarlar ve SharedPrefs'e kaydeder
  // EN: EN: Sets amber mode and saves to SharedPrefs
  Future<void> setAmberMode(bool isAmberMode) async {
    if (_prefs == null) return;

    await _prefs!.setBool('isAmberMode', isAmberMode);
    state = state.copyWith(isAmberMode: isAmberMode);
  }

  // TR: Onboarding görüldü olarak ayarla
  // EN: Set onboarding as seen
  // TR: TR: Onboarding'in görüldüğünü ayarlar ve SharedPrefs'e kaydeder
  // EN: EN: Sets onboarding as seen and saves to SharedPrefs
  Future<void> setOnboardingSeen([bool seen = true]) async {
    if (_prefs == null) return;

    await _prefs!.setBool('hasSeenOnboarding', seen);
    state = state.copyWith(hasSeenOnboarding: seen);
  }

  // TR: Mushaf fontunu ayarla
  // EN: Set mushaf font
  // TR: TR: Mushaf fontunu ayarlar ve SharedPrefs'e kaydeder
  // EN: EN: Sets mushaf font and saves to SharedPrefs
  Future<void> setMushafFont(String fontId) async {
    if (_prefs == null) return;

    await _prefs!.setString('selectedMushafFont', fontId);
    state = state.copyWith(selectedMushafFont: fontId);
  }

  // TR: Ezan bildirimlerini ayarla
  // EN: Set prayer notifications
  // TR: TR: Ezan bildirimlerini ayarlar ve SharedPrefs'e kaydeder
  // EN: EN: Sets prayer notifications and saves to SharedPrefs
  Future<void> setPrayerNotificationsEnabled(bool enabled) async {
    if (_prefs == null) return;

    await _prefs!.setBool('prayerNotificationsEnabled', enabled);
    state = state.copyWith(prayerNotificationsEnabled: enabled);
  }

  // TR: Günlük bildirimleri ayarla
  // EN: Set daily notifications
  // TR: TR: Günlük bildirimleri ayarlar ve SharedPrefs'e kaydeder
  // EN: EN: Sets daily notifications and saves to SharedPrefs
  Future<void> setDailyNotificationsEnabled(bool enabled) async {
    if (_prefs == null) return;

    await _prefs!.setBool('dailyNotificationsEnabled', enabled);
    state = state.copyWith(dailyNotificationsEnabled: enabled);
  }

  // TR: Zikir bildirimlerini ayarla
  // EN: Set zikir notifications
  // TR: TR: Zikir bildirimlerini ayarlar ve SharedPrefs'e kaydeder
  // EN: EN: Sets zikir notifications and saves to SharedPrefs
  Future<void> setZikirNotificationsEnabled(bool enabled) async {
    if (_prefs == null) return;

    await _prefs!.setBool('zikirNotificationsEnabled', enabled);
    state = state.copyWith(zikirNotificationsEnabled: enabled);
  }

  // TR: Kart stilini ayarla
  // EN: Set card style
  // TR: TR: Kart stilini ayarlar ve SharedPrefs'e kaydeder
  // EN: EN: Sets card style and saves to SharedPrefs
  Future<void> setCardStyle(bool cardStyle) async {
    if (_prefs == null) return;

    await _prefs!.setBool('cardStyle', cardStyle);
    state = state.copyWith(cardStyle: cardStyle);
  }

  // TR: Ezan vakti ayarla
  // EN: Set prayer time
  // TR: TR: Ezan vakti ayarını SharedPrefs'e kaydeder
  // EN: EN: Saves prayer time setting to SharedPrefs
  Future<void> setPrayerTimeEnabled(bool enabled) async {
    if (_prefs == null) return;

    await _prefs!.setBool('prayerTimeEnabled', enabled);
    state = state.copyWith(prayerTimeEnabled: enabled);
  }

  // TR: Konum izni ayarla
  // EN: Set location permission
  // TR: TR: Konum izni ayarını SharedPrefs'e kaydeder
  // EN: EN: Saves location permission setting to SharedPrefs
  Future<void> setLocationPermissionGranted(bool granted) async {
    if (_prefs == null) return;

    await _prefs!.setBool('locationPermissionGranted', granted);
    state = state.copyWith(locationPermissionGranted: granted);
  }

  // TR: Otomatik konum ayarla
  // EN: Set auto location
  // TR: TR: Otomatik konum ayarını SharedPrefs'e kaydeder
  // EN: EN: Saves auto location setting to SharedPrefs
  Future<void> setAutoLocationEnabled(bool enabled) async {
    if (_prefs == null) return;

    await _prefs!.setBool('autoLocationEnabled', enabled);
    state = state.copyWith(autoLocationEnabled: enabled);
  }

  // TR: Bildirim sesi ayarla
  // EN: Set notification sound
  // TR: TR: Bildirim sesi ayarını SharedPrefs'e kaydeder
  // EN: EN: Saves notification sound setting to SharedPrefs
  Future<void> setNotificationSoundEnabled(bool enabled) async {
    if (_prefs == null) return;

    await _prefs!.setBool('notificationSoundEnabled', enabled);
    state = state.copyWith(notificationSoundEnabled: enabled);
  }

  // TR: Vakit öncesi ayarla
  // EN: Set prayer reminder
  // TR: TR: Vakit öncesi ayarını SharedPrefs'e kaydeder
  // EN: EN: Saves prayer reminder setting to SharedPrefs
  Future<void> setPrayerReminderMinutes(int minutes) async {
    if (_prefs == null) return;

    await _prefs!.setInt('prayerReminderMinutes', minutes);
    state = state.copyWith(prayerReminderMinutes: minutes);
  }

  // TR: Son ezan vaktini ayarla
  // EN: Set last prayer time
  // TR: TR: Son ezan vaktini SharedPrefs'e kaydeder
  // EN: EN: Saves last prayer time to SharedPrefs
  Future<void> setLastPrayerTime(DateTime prayerTime) async {
    if (_prefs == null) return;

    await _prefs!.setString('lastPrayerTime', prayerTime.toIso8601String());
    state = state.copyWith(lastPrayerTime: prayerTime);
  }

  // TR: Hesaplama yöntemini ayarla
  // EN: Set calculation method
  // TR: TR: Hesaplama yöntemini SharedPrefs'e kaydeder
  // EN: EN: Saves calculation method to SharedPrefs
  Future<void> setCalculationMethod(String method) async {
    if (_prefs == null) return;

    await _prefs!.setString('calculationMethod', method);
    state = state.copyWith(calculationMethod: method);
  }

  // TR: Ayarları dışa aktar - V1'den miras alındı
  // EN: Export settings - Inherited from V1
  // TR: TR: Tüm ayarları JSON formatında dışa aktarır
  // EN: Exports all settings in JSON format
  // TR: TR: Veri yedekleme ve taşıma için kullanılır
  // EN: EN: Used for data backup and migration
  Map<String, dynamic> exportSettings() {
    return {
      'isDarkMode': state.isDarkMode,
      'language': state.language,
      'zikirCounter': state.zikirCounter,
      'lastReadSurah': state.lastReadSurah,
      'lastReadAyet': state.lastReadAyet,
      'selectedCity': state.selectedCity,
      'notificationsEnabled': state.notificationsEnabled,
      'soundEnabled': state.soundEnabled,
      'vibrationEnabled': state.vibrationEnabled,
      'autoPlayEnabled': state.autoPlayEnabled,
      'fontSize': state.fontSize,
      'lastKnownLatitude': state.lastKnownLatitude,
      'lastKnownLongitude': state.lastKnownLongitude,
      'firstLaunch': state.firstLaunch,
    };
  }

  // TR: Ayarları içe aktar - V1'den miras alındı
  // EN: Import settings - Inherited from V1
  // TR: TR: JSON formatındaki ayarları içe aktarır
  // EN: Imports settings from JSON format
  // TR: TR: Veri yedekleme geri yükleme için kullanılır
  // EN: EN: Used for data backup restoration
  Future<void> importSettings(Map<String, dynamic> settings) async {
    if (_prefs == null) return;

    // TR: Her ayarı tek tek içe aktar
    // EN: Import each setting one by one
    if (settings.containsKey('isDarkMode')) {
      await setTheme(settings['isDarkMode'] as bool);
    }
    if (settings.containsKey('language')) {
      await setLanguage(settings['language'] as String);
    }
    if (settings.containsKey('zikirCounter')) {
      await setZikirCounter(settings['zikirCounter'] as int);
    }
    if (settings.containsKey('lastReadSurah')) {
      await setLastReadSurah(settings['lastReadSurah'] as int);
    }
    if (settings.containsKey('lastReadAyet')) {
      await setLastReadAyet(settings['lastReadAyet'] as int);
    }
    if (settings.containsKey('selectedCity')) {
      await setSelectedCity(settings['selectedCity'] as String);
    }
    if (settings.containsKey('notificationsEnabled')) {
      await setNotificationsEnabled(settings['notificationsEnabled'] as bool);
    }
    if (settings.containsKey('soundEnabled')) {
      await setSoundEnabled(settings['soundEnabled'] as bool);
    }
    if (settings.containsKey('vibrationEnabled')) {
      await setVibrationEnabled(settings['vibrationEnabled'] as bool);
    }
    if (settings.containsKey('autoPlayEnabled')) {
      await setAutoPlayEnabled(settings['autoPlayEnabled'] as bool);
    }
    if (settings.containsKey('fontSize')) {
      await setFontSize(settings['fontSize'] as double);
    }
    if (settings.containsKey('lastKnownLatitude') &&
        settings.containsKey('lastKnownLongitude')) {
      await setLastKnownLocation(
        settings['lastKnownLatitude'] as double,
        settings['lastKnownLongitude'] as double,
      );
    }
  }
}

// TR: Preferences State Model - V1'den miras alındı
// EN: Preferences State Model - Inherited from V1
// TR: Tüm kullanıcı ayarlarını içeren veri modeli
// EN: Data model containing all user settings
// TR: Notifier ile uyumlu state yönetimi
// EN: Notifier compatible state management
class PreferencesState {
  // TR: Tema modu
  // EN: Theme mode
  final bool isDarkMode;

  // TR: ThemeMode
  // EN: ThemeMode
  final ThemeMode themeMode;

  // TR: Amber modu
  // EN: Amber mode
  final bool isAmberMode;

  // TR: Dil ayarı
  // EN: Language setting
  final String language;

  // TR: Zikir sayacı
  // EN: Zikir counter
  final int zikirCounter;

  // TR: Son okunan sure
  // EN: Last read surah
  final int lastReadSurah;

  // TR: Son okunan ayet
  // EN: Last read verse
  final int lastReadAyet;

  // TR: Seçili şehir
  // EN: Selected city
  final String selectedCity;

  // TR: Onboarding görüldü mü
  // EN: Has seen onboarding
  final bool hasSeenOnboarding;

  // TR: Kart stili
  // EN: Card style
  final bool cardStyle;

  // TR: Font boyutu
  // EN: Font size
  final double fontSize;

  // TR: Seçili Mushaf fontu
  // EN: Selected Mushaf font
  final String selectedMushafFont;

  // TR: Ezan bildirimleri etkin
  // EN: Prayer notifications enabled
  final bool prayerNotificationsEnabled;

  // TR: Günlük bildirimler etkin
  // EN: Daily notifications enabled
  final bool dailyNotificationsEnabled;

  // TR: Zikir bildirimleri etkin
  // EN: Zikir notifications enabled
  final bool zikirNotificationsEnabled;

  // TR: Ezan vakti etkin mi
  // EN: Is prayer time enabled
  final bool prayerTimeEnabled;

  // TR: Konum izni verildi mi
  // EN: Is location permission granted
  final bool locationPermissionGranted;

  // TR: Otomatik konum etkin mi
  // EN: Is auto location enabled
  final bool autoLocationEnabled;

  // TR: Bildirim sesi etkin mi
  // EN: Is notification sound enabled
  final bool notificationSoundEnabled;

  // TR: Vakit öncesi hatırlatma (dakika)
  // EN: Prayer reminder minutes
  final int prayerReminderMinutes;

  // TR: Son ezan vakti
  // EN: Last prayer time
  final DateTime? lastPrayerTime;

  // TR: Hesaplama yöntemi
  // EN: Calculation method
  final String calculationMethod;

  // TR: Bildirimler etkin mi
  // EN: Are notifications enabled
  final bool notificationsEnabled;

  // TR: Ses etkin mi
  // EN: Is sound enabled
  final bool soundEnabled;

  // TR: Titreşim etkin mi
  // EN: Is vibration enabled
  final bool vibrationEnabled;

  // TR: Otomatik oynatma etkin mi
  // EN: Is auto play enabled
  final bool autoPlayEnabled;

  // TR: Son bilinen enlem
  // EN: Last known latitude
  final double? lastKnownLatitude;

  // TR: Son bilinen boylam
  // EN: Last known longitude
  final double? lastKnownLongitude;

  // TR: İlk açılış mı
  // EN: Is first launch
  final bool firstLaunch;

  // TR: Constructor
  // EN: Constructor
  const PreferencesState({
    this.isDarkMode = false,
    this.themeMode = ThemeMode.system,
    this.isAmberMode = false,
    this.language = 'tr',
    this.zikirCounter = 0,
    this.lastReadSurah = 1,
    this.lastReadAyet = 1,
    this.selectedCity = 'İstanbul',
    this.hasSeenOnboarding = false,
    this.cardStyle = true,
    this.fontSize = 20.0,
    this.selectedMushafFont = 'husrev',
    this.prayerNotificationsEnabled = true,
    this.dailyNotificationsEnabled = true,
    this.zikirNotificationsEnabled = true,
    this.prayerTimeEnabled = true,
    this.locationPermissionGranted = false,
    this.autoLocationEnabled = true,
    this.notificationSoundEnabled = true,
    this.prayerReminderMinutes = 15,
    this.lastPrayerTime,
    this.calculationMethod = 'turkey',
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.autoPlayEnabled = false,
    this.lastKnownLatitude,
    this.lastKnownLongitude,
    this.firstLaunch = true,
  });

  // TR: Initial state factory constructor - SharedPreferences hazır değilken kullanılır
  // EN: Initial state factory constructor - Used when SharedPreferences is not ready
  factory PreferencesState.initial() => const PreferencesState();

  // TR: CopyWith metodu
  // EN: CopyWith method
  PreferencesState copyWith({
    bool? isDarkMode,
    ThemeMode? themeMode,
    bool? isAmberMode,
    String? language,
    int? zikirCounter,
    int? lastReadSurah,
    int? lastReadAyet,
    String? selectedCity,
    bool? hasSeenOnboarding,
    double? fontSize,
    String? selectedMushafFont,
    bool? prayerNotificationsEnabled,
    bool? dailyNotificationsEnabled,
    bool? zikirNotificationsEnabled,
    bool? cardStyle,
    bool? prayerTimeEnabled,
    bool? locationPermissionGranted,
    bool? autoLocationEnabled,
    bool? notificationSoundEnabled,
    int? prayerReminderMinutes,
    DateTime? lastPrayerTime,
    String? calculationMethod,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? autoPlayEnabled,
    double? lastKnownLatitude,
    double? lastKnownLongitude,
    bool? firstLaunch,
  }) {
    return PreferencesState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeMode: themeMode ?? this.themeMode,
      isAmberMode: isAmberMode ?? this.isAmberMode,
      language: language ?? this.language,
      zikirCounter: zikirCounter ?? this.zikirCounter,
      lastReadSurah: lastReadSurah ?? this.lastReadSurah,
      lastReadAyet: lastReadAyet ?? this.lastReadAyet,
      selectedCity: selectedCity ?? this.selectedCity,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      fontSize: fontSize ?? this.fontSize,
      selectedMushafFont: selectedMushafFont ?? this.selectedMushafFont,
      prayerNotificationsEnabled:
          prayerNotificationsEnabled ?? this.prayerNotificationsEnabled,
      dailyNotificationsEnabled:
          dailyNotificationsEnabled ?? this.dailyNotificationsEnabled,
      zikirNotificationsEnabled:
          zikirNotificationsEnabled ?? this.zikirNotificationsEnabled,
      cardStyle: cardStyle ?? this.cardStyle,
      prayerTimeEnabled: prayerTimeEnabled ?? this.prayerTimeEnabled,
      locationPermissionGranted:
          locationPermissionGranted ?? this.locationPermissionGranted,
      autoLocationEnabled: autoLocationEnabled ?? this.autoLocationEnabled,
      notificationSoundEnabled:
          notificationSoundEnabled ?? this.notificationSoundEnabled,
      prayerReminderMinutes:
          prayerReminderMinutes ?? this.prayerReminderMinutes,
      lastPrayerTime: lastPrayerTime ?? this.lastPrayerTime,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      autoPlayEnabled: autoPlayEnabled ?? this.autoPlayEnabled,
      lastKnownLatitude: lastKnownLatitude ?? this.lastKnownLatitude,
      lastKnownLongitude: lastKnownLongitude ?? this.lastKnownLongitude,
      firstLaunch: firstLaunch ?? this.firstLaunch,
    );
  }

  // TR: Equality operator
  // EN: Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PreferencesState &&
        other.isDarkMode == isDarkMode &&
        other.themeMode == themeMode &&
        other.isAmberMode == isAmberMode &&
        other.language == language &&
        other.zikirCounter == zikirCounter &&
        other.lastReadSurah == lastReadSurah &&
        other.lastReadAyet == lastReadAyet &&
        other.selectedCity == selectedCity &&
        other.hasSeenOnboarding == hasSeenOnboarding &&
        other.fontSize == fontSize &&
        other.selectedMushafFont == selectedMushafFont &&
        other.prayerNotificationsEnabled == prayerNotificationsEnabled &&
        other.dailyNotificationsEnabled == dailyNotificationsEnabled &&
        other.zikirNotificationsEnabled == zikirNotificationsEnabled &&
        other.prayerTimeEnabled == prayerTimeEnabled &&
        other.locationPermissionGranted == locationPermissionGranted &&
        other.autoLocationEnabled == autoLocationEnabled &&
        other.notificationSoundEnabled == notificationSoundEnabled &&
        other.prayerReminderMinutes == prayerReminderMinutes &&
        other.lastPrayerTime == lastPrayerTime &&
        other.calculationMethod == calculationMethod &&
        other.notificationsEnabled == notificationsEnabled &&
        other.soundEnabled == soundEnabled &&
        other.vibrationEnabled == vibrationEnabled &&
        other.autoPlayEnabled == autoPlayEnabled &&
        other.lastKnownLatitude == lastKnownLatitude &&
        other.lastKnownLongitude == lastKnownLongitude &&
        other.firstLaunch == firstLaunch;
  }

  // TR: Hash code
  // EN: Hash code
  @override
  int get hashCode {
    return Object.hash(
      Object.hash(
        isDarkMode,
        themeMode,
        isAmberMode,
        language,
        zikirCounter,
        lastReadSurah,
        lastReadAyet,
        selectedCity,
        hasSeenOnboarding,
        fontSize,
        selectedMushafFont,
        prayerNotificationsEnabled,
        dailyNotificationsEnabled,
        zikirNotificationsEnabled,
        cardStyle,
        prayerTimeEnabled,
        locationPermissionGranted,
        autoLocationEnabled,
        notificationSoundEnabled,
      ),
      Object.hash(
        prayerReminderMinutes,
        lastPrayerTime,
        calculationMethod,
        notificationsEnabled,
        soundEnabled,
        vibrationEnabled,
        autoPlayEnabled,
        lastKnownLatitude,
        lastKnownLongitude,
        firstLaunch,
      ),
    );
  }

  // TR: String representation
  // EN: String representation
  @override
  String toString() {
    return 'PreferencesState(isDarkMode: $isDarkMode, themeMode: $themeMode, isAmberMode: $isAmberMode, language: $language, zikirCounter: $zikirCounter, lastReadSurah: $lastReadSurah, lastReadAyet: $lastReadAyet, selectedCity: $selectedCity, hasSeenOnboarding: $hasSeenOnboarding, cardStyle: $cardStyle, fontSize: $fontSize, selectedMushafFont: $selectedMushafFont, prayerNotificationsEnabled: $prayerNotificationsEnabled, dailyNotificationsEnabled: $dailyNotificationsEnabled, zikirNotificationsEnabled: $zikirNotificationsEnabled, prayerTimeEnabled: $prayerTimeEnabled, locationPermissionGranted: $locationPermissionGranted, autoLocationEnabled: $autoLocationEnabled, notificationSoundEnabled: $notificationSoundEnabled, prayerReminderMinutes: $prayerReminderMinutes, lastPrayerTime: $lastPrayerTime, calculationMethod: $calculationMethod, notificationsEnabled: $notificationsEnabled, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, autoPlayEnabled: $autoPlayEnabled, lastKnownLatitude: $lastKnownLatitude, lastKnownLongitude: $lastKnownLongitude, firstLaunch: $firstLaunch)';
  }
}

/// TR: Preferences Manager Provider - V4 yeniliği
/// EN: Preferences Manager Provider - V4 innovation
/// TR: PreferencesManager instance'ını yönetir
/// EN: Manages PreferencesManager instance
/// TR: main.dart'tan override edilebilir
/// EN: Can be overridden from main.dart
final preferencesManagerProvider = Provider<PreferencesManager>((ref) {
  throw UnimplementedError(
      'PreferencesManager must be overridden in main.dart');
});

/// TR: Preferences Provider - Riverpod ile entegrasyon
/// EN: Preferences Provider - Integration with Riverpod
/// TR: PreferencesManager'ı uygulama genelinde erişilebilir yapar
/// EN: Makes PreferencesManager accessible throughout the application
/// TR: Notifier ile senkron erişim
/// EN: Notifier compatible access
final preferencesProvider =
    NotifierProvider<PreferencesManager, PreferencesState>(
        PreferencesManager.new);

/// TR: Preferences Notifier Provider - app_providers.dart için uyumlu isim
/// EN: Preferences Notifier Provider - Compatible name for app_providers.dart
/// TR: preferencesProvider ile aynı provider - farklı isimde erişim
/// EN: Same provider as preferencesProvider - access with different name
final preferencesNotifierProvider =
    NotifierProvider<PreferencesManager, PreferencesState>(
        PreferencesManager.new);

/// TR: Preferences State Provider - V1'den miras alındı
/// EN: Preferences State Provider - Inherited from V1
/// TR: Mevcut preferences state'ine erişim sağlar
/// EN: Provides access to current preferences state
final preferencesStateProvider = Provider<PreferencesState>((ref) {
  return ref.watch(preferencesProvider);
});
