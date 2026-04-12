import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/services/history_service.dart';
import 'developer_settings_screen.dart';
import 'theme_selection_screen.dart';
import '../../../core/state/theme_provider.dart';
import 'package:provider/provider.dart';

// [Genel Ayarlar Sayfası - General Settings Page]
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDevModeUnlocked = false;
  bool _isFastingModeActive = false;
  int _devTapCount = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final fasting = await HistoryService.isFastingModeActive();
    setState(() {
      _isDevModeUnlocked = prefs.getBool('isDevModeUnlocked') ?? false;
      _isFastingModeActive = fasting;
    });
  }

  void _handleTap() {
    setState(() {
      _devTapCount++;
      if (_devTapCount >= 7) {
        _devTapCount = 0;
        if (!_isDevModeUnlocked) {
          _showPinDialog();
        }
      }
    });
  }

  void _showPinDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Giriş Gerekli", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "PIN kodunu giriniz",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () async {
              if (controller.text == "444455") {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isDevModeUnlocked', true);
                if (context.mounted) {
                  setState(() => _isDevModeUnlocked = true);
                  Navigator.pop(context);
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hatalı PIN")));
                }
              }
            },
            child: const Text("Giriş"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final activeColor = themeProvider.currentTheme.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Ayarlar', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: activeColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        physics: const BouncingScrollPhysics(),
        children: [
          // 1. KONUM VE HESAPLAMA - LOCATION AND CALCULATION
          _buildSectionHeader('Konum ve Hesaplama', activeColor),
          _buildCardGroup([
            _buildOneUIActionTile(
              icon: PhosphorIcons.mapPin(),
              title: 'Konum Seçimi',
              subtitle: 'Şehir ve ülke ayarlarını değiştir',
              onTap: () => _showComingSoon('Konum seçimi ekranı yakında eklenecektir.'),
              activeColor: activeColor,
            ),
            _buildOneUIActionTile(
              icon: PhosphorIcons.mathOperations(),
              title: 'Hesaplama Yöntemi',
              subtitle: 'Diyanet İşleri Başkanlığı (Otomatik)',
              onTap: () => _showComingSoon('Türkiye ve dünya geneli için Diyanet usulü otomatik uygulanır.'),
              activeColor: activeColor,
            ),
          ]),

          const SizedBox(height: 24),

          // 2. GÖRÜNÜM VE DİL - APPEARANCE AND LANGUAGE
          _buildSectionHeader('Görünüm ve Dil', activeColor),
          _buildCardGroup([
            _buildOneUISwitchTile(
              icon: PhosphorIcons.moon(),
              title: 'Karanlık Tema',
              subtitle: 'Gece modunu aktif et',
              value: themeProvider.isDarkMode,
              onChanged: (val) => themeProvider.toggleDarkMode(val),
              activeColor: activeColor,
            ),
            _buildOneUIActionTile(
              icon: PhosphorIcons.palette(),
              title: 'Tema Galerisi',
              subtitle: 'Modern ve premium renk paletleri',
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const ThemeSelectionScreen())
              ),
              activeColor: activeColor,
            ),
            _buildOneUISwitchTile(
              icon: PhosphorIcons.timer(),
              title: 'Oruç / İftar Sayacı',
              subtitle: 'Ana sayfada geri sayımı aktif eder',
              value: _isFastingModeActive,
              onChanged: (val) async {
                await HistoryService.setFastingMode(val);
                setState(() => _isFastingModeActive = val);
              },
              activeColor: activeColor,
            ),
          ]),

          const SizedBox(height: 24),

          // 3. BİLDİRİMLER - NOTIFICATIONS
          _buildSectionHeader('Bildirimler', activeColor),
          _buildCardGroup([
            _buildOneUISwitchTile(
              icon: PhosphorIcons.bellRinging(),
              title: 'Vakit Bildirimleri',
              subtitle: 'Ezan vakitlerinde uyarı al',
              value: true,
              onChanged: (val) => _showComingSoon('Bildirim sistemi geliştirme aşamasındadır.'),
              activeColor: activeColor,
            ),
          ]),

          const SizedBox(height: 24),

          // 4. GELİŞTİRİCİ - DEVELOPER
          if (_isDevModeUnlocked) ...[
            _buildSectionHeader('Hünkâr Paneli', activeColor),
            _buildCardGroup([
              _buildActionTile(
                icon: PhosphorIcons.terminalWindow(),
                title: 'Geliştirici Ayarları',
                subtitle: 'Sistem simülasyonu ve loglar',
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const DeveloperSettingsScreen())
                ),
                activeColor: activeColor,
              ),
            ]),
            const SizedBox(height: 24),
          ],

          // 5. HAKKINDA - ABOUT
          _buildSectionHeader('Hakkında', activeColor),
          _buildCardGroup([
            _buildActionTile(
              icon: PhosphorIcons.info(),
              title: 'Kubbe Hakkında',
              subtitle: 'Kubbe v1.2.0 - Premium Edition',
              onTap: () {},
              activeColor: activeColor,
            ),
            _buildActionTile(
              icon: PhosphorIcons.heart(),
              title: 'Destek Ol',
              subtitle: 'Gelişime katkıda bulun',
              onTap: () => _showSupportDialog(),
              activeColor: activeColor,
            ),
          ]),

          const SizedBox(height: 40),
          
          // [Secret Developer Entry]
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _handleTap,
                child: Text(
                  "KUBBE",
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.withValues(alpha: 0.2),
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color activeColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 12),
      child: Text(
        title.toUpperCase(), 
        style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: activeColor.withValues(alpha: 0.5), letterSpacing: 1.5)
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildOneUISwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color activeColor,
  }) {
    final Color purple = activeColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: purple.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: purple, size: 22),
        ),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15, color: const Color(0xFF1F2937))),
        subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
        trailing: Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value, 
            onChanged: onChanged, 
            activeThumbColor: Colors.white,
            activeTrackColor: purple,
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[200],
            trackOutlineColor: WidgetStateProperty.resolveWith((states) => Colors.transparent),
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color activeColor,
    bool isDangerous = false,
  }) {
    final Color color = isDangerous ? Colors.red : activeColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15, color: isDangerous ? Colors.red : const Color(0xFF1F2937))),
        subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 20),
      ),
    );
  }

  Widget _buildOneUIActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    final Color purple = activeColor;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: purple.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: purple, size: 22),
      ),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15, color: const Color(0xFF1F2937))),
      subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 20),
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text("Kubbe'ye Destek Ol", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: const Text("Kubbe'nin inşasına katkıda bulunmak ve yeni özellikleri desteklemek için yakında ödeme altyapımız eklenecektir. İlginiz için teşekkür ederiz, seyyah."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Geri Dön")),
        ],
      ),
    );
  }

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF1F2937),
      )
    );
  }

}
