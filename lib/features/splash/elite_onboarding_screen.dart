// TR: KUBBE V4 Elite Onboarding Screen - Pure Flutter Animation
// EN: KUBBE V4 Elite Onboarding Screen - Pure Flutter Animation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: CustomPainter ve AnimationController ile Samsung One UI tarzı geçişler
// EN: Samsung One UI style transitions with CustomPainter and AnimationController
// TR: Curves.easeInOutCubic ile akıcı sayfa geçişleri
// EN: Smooth page transitions with Curves.easeInOutCubic

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../navigation/ana_navigasyon.dart';

/// TR: Onboarding veri modeli
/// EN: Onboarding data model
class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
}

/// TR: KUBBE V4 Elite Onboarding Screen Sınıfı
/// EN: KUBBE V4 Elite Onboarding Screen Class
/// TR: Samsung One UI tarzı indicator'lar ve akıcı geçişler
/// EN: Samsung One UI style indicators and smooth transitions
/// TR: Curves.easeInOutCubic ile asil geçiş animasyonları
/// EN: Noble transition animations with Curves.easeInOutCubic
class EliteOnboardingScreen extends StatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const EliteOnboardingScreen({super.key});

  @override
  State<EliteOnboardingScreen> createState() => _EliteOnboardingScreenState();
}

class _EliteOnboardingScreenState extends State<EliteOnboardingScreen>
    with TickerProviderStateMixin {
  // TR: PageView controller
  // EN: PageView controller
  late PageController _pageController;

  // TR: Animasyon controller'ları
  // EN: Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;

  // TR: Animasyonlar
  // EN: Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _indicatorController;

  // TR: Mevcut sayfa indeksi
  // EN: Current page index
  int _currentPage = 0;

  // TR: Onboarding verileri
  // EN: Onboarding data
  final List<OnboardingData> _onboardingData = const [
    OnboardingData(
      title: 'Elite Tasarım',
      description: 'Sy-OS standartlarında modern ve şık arayüz',
      icon: Icons.design_services,
      iconColor: Color(0xFF4B0082),
    ),
    OnboardingData(
      title: 'Akıllı Asistan Kumo',
      description: 'Yapay zeka destekli dini soru-cevap asistanı',
      icon: Icons.smart_toy_outlined,
      iconColor: Color(0xFF9C27B0),
    ),
    OnboardingData(
      title: 'Zaman Kubbesi',
      description: 'Vakit takibi ve namaz hatırlatıcıları',
      icon: Icons.schedule,
      iconColor: Color(0xFF4CAF50),
    ),
  ];

  @override
  void initState() {
    super.initState();

    // TR: PageView controller'ı
    // EN: PageView controller
    _pageController = PageController();

    // TR: Indicator animasyon controller'ı - Samsung One UI tarzı
    // EN: Indicator animation controller - Samsung One UI style
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // TR: Sayfa geçiş fade animasyon controller'ı
    // EN: Page transition fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // TR: Sayfa geçiş kayma animasyon controller'ı
    // EN: Page transition slide animation controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // TR: Fade animasyonu - Curves.easeInOutCubic
    // EN: Fade animation - Curves.easeInOutCubic
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    ));

    // TR: Slide animasyonu - Curves.easeInOutCubic
    // EN: Slide animation - Curves.easeInOutCubic
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOutCubic,
    ));

    // TR: İlk animasyonu başlat
    // EN: Start first animation
    _startInitialAnimation();
  }

  // TR: Başlangıç animasyonunu başlat
  // EN: Start initial animation
  void _startInitialAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    _slideController.forward();
  }

  // TR: Sayfa değiştir - akıcı geçiş
  // EN: Change page - smooth transition
  void _changePage(int direction) {
    if (direction > 0 && _currentPage < _onboardingData.length - 1) {
      // TR: Sonraki sayfa
      // EN: Next page
      _currentPage++;
    } else if (direction < 0 && _currentPage > 0) {
      // TR: Önceki sayfa
      // EN: Previous page
      _currentPage--;
    } else {
      return;
    }

    // TR: Animasyonları sıfırla ve yeniden başlat
    // EN: Reset and restart animations
    _fadeController.reset();
    _slideController.reset();

    _fadeController.forward();
    _slideController.forward();

    // TR: Indicator animasyonunu güncelle
    // EN: Update indicator animation
    _indicatorController.reset();
    _indicatorController.forward();

    // TR: PageView'i güncelle
    // EN: Update PageView
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  // TR: Onboarding'i bitir ve ana ekrana git
  // EN: Finish onboarding and navigate to main screen
  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AnaNavigasyon(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    // TR: Controller'ları temizle
    // EN: Dispose controllers
    _pageController.dispose();
    _indicatorController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TR: KubbeIndigo arka plan
      // EN: KubbeIndigo background
      backgroundColor: KubbeTheme.kubbeIndigo,
      body: SafeArea(
        child: Column(
          children: [
            // TR: Üst kapatma butonu
            // EN: Top close button
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: _finishOnboarding,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // TR: Ana içerik alanı
            // EN: Main content area
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  // TR: Indicator animasyonunu başlat
                  // EN: Start indicator animation
                  _indicatorController.forward();
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // TR: İkon
                                // EN: Icon
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color:
                                        data.iconColor.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    data.icon,
                                    color: data.iconColor,
                                    size: 60,
                                  ),
                                ),

                                const SizedBox(height: 40),

                                // TR: Başlık
                                // EN: Title
                                Text(
                                  data.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: KubbeTheme.outfitFontFamily,
                                    height: 1.3,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // TR: Açıklama
                                // EN: Description
                                Text(
                                  data.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontFamily: KubbeTheme.interFontFamily,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // TR: Alt kısım - Samsung One UI tarzı indicator'lar
            // EN: Bottom section - Samsung One UI style indicators
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  // TR: Samsung One UI tarzı indicator'lar
                  // EN: Samsung One UI style indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_onboardingData.length, (index) {
                      final isActive = index == _currentPage;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: isActive ? 24.0 : 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          // TR: Aktif olanın rengi ve şekli
                          // EN: Active one's color and shape
                          color: isActive
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),

                  // TR: Geçiş butonları
                  // EN: Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // TR: Önceki butonu
                      // EN: Previous button
                      if (_currentPage > 0)
                        GestureDetector(
                          onTap: () => _changePage(-1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                // TR: Text
                                // EN: Text
                                Text(
                                  'Önceki',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),

                      // TR: Sonraki/Bitir butonu
                      // EN: Next/Finish button
                      GestureDetector(
                        onTap: () {
                          if (_currentPage < _onboardingData.length - 1) {
                            _changePage(1);
                          } else {
                            _finishOnboarding();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage < _onboardingData.length - 1
                                    ? 'Sonraki'
                                    : 'Hadi Başlayalım',
                                style: const TextStyle(
                                  color: KubbeTheme.kubbeIndigo,
                                  fontFamily: KubbeTheme.interFontFamily,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_currentPage <
                                  _onboardingData.length - 1) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: KubbeTheme.kubbeIndigo,
                                  size: 20,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
