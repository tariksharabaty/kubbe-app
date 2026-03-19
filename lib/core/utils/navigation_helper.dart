// TR: KUBBE V4 Navigation Helper - V4 yeniliği
// EN: KUBBE V4 Navigation Helper - V4 innovation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Tüm navigasyon geçişlerine yumuşak bir Fade-In animasyonu ekle
// EN: Add smooth Fade-In animation to all navigation transitions
// TR: 'ic_kubbe_logo'nun tüm AppBar ve Modal'larda pürüzsüz göründüğünden emin ol
// EN: Ensure 'ic_kubbe_logo' appears smoothly in all AppBars and Modals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// TR: KUBBE V4 Navigation Helper Sınıfı
/// EN: KUBBE V4 Navigation Helper Class
/// TR: Yumuşak geçişler ve logo optimizasyonu
/// EN: Smooth transitions and logo optimization
/// TR: V4 estetiği ve Sy-OS design language
/// EN: V4 aesthetics and Sy-OS design language
class NavigationHelper {
  // TR: Fade-In geçişi
  // EN: Fade-In transition
  static Route<T> fadeTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 800),
      reverseTransitionDuration: const Duration(milliseconds: 600),
    );
  }

  // TR: Slide-In geçişi
  // EN: Slide-In transition
  static Route<T> slideTransition<T>(Widget page,
      {SlideDirection direction = SlideDirection.left}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;
        switch (direction) {
          case SlideDirection.left:
            begin = const Offset(1.0, 0.0);
            break;
          case SlideDirection.right:
            begin = const Offset(-1.0, 0.0);
            break;
          case SlideDirection.up:
            begin = const Offset(0.0, 1.0);
            break;
          case SlideDirection.down:
            begin = const Offset(0.0, -1.0);
            break;
        }

        return SlideTransition(
          position: animation.drive(
            Tween(begin: begin, end: Offset.zero).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 400),
    );
  }

  // TR: Scale geçişi
  // EN: Scale transition
  static Route<T> scaleTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation.drive(
            Tween(begin: 0.8, end: 1.0).chain(
              CurveTween(curve: Curves.easeOutBack),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // TR: BottomSheet geçişi
  // EN: BottomSheet transition
  static Route<T> bottomSheetTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(0.0, 1.0), end: Offset.zero).chain(
              CurveTween(curve: Curves.easeOutBack),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // TR: Haptic feedback ile geçiş
  // EN: Transition with haptic feedback
  static void navigateWithHaptic<T>(
    BuildContext context,
    Widget page, {
    NavigationType type = NavigationType.fade,
    SlideDirection direction = SlideDirection.left,
  }) {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    // TR: Geçiş türüne göre yönlendir
    // EN: Navigate based on transition type
    switch (type) {
      case NavigationType.fade:
        Navigator.of(context).push(fadeTransition<T>(page));
        break;
      case NavigationType.slide:
        Navigator.of(context)
            .push(slideTransition<T>(page, direction: direction));
        break;
      case NavigationType.scale:
        Navigator.of(context).push(scaleTransition<T>(page));
        break;
      case NavigationType.bottomSheet:
        Navigator.of(context).push(bottomSheetTransition<T>(page));
        break;
    }
  }

  // TR: Haptic feedback ile geçiş değiştirme
  // EN: Replace with haptic feedback
  static void replaceWithHaptic<T>(
    BuildContext context,
    Widget page, {
    NavigationType type = NavigationType.fade,
    SlideDirection direction = SlideDirection.left,
  }) {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    // TR: Geçiş türüne göre değiştir
    // EN: Replace based on transition type
    switch (type) {
      case NavigationType.fade:
        Navigator.of(context).pushReplacement(fadeTransition<T>(page));
        break;
      case NavigationType.slide:
        Navigator.of(context)
            .pushReplacement(slideTransition<T>(page, direction: direction));
        break;
      case NavigationType.scale:
        Navigator.of(context).pushReplacement(scaleTransition<T>(page));
        break;
      case NavigationType.bottomSheet:
        Navigator.of(context).pushReplacement(bottomSheetTransition<T>(page));
        break;
    }
  }

  // TR: Haptic feedback ile geri gitme
  // EN: Go back with haptic feedback
  static void popWithHaptic(BuildContext context) {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    // TR: Geri git
    // EN: Go back
    Navigator.of(context).pop();
  }

  // TR: Logo içeren AppBar
  // EN: AppBar with logo
  static PreferredSizeWidget buildLogoAppBar({
    String? title,
    List<Widget>? actions,
    Color? backgroundColor,
    bool centerTitle = true,
    double logoSize = 36.0,
    Color logoColor =
        const Color(0xFF4B0082), // TR: KubbeIndigo // EN: KubbeIndigo
  }) {
    return AppBar(
      // TR: Başlık
      // EN: Title
      title: title != null
          ? Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          : null,

      // TR: Arka plan
      // EN: Background
      backgroundColor: backgroundColor,

      // TR: Gölge kaldır
      // EN: Remove shadow
      elevation: 0,

      // TR: Ortalanmış başlık
      // EN: Centered title
      centerTitle: centerTitle,

      // TR: Logo ve başlık
      // EN: Logo and title
      titleSpacing: 0,

      // TR: Flexible space (logo için)
      // EN: Flexible space (for logo)
      flexibleSpace: title == null
          ? Center(
              // TR: Logo container
              // EN: Logo container
              child: Container(
                width: logoSize,
                height: logoSize,
                margin: const EdgeInsets.only(top: 40.0),
                decoration: BoxDecoration(
                  // TR: Yuvarlak
                  // EN: Circle
                  shape: BoxShape.circle,
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: LinearGradient(
                    colors: [
                      logoColor,
                      logoColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // TR: Hafif gölge
                  // EN: Light shadow
                  boxShadow: [
                    BoxShadow(
                      color: logoColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                // TR: Logo içeriği - Color.Unspecified ile renkler korunur
                // EN: Logo content - Colors preserved with Color.Unspecified
                child: Center(
                  // TR: Logo
                  // EN: Logo
                  child: Icon(
                    Icons
                        .smart_toy_outlined, // TR: ic_kumo_logo yerine geçici ikon // EN: Temporary icon instead of ic_kumo_logo
                    color: Colors.white,
                    size: logoSize * 0.7,
                  ),
                ),
              ),
            )
          : null,

      // TR: Eylemler
      // EN: Actions
      actions: actions,
    );
  }

  // TR: Modal logo
  // EN: Modal logo
  static Widget buildModalLogo({
    double size = 80.0,
    Color logoColor =
        const Color(0xFF4B0082), // TR: KubbeIndigo // EN: KubbeIndigo
    bool showGlow = true,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // TR: Yuvarlak
        // EN: Circle
        shape: BoxShape.circle,
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: [
            logoColor,
            logoColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // TR: Gölge
        // EN: Shadow
        boxShadow: showGlow
            ? [
                // TR: İç parlama
                // EN: Inner glow
                BoxShadow(
                  color: logoColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                  spreadRadius: 2,
                ),
                // TR: Dış parlama
                // EN: Outer glow
                BoxShadow(
                  color: logoColor.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: logoColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
      ),
      // TR: Logo içeriği
      // EN: Logo content
      child: Center(
        // TR: Logo
        // EN: Logo
        child: Icon(
          Icons
              .smart_toy_outlined, // TR: ic_kumo_logo yerine geçici ikon // EN: Temporary icon instead of ic_kumo_logo
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }

  // TR: AppBar için logo
  // EN: Logo for AppBar
  static Widget buildAppBarLogo({
    double size = 36.0,
    Color logoColor =
        const Color(0xFF4B0082), // TR: KubbeIndigo // EN: KubbeIndigo
    bool showGlow = true,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // TR: Yuvarlak
        // EN: Circle
        shape: BoxShape.circle,
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: [
            logoColor,
            logoColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // TR: Gölge
        // EN: Shadow
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: logoColor.withValues(alpha: 0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: logoColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
      ),
      // TR: Logo içeriği
      // EN: Logo content
      child: Center(
        // TR: Logo
        // EN: Logo
        child: Icon(
          Icons
              .smart_toy_outlined, // TR: ic_kumo_logo yerine geçici ikon // EN: Temporary icon instead of ic_kumo_logo
          color: Colors.white,
          size: size * 0.7,
        ),
      ),
    );
  }

  // TR: FAB için logo
  // EN: Logo for FAB
  static Widget buildFabLogo({
    double size = 64.0,
    Color logoColor =
        const Color(0xFF4B0082), // TR: KubbeIndigo // EN: KubbeIndigo
    bool showGlow = true,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // TR: Yuvarlak
        // EN: Circle
        shape: BoxShape.circle,
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: RadialGradient(
          colors: [
            logoColor,
            logoColor.withValues(alpha: 0.8),
          ],
        ),
        // TR: Gölge
        // EN: Shadow
        boxShadow: showGlow
            ? [
                // TR: İç parlama
                // EN: Inner glow
                BoxShadow(
                  color: logoColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                  spreadRadius: 2,
                ),
                // TR: Dış parlama
                // EN: Outer glow
                BoxShadow(
                  color: logoColor.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: logoColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
      ),
      // TR: Logo içeriği
      // EN: Logo content
      child: Center(
        // TR: Logo
        // EN: Logo
        child: Icon(
          Icons
              .smart_toy_outlined, // TR: ic_kumo_logo yerine geçici ikon // EN: Temporary icon instead of ic_kumo_logo
          color: Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}

// TR: Geçiş yönü enum'u
// EN: Slide direction enum
enum SlideDirection {
  // TR: Sol
  // EN: Left
  left,

  // TR: Sağ
  // EN: Right
  right,

  // TR: Yukarı
  // EN: Up
  up,

  // TR: Aşağı
  // EN: Down
  down,
}

// TR: Navigasyon türü enum'u
// EN: Navigation type enum
enum NavigationType {
  // TR: Fade
  // EN: Fade
  fade,

  // TR: Slide
  // EN: Slide
  slide,

  // TR: Scale
  // EN: Scale
  scale,

  // TR: BottomSheet
  // EN: BottomSheet
  bottomSheet,
}

// TR: Navigation Helper Provider - V4 yeniliği
// EN: Navigation Helper Provider - V4 innovation
// TR: Riverpod ile entegrasyon
// EN: Integration with Riverpod
final navigationHelperProvider = Provider<NavigationHelper>((ref) {
  return NavigationHelper();
});
