import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TR: KUBBE V4 Geliştirici Araçları Sınıfı
/// EN: KUBBE V4 Developer Tools Class
/// TR: Ekran görüntüsü modu vb. geliştirme araçlarını yönetir
/// EN: Manages development tools like screenshot mode, etc.
class DevTools {
  /// TR: Ekran görüntüsü modu aktif mi?
  /// EN: Is screenshot mode active?
  static final screenshotModeProvider = StateProvider<bool>((ref) => false);

  /// TR: Ekran görüntüsü modunu ayarla
  /// EN: Set screenshot mode
  static void setScreenshotMode(WidgetRef ref, bool value) {
    ref.read(screenshotModeProvider.notifier).state = value;
  }

  /// TR: Sabit tarih: 10 Mart 2026
  /// EN: Fixed date: March 10, 2026
  static DateTime get fixedDateTime => DateTime(2026, 3, 10, 3, 35, 25);

  /// TR: Dinamik saat/tarih sağlayıcısı
  /// EN: Dynamic time/date provider
  /// TR: Ekran görüntüsü modu açıksa sabit tarih döner, kapalıysa şu anki zamanı döner
  /// EN: Returns fixed date if screenshot mode is ON, otherwise returns current time
  static final currentTimeProvider = Provider<DateTime>((ref) {
    final isScreenshotMode = ref.watch(screenshotModeProvider);
    if (isScreenshotMode) {
      return fixedDateTime;
    }
    return DateTime.now();
  });
}
