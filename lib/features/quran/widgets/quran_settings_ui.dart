import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/state/quran_settings_state.dart';
import '../../../core/services/quran_service.dart';
import '../../../shared/widgets/pulsing_loader.dart';

// [Okuma Ayarları Ekranı - Reading Settings Page]
class QuranSettingsPage extends StatelessWidget {
  const QuranSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC), // Çok açık, ferah arka plan - Ultra-light fresh background
      appBar: AppBar(
        title: Text(
          "Kur'an-ı Kerim Ayarları",
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4B0082),
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: SettingsContentWidget(), 
        ),
      ),
    );
  }
}

// [Ayarlar İçerik Widget'ı - Settings Content Widget]
class SettingsContentWidget extends StatelessWidget {
  const SettingsContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = QuranSettingsState();

    return ListenableBuilder(
      listenable: settings,
      builder: (context, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // [PREMIUM PURPLE HEADER - FIXED STATUS BAR BLEED]
              Container(
                width: double.infinity,
                color: const Color(0xFF4B0082),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Kur'an-ı Kerim Ayarları",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: "Okuma Kapsamı",
                icon: Icons.auto_stories_outlined,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildModeChip('Ayet', ReadingScope.ayah, settings),
                      const SizedBox(width: 8),
                      _buildModeChip('Sayfa', ReadingScope.page, settings),
                      const SizedBox(width: 8),
                      _buildModeChip('Cüz', ReadingScope.juz, settings),
                    ],
                  ),
                ),
              ),

            _buildSection(
              title: "Hafız Seçimi",
              icon: Icons.person_outline,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: QuranService.fetchReciters(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const PulsingLoader(size: 40);
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("Hafız listesi yüklenemedi.");
                  }
                  final reciters = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: settings.selectedReciterId,
                        isExpanded: true,
                        items: reciters.map((r) => DropdownMenuItem(
                          value: r['id'] as int,
                          child: Text(r['reciter_name'] ?? 'Bilinmeyen', style: const TextStyle(fontSize: 14)),
                        )).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            final r = reciters.firstWhere((e) => e['id'] == val);
                            settings.updateReciter(val, r['reciter_name']);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            if (settings.readingScope == ReadingScope.page)
              _buildSection(
                title: "Mushaf Yazı Tipi",
                icon: Icons.font_download_outlined,
                child: Column(
                  children: [
                    // Preview
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B0082).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(settings.mushafFont, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Font Grid
                    SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildFontCard('Kubbe', 'Amiri', settings),
                          _buildFontCard('Klasik', 'Scheherazade New', settings),
                          _buildFontCard('Medine', 'Lateef', settings),
                          _buildFontCard('Hafs', 'Noto Naskh Arabic', settings),
                          _buildFontCard('İndopak', 'Harmattan', settings),
                          _buildFontCard('Kemerli', 'Gulzar', settings),
                          _buildFontCard('Kufi', 'Reem Kufi', settings),
                          _buildFontCard('Ruqaa', 'Aref Ruqaa', settings),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            _buildSection(
              title: "Okuma Hızı (Otomatik)",
              icon: Icons.speed,
              child: Column(
                children: [
                   SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      showValueIndicator: ShowValueIndicator.always,
                      valueIndicatorColor: const Color(0xFF4B0082),
                    ),
                    child: Slider(
                      value: settings.autoScrollSpeed,
                      min: 0.25,
                      max: 10.0,
                      divisions: 39,
                      label: "${settings.autoScrollSpeed.toStringAsFixed(2)}x",
                      activeColor: const Color(0xFF4B0082),
                      onChanged: (val) => settings.updateAutoScrollSpeed(val),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("0.25x", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        Text("10.0x", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // [Strict Logic Rule: Mushaf modunda Meal/Tefsir/Latin ayarlarını gizle]
            if (settings.readingScope != ReadingScope.page)
              _buildSection(
                title: "Görünüm Katmanları",
                icon: Icons.layers_outlined,
                child: Column(
                  children: [
                    _buildLayerRow("Arapça", "arabic", settings.showArabic, settings.arabicFontSize, settings),
                    _buildLayerRow("Meali", "translation", settings.showTranslation, settings.translationFontSize, settings),
                    _buildLayerRow("Tefsir", "tafsir", settings.showTafsir, settings.tafsirFontSize, settings),
                    _buildLayerRow("Okunuş", "transliteration", settings.showTransliteration, settings.transliterationFontSize, settings),
                    _buildLayerRow("Kelime", "wordByWord", settings.showWordByWord, settings.wordByWordFontSize, settings),
                  ],
                ),
              ),

            // [Elite Font Selectors - Bypass conditional logic where required]
            if (settings.readingScope != ReadingScope.page)
              _buildFontSelectors(settings),
            const SizedBox(height: 40),
          ],
        ),
      );
    },
);
  }

  Widget _buildSection({required String title, required IconData icon, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF4B0082)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title, 
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF4B0082)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildModeChip(String label, ReadingScope scope, QuranSettingsState settings) {
    final isSelected = settings.readingScope == scope;
    return GestureDetector(
      onTap: () => settings.updateScope(scope),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4B0082) : const Color(0xFFF0F0FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF4B0082), fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFontCard(String label, String font, QuranSettingsState settings) {
    final isSelected = settings.mushafFont == font;
    return GestureDetector(
      onTap: () => settings.updateMushafFont(font),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4B0082).withOpacity(0.05) : Colors.transparent,
          border: Border.all(color: isSelected ? const Color(0xFF4B0082) : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("بِسْمِ", style: GoogleFonts.getFont(font, fontSize: 20)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerRow(String label, String key, bool isVisible, double fontSize, QuranSettingsState settings) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
            Switch(
              value: isVisible,
              activeColor: const Color(0xFF4B0082),
              onChanged: (val) => settings.toggleLayer(key, val),
            ),
          ],
        ),
        if (isVisible)
          Slider(
            value: fontSize,
            min: 12,
            max: 48,
            activeColor: const Color(0xFF4B0082).withOpacity(0.5),
            onChanged: (val) => settings.updateFontSize(key, val),
          ),
      ],
    );
  }

  // [Elite Font Selection Implementation - Forced Render Fix]
  Widget _buildFontSelectors(QuranSettingsState settings) {
    final List<String> arabicFontsList = ['Amiri', 'Uthmani', 'Lateef', 'Scheherazade New', 'Kubbe'];
    final List<String> turkishFontsList = ['Inter', 'Roboto', 'Open Sans', 'Lora'];

    return _buildSection(
      title: "Yazı Tipi Ayarları",
      icon: Icons.font_download_outlined,
      child: Column(
        children: [
          _buildSafeFontDropdown(
            label: "Arapça Font",
            currentValue: settings.arabicFont,
            fontList: arabicFontsList,
            onChanged: (val) => settings.updateArabicFont(val),
          ),
          const SizedBox(height: 12),
          _buildSafeFontDropdown(
            label: "Türkçe Font",
            currentValue: settings.turkishFont,
            fontList: turkishFontsList,
            onChanged: (val) => settings.updateTurkishFont(val),
          ),
        ],
      ),
    );
  }

  // [Bulletproof Font Dropdown Implementation]
  Widget _buildSafeFontDropdown({
    required String label,
    required String currentValue,
    required List<String> fontList,
    required Function(String) onChanged,
  }) {
    // Ensure current value is in the list, otherwise default to the first item (Value Mismatch Fix)
    final String safeValue = fontList.contains(currentValue) ? currentValue : fontList.first;

    return Row(
      children: [
        Expanded(
          child: Text(
            '$label:',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: safeValue,
              items: fontList.map((font) => DropdownMenuItem(
                value: font,
                child: Text(font, style: const TextStyle(fontSize: 14)),
              )).toList(),
              onChanged: (val) {
                if (val != null) {
                  onChanged(val); // Calls update functions that trigger notifyListeners()
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
