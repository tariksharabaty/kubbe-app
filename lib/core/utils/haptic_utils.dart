// TR: KUBBE V4 Haptic Utils - V4 yeniliği
// EN: KUBBE V4 Haptic Utils - V4 innovation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Android cihazlarda 'mekanik tesbih' hissi veren titreşim yardımcı sınıfını oluştur
// EN: Create vibration helper class that gives 'mechanical tesbih' feeling on Android devices

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// TR: KUBBE V4 Haptic Utils Sınıfı
/// EN: KUBBE V4 Haptic Utils Class
/// TR: Android cihazlarda mekanik tesbih hissi veren titreşimler
/// EN: Vibrations that give mechanical tesbih feeling on Android devices
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
/// TR: Farklı titreşim tipleri ve yoğunlukları
/// EN: Different vibration types and intensities
/// TR: Zikirmatik ve diğer ibadetler için özel titreşimler
/// EN: Special vibrations for zikirmatik and other worship activities
class HapticUtils {
  // TR: Vibration controller (Android için)
  // EN: Vibration controller (for Android)
  static const MethodChannel _vibrationChannel = MethodChannel('vibration');

  // TR: Hafif titreşim - Zikir için
  // EN: Light vibration - For zikir
  // TR: TR: Hafif bir titreşim verir, zikir sayarken kullanılır
  // EN: EN: Gives a light vibration, used while counting zikir
  static Future<void> lightImpact() async {
    try {
      // TR: Haptic feedback
      // EN: Haptic feedback
      await HapticFeedback.lightImpact();

      // TR: Android için özel titreşim
      // EN: Custom vibration for Android
      if (!kDebugMode) {
        await _vibratePattern(
            [0, 50], 100); // TR: 50ms titreşim // EN: 50ms vibration
      }
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Hafif titreşim hatası: $e');
      debugPrint('EN: Light vibration error: $e');
    }
  }

  // TR: Orta titreşim - 33 zikir için
  // EN: Medium vibration - For 33 zikir
  // TR: TR: Orta şiddette bir titreşim verir, 33 zikir tamamlandığında kullanılır
  // EN: EN: Gives a medium intensity vibration, used when 33 zikir completed
  static Future<void> mediumImpact() async {
    try {
      // TR: Haptic feedback
      // EN: Haptic feedback
      await HapticFeedback.mediumImpact();

      // TR: Android için özel titreşim
      // EN: Custom vibration for Android
      if (!kDebugMode) {
        await _vibratePattern(
            [0, 100], 150); // TR: 100ms titreşim // EN: 100ms vibration
      }
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Orta titreşim hatası: $e');
      debugPrint('EN: Medium vibration error: $e');
    }
  }

  // TR: Güçlü titreşim - 99 zikir için
  // EN: Strong vibration - For 99 zikir
  // TR: TR: Güçlü bir titreşim verir, 99 zikir tamamlandığında kullanılır
  // EN: EN: Gives a strong vibration, used when 99 zikir completed
  static Future<void> heavyImpact() async {
    try {
      // TR: Haptic feedback
      // EN: Haptic feedback
      await HapticFeedback.heavyImpact();

      // TR: Android için özel titreşim
      // EN: Custom vibration for Android
      if (!kDebugMode) {
        await _vibratePattern(
            [0, 200], 200); // TR: 200ms titreşim // EN: 200ms vibration
      }
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Güçlü titreşim hatası: $e');
      debugPrint('EN: Strong vibration error: $e');
    }
  }

  // TR: Seçim titreşimi - Butonlar için
  // EN: Selection vibration - For buttons
  // TR: TR: Seçim hissi veren titreşim, butonlara basıldığında kullanılır
  // EN: EN: Selection feeling vibration, used when buttons are pressed
  static Future<void> selectionClick() async {
    try {
      // TR: Haptic feedback
      // EN: Haptic feedback
      await HapticFeedback.selectionClick();

      // TR: Android için özel titreşim
      // EN: Custom vibration for Android
      if (!kDebugMode) {
        await _vibratePattern(
            [0, 25], 50); // TR: 25ms titreşim // EN: 25ms vibration
      }
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Seçim titreşimi hatası: $e');
      debugPrint('EN: Selection vibration error: $e');
    }
  }

  // TR: Başarı titreşimi - Namaz tamamlandığında
  // EN: Success vibration - When prayer completed
  // TR: TR: Başarı hissi veren titreşim, namaz tamamlandığında kullanılır
  // EN: EN: Success feeling vibration, used when prayer completed
  static Future<void> successVibration() async {
    try {
      // TR: Android için özel titreşim deseni
      // EN: Custom vibration pattern for Android
      if (!kDebugMode) {
        await _vibratePattern([0, 100, 50, 100],
            300); // TR: 100-50-100ms desen // EN: 100-50-100ms pattern
      } else {
        // TR: Debug modunda haptic feedback
        // EN: Haptic feedback in debug mode
        await HapticFeedback.mediumImpact();
      }
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Başarı titreşimi hatası: $e');
      debugPrint('EN: Success vibration error: $e');
    }
  }

  // TR: Uyarı titreşimi - Hata durumunda
  // EN: Warning vibration - For error cases
  // TR: TR: Uyarı hissi veren titreşim, hata durumunda kullanılır
  // EN: EN: Warning feeling vibration, used in error cases
  static Future<void> warningVibration() async {
    try {
      // TR: Android için özel titreşim deseni
      // EN: Custom vibration pattern for Android
      if (!kDebugMode) {
        await _vibratePattern([0, 200, 100, 200],
            400); // TR: 200-100-200ms desen // EN: 200-100-200ms pattern
      } else {
        // TR: Debug modunda haptic feedback
        // EN: Haptic feedback in debug mode
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Uyarı titreşimi hatası: $e');
      debugPrint('EN: Warning vibration error: $e');
    }
  }

  // TR: Tesbih deseni - Mekanik tesbih hissi
  // EN: Tesbih pattern - Mechanical tesbih feeling
  // TR: TR: Mekanik tesbih hissi veren özel titreşim deseni
  // EN: EN: Special vibration pattern that gives mechanical tesbih feeling
  static Future<void> tesbihPattern() async {
    try {
      // TR: Android için özel titreşim deseni
      // EN: Custom vibration pattern for Android
      if (!kDebugMode) {
        await _vibratePattern([0, 30, 20, 30, 20, 30],
            150); // TR: 30-20-30-20-30ms desen // EN: 30-20-30-20-30ms pattern
      } else {
        // TR: Debug modunda haptic feedback
        // EN: Haptic feedback in debug mode
        await HapticFeedback.lightImpact();
      }
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Tesbih deseni hatası: $e');
      debugPrint('EN: Tesbih pattern error: $e');
    }
  }

  // TR: Namaz vakti deseni - Namaz vakti geldiğinde
  // EN: Prayer time pattern - When prayer time comes
  // TR: TR: Namaz vakti geldiğini belirten özel titreşim deseni
  // EN: EN: Special vibration pattern that indicates prayer time has come
  static Future<void> prayerTimePattern() async {
    try {
      // TR: Android için özel titreşim deseni
      // EN: Custom vibration pattern for Android
      if (!kDebugMode) {
        await _vibratePattern([
          0,
          150,
          100,
          150,
          100,
          150
        ], 500); // TR: 150-100-150-100-150ms desen // EN: 150-100-150-100-150ms pattern
      } else {
        // TR: Debug modunda haptic feedback
        // EN: Haptic feedback in debug mode
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Namaz vakti deseni hatası: $e');
      debugPrint('EN: Prayer time pattern error: $e');
    }
  }

  // TR: Özel titreşim deseni
  // EN: Custom vibration pattern
  // TR: TR: Belirtilen desene göre titreşim verir
  // EN: EN: Gives vibration according to specified pattern
  static Future<void> _vibratePattern(List<int> pattern, int duration) async {
    try {
      // TR: Android için titreşim deseni
      // EN: Vibration pattern for Android
      await _vibrationChannel.invokeMethod('vibrate', {
        'pattern': pattern,
        'duration': duration,
      });
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Özel titreşim deseni hatası: $e');
      debugPrint('EN: Custom vibration pattern error: $e');
    }
  }

  // TR: Titreşim desteğini kontrol et
  // EN: Check vibration support
  // TR: TR: Cihazın titreşim desteğini kontrol eder
  // EN: EN: Checks if device supports vibration
  static Future<bool> hasVibratorSupport() async {
    try {
      // TR: Android için kontrol
      // EN: Check for Android
      if (!kDebugMode) {
        final result = await _vibrationChannel.invokeMethod('hasVibrator');
        return result as bool? ?? false;
      }
      return true;
    } catch (e) {
      // TR: Hata durumunda false döndür
      // EN: Return false on error
      debugPrint('TR: Titreşim desteği kontrolü hatası: $e');
      debugPrint('EN: Vibration support check error: $e');
      return false;
    }
  }

  // TR: Titreşimi durdur
  // EN: Stop vibration
  // TR: TR: Mevcut titreşimi durdurur
  // EN: EN: Stops current vibration
  static Future<void> stopVibration() async {
    try {
      // TR: Android için durdur
      // EN: Stop for Android
      if (!kDebugMode) {
        await _vibrationChannel.invokeMethod('cancelVibration');
      }
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Titreşim durdurma hatası: $e');
      debugPrint('EN: Stop vibration error: $e');
    }
  }

  // TR: Zikirmatik için özel titreşim
  // EN: Special vibration for zikirmatik
  // TR: TR: Zikirmatik sayısına göre farklı titreşimler verir
  // EN: EN: Gives different vibrations based on zikirmatik count
  static Future<void> zikirmatikVibration(int count, int targetCount) async {
    try {
      // TR: Hedef sayıya göre titreşim
      // EN: Vibration based on target count
      if (count == targetCount) {
        // TR: Hedef tamamlandı - güçlü titreşim
        // EN: Target completed - strong vibration
        await heavyImpact();
      } else if (count % 33 == 0 && count > 0) {
        // TR: 33'e ulaşıldı - orta titreşim
        // EN: Reached 33 - medium vibration
        await mediumImpact();
      } else if (count % 11 == 0 && count > 0) {
        // TR: 11'e ulaşıldı - hafif titreşim
        // EN: Reached 11 - light vibration
        await lightImpact();
      } else {
        // TR: Normal zikir - çok hafif titreşim
        // EN: Normal zikir - very light vibration
        await _vibratePattern([0, 10], 20);
      }
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Zikirmatik titreşimi hatası: $e');
      debugPrint('EN: Zikirmatik vibration error: $e');
    }
  }

  // TR: Namaz takibi için özel titreşim
  // EN: Special vibration for prayer tracking
  // TR: TR: Namaz işaretlemesi için özel titreşimler
  // EN: EN: Special vibrations for prayer marking
  static Future<void> prayerTrackingVibration(
      int completedCount, int totalCount) async {
    try {
      // TR: Tamamlanan namaz sayısına göre titreşim
      // EN: Vibration based on completed prayer count
      if (completedCount == totalCount) {
        // TR: Tüm namazlar tamamlandı - başarı deseni
        // EN: All prayers completed - success pattern
        await successVibration();
      } else if (completedCount == 3) {
        // TR: 3 namaz tamamlandı - orta titreşim
        // EN: 3 prayers completed - medium vibration
        await mediumImpact();
      } else {
        // TR: Normal işaretleme - hafif titreşim
        // EN: Normal marking - light vibration
        await lightImpact();
      }
    } catch (e) {
      // TR: Hata durumunda sessiz kal
      // EN: Silent on error
      debugPrint('TR: Namaz takibi titreşimi hatası: $e');
      debugPrint('EN: Prayer tracking vibration error: $e');
    }
  }
}

/// TR: Haptic Type Enum - V4 yeniliği
/// EN: Haptic Type Enum - V4 innovation
/// TR: Farklı titreşim tiplerini tanımlar
/// EN: Defines different vibration types
enum HapticType {
  // TR: Hafif
  // EN: Light
  light,

  // TR: Orta
  // EN: Medium
  medium,

  // TR: Güçlü
  // EN: Heavy
  heavy,

  // TR: Seçim
  // EN: Selection
  selection,

  // TR: Başarı
  // EN: Success
  success,

  // TR: Uyarı
  // EN: Warning
  warning,

  // TR: Tesbih
  // EN: Tesbih
  tesbih,

  // TR: Namaz vakti
  // EN: Prayer time
  prayerTime,
}

/// TR: Haptic Manager - V4 yeniliği
/// EN: Haptic Manager - V4 innovation
/// TR: Titreşim yönetimi için yardımcı sınıf
/// EN: Helper class for vibration management
class HapticManager {
  // TR: Singleton instance
  // EN: Singleton instance
  static final HapticManager _instance = HapticManager._internal();
  factory HapticManager() => _instance;
  HapticManager._internal();

  // TR: Titreşimleri etkin mi?
  // EN: Are vibrations enabled?
  bool _vibrationsEnabled = true;

  // TR: Titreşimleri ayarla
  // EN: Set vibrations enabled
  void setVibrationsEnabled(bool enabled) {
    _vibrationsEnabled = enabled;
  }

  // TR: Titreşim ver
  // EN: Give vibration
  Future<void> vibrate(HapticType type) async {
    if (!_vibrationsEnabled) return;

    switch (type) {
      case HapticType.light:
        await HapticUtils.lightImpact();
        break;
      case HapticType.medium:
        await HapticUtils.mediumImpact();
        break;
      case HapticType.heavy:
        await HapticUtils.heavyImpact();
        break;
      case HapticType.selection:
        await HapticUtils.selectionClick();
        break;
      case HapticType.success:
        await HapticUtils.successVibration();
        break;
      case HapticType.warning:
        await HapticUtils.warningVibration();
        break;
      case HapticType.tesbih:
        await HapticUtils.tesbihPattern();
        break;
      case HapticType.prayerTime:
        await HapticUtils.prayerTimePattern();
        break;
    }
  }

  // TR: Titreşimleri kontrol et
  // EN: Check vibrations
  bool get vibrationsEnabled => _vibrationsEnabled;
}
