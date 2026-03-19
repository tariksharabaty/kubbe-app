// TR: KUBBE V4 Onboarding Screen - V4 standartları
// EN: KUBBE V4 Onboarding Screen - V4 standards
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: 3 Slaytlık akıcı bir yapı: [Elite Tasarım, Akıllı Asistan Kumo, Zaman Kubbesi].
// EN: 3-slide smooth structure: [Elite Design, Smart Assistant Kumo, Time Dome].
// TR: Tasarım: Üstte Lottie animasyonu, ortada 'Outfit Bold' başlık, altta 'Inter' açıklama metni.
// EN: Design: Lottie animation at top, 'Outfit Bold' title in middle, 'Inter' description text at bottom.
// TR: 32dp radius'lu "Hadi Başlayalım" butonu ekle.
// EN: Add 32dp radius "Let's Get Started" button.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../core/theme/app_theme.dart';
import '../../core/storage/preferences_manager.dart';
import '../navigation/ana_navigasyon.dart';

/// TR: KUBBE V4 Onboarding Screen Sınıfı
/// EN: KUBBE V4 Onboarding Screen Class
/// TR: 3 slaytlık modern akış ve Samsung One UI tarzı indicator
/// EN: 3-slide modern flow and Samsung One UI style indicators
/// TR: 32dp radius illüstrasyon alanları ve Outfit Bold başlıklar
/// EN: 32dp radius illustration areas and Outfit Bold headings
/// TR: V4 estetiği ve Sy-OS design language
/// EN: V4 aesthetics and Sy-OS design language
class OnboardingScreen extends ConsumerStatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

// TR: Onboarding Screen State
// EN: Onboarding Screen State
class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  // TR: Page controller
  // EN: Page controller
  final PageController _pageController = PageController();

  // TR: Mevcut sayfa
  // EN: Current page
  int _currentPage = 0;

  // TR: Animation controller
  // EN: Animation controller
  late AnimationController _animationController;

  // TR: Onboarding verileri - Güncellenmiş slaytlar
  // EN: Onboarding data - Updated slides
  final List<OnboardingData> _onboardingData = [
    // TR: Slayt 1 - Elite Tasarım
    // EN: Slide 1 - Elite Design
    const OnboardingData(
      title: 'Elite Tasarım',
      subtitle: 'Sy-OS Design\nModern Arayüz',
      description:
          '32dp radius, KubbeIndigo renk paleti ve şık animasyonlarla tasarlanmış modern İslami uygulama.',
      lottieAsset: 'assets/animations/elite_design.json',
      icon: Icons.design_services,
      color: KubbeTheme.kubbeIndigo,
    ),

    // TR: Slayt 2 - Akıllı Asistan Kumo
    // EN: Slide 2 - Smart Assistant Kumo
    const OnboardingData(
      title: 'Akıllı Asistan Kumo',
      subtitle: 'İslami Bilgi\nZeki Asistan',
      description:
          '50 soruluk dini arşiv ve anahtar kelime eşleştirme ile size özel cevaplar sunan yapay zeka asistanı.',
      lottieAsset: 'assets/animations/kumo_ai.json',
      icon: Icons.smart_toy,
      color: Color(0xFF4CAF50), // TR: Yeşil // EN: Green
    ),

    // TR: Slayt 3 - Zaman Kubbesi
    // EN: Slide 3 - Time Dome
    const OnboardingData(
      title: 'Zaman Kubbesi',
      subtitle: 'İbadet Merkezi\nZaman Takibi',
      description:
          'Zikirmatik, namaz takibi, kible pusulası ve zekat hesaplama ile tüm ibadetlerinizi tek bir yerden yönetin.',
      lottieAsset: 'assets/animations/time_dome.json',
      icon: Icons.schedule,
      color: Color(0xFFFF5722), // TR: Turuncu // EN: Orange
    ),
  ];

  @override
  void initState() {
    super.initState();

    // TR: Animation controller'ı başlat
    // EN: Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // TR: Page listener'ı ekle
    // EN: Add page listener
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // TR: Sonraki sayfaya git
  // EN: Go to next page
  void _nextPage() {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // TR: Onboarding'i tamamla
      // EN: Complete onboarding
      _completeOnboarding();
    }
  }

  // TR: Önceki sayfaya git
  // EN: Go to previous page
  void _previousPage() {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // TR: Sayfaya atla
  // EN: Jump to page
  void _goToPage(int page) {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // TR: Onboarding'i tamamla
  // EN: Complete onboarding
  Future<void> _completeOnboarding() async {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.heavyImpact();

    // TR: Context'i kaydet
    // EN: Save context
    final navigatorContext = context;

    // TR: Onboarding'i kaydet
    // EN: Save onboarding
    final prefsManager = PreferencesManager();
    await prefsManager.setOnboardingSeen();

    // TR: Ana sayfaya git
    // EN: Navigate to home
    if (navigatorContext.mounted) {
      Navigator.of(navigatorContext).pushReplacement(
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
  }

  // TR: Onboarding'i atla
  // EN: Skip onboarding
  void _skipOnboarding() {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.mediumImpact();

    // TR: Ana sayfaya git
    // EN: Navigate to home
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
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // TR: İçerik
        // EN: Content
        child: Column(
          children: [
            // TR: Üst boşluk ve atla butonu
            // EN: Top space and skip button
            _buildTopSection(),

            // TR: PageView
            // EN: PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingData[index]);
                },
              ),
            ),

            // TR: Alt bölüm - indicator'lar ve butonlar
            // EN: Bottom section - indicators and buttons
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  // TR: Üst bölüm oluştur
  // EN: Build top section
  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      // TR: Üst satır
      // EN: Top row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TR: Boşluk
          // EN: Spacer
          const SizedBox(width: 60),

          // TR: Atla butonu
          // EN: Skip button
          GestureDetector(
            onTap: _skipOnboarding,
            // TR: Buton
            // EN: Button
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                // TR: 16dp radius
                // EN: 16dp radius
                borderRadius: BorderRadius.circular(16.0),
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.transparent.withValues(alpha: 0.1),
                  ],
                ),
                // TR: Kenar
                // EN: Border
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              // TR: Buton metni
              // EN: Button text
              child: Text(
                'Atla',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TR: Onboarding sayfası oluştur
  // EN: Build onboarding page
  Widget _buildOnboardingPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      // TR: Sayfa içeriği
      // EN: Page content
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TR: Illüstrasyon alanı - 32dp radius
          // EN: Illustration area - 32dp radius
          _buildIllustrationArea(data),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 40),

          // TR: Başlık - Outfit Bold
          // EN: Title - Outfit Bold
          Text(
            data.title,
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: data.color,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          // TR: Alt başlık
          // EN: Subtitle
          Text(
            data.subtitle,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: data.color.withValues(alpha: 0.8),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 20),

          // TR: Açıklama
          // EN: Description
          Text(
            data.description,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // TR: Illüstrasyon alanı oluştur
  // EN: Build illustration area
  Widget _buildIllustrationArea(OnboardingData data) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        // TR: 32dp radius - Sy-OS standartı
        // EN: 32dp radius - Sy-OS standard
        borderRadius: BorderRadius.circular(32.0),
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: [
            data.color.withValues(alpha: 0.1),
            data.color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: data.color.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      // TR: Illüstrasyon içeriği
      // EN: Illustration content
      child: Center(
        // TR: Lottie animasyonu
        // EN: Lottie animation
        child: SizedBox(
          width: 200,
          height: 200,
          // TR: Lottie animasyonu
          // EN: Lottie animation
          child: Lottie.asset(
            data.lottieAsset,
            controller: _animationController,
            onLoaded: (composition) {
              // TR: Animation'u başlat
              // EN: Start animation
              _animationController
                ..duration = composition.duration
                ..repeat();
            },
          ),
        ),
      ),
    );
  }

  // TR: Alt bölüm oluştur
  // EN: Build bottom section
  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      // TR: Alt içerik
      // EN: Bottom content
      child: Column(
        children: [
          // TR: Samsung One UI tarzı indicator'lar
          // EN: Samsung One UI style indicators
          _buildIndicators(),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 30),

          // TR: Navigasyon butonları
          // EN: Navigation buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  // TR: Indicator'lar oluştur
  // EN: Build indicators
  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_onboardingData.length, (index) {
        return _buildIndicator(index);
      }),
    );
  }

  // TR: Indicator oluştur
  // EN: Build indicator
  Widget _buildIndicator(int index) {
    final isActive = index == _currentPage;

    return GestureDetector(
      onTap: () => _goToPage(index),
      // TR: Indicator
      // EN: Indicator
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: isActive ? 24.0 : 8.0,
        height: 8.0,
        decoration: BoxDecoration(
          // TR: Samsung One UI tarzı yuvarlak
          // EN: Samsung One UI style rounded
          borderRadius: BorderRadius.circular(4.0),
          // TR: Gradient arka plan
          // EN: Gradient background
          gradient: LinearGradient(
            colors: isActive
                ? [
                    _onboardingData[index].color,
                    _onboardingData[index].color.withValues(alpha: 0.8),
                  ]
                : [
                    Colors.grey.withValues(alpha: 0.3),
                    Colors.grey.withValues(alpha: 0.1),
                  ],
          ),
          // TR: Gölge
          // EN: Shadow
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: _onboardingData[index].color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  // TR: Navigasyon butonları oluştur
  // EN: Build navigation buttons
  Widget _buildNavigationButtons() {
    return Row(
      children: [
        // TR: Önceki butonu
        // EN: Previous button
        if (_currentPage > 0)
          Expanded(
            // TR: Önceki butonu
            // EN: Previous button
            child: GestureDetector(
              onTap: _previousPage,
              // TR: Buton
              // EN: Button
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  // TR: 32dp radius - Sy-OS standartı
                  // EN: 32dp radius - Sy-OS standard
                  borderRadius: BorderRadius.circular(32.0),
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.withValues(alpha: 0.1),
                      Colors.grey.withValues(alpha: 0.05),
                    ],
                  ),
                  // TR: Kenar
                  // EN: Border
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                // TR: Buton içeriği
                // EN: Button content
                child: Center(
                  // TR: İkon
                  // EN: Icon
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.grey.withValues(alpha: 0.7),
                    size: 24,
                  ),
                ),
              ),
            ),
          )
        else
          const Expanded(child: SizedBox()),

        // TR: Boşluk
        // EN: Spacer
        const SizedBox(width: 16),

        // TR: Sonraki/Tamamla butonu
        // EN: Next/Complete button
        Expanded(
          // TR: Sonraki/Tamamla butonu
          // EN: Next/Complete button
          child: GestureDetector(
            onTap: _nextPage,
            // TR: Buton
            // EN: Button
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                // TR: 32dp radius - Sy-OS standartı
                // EN: 32dp radius - Sy-OS standard
                borderRadius: BorderRadius.circular(32.0),
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    _onboardingData[_currentPage].color,
                    _onboardingData[_currentPage].color.withValues(alpha: 0.8),
                  ],
                ),
                // TR: Gölge
                // EN: Shadow
                boxShadow: [
                  BoxShadow(
                    color: _onboardingData[_currentPage].color.withValues(
                          alpha: 0.3,
                        ),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              // TR: Buton içeriği
              // EN: Button content
              child: Center(
                // TR: Buton metni
                // EN: Button text
                child: Text(
                  _currentPage == _onboardingData.length - 1
                      ? 'Başla'
                      : 'Sonraki',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// TR: Onboarding Veri Modeli - V4 yeniliği
/// EN: Onboarding Data Model - V4 innovation
/// TR: Onboarding veri modeli
/// EN: Onboarding data model
class OnboardingData {
  // TR: Başlık
  // EN: Title
  final String title;

  // TR: Alt başlık
  // EN: Subtitle
  final String subtitle;

  // TR: Açıklama
  // EN: Description
  final String description;

  // TR: Lottie asset'i
  // EN: Lottie asset
  final String lottieAsset;

  // TR: İkon
  // EN: Icon
  final IconData icon;

  // TR: Renk
  // EN: Color
  final Color color;

  // TR: Constructor
  // EN: Constructor
  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.lottieAsset,
    required this.icon,
    required this.color,
  });
}

/// TR: Onboarding Helper - V4 yeniliği
/// EN: Onboarding Helper - V4 innovation
/// TR: Onboarding için yardımcı fonksiyonlar
/// EN: Helper functions for Onboarding
class OnboardingHelper {
  // TR: Onboarding durumunu kontrol et
  // EN: Check onboarding status
  static bool checkOnboardingStatus(WidgetRef ref) {
    final preferences = ref.read(preferencesStateProvider);
    return preferences.hasSeenOnboarding;
  }

  // TR: Onboarding'i tamamla
  // EN: Complete onboarding
  static Future<void> completeOnboarding() async {
    final prefsManager = PreferencesManager();
    await prefsManager.setOnboardingSeen();
  }

  // TR: Onboarding'i sıfırla
  // EN: Reset onboarding
  static Future<void> resetOnboarding() async {
    final prefsManager = PreferencesManager();
    await prefsManager.setOnboardingSeen(false);
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

/// TR: Onboarding Provider - V4 yeniliği
/// EN: Onboarding Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
final onboardingProvider = Provider<OnboardingHelper>((ref) {
  return OnboardingHelper();
});

/// TR: Onboarding Data Provider - V4 yeniliği
/// EN: Onboarding Data Provider - V4 innovation
final onboardingDataProvider = Provider<List<OnboardingData>>((ref) {
  return [
    const OnboardingData(
      title: 'Hoş Geldiniz',
      subtitle: 'KUBBE V4\nİslami Yaşam Tarzı',
      description:
          'Modern teknoloji ile geleneksel İslami değerleri bir araya getiren yenilikçi uygulama.',
      lottieAsset: 'assets/animations/welcome.json',
      icon: Icons.waving_hand,
      color: KubbeTheme.kubbeIndigo,
    ),
    const OnboardingData(
      title: 'Hassas Vakitler',
      subtitle: 'Ezan Vakitleri\nNamaz Hatırlatıcı',
      description:
          'Konumunuza göre hassas ezan vakitleri ve namaz hatırlatıcı özellikleri.',
      lottieAsset: 'assets/animations/prayer_times.json',
      icon: Icons.access_time,
      color: Color(0xFF2196F3),
    ),
    const OnboardingData(
      title: 'Kumo AI Zekası',
      subtitle: 'İslami Bilgi\nZeki Asistan',
      description:
          'Yapay zeka destekli İslami soru-cevap sistemi ve kişiselleştirilmiş içerik.',
      lottieAsset: 'assets/animations/kumo_ai.json',
      icon: Icons.smart_toy,
      color: Color(0xFF4CAF50),
    ),
  ];
});
