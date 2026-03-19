import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../storage/preferences_manager.dart';

// TR: KUBBE V4 Location Service Sınıfı
// EN: KUBBE V4 Location Service Class
// TR: geolocator ve permission_handler'ın modern API'lerini kullanır
// EN: Uses modern APIs of geolocator and permission_handler
class LocationService {
  // TR: Konum ayarları - Yüksek hassasiyet ve 10 metre filtre
  // EN: Location settings - High accuracy and 10 meter filter
  static final LocationSettings _locationSettings = AndroidSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
    timeLimit: const Duration(seconds: 30),
  );

  // TR: Konum servislerinin aktif olup olmadığını kontrol et
  // EN: Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // TR: Kullanıcıyı cihazın konum ayarları ekranına yönlendir
  // EN: Directs user to the device's location settings screen
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  // TR: Gerekli tüm konum izinlerini iste
  // EN: Request all necessary location permissions
  static Future<Map<Permission, PermissionStatus>>
      requestAllPermissions() async {
    final permissions = <Permission, PermissionStatus>{};

    // TR: Konum iznini iste (cihaz açıkken)
    // EN: Request location permission (while in use)
    final locationStatus = await Permission.location.request();
    permissions[Permission.location] = locationStatus;

    // TR: Eğer 'cihaz açıkken' izni verildiyse, 'her zaman açık' iznini de iste
    // EN: If 'while in use' permission is granted, also request 'always' permission
    if (locationStatus.isGranted) {
      final alwaysLocationStatus = await Permission.locationAlways.request();
      permissions[Permission.locationAlways] = alwaysLocationStatus;
    }

    return permissions;
  }

  // TR: Mevcut konumu al
  // EN: Get current position
  static Future<Position> getCurrentPosition() async {
    try {
      // TR: 1. Adım: Konum servisleri cihazda açık mı?
      // EN: Step 1: Are location services enabled on the device?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // TR: Servisler kapalıysa, özel bir istisna fırlat.
        // EN: If services are disabled, throw a specific exception.
        throw const LocationServiceDisabledException();
      }

      // TR: 2. Adım: Uygulamanın konum izni var mı?
      // EN: Step 2: Does the app have location permission?
      var permissionStatus = await Permission.location.status;

      // TR: İzin hiç istenmemişse veya reddedilmişse, tekrar iste.
      // EN: If permission has never been asked or was denied, request it.
      if (permissionStatus.isDenied) {
        permissionStatus = await Permission.location.request();
        if (permissionStatus.isDenied) {
          // TR: Kullanıcı izni yine reddederse, hata fırlat.
          // EN: If the user denies permission again, throw an error.
          throw const LocationServiceException(
            'TR: Konum izni reddedildi. // EN: Location permission denied.',
          );
        }
      }

      // TR: İzin kalıcı olarak reddedilmişse, kullanıcıyı ayarlara yönlendirmesi için hata fırlat.
      // EN: If permission is permanently denied, throw an error to prompt the user to go to settings.
      if (permissionStatus.isPermanentlyDenied) {
        throw const LocationServiceException(
          'TR: Konum izni kalıcı olarak reddedildi. Lütfen uygulama ayarlarından izin verin. // EN: Location permission permanently denied. Please enable it from app settings.',
        );
      }

      // TR: 3. Adım: Tüm kontrollerden geçtiyse, konumu al.
      // EN: Step 3: If all checks pass, get the position.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: _locationSettings,
      );

      // TR: Konumu ve izin durumunu yerel depolamaya kaydet.
      // EN: Save the position and permission status to local storage.
      await PreferencesManager.setLastKnownLocationStatic(
        position.latitude,
        position.longitude,
      );
      await PreferencesManager.setLocationPermissionGrantedStatic(true);

      return position;
    } on LocationServiceDisabledException {
      // TR: Konum servislerinin kapalı olduğunu belirten hatayı yeniden fırlat.
      // EN: Re-throw the exception indicating that location services are disabled.
      rethrow;
    } catch (e) {
      // TR: Diğer tüm hataları genel bir konum hatası olarak yakala ve kaydet.
      // EN: Catch and log all other errors as a general location failure.
      await PreferencesManager.setLocationPermissionGrantedStatic(false);
      throw LocationServiceException(
        'TR: Konum alınamadı: $e // EN: Failed to get location: $e',
      );
    }
  }

  // TR: Kaydedilen son konumu al
  // EN: Get last known position
  static Future<Position?> getLastKnownPosition() async {
    final location = await PreferencesManager.getLastKnownLocation();
    final latitude = location.$1;
    final longitude = location.$2;

    if (latitude == null ||
        longitude == null ||
        latitude == 0.0 ||
        longitude == 0.0) {
      return null;
    }

    // TR: geolocator paketinin güncel sürümüne uygun Position nesnesi oluştur.
    // EN: Create a Position object compliant with the current version of the geolocator package.
    return Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      floor: null, // TR: Kat bilgisi yok // EN: No floor information
      isMocked: false, // TR: Sahte konum değil // EN: Not a mocked location
    );
  }

  // TR: Konum güncellemeleri stream'ini başlat
  // EN: Start location updates stream
  static Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: locationSettings ?? _locationSettings,
    );
  }

  // TR: İki nokta arasındaki mesafeyi al
  // EN: Get distance between two points
  static double getDistanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // TR: Türkiye sınırları içinde mi kontrolü
  // EN: Check if within Turkey borders
  static bool isWithinTurkey(double latitude, double longitude) {
    const turkeyNorth = 42.12;
    const turkeySouth = 35.81;
    const turkeyWest = 25.66;
    const turkeyEast = 44.82;

    return latitude >= turkeySouth &&
        latitude <= turkeyNorth &&
        longitude >= turkeyWest &&
        longitude <= turkeyEast;
  }

  // TR: Koordinatları gösterim için formatla
  // EN: Format coordinates for display
  static String formatCoordinates(double latitude, double longitude) {
    final latDir = latitude >= 0 ? 'N' : 'S';
    final lonDir = longitude >= 0 ? 'E' : 'W';

    return '${latitude.abs().toStringAsFixed(4)}°$latDir, ${longitude.abs().toStringAsFixed(4)}°$lonDir';
  }

  // TR: Konum hassasiyetinin yeterli olup olmadığını kontrol et
  // EN: Check if location accuracy is sufficient
  static bool isAccuracySufficient(double accuracy) {
    return accuracy <= 100.0;
  }

  // TR: Konum kalitesini al
  // EN: Get location quality
  static LocationQuality getLocationQuality(double accuracy) {
    if (accuracy <= 10) {
      return LocationQuality.excellent;
    } else if (accuracy <= 50) {
      return LocationQuality.good;
    } else if (accuracy <= 100) {
      return LocationQuality.fair;
    } else {
      return LocationQuality.poor;
    }
  }

  // TR: Konum servisini başlat
  // EN: Initialize location service
  static Future<LocationInitializationResult> initialize() async {
    try {
      await getCurrentPosition();
      return LocationInitializationResult(success: true);
    } on LocationServiceDisabledException {
      return LocationInitializationResult(
        success: false,
        error:
            'TR: Konum servisleri kapalı. // EN: Location services are disabled.',
        canRequestEnable: true,
      );
    } on LocationServiceException catch (e) {
      // TR: İzin reddedildiyse, izin isteme seçeneği sun.
      // EN: If permission was denied, offer the option to request permission.
      final isPermissionError = e.message.contains('permission');
      return LocationInitializationResult(
        success: false,
        error: e.message,
        canRequestPermission: isPermissionError,
      );
    } catch (e) {
      return LocationInitializationResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  // TR: Konum izinlerini sıfırla
  // EN: Reset location permissions
  static Future<void> resetPermissions() async {
    await PreferencesManager.setLocationPermissionGrantedStatic(false);
    await PreferencesManager.setLastKnownLocationStatic(0.0, 0.0);
  }
}

// TR: Konum servisi istisnası
// EN: Location service exception
class LocationServiceException implements Exception {
  final String message;
  const LocationServiceException(this.message);
  @override
  String toString() => 'LocationServiceException: $message';
}

// TR: Konum kalitesi enum'u
// EN: Location quality enum
enum LocationQuality {
  excellent,
  good,
  fair,
  poor,
}

// TR: Konum başlatma sonucu
// EN: Location initialization result
class LocationInitializationResult {
  final bool success;
  final String? error;
  final bool canRequestPermission;
  final bool canRequestEnable;

  LocationInitializationResult({
    required this.success,
    this.error,
    this.canRequestPermission = false,
    this.canRequestEnable = false,
  });
}

// TR: Konum veri modeli
// EN: Location data model
class LocationData {
  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime timestamp;
  final String? cityName;
  final LocationQuality quality;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
    this.cityName,
    required this.quality,
  });

  factory LocationData.fromPosition(Position position, {String? cityName}) {
    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: position.timestamp,
      cityName: cityName,
      quality: LocationService.getLocationQuality(position.accuracy),
    );
  }

  String get formattedCoordinates =>
      LocationService.formatCoordinates(latitude, longitude);

  bool get isWithinTurkey =>
      LocationService.isWithinTurkey(latitude, longitude);

  bool get isAccurate => LocationService.isAccuracySufficient(accuracy);
}
