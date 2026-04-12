import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/string_extensions.dart';

class RamadanCustomCard extends StatefulWidget {
  final String label;
  final String time;

  const RamadanCustomCard({
    super.key,
    required this.label,
    required this.time,
  });

  @override
  State<RamadanCustomCard> createState() => _RamadanCustomCardState();
}

class _RamadanCustomCardState extends State<RamadanCustomCard> with SingleTickerProviderStateMixin {
  late AnimationController _lanternController;
  late Animation<double> _lanternAnimation;

  @override
  void initState() {
    super.initState();
    _lanternController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // [Premium Yavaş Sallanma - Slow Swing]
    )..repeat(reverse: true);

    _lanternAnimation = Tween<double>(begin: -0.03, end: 0.03).animate(
      CurvedAnimation(parent: _lanternController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _lanternController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // [Dinamik Renk Zekası - Dynamic Color Intelligence]
    final isIftar = widget.label.contains('iftara');
    
    // [Premium Vakit Renkleri - Premium Timing Colors]
    final List<Color> bgGradient = isIftar 
      ? [const Color(0xFF2D1B36), const Color(0xFFE67E22), const Color(0xFFF1C40F)] // Dusty Rose / Golden Hour
      : [const Color(0xFF0F0C29), const Color(0xFF302B63), const Color(0xFF24243E)]; // Deep Night (Lacivert/Mor)

    return Container(
      width: double.infinity,
      height: 180, // High-performance smaller height
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: bgGradient[0].withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // [1. ARKA PLAN: Gradyan - Gradient Background]
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: bgGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // [2. ARKA PLAN: Endülüs Kemeri - Andalusian Arch]
            Positioned.fill(
              child: CustomPaint(
                painter: _ArchPainter(),
              ),
            ),

            // [3. SU DAMGASI: Devasa Hat Sanatı - Massive Calligraphy]
            Positioned(
              left: -30,
              bottom: -40,
              child: Opacity(
                opacity: 0.15,
                child: Text(
                  'رمضان',
                  style: GoogleFonts.arefRuqaa(
                    fontSize: 220,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ),

            // [4. GÖKSEL ÖĞELER: Hilal ve Yıldızlar - Celestial Elements]
            Positioned.fill(
              child: CustomPaint(
                painter: _CelestialPainter(isIftar: isIftar),
              ),
            ),

            // [5. FENERLER: Dual Swaying Lanterns]
            // Arka (Bulanık) Fener - Back (Blurred) Lantern
            Positioned(
              right: 60,
              top: -10,
              child: RotationTransition(
                turns: _lanternAnimation,
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: 0.4,
                  child: CustomPaint(
                    size: const Size(50, 100),
                    painter: _IslamicLanternPainter(isBlurred: true),
                  ),
                ),
              ),
            ),

            // Ana Fener - Main Lantern
            Positioned(
              right: 25,
              top: -15,
              child: RotationTransition(
                turns: _lanternAnimation,
                alignment: Alignment.topCenter,
                child: CustomPaint(
                  size: const Size(75, 150),
                  painter: _IslamicLanternPainter(isBlurred: false),
                ),
              ),
            ),

            // [5. İÇERİK: Sayaç ve Etiket - Content]
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.label.toLocaleUpperCase('tr'),
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFFFD700), // Gold
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0,
                      shadows: [
                        const Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.time.substring(0, 5),
                        style: GoogleFonts.poppins(
                          fontSize: 52,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                          shadows: [
                            const Shadow(color: Colors.black54, blurRadius: 15, offset: Offset(0, 4)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.time.length > 5 ? widget.time.substring(5) : "",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.6),
                          shadows: [
                            const Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    path.moveTo(0, size.height);
    // [Çift Kemerli Endülüs Formu - Double Arch Andalusian Form]
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.3, size.width * 0.25, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.02, size.width * 0.5, size.height * 0.05);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.02, size.width * 0.75, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.3, size.width, size.height);
    
    canvas.drawPath(path, paint);
    
    // [İç Kemer - Inner Arch]
    final innerPath = Path();
    innerPath.moveTo(20, size.height);
    innerPath.quadraticBezierTo(size.width * 0.15, size.height * 0.35, size.width * 0.28, size.height * 0.22);
    innerPath.quadraticBezierTo(size.width * 0.45, size.height * 0.07, size.width * 0.5, size.height * 0.1);
    innerPath.quadraticBezierTo(size.width * 0.55, size.height * 0.07, size.width * 0.72, size.height * 0.22);
    innerPath.quadraticBezierTo(size.width * 0.85, size.height * 0.35, size.width - 20, size.height);
    canvas.drawPath(innerPath, paint..strokeWidth = 1.0..color = const Color(0xFFFFD700).withValues(alpha: 0.05));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CelestialPainter extends CustomPainter {
  final bool isIftar;
  _CelestialPainter({required this.isIftar});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = math.Random(107);
    
    // [1. Arka Plan Silüeti Silindi - Background Silhouette Removed]
    // Siyah nokta artifact'lerini önlemek için camii silüeti kaldırılmıştır.

    // [2. Hilal - Golden Crescent]
    final goldPaint = Paint()..color = const Color(0xFFFFD700).withValues(alpha: 0.6);
    final hilalPos = Offset(size.width * 0.15, size.height * 0.25);
    
    // Path ile Hilal çizimi (BlendMode.clear artifact'lerini önlemek için)
    final outerPath = Path()..addOval(Rect.fromCircle(center: hilalPos, radius: 15));
    final innerPath = Path()..addOval(Rect.fromCircle(center: hilalPos.translate(6, -4), radius: 14));
    final crescentPath = Path.combine(PathOperation.difference, outerPath, innerPath);
    
    canvas.drawPath(crescentPath, goldPaint);
    
    // Hilal Parıltısı - Crescent Glow
    canvas.drawCircle(hilalPos, 18, Paint()..color = const Color(0xFFFFD700).withValues(alpha: 0.1)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));

    // [3. Yıldızlar - Stars]
    for (int i = 0; i < 25; i++) {
      final pos = Offset(rand.nextDouble() * size.width, rand.nextDouble() * size.height * 0.7);
      final starSize = rand.nextDouble() * 1.8 + 0.3;
      final starOpacity = rand.nextDouble() * 0.4 + 0.1;
      
      if (i % 5 == 0) {
        // Parlayan Artı Yıldız - Twinkly Cross Star
        final p = Paint()..color = Colors.white.withValues(alpha: starOpacity)..strokeWidth = 0.5;
        canvas.drawLine(pos.translate(-2, 0), pos.translate(2, 0), p);
        canvas.drawLine(pos.translate(0, -2), pos.translate(0, 2), p);
      }
      canvas.drawCircle(pos, starSize, Paint()..color = Colors.white.withValues(alpha: starOpacity));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IslamicLanternPainter extends CustomPainter {
  final bool isBlurred;
  _IslamicLanternPainter({required this.isBlurred});

  @override
  void paint(Canvas canvas, Size size) {
    final goldColor = const Color(0xFFFFD700);
    final glassColor = Colors.white.withValues(alpha: 0.12);
    
    final paint = Paint()
      ..color = isBlurred ? goldColor.withValues(alpha: 0.25) : goldColor
      ..style = PaintingStyle.fill;

    if (isBlurred) {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    }

    final outlinePaint = Paint()
      ..color = goldColor.withValues(alpha: isBlurred ? 0.2 : 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isBlurred ? 0.4 : 1.0; // Daha ince çizgiler - Thinner lines

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFCC33).withValues(alpha: isBlurred ? 0.4 : 0.95), // Daha sıcak sarı
          const Color(0xFFFFA500).withValues(alpha: 0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.52), radius: size.width * 0.35))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, isBlurred ? 18 : 15); // Daha geniş ışık

    // 1. Asma Zinciri (Chain)
    final chainPaint = Paint()
      ..color = goldColor.withValues(alpha: 0.4)
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height * 0.12), chainPaint);

    // 2. En Tepe: Zarif Hilal (Elegant Tiny Crescent)
    final hilalPos = Offset(size.width * 0.5, size.height * 0.14);
    final hilalPath = Path();
    hilalPath.addOval(Rect.fromCircle(center: hilalPos, radius: 3.5));
    final hilalCut = Path();
    hilalCut.addOval(Rect.fromCircle(center: hilalPos.translate(1.5, -0.8), radius: 3));
    canvas.drawPath(Path.combine(PathOperation.difference, hilalPath, hilalCut), paint);
    
    // 3. Soğan Kubbe (Onion Dome - Kavisli)
    final domePath = Path();
    domePath.moveTo(size.width * 0.3, size.height * 0.3);
    // Kavisli Kubbe Formu - Curved Onion Form
    domePath.quadraticBezierTo(size.width * 0.25, size.height * 0.18, size.width * 0.5, size.height * 0.18);
    domePath.quadraticBezierTo(size.width * 0.75, size.height * 0.18, size.width * 0.7, size.height * 0.3);
    canvas.drawPath(domePath, paint);
    canvas.drawPath(domePath, outlinePaint);
    
    // 4. Ana Gövde: Damla Formu (Teardrop Body - Kavisli)
    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.3, size.height * 0.3);
    bodyPath.lineTo(size.width * 0.7, size.height * 0.3);
    // Sağ Kavis - Right Curve
    bodyPath.quadraticBezierTo(size.width * 0.95, size.height * 0.52, size.width * 0.8, size.height * 0.75);
    // Alt Sivri Uç - Pointed Bottom
    bodyPath.quadraticBezierTo(size.width * 0.5, size.height * 0.95, size.width * 0.2, size.height * 0.75);
    // Sol Kavis - Left Curve
    bodyPath.quadraticBezierTo(size.width * 0.05, size.height * 0.52, size.width * 0.3, size.height * 0.3);
    bodyPath.close();

    canvas.drawPath(bodyPath, Paint()..color = glassColor);
    canvas.drawPath(bodyPath, outlinePaint);

    // İncelikli Dikey Kavisler (Faceted Detail Lines)
    final detailPath = Path();
    detailPath.moveTo(size.width * 0.5, size.height * 0.3);
    detailPath.quadraticBezierTo(size.width * 0.65, size.height * 0.52, size.width * 0.5, size.height * 0.9);
    canvas.drawPath(detailPath, outlinePaint..strokeWidth = 0.4);

    final detailPath2 = Path();
    detailPath2.moveTo(size.width * 0.5, size.height * 0.3);
    detailPath2.quadraticBezierTo(size.width * 0.35, size.height * 0.52, size.width * 0.5, size.height * 0.9);
    canvas.drawPath(detailPath2, outlinePaint);

    // 5. Parıltılı Mum Işığı (Warm Glowing Candle)
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.52), size.width * 0.18, glowPaint);
    if (!isBlurred) {
      final flamePaint = Paint()..color = Colors.white..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.52), 3, flamePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

