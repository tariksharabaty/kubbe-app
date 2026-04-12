import 'package:flutter/material.dart';


// [Desenli Şemse Kütüphane İkonu - Patterned Shemse Library Icon]
class KubbeLibraryIcon extends StatelessWidget {
  final bool isActive;
  final double size;
  final Color? color;

  const KubbeLibraryIcon({
    super.key,
    required this.isActive,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // [Aktiflik durumuna göre renk ayarı - Color adjustment based on activity]
    final Color mainColor = color ?? (isActive ? const Color(0xFF4B0082) : const Color(0xFFBDBDBD));

    return Icon(
      isActive ? Icons.collections_bookmark_rounded : Icons.collections_bookmark_outlined,
      color: mainColor,
      size: size,
    );
  }
}
