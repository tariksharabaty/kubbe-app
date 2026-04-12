import 'package:flutter/material.dart';

/// [Premium Özel İkon Seti - Premium Custom Icon Set]
/// V23: Tüm ikonlar Saf Kod (CustomPaint) ile sıfırdan çizildi.

class CustomNavigationIcon extends StatelessWidget {
  final CustomPainter painter;
  final double size;

  const CustomNavigationIcon({
    super.key,
    required this.painter,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: painter,
    );
  }
}

/// [1. Ana Sayfa: Kubbe ve Hilal - Home: Dome and Crescent]
class HomeIconPainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  HomeIconPainter({required this.color, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 2.5 : 1.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // [Kubbe Çizimi - Dome Drawing]
    path.moveTo(size.width * 0.1, size.height * 0.9);
    path.lineTo(size.width * 0.9, size.height * 0.9);
    
    path.moveTo(size.width * 0.2, size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.2, size.width * 0.5, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.2, size.width * 0.8, size.height * 0.9);

    canvas.drawPath(path, paint);

    // [Hilal Çizimi - Crescent Drawing]
    if (isSelected) paint.style = PaintingStyle.fill;
    final crescentPath = Path();
    crescentPath.addOval(Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.45), radius: 3));
    canvas.drawPath(crescentPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// [2. Kur'an: Rahle ve Kitap - Quran: Rahle and Book]
class QuranIconPainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  QuranIconPainter({required this.color, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 2.5 : 1.5
      ..strokeCap = StrokeCap.round;

    // [Rahle (X) - Rahle Base]
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.8), Offset(size.width * 0.8, size.height * 0.4), paint);
    canvas.drawLine(Offset(size.width * 0.8, size.height * 0.8), Offset(size.width * 0.2, size.height * 0.4), paint);

    // [Açık Kitap (V) - Open Book]
    final bookPath = Path();
    bookPath.moveTo(size.width * 0.15, size.height * 0.35);
    bookPath.lineTo(size.width * 0.5, size.height * 0.55);
    bookPath.lineTo(size.width * 0.85, size.height * 0.35);

    canvas.drawPath(bookPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// [3. Kıble: Pusula Gülü ve Kabe - Qibla: Compass Rose and Kaaba]
class QiblaIconPainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  QiblaIconPainter({required this.color, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 2.5 : 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    
    // [Dış Çember - Outer Circle]
    canvas.drawCircle(center, size.width * 0.45, paint);

    // [Merkezdeki Küp (Kabe) - Center Cube (Kaaba)]
    if (isSelected) paint.style = PaintingStyle.fill;
    final cubeRect = Rect.fromCenter(center: center, width: 8, height: 8);
    canvas.drawRect(cubeRect, paint);

    // [Pusula Çizgileri - Compass Lines]
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(Offset(center.dx, size.height * 0.05), Offset(center.dx, size.height * 0.2), paint);
    canvas.drawLine(Offset(size.width * 0.95, center.dy), Offset(size.width * 0.8, center.dy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// [4. Araçlar: 4 Yumuşak Kutu - Tools: 4 Soft Boxes]
class ToolsIconPainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  ToolsIconPainter({required this.color, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = isSelected ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2.0;

    double padding = 2.0;
    double boxSize = (size.width - padding * 3) / 2;

    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            padding + i * (boxSize + padding),
            padding + j * (boxSize + padding),
            boxSize,
            boxSize,
          ),
          const Radius.circular(4),
        );
        canvas.drawRRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// [5. KUMO: Parıltı/Yıldız - KUMO: Sparkle/Star]
class SparkleIconPainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  SparkleIconPainter({required this.color, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = isSelected ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // [4 Köşeli Parıltı Yıldızı - 4 Pointed Sparkle Star]
    path.moveTo(centerX, 0);
    path.quadraticBezierTo(centerX * 1.05, centerY * 0.95, size.width, centerY);
    path.quadraticBezierTo(centerX * 1.05, centerY * 1.05, centerX, size.height);
    path.quadraticBezierTo(centerX * 0.95, centerY * 1.05, 0, centerY);
    path.quadraticBezierTo(centerX * 0.95, centerY * 0.95, centerX, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
