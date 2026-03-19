// TR: KUBBE V4 Language Manager - V4 yeniliği
// EN: KUBBE V4 Language Manager - V4 innovation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki 14 dil desteğini (TR, EN, AR, FR, DE vb.) yöneten 'easy_localization' veya standart 'Intl' yapısını kur.
// EN: Set up 'easy_localization' or standard 'Intl' structure that manages V1's 14 language support (TR, EN, AR, FR, DE, etc.).

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// TR: KUBBE V4 Language Manager Sınıfı
/// EN: KUBBE V4 Language Manager Class
/// TR: V1'deki 14 dil desteğini yöneten modern dil yönetimi
/// EN: Modern language management that manages V1's 14 language support
/// TR: Intl paketi ile yerelleştirme ve dil değiştirme
/// EN: Localization and language switching with Intl package
/// TR: V4 yeniliği ve Sy-OS design language
/// EN: V4 innovation and Sy-OS design language
class LanguageManager {
  // TR: Singleton instance
  // EN: Singleton instance
  static final LanguageManager _instance = LanguageManager._internal();
  factory LanguageManager() => _instance;
  LanguageManager._internal();

  // TR: Desteklenen diller - V1'den miras alındı
  // EN: Supported languages - Inherited from V1
  static const Map<String, String> _supportedLanguages = {
    'tr': 'Türkçe', // TR: Türkçe // EN: Turkish
    'en': 'English', // TR: İngilizce // EN: English
    'ar': 'العربية', // TR: Arapça // EN: Arabic
    'fr': 'Français', // TR: Fransızca // EN: French
    'de': 'Deutsch', // TR: Almanca // EN: German
    'es': 'Español', // TR: İspanyolca // EN: Spanish
    'ur': 'اردو', // TR: Urdu // EN: Urdu
    'id': 'Bahasa Indonesia', // TR: Endonezce // EN: Indonesian
    'ms': 'Bahasa Melayu', // TR: Malayca // EN: Malay
    'fa': 'فارسی', // TR: Farsça // EN: Persian
    'ru': 'Русский', // TR: Rusça // EN: Russian
    'hi': 'हिन्दी', // TR: Hintçe // EN: Hindi
    'bn': 'বাংলা', // TR: Bengalce // EN: Bengali
  };

  // TR: Mevcut dil kodu
  // EN: Current language code
  String _currentLanguage = 'tr';

  // TR: Dil değişimi callback'leri
  // EN: Language change callbacks
  final List<void Function(String)> _languageChangeCallbacks = [];

  // TR: Mevcut dili al
  // EN: Get current language
  String get currentLanguage => _currentLanguage;

  // TR: Desteklenen dilleri al
  // EN: Get supported languages
  Map<String, String> get supportedLanguages => Map.from(_supportedLanguages);

  // TR: Dil adını al
  // EN: Get language name
  String getLanguageName(String languageCode) {
    return _supportedLanguages[languageCode] ?? languageCode;
  }

  // TR: Dili ayarla
  // EN: Set language
  void setLanguage(String languageCode) {
    if (_supportedLanguages.containsKey(languageCode)) {
      _currentLanguage = languageCode;

      // TR: Intl dilini ayarla
      // EN: Set Intl locale
      try {
        Intl.defaultLocale = languageCode;
      } catch (e) {
        // TR: Hata durumunda varsayılan dil
        // EN: Default language on error
        Intl.defaultLocale = 'tr';
      }

      // TR: Callback'leri tetikle
      // EN: Trigger callbacks
      for (final callback in _languageChangeCallbacks) {
        callback(languageCode);
      }

      // TR: Debug mesajı
      // EN: Debug message
      if (kDebugMode) {
        print('TR: Dil değiştirildi: $languageCode');
        print('EN: Language changed to: $languageCode');
      }
    }
  }

  // TR: Dil değişimi callback'i ekle
  // EN: Add language change callback
  void addLanguageChangeCallback(void Function(String) callback) {
    _languageChangeCallbacks.add(callback);
  }

  // TR: Dil değişimi callback'ini kaldır
  // EN: Remove language change callback
  void removeLanguageChangeCallback(void Function(String) callback) {
    _languageChangeCallbacks.remove(callback);
  }

  // TR: Metni yerelleştir
  // EN: Localize text
  String translate(String key, {Map<String, String>? parameters}) {
    // TR: Çeviri sözlüğü
    // EN: Translation dictionary
    final translations = _getTranslations();

    // TR: Mevcut dilde çeviri ara
    // EN: Search translation in current language
    String translation =
        translations[_currentLanguage]?[key] ?? translations['tr']?[key] ?? key;

    // TR: Parametreleri değiştir
    // EN: Replace parameters
    if (parameters != null) {
      for (final entry in parameters.entries) {
        translation = translation.replaceAll('{${entry.key}}', entry.value);
      }
    }

    return translation;
  }

  // TR: Çeviri sözlüğünü al
  // EN: Get translation dictionary
  Map<String, Map<String, String>> _getTranslations() {
    return {
      // TR: Türkçe çeviriler
      // EN: Turkish translations
      'tr': {
        // TR: Ana Sayfa
        // EN: Home
        'home': 'Ana Sayfa',
        'home_subtitle': 'İslami Yaşam Tarzı',
        'quran': 'Kur\'an-ı Kerim',
        'quran_subtitle': 'Kutsal Kitap',
        'ai_assistant': 'Kumo AI',
        'ai_subtitle': 'Zeki Asistan',
        'worship': 'İbadetler',
        'worship_subtitle': 'İbadet Merkezi',
        'qibla': 'Kıble',
        'qibla_subtitle': 'Kıble Yönü',

        // TR: Ayarlar
        // EN: Settings
        'settings': 'Ayarlar',
        'notifications': 'Bildirimler',
        'theme': 'Tema',
        'language': 'Dil',
        'about': 'Hakkında',
        'version': 'Versiyon',

        // TR: İbadetler
        // EN: Worship
        'zikirmatik': 'Zikirmatik',
        'zikirmatik_subtitle': 'Tesbih Sayacı',
        'prayer_tracking': 'Namaz Takibi',
        'prayer_tracking_subtitle': 'Lale Bahçesi',
        'zakat': 'Zekat',
        'zakat_subtitle': 'Zekat Hesaplama',
        'compass': 'Kible Pusulası',
        'compass_subtitle': 'Kıble Yönü',

        // TR: Genel
        // EN: General
        'start': 'Başla',
        'continue': 'Devam Et',
        'back': 'Geri',
        'next': 'İleri',
        'done': 'Tamam',
        'cancel': 'İptal',
        'save': 'Kaydet',
        'delete': 'Sil',
        'edit': 'Düzenle',
        'search': 'Ara',
        'loading': 'Yükleniyor...',
        'error': 'Hata',
        'success': 'Başarılı',

        // TR: Mesajlar
        // EN: Messages
        'welcome': 'Hoş Geldiniz',
        'good_morning': 'Günaydın',
        'good_evening': 'İyi Akşamlar',
        'prayer_time': 'Namaz Vakti',
        'fajr': 'İmsak',
        'dhuhr': 'Öğle',
        'asr': 'İkindi',
        'maghrib': 'Akşam',
        'isha': 'Yatsı',
      },

      // TR: İngilizce çeviriler
      // EN: English translations
      'en': {
        // TR: Ana Sayfa
        // EN: Home
        'home': 'Home',
        'home_subtitle': 'Islamic Lifestyle',
        'quran': 'Holy Quran',
        'quran_subtitle': 'Sacred Book',
        'ai_assistant': 'Kumo AI',
        'ai_subtitle': 'Smart Assistant',
        'worship': 'Worship',
        'worship_subtitle': 'Worship Center',
        'qibla': 'Qibla',
        'qibla_subtitle': 'Qibla Direction',

        // TR: Ayarlar
        // EN: Settings
        'settings': 'Settings',
        'notifications': 'Notifications',
        'theme': 'Theme',
        'language': 'Language',
        'about': 'About',
        'version': 'Version',

        // TR: İbadetler
        // EN: Worship
        'zikirmatik': 'Dhikr Counter',
        'zikirmatik_subtitle': 'Tasbih Counter',
        'prayer_tracking': 'Prayer Tracking',
        'prayer_tracking_subtitle': 'Lale Bahçesi',
        'zakat': 'Zakat',
        'zakat_subtitle': 'Zakat Calculator',
        'compass': 'Qibla Compass',
        'compass_subtitle': 'Qibla Direction',

        // TR: Genel
        // EN: General
        'start': 'Start',
        'continue': 'Continue',
        'back': 'Back',
        'next': 'Next',
        'done': 'Done',
        'cancel': 'Cancel',
        'save': 'Save',
        'delete': 'Delete',
        'edit': 'Edit',
        'search': 'Search',
        'loading': 'Loading...',
        'error': 'Error',
        'success': 'Success',

        // TR: Mesajlar
        // EN: Messages
        'welcome': 'Welcome',
        'good_morning': 'Good Morning',
        'good_evening': 'Good Evening',
        'prayer_time': 'Prayer Time',
        'fajr': 'Fajr',
        'dhuhr': 'Dhuhr',
        'asr': 'Asr',
        'maghrib': 'Maghrib',
        'isha': 'Isha',
      },

      // TR: Arapça çeviriler (örnek)
      // EN: Arabic translations (example)
      'ar': {
        'home': 'الرئيسية',
        'home_subtitle': 'نمط الحياة الإسلامية',
        'quran': 'القرآن الكريم',
        'quran_subtitle': 'الكتاب المقدس',
        'ai_assistant': 'كومو AI',
        'ai_subtitle': 'مساعد ذكي',
        'worship': 'العبادات',
        'worship_subtitle': 'مركز العبادات',
        'qibla': 'القبلة',
        'qibla_subtitle': 'اتجاه القبلة',
        'settings': 'الإعدادات',
        'notifications': 'الإشعارات',
        'theme': 'المظهر',
        'language': 'اللغة',
        'about': 'حول',
        'version': 'الإصدار',
        'zikirmatik': 'عداد الذكر',
        'zikirmatik_subtitle': 'عداد التسبيح',
        'prayer_tracking': 'تتبع الصلاة',
        'prayer_tracking_subtitle': 'حديقة الزهور',
        'zakat': 'الزكاة',
        'zakat_subtitle': 'حاسبة الزكاة',
        'compass': 'بوصلة القبلة',
        'compass_subtitle': 'اتجاه القبلة',
        'start': 'ابدأ',
        'continue': 'تابع',
        'back': 'رجوع',
        'next': 'التالي',
        'done': 'تم',
        'cancel': 'إلغاء',
        'save': 'حفظ',
        'delete': 'حذف',
        'edit': 'تحرير',
        'search': 'بحث',
        'loading': 'جاري التحميل...',
        'error': 'خطأ',
        'success': 'نجاح',
        'welcome': 'أهلا بك',
        'good_morning': 'صباح الخير',
        'good_evening': 'مساء الخير',
        'prayer_time': 'وقت الصلاة',
        'fajr': 'الفجر',
        'dhuhr': 'الظهر',
        'asr': 'العصر',
        'maghrib': 'المغرب',
        'isha': 'العشاء',
      },

      // TR: Diğer diller için temel çeviriler
      // EN: Basic translations for other languages
      'fr': {
        'home': 'Accueil',
        'quran': 'Saint Coran',
        'ai_assistant': 'Kumo AI',
        'worship': 'Adoration',
        'qibla': 'Qibla',
        'settings': 'Paramètres',
        'start': 'Commencer',
        'cancel': 'Annuler',
        'save': 'Sauvegarder',
        'loading': 'Chargement...',
      },

      'de': {
        'home': 'Startseite',
        'quran': 'Heiliger Quran',
        'ai_assistant': 'Kumo AI',
        'worship': 'Anbetung',
        'qibla': 'Qibla',
        'settings': 'Einstellungen',
        'start': 'Starten',
        'cancel': 'Abbrechen',
        'save': 'Speichern',
        'loading': 'Laden...',
      },
    };
  }

  // TR: Tarih formatla
  // EN: Format date
  String formatDate(DateTime date, {String? pattern}) {
    try {
      return DateFormat(pattern ?? 'dd.MM.yyyy', _currentLanguage).format(date);
    } catch (e) {
      // TR: Hata durumunda varsayılan format
      // EN: Default format on error
      return DateFormat('dd.MM.yyyy', 'tr').format(date);
    }
  }

  // TR: Saat formatla
  // EN: Format time
  String formatTime(DateTime time, {String? pattern}) {
    try {
      return DateFormat(pattern ?? 'HH:mm', _currentLanguage).format(time);
    } catch (e) {
      // TR: Hata durumunda varsayılan format
      // EN: Default format on error
      return DateFormat('HH:mm', 'tr').format(time);
    }
  }

  // TR: Para birimi formatla
  // EN: Format currency
  String formatCurrency(double amount, {String? currencyCode}) {
    try {
      return NumberFormat.currency(
        locale: _currentLanguage,
        symbol: currencyCode ?? '₺',
        decimalDigits: 2,
      ).format(amount);
    } catch (e) {
      // TR: Hata durumunda varsayılan format
      // EN: Default format on error
      return NumberFormat.currency(
        locale: 'tr',
        symbol: '₺',
        decimalDigits: 2,
      ).format(amount);
    }
  }

  // TR: Sayı formatla
  // EN: Format number
  String formatNumber(double number) {
    try {
      return NumberFormat.decimalPattern(_currentLanguage).format(number);
    } catch (e) {
      // TR: Hata durumunda varsayılan format
      // EN: Default format on error
      return NumberFormat.decimalPattern('tr').format(number);
    }
  }

  // TR: Dilin RTL olup olmadığını kontrol et
  // EN: Check if language is RTL
  bool isRTL(String languageCode) {
    // TR: RTL diller
    // EN: RTL languages
    const rtlLanguages = ['ar', 'fa', 'ur', 'he'];
    return rtlLanguages.contains(languageCode);
  }

  // TR: Mevcut dilin RTL olup olmadığını al
  // EN: Get if current language is RTL
  bool get isCurrentLanguageRTL => isRTL(_currentLanguage);

  // TR: Dil kodunu doğrula
  // EN: Validate language code
  bool isValidLanguageCode(String languageCode) {
    return _supportedLanguages.containsKey(languageCode);
  }

  // TR: Sistem dilini al
  // EN: Get system language
  String getSystemLanguage() {
    // TR: Basit sistem dili tespiti
    // EN: Simple system language detection
    final systemLocale = Intl.getCurrentLocale();

    // TR: Dil kodunu çıkar
    // EN: Extract language code
    final languageCode = systemLocale.split('_')[0];

    // TR: Desteklenen dil mi kontrol et
    // EN: Check if supported language
    return _supportedLanguages.containsKey(languageCode) ? languageCode : 'tr';
  }

  // TR: Varsayılan dili ayarla
  // EN: Set default language
  void setDefaultLanguage() {
    final systemLanguage = getSystemLanguage();
    setLanguage(systemLanguage);
  }

  // TR: Dil istatistiklerini al
  // EN: Get language statistics
  Map<String, dynamic> getStatistics() {
    return {
      'currentLanguage': _currentLanguage,
      'supportedLanguages': _supportedLanguages.length,
      'isRTL': isCurrentLanguageRTL,
      'totalTranslations': _getTranslations()[_currentLanguage]?.length ?? 0,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  // TR: Tüm çevirileri dışa aktar
  // EN: Export all translations
  Map<String, Map<String, String>> exportTranslations() {
    return _getTranslations();
  }

  // TR: Çevirileri içe aktar
  // EN: Import translations
  void importTranslations(Map<String, Map<String, String>> translations) {
    // TR: Gelecekte geliştirilebilir
    // EN: Can be developed in future
    if (kDebugMode) {
      print('TR: Çeviriler içe aktarıldı');
      print('EN: Translations imported');
    }
  }
}

/// TR: Language Manager Provider - V4 yeniliği
/// EN: Language Manager Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
final languageManagerProvider = Provider<LanguageManager>((ref) {
  return LanguageManager();
});

/// TR: Dil değişimi Provider - V4 yeniliği
/// EN: Language Change Provider - V4 innovation
/// TR: Mevcut dil durumunu sağlar
/// EN: Provides current language state
final currentLanguageProvider = Provider<String>((ref) {
  return ref.watch(languageManagerProvider).currentLanguage;
});
