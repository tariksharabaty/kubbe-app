import 'package:flutter/material.dart';

class CustomQuranIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CustomQuranIcon({super.key, this.size = 24.0, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: QuranIconPainter(color: color),
    );
  }
}

class QuranIconPainter extends CustomPainter {
  final Color color;

  QuranIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double w = size.width;
    final double h = size.height;

    // [RAHLE: Alt Çapraz Ayaklar - Rahle: Bottom Cross Legs]
    // Çapraz duran iki ana hat - Two main crossing lines
    canvas.drawLine(Offset(w * 0.2, h * 0.8), Offset(w * 0.8, h * 0.4), paint);
    canvas.drawLine(Offset(w * 0.8, h * 0.8), Offset(w * 0.2, h * 0.4), paint);

    // [AÇIK KİTAP: Üst Kanatlar - Open Book: Top Wings]
    final path = Path();
    // Sol sayfa - Left page
    path.moveTo(w * 0.5, h * 0.45);
    path.quadraticBezierTo(w * 0.35, h * 0.25, w * 0.15, h * 0.35);
    path.lineTo(w * 0.15, h * 0.15);
    path.quadraticBezierTo(w * 0.35, h * 0.05, w * 0.5, h * 0.25);
    
    // Sağ sayfa - Right page
    path.moveTo(w * 0.5, h * 0.25);
    path.quadraticBezierTo(w * 0.65, h * 0.05, w * 0.85, h * 0.15);
    path.lineTo(w * 0.85, h * 0.35);
    path.quadraticBezierTo(w * 0.65, h * 0.25, w * 0.5, h * 0.45);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
