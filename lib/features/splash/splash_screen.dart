// TR: KUBBE V4 Splash Screen - V4 standartları
// EN: KUBBE V4 Splash Screen - V4 standards
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Merkeze 'ic_kubbe_logo'yu (120dp) yerleştir. Logo için hafif bir 'Fade-In' ve 'Scale' animasyonu kur.
// EN: Place 'ic_kubbe_logo' (120dp) in the center. Create light 'Fade-In' and 'Scale' animation for logo.
// TR: Arka plan 'KubbeIndigo' (#4B0082) olsun. 2 saniye sonra Onboarding'e yönlendir.
// EN: Background should be 'KubbeIndigo' (#4B0082). Redirect to Onboarding after 2 seconds.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../core/theme/app_theme.dart';
import '../../core/storage/preferences_manager.dart';
import '../onboarding/onboarding_screen.dart';
import '../navigation/ana_navigasyon.dart';

/// TR: KUBBE V4 Splash Screen Sınıfı
/// EN: KUBBE V4 Splash Screen Class
/// TR: 120dp logo, scale animasyonu ve glow effect
/// EN: 120dp logo, scale animation and glow effect
/// TR: Lottie animasyonu ve otomatik yönlendirme
/// EN: Lottie animation and automatic redirect
/// TR: V4 estetiği ve Sy-OS design language
/// EN: V4 aesthetics and Sy-OS design language
class SplashScreen extends ConsumerStatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

// TR: Splash Screen State
// EN: Splash Screen State
class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  // TR: Animation controller'lar
  // EN: Animation controllers
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late AnimationController _fadeController;

  // TR: Animation'lar
  // EN: Animations
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // TR: Gösterim durumu
  // EN: Display state
  bool _showSignature = false;

  @override
  void initState() {
    super.initState();

    // TR: Animation controller'ları başlat
    // EN: Initialize animation controllers
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // TR: Animation'ları ayarla - 120dp logo için güncellenmiş
    // EN: Set up animations - Updated for 120dp logo
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // TR: Animation'ları başlat
    // EN: Start animations
    _startAnimations();

    // TR: Otomatik yönlendirme
    // EN: Automatic redirect
    _autoNavigate();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // TR: Animation'ları başlat - Güncellenmiş sıra
  // EN: Start animations - Updated sequence
  void _startAnimations() async {
    // TR: Fade-in ve Scale animasyonu birlikte
    // EN: Fade-in and Scale animation together
    await Future.wait([_scaleController.forward(), _fadeController.forward()]);

    // TR: Signature gösterimi
    // EN: Show signature
    setState(() {
      _showSignature = true;
    });
  }

  // TR: Otomatik yönlendirme
  // EN: Automatic redirect
  void _autoNavigate() async {
    // TR: 2 saniye bekle
    // EN: Wait 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // TR: Onboarding durumunu kontrol et
    // EN: Check onboarding status
    final preferences = ref.read(preferencesStateProvider);
    final hasSeenOnboarding = preferences.hasSeenOnboarding;

    // TR: Yönlendirme
    // EN: Navigate
    if (mounted) {
      if (hasSeenOnboarding) {
        // TR: Ana sayfaya git
        // EN: Navigate to home
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AnaNavigasyon(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      } else {
        // TR: Onboarding'e git
        // EN: Navigate to onboarding
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const OnboardingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TR: Arka plan
      // EN: Background
      body: Container(
        decoration: BoxDecoration(
          // TR: Gradient arka plan
          // EN: Gradient background
          gradient: LinearGradient(
            colors: [
              KubbeTheme.kubbeIndigo,
              KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
              KubbeTheme.kubbeIndigo.withValues(alpha: 0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // TR: İçerik
        // EN: Content
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TR: Boşluk
              // EN: Spacer
              const Expanded(flex: 2, child: SizedBox()),

              // TR: Logo alanı
              // EN: Logo area
              _buildLogoArea(),

              // TR: Boşluk
              // EN: Spacer
              const Expanded(flex: 1, child: SizedBox()),

              // TR: İmza alanı
              // EN: Signature area
              if (_showSignature) _buildSignatureArea(),

              // TR: Alt boşluk
              // EN: Bottom padding
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // TR: Logo alanı oluştur - 120dp logo ile güncellenmiş
  // EN: Build logo area - Updated with 120dp logo
  Widget _buildLogoArea() {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _fadeAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          // TR: Logo container
          // EN: Logo container
          child: Opacity(
            opacity: _fadeAnimation.value,
            // TR: Logo içeriği
            // EN: Logo content
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                // TR: Yuvarlak
                // EN: Circle
                shape: BoxShape.circle,
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.9),
                    Colors.white.withValues(alpha: 0.7),
                    Colors.white.withValues(alpha: 0.5),
                  ],
                ),
                // TR: Hafif gölge
                // EN: Light shadow
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              // TR: Logo içeriği
              // EN: Logo content
              child: const Center(
                // TR: KUBBE logo'su
                // EN: KUBBE logo
                child: Icon(
                  Icons
                      .mosque, // TR: ic_kubbe_logo yerine geçici ikon // EN: Temporary icon instead of ic_kubbe_logo
                  color: KubbeTheme.kubbeIndigo,
                  size: 80,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // TR: İmza alanı oluştur
  // EN: Build signature area
  Widget _buildSignatureArea() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          // TR: İmza container
          // EN: Signature container
          child: Column(
            children: [
              // TR: KUBBE metni
              // EN: KUBBE text
              Text(
                'KUBBE',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 4,
                ),
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 8),

              // TR: Sygrad imzası
              // EN: Sygrad signature
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TR: Lottie animasyonu
                  // EN: Lottie animation
                  SizedBox(
                    width: 20,
                    height: 20,
                    // TR: Lottie signature animasyonu
                    // EN: Lottie signature animation
                    child: Lottie.asset(
                      'assets/animations/signature.json',
                      controller: _fadeController,
                      onLoaded: (composition) {
                        // TR: Animation'u tekrar başlat
                        // EN: Restart animation
                        _fadeController.repeat();
                      },
                    ),
                  ),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(width: 8),

                  // TR: Sygrad metni
                  // EN: Sygrad text
                  Text(
                    'Sygrad',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),

              // TR: Versiyon bilgisi
              // EN: Version info
              const SizedBox(height: 8),
              Text(
                'V4.0.0',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// TR: Splash Screen Helper - V4 yeniliği
/// EN: Splash Screen Helper - V4 innovation
/// TR: SplashScreen için yardımcı fonksiyonlar
/// EN: Helper functions for SplashScreen
class SplashScreenHelper {
  // TR: Splash screen göster
  // EN: Show splash screen
  static void showSplashScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  // TR: Onboarding durumunu kontrol et
  // EN: Check onboarding status
  static Future<bool> checkOnboardingStatus(WidgetRef ref) async {
    final preferences = ref.read(preferencesStateProvider);
    return preferences.hasSeenOnboarding;
  }

  // TR: Onboarding'i tamamla
  // EN: Complete onboarding
  static Future<void> completeOnboarding(WidgetRef ref) async {
    final prefsManager = PreferencesManager();
    await prefsManager.setOnboardingSeen();
  }

  // TR: Ana sayfaya yönlendir
  // EN: Navigate to home
  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AnaNavigasyon(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  // TR: Onboarding'e yönlendir
  // EN: Navigate to onboarding
  static void navigateToOnboarding(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}

/// TR: Splash Screen Provider - V4 yeniliği
/// EN: Splash Screen Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
final splashScreenProvider = Provider<SplashScreenHelper>((ref) {
  return SplashScreenHelper();
});

/// TR: Splash Animation Controller Provider - V4 yeniliği
/// EN: Splash Animation Controller Provider - V4 innovation
final splashAnimationProvider =
    Provider.family<AnimationController, TickerProvider>((ref, ticker) {
  return AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: ticker,
  );
});

/// TR: Splash Scale Animation Provider - V4 yeniliği
/// EN: Splash Scale Animation Provider - V4 innovation
final splashScaleAnimationProvider =
    Provider.family<Animation<double>, AnimationController>((ref, controller) {
  return Tween<double>(
    begin: 0.0,
    end: 1.2,
  ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));
});

/// TR: Splash Glow Animation Provider - V4 yeniliği
/// EN: Splash Glow Animation Provider - V4 innovation
final splashGlowAnimationProvider =
    Provider.family<Animation<double>, AnimationController>((ref, controller) {
  return Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
});

/// TR: Splash Fade Animation Provider - V4 yeniliği
/// EN: Splash Fade Animation Provider - V4 innovation
final splashFadeAnimationProvider =
    Provider.family<Animation<double>, AnimationController>((ref, controller) {
  return Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
});
