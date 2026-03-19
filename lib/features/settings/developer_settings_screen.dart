import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/utils/dev_tools.dart';

/// TR: KUBBE V4 Geliştirici Ayarları Ekranı
/// EN: KUBBE V4 Developer Settings Screen
/// TR: Ekran görüntüsü modu vb. geliştirme araçlarını içerir
/// EN: Contains development tools like screenshot mode, etc.
class DeveloperSettingsScreen extends ConsumerWidget {
  /// TR: Constructor
  /// EN: Constructor
  const DeveloperSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenshotMode = ref.watch(DevTools.screenshotModeProvider);

    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'Geliştirici Ayarları',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: KubbeTheme.kubbeIndigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // TR: Body
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // TR: Ekran Görüntüsü Modu Kartı
              // EN: Screenshot Mode Card
              _buildDevCard(
                title: 'Ekran Görüntüsü Modu',
                subtitle: 'Saat ve tarihi sabitler (03:35:25, 10 Mart 2026)',
                icon: Icons.screenshot,
                value: screenshotMode,
                onChanged: (value) {
                  HapticHelper.tokClick();
                  ref.read(DevTools.screenshotModeProvider.notifier).state = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TR: Geliştirici ayar kartı oluştur
  // EN: Build developer setting card
  Widget _buildDevCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: KubbeTheme.kubbeIndigo, size: 24),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                ),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: KubbeTheme.kubbeIndigo,
          ),
        ],
      ),
    );
  }
}
