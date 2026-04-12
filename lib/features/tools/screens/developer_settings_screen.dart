import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/services/history_service.dart';

class DeveloperSettingsScreen extends StatefulWidget {
  const DeveloperSettingsScreen({super.key});

  @override
  State<DeveloperSettingsScreen> createState() => _DeveloperSettingsScreenState();
}

class _DeveloperSettingsScreenState extends State<DeveloperSettingsScreen> {
  bool _isScreenshotMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final active = await HistoryService.isScreenshotMode();
    setState(() => _isScreenshotMode = active);
  }

  @override
  Widget build(BuildContext context) {
    const Color kubbePurple = Color(0xFF4B0082);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Geliştirici Ayarları", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(PhosphorIcons.caretLeft(), color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                SwitchListTile(
                  title: Text(
                    "Google Play Ekran Görüntüsü Modu",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Aktif edildiğinde tarih 10 Mart 2026'ya sabitlenir.",
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                  activeThumbColor: kubbePurple,
                  value: _isScreenshotMode,
                  onChanged: (value) async {
                    await HistoryService.setScreenshotMode(value);
                    setState(() => _isScreenshotMode = value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              "Seyyah'ın Gizli Kubbesi v1.0.0",
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
