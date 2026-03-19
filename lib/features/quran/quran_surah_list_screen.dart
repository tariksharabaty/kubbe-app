// TR: KUBBE V4 Quran Surah List Screen - V4 yeniliği
// EN: KUBBE V4 Quran Surah List Screen - V4 innovation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/surah.dart';
import 'surah_repository.dart';
import 'quran_reader_screen.dart';

/// TR: KUBBE V4 Quran Surah List Screen Sınıfı
/// EN: KUBBE V4 Quran Surah List Screen Class
/// TR: 114 sure listesi ve navigasyon
/// EN: 114 surah list and navigation
/// TR: V4 estetiği ve Sy-OS design language
/// EN: V4 aesthetics and Sy-OS design language
class QuranSurahListScreen extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const QuranSurahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TR: Sure listesi
    // EN: Surah list
    final surahs = ref.watch(surahListProvider);

    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'Kur\'an-ı Kerim',
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
        // TR: Sure listesi
        // EN: Surah list
        child: surahs.when(
          data: (surahs) => ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return _buildSurahCard(surah, context);
            },
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Colors.indigo,
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Sureler yüklenemedi: $error',
              style: GoogleFonts.inter(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TR: Sure kartı oluştur
  // EN: Build surah card
  Widget _buildSurahCard(Surah surah, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      // TR: Kart
      // EN: Card
      child: GestureDetector(
        onTap: () {
          // TR: Okuma ekranına git
          // EN: Navigate to reading screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QuranReaderScreen(surah: surah),
            ),
          );
        },
        // TR: Kart container
        // EN: Card container
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // TR: Gölge
            // EN: Shadow
            boxShadow: [
              BoxShadow(
                color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
                blurRadius: 12.0,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          // TR: Kart içeriği
          // EN: Card content
          child: Row(
            children: [
              // TR: Sure numarası
              // EN: Surah number
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
                      KubbeTheme.kubbeIndigo,
                      KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                // TR: Sure numarası metni
                // EN: Surah number text
                child: Center(
                  child: Text(
                    '${surah.id}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(width: 16.0),

              // TR: Sure bilgileri
              // EN: Surah information
              Expanded(
                // TR: Bilgiler
                // EN: Information
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TR: Sure adı - Outfit Bold
                    // EN: Surah name - Outfit Bold
                    Text(
                      surah.name,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KubbeTheme.kubbeIndigo,
                      ),
                    ),

                    // TR: Arapça adı
                    // EN: Arabic name
                    Text(
                      surah.name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),

                    // TR: Ayet sayısı ve iniş yeri
                    // EN: Verse count and revelation place
                    Text(
                      '${surah.verses.length} ayet • ${surah.city}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // TR: İkon
              // EN: Icon
              Icon(
                Icons.arrow_forward_ios,
                color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
