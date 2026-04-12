import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// [Görsel Servisi - Image Service]
// Not: Gerçek API anahtarı kullanıcı tarafından sağlandığında buraya eklenebilir.
class ImageService {
  // [Unsplash tabanlı anahtar kelime URL'si - Keyword based Unsplash URL]
  static String getKeywordImage(String keywords) {
    // encode query parameters to be safe
    final encodedKeywords = Uri.encodeComponent(keywords.replaceAll(' ', ','));
    return "https://source.unsplash.com/featured/?$encodedKeywords";
  }

  // [Pexels tabanlı alternatif (Opsiyonel) - Pexels alternative]
  // static String getPexelsImage(String query) { ... }
}

// [İslami Motifli Fallback Kartı - Islamic Motifs Fallback Card]
class KubbeFallbackCard extends StatelessWidget {
  final String title;
  final double height;
  final double radius;

  const KubbeFallbackCard({
    super.key,
    required this.title,
    this.height = 200,
    this.radius = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5E6), // Parşömen
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFF4B0082).withValues(alpha: 0.1)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arka planda silik İslami desen (Lale veya Geometrik)
          Opacity(
            opacity: 0.03,
            child: Icon(Icons.mosque_rounded, size: height * 0.6, color: const Color(0xFF4B0082)),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.history_edu_rounded, color: Color(0xFF4B0082), size: 40),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4B0082),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Arşiv Kaydı Yükleniyor...",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
