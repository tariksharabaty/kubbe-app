import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/islamic_audio_service.dart';
import 'package:flutter/services.dart';

/// [MusicSettingsScreen] Kullanıcı dostu müzik ayarları sayfası - User-friendly music settings page
class MusicSettingsScreen extends StatefulWidget {
  const MusicSettingsScreen({super.key});

  @override
  State<MusicSettingsScreen> createState() => _MusicSettingsScreenState();
}

class _MusicSettingsScreenState extends State<MusicSettingsScreen> {
  // [Ayarlar servis üzerinden yönetilecek - Settings managed through service]

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Müzik Ayarları', // Music Settings
          style: GoogleFonts.outfit(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // [Ses Kalitesi Bölümü - Audio Quality Section]
          _buildSettingsSection(
            context,
            'Ses ve Veri', // Audio and Data
            [
              ListenableBuilder(
                listenable: IslamicAudioService(),
                builder: (context, child) {
                  final audioService = IslamicAudioService();
                  final bool isHigh = audioService.quality == AudioQuality.highQuality;
                  return SwitchListTile(
                    value: isHigh,
                    onChanged: (val) {
                      HapticFeedback.selectionClick();
                      audioService.setQuality(val ? AudioQuality.highQuality : AudioQuality.standard);
                    },
                    secondary: Icon(Icons.high_quality_rounded, color: theme.colorScheme.primary),
                    title: Text('Yüksek Ses Kalitesi', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                      'Daha net ses, ancak hücresel veride daha fazla tüketim.', // Higher quality audio info
                      style: TextStyle(fontSize: 12),
                    ),
                    activeThumbColor: theme.colorScheme.primary,
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // [Oynatma ve Zamanlayıcı Bölümü - Playback and Timer Section]
          _buildSettingsSection(
            context,
            'Zamanlayıcılar', // Timers
            [
              ListTile(
                leading: Icon(Icons.timer_rounded, color: theme.colorScheme.primary),
                title: Text('Uyku Zamanlayıcısı', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                subtitle: const Text(
                  'Süre sonunda ses otomatik kapanır.', // Sleep timer info
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ayarlar', style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  ],
                ),
                onTap: () => _showSleepTimerPicker(context), // [Zamanlayıcı seçici - Timer picker]
              ),
            ],
          ),

          const SizedBox(height: 16),

          // [Bilgi Bölümü (Modülerlik için) - Info Section]
          _buildSettingsSection(
            context,
            'Bilgi', // Info
            [
              _buildSimpleTile(context, Icons.info_outline_rounded, 'Uygulama Sürümü', '1.2.0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
              letterSpacing: 1.2,
            ),
          ),
        ),
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSimpleTile(BuildContext context, IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  void _showSleepTimerPicker(BuildContext context) {
    final theme = Theme.of(context);
    final audioService = IslamicAudioService();

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Uyku Zamanlayıcısı', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...[15, 30, 45, 60].map((mins) => ListTile(
              title: Text('$mins Dakika', textAlign: TextAlign.center, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
              onTap: () {
                HapticFeedback.lightImpact();
                audioService.startSleepTimer(mins);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ses $mins dakika sonra kapanacak.')),
                );
              },
            )),
            ListTile(
              title: Text('İptal', textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.red)),
              onTap: () {
                audioService.startSleepTimer(0);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
