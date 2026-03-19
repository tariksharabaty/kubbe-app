// TR: KUBBE V4 Page Transitions Builder - V4 yeniliği
// EN: KUBBE V4 Page Transitions Builder - V4 innovation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Sayfa geçişlerine 'PageTransitionsBuilder' ile yumuşak geçişler ekle.
// EN: Add smooth transitions to page transitions with 'PageTransitionsBuilder'.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// TR: KUBBE V4 Page Transitions Builder Sınıfı
/// EN: KUBBE V4 Page Transitions Builder Class
/// TR: Sayfa geçişleri için yumuşak animasyonlar ve geçişler
/// EN: Smooth animations and transitions for page transitions
/// TR: V4 estetiği ve Sy-OS design language
/// EN: V4 aesthetics and Sy-OS design language
class V4PageTransitions {
  // TR: Fade geçişi
  // EN: Fade transition
  static PageRouteBuilder fadeTransition(Widget page) {
    return PageRouteBuilder(
      // TR: Sayfa builder
      // EN: Page builder
      pageBuilder: (context, animation, secondaryAnimation) => page,
      // TR: Geçiş builder
      // EN: Transition builder
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // TR: Fade animasyonu
        // EN: Fade animation
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      // TR: Geçiş süresi
      // EN: Transition duration
      transitionDuration: const Duration(milliseconds: 300),
      // TR: Ters geçiş süresi
      // EN: Reverse transition duration
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // TR: Slide geçişi (sağdan)
  // EN: Slide transition (from right)
  static PageRouteBuilder slideTransition(Widget page) {
    return PageRouteBuilder(
      // TR: Sayfa builder
      // EN: Page builder
      pageBuilder: (context, animation, secondaryAnimation) => page,
      // TR: Geçiş builder
      // EN: Transition builder
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // TR: Slide animasyonu
        // EN: Slide animation
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      // TR: Geçiş süresi
      // EN: Transition duration
      transitionDuration: const Duration(milliseconds: 400),
      // TR: Ters geçiş süresi
      // EN: Reverse transition duration
      reverseTransitionDuration: const Duration(milliseconds: 400),
    );
  }

  // TR: Scale geçişi
  // EN: Scale transition
  static PageRouteBuilder scaleTransition(Widget page) {
    return PageRouteBuilder(
      // TR: Sayfa builder
      // EN: Page builder
      pageBuilder: (context, animation, secondaryAnimation) => page,
      // TR: Geçiş builder
      // EN: Transition builder
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // TR: Scale animasyonu
        // EN: Scale animation
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      // TR: Geçiş süresi
      // EN: Transition duration
      transitionDuration: const Duration(milliseconds: 300),
      // TR: Ters geçiş süresi
      // EN: Reverse transition duration
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // TR: Elite geçişi (özel V4 animasyonu)
  // EN: Elite transition (custom V4 animation)
  static PageRouteBuilder eliteTransition(Widget page) {
    return PageRouteBuilder(
      // TR: Sayfa builder
      // EN: Page builder
      pageBuilder: (context, animation, secondaryAnimation) => page,
      // TR: Geçiş builder
      // EN: Transition builder
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // TR: Karma animasyon (fade + scale)
        // EN: Mixed animation (fade + scale)
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      // TR: Geçiş süresi
      // EN: Transition duration
      transitionDuration: const Duration(milliseconds: 500),
      // TR: Ters geçiş süresi
      // EN: Reverse transition duration
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // TR: Rotasyon geçişi
  // EN: Rotation transition
  static PageRouteBuilder rotationTransition(Widget page) {
    return PageRouteBuilder(
      // TR: Sayfa builder
      // EN: Page builder
      pageBuilder: (context, animation, secondaryAnimation) => page,
      // TR: Geçiş builder
      // EN: Transition builder
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // TR: Rotasyon animasyonu
        // EN: Rotation animation
        return RotationTransition(
          turns: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      // TR: Geçiş süresi
      // EN: Transition duration
      transitionDuration: const Duration(milliseconds: 600),
      // TR: Ters geçiş süresi
      // EN: Reverse transition duration
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // TR: Kubbe geçişi (özel KUBBE animasyonu)
  // EN: Kubbe transition (custom KUBBE animation)
  static PageRouteBuilder kubbeTransition(Widget page) {
    return PageRouteBuilder(
      // TR: Sayfa builder
      // EN: Page builder
      pageBuilder: (context, animation, secondaryAnimation) => page,
      // TR: Geçiş builder
      // EN: Transition builder
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // TR: Özel KUBBE animasyonu
        // EN: Custom KUBBE animation
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            // TR: Animasyon değeri
            // EN: Animation value
            final value = animation.value;

            // TR: Fade ve scale kombinasyonu
            // EN: Fade and scale combination
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                // TR: KubbeContainer ile özel efekt
                // EN: Special effect with KubbeContainer
                child: Container(
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        KubbeTheme.kubbeIndigo.withValues(alpha: value * 0.1),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  // TR: Çocuk widget
                  // EN: Child widget
                  child: child,
                ),
              ),
            );
          },
          // TR: Çocuk widget
          // EN: Child widget
          child: child,
        );
      },
      // TR: Geçiş süresi
      // EN: Transition duration
      transitionDuration: const Duration(milliseconds: 700),
      // TR: Ters geçiş süresi
      // EN: Reverse transition duration
      reverseTransitionDuration: const Duration(milliseconds: 400),
    );
  }
}

/// TR: V4 Navigation Helper - V4 yeniliği
/// EN: V4 Navigation Helper - V4 innovation
/// TR: Sayfa geçişlerini kolaylaştıran yardımcı sınıf
/// EN: Helper class that facilitates page transitions
class V4NavigationHelper {
  // TR: Varsayılan geçiş tipi
  // EN: Default transition type
  static String _defaultTransition = 'elite';

  // TR: Varsayılan geçiş tipini ayarla
  // EN: Set default transition type
  static void setDefaultTransition(String transitionType) {
    _defaultTransition = transitionType;
  }

  // TR: Varsayılan geçiş tipini al
  // EN: Get default transition type
  static String getDefaultTransition() {
    return _defaultTransition;
  }

  // TR: Sayfa geçişi yap
  // EN: Navigate to page
  static void navigateToPage(BuildContext context, Widget page,
      {String? transitionType}) {
    final transition = transitionType ?? _defaultTransition;

    switch (transition) {
      case 'fade':
        Navigator.of(context).push(V4PageTransitions.fadeTransition(page));
        break;
      case 'slide':
        Navigator.of(context).push(V4PageTransitions.slideTransition(page));
        break;
      case 'scale':
        Navigator.of(context).push(V4PageTransitions.scaleTransition(page));
        break;
      case 'rotation':
        Navigator.of(context).push(V4PageTransitions.rotationTransition(page));
        break;
      case 'kubbe':
        Navigator.of(context).push(V4PageTransitions.kubbeTransition(page));
        break;
      case 'elite':
      default:
        Navigator.of(context).push(V4PageTransitions.eliteTransition(page));
        break;
    }
  }

  // TR: Sayfa geçişi yap (replace)
  // EN: Navigate to page (replace)
  static void navigateToPageReplace(BuildContext context, Widget page,
      {String? transitionType}) {
    final transition = transitionType ?? _defaultTransition;

    switch (transition) {
      case 'fade':
        Navigator.of(context)
            .pushReplacement(V4PageTransitions.fadeTransition(page));
        break;
      case 'slide':
        Navigator.of(context)
            .pushReplacement(V4PageTransitions.slideTransition(page));
        break;
      case 'scale':
        Navigator.of(context)
            .pushReplacement(V4PageTransitions.scaleTransition(page));
        break;
      case 'rotation':
        Navigator.of(context)
            .pushReplacement(V4PageTransitions.rotationTransition(page));
        break;
      case 'kubbe':
        Navigator.of(context)
            .pushReplacement(V4PageTransitions.kubbeTransition(page));
        break;
      case 'elite':
      default:
        Navigator.of(context)
            .pushReplacement(V4PageTransitions.eliteTransition(page));
        break;
    }
  }

  // TR: Geri git
  // EN: Go back
  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  // TR: Ana sayfaya git
  // EN: Go to home
  static void goToHome(BuildContext context, Widget homePage) {
    Navigator.of(context).pushAndRemoveUntil(
      V4PageTransitions.eliteTransition(homePage),
      (route) => false,
    );
  }

  // TR: Mevcut sayfayı kapat
  // EN: Close current page
  static void closePage(BuildContext context) {
    Navigator.of(context).pop();
  }

  // TR: Tüm sayfaları kapat ve yeni sayfa aç
  // EN: Close all pages and open new page
  static void closeAllAndOpen(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      V4PageTransitions.eliteTransition(page),
      (route) => false,
    );
  }
}

/// TR: V4 Transition Builder Widget - V4 yeniliği
/// EN: V4 Transition Builder Widget - V4 innovation
/// TR: Geçiş animasyonları için kolay kullanım widget'ı
/// EN: Easy to use widget for transition animations
class V4TransitionBuilder extends StatelessWidget {
  // TR: Child widget
  // EN: Child widget
  final Widget child;

  // TR: Geçiş tipi
  // EN: Transition type
  final String transitionType;

  // TR: Süre
  // EN: Duration
  final Duration? duration;

  // TR: Constructor
  // EN: Constructor
  const V4TransitionBuilder({
    super.key,
    required this.child,
    this.transitionType = 'elite',
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    // TR: Geçiş tipine göre animasyon seç
    // EN: Select animation based on transition type
    switch (transitionType) {
      case 'fade':
        return _buildFadeTransition();
      case 'slide':
        return _buildSlideTransition();
      case 'scale':
        return _buildScaleTransition();
      case 'rotation':
        return _buildRotationTransition();
      case 'kubbe':
        return _buildKubbeTransition();
      case 'elite':
      default:
        return _buildEliteTransition();
    }
  }

  // TR: Fade geçişi oluştur
  // EN: Build fade transition
  Widget _buildFadeTransition() {
    return TweenAnimationBuilder<double>(
      // TR: Tween
      // EN: Tween
      tween: Tween<double>(begin: 0.0, end: 1.0),
      // TR: Süre
      // EN: Duration
      duration: duration ?? const Duration(milliseconds: 300),
      // TR: Builder
      // EN: Builder
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      // TR: Child
      // EN: Child
      child: child,
    );
  }

  // TR: Slide geçişi oluştur
  // EN: Build slide transition
  Widget _buildSlideTransition() {
    return TweenAnimationBuilder<Offset>(
      // TR: Tween
      // EN: Tween
      tween: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero),
      // TR: Süre
      // EN: Duration
      duration: duration ?? const Duration(milliseconds: 400),
      // TR: Builder
      // EN: Builder
      builder: (context, value, child) {
        return SlideTransition(
          position: AlwaysStoppedAnimation(value),
          child: child,
        );
      },
      // TR: Child
      // EN: Child
      child: child,
    );
  }

  // TR: Scale geçişi oluştur
  // EN: Build scale transition
  Widget _buildScaleTransition() {
    return TweenAnimationBuilder<double>(
      // TR: Tween
      // EN: Tween
      tween: Tween<double>(begin: 0.8, end: 1.0),
      // TR: Süre
      // EN: Duration
      duration: duration ?? const Duration(milliseconds: 300),
      // TR: Builder
      // EN: Builder
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      // TR: Child
      // EN: Child
      child: child,
    );
  }

  // TR: Rotasyon geçişi oluştur
  // EN: Build rotation transition
  Widget _buildRotationTransition() {
    return TweenAnimationBuilder<double>(
      // TR: Tween
      // EN: Tween
      tween: Tween<double>(begin: 0.0, end: 1.0),
      // TR: Süre
      // EN: Duration
      duration: duration ?? const Duration(milliseconds: 600),
      // TR: Builder
      // EN: Builder
      builder: (context, value, child) {
        return RotationTransition(
          turns: AlwaysStoppedAnimation(value),
          child: child,
        );
      },
      // TR: Child
      // EN: Child
      child: child,
    );
  }

  // TR: Elite geçişi oluştur
  // EN: Build elite transition
  Widget _buildEliteTransition() {
    return TweenAnimationBuilder<double>(
      // TR: Tween
      // EN: Tween
      tween: Tween<double>(begin: 0.0, end: 1.0),
      // TR: Süre
      // EN: Duration
      duration: duration ?? const Duration(milliseconds: 500),
      // TR: Builder
      // EN: Builder
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      // TR: Child
      // EN: Child
      child: child,
    );
  }

  // TR: Kubbe geçişi oluştur
  // EN: Build kubbe transition
  Widget _buildKubbeTransition() {
    return TweenAnimationBuilder<double>(
      // TR: Tween
      // EN: Tween
      tween: Tween<double>(begin: 0.0, end: 1.0),
      // TR: Süre
      // EN: Duration
      duration: duration ?? const Duration(milliseconds: 700),
      // TR: Builder
      // EN: Builder
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            // TR: KubbeContainer ile özel efekt
            // EN: Special effect with KubbeContainer
            child: Container(
              // TR: Gradient arka plan
              // EN: Gradient background
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    KubbeTheme.kubbeIndigo.withValues(alpha: value * 0.1),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              // TR: Çocuk widget
              // EN: Child widget
              child: child,
            ),
          ),
        );
      },
      // TR: Child
      // EN: Child
      child: child,
    );
  }
}
