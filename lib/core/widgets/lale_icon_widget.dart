import 'package:flutter/material.dart';

// [Özel Lale İkonu: Lale Bahçesi'ndeki 5 yapraklı yapıyı temsil eden widget - Custom Tulip Icon: Widget representing the 5-petal structure in Tulip Garden]
class LaleIconWidget extends StatelessWidget {
  final double size;
  final bool isActive;

  const LaleIconWidget({
    super.key,
    this.size = 28.0,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    // [Namaz renkleri: Lale Bahçesi ile birebir aynı - Prayer colors: Identical to Tulip Garden]
    final List<Color> prayerColors = [
      const Color(0xFFFFC107), // Sabah (Sarı)
      const Color(0xFFFF9800), // Öğle (Turuncu)
      const Color(0xFFF44336), // İkindi (Kırmızı)
      const Color(0xFF4CAF50), // Akşam (Yeşil)
      const Color(0xFF2196F3), // Yatsı (Mavi)
    ];

    final Color inactiveColor = Colors.grey.withValues(alpha: 0.2);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: List.generate(5, (index) {
          // [Yaprak açıları (Radyan cinsinden) - Petal angles (in Radians)]
          double angle = (index - 2) * 0.40; // -0.80'den 0.80'e yelpaze açılımı
          return _buildPetal(
            isActive ? prayerColors[index] : inactiveColor,
            angle,
            size,
          );
        }),
      ),
    );
  }

  Widget _buildPetal(Color color, double angle, double size) {
    return Transform.rotate(
      angle: angle,
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size * 0.35, // [Yaprak genişliği - Petal width]
        height: size * 0.8,  // [Yaprak uzunluğu - Petal length]
        decoration: BoxDecoration(
          color: color,
          // [Lale yaprağı formu veren özel ovallik - Special border radius for tulip petal shape]
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size * 0.4),
            bottomRight: Radius.circular(size * 0.4),
            topRight: Radius.circular(size * 0.05),
            bottomLeft: Radius.circular(size * 0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            )
          ],
        ),
      ),
    );
  }
}
