import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import '../../../core/state/quran_settings_state.dart';
import '../../../core/utils/quran_utils.dart';
import '../../../core/services/islamic_audio_service.dart';
import '../../../core/state/history_state.dart';
import '../../../core/state/hatim_provider.dart';
import 'package:provider/provider.dart';

class MushafView extends StatelessWidget {
  final int initialPage;
  
  const MushafView({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    final settings = QuranSettingsState();
    final audioService = IslamicAudioService();

    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        return PageView.builder(
          itemCount: 604,
          controller: PageController(initialPage: initialPage - 1),
          reverse: true, // Right-to-left Mushaf navigation
          onPageChanged: (pageIndex) {
            final pageNum = pageIndex + 1;
            // [Sayfa değişince ilerlemeyi kaydet - Save progress when page changes]
            final pageData = quran.getPageData(pageNum);
            if (pageData.isNotEmpty) {
              final firstItem = pageData.first;
              final surahId = firstItem['surah'] as int;
              final ayahId = firstItem['start'] as int;
              
              updateHistoryProgress(
                surahNumber: surahId,
                ayahNumber: ayahId,
                surahName: quran.getSurahName(surahId),
                pageNumber: pageNum,
              );
              
              context.read<HatimProvider>().markAyahAsReadSilently(
                surahId: surahId,
                ayahId: ayahId,
              );
            }
          },
          itemBuilder: (context, index) {
            int pageNum = index + 1;
            List<Map<String, dynamic>> pageData = [];

            try {
              pageData = quran.getPageData(pageNum).cast<Map<String, dynamic>>();
            } catch (e) {
              return Center(child: Text("Sayfa yüklenirken hata oluştu: $e"));
            }

            return StreamBuilder<int?>(
              stream: audioService.currentAyahStream,
              builder: (context, ayahSnapshot) {
                final int currentAyah = ayahSnapshot.data ?? -1;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      // Elite Premium Mushaf Rendering
                      Text.rich(
                        TextSpan(
                          children: [
                             for (var item in pageData) ...[
                               for (int i = item['start']; i <= item['end']; i++) ...(() {
                                 final bool isCurrentSurah = audioService.currentTrack?.extras?['surah_id'] == item['surah'];
                                 final bool isActive = isCurrentSurah && i == currentAyah;

                                 return [
                                   TextSpan(
                                     text: quran.getVerse(item['surah'], i) + ' ',
                                     style: GoogleFonts.getFont(
                                       settings.mushafFont,
                                       fontSize: settings.arabicFontSize,
                                       height: 1.8,
                                       backgroundColor: isActive 
                                          ? const Color(0xFF4B0082).withOpacity(0.2) 
                                          : Colors.transparent,
                                       color: Colors.black.withOpacity(0.9),
                                     ),
                                   ),
                                   TextSpan(
                                     text: '﴿${QuranUtils.toArabicNumerals(i)}﴾ ', // Traditional Ornament
                                     style: GoogleFonts.getFont(
                                       settings.mushafFont,
                                       fontSize: settings.arabicFontSize * 0.9,
                                       color: isActive 
                                          ? const Color(0xFF4B0082) 
                                          : Colors.black87,
                                     ),
                                   ),
                                 ];
                               })()
                             ]
                          ],
                        ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.justify, // Professional book alignment
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                );
              }
            );
          },
        );
      },
    );
  }
}
