import 'package:flutter/material.dart';

// [Kubbe Özel Kütüphane İkonu - Custom Library Icon]
class CustomLibraryIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CustomLibraryIcon({
    super.key,
    this.size = 24.0,
    this.color = const Color(0xFF4B0082), // [Varsayılan renk]
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LibraryIconPainter(
          bookColor: color,
          domeColor: const Color(0xFF4B0082), // [Sabit Proje Moru]
        ),
      ),
    );
  }
}

class _LibraryIconPainter extends CustomPainter {
  final Color bookColor;
  final Color domeColor;
  
  _LibraryIconPainter({required this.bookColor, required this.domeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bookPaint = Paint()
      ..color = bookColor
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double w = size.width;
    final double h = size.height;

    // --- 1. Kitap Formu (Alt Kısım) ---
    final Path bookPath = Path();
    // Sol sayfa
    bookPath.moveTo(w * 0.1, h * 0.55);
    bookPath.quadraticBezierTo(w * 0.3, h * 0.45, w * 0.5, h * 0.55);
    bookPath.lineTo(w * 0.5, h * 0.85);
    bookPath.quadraticBezierTo(w * 0.3, h * 0.75, w * 0.1, h * 0.85);
    bookPath.close();
    
    // Sağ sayfa
    bookPath.moveTo(w * 0.5, h * 0.55);
    bookPath.quadraticBezierTo(w * 0.7, h * 0.45, w * 0.9, h * 0.55);
    bookPath.lineTo(w * 0.9, h * 0.85);
    bookPath.quadraticBezierTo(w * 0.7, h * 0.75, w * 0.5, h * 0.85);
    bookPath.close();

    canvas.drawPath(bookPath, bookPaint);

    // --- 2. Kubbe Silüeti (Üst Kısım) ---
    final Paint domeBrush = Paint()
      ..color = domeColor
      ..style = PaintingStyle.fill;

    final Path domePath = Path();
    // Kubbe yayı
    domePath.moveTo(w * 0.25, h * 0.45);
    domePath.quadraticBezierTo(w * 0.5, h * 0.05, w * 0.75, h * 0.45);
    domePath.lineTo(w * 0.25, h * 0.45);
    domePath.close();
    
    canvas.drawPath(domePath, domeBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
