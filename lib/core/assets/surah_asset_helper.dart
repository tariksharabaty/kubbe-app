import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// [SurahAssetHelper] 114 Sure kapağı için mantıksal yapı - Logical structure for 114 Surah covers
class SurahAssetHelper {
  // [Bilingual Comments: Türkçe açıklama - English explanation]

  /// Sure numarasına göre gradiyent ve kaligrafi kapağı oluşturur - Generates gradient and calligraphy cover based on Surah number
  static Widget getSurahCover(int surahNumber, String surahName, {double size = 150}) {
    // [Gradyan renklerini belirle - Determine gradient colors]
    final List<Color> gradientColors = _getGradientForSurah(surahNumber);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // [Arka plan deseni mock - Background pattern mockup]
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.mosque, size: size * 0.8, color: Colors.white),
            ),
          ),
          // [Merkezi kaligrafi metni - Central calligraphy text]
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  surahNumber.toString(),
                  style: GoogleFonts.outfit(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: size * 0.15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    surahName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      color: Colors.white,
                      fontSize: size * 0.18,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Sure numarasına göre renk paleti döner - Returns color palette based on Surah number
  static List<Color> _getGradientForSurah(int surahNumber) {
    // [114 sure için farklı renk kombinasyonları - Different color combinations for 114 surahs]
    if (surahNumber <= 10) {
      return [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)]; // Deep Blue - Derin Mavi
    } else if (surahNumber <= 20) {
      return [const Color(0xFF064E3B), const Color(0xFF10B981)]; // Emerald - Zümrüt
    } else if (surahNumber <= 40) {
      return [const Color(0xFF701A75), const Color(0xFFD946EF)]; // Fuchsia - Fuşya
    } else if (surahNumber <= 70) {
      return [const Color(0xFF7C2D12), const Color(0xFFF97316)]; // Orange - Turuncu
    } else if (surahNumber <= 100) {
      return [const Color(0xFF4C1D95), const Color(0xFF8B5CF6)]; // Violet - Menekşe
    } else {
      return [const Color(0xFF831843), const Color(0xFFF43F5E)]; // Rose - Gül
    }
  }
}
