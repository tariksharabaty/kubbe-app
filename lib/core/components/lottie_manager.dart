// TR: KUBBE Lottie Manager - Asset yönetimi
// EN: KUBBE Lottie Manager - Asset management
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Lottie animasyonlarını ve assetleri yöneten yardımcı sınıf
// EN: Helper class that manages Lottie animations and assets

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

/// TR: KUBBE Lottie Manager Sınıfı
/// EN: KUBBE Lottie Manager Class
/// TR: Lottie animasyonlarının yollarını ve fallback mantığını yönetir
/// EN: Manages Lottie animation paths and fallback logic
class LottieManager {
  // TR: Splash screen loading animasyonu
  // EN: Splash screen loading animation
  static const String splashLoading = 'assets/animations/splash_loading.json';

  // TR: Onboarding welcome animasyonu
  // EN: Onboarding welcome animation
  static const String onboardingWelcome =
      'assets/animations/onboarding_welcome.json';

  // TR: Onboarding prayer animasyonu
  // EN: Onboarding prayer animation
  static const String onboardingPrayer =
      'assets/animations/onboarding_prayer.json';

  // TR: Logo yolları
  // EN: Logo paths
  static const String icKubbeLogo = 'assets/icons/ic_kubbe_logo.png';
  static const String icKumoLogo = 'assets/icons/ic_kumo_logo.png';

  // TR: Placeholder Lottie yolu (yedek animasyon)
  // EN: Placeholder Lottie path (fallback animation)
  static const String placeholderAnimation =
      'assets/animations/placeholder.json';

  /// TR: Lottie dosyasının var olup olmadığını kontrol et
  /// EN: Check if Lottie file exists
  static Future<bool> assetExists(String assetPath) async {
    try {
      await rootBundle.loadString(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// TR: Lottie widget oluştur - Fallback ile
  /// EN: Create Lottie widget - with fallback
  /// TR: Eğer dosya yoksa placeholder göster, varsa Lottie animasyonu göster
  /// EN: Show placeholder if file doesn't exist, show Lottie animation if exists
  static Widget buildLottie({
    required String assetPath,
    double? width,
    double? height,
    BoxFit? fit,
    bool? repeat,
    bool? reverse,
    bool? animate,
    void Function(LottieComposition)? onLoaded,
    LottieDelegates? delegates,
  }) {
    return FutureBuilder<bool>(
      future: assetExists(assetPath),
      builder: (context, snapshot) {
        // TR: Yüklenirken veya dosya yoksa placeholder göster
        // EN: Show placeholder while loading or if file doesn't exist
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            snapshot.data == false) {
          return _buildPlaceholder(
            width: width,
            height: height,
          );
        }

        // TR: Dosya varsa Lottie animasyonu göster
        // EN: Show Lottie animation if file exists
        return Lottie.asset(
          assetPath,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          repeat: repeat ?? true,
          reverse: reverse ?? false,
          animate: animate ?? true,
          onLoaded: onLoaded,
          delegates: delegates,
          errorBuilder: (context, error, stackTrace) {
            // TR: Hata durumunda placeholder göster
            // EN: Show placeholder on error
            return _buildPlaceholder(
              width: width,
              height: height,
            );
          },
        );
      },
    );
  }

  /// TR: Placeholder widget oluştur
  /// EN: Create placeholder widget
  /// TR: Dosya olmadığında gösterilecek Sy-OS stili placeholder
  /// EN: Sy-OS style placeholder to show when file doesn't exist
  static Widget _buildPlaceholder({
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // TR: Sy-OS gradient arka plan
        // EN: Sy-OS gradient background
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4B0082), // TR: KubbeIndigo // EN: KubbeIndigo
            Color(0xFF6A1B9A), // TR: Açık Indigo // EN: Light Indigo
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // TR: Yuvarlak köşeler
        // EN: Rounded corners
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TR: Logo ikonu
            // EN: Logo icon
            Icon(
              Icons.animation,
              color: Colors.white.withValues(alpha: 0.8),
              size: 48,
            ),
            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 8),
            // TR: Yükleniyor metni
            // EN: Loading text
            Text(
              'Yükleniyor...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TR: Network Lottie URL'leri (geçici olarak kullanılan)
  // EN: Network Lottie URLs (used temporarily)
  static const String splashLoadingNetworkUrl =
      'https://assets10.lottiefiles.com/packages/lf20_at6p7rqi.json';

  /// TR: Network Lottie widget oluştur - Fallback ile
  /// EN: Create Network Lottie widget - with fallback
  /// TR: Eğer network yüklenemezse placeholder göster
  /// EN: Show placeholder if network fails to load
  static Widget buildNetworkLottie({
    required String url,
    double? width,
    double? height,
    BoxFit? fit,
    bool? repeat,
    bool? reverse,
    bool? animate,
    void Function(LottieComposition)? onLoaded,
  }) {
    return Lottie.network(
      url,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      repeat: repeat ?? true,
      reverse: reverse ?? false,
      animate: animate ?? true,
      onLoaded: onLoaded,
      errorBuilder: (context, error, stackTrace) {
        // TR: Hata durumunda placeholder göster
        // EN: Show placeholder on error
        return _buildPlaceholder(
          width: width,
          height: height,
        );
      },
    );
  }

  /// TR: Splash loading network Lottie widget'i
  /// EN: Splash loading network Lottie widget
  static Widget splashLoadingNetworkWidget({
    double? width,
    double? height,
  }) {
    return buildNetworkLottie(
      url: splashLoadingNetworkUrl,
      width: width ?? 200,
      height: height ?? 200,
      repeat: true,
      animate: true,
    );
  }

  /// TR: Onboarding welcome Lottie widget'i
  /// EN: Onboarding welcome Lottie widget
  static Widget onboardingWelcomeWidget({
    double? width,
    double? height,
  }) {
    return buildLottie(
      assetPath: onboardingWelcome,
      width: width ?? double.infinity,
      height: height ?? 300,
      repeat: true,
      animate: true,
    );
  }

  /// TR: Onboarding prayer Lottie widget'i
  /// EN: Onboarding prayer Lottie widget
  static Widget onboardingPrayerWidget({
    double? width,
    double? height,
  }) {
    return buildLottie(
      assetPath: onboardingPrayer,
      width: width ?? double.infinity,
      height: height ?? 300,
      repeat: true,
      animate: true,
    );
  }

  /// TR: Logo asset oluştur - Fallback ile
  /// EN: Create logo asset - with fallback
  static Widget buildLogo({
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Image.asset(
      icKubbeLogo,
      width: width ?? 36,
      height: height ?? 36,
      fit: fit ?? BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // TR: Logo yoksa placeholder göster
        // EN: Show placeholder if logo doesn't exist
        return _buildLogoPlaceholder(
          width: width ?? 36,
          height: height ?? 36,
        );
      },
    );
  }

  /// TR: Logo placeholder widget oluştur
  /// EN: Create logo placeholder widget
  static Widget _buildLogoPlaceholder({
    required double width,
    required double height,
  }) {
    return Icon(
      Icons.mosque,
      color: const Color(0xFF4B0082),
      size: width,
    );
  }

  /// TR: Tüm asset yollarını listele (debug için)
  /// EN: List all asset paths (for debug)
  static Map<String, String> getAllAssetPaths() {
    return {
      'splashLoading': splashLoading,
      'onboardingWelcome': onboardingWelcome,
      'onboardingPrayer': onboardingPrayer,
      'icKubbeLogo': icKubbeLogo,
      'icKumoLogo': icKumoLogo,
    };
  }
}
