import 'package:flutter/material.dart';

// [Özel Sayaç Metni: Saniyeyi küçülterek modern bir görünüm sağlar - Custom Timer Text: Provides a modern look by shrinking seconds]
class CustomTimerText extends StatelessWidget {
  final String time; // [Format: "HH:mm:ss" veya "mm:ss" - Format: "HH:mm:ss" or "mm:ss"]
  final double baseSize;
  final Color color;
  final FontWeight fontWeight;

  const CustomTimerText({
    super.key,
    required this.time,
    this.baseSize = 36,
    this.color = Colors.white,
    this.fontWeight = FontWeight.bold,
  }) ;

  @override
  Widget build(BuildContext context) {
    // [Vakti parçalara ayır - Split time into parts]
    List<String> parts = time.split(':');
    
    // [Eğer beklenen formatta değilse düz metin döndür - Return plain text if not in expected format]
    if (parts.length < 2) {
      return Text(
        time,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: baseSize,
          fontWeight: fontWeight,
          color: color,
        ),
      );
    }

    // [HH:mm:ss formatı için son parçayı (saniyeyi) yakala - Catch last part (seconds) for HH:mm:ss]
    String mainTime = parts.sublist(0, parts.length - 1).join(':');
    String seconds = parts.last;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // [Ana Saat ve Dakika - Main Hour and Minute]
        Text(
          mainTime,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: baseSize,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
        // [Küçültülmüş Saniye - Shrunken Seconds]
        Text(
          ":$seconds",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: baseSize / 3, // [Tam olarak 1/3 boyuta çekildi - set precisely to 1/3 size]
            fontWeight: fontWeight,
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
