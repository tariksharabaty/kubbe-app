// TR: KUBBE V4 Kible Pusulası Provider - V1'den miras alındı
// EN: KUBBE V4 Qibla Compass Provider - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: 'sensors_plus' veya 'flutter_compass' kullanarak cihazın sapma açısını (Azimuth) dinle
// EN: Listen to device's deviation angle (Azimuth) using 'sensors_plus' or 'flutter_compass'
// TR: Kabe koordinatlarına (21.4225° N, 39.8262° E) göre cihazın bulunduğu konumdan bakması gereken matematiksel açıyı hesaplayan V1 logic'ini ekle
// EN: Add V1 logic that calculates the mathematical angle the device should face from its current location based on Kaaba coordinates (21.4225° N, 39.8262° E)

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../core/services/location_service.dart';

/// TR: KUBBE V4 Kible Pusulası State Sınıfı
/// EN: KUBBE V4 Qibla Compass State Class
/// TR: Kible pusulası durumunu temsil eden veri modeli
/// EN: Data model representing qibla compass state
/// TR: Açı, yön ve konum bilgilerini içerir
/// EN: Contains angle, direction and location information
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
class QiblaState {
  // TR: Mevcut açı (derece)
  // EN: Current angle (degrees)
  final double currentAngle;

  // TR: Kible yönü (derece)
  // EN: Qibla direction (degrees)
  final double qiblaAngle;

  // TR: Kibleye olan açı farkı
  // EN: Angle difference to Qibla
  final double angleDifference;

  // TR: Mevcut konum enlemi
  // EN: Current location latitude
  final double? latitude;

  // TR: Mevcut konum boylamı
  // EN: Current location longitude
  final double? longitude;

  // TR: Kibleye dönük mü?
  // EN: Is facing Qibla?
  final bool isFacingQibla;

  // TR: Sensör aktif mi?
  // EN: Is sensor active?
  final bool isSensorActive;

  // TR: Hata mesajı
  // EN: Error message
  final String? errorMessage;

  // TR: Constructor
  // EN: Constructor
  const QiblaState({
    required this.currentAngle,
    required this.qiblaAngle,
    required this.angleDifference,
    this.latitude,
    this.longitude,
    this.isFacingQibla = false,
    this.isSensorActive = false,
    this.errorMessage,
  });

  // TR: CopyWith metodu
  // EN: CopyWith method
  QiblaState copyWith({
    double? currentAngle,
    double? qiblaAngle,
    double? angleDifference,
    double? latitude,
    double? longitude,
    bool? isFacingQibla,
    bool? isSensorActive,
    String? errorMessage,
  }) {
    return QiblaState(
      currentAngle: currentAngle ?? this.currentAngle,
      qiblaAngle: qiblaAngle ?? this.qiblaAngle,
      angleDifference: angleDifference ?? this.angleDifference,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFacingQibla: isFacingQibla ?? this.isFacingQibla,
      isSensorActive: isSensorActive ?? this.isSensorActive,
      errorMessage: errorMessage,
    );
  }

  // TR: Equality operator
  // EN: Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QiblaState &&
        other.currentAngle == currentAngle &&
        other.qiblaAngle == qiblaAngle &&
        other.angleDifference == angleDifference &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.isFacingQibla == isFacingQibla &&
        other.isSensorActive == isSensorActive &&
        other.errorMessage == errorMessage;
  }

  // TR: Hash code
  // EN: Hash code
  @override
  int get hashCode {
    return Object.hash(
      currentAngle,
      qiblaAngle,
      angleDifference,
      latitude,
      longitude,
      isFacingQibla,
      isSensorActive,
      errorMessage,
    );
  }

  // TR: String representation
  // EN: String representation
  @override
  String toString() {
    return 'QiblaState(currentAngle: $currentAngle, qiblaAngle: $qiblaAngle, isFacingQibla: $isFacingQibla)';
  }
}

/// TR: KUBBE V4 Kible Pusulası Notifier Sınıfı
/// EN: KUBBE V4 Qibla Compass Notifier Class
/// TR: V1'deki kible pusulası mantığını Riverpod Notifier olarak uygular
/// EN: Implements V1's qibla compass logic as Riverpod Notifier
/// TR: Cihazın sapma açısını dinler ve Kabe yönünü hesaplar
/// EN: Listens to device's deviation angle and calculates Kaaba direction
/// TR: Kabe koordinatlarına göre matematiksel hesaplamalar yapar
/// EN: Performs mathematical calculations based on Kaaba coordinates
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
class QiblaNotifier extends Notifier<QiblaState> {
  // TR: Kabe koordinatları
  // EN: Kaaba coordinates
  static const double _kaabaLatitude =
      21.4225; // TR: Kabe enlemi // EN: Kaaba latitude
  static const double _kaabaLongitude =
      39.8262; // TR: Kabe boylamı // EN: Kaaba longitude

  // TR: Sensör subscription
  // EN: Sensor subscription
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;

  // TR: Başlangıç durumu
  // EN: Initial state
  @override
  QiblaState build() {
    // TR: Varsayılan durum
    // EN: Default state
    return const QiblaState(
      currentAngle: 0.0,
      qiblaAngle: 0.0,
      angleDifference: 0.0,
      isSensorActive: false,
    );
  }

  // TR: Kible pusulasını başlat
  // EN: Start qibla compass
  Future<void> startCompass() async {
    try {
      // TR: Konumu al
      // EN: Get location
      final location = await LocationService.getCurrentLocation();
      if (location != null) {
        // TR: Kible açısını hesapla
        // EN: Calculate qibla angle
        final userLat = location.latitude;
        final userLon = location.longitude;
        final qiblaAngle = _calculateQiblaAngle(userLat, userLon);

        // TR: Durumu güncelle
        // EN: Update state
        state = state.copyWith(
          latitude: userLat,
          longitude: userLon,
          qiblaAngle: qiblaAngle,
          isSensorActive: true,
          errorMessage: null,
        );
      }

      // TR: Sensör dinlemesini başlat
      // EN: Start sensor listening
      _startSensorListening();
    } catch (e) {
      // TR: Hata durumunda
      // EN: On error
      state = state.copyWith(
        errorMessage: 'Kible pusulası başlatılamadı: ${e.toString()}',
        isSensorActive: false,
      );
    }
  }

  // TR: Kible pusulasını durdur
  // EN: Stop qibla compass
  void stopCompass() {
    // TR: Sensör dinlemesini durdur
    // EN: Stop sensor listening
    _magnetometerSubscription?.cancel();
    _magnetometerSubscription = null;

    // TR: Durumu güncelle
    // EN: Update state
    state = state.copyWith(
      isSensorActive: false,
    );
  }

  // TR: Sensör dinlemesini başlat
  // EN: Start sensor listening
  void _startSensorListening() {
    // TR: Mevcut aboneliği iptal et
    // EN: Cancel current subscription
    _magnetometerSubscription?.cancel();

    // TR: Yeni abonelik başlat
    // EN: Start new subscription
    _magnetometerSubscription =
        magnetometerEvents.listen((MagnetometerEvent event) {
      // TR: Açıyı hesapla
      // EN: Calculate angle
      final currentAngle = _calculateAzimuth(event.x, event.y, event.z);
      final angleDifference =
          _calculateAngleDifference(currentAngle, state.qiblaAngle);
      final isFacingQibla = _isFacingQibla(angleDifference);

      // TR: Kibleye dönüldüğünde titreşim ver
      // EN: Give haptic when facing Qibla
      if (isFacingQibla && !state.isFacingQibla) {
        HapticUtils.successVibration();
      }

      // TR: Durumu güncelle
      // EN: Update state
      state = state.copyWith(
        currentAngle: currentAngle,
        angleDifference: angleDifference,
        isFacingQibla: isFacingQibla,
      );
    });
  }

  // TR: Azimuth açısını hesapla
  // EN: Calculate azimuth angle
  // TR: TR: Manyetometre verilerinden azimuth açısını hesaplar
  // EN: EN: Calculates azimuth angle from magnetometer data
  double _calculateAzimuth(double x, double y, double z) {
    // TR: V1'den miras alınan azimuth hesaplama mantığı
    // EN: Azimuth calculation logic inherited from V1
    double azimuth = math.atan2(y, x) * (180 / math.pi);

    // TR: Açıyı 0-360 aralığına getir
    // EN: Bring angle to 0-360 range
    if (azimuth < 0) {
      azimuth += 360;
    }

    return azimuth;
  }

  // TR: Kible açısını hesapla
  // EN: Calculate qibla angle
  // TR: TR: Kullanıcı konumundan Kabe'ye olan açıyı hesaplar
  // EN: EN: Calculates angle from user location to Kaaba
  double _calculateQiblaAngle(double userLat, double userLon) {
    // TR: V1'den miras alınan matematiksel hesaplama mantığı
    // EN: Mathematical calculation logic inherited from V1

    // TR: Radyan dönüşümü
    // EN: Radian conversion
    const radianConversion = math.pi / 180;
    final lat1 = userLat * radianConversion;
    const lat2 = _kaabaLatitude * radianConversion;
    final lonDiff = (_kaabaLongitude - userLon) * radianConversion;

    // TR: Trigonometrik hesaplamalar
    // EN: Trigonometric calculations
    final y = math.sin(lonDiff) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(lonDiff);

    // TR: Açıyı hesapla
    // EN: Calculate angle
    const degreeConversion = 180 / math.pi;
    double qiblaAngle = math.atan2(y, x) * degreeConversion;

    // TR: Açıyı 0-360 aralığına getir
    // EN: Bring angle to 0-360 range
    if (qiblaAngle < 0) {
      qiblaAngle += 360;
    }

    return qiblaAngle;
  }

  // TR: Aç farkını hesapla
  // EN: Calculate angle difference
  // TR: TR: Mevcut açı ile kible açısı arasındaki farkı hesaplar
  // EN: EN: Calculates difference between current angle and qibla angle
  double _calculateAngleDifference(double currentAngle, double qiblaAngle) {
    double difference = qiblaAngle - currentAngle;

    // TR: Farkı -180 ile 180 aralığına getir
    // EN: Bring difference to -180 to 180 range
    if (difference > 180) {
      difference -= 360;
    } else if (difference < -180) {
      difference += 360;
    }

    return difference;
  }

  // TR: Kibleye dönük mü kontrolü
  // EN: Is facing Qibla check
  // TR: TR: Cihazın kibleye dönük olup olmadığını kontrol eder
  // EN: EN: Checks if device is facing Qibla
  bool _isFacingQibla(double angleDifference) {
    // TR: ±5 derece tolerans
    // EN: ±5 degree tolerance
    return angleDifference.abs() <= 5.0;
  }

  // TR: Yön metnini al
  // EN: Get direction text
  // TR: TR: Aç farkına göre yön metnini döndürür
  // EN: EN: Returns direction text based on angle difference
  String getDirectionText(double angleDifference, {String language = 'tr'}) {
    if (language == 'tr') {
      if (angleDifference.abs() <= 5) {
        return 'KIBLE';
      } else if (angleDifference > 0) {
        return 'SAĞ';
      } else {
        return 'SOL';
      }
    } else {
      if (angleDifference.abs() <= 5) {
        return 'QIBLA';
      } else if (angleDifference > 0) {
        return 'RIGHT';
      } else {
        return 'LEFT';
      }
    }
  }

  // TR: Mesafe metnini al
  // EN: Get distance text
  // TR: TR: Kıbleye olan mesafeyi döndürür
  // EN: EN: Returns distance to Qibla
  String getDistanceText({String language = 'tr'}) {
    if (state.latitude == null || state.longitude == null) {
      return language == 'tr' ? 'Hesaplanıyor...' : 'Calculating...';
    }

    // TR: Basit mesafe hesabı (V1 mantığı)
    // EN: Simple distance calculation (V1 logic)
    final distance = _calculateDistance(
      state.latitude!,
      state.longitude!,
      _kaabaLatitude,
      _kaabaLongitude,
    );

    if (language == 'tr') {
      return 'Kıbleye uzaklık: ${distance.toStringAsFixed(0)} km';
    } else {
      return 'Distance to Qibla: ${distance.toStringAsFixed(0)} km';
    }
  }

  // TR: Mesafeyi hesapla
  // EN: Calculate distance
  // TR: TR: İki nokta arasındaki mesafeyi hesaplar
  // EN: EN: Calculates distance between two points
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    // TR: Haversine formülü (V1'den miras alındı)
    // EN: Haversine formula (inherited from V1)
    const R = 6371; // TR: Dünya yarıçapı (km) // EN: Earth radius (km)
    final dLat = (lat2 - lat1) * (math.pi / 180);
    final dLon = (lon2 - lon1) * (math.pi / 180);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * (math.pi / 180)) *
            math.cos(lat2 * (math.pi / 180)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return R * c;
  }

  // TR: Dispose metodu
  // EN: Dispose method
  void dispose() {
    // TR: Aboneliği iptal et
    // EN: Cancel subscription
    _magnetometerSubscription?.cancel();
  }
}

/// TR: Qibla Provider - V4 yeniliği
/// EN: Qibla Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
/// TR: V1'den miras alındı
/// EN: Inherited from V1
final qiblaProvider = NotifierProvider<QiblaNotifier, QiblaState>(() {
  return QiblaNotifier();
});

/// TR: Qibla State Provider - V4 yeniliği
/// EN: Qibla State Provider - V4 innovation
/// TR: Mevcut kible durumunu sağlar
/// EN: Provides current qibla state
final qiblaStateProvider = Provider<QiblaState>((ref) {
  return ref.watch(qiblaProvider);
});
