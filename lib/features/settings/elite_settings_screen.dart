// TR: KUBBE V4 Elite Settings Panel - V4 yeniliği
// EN: KUBBE V4 Elite Settings Panel - V4 innovation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: One UI Tarzı Gruplandırma: 32dp radius'lu beyaz kartlar içinde Ayarlar.
// EN: One UI Style Grouping: Settings inside 32dp radius white cards.
// TR: Switchler: Bildirimler (Ezan/Hatırlatıcı), Tema (Light/Dark/Amber), Dil Seçimi.
// EN: Switches: Notifications (Adhan/Reminder), Theme (Light/Dark/Amber), Language Selection.
// TR: Alt Kısım: 'Sygrad' imzası ve versiyon numarası (v4.0.0).
// EN: Bottom Section: 'Sygrad' signature and version number (v4.0.0).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/haptic_utils.dart';
import '../../core/localization/language_manager.dart';
import '../../core/storage/preferences_manager.dart';

/// TR: KUBBE V4 Elite Settings Panel Widget'ı
/// EN: KUBBE V4 Elite Settings Panel Widget
/// TR: One UI tarzı gruplandırma ve 32dp radius'lu kartlar
/// EN: One UI style grouping and 32dp radius cards
/// TR: Switch kontrolleri ve ayar yönetimi
/// EN: Switch controls and settings management
/// TR: V4 estetiği ve Sy-OS design language
/// EN: V4 aesthetics and Sy-OS design language
class EliteSettingsScreen extends ConsumerStatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const EliteSettingsScreen({super.key});

  @override
  ConsumerState<EliteSettingsScreen> createState() =>
      _EliteSettingsScreenState();
}

class _EliteSettingsScreenState extends ConsumerState<EliteSettingsScreen>
    with TickerProviderStateMixin {
  // TR: Animation controller
  // EN: Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // TR: Animation controller'ı başlat
    // EN: Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // TR: Fade animasyonu
    // EN: Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // TR: Animation'ı başlat
    // EN: Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TR: Preferences ve language manager
    // EN: Preferences and language manager
    final preferences = ref.watch(preferencesStateProvider);
    final languageManager = ref.read(languageManagerProvider);
    final prefsManager = PreferencesManager();

    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'Ayarlar',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // TR: Arka plan
        // EN: Background
        backgroundColor: KubbeTheme.kubbeIndigo,
        // TR: Gölge kaldır
        // EN: Remove shadow
        elevation: 0,
      ),

      // TR: Gövde
      // EN: Body
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // TR: Gradient arka plan
        // EN: Gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              KubbeTheme.kubbeIndigo,
              KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // TR: İçerik
        // EN: Content
        child: SafeArea(
          // TR: Ana içerik
          // EN: Main content
          child: SingleChildScrollView(
            // TR: Padding
            // EN: Padding
            padding: const EdgeInsets.all(16.0),
            // TR: Fade animasyonu
            // EN: Fade animation
            child: FadeTransition(
              opacity: _fadeAnimation,
              // TR: İçerik
              // EN: Content
              child: Column(
                // TR: Ana içerik
                // EN: Main content
                children: [
                  // TR: Bildirimler Kartı
                  // EN: Notifications Card
                  _buildNotificationsCard(preferences, prefsManager),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(height: 16.0),

                  // TR: Tema Kartı
                  // EN: Theme Card
                  _buildThemeCard(preferences, prefsManager),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(height: 16.0),

                  // TR: Dil Kartı
                  // EN: Language Card
                  _buildLanguageCard(languageManager, prefsManager),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(height: 16.0),

                  // TR: Diğer Ayarlar Kartı
                  // EN: Other Settings Card
                  _buildOtherSettingsCard(preferences, prefsManager),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(height: 32.0),

                  // TR: Versiyon Bilgisi
                  // EN: Version Information
                  _buildVersionInfo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TR: Bildirimler Kartı oluştur
  // EN: Build Notifications Card
  Widget _buildNotificationsCard(
    PreferencesState preferences,
    PreferencesManager prefsManager,
  ) {
    return Container(
      width: double.infinity,
      // TR: Kart dekorasyonu
      // EN: Card decoration
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(32.0),
        // TR: Beyaz arka plan
        // EN: White background
        color: Colors.white,
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      // TR: Kart içeriği
      // EN: Card content
      child: Padding(
        // TR: Padding
        // EN: Padding
        padding: const EdgeInsets.all(20.0),
        // TR: İçerik
        // EN: Content
        child: Column(
          // TR: Ana içerik
          // EN: Main content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TR: Başlık
            // EN: Title
            Row(
              // TR: MainAxisAlignment
              // EN: MainAxisAlignment
              children: [
                // TR: İkon
                // EN: Icon
                const Icon(
                  Icons.notifications,
                  color: KubbeTheme.kubbeIndigo,
                  size: 24,
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(width: 12.0),

                // TR: Başlık metni
                // EN: Title text
                Text(
                  'Bildirimler',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                ),
              ],
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 16.0),

            // TR: Ezan Bildirimleri
            // EN: Adhan Notifications
            _buildSwitchItem(
              'Ezan Bildirimleri',
              'Namaz vakitlerinde ezan bildirimi',
              preferences.prayerNotificationsEnabled,
              (value) {
                // TR: Titreşim ver
                // EN: Give haptic feedback
                HapticUtils.lightImpact();
                // TR: Ayarı güncelle
                // EN: Update setting
                prefsManager.setPrayerNotificationsEnabled(value);
              },
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 12.0),

            // TR: Namaz Hatırlatıcı
            // EN: Prayer Reminder
            _buildSwitchItem(
              'Namaz Hatırlatıcı',
              'Namaz vakitlerinden 15 dakika önce hatırlat',
              preferences.dailyNotificationsEnabled,
              (value) {
                // TR: Titreşim ver
                // EN: Give haptic feedback
                HapticUtils.lightImpact();
                // TR: Ayarı güncelle
                // EN: Update setting
                prefsManager.setDailyNotificationsEnabled(value);
              },
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 12.0),

            // TR: Zikir Hatırlatıcı
            // EN: Dhikr Reminder
            _buildSwitchItem(
              'Zikir Hatırlatıcı',
              'Günlük zikir hedefi hatırlatıcı',
              preferences.zikirNotificationsEnabled,
              (value) {
                // TR: Titreşim ver
                // EN: Give haptic feedback
                HapticUtils.lightImpact();
                // TR: Ayarı güncelle
                // EN: Update setting
                prefsManager.setZikirNotificationsEnabled(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  // TR: Tema Kartı oluştur
  // EN: Build Theme Card
  Widget _buildThemeCard(
    PreferencesState preferences,
    PreferencesManager prefsManager,
  ) {
    return Container(
      width: double.infinity,
      // TR: Kart dekorasyonu
      // EN: Card decoration
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(32.0),
        // TR: Beyaz arka plan
        // EN: White background
        color: Colors.white,
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      // TR: Kart içeriği
      // EN: Card content
      child: Padding(
        // TR: Padding
        // EN: Padding
        padding: const EdgeInsets.all(20.0),
        // TR: İçerik
        // EN: Content
        child: Column(
          // TR: Ana içerik
          // EN: Main content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TR: Başlık
            // EN: Title
            Row(
              // TR: MainAxisAlignment
              // EN: MainAxisAlignment
              children: [
                // TR: İkon
                // EN: Icon
                const Icon(
                  Icons.palette,
                  color: KubbeTheme.kubbeIndigo,
                  size: 24,
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(width: 12.0),

                // TR: Başlık metni
                // EN: Title text
                Text(
                  'Tema',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                ),
              ],
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 16.0),

            // TR: Tema seçenekleri
            // EN: Theme options
            Row(
              // TR: MainAxisAlignment
              // EN: MainAxisAlignment
              children: [
                // TR: Light tema
                // EN: Light theme
                _buildThemeOption(
                  'Light',
                  'Açık',
                  Icons.light_mode,
                  preferences.themeMode == ThemeMode.light,
                  () {
                    // TR: Titreşim ver
                    // EN: Give haptic feedback
                    HapticUtils.lightImpact();
                    // TR: Temayı ayarla
                    // EN: Set theme
                    prefsManager.setTheme(false);
                  },
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(width: 12.0),

                // TR: Dark tema
                // EN: Dark theme
                _buildThemeOption(
                  'Dark',
                  'Koyu',
                  Icons.dark_mode,
                  preferences.themeMode == ThemeMode.dark,
                  () {
                    // TR: Titreşim ver
                    // EN: Give haptic feedback
                    HapticUtils.lightImpact();
                    // TR: Temayı ayarla
                    // EN: Set theme
                    prefsManager.setTheme(true);
                  },
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(width: 12.0),

                // TR: Amber tema
                // EN: Amber theme
                _buildThemeOption(
                  'Amber',
                  'Amber',
                  Icons.nightlight,
                  preferences.isAmberMode,
                  () {
                    // TR: Titreşim ver
                    // EN: Give haptic feedback
                    HapticUtils.lightImpact();
                    // TR: Amber modu ayarla
                    // EN: Set amber mode
                    prefsManager.setAmberMode(!preferences.isAmberMode);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TR: Dil Kartı oluştur
  // EN: Build Language Card
  Widget _buildLanguageCard(
    LanguageManager languageManager,
    PreferencesManager prefsManager,
  ) {
    return Container(
      width: double.infinity,
      // TR: Kart dekorasyonu
      // EN: Card decoration
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(32.0),
        // TR: Beyaz arka plan
        // EN: White background
        color: Colors.white,
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      // TR: Kart içeriği
      // EN: Card content
      child: Padding(
        // TR: Padding
        // EN: Padding
        padding: const EdgeInsets.all(20.0),
        // TR: İçerik
        // EN: Content
        child: Column(
          // TR: Ana içerik
          // EN: Main content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TR: Başlık
            // EN: Title
            Row(
              // TR: MainAxisAlignment
              // EN: MainAxisAlignment
              children: [
                // TR: İkon
                // EN: Icon
                const Icon(
                  Icons.language,
                  color: KubbeTheme.kubbeIndigo,
                  size: 24,
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(width: 12.0),

                // TR: Başlık metni
                // EN: Title text
                Text(
                  'Dil Seçimi',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                ),
              ],
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 16.0),

            // TR: Dil seçimi
            // EN: Language selection
            GestureDetector(
              // TR: Dokunma
              // EN: On tap
              onTap: () {
                // TR: Dil seçim dialog'u göster
                // EN: Show language selection dialog
                _showLanguageSelectionDialog(languageManager, prefsManager);
              },
              // TR: Dil seçimi alanı
              // EN: Language selection area
              child: Container(
                width: double.infinity,
                // TR: Padding
                // EN: Padding
                padding: const EdgeInsets.all(16.0),
                // TR: Dekorasyon
                // EN: Decoration
                decoration: BoxDecoration(
                  // TR: 16dp radius
                  // EN: 16dp radius
                  borderRadius: BorderRadius.circular(16.0),
                  // TR: Kenar
                  // EN: Border
                  border: Border.all(
                    color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                // TR: İçerik
                // EN: Content
                child: Row(
                  // TR: MainAxisAlignment
                  // EN: MainAxisAlignment
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TR: Dil bilgisi
                    // EN: Language info
                    Text(
                      languageManager
                          .getLanguageName(languageManager.currentLanguage),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),

                    // TR: Ok ikonu
                    // EN: Arrow icon
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: KubbeTheme.kubbeIndigo,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TR: Diğer Ayarlar Kartı oluştur
  // EN: Build Other Settings Card
  Widget _buildOtherSettingsCard(
    PreferencesState preferences,
    PreferencesManager prefsManager,
  ) {
    return Container(
      width: double.infinity,
      // TR: Kart dekorasyonu
      // EN: Card decoration
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(32.0),
        // TR: Beyaz arka plan
        // EN: White background
        color: Colors.white,
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      // TR: Kart içeriği
      // EN: Card content
      child: Padding(
        // TR: Padding
        // EN: Padding
        padding: const EdgeInsets.all(20.0),
        // TR: İçerik
        // EN: Content
        child: Column(
          // TR: Ana içerik
          // EN: Main content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TR: Başlık
            // EN: Title
            Row(
              // TR: MainAxisAlignment
              // EN: MainAxisAlignment
              children: [
                // TR: İkon
                // EN: Icon
                const Icon(
                  Icons.more_horiz,
                  color: KubbeTheme.kubbeIndigo,
                  size: 24,
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(width: 12.0),

                // TR: Başlık metni
                // EN: Title text
                Text(
                  'Diğer Ayarlar',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                ),
              ],
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 16.0),

            // TR: Font boyutu
            // EN: Font size
            _buildSliderItem(
              'Font Boyutu',
              'Metin boyutunu ayarla',
              preferences.fontSize,
              (value) {
                // TR: Ayarı güncelle
                // EN: Update setting
                prefsManager.setFontSize(value);
              },
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 12.0),

            // TR: Sesler
            // EN: Sounds
            _buildSwitchItem(
              'Sesler',
              'Bildirim ve etkileşim sesleri',
              preferences.soundEnabled,
              (value) {
                // TR: Titreşim ver
                // EN: Give haptic feedback
                HapticUtils.lightImpact();
                // TR: Ayarı güncelle
                // EN: Update setting
                prefsManager.setSoundEnabled(value);
              },
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 12.0),

            // TR: Titreşimler
            // EN: Vibrations
            _buildSwitchItem(
              'Titreşimler',
              'Etkileşim titreşimleri',
              preferences.vibrationEnabled,
              (value) {
                // TR: Titreşim ver
                // EN: Give haptic feedback
                HapticUtils.lightImpact();
                // TR: Ayarı güncelle
                // EN: Update setting
                prefsManager.setVibrationEnabled(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  // TR: Switch öğesi oluştur
  // EN: Build switch item
  Widget _buildSwitchItem(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      // TR: MainAxisAlignment
      // EN: MainAxisAlignment
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // TR: CrossAxisAlignment
      // EN: CrossAxisAlignment
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // TR: Metin alanı
        // EN: Text area
        Expanded(
          // TR: Metin
          // EN: Text
          child: Column(
            // TR: Ana içerik
            // EN: Main content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TR: Başlık
              // EN: Title
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              // TR: Alt başlık
              // EN: Subtitle
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        // TR: Switch
        // EN: Switch
        Switch(
          // TR: Değer
          // EN: Value
          value: value,
          // TR: Değişim callback'i
          // EN: On changed callback
          onChanged: onChanged,
          // TR: Aktif renk
          // EN: Active color
          activeThumbColor: KubbeTheme.kubbeIndigo,
          // TR: Track renk
          // EN: Track color
          activeTrackColor: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  // TR: Tema seçeneği oluştur
  // EN: Build theme option
  Widget _buildThemeOption(
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      // TR: Dokunma
      // EN: On tap
      onTap: onTap,
      // TR: Seçenek
      // EN: Option
      child: Container(
        // TR: Padding
        // EN: Padding
        padding: const EdgeInsets.all(8.0),
        // TR: Dekorasyon
        // EN: Decoration
        decoration: BoxDecoration(
          // TR: 16dp radius
          // EN: 16dp radius
          borderRadius: BorderRadius.circular(16.0),
          // TR: Kenar
          // EN: Border
          border: Border.all(
            color: isSelected
                ? KubbeTheme.kubbeIndigo
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          // TR: Arka plan
          // EN: Background
          color: isSelected
              ? KubbeTheme.kubbeIndigo.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        // TR: İçerik
        // EN: Content
        child: Column(
          // TR: Ana içerik
          // EN: Main content
          children: [
            // TR: İkon
            // EN: Icon
            Icon(
              icon,
              color: isSelected ? KubbeTheme.kubbeIndigo : Colors.grey,
              size: 24,
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 4.0),

            // TR: Başlık
            // EN: Title
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? KubbeTheme.kubbeIndigo : Colors.grey,
              ),
            ),

            // TR: Alt başlık
            // EN: Subtitle
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: isSelected
                    ? KubbeTheme.kubbeIndigo.withValues(alpha: 0.7)
                    : Colors.grey.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TR: Slider öğesi oluştur
  // EN: Build slider item
  Widget _buildSliderItem(
    String title,
    String subtitle,
    double value,
    Function(double) onChanged,
  ) {
    return Column(
      // TR: Ana içerik
      // EN: Main content
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TR: Başlık ve değer
        // EN: Title and value
        Row(
          // TR: MainAxisAlignment
          // EN: MainAxisAlignment
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TR: Başlık
            // EN: Title
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            // TR: Değer
            // EN: Value
            Text(
              '${value.toInt()}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: KubbeTheme.kubbeIndigo,
              ),
            ),
          ],
        ),

        // TR: Alt başlık
        // EN: Subtitle
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),

        // TR: Boşluk
        // EN: Spacer
        const SizedBox(height: 8.0),

        // TR: Slider
        // EN: Slider
        Slider(
          // TR: Değer
          // EN: Value
          value: value,
          // TR: Minimum değer
          // EN: Minimum value
          min: 12.0,
          // TR: Maksimum değer
          // EN: Maximum value
          max: 24.0,
          // TR: Bölümler
          // EN: Divisions
          divisions: 12,
          // TR: Değişim callback'i
          // EN: On changed callback
          onChanged: onChanged,
          // TR: Aktif renk
          // EN: Active color
          thumbColor: KubbeTheme.kubbeIndigo,
          // TR: Pasif renk
          // EN: Inactive color
          inactiveColor: Colors.grey.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  // TR: Versiyon bilgisini oluştur
  // EN: Build version information
  Widget _buildVersionInfo() {
    return Container(
      width: double.infinity,
      // TR: Padding
      // EN: Padding
      padding: const EdgeInsets.all(20.0),
      // TR: İçerik
      // EN: Content
      child: Column(
        // TR: Ana içerik
        // EN: Main content
        children: [
          // TR: Logo
          // EN: Logo
          Container(
            width: 60,
            height: 60,
            // TR: Dekorasyon
            // EN: Decoration
            decoration: BoxDecoration(
              // TR: Gradient arka plan
              // EN: Gradient background
              gradient: const LinearGradient(
                colors: [
                  KubbeTheme.kubbeIndigo,
                  KubbeTheme.kubbeIndigo,
                ],
              ),
              // TR: 30dp radius
              // EN: 30dp radius
              borderRadius: BorderRadius.circular(30.0),
            ),
            // TR: Logo içeriği
            // EN: Logo content
            child: const Icon(
              Icons.mosque,
              color: Colors.white,
              size: 30,
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 16.0),

          // TR: Uygulama adı
          // EN: App name
          Text(
            'KUBBE',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // TR: Versiyon
          // EN: Version
          Text(
            'v4.0.0',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 8.0),

          // TR: İmza
          // EN: Signature
          Text(
            'Sygrad © 2024',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 4.0),

          // TR: Slogan
          // EN: Slogan
          Text(
            'Elite Islamic Lifestyle',
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // TR: Dil seçim dialog'u göster
  // EN: Show language selection dialog
  void _showLanguageSelectionDialog(
    LanguageManager languageManager,
    PreferencesManager prefsManager,
  ) {
    showDialog(
      // TR: Dialog
      // EN: Dialog
      context: context,
      builder: (BuildContext context) {
        // TR: AlertDialog
        // EN: AlertDialog
        return AlertDialog(
          // TR: Başlık
          // EN: Title
          title: Text(
            'Dil Seçimi',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),
          // TR: İçerik
          // EN: Content
          content: SizedBox(
            // TR: Boyut
            // EN: Size
            width: double.maxFinite,
            height: 300,
            // TR: İçerik
            // EN: Content
            child: ListView.builder(
              // TR: Eleman sayısı
              // EN: Item count
              itemCount: languageManager.supportedLanguages.length,
              // TR: Builder
              // EN: Builder
              itemBuilder: (context, index) {
                // TR: Dil kodu ve adı
                // EN: Language code and name
                final entry =
                    languageManager.supportedLanguages.entries.elementAt(index);
                final languageCode = entry.key;
                final languageName = entry.value;
                final isSelected =
                    languageManager.currentLanguage == languageCode;

                // TR: Dil öğesi
                // EN: Language item
                return ListTile(
                  // TR: Başlık
                  // EN: Title
                  title: Text(
                    languageName,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color:
                          isSelected ? KubbeTheme.kubbeIndigo : Colors.black87,
                    ),
                  ),
                  // TR: Alt başlık
                  // EN: Subtitle
                  subtitle: Text(
                    languageCode.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  // TR: İkon
                  // EN: Icon
                  leading: Icon(
                    Icons.language,
                    color: isSelected ? KubbeTheme.kubbeIndigo : Colors.grey,
                  ),
                  // TR: Seçim ikonu
                  // EN: Selection icon
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: KubbeTheme.kubbeIndigo,
                        )
                      : null,
                  // TR: Dokunma
                  // EN: On tap
                  onTap: () {
                    // TR: Dil değiştir
                    // EN: Change language
                    languageManager.setLanguage(languageCode);
                    prefsManager.setLanguage(languageCode);

                    // TR: Dialog'u kapat
                    // EN: Close dialog
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          // TR: Butonlar
          // EN: Actions
          actions: [
            // TR: Kapat butonu
            // EN: Close button
            TextButton(
              // TR: Metin
              // EN: Text
              onPressed: () {
                // TR: Dialog'u kapat
                // EN: Close dialog
                Navigator.of(context).pop();
              },
              // TR: Stil
              // EN: Style
              style: TextButton.styleFrom(
                // TR: Metin rengi
                // EN: Text color
                foregroundColor: KubbeTheme.kubbeIndigo,
              ),
              // TR: Metin
              // EN: Text
              child: Text(
                'Kapat',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
