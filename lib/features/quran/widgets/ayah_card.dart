import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/services/islamic_audio_service.dart';
import '../../../core/services/quran_service.dart';
import '../../../core/state/quran_settings_state.dart';
import '../../../core/utils/quran_utils.dart';
import '../../../core/state/hatim_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/collection_helper.dart';

class AyahCard extends StatelessWidget {
  final int surahId;
  final QuranVerse verse;
  final int verseNumber;
  final int index;
  final bool isEzberMode;
  final GlobalKey ayahKey;

  const AyahCard({
    super.key,
    required this.surahId,
    required this.verse,
    required this.verseNumber,
    required this.index,
    required this.isEzberMode,
    required this.ayahKey,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.read<QuranSettingsState>(); // Access settings via provider - Ayarları provider üzerinden al

    return Consumer<IslamicAudioService>(
      builder: (context, audioService, _) {
        // [Ayet bazlı arka plan vurgusu - Ayah-based background highlight with safe comparison]
        final bool isHighlighted = audioService.currentPlayingAyahId.toString() == verse.number.toString();

        return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              key: ayahKey,
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? const Color(0xFF4B0082).withValues(alpha: 0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isHighlighted 
                      ? const Color(0xFF4B0082).withValues(alpha: 0.5)
                      : Colors.grey.withValues(alpha: 0.15),
                  width: isHighlighted ? 2.0 : 1,
                ),
                boxShadow: isHighlighted ? [
                  BoxShadow(
                    color: const Color(0xFF4B0082).withValues(alpha: 0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ] : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF4B0082).withValues(alpha: 0.06),
                        ),
                        child: Center(
                          child: Text(
                            QuranUtils.toArabicNumerals(verseNumber),
                            style: const TextStyle(
                              color: Color(0xFF4B0082),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Consumer<HatimProvider>(
                            builder: (context, hatimProvider, _) {
                              if (hatimProvider.targetDate == null) return const SizedBox.shrink();
                              final bool isRead = hatimProvider.isAyahReadSync(surahId, verseNumber);
                              return IconButton(
                                icon: Icon(
                                  isRead ? Icons.check_box : Icons.check_box_outline_blank,
                                  size: 20,
                                  color: isRead ? const Color(0xFFFFD700) : const Color(0xFF4B0082),
                                ),
                                onPressed: () {
                                  hatimProvider.markAyahAsRead(
                                    surahId: surahId,
                                    ayahId: verseNumber,
                                    isRead: !isRead,
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.collections_bookmark, size: 20, color: Color(0xFF4B0082)),
                            onPressed: () {
                              CollectionHelper.showCollectionSheet(
                                context: context,
                                itemId: 'surah_${surahId}_ayah_$verseNumber',
                                title: '$surahId. Sure, $verseNumber. Ayet',
                                subtitle: verse.turkish,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 20, color: Color(0xFF4B0082)),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: verse.arabic));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ayet kopyalandı!')),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, size: 20, color: Color(0xFF4B0082)),
                            onPressed: () => Share.share(verse.arabic),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) {
                      final wordsData = verse.words;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (settings.showArabic)
                            (wordsData == null || wordsData.isEmpty)
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                // Active Ayah shadow highlight - Aktif ayet için gölge vurgusu
                                child: Container(
                                  decoration: isHighlighted ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4B0082).withValues(alpha: 0.15), // Subtle shadow matching primary theme - Ana temaya uygun ince gölge
                                        blurRadius: 30,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ) : null,
                                  child: Text(
                                    verse.arabic.isNotEmpty ? verse.arabic : "Ayet yüklenemedi",
                                    style: GoogleFonts.getFont(
                                      settings.arabicFont,
                                      fontSize: settings.arabicFontSize,
                                      height: 1.6,
                                    ),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              )
                            : Wrap(
                              alignment: WrapAlignment.end,
                              textDirection: TextDirection.rtl,
                              spacing: 8.0,
                              runSpacing: 12.0,
                              children: wordsData.asMap().entries.map((entry) {
                                int wordIdx = entry.key;
                                final wordData = entry.value;
                                final wordArabic = wordData['arabic'] ?? wordData['text_uthmani'] ?? " ";
                                final rawTranslation = wordData['translation'];
                                final translationMap = rawTranslation != null ? Map<String, dynamic>.from(rawTranslation as Map) : null; // Safe conversion for nullable Map - Nullable Map için güvenli dönüştürme
                                final wordTranslation = translationMap?['tr'] ?? translationMap?['text'] ?? '';

                                // [Kelimeler için hassas zamanlama kontrolü - Precise timing for words]
                                final currentLocalActiveIndex = audioService.getLocalWordIndex(index);
                                final isWordActive = wordIdx == currentLocalActiveIndex;

                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isWordActive
                                        ? const Color(0xFF4B0082).withValues(alpha: 0.2) // Updated to withValues - withValues ile güncellendi
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: isWordActive
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF4B0082).withValues(alpha: 0.3), // Updated to withValues - withValues ile güncellendi
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        wordArabic,
                                        style: GoogleFonts.getFont(
                                          settings.arabicFont,
                                          fontSize: settings.arabicFontSize,
                                          fontWeight: isWordActive ? FontWeight.bold : FontWeight.normal,
                                          height: 1.3,
                                          color: isWordActive
                                              ? const Color(0xFF4B0082)
                                              : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
                                        ),
                                      ),
                                      if (settings.showWordByWord && wordTranslation.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            wordTranslation,
                                            style: GoogleFonts.inter(
                                              fontSize: settings.arabicFontSize * 0.45,
                                              color: Colors.grey,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          if (settings.showTranslation && verse.turkish.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Opacity(
                              opacity: isEzberMode ? 0.05 : 1.0,
                              child: Text(
                                verse.turkish,
                                style: GoogleFonts.getFont(
                                  settings.turkishFont,
                                  fontSize: settings.translationFontSize,
                                  height: 1.5,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                          if (settings.showTransliteration && verse.transliteration.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              verse.transliteration,
                              style: GoogleFonts.getFont(
                                settings.turkishFont,
                                fontSize: settings.transliterationFontSize,
                                height: 1.5,
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          if (settings.showTafsir) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                              ),
                              child: Text(
                                (verse.tafsir != null && verse.tafsir!.isNotEmpty) 
                                    ? verse.tafsir! 
                                    : "Bu ayet için tefsir bulunamadı.",
                                style: GoogleFonts.getFont(
                                  settings.turkishFont,
                                  fontSize: settings.tafsirFontSize,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
    );
  }
}
