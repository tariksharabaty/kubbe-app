import 'dart:math' show pi, sin, cos, atan2;

// [Kıble Hesaplayıcı: Konum bazlı matematiksel yön bulma]
// [Qibla Calculator: Location-based mathematical direction finding]
class QiblaCalculator {
  // [Kabe'nin Sabit Koordinatları: Latitude (Enlem) ve Longitude (Boylam)]
  // [Kaaba's Fixed Coordinates: Latitude and Longitude]
  static const double kaabaLat = 21.422487;
  static const double kaabaLng = 39.826206;

  // [Kıble Açısını Hesaplarken Dünyanın Eğriliğini Baz Alır - Calculates bearing]
  // [Küresel trigonometrik formül kullanarak gerçek yönü hesaplar]
  static double calculateQiblaBearing(double userLat, double userLng) {
    // [Dereceleri radyana çevir - Convert degrees to radians]
    double latk = kaabaLat * (pi / 180.0);
    double latu = userLat * (pi / 180.0);
    double longDiff = (kaabaLng * (pi / 180.0)) - (userLng * (pi / 180.0));

    // [Great Circle (Büyük Daire) yön formülü - Formula for bearing on a sphere]
    double y = sin(longDiff) * cos(latk);
    double x = cos(latu) * sin(latk) - sin(latu) * cos(latk) * cos(longDiff);

    // [Radyanı dereceye geri çevir - Convert radians back to degrees]
    double bearing = atan2(y, x) * (180.0 / pi);
    
    // [Negatif açıyı pozitif 360 derecelik düzleme çeker - Normalize to 0-360 range]
    return (bearing + 360.0) % 360.0; 
  }
}
