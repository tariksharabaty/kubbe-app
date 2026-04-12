import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/location_model.dart';

/// [Merkezi Konum Servisi - Centralized Location Service]
/// V23: Baştan yazıldı, daha sağlam geocoding ve hata yönetimi içerir.
class LocationService {
  
  /// [Konum İzni Kontrolü | Permission Check]
  static Future<bool> hasLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  /// [GPS ile Mevcut Şehri Al | Get Current City via GPS]
  static Future<LocationModel?> getCurrentLocation() async {
    try {
      if (!await hasLocationPermission()) return null;

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        String city = (place.locality != null && place.locality!.isNotEmpty) 
            ? place.locality! 
            : (place.administrativeArea ?? 'Bilinmeyen');
        return LocationModel(
          sehir: _normalizeCityName(city),
          ulke: place.country ?? "Türkiye",
          bolge: place.subAdministrativeArea ?? "",
        );
      }
    } catch (e) {
      debugPrint("LocationService Error: $e");
    }
    return null;
  }

  /// [Şehir Adından Konum Bilgisi Al | Search City]
  static Future<LocationModel?> getLocationFromCity(String cityName) async {
    try {
      final List<Location> locations = await locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final List<Placemark> placemarks = await placemarkFromCoordinates(loc.latitude, loc.longitude);
        
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          String city = (place.locality != null && place.locality!.isNotEmpty) 
              ? place.locality! 
              : (place.administrativeArea ?? cityName);
          return LocationModel(
            sehir: _normalizeCityName(city),
            ulke: place.country ?? "Türkiye",
            bolge: place.subAdministrativeArea ?? "",
          );
        }
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    }
    return null;
  }

  /// [Statik Şehir Listesi | Static City List]
  /// V23: Dünyadan ve Türkiye'den sembolik 10 şehir.
  static List<String> getDefaultCities() {
    return [
      'İstanbul', 'Ankara', 'İzmir', 'Bursa', 'Konya',
      'Mekke', 'Medine', 'Kudüs', 'Saraybosna', 'Bakü'
    ];
  }

  /// [Şehir Arama | Search Cities]
  static List<String> searchCities(String query) {
    final all = getTurkeyCities();
    if (query.isEmpty) return getDefaultCities();
    return all.where((c) => c.toLowerCase().contains(query.toLowerCase())).take(15).toList();
  }

  static String _normalizeCityName(String name) {
    if (name.toLowerCase().contains("istanbul")) return "İstanbul";
    if (name.toLowerCase().contains("ankara")) return "Ankara";
    // Gereksiz "Province" veya "İli" eklerini temizle - Clean "Province" or "City" suffixes
    return name.replaceAll(" Province", "").replaceAll(" İli", "").trim();
  }

  static List<String> getTurkeyCities() {
    return [
      'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Aksaray', 'Amasya', 'Ankara', 'Antalya', 'Ardahan', 'Artvin', 
      'Aydın', 'Balıkesir', 'Bartın', 'Batman', 'Bayburt', 'Bilecik', 'Bingöl', 'Bitlis', 'Bolu', 'Burdur', 
      'Bursa', 'Çanakkale', 'Çankırı', 'Çorum', 'Denizli', 'Diyarbakir', 'Düzce', 'Edirne', 'Elazığ', 'Erzincan', 
      'Erzurum', 'Eskişehir', 'Gaziantep', 'Giresun', 'Gümüşhane', 'Hakkari', 'Hatay', 'Iğdır', 'Isparta', 'İstanbul', 
      'İzmir', 'Kahramanmaraş', 'Karabük', 'Karaman', 'Kars', 'Kastamonu', 'Kayseri', 'Kilis', 'Kırıkkale', 'Kırklareli', 
      'Kırşehir', 'Kocaeli', 'Konya', 'Kütahya', 'Malatya', 'Manisa', 'Mardin', 'Mersin', 'Muğla', 'Muş', 
      'Nevşehir', 'Niğde', 'Ordu', 'Osmaniye', 'Rize', 'Sakarya', 'Samsun', 'Şanlıurfa', 'Siirt', 'Sinop', 
      'Şırnak', 'Sivas', 'Tekirdağ', 'Tokat', 'Trabzon', 'Tunceli', 'Uşak', 'Van', 'Yalova', 'Yozgat', 'Zonguldak'
    ];
  }
}
