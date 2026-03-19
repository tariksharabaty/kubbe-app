import 'package:flutter/services.dart';

// TR: KUBBE V4 Haptic Helper - Elite Titreşim Desteği
// EN: KUBBE V4 Haptic Helper - Elite Vibration Support
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code

/// TR: KUBBE V4 Haptic Helper Sınıfı
/// EN: KUBBE V4 Haptic Helper Class
/// TR: Uygulama genelinde 'tok' ve 'heavy' klik hissi sağlar
/// EN: Provides 'tok' and 'heavy' click feel throughout the application
class HapticHelper {
  // TR: Tok klik hissi - Hafif (Zikirmatik artışları için ideal)
  // EN: Tok click feel - Light (Ideal for zikirmatik increments)
  static Future<void> tokClick() async {
    // TR: Samsung A55 ve benzeri cihazlarda net hissedilen hafif vuruş
    // EN: Light impact felt clearly on Samsung A55 and similar devices
    await HapticFeedback.lightImpact();
  }

  // TR: Güçlü klik hissi - Orta (Sıfırlama veya önemli işlemler için)
  // EN: Heavy click feel - Medium (For reset or important actions)
  static Future<void> heavyClick() async {
    // TR: Daha belirgin ve güçlü vuruş
    // EN: More distinct and strong impact
    await HapticFeedback.mediumImpact();
  }
}
