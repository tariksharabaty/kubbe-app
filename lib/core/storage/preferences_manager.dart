// TR: KUBBE V4 Preferences Manager - Clean Version
// EN: KUBBE V4 Preferences Manager - Clean Version
// TR: Sadece temel ayarları tutan basit yapı
// EN: Simple structure that holds only basic settings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// TR: KUBBE V4 Preferences Manager Sınıfı
/// EN: KUBBE V4 Preferences Manager Class
/// TR: Sadece isFirstTime, language, themeMode ve termsAccepted verilerini yönetir
/// EN: Manages only isFirstTime, language, themeMode and termsAccepted data
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
  @override
  PreferencesState build() {
    // TR: SharedPrefs zaten main.dart'tan enjekte edildi
    // EN: SharedPrefs already injected from main.dart
    if (_prefs == null) {
      // TR: SharedPrefs henüz hazır değilse varsayılan state döndür
      // EN: Return default state if SharedPrefs is not ready yet
      return PreferencesState.initial();
    }

    // TR: Kayıtlı temel ayarları yükle
    // EN: Load saved basic settings
    final state = PreferencesState(
      isFirstTime: _prefs?.getBool('isFirstTime') ?? true,
      language: _prefs?.getString('language') ?? 'tr',
      themeMode: _getThemeModeFromString(
        _prefs?.getString('themeMode') ?? 'system',
      ),
      termsAccepted: _prefs?.getBool('termsAccepted') ?? false,
    );

    return state;
  }

  // TR: İlk kullanım durumunu ayarla
  // EN: Set first time usage
  Future<void> setFirstTime(bool isFirstTime) async {
    if (_prefs == null) return;

    await _prefs!.setBool('isFirstTime', isFirstTime);
    state = state.copyWith(isFirstTime: isFirstTime);
  }

  // TR: Dil ayarını değiştir
  // EN: Change language setting
  Future<void> setLanguage(String language) async {
    if (_prefs == null) return;

    await _prefs!.setString('language', language);
    state = state.copyWith(language: language);
  }

  // TR: Tema modunu ayarla
  // EN: Set theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_prefs == null) return;

    final themeModeString = _getThemeModeString(themeMode);
    await _prefs!.setString('themeMode', themeModeString);
    state = state.copyWith(themeMode: themeMode);
  }

  // TR: Kullanım koşullarını kabul et
  // EN: Accept terms and conditions
  Future<void> setTermsAccepted(bool accepted) async {
    if (_prefs == null) return;

    await _prefs!.setBool('termsAccepted', accepted);
    state = state.copyWith(termsAccepted: accepted);
  }

  // TR: ThemeMode string'e dönüştür
  // EN: Convert ThemeMode to string
  String _getThemeModeString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  // TR: ThemeMode string'den dönüştür
  // EN: Convert ThemeMode from string
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

  // TR: Legacy methods for backward compatibility
  // EN: Legacy methods for backward compatibility

  // TR: Tema değiştir (legacy)
  // EN: Change theme (legacy)
  Future<void> setTheme(bool isDarkMode) async {
    if (_prefs == null) return;
    await _prefs!.setBool('isDarkMode', isDarkMode);
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  // TR: Amber modunu ayarla
  // EN: Set amber mode
  Future<void> setAmberMode(bool isAmberMode) async {
    if (_prefs == null) return;
    await _prefs!.setBool('isAmberMode', isAmberMode);
    state = state.copyWith(isAmberMode: isAmberMode);
  }

  // TR: Zikir sayacını ayarla
  // EN: Set zikir counter
  Future<void> setZikirCounter(int count) async {
    if (_prefs == null) return;
    await _prefs!.setInt('zikirCounter', count);
    state = state.copyWith(zikirCounter: count);
  }

  // TR: Son okunan sureyi ayarla
  // EN: Set last read surah
  Future<void> setLastReadSurah(int surahNumber) async {
    if (_prefs == null) return;
    await _prefs!.setInt('lastReadSurah', surahNumber);
    state = state.copyWith(lastReadSurah: surahNumber);
  }

  // TR: Onboarding görüldü olarak ayarla
  // EN: Set onboarding as seen
  Future<void> setOnboardingSeen([bool seen = true]) async {
    if (_prefs == null) return;
    await _prefs!.setBool('hasSeenOnboarding', seen);
    state = state.copyWith(hasSeenOnboarding: seen);
  }

  // TR: Font boyutunu ayarla
  // EN: Set font size
  Future<void> setFontSize(double fontSize) async {
    if (_prefs == null) return;
    await _prefs!.setDouble('fontSize', fontSize);
    state = state.copyWith(fontSize: fontSize);
  }

  // TR: Kart stilini ayarla
  // EN: Set card style
  Future<void> setCardStyle(bool cardStyle) async {
    if (_prefs == null) return;
    await _prefs!.setBool('cardStyle', cardStyle);
    state = state.copyWith(cardStyle: cardStyle);
  }

  // TR: Ezan bildirimlerini ayarla
  // EN: Set prayer notifications
  Future<void> setPrayerNotificationsEnabled(bool enabled) async {
    if (_prefs == null) return;
    await _prefs!.setBool('prayerNotificationsEnabled', enabled);
    state = state.copyWith(prayerNotificationsEnabled: enabled);
  }

  // TR: Günlük bildirimleri ayarla
  // EN: Set daily notifications
  Future<void> setDailyNotificationsEnabled(bool enabled) async {
    if (_prefs == null) return;
    await _prefs!.setBool('dailyNotificationsEnabled', enabled);
    state = state.copyWith(dailyNotificationsEnabled: enabled);
  }

  // TR: Zikir bildirimlerini ayarla
  // EN: Set zikir notifications
  Future<void> setZikirNotificationsEnabled(bool enabled) async {
    if (_prefs == null) return;
    await _prefs!.setBool('zikirNotificationsEnabled', enabled);
    state = state.copyWith(zikirNotificationsEnabled: enabled);
  }

  // TR: Bildirimleri etkinleştir/devre dışı bırak
  // EN: Enable/disable notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    if (_prefs == null) return;
    await _prefs!.setBool('notificationsEnabled', enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }

  // TR: Sesi etkinleştir/devre dışı bırak
  // EN: Enable/disable sound
  Future<void> setSoundEnabled(bool enabled) async {
    if (_prefs == null) return;
    await _prefs!.setBool('soundEnabled', enabled);
    state = state.copyWith(soundEnabled: enabled);
  }

  // TR: Titreşimi etkinleştir/devre dışı bırak
  // EN: Enable/disable vibration
  Future<void> setVibrationEnabled(bool enabled) async {
    if (_prefs == null) return;
    await _prefs!.setBool('vibrationEnabled', enabled);
    state = state.copyWith(vibrationEnabled: enabled);
  }

  // TR: Seçili şehri ayarla
  // EN: Set selected city
  Future<void> setSelectedCity(String city) async {
    if (_prefs == null) return;
    await _prefs!.setString('selectedCity', city);
    state = state.copyWith(selectedCity: city);
  }

  // TR: Mushaf fontunu ayarla
  // EN: Set mushaf font
  Future<void> setMushafFont(String fontId) async {
    if (_prefs == null) return;
    await _prefs!.setString('selectedMushafFont', fontId);
    state = state.copyWith(selectedMushafFont: fontId);
  }

  // TR: Konum izni ayarla - Statik erişim
  // EN: Set location permission granted - Static access
  static Future<void> setLocationPermissionGrantedStatic(bool granted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('locationPermissionGranted', granted);
  }

  // TR: Son bilinen konumu ayarla - Statik erişim
  // EN: Set last known location - Static access
  static Future<void> setLastKnownLocationStatic(
    double latitude,
    double longitude,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('lastKnownLatitude', latitude);
    await prefs.setDouble('lastKnownLongitude', longitude);
  }

  // TR: Son bilinen konumu al - Statik erişim
  // EN: Get last known location - Static access
  static Future<(double?, double?)> getLastKnownLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('lastKnownLatitude');
    final lon = prefs.getDouble('lastKnownLongitude');
    return (lat, lon);
  }

  // TR: Konum izni verildi mi - Statik erişim
  // EN: Is location permission granted - Static access
  static Future<bool> isLocationPermissionGranted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('locationPermissionGranted') ?? false;
  }

  // TR: Son bilinen konumu ayarla
  // EN: Set last known location
  Future<void> setLastKnownLocation(double latitude, double longitude) async {
    if (_prefs == null) return;
    await _prefs!.setDouble('lastKnownLatitude', latitude);
    await _prefs!.setDouble('lastKnownLongitude', longitude);
    state = state.copyWith(
      lastKnownLatitude: latitude,
      lastKnownLongitude: longitude,
    );
  }

  // TR: Zikir sayacını artır
  // EN: Increment zikir counter
  Future<void> incrementZikir() async {
    if (_prefs == null) return;
    final newCount = state.zikirCounter + 1;
    await _prefs!.setInt('zikirCounter', newCount);
    state = state.copyWith(zikirCounter: newCount);
  }

  // TR: Zikir sayacını sıfırla
  // EN: Reset zikir counter
  Future<void> resetZikir() async {
    await setZikirCounter(0);
  }
}

/// TR: Preferences State Model - Sadece temel alanlar
/// EN: Preferences State Model - Only basic fields
class PreferencesState {
  // TR: İlk kullanım mı
  // EN: Is first time usage
  final bool isFirstTime;

  // TR: Dil ayarı
  // EN: Language setting
  final String language;

  // TR: Tema modu
  // EN: Theme mode
  final ThemeMode themeMode;

  // TR: Kullanım koşulları kabul edildi mi
  // EN: Are terms and conditions accepted
  final bool termsAccepted;

  // TR: Legacy properties for backward compatibility
  // EN: Legacy properties for backward compatibility
  final bool isDarkMode;
  final bool isAmberMode;
  final int zikirCounter;
  final int lastReadSurah;
  final int lastReadAyet;
  final String selectedCity;
  final bool hasSeenOnboarding;
  final bool cardStyle;
  final double fontSize;
  final String selectedMushafFont;
  final bool prayerNotificationsEnabled;
  final bool dailyNotificationsEnabled;
  final bool zikirNotificationsEnabled;
  final bool prayerTimeEnabled;
  final bool locationPermissionGranted;
  final bool autoLocationEnabled;
  final bool notificationSoundEnabled;
  final int prayerReminderMinutes;
  final DateTime? lastPrayerTime;
  final String calculationMethod;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool autoPlayEnabled;
  final double? lastKnownLatitude;
  final double? lastKnownLongitude;

  // TR: Constructor
  // EN: Constructor
  const PreferencesState({
    this.isFirstTime = true,
    this.language = 'tr',
    this.themeMode = ThemeMode.system,
    this.termsAccepted = false,
    // TR: Legacy defaults
    // EN: Legacy defaults
    this.isDarkMode = false,
    this.isAmberMode = false,
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
  });

  // TR: Initial state factory constructor
  // EN: Initial state factory constructor
  factory PreferencesState.initial() => const PreferencesState();

  // TR: CopyWith metodu
  // EN: CopyWith method
  PreferencesState copyWith({
    bool? isFirstTime,
    String? language,
    ThemeMode? themeMode,
    bool? termsAccepted,
    // TR: Legacy properties
    // EN: Legacy properties
    bool? isDarkMode,
    bool? isAmberMode,
    int? zikirCounter,
    int? lastReadSurah,
    int? lastReadAyet,
    String? selectedCity,
    bool? hasSeenOnboarding,
    bool? cardStyle,
    double? fontSize,
    String? selectedMushafFont,
    bool? prayerNotificationsEnabled,
    bool? dailyNotificationsEnabled,
    bool? zikirNotificationsEnabled,
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
  }) {
    return PreferencesState(
      isFirstTime: isFirstTime ?? this.isFirstTime,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      // TR: Legacy properties
      // EN: Legacy properties
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isAmberMode: isAmberMode ?? this.isAmberMode,
      zikirCounter: zikirCounter ?? this.zikirCounter,
      lastReadSurah: lastReadSurah ?? this.lastReadSurah,
      lastReadAyet: lastReadAyet ?? this.lastReadAyet,
      selectedCity: selectedCity ?? this.selectedCity,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      cardStyle: cardStyle ?? this.cardStyle,
      fontSize: fontSize ?? this.fontSize,
      selectedMushafFont: selectedMushafFont ?? this.selectedMushafFont,
      prayerNotificationsEnabled:
          prayerNotificationsEnabled ?? this.prayerNotificationsEnabled,
      dailyNotificationsEnabled:
          dailyNotificationsEnabled ?? this.dailyNotificationsEnabled,
      zikirNotificationsEnabled:
          zikirNotificationsEnabled ?? this.zikirNotificationsEnabled,
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
    );
  }
}

/// TR: Preferences Manager Provider
/// EN: Preferences Manager Provider
final preferencesManagerProvider =
    NotifierProvider<PreferencesManager, PreferencesState>(
  PreferencesManager.new,
);

/// TR: Preferences State Provider (for backward compatibility)
/// EN: Preferences State Provider (for backward compatibility)
final preferencesStateProvider = Provider<PreferencesState>((ref) {
  return ref.watch(preferencesManagerProvider);
});

/// TR: Preferences Notifier Provider (for backward compatibility)
/// EN: Preferences Notifier Provider (for backward compatibility)
final preferencesNotifierProvider =
    NotifierProvider<PreferencesManager, PreferencesState>(
  PreferencesManager.new,
);

/// TR: Preferences Provider (for backward compatibility)
/// EN: Preferences Provider (for backward compatibility)
final preferencesProvider =
    NotifierProvider<PreferencesManager, PreferencesState>(
  PreferencesManager.new,
);
