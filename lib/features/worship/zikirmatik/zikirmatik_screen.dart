// TR: KUBBE V4 Elite Zikirmatik Screen - V1'den miras alındı
// EN: KUBBE V4 Elite Zikirmatik Screen - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Tam ekran dokunmatik (Gesture) desteği. AMBER MODU: Gece göz yormayan, V1'den hatırladığımız o turuncu/kehribar temayı bir switch ile aktif et
// EN: Full-screen touch (Gesture) support. AMBER MODE: Activate the orange/amber theme from V1 that doesn't strain the eyes at night with a switch
// TR: Haptic Feedback: Her tıklamada Samsung A55'in titreşim motorunu hissettir (HapticFeedback.lightImpact)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/storage/preferences_manager.dart';
import '../../../core/utils/haptic_helper.dart';

/// TR: KUBBE V4 Elite Zikirmatik Screen Sınıfı
/// EN: KUBBE V4 Elite Zikirmatik Screen Class
/// TR: V1'deki zikirmatik mantığı modernize edildi
/// EN: Modernized V1's zikirmatik logic
/// TR: Tam ekran dokunmatik destek ve haptic feedback
/// EN: Full-screen touch support and haptic feedback
/// TR: AMBER MODU - gece göz yormayan tema
/// EN: AMBER MODE - eye-friendly night theme
/// TR: V1'den miras alınan mantık V4 estetiğiyle modernize edildi
/// EN: Logic inherited from V1 modernized with V4 aesthetics
class EliteZikirmatikScreen extends ConsumerStatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const EliteZikirmatikScreen({super.key});

  @override
  ConsumerState<EliteZikirmatikScreen> createState() =>
      _EliteZikirmatikScreenState();
}

// TR: Elite Zikirmatik Screen State
// EN: Elite Zikirmatik Screen State
class _EliteZikirmatikScreenState extends ConsumerState<EliteZikirmatikScreen>
    with TickerProviderStateMixin {
  // TR: Animation controller
  // EN: Animation controller
  late AnimationController _animationController;

  // TR: Scale animation
  // EN: Scale animation
  late Animation<double> _scaleAnimation;

  // TR: Rotation animation
  // EN: Rotation animation
  late Animation<double> _rotationAnimation;

  // TR: Amber modu
  // EN: Amber mode
  bool _isAmberMode = false;

  // TR: Zikir sayacı
  // EN: Zikir counter
  int _zikirCount = 0;

  // TR: Hedef sayı
  // EN: Target count
  int _targetCount = 33;

  // TR: Seçili zikir
  // EN: Selected zikir
  String _selectedZikir = 'Subhanallah';

  // TR: Zikir listesi
  // EN: Zikir list
  final List<String> _zikirList = [
    'Subhanallah',
    'Elhamdulillah',
    'Allahu Akbar',
    'La ilaha illallah',
    'Muhammedun Rasulullah',
    'Astaghfirullah',
    'Hasbunallahu wa ni\'mal wakeel',
    'La hawla wa la quwwata illa billah',
    'Rabbana atina fid dunya hasanah',
    'Rabbana atina fil akhirati hasanah',
  ];

  @override
  void initState() {
    super.initState();

    // TR: Animation controller'ı başlat
    // EN: Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // TR: Scale animation'u ayarla
    // EN: Set up scale animation
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    // TR: Rotation animation'u ayarla
    // EN: Set up rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    // TR: Ayarları yükle
    // EN: Load settings
    _loadSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // TR: Ayarları yükle
  // EN: Load settings
  void _loadSettings() {
    final preferences = ref.read(preferencesStateProvider);
    setState(() {
      _zikirCount = preferences.zikirCounter;
      _isAmberMode = preferences.isAmberMode;
    });
  }

  // TR: Zikir sayısını artır
  // EN: Increment zikir count
  void _incrementZikir() {
    // TR: Haptic feedback - Elite Tok Click
    // EN: Haptic feedback - Elite Tok Click
    HapticHelper.tokClick();

    setState(() {
      _zikirCount++;
    });

    // TR: Preferences'e kaydet
    // EN: Save to preferences
    ref.read(preferencesProvider.notifier).incrementZikir();

    // TR: Animation'u başlat
    // EN: Start animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // TR: Hedefe ulaşıldığında bildirim
    // EN: Notification when target reached
    if (_zikirCount % _targetCount == 0) {
      _showCompletionMessage();
    }
  }

  // TR: Zikiri sıfırla
  // EN: Reset zikir
  void _resetZikir() {
    // TR: Haptic feedback - Elite Heavy Click
    // EN: Haptic feedback - Elite Heavy Click
    HapticHelper.heavyClick();

    setState(() {
      _zikirCount = 0;
    });

    // TR: Preferences'e kaydet
    // EN: Save to preferences
    ref.read(preferencesProvider.notifier).resetZikir();
  }

  // TR: Amber modunu aç/kapat
  // EN: Toggle amber mode
  void _toggleAmberMode() {
    // TR: Haptic feedback - Elite Tok Click
    // EN: Haptic feedback - Elite Tok Click
    HapticHelper.tokClick();

    setState(() {
      _isAmberMode = !_isAmberMode;
    });

    // TR: Preferences'e kaydet
    // EN: Save to preferences
    ref.read(preferencesProvider.notifier).setAmberMode(_isAmberMode);
  }

  // TR: Zikir seç
  // EN: Select zikir
  void _selectZikir(String zikir) {
    // TR: Haptic feedback - Elite Tok Click
    // EN: Haptic feedback - Elite Tok Click
    HapticHelper.tokClick();

    setState(() {
      _selectedZikir = zikir;
    });
  }

  // TR: Hedefi ayarla
  // EN: Set target
  void _setTarget(int target) {
    // TR: Haptic feedback - Elite Tok Click
    // EN: Haptic feedback - Elite Tok Click
    HapticHelper.tokClick();

    setState(() {
      _targetCount = target;
    });
  }

  // TR: Tamamlama mesajı göster
  // EN: Show completion message
  void _showCompletionMessage() {
    // TR: Haptic feedback - Elite Heavy Click
    // EN: Haptic feedback - Elite Heavy Click
    HapticHelper.heavyClick();

    // TR: SnackBar göster
    // EN: Show SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Maşaallah! $_targetCount zikir tamamlandı!',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        // TR: Gradient arka plan
        // EN: Gradient background
        backgroundColor: KubbeTheme.kubbeIndigo,
        // TR: Süre
        // EN: Duration
        duration: const Duration(seconds: 2),
        // TR: Davranış
        // EN: Behavior
        behavior: SnackBarBehavior.floating,
        // TR: Şekil
        // EN: Shape
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
  }

  // TR: Renk temasını al
  // EN: Get color theme
  ColorScheme _getColorScheme() {
    if (_isAmberMode) {
      // TR: Amber modu renkleri
      // EN: Amber mode colors
      return ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF8C00), // TR: Amber // EN: Amber
        brightness: Brightness.dark,
        primary: const Color(0xFFFF8C00), // TR: Amber // EN: Amber
        secondary:
            const Color(0xFFFFD54F), // TR: Light Amber // EN: Light Amber
        surface: const Color(0xFF1A1A00), // TR: Dark Amber // EN: Dark Amber
        onPrimary: const Color(0xFF000000), // TR: Black // EN: Black
        onSecondary: const Color(0xFF000000), // TR: Black // EN: Black
        onSurface:
            const Color(0xFFFFD54F), // TR: Light Amber // EN: Light Amber
      );
    } else {
      // TR: Normal mod renkleri
      // EN: Normal mode colors
      return ColorScheme.fromSeed(
        seedColor: KubbeTheme.kubbeIndigo,
        brightness: Brightness.light,
        primary: KubbeTheme.kubbeIndigo,
        secondary: KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
        surface: Colors.white,
        onSurface: Colors.black87,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = _getColorScheme();

    return Theme(
      // TR: Tema
      // EN: Theme
      data: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
      ),
      // TR: Scaffold
      // EN: Scaffold
      child: Scaffold(
        // TR: AppBar
        // EN: AppBar
        appBar: AppBar(
          // TR: Başlık
          // EN: Title
          title: Text(
            'Elite Zikirmatik',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          // TR: Arka plan
          // EN: Background
          backgroundColor: colorScheme.surface,
          // TR: Gölge kaldır
          // EN: Remove shadow
          elevation: 0,
          // TR: Eylemler
          // EN: Actions
          actions: [
            // TR: Amber modu switch
            // EN: Amber mode switch
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              // TR: Switch
              // EN: Switch
              child: Switch(
                value: _isAmberMode,
                onChanged: (value) => _toggleAmberMode(),
                // TR: Aktif renk
                // EN: Active color
                activeThumbColor: _isAmberMode
                    ? const Color(0xFFFF8C00)
                    : KubbeTheme.kubbeIndigo,
                // TR: Pasif renk
                // EN: Inactive color
                inactiveThumbColor: Colors.grey,
                // TR: İkon
                // EN: Icon
                activeThumbImage: const AssetImage('assets/icons/moon.png'),
                inactiveThumbImage: const AssetImage('assets/icons/sun.png'),
              ),
            ),
          ],
        ),

        // TR: Body
        // EN: Body
        body: Container(
          decoration: BoxDecoration(
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: LinearGradient(
              colors: _isAmberMode
                  ? [
                      const Color(0xFF0D0D00),
                      const Color(0xFF1A1A00),
                      const Color(0xFF262600),
                    ]
                  : [
                      colorScheme.surface,
                      colorScheme.surface.withValues(alpha: 0.95),
                      colorScheme.surface.withValues(alpha: 0.9),
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          // TR: İçerik
          // EN: Content
          child: Column(
            children: [
              // TR: Zikir seçici
              // EN: Zikir selector
              _buildZikirSelector(),

              // TR: Zikir sayacı
              // EN: Zikir counter
              Expanded(
                child: _buildZikirCounter(),
              ),

              // TR: Kontroller
              // EN: Controls
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  // TR: Zikir seçici oluştur
  // EN: Build zikir selector
  Widget _buildZikirSelector() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // TR: 32dp radius - Sy-OS standartı
        // EN: 32dp radius - Sy-OS standard
        borderRadius: BorderRadius.circular(32.0),
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: _isAmberMode
              ? [
                  const Color(0xFF1A1A00),
                  const Color(0xFF262600),
                ]
              : [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.95),
                ],
        ),
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      // TR: Zikir listesi
      // EN: Zikir list
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TR: Başlık
          // EN: Title
          Text(
            'Zikir Seçimi',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isAmberMode
                  ? const Color(0xFFFFD54F)
                  : KubbeTheme.kubbeIndigo,
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 12.0),

          // TR: Zikir butonları
          // EN: Zikir buttons
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _zikirList.map((zikir) {
              return _buildZikirButton(zikir);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // TR: Zikir butonu oluştur
  // EN: Build zikir button
  Widget _buildZikirButton(String zikir) {
    final isSelected = _selectedZikir == zikir;

    return GestureDetector(
      onTap: () => _selectZikir(zikir),
      // TR: Buton container
      // EN: Button container
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          // TR: 32dp radius
          // EN: 32dp radius
          borderRadius: BorderRadius.circular(32.0),
          // TR: Gradient arka plan
          // EN: Gradient background
          gradient: isSelected
              ? LinearGradient(
                  colors: _isAmberMode
                      ? [
                          const Color(0xFFFF8C00),
                          const Color(0xFFFFD54F),
                        ]
                      : [
                          KubbeTheme.kubbeIndigo,
                          KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                        ],
                )
              : null,
          // TR: Kenar
          // EN: Border
          border: isSelected
              ? null
              : Border.all(
                  color: _isAmberMode
                      ? const Color(0xFFFF8C00)
                      : KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                  width: 1,
                ),
          // TR: Renk
          // EN: Color
          color: isSelected ? null : Colors.transparent,
        ),
        // TR: Buton metni
        // EN: Button text
        child: Text(
          zikir,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (_isAmberMode
                    ? const Color(0xFFFF8C00)
                    : KubbeTheme.kubbeIndigo),
          ),
        ),
      ),
    );
  }

  // TR: Zikir sayacı oluştur
  // EN: Build zikir counter
  Widget _buildZikirCounter() {
    return Center(
      // TR: Dokunmatik alan
      // EN: Touch area
      child: GestureDetector(
        onTap: _incrementZikir,
        // TR: Tam ekran dokunma
        // EN: Full-screen touch
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            // TR: 32dp radius - Sy-OS standartı
            // EN: 32dp radius - Sy-OS standard
            borderRadius: BorderRadius.circular(32.0),
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: LinearGradient(
              colors: _isAmberMode
                  ? [
                      const Color(0xFFFF8C00),
                      const Color(0xFFFFD54F),
                    ]
                  : [
                      KubbeTheme.kubbeIndigo,
                      KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // TR: Gölge
            // EN: Shadow
            boxShadow: [
              BoxShadow(
                color: _isAmberMode
                    ? const Color(0xFFFF8C00).withValues(alpha: 0.3)
                    : KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                blurRadius: 20.0,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          // TR: Sayı içeriği
          // EN: Counter content
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                // TR: Dönüş animasyonu
                // EN: Rotation animation
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  // TR: Sayı metni
                  // EN: Number text
                  child: Center(
                    // TR: Sayı
                    // EN: Number - Poppins Bold
                    child: Text(
                      '$_zikirCount',
                      style: GoogleFonts.poppins(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // TR: Kontroller oluştur
  // EN: Build controls
  Widget _buildControls() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // TR: 32dp radius - Sy-OS standartı
        // EN: 32dp radius - Sy-OS standard
        borderRadius: BorderRadius.circular(32.0),
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: _isAmberMode
              ? [
                  const Color(0xFF1A1A00),
                  const Color(0xFF262600),
                ]
              : [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.95),
                ],
        ),
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      // TR: Kontrol içeriği
      // EN: Control content
      child: Column(
        children: [
          // TR: Hedef seçici
          // EN: Target selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TR: Hedef metni
              // EN: Target text
              Text(
                'Hedef: $_targetCount',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isAmberMode
                      ? const Color(0xFFFFD54F)
                      : KubbeTheme.kubbeIndigo,
                ),
              ),

              // TR: Hedef butonları
              // EN: Target buttons
              Row(
                children: [
                  // TR: 33 butonu
                  // EN: 33 button
                  _buildTargetButton(33),
                  const SizedBox(width: 8),
                  // TR: 99 butonu
                  // EN: 99 button
                  _buildTargetButton(99),
                  const SizedBox(width: 8),
                  // TR: 1000 butonu
                  // EN: 1000 button
                  _buildTargetButton(1000),
                ],
              ),
            ],
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 16.0),

          // TR: Durum ve sıfırlama
          // EN: Status and reset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TR: Durum metni
              // EN: Status text
              Text(
                'Tamamlanan: ${(_zikirCount ~/ _targetCount)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: _isAmberMode
                      ? const Color(0xFFFFD54F)
                      : KubbeTheme.kubbeIndigo,
                ),
              ),

              // TR: Sıfırla butonu
              // EN: Reset button
              GestureDetector(
                onTap: _resetZikir,
                // TR: Buton
                // EN: Button
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    // TR: 32dp radius
                    // EN: 32dp radius
                    borderRadius: BorderRadius.circular(32.0),
                    // TR: Gradient arka plan
                    // EN: Gradient background
                    gradient: LinearGradient(
                      colors: _isAmberMode
                          ? [
                              const Color(0xFFFF8C00),
                              const Color(0xFFFFD54F),
                            ]
                          : [
                              KubbeTheme.kubbeIndigo,
                              KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                            ],
                    ),
                  ),
                  // TR: Buton metni
                  // EN: Button text
                  child: Text(
                    'Sıfırla',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TR: Hedef butonu oluştur
  // EN: Build target button
  Widget _buildTargetButton(int target) {
    final isSelected = _targetCount == target;

    return GestureDetector(
      onTap: () => _setTarget(target),
      // TR: Buton
      // EN: Button
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          // TR: Yuvarlak
          // EN: Circle
          shape: BoxShape.circle,
          // TR: Gradient arka plan
          // EN: Gradient background
          gradient: isSelected
              ? LinearGradient(
                  colors: _isAmberMode
                      ? [
                          const Color(0xFFFF8C00),
                          const Color(0xFFFFD54F),
                        ]
                      : [
                          KubbeTheme.kubbeIndigo,
                          KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                        ],
                )
              : LinearGradient(
                  colors: _isAmberMode
                      ? [
                          const Color(0xFF1A1A00),
                          const Color(0xFF262600),
                        ]
                      : [
                          Colors.white,
                          Colors.white.withValues(alpha: 0.95),
                        ],
                ),
          // TR: Kenar
          // EN: Border
          border: isSelected
              ? null
              : Border.all(
                  color: _isAmberMode
                      ? const Color(0xFFFF8C00)
                      : KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                  width: 1,
                ),
        ),
        // TR: Buton metni
        // EN: Button text
        child: Center(
          child: Text(
            '$target',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : (_isAmberMode
                      ? const Color(0xFFFF8C00)
                      : KubbeTheme.kubbeIndigo),
            ),
          ),
        ),
      ),
    );
  }
}
