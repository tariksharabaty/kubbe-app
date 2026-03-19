// TR: KUBBE V4 Elite Settings Panel - V4 standartları
// EN: KUBBE V4 Elite Settings Panel - V4 standards
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Liste yapısı (ListTile): 32dp radius'lu kartlar içinde gruplandırılmış ayarlar.
// EN: List structure (ListTile): Settings grouped in 32dp radius cards.
// TR: TEMA SEÇİCİ: Light/Dark/Amber (V1'deki o turuncu mod) geçişlerini 'settingsProvider' üzerinden yap.
// EN: THEME SELECTOR: Make Light/Dark/Amber (that orange mode from V1) transitions through 'settingsProvider'.
// TR: DİL SEÇİMİ: 14 dili destekleyen (LanguageManager logic) şık bir BottomSheet aç.
// EN: LANGUAGE SELECTION: Open a stylish BottomSheet supporting 14 languages (LanguageManager logic).
// TR: BİLDİRİM YÖNETİMİ: Ezan vakti bildirimlerini açma/kapama switchleri.
// EN: NOTIFICATION MANAGEMENT: Switches to turn prayer time notifications on/off.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/storage/preferences_manager.dart';

/// TR: KUBBE V4 Elite Settings Panel Sınıfı
/// EN: KUBBE V4 Elite Settings Panel Class
/// TR: 32dp radius'lu kartlar ve gruplandırılmış ayarlar
/// EN: 32dp radius cards and grouped settings
/// TR: Tema seçici, dil seçimi ve bildirim yönetimi
/// EN: Theme selector, language selection and notification management
/// TR: V4 estetiği ve Sy-OS design language
/// EN: V4 aesthetics and Sy-OS design language
class EliteSettingsScreen extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const EliteSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TR: Preferences state ve manager
    // EN: Preferences state and manager
    final preferencesState = ref.watch(preferencesStateProvider);

    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'Ayarlar',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        // TR: Arka plan
        // EN: Background
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // TR: Gölge kaldır
        // EN: Remove shadow
        elevation: 0,
      ),

      // TR: Body
      // EN: Body
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
        // TR: Ayar listesi
        // EN: Settings list
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // TR: Tema Ayarları
            // EN: Theme Settings
            _buildThemeSection(context, ref, preferencesState),

            // TR: Dil Ayarları
            // EN: Language Settings
            _buildLanguageSection(context, ref, preferencesState),

            // TR: Bildirim Ayarları
            // EN: Notification Settings
            _buildNotificationSection(context, ref, preferencesState),

            // TR: Görünüm Ayarları
            // EN: Appearance Settings
            _buildAppearanceSection(context, ref, preferencesState),

            // TR: Diğer Ayarlar
            // EN: Other Settings
            _buildOtherSection(context, ref, preferencesState),
          ],
        ),
      ),
    );
  }

  // TR: Tema bölümü oluştur
  // EN: Build theme section
  Widget _buildThemeSection(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    return _buildSettingsSection(
      context,
      'Tema',
      'Uygulama görünümünü özelleştir',
      Icons.palette,
      KubbeTheme.kubbeIndigo,
      [
        // TR: Tema seçici
        // EN: Theme selector
        _buildThemeSelector(context, ref, preferencesState),
        // TR: Amber modu
        // EN: Amber mode
        _buildAmberModeToggle(context, ref, preferencesState),
      ],
    );
  }

  // TR: Dil bölümü oluştur
  // EN: Build language section
  Widget _buildLanguageSection(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    return _buildSettingsSection(
      context,
      'Dil',
      'Uygulama dilini seç',
      Icons.language,
      const Color(0xFF2196F3), // TR: Mavi // EN: Blue
      [
        // TR: Dil seçimi
        // EN: Language selection
        _buildLanguageSelector(context, ref, preferencesState),
      ],
    );
  }

  // TR: Bildirim bölümü oluştur
  // EN: Build notification section
  Widget _buildNotificationSection(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    return _buildSettingsSection(
      context,
      'Bildirimler',
      'Bildirim tercihlerini yönet',
      Icons.notifications,
      const Color(0xFF4CAF50), // TR: Yeşil // EN: Green
      [
        // TR: Ezan bildirimleri
        // EN: Prayer notifications
        _buildPrayerNotificationsToggle(context, ref, preferencesState),
        // TR: Günlük bildirimleri
        // EN: Daily notifications
        _buildDailyNotificationsToggle(context, ref, preferencesState),
        // TR: Zikir bildirimleri
        // EN: Zikir notifications
        _buildZikirNotificationsToggle(context, ref, preferencesState),
      ],
    );
  }

  // TR: Görünüm bölümü oluştur
  // EN: Build appearance section
  Widget _buildAppearanceSection(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    return _buildSettingsSection(
      context,
      'Görünüm',
      'Görünüm ayarlarını özelleştir',
      Icons.visibility,
      const Color(0xFF9C27B0), // TR: Mor // EN: Purple
      [
        // TR: Font boyutu
        // EN: Font size
        _buildFontSizeSelector(context, ref, preferencesState),
        // TR: Kart stili
        // EN: Card style
        _buildCardStyleToggle(context, ref, preferencesState),
      ],
    );
  }

  // TR: Diğer bölümü oluştur
  // EN: Build other section
  Widget _buildOtherSection(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    return _buildSettingsSection(
      context,
      'Diğer',
      'Diğer ayarlar ve bilgiler',
      Icons.more_horiz,
      const Color(0xFFFF9800), // TR: Turuncu // EN: Orange
      [
        // TR: Hakkında
        // EN: About
        _buildAboutItem(context, ref),
        // TR: Gizlilik politikası
        // EN: Privacy policy
        _buildPrivacyPolicyItem(context, ref),
        // TR: Verileri sıfırla
        // EN: Reset data
        _buildResetDataItem(context, ref),
      ],
    );
  }

  // TR: Ayarlar bölümü oluştur
  // EN: Build settings section
  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      // TR: Bölüm container
      // EN: Section container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TR: Bölüm başlığı
          // EN: Section header
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            // TR: Başlık satırı
            // EN: Header row
            child: Row(
              children: [
                // TR: İkon
                // EN: Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    // TR: Yuvarlak
                    // EN: Circle
                    shape: BoxShape.circle,
                    // TR: Gradient arka plan
                    // EN: Gradient background
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  // TR: İkon içeriği
                  // EN: Icon content
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(width: 12.0),

                // TR: Başlık metinleri
                // EN: Header texts
                Expanded(
                  // TR: Başlık içeriği
                  // EN: Header content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TR: Başlık
                      // EN: Title
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),

                      // TR: Alt başlık
                      // EN: Subtitle
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // TR: Ayar kartları
          // EN: Settings cards
          ...children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                // TR: Ayar kartı
                // EN: Settings card
                child: child,
              )),
        ],
      ),
    );
  }

  // TR: Tema seçici oluştur
  // EN: Build theme selector
  Widget _buildThemeSelector(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // TR: 32dp radius - Sy-OS standartı
        // EN: 32dp radius - Sy-OS standard
        borderRadius: BorderRadius.circular(32.0),
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withValues(alpha: 0.95),
          ],
        ),
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      // TR: Tema seçici içeriği
      // EN: Theme selector content
      child: Column(
        children: [
          // TR: Tema seçimi başlığı
          // EN: Theme selection title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TR: Başlık
              // EN: Title
              Text(
                'Tema',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: KubbeTheme.kubbeIndigo,
                ),
              ),

              // TR: Mevcut tema
              // EN: Current theme
              Text(
                _getThemeName(preferencesState.themeMode),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
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
            children: [
              // TR: Light tema
              // EN: Light theme
              _buildThemeOption(
                context,
                ref,
                'Açık',
                ThemeMode.light,
                Icons.light_mode,
                preferencesState.themeMode == ThemeMode.light,
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(width: 12.0),

              // TR: Dark tema
              // EN: Dark theme
              _buildThemeOption(
                context,
                ref,
                'Koyu',
                ThemeMode.dark,
                Icons.dark_mode,
                preferencesState.themeMode == ThemeMode.dark,
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(width: 12.0),

              // TR: Amber tema
              // EN: Amber theme
              _buildThemeOption(
                context,
                ref,
                'Amber',
                ThemeMode
                    .system, // TR: V1'deki turuncu mod // EN: Orange mode from V1
                Icons.nights_stay,
                preferencesState.isAmberMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TR: Tema seçeneği oluştur
  // EN: Build theme option
  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    String title,
    ThemeMode themeMode,
    IconData icon,
    bool isSelected,
  ) {
    final prefsManager = PreferencesManager();
    return Expanded(
      // TR: Tema seçeneği
      // EN: Theme option
      child: GestureDetector(
        onTap: () {
          // TR: Haptic feedback
          // EN: Haptic feedback
          HapticFeedback.lightImpact();

          // TR: Temayı değiştir
          // EN: Change theme
          if (themeMode == ThemeMode.system) {
            // TR: Amber modu
            // EN: Amber mode
            prefsManager.setAmberMode(!isSelected);
          } else {
            // TR: Normal tema
            // EN: Normal theme
            prefsManager.setTheme(themeMode == ThemeMode.dark);
          }
        },
        // TR: Seçenek container
        // EN: Option container
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            // TR: 16dp radius
            // EN: 16dp radius
            borderRadius: BorderRadius.circular(16.0),
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      KubbeTheme.kubbeIndigo,
                      KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Colors.grey.withValues(alpha: 0.1),
                      Colors.grey.withValues(alpha: 0.05),
                    ],
                  ),
            // TR: Kenar
            // EN: Border
            border: isSelected
                ? null
                : Border.all(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
          ),
          // TR: Seçenek içeriği
          // EN: Option content
          child: Column(
            children: [
              // TR: İkon
              // EN: Icon
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : Colors.grey.withValues(alpha: 0.7),
                size: 24,
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 8.0),

              // TR: Başlık
              // EN: Title
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : Colors.grey.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TR: Amber modu toggle oluştur
  // EN: Build amber mode toggle
  Widget _buildAmberModeToggle(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    final prefsManager = PreferencesManager();
    return _buildToggleItem(
      context,
      'Amber Modu',
      'Gece göz yormayan kehribar tema',
      Icons.nights_stay,
      preferencesState.isAmberMode,
      (value) => prefsManager.setAmberMode(value),
      const Color(0xFFFF8C00), // TR: Amber // EN: Amber
    );
  }

  // TR: Dil seçici oluştur
  // EN: Build language selector
  Widget _buildLanguageSelector(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    return _buildSettingsItem(
      context,
      'Dil',
      _getLanguageName(preferencesState.language),
      Icons.language,
      () => _showLanguageBottomSheet(context, ref),
      const Color(0xFF2196F3), // TR: Mavi // EN: Blue
    );
  }

  // TR: Ezan bildirimleri toggle oluştur
  // EN: Build prayer notifications toggle
  Widget _buildPrayerNotificationsToggle(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    final prefsManager = PreferencesManager();
    return _buildToggleItem(
      context,
      'Ezan Bildirimleri',
      'Namaz vakitlerinde bildirim gönder',
      Icons.notifications,
      preferencesState.prayerNotificationsEnabled,
      (value) => prefsManager.setPrayerNotificationsEnabled(value),
      const Color(0xFF4CAF50), // TR: Yeşil // EN: Green
    );
  }

  // TR: Günlük bildirimleri toggle oluştur
  // EN: Build daily notifications toggle
  Widget _buildDailyNotificationsToggle(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    final prefsManager = PreferencesManager();
    return _buildToggleItem(
      context,
      'Günlük Bildirimler',
      'Günlük ayet ve dua bildirimleri',
      Icons.today,
      preferencesState.dailyNotificationsEnabled,
      (value) => prefsManager.setDailyNotificationsEnabled(value),
      const Color(0xFF4CAF50), // TR: Yeşil // EN: Green
    );
  }

  // TR: Zikir bildirimleri toggle oluştur
  // EN: Build zikir notifications toggle
  Widget _buildZikirNotificationsToggle(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    final prefsManager = PreferencesManager();
    return _buildToggleItem(
      context,
      'Zikir Hatırlatıcı',
      'Zikir zamanlarında bildirim gönder',
      Icons.mosque,
      preferencesState.zikirNotificationsEnabled,
      (value) => prefsManager.setZikirNotificationsEnabled(value),
      const Color(0xFF4CAF50), // TR: Yeşil // EN: Green
    );
  }

  // TR: Font boyutu seçici oluştur
  // EN: Build font size selector
  Widget _buildFontSizeSelector(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    return _buildSettingsItem(
      context,
      'Font Boyutu',
      '${preferencesState.fontSize.toInt()}',
      Icons.text_fields,
      () => _showFontSizeBottomSheet(context, ref),
      const Color(0xFF9C27B0), // TR: Mor // EN: Purple
    );
  }

  // TR: Kart stili toggle oluştur
  // EN: Build card style toggle
  Widget _buildCardStyleToggle(
      BuildContext context, WidgetRef ref, PreferencesState preferencesState) {
    final prefsManager = PreferencesManager();
    return _buildToggleItem(
      context,
      'Kart Stili',
      'Kart görünümünü özelleştir',
      Icons.style,
      preferencesState.cardStyle,
      (value) => prefsManager.setCardStyle(value),
      const Color(0xFF9C27B0), // TR: Mor // EN: Purple
    );
  }

  // TR: Hakkında öğesi oluştur
  // EN: Build about item
  Widget _buildAboutItem(BuildContext context, WidgetRef ref) {
    return _buildSettingsItem(
      context,
      'Hakkında',
      'KUBBE V4.0.0',
      Icons.info,
      () => _showAboutDialog(context),
      const Color(0xFFFF9800), // TR: Turuncu // EN: Orange
    );
  }

  // TR: Gizlilik politikası öğesi oluştur
  // EN: Build privacy policy item
  Widget _buildPrivacyPolicyItem(BuildContext context, WidgetRef ref) {
    return _buildSettingsItem(
      context,
      'Gizlilik Politikası',
      'Veri koruma ve gizlilik',
      Icons.privacy_tip,
      () => _showPrivacyPolicy(context),
      const Color(0xFFFF9800), // TR: Turuncu // EN: Orange
    );
  }

  // TR: Verileri sıfırla öğesi oluştur
  // EN: Build reset data item
  Widget _buildResetDataItem(BuildContext context, WidgetRef ref) {
    return _buildSettingsItem(
      context,
      'Verileri Sıfırla',
      'Tüm ayarları sıfırla',
      Icons.refresh,
      () => _showResetDataDialog(context, ref),
      const Color(0xFFFF9800), // TR: Turuncu // EN: Orange
    );
  }

  // TR: Ayar öğesi oluştur
  // EN: Build settings item
  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
    Color color,
  ) {
    return GestureDetector(
      onTap: onTap,
      // TR: Ayar öğesi
      // EN: Settings item
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
              Colors.white,
              Colors.white.withValues(alpha: 0.95),
            ],
          ),
          // TR: Gölge
          // EN: Shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
              spreadRadius: 1,
            ),
          ],
        ),
        // TR: Ayar içeriği
        // EN: Settings content
        child: Row(
          children: [
            // TR: İkon
            // EN: Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                // TR: Yuvarlak
                // EN: Circle
                shape: BoxShape.circle,
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    color,
                    color.withValues(alpha: 0.8),
                  ],
                ),
              ),
              // TR: İkon içeriği
              // EN: Icon content
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(width: 16.0),

            // TR: Başlık ve değer
            // EN: Title and value
            Expanded(
              // TR: Başlık içeriği
              // EN: Title content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TR: Başlık
                  // EN: Title
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  // TR: Değer
                  // EN: Value
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            // TR: Ok ikonu
            // EN: Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // TR: Toggle öğesi oluştur
  // EN: Build toggle item
  Widget _buildToggleItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // TR: 32dp radius - Sy-OS standartı
        // EN: 32dp radius - Sy-OS standard
        borderRadius: BorderRadius.circular(32.0),
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withValues(alpha: 0.95),
          ],
        ),
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      // TR: Toggle içeriği
      // EN: Toggle content
      child: Row(
        children: [
          // TR: İkon
          // EN: Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              // TR: Yuvarlak
              // EN: Circle
              shape: BoxShape.circle,
              // TR: Gradient arka plan
              // EN: Gradient background
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withValues(alpha: 0.8),
                ],
              ),
            ),
            // TR: İkon içeriği
            // EN: Icon content
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(width: 16.0),

          // TR: Başlık ve alt başlık
          // EN: Title and subtitle
          Expanded(
            // TR: Başlık içeriği
            // EN: Title content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TR: Başlık
                // EN: Title
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                // TR: Alt başlık
                // EN: Subtitle
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // TR: Switch
          // EN: Switch
          Switch(
            value: value,
            onChanged: onChanged,
            // TR: Aktif renk
            // EN: Active color
            activeThumbColor: color,
            // TR: Pasif renk
            // EN: Inactive color
            inactiveThumbColor: Colors.grey,
            // TR: İkon
            // EN: Icon
            activeThumbImage: const AssetImage('assets/icons/moon.png'),
            inactiveThumbImage: const AssetImage('assets/icons/sun.png'),
          ),
        ],
      ),
    );
  }

  // TR: Tema adını al
  // EN: Get theme name
  String _getThemeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Açık';
      case ThemeMode.dark:
        return 'Koyu';
      case ThemeMode.system:
        return 'Sistem';
    }
  }

  // TR: Dil adını al
  // EN: Get language name
  String _getLanguageName(String language) {
    switch (language) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      case 'ru':
        return 'Русский';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'hi':
        return 'हिन्दी';
      case 'ur':
        return 'اردو';
      case 'fa':
        return 'فارسی';
      default:
        return 'Türkçe';
    }
  }

  // TR: Dil seçim bottom sheet'ini göster
  // EN: Show language selection bottom sheet
  void _showLanguageBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      // TR: Arka plan
      // EN: Background
      backgroundColor: Colors.transparent,
      // TR: Builder
      // EN: Builder
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            // TR: 32dp radius üst köşeler
            // EN: 32dp radius top corners
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withValues(alpha: 0.95),
              ],
            ),
          ),
          // TR: Dil listesi
          // EN: Language list
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TR: Başlık
              // EN: Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                // TR: Başlık metni
                // EN: Header text
                child: Text(
                  'Dil Seçimi',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // TR: Dil listesi
              // EN: Language list
              Container(
                height: 300,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                // TR: Dil seçenekleri
                // EN: Language options
                child: ListView(
                  children: [
                    'tr',
                    'en',
                    'ar',
                    'de',
                    'fr',
                    'es',
                    'ru',
                    'zh',
                    'ja',
                    'ko',
                    'hi',
                    'ur',
                    'fa',
                  ].map((language) {
                    return _buildLanguageOption(context, ref, language);
                  }).toList(),
                ),
              ),

              // TR: Alt boşluk
              // EN: Bottom padding
              const SizedBox(height: 20.0),
            ],
          ),
        );
      },
    );
  }

  // TR: Dil seçeneği oluştur
  // EN: Build language option
  Widget _buildLanguageOption(
      BuildContext context, WidgetRef ref, String language) {
    final preferencesState = ref.read(preferencesStateProvider);
    final prefsManager = PreferencesManager();
    final isSelected = preferencesState.language == language;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      // TR: Dil seçeneği
      // EN: Language option
      child: GestureDetector(
        onTap: () {
          // TR: Haptic feedback
          // EN: Haptic feedback
          HapticFeedback.lightImpact();

          // TR: Dili değiştir
          // EN: Change language
          prefsManager.setLanguage(language);

          // TR: Modal'ı kapat
          // EN: Close modal
          Navigator.of(context).pop();
        },
        // TR: Seçenek container
        // EN: Option container
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            // TR: 16dp radius
            // EN: 16dp radius
            borderRadius: BorderRadius.circular(16.0),
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      const Color(0xFF2196F3),
                      const Color(0xFF2196F3).withValues(alpha: 0.8),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Colors.grey.withValues(alpha: 0.1),
                      Colors.grey.withValues(alpha: 0.05),
                    ],
                  ),
            // TR: Kenar
            // EN: Border
            border: isSelected
                ? null
                : Border.all(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
          ),
          // TR: Seçenek içeriği
          // EN: Option content
          child: Row(
            children: [
              // TR: Dil bayrağı
              // EN: Language flag
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  // TR: Yuvarlak
                  // EN: Circle
                  shape: BoxShape.circle,
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2196F3),
                      Color(0xFF2196F3),
                    ],
                  ),
                ),
                // TR: Bayrak içeriği
                // EN: Flag content
                child: Center(
                  // TR: Dil kodu
                  // EN: Language code
                  child: Text(
                    language.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected ? const Color(0xFF2196F3) : Colors.white,
                    ),
                  ),
                ),
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(width: 16.0),

              // TR: Dil adı
              // EN: Language name
              Expanded(
                // TR: Dil metni
                // EN: Language text
                child: Text(
                  _getLanguageName(language),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),

              // TR: Seçim ikonu
              // EN: Selection icon
              if (isSelected)
                const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // TR: Font boyutu bottom sheet'ini göster
  // EN: Show font size bottom sheet
  void _showFontSizeBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      // TR: Arka plan
      // EN: Background
      backgroundColor: Colors.transparent,
      // TR: Builder
      // EN: Builder
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            // TR: 32dp radius üst köşeler
            // EN: 32dp radius top corners
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withValues(alpha: 0.95),
              ],
            ),
          ),
          // TR: Font boyutu seçici
          // EN: Font size selector
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TR: Başlık
              // EN: Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                // TR: Başlık metni
                // EN: Header text
                child: Text(
                  'Font Boyutu',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF9C27B0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // TR: Font boyutu seçenekleri
              // EN: Font size options
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                // TR: Font seçenekleri
                // EN: Font options
                child: Row(
                  children: [
                    'Küçük',
                    'Orta',
                    'Büyük',
                    'Çok Büyük',
                  ].map((size) {
                    return _buildFontSizeOption(context, ref, size);
                  }).toList(),
                ),
              ),

              // TR: Alt boşluk
              // EN: Bottom padding
              const SizedBox(height: 20.0),
            ],
          ),
        );
      },
    );
  }

  // TR: Font boyutu seçeneği oluştur
  // EN: Build font size option
  Widget _buildFontSizeOption(
      BuildContext context, WidgetRef ref, String size) {
    final preferencesState = ref.read(preferencesStateProvider);
    final prefsManager = PreferencesManager();
    final fontSize = preferencesState.fontSize;

    double sizeValue;
    switch (size) {
      case 'Küçük':
        sizeValue = 16.0;
        break;
      case 'Orta':
        sizeValue = 20.0;
        break;
      case 'Büyük':
        sizeValue = 24.0;
        break;
      case 'Çok Büyük':
        sizeValue = 28.0;
        break;
      default:
        sizeValue = 20.0;
    }

    final isSelected = fontSize == sizeValue;

    return Expanded(
      // TR: Font seçeneği
      // EN: Font option
      child: GestureDetector(
        onTap: () {
          // TR: Haptic feedback
          // EN: Haptic feedback
          HapticFeedback.lightImpact();

          // TR: Font boyutunu değiştir
          // EN: Change font size
          prefsManager.setFontSize(sizeValue);

          // TR: Modal'ı kapat
          // EN: Close modal
          Navigator.of(context).pop();
        },
        // TR: Seçenek container
        // EN: Option container
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          decoration: BoxDecoration(
            // TR: 16dp radius
            // EN: 16dp radius
            borderRadius: BorderRadius.circular(16.0),
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      const Color(0xFF9C27B0),
                      const Color(0xFF9C27B0).withValues(alpha: 0.8),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Colors.grey.withValues(alpha: 0.1),
                      Colors.grey.withValues(alpha: 0.05),
                    ],
                  ),
            // TR: Kenar
            // EN: Border
            border: isSelected
                ? null
                : Border.all(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
          ),
          // TR: Seçenek içeriği
          // EN: Option content
          child: Center(
            // TR: Font metni
            // EN: Font text
            child: Text(
              size,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TR: Hakkında dialog'u göster
  // EN: Show about dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      // TR: Builder
      // EN: Builder
      builder: (context) {
        return AlertDialog(
          // TR: Başlık
          // EN: Title
          title: Text(
            'Hakkında',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),
          // TR: İçerik
          // EN: Content
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TR: Logo
              // EN: Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  // TR: Yuvarlak
                  // EN: Circle
                  shape: BoxShape.circle,
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: LinearGradient(
                    colors: [
                      KubbeTheme.kubbeIndigo,
                      KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                // TR: Logo içeriği
                // EN: Logo content
                child: const Center(
                  // TR: Logo
                  // EN: Logo
                  child: Icon(
                    Icons.smart_toy_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 16.0),

              // TR: Bilgiler
              // EN: Information
              Text(
                'KUBBE V4.0.0\nSygrad Elite Islamic Lifestyle\n\n© 2026 Sygrad Technologies',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // TR: Eylemler
          // EN: Actions
          actions: [
            // TR: Tamam butonu
            // EN: OK button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              // TR: Buton metni
              // EN: Button text
              child: Text(
                'Tamam',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: KubbeTheme.kubbeIndigo,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // TR: Gizlilik politikası göster
  // EN: Show privacy policy
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      // TR: Builder
      // EN: Builder
      builder: (context) {
        return AlertDialog(
          // TR: Başlık
          // EN: Title
          title: Text(
            'Gizlilik Politikası',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),
          // TR: İçerik
          // EN: Content
          content: SingleChildScrollView(
            // TR: Gizlilik metni
            // EN: Privacy text
            child: Text(
              'KUBBE V4 Gizlilik Politikası\n\n'
              '1. Veri Toplama\n'
              'Uygulamamız, hizmetlerimizi sunmak için minimum düzeyde kişisel veri toplar.\n\n'
              '2. Veri Kullanımı\n'
              'Toplanan veriler sadece hizmet sunumu ve iyileştirme için kullanılır.\n\n'
              '3. Veri Güvenliği\n'
              'Tüm verileriniz end-to-end şifreleme ile korunur.\n\n'
              '4. Veri Paylaşımı\n'
              'Kişisel verileriniz hiçbir üçüncü parti ile paylaşılmaz.\n\n'
              '5. Kullanıcı Hakları\n'
              'Her zaman verilerinizi görüntüleme, düzenleme ve silme hakkınız vardır.',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
          // TR: Eylemler
          // EN: Actions
          actions: [
            // TR: Tamam butonu
            // EN: OK button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              // TR: Buton metni
              // EN: Button text
              child: Text(
                'Tamam',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: KubbeTheme.kubbeIndigo,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // TR: Veri sıfırlama dialog'u göster
  // EN: Show reset data dialog
  void _showResetDataDialog(BuildContext context, WidgetRef ref) {
    final prefsManager = PreferencesManager();
    showDialog(
      context: context,
      // TR: Builder
      // EN: Builder
      builder: (context) {
        return AlertDialog(
          // TR: Başlık
          // EN: Title
          title: Text(
            'Verileri Sıfırla',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          // TR: İçerik
          // EN: Content
          content: Text(
            'Tüm ayarlarınız sıfırlanacak. Bu işlem geri alınamaz.\n\nDevam etmek istediğinizden emin misiniz?',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          // TR: Eylemler
          // EN: Actions
          actions: [
            // TR: İptal butonu
            // EN: Cancel button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              // TR: Buton metni
              // EN: Button text
              child: Text(
                'İptal',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),

            // TR: Sıfırla butonu
            // EN: Reset button
            TextButton(
              onPressed: () async {
                // TR: Verileri sıfırla
                // EN: Reset data
                await prefsManager.setTheme(false);
                await prefsManager.setLanguage('tr');
                await prefsManager.setFontSize(20.0);
                await prefsManager.setPrayerNotificationsEnabled(true);
                await prefsManager.setDailyNotificationsEnabled(true);
                await prefsManager.setZikirNotificationsEnabled(true);
                await prefsManager.setCardStyle(true);

                // TR: Modal'ı kapat
                // EN: Close modal
                if (context.mounted) {
                  Navigator.of(context).pop();
                }

                // TR: Başarılı mesajı
                // EN: Success message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Tüm veriler başarıyla sıfırlandı.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text(
                'Sıfırla',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
