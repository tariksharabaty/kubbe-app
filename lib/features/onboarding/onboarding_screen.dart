// TR: KUBBE V4 Onboarding Screen - Kumo AI Rehberlik
// EN: KUBBE V4 Onboarding Screen - Kumo AI Guidance
// TR: 3 sayfalık modern onboarding yapısı
// EN: 3-page modern onboarding structure

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/storage/preferences_manager.dart';

/// TR: KUBBE V4 Onboarding Screen Sınıfı
/// EN: KUBBE V4 Onboarding Screen Class
/// TR: Kumo AI rehberliğinde 3 sayfalık modern onboarding
/// EN: Modern 3-page onboarding with Kumo AI guidance
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  String _selectedLanguage = 'tr';
  bool _darkMode = false;
  bool _amberMode = false;
  bool _termsAccepted = false;

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

  // TR: Dil seçimi
  // EN: Language selection
  void _selectLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  // TR: Tema seçimi
  // EN: Theme selection
  void _selectTheme(String theme) {
    setState(() {
      if (theme == 'dark') {
        _darkMode = true;
        _amberMode = false;
      } else if (theme == 'amber') {
        _darkMode = true;
        _amberMode = true;
      } else {
        _darkMode = false;
        _amberMode = false;
      }
    });
  }

  // TR: Onboarding tamamlama
  // EN: Complete onboarding
  void _completeOnboarding() async {
    if (_termsAccepted) {
      // TR: Tercihleri kaydet
      // EN: Save preferences
      final prefsManager = PreferencesManager();
      await prefsManager.setLanguage(_selectedLanguage);
      await prefsManager.setFirstTime(false);

      // TR: Ana ekrana git
      // EN: Navigate to home screen
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // TR: Sayfa göstergisi
            // EN: Page indicator
            _buildPageIndicator(),

            // TR: Sayfa içeriği
            // EN: Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPage1(), // Selam
                  _buildPage2(), // İzinler
                  _buildPage3(), // Tema ve Onay
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TR: Sayfa göstergisi
  // EN: Page indicator
  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? KubbeTheme.kubbeIndigo
                  : KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        }).toList(),
      ),
    );
  }

  // TR: Sayfa 1 - Selam
  // EN: Page 1 - Welcome
  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TR: Kumo AI ikonu
          // EN: Kumo AI icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  KubbeTheme.kubbeIndigo,
                  KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(60.0),
              boxShadow: [
                BoxShadow(
                  color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 60,
            ),
          ),

          const SizedBox(height: 40.0),

          // TR: Başlık
          // EN: Title
          Text(
            'Selamun Aleykum',
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),

          const SizedBox(height: 16.0),

          // TR: Slogan
          // EN: Slogan
          Text(
            'Kubbe Sygrad\nİslami Yaşam Asistanınız',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 60.0),

          // TR: Dil seçimi
          // EN: Language selection
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  // TR: Dil seçici
  // EN: Language selector
  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Dil Seçimi',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),
          const SizedBox(height: 16.0),

          // TR: Dil butonları
          // EN: Language buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLanguageButton('tr', 'Türkçe'),
              _buildLanguageButton('en', 'English'),
              _buildLanguageButton('ar', 'العربية'),
            ],
          ),
        ],
      ),
    );
  }

  // TR: Dil butonu
  // EN: Language button
  Widget _buildLanguageButton(String code, String name) {
    final isSelected = _selectedLanguage == code;

    return GestureDetector(
      onTap: () => _selectLanguage(code),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? KubbeTheme.kubbeIndigo : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          name,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : KubbeTheme.kubbeIndigo,
          ),
        ),
      ),
    );
  }

  // TR: Sayfa 2 - İzinler
  // EN: Page 2 - Permissions
  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          // TR: Kumo rehber ikonu
          // EN: Kumo guide icon
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
                    KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: const Icon(
                Icons.psychology_outlined,
                color: KubbeTheme.kubbeIndigo,
                size: 40,
              ),
            ),
          ),

          const SizedBox(height: 60.0),

          // TR: Başlık
          // EN: Title
          Text(
            'İzinler',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),

          const SizedBox(height: 24.0),

          // TR: İzin kartları
          // EN: Permission cards
          Column(
            children: [
              _buildPermissionCard(
                icon: Icons.location_on_outlined,
                title: 'Konum İzni',
                description:
                    'Konum tabanlı namaz vakitleri için GPS konumunuza erişim',
              ),
              const SizedBox(height: 16.0),
              _buildPermissionCard(
                icon: Icons.notifications_outlined,
                title: 'Bildirimler',
                description:
                    'Namaz vakitleri hatırlatmaları ve önemli bildirimleri alma',
              ),
              const SizedBox(height: 16.0),
              _buildPermissionCard(
                icon: Icons.storage_outlined,
                title: 'Depolama Alanı',
                description:
                    'Ayarlarınızı ve verilerinizi güvenli bir şekilde saklama',
              ),
            ],
          ),

          const SizedBox(height: 40.0),

          // TR: İzin ver butonu
          // EN: Grant permission button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TR: İzinleri iste
                // EN: Request permissions
                _showKumoGuide();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: KubbeTheme.kubbeIndigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                textStyle: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(
                'İzin Ver',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TR: İzin kartı
  // EN: Permission card
  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(
          color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // TR: İkon
          // EN: Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Icon(
              icon,
              color: KubbeTheme.kubbeIndigo,
              size: 24,
            ),
          ),

          const SizedBox(width: 16.0),

          // TR: Metin
          // EN: Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TR: Sayfa 3 - Tema ve Onay
  // EN: Page 3 - Theme and Confirmation
  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          // TR: Başlık
          // EN: Title
          Text(
            'Tema ve Onay',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),

          const SizedBox(height: 32.0),

          // TR: Tema seçimi
          // EN: Theme selection
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(32.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Uygulama Teması',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                ),

                const SizedBox(height: 20.0),

                // TR: Tema butonları
                // EN: Theme buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildThemeButton('Açık', 'light', false, false),
                    _buildThemeButton('Koyu', 'dark', true, false),
                    _buildThemeButton('Amber', 'amber', true, true),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32.0),

          // TR: Kullanım koşulları
          // EN: Terms and conditions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(32.0),
              border: Border.all(
                color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Kullanım Koşulları',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                ),

                const SizedBox(height: 16.0),

                Text(
                  'Kubbe Sygrad uygulamasını kullanarak, İslami yaşam tarzınıza uygun namaz vakitleri, hesaplama yöntemleri ve kişiselleştirme seçenekleri sunarız. Verileriniz gizlidir ve sadece uygulama içinde kullanılır.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20.0),

                // TR: Checkbox ve buton
                // EN: Checkbox and button
                Row(
                  children: [
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
                              border: Border.all(
                                color: KubbeTheme.kubbeIndigo,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: _termsAccepted
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: KubbeTheme.kubbeIndigo,
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            'Kullanım Koşullarını Onaylıyorum',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32.0),

          // TR: Başla butonu
          // EN: Start button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _termsAccepted ? _completeOnboarding : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _termsAccepted
                    ? KubbeTheme.kubbeIndigo
                    : Colors.grey.shade300,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                textStyle: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(
                'Başla',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TR: Tema butonu
  // EN: Theme button
  Widget _buildThemeButton(
    String label,
    String themeType,
    bool isDark,
    bool isAmber,
  ) {
    final isSelected = (isDark && _darkMode) || (isAmber && _amberMode);

    return GestureDetector(
      onTap: () => _selectTheme(themeType),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? (isAmber ? KubbeTheme.amberPrimary : KubbeTheme.kubbeIndigo)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
          border: isAmber && isSelected
              ? Border.all(
                  color: KubbeTheme.amberPrimary.withValues(alpha: 0.5),
                  width: 2,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TR: Tema ikonu
            // EN: Theme icon
            Icon(
              isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: isSelected ? Colors.white : KubbeTheme.kubbeIndigo,
              size: 20,
            ),

            if (isAmber && isSelected) ...[
              const SizedBox(width: 8.0),
              const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 16,
              ),
            ],

            const SizedBox(width: 8.0),

            // TR: Tema adı
            // EN: Theme name
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : KubbeTheme.kubbeIndigo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TR: Kumo rehber balonu
  // EN: Kumo guide balloon
  void _showKumoGuide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        content: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TR: Kumo ikonu
              // EN: Kumo icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      KubbeTheme.kubbeIndigo,
                      KubbeTheme.kubbeIndigo,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(height: 16.0),

              // TR: Rehberlik metni
              // EN: Guidance text
              Text(
                'Kumo AI size rehberlik ediyor!\n\nİzinlere ihtiyaç duyulmasının nedenlerini açıklayan Sy-OS tarzı kartlar size özel olarak tasarlandı.\n\nDevam etmek için izin vermeniz yeterli olacaktır.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Anladım',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: KubbeTheme.kubbeIndigo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
