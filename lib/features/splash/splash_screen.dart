import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// TR: KUBBE V4 Elite Splash Screen - V4 yenilikleri
/// EN: KUBBE V4 Elite Splash Screen - V4 innovations
/// TR: Devasa logonun estetik olarak taşması (overflow), gradyan arka plan ve "Breathing" animasyonu.
/// EN: Deformed (overflowing) logo, gradient background, and "Breathing" animation.
class SplashScreen extends StatefulWidget {
  /// TR: Constructor
  /// EN: Constructor
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// TR: Breathing animasyon controller
  /// EN: Breathing animation controller
  late AnimationController _breathingController;
  late Animation<double> _breatheAnimation;

  @override
  void initState() {
    super.initState();

    // TR: 2 saniyelik breathing animasyonu
    // EN: 2 seconds breathing animation
    _breathingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _breatheAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TR: Sistem tema durumu (Aydınlık/Karanlık)
    // EN: System theme status (Light/Dark)
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // TR: Arka plan ve metin renklerini tema bazlı belirle (User requirement #1 & #4)
    // EN: Set background and text colors based on theme (User requirement #1 & #4)
    final Color backgroundColor = isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
    final Color contentColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // TR: Devasa Arka Plan Logosu (Cropped/Overflown) (User requirement #2)
          // EN: Giant Background Logo (Cropped/Overflown) (User requirement #2)
          OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: Transform.scale(
              scale: 6.0, // TR: Kenarlardan taşması için devasa ölçek // EN: Massive scale for overflown effect
              child: Opacity(
                opacity: isDark ? 0.08 : 0.05, // TR: Arka planla bütünleşmesi için düşük opaklık // EN: Low opacity to blend with background
                child: Image.asset(
                  'assets/icons/ic_kubbe_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // TR: Merkez İçerik (Daha küçük ve odaklı logo)
          // EN: Central Content (Smaller and focused logo)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/ic_kubbe_logo.png',
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),
            ],
          ),

          // TR: Alt Bölüm (Yazı ve Animasyon)
          // EN: Bottom Section (Text and Animation)
          Positioned(
            bottom: 60,
            child: Column(
              children: [
                // TR: KUBBE Başlığı (User requirement #4)
                // EN: KUBBE Title (User requirement #4)
                Text(
                  'KUBBE',
                  style: GoogleFonts.outfit(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: contentColor,
                    letterSpacing: 6.0,
                  ),
                ),
                const SizedBox(height: 40.0),

                // TR: Breathing Circle (User requirement #4)
                // EN: Breathing Circle (User requirement #4)
                ScaleTransition(
                  scale: _breatheAnimation,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: contentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: contentColor.withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
