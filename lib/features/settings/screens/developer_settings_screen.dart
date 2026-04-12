import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/history_service.dart';

class DeveloperSettingsScreen extends StatefulWidget {
  const DeveloperSettingsScreen({super.key});

  @override
  State<DeveloperSettingsScreen> createState() => _DeveloperSettingsScreenState();
}

class _DeveloperSettingsScreenState extends State<DeveloperSettingsScreen> {
  bool _isScreenshotMode = false;
  bool _isStopTimeActive = false;

  @override
  void initState() {
    super.initState();
    _loadDevSettings();
  }

  Future<void> _loadDevSettings() async {
    final screenshot = await HistoryService.isScreenshotMode();
    final stopTime = await HistoryService.isStopTimeActive();
    setState(() {
      _isScreenshotMode = screenshot;
      _isStopTimeActive = stopTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hünkâr Paneli', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F2937),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildInfoCard(),
          const SizedBox(height: 24),
          _buildSectionHeader("Sistem Simülasyonu"),
          _buildDevTile(
            title: "Ekran Görüntüsü Modu",
            subtitle: "Sabit tarih ve verileri aktif eder",
            value: _isScreenshotMode,
            onChanged: (val) async {
              await HistoryService.setScreenshotMode(val);
              setState(() => _isScreenshotMode = val);
            },
          ),
          _buildDevTile(
            title: "Zamanı Durdur",
            subtitle: "Sayaçların ilerlemesini engeller",
            value: _isStopTimeActive,
            onChanged: (val) async {
              await HistoryService.setStopTimeActive(val);
              setState(() => _isStopTimeActive = val);
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("Hata Ayıklama"),
          _buildActionTile(
            title: "Logları Temizle",
            icon: Icons.delete_sweep_outlined,
            onTap: () => _showMsg("Loglar temizlendi."),
          ),
          _buildActionTile(
            title: "Geliştirici Modundan Çık",
            icon: Icons.exit_to_app,
            isDangerous: true,
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isDevModeUnlocked', false);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Bu paneldeki ayarlar uygulamanın normal işleyişini değiştirir. Dikkatli kullanınız.",
              style: GoogleFonts.inter(fontSize: 13, color: Colors.amber[900]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildDevTile({required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SwitchListTile(
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: 
const Color(0xFF4B0082),
      ),
    );
  }

  Widget _buildActionTile({required String title, required IconData icon, required VoidCallback onTap, bool isDangerous = false}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: isDangerous ? Colors.red : Colors.grey),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDangerous ? Colors.red : null)),
        onTap: onTap,
      ),
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }
}
