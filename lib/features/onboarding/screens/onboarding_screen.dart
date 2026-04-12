import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/navigation/main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isKvkkAccepted = false;
  
  late AnimationController _shakeController;
  late AnimationController _errorColorController;
  late Animation<double> _shakeAnimation;
  late Animation<Color?> _errorColorAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _shakeAnimation = Tween<double>(begin: 0, end: 10).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    _errorColorController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _errorColorAnimation = ColorTween(begin: Colors.grey.shade300, end: Colors.red.shade400).animate(_errorColorController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _errorColorController.dispose();
    _pageController.dispose();
    super.dispose();
  }


  void _nextPage() async {
    if (_currentPage == 1) {
      // [Büyük İzin Paketi: Konum ve Bildirim - Big Permission Bundle: Location & Notification]
      // Explanation: "Kıbleyi doğru bulabilmemiz için Konum, arka planda Kur'an dinlemeye devam edebilmeniz için Bildirim iznine ihtiyacımız var."
      await Permission.location.request();
      await Permission.notification.request();
    }
    
    if (_currentPage < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    if (!_isKvkkAccepted) {
      HapticFeedback.vibrate();
      _shakeController.forward(from: 0);
      _errorColorController.forward(from: 0).then((_) => Future.delayed(const Duration(milliseconds: 1500), () => _errorColorController.reverse()));
      return;
    }

    // [Bildirim İzni İste - Request Notification Permission]
    // Explanation: "Arka planda Kur'an ve ilahi dinlemeye devam edebilmeniz için bildirim iznine ihtiyacımız var."
    await Permission.notification.request();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  void _showPrivacyAgreement() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Kullanım Koşulları ve Gizlilik',
                      style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.black54),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "KUBBE UYGULAMASI KULLANIM KOŞULLARI VE GİZLİLİK POLİTİKASI\n\n"
                    "1. Taraflar ve Amaç: Bu sözleşme, Kubbe uygulamasının sağladığı hizmetlerden yararlanan kullanıcı ile uygulama geliştiricisi arasındadır.\n\n"
                    "2. Konum Verileri: Namaz vakitlerinin en yüksek hassasiyetle hesaplanabilmesi için GPS verileriniz işlenir.\n\n"
                    "3. Bildirimler: Ezan vakitlerinde sesli veya görsel uyarı alabilmeniz için sistem bildirimlerine ihtiyaç duyulur.\n\n"
                    "4. Kişisel Veriler: Hatim takibi, zikirmatik sayaçları ve favori içerikleriniz sadece cihazınızda saklanır.\n\n"
                    "5. Çevrimiçi Servisler: Uygulama içindeki bazı özellikler internet bağlantısı gerektirir.\n\n"
                    "Uygulamayı kullanarak bu şartları beyan ve taahhüt etmiş sayılırsınız.",
                    style: GoogleFonts.inter(fontSize: 15, color: Colors.black54, height: 1.8),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(
                    onPressed: () {
                      setState(() => _isKvkkAccepted = true);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF4B0082),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Okudum ve Kabul Ediyorum', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildPage(
                    icon: PhosphorIcons.mosque(PhosphorIconsStyle.duotone),
                    title: 'Kubbe\'ye Hoş Geldiniz',
                    description: 'Namaz vakitlerinden Kur\'an-ı Kerim\'e, rüya tabirlerinden zikirlere kadar tüm ihtiyaçlarınız tek bir çatı altında.',
                  ),
                  _buildPage(
                    isPermissionPage: true, // [İzin sayfası - Permission page]
                    icon: PhosphorIcons.shieldCheck(PhosphorIconsStyle.duotone),
                    title: 'İbadetinize Odaklanın',
                    description: 'Kıbleyi doğru bulabilmemiz için Konum, arka planda Kur\'an dinlemeye devam edebilmeniz için Bildirim iznine ihtiyacımız var.',
                  ),
                  _buildPage(
                    icon: PhosphorIcons.shieldCheck(PhosphorIconsStyle.duotone),
                    title: 'Güvenli ve Gizli',
                    description: 'Verileriniz cihazınızda güvende kalsın. Gizliliğinize önem veriyor, şeffaf bir deneyim sunuyoruz.',
                    isLastPage: true,
                  ),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required IconData icon, required String title, required String description, bool isLastPage = false, bool isPermissionPage = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isPermissionPage)
            const PulsingPermissionIcon() // [Özel Pulsing Animasyonu - Custom Pulsing Animation]
          else
            Icon(icon, size: 120, color: const Color(0xFF4B0082)),
          
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 16, color: Colors.black54, height: 1.6),
          ),
          if (isPermissionPage) ...[
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Kubbe Müzik sayfasındaki YouTube damgalı içerikler arka planda çalınamaz.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isLastPage) ...[
            const SizedBox(height: 40),
            _buildPrivacyCheckbox(),
          ],
        ],
      ),
    );
  }

  Widget _buildPrivacyCheckbox() {
    return AnimatedBuilder(
      animation: Listenable.merge([_shakeAnimation, _errorColorAnimation]),
      builder: (context, child) {
        final double shakeOffset = _shakeAnimation.value * math.sin(math.pi * 4 * _shakeController.value);
        final bool isError = _errorColorController.isAnimating || _errorColorController.isCompleted;

        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isError ? Colors.red.withValues(alpha: 0.05) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isError ? Colors.red.shade200 : Colors.transparent, width: 1),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _isKvkkAccepted,
                    onChanged: (val) => setState(() => _isKvkkAccepted = val ?? false),
                    activeColor: const Color(0xFF4B0082),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    side: BorderSide(color: isError ? Colors.red : Colors.grey.shade400, width: 2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(fontSize: 13, color: isError ? Colors.red.shade900 : Colors.black54),
                      children: [
                        const TextSpan(text: 'Kullanım şartlarını ve '),
                        TextSpan(
                          text: 'Gizlilik Politikası',
                          style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = _showPrivacyAgreement,
                        ),
                        const TextSpan(text: '\'nı onaylıyorum.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dynamic Indicators
          Row(
            children: List.generate(3, (index) {
              final bool isActive = _currentPage == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 8),
                width: isActive ? 32 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF4B0082) : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),
          // Navigation Button
          FilledButton(
            onPressed: _nextPage,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF4B0082),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              _currentPage == 2 ? 'Hadi Başlayalım' : 'İleri',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// [PulsingPermissionIcon] Saf Flutter ile sürekli pulse yapan ikon - Pure Flutter continuous pulsing icon
class PulsingPermissionIcon extends StatefulWidget {
  const PulsingPermissionIcon({super.key});

  @override
  State<PulsingPermissionIcon> createState() => _PulsingPermissionIconState();
}

class _PulsingPermissionIconState extends State<PulsingPermissionIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true); // [Sürekli tekrar ve tersine dön - Repeat and reverse]

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF4B0082).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4B0082).withValues(alpha: 0.05),
                  blurRadius: 20 * _scaleAnimation.value,
                  spreadRadius: 5 * _scaleAnimation.value,
                ),
              ],
            ),
            child: const Icon(Icons.security_update_good_rounded, size: 80, color: Color(0xFF4B0082)),
          ),
        );
      },
    );
  }
}
