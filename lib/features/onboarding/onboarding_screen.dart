// TR: KUBBE V4 Onboarding Screen - 3 Page Flow
// EN: KUBBE V4 Onboarding Screen - 3 Page Flow
// TR: Elite görünüm ve KubbeTheme ile 3 sayfalık onboarding akışı
// EN: 3-page onboarding flow with Elite appearance and KubbeTheme

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/storage/preferences_manager.dart';

/// TR: Onboarding Screen - 3 sayfalık akış
/// EN: Onboarding Screen - 3 page flow
class OnboardingScreen extends ConsumerStatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  // TR: PageView controller
  // EN: PageView controller
  late PageController _pageController;

  // TR: State variables
  // EN: State variables
  bool _termsAccepted = false;
  bool _isDarkMode = false;
  bool _locationPermissionGranted = false;
  bool _notificationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // TR: Sonraki sayfaya git
  // EN: Go to next page
  void _nextPage() {
    if (_pageController.page! < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // TR: Önceki sayfaya git
  // EN: Go to previous page
  void _previousPage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // TR: Konum iznini iste
  // EN: Request location permission
  Future<void> _requestLocationPermission() async {
    try {
      final position = await Geolocator.requestPermission();
      setState(() {
        _locationPermissionGranted = position != LocationPermission.denied;
      });
    } catch (e) {
      setState(() {
        _locationPermissionGranted = false;
      });
    }
  }

  // TR: Bildirim iznini iste
  // EN: Request notification permission
  Future<void> _requestNotificationPermission() async {
    try {
      final status = await Permission.notification.request();
      setState(() {
        _notificationPermissionGranted = status.isGranted;
      });
    } catch (e) {
      setState(() {
        _notificationPermissionGranted = false;
      });
    }
  }

  // TR: Tüm izinleri iste
  // EN: Request all permissions
  Future<void> _requestPermissions() async {
    await _requestLocationPermission();
    await _requestNotificationPermission();
  }

  // TR: Başla butonu işlemi
  // EN: Start button action
  void _onStartPressed() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lütfen kullanım koşullarını kabul edin',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: KubbeTheme.kubbeIndigo,
        ),
      );
      return;
    }

    // TR: Tercihleri kaydet
    // EN: Save preferences
    final preferencesManager = ref.read(preferencesManagerProvider.notifier);
    await preferencesManager.setTermsAccepted(true);
    await preferencesManager
        .setThemeMode(_isDarkMode ? ThemeMode.dark : ThemeMode.light);

    // TR: Ana sayfaya yönlendir
    // EN: Navigate to home page
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // TR: Page indicator
            // EN: Page indicator
            _buildPageIndicator(),

            // TR: PageView
            // EN: PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomePage(),
                  _buildPermissionsPage(),
                  _buildSettingsPage(),
                ],
              ),
            ),

            // TR: Navigation buttons
            // EN: Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  // TR: Page indicator
  // EN: Page indicator
  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < 3; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _pageController.hasClients &&
                      _pageController.page?.round() == i
                  ? 24
                  : 8,
              decoration: BoxDecoration(
                color: _pageController.hasClients &&
                        _pageController.page?.round() == i
                    ? KubbeTheme.kubbeIndigo
                    : KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }

  // TR: Navigation buttons
  // EN: Navigation buttons
  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TR: Previous button
          // EN: Previous button
          if (_pageController.hasClients && _pageController.page! > 0)
            TextButton(
              onPressed: _previousPage,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Geri',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: KubbeTheme.kubbeIndigo,
                ),
              ),
            )
          else
            const SizedBox(width: 80),

          // TR: Next/Start button
          // EN: Next/Start button
          Consumer(
            builder: (context, ref, child) {
              final currentPage = _pageController.hasClients
                  ? _pageController.page?.round() ?? 0
                  : 0;

              if (currentPage < 2) {
                return ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KubbeTheme.kubbeIndigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'Devam',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              } else {
                return ElevatedButton(
                  onPressed: _onStartPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KubbeTheme.kubbeIndigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'BAŞLA',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // TR: SAYFA 1 - Karşılama
  // EN: PAGE 1 - Welcome
  Widget _buildWelcomePage() {
    return Consumer(
      builder: (context, ref, child) {
        final preferencesManager = ref.watch(preferencesManagerProvider);

        return Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // TR: Kubbe logosu
              // EN: Kubbe logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: KubbeTheme.kubbeIndigo,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mosque,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 32),

              // TR: Selamun Aleykum
              // EN: Selamun Aleykum
              Text(
                'Selamun Aleykum',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: KubbeTheme.kubbeIndigo,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // TR: Kubbe'ye Hoşgeldiniz
              // EN: Welcome to Kubbe
              Text(
                'Kubbe\'ye Hoşgeldiniz',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // TR: Language Picker
              // EN: Language Picker
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TR: Turkish
                    // EN: Turkish
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(preferencesManagerProvider.notifier)
                            .setLanguage('tr');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: preferencesManager.language == 'tr'
                              ? KubbeTheme.kubbeIndigo
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          'TR',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: preferencesManager.language == 'tr'
                                ? Colors.white
                                : KubbeTheme.kubbeIndigo,
                          ),
                        ),
                      ),
                    ),

                    // TR: English
                    // EN: English
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(preferencesManagerProvider.notifier)
                            .setLanguage('en');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: preferencesManager.language == 'en'
                              ? KubbeTheme.kubbeIndigo
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          'EN',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: preferencesManager.language == 'en'
                                ? Colors.white
                                : KubbeTheme.kubbeIndigo,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        );
      },
    );
  }

  // TR: SAYFA 2 - İzinler
  // EN: PAGE 2 - Permissions
  Widget _buildPermissionsPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // TR: İkon
          // EN: Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: KubbeTheme.amberPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.security,
              size: 50,
              color: KubbeTheme.amberPrimary,
            ),
          ),

          const SizedBox(height: 32),

          // TR: Başlık
          // EN: Title
          Text(
            'İzinler',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // TR: Açıklama metni
          // EN: Explanation text
          Text(
            'Kubbe\'nin size en iyi hizmeti sunabilmesi için bazı izinlere ihtiyacı var:\n\n'
            '📍 Konum İzni: Namaz vakitlerinizi bulunduğunuz konuma göre hesaplamak için.\n\n'
            '🔔 Bildirim İzni: Namaz vakitlerinde size hatırlatmalar göndermek için.\n\n'
            'Bu izinler tamamen isteğe bağlıdır ve istediğiniz zaman ayarlardan değiştirebilirsiniz.',
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 1.6,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // TR: İzin durumu kartları
          // EN: Permission status cards
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                // TR: Konum izni
                // EN: Location permission
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: _locationPermissionGranted
                              ? Colors.green
                              : KubbeTheme.kubbeIndigo,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Konum İzni',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      _locationPermissionGranted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _locationPermissionGranted
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // TR: Bildirim izni
                // EN: Notification permission
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: _notificationPermissionGranted
                              ? Colors.green
                              : KubbeTheme.kubbeIndigo,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Bildirim İzni',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      _notificationPermissionGranted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _notificationPermissionGranted
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // TR: İzinleri ayarla butonu
          // EN: Set permissions button
          ElevatedButton.icon(
            onPressed: _requestPermissions,
            icon: const Icon(Icons.settings),
            label: Text(
              'İzinleri Ayarla',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: KubbeTheme.amberPrimary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  // TR: SAYFA 3 - Ayarlar ve Onay
  // EN: PAGE 3 - Settings and Confirmation
  Widget _buildSettingsPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // TR: İkon
          // EN: Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.settings,
              size: 50,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),

          const SizedBox(height: 32),

          // TR: Başlık
          // EN: Title
          Text(
            'Ayarlar',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // TR: Tema seçimi
          // EN: Theme selection
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tema Seçimi',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // TR: Tema switch'leri
                // EN: Theme switches
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Mode',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.8),
                      ),
                    ),
                    Switch(
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                      },
                      activeThumbColor: KubbeTheme.kubbeIndigo,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // TR: Kullanım koşulları onayı
          // EN: Terms and conditions acceptance
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kullanım Koşulları',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),

                // TR: Checkbox
                // EN: Checkbox
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _termsAccepted = !_termsAccepted;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _termsAccepted
                              ? KubbeTheme.kubbeIndigo
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _termsAccepted
                                ? KubbeTheme.kubbeIndigo
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: _termsAccepted
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Kullanım koşullarını ve gizlilik politikasını kabul ediyorum',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
