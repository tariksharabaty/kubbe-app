import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// [SurahCoverWidget] Gün doğumu temalı ve hat sanatlı Surah kapağı - Sunrise themed and calligraphy Surah cover
class SurahCoverWidget extends StatelessWidget {
  final String surahName;
  final double height;
  final double width;

  const SurahCoverWidget({
    super.key,
    required this.surahName,
    this.height = 200,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF2E0854), // [Derin Mor - Deep Purple]
            Color(0xFF4B0082), // [İndigo - Indigo]
            Color(0xFFFF8C00), // [Koyu Turuncu - Dark Orange]
            Color(0xFFFFD700), // [Altın Sarısı - Gold]
          ],
          stops: [0.0, 0.4, 0.8, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // [Hafif doku veya parıltı efekti eklenebilir - Light texture or glow effect can be added]
          Center(
            child: Text(
              surahName,
              style: GoogleFonts.amiri(
                fontSize: 48, // [Görkemli boyut - Grandiose size]
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black.withValues(alpha: 0.5),
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center, // [Hat sanatını ortala - Center the calligraphy]
            ),
          ),
        ],
      ),
    );
  }
}

// [Gerçek Kur'an Ayet Gülü Motifi - Authentic Quran Verse Motif Painter]
class AyetDurakGuluPainter extends CustomPainter {
  final String number;
  final bool isGold;

  AyetDurakGuluPainter({required this.number, this.isGold = true});

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width / 2;
    final double radius = size.width / 2.2;
    final double innerRadius = radius * 0.85;

    final baseColor = isGold ? const Color(0xFFFFD700) : const Color(0xFF4B0082);
    final accentColor = isGold ? const Color(0xFF4B0082) : const Color(0xFFD4AF37);

    final Paint fillPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final Paint innerBorderPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // 1. Dış Çiçek Yaprağı (Scalloped Edges)
    final Path path = Path();
    const int petals = 8;
    for (int i = 0; i < petals * 2; i++) {
      final double angle = i * math.pi / petals;
      final double r = (i % 2 == 0) ? radius : radius * 0.9;
      final double x = center + r * math.cos(angle);
      final double y = center + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final double prevAngle = (i - 1) * math.pi / petals;
        final double midAngle = (prevAngle + angle) / 2;
        final double midR = radius * 1.05;
        path.quadraticBezierTo(
          center + midR * math.cos(midAngle),
          center + midR * math.sin(midAngle),
          x, y
        );
      }
    }
    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);

    // 2. İç Daire
    canvas.drawCircle(Offset(center, center), innerRadius, innerBorderPaint);

    // 3. Köşe Noktaları (Süsleme)
    final pointPaint = Paint()..color = baseColor..style = PaintingStyle.fill;
    for (int i = 0; i < petals; i++) {
      final double angle = i * 2 * math.pi / petals;
      canvas.drawCircle(Offset(center + radius * math.cos(angle), center + radius * math.sin(angle)), 1.5, pointPaint);
    }

    // 4. Sayı Çizimi
    final textPainter = TextPainter(
      text: TextSpan(
        text: number,
        style: GoogleFonts.poppins(
          color: accentColor,
          fontWeight: FontWeight.bold,
          fontSize: size.width * 0.35,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center - textPainter.width / 2, center - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
