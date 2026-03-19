// TR: KUBBE V4 Location Service - Modern Konum Servisi
// EN: KUBBE V4 Location Service - Modern Location Service
// TR: GPS otomatik konum alma ve manuel şehir seçimi
// EN: GPS automatic location detection and manual city selection

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/preferences_manager.dart';

// TR: Konum verisi modeli
// EN: Location data model
class LocationData {
  final double latitude;
  final double longitude;
  final String city;
  final String country;
  final String countryCode;
  final bool isManual;
  final DateTime timestamp;

  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.countryCode,
    required this.isManual,
    required this.timestamp,
  });

  // TR: JSON'a dönüştür
  // EN: Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
      'countryCode': countryCode,
      'isManual': isManual,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // TR: JSON'dan oluştur
  // EN: Create from JSON
  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      countryCode: json['countryCode'] ?? '',
      isManual: json['isManual'] ?? false,
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  // TR: Ülkenin Türkiye olup olmadığını kontrol et
  // EN: Check if country is Turkey
  bool get isTurkey =>
      countryCode.toUpperCase() == 'TR' ||
      country.toLowerCase().contains('turkey');

  @override
  String toString() {
    return 'LocationData(city: $city, country: $country, lat: $latitude, lng: $longitude, manual: $isManual)';
  }
}

// TR: Şehir verisi modeli
// EN: City data model
class CityData {
  final String name;
  final String country;
  final String countryCode;
  final double latitude;
  final double longitude;

  const CityData({
    required this.name,
    required this.country,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });
}

// TR: Modern Location Service sınıfı
// EN: Modern Location Service class
class LocationService {
  static const String _latitudeKey = 'lastKnownLatitude';
  static const String _longitudeKey = 'lastKnownLongitude';
  static const String _cityKey = 'selectedCity';
  static const String _countryKey = 'selectedCountry';
  static const String _countryCodeKey = 'selectedCountryCode';
  static const String _isManualKey = 'isManualLocation';
  static const String _locationTimestampKey = 'locationTimestamp';

  // TR: Popüler Türk şehirleri
  // EN: Popular Turkish cities
  static const List<CityData> turkishCities = [
    CityData(
        name: 'İstanbul',
        country: 'Turkey',
        countryCode: 'TR',
        latitude: 41.0082,
        longitude: 28.9784),
    CityData(
        name: 'Ankara',
        country: 'Turkey',
        countryCode: 'TR',
        latitude: 39.9334,
        longitude: 32.8597),
    CityData(
        name: 'İzmir',
        country: 'Turkey',
        countryCode: 'TR',
        latitude: 38.4237,
        longitude: 27.1428),
    CityData(
        name: 'Bursa',
        country: 'Turkey',
        countryCode: 'TR',
        latitude: 40.1885,
        longitude: 29.0610),
    CityData(
        name: 'Adana',
        country: 'Turkey',
        countryCode: 'TR',
        latitude: 37.0000,
        longitude: 35.3213),
    CityData(
        name: 'Antalya',
        country: 'Turkey',
        countryCode: 'TR',
        latitude: 36.8841,
        longitude: 30.7056),
    CityData(
        name: 'Konya',
        country: 'Turkey',
        countryCode: 'TR',
        latitude: 37.8713,
        longitude: 32.4846),
    CityData(
        name: 'Gaziantep',
        country: 'Turkey',
        countryCode: 'TR',
        latitude: 37.0662,
        longitude: 37.3833),
  ];

  // TR: Konum izinlerini kontrol et
  // EN: Check location permissions
  static Future<bool> hasLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // TR: Konum servisi aktif mi
    // EN: Is location service enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // TR: Konum izni kontrolü
    // EN: Location permission check
    permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // TR: Konum izni iste
  // EN: Request location permission
  static Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // TR: Konum servisi aktif mi
    // EN: Is location service enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // TR: Konum servislerini açmaya iste
      // EN: Request to open location services
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        return false;
      }
    }

    // TR: Konum izni iste
    // EN: Request location permission
    permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // TR: GPS üzerinden otomatik konum al
  // EN: Get automatic location via GPS
  static Future<LocationData?> getCurrentLocation() async {
    try {
      // TR: Konum izni kontrolü
      // EN: Check location permission
      if (!await hasLocationPermission()) {
        if (!await requestLocationPermission()) {
          throw Exception('Konum izni verilmedi');
        }
      }

      // TR: Mevcut konumu al
      // EN: Get current location
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      // TR: Adres bilgisini al
      // EN: Get address information
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final locationData = LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          city: place.locality ??
              place.subAdministrativeArea ??
              'Bilinmeyen Şehir',
          country: place.country ?? 'Bilinmeyen Ülke',
          countryCode: place.isoCountryCode ?? 'XX',
          isManual: false,
          timestamp: DateTime.now(),
        );

        // TR: Konumu kaydet
        // EN: Save location
        await saveLocationData(locationData);
        return locationData;
      }

      return null;
    } catch (e) {
      debugPrint('Konum alınamadı: $e');
      return null;
    }
  }

  // TR: Manuel şehir seçimi
  // EN: Manual city selection
  static Future<LocationData> selectManualCity(CityData cityData) async {
    final locationData = LocationData(
      latitude: cityData.latitude,
      longitude: cityData.longitude,
      city: cityData.name,
      country: cityData.country,
      countryCode: cityData.countryCode,
      isManual: true,
      timestamp: DateTime.now(),
    );

    // TR: Konumu kaydet
    // EN: Save location
    await saveLocationData(locationData);
    return locationData;
  }

  // TR: Kaydedilmiş konum verisini al
  // EN: Get saved location data
  static Future<LocationData?> getSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final latitude = prefs.getDouble(_latitudeKey);
      final longitude = prefs.getDouble(_longitudeKey);
      final city = prefs.getString(_cityKey);
      final country = prefs.getString(_countryKey);
      final countryCode = prefs.getString(_countryCodeKey);
      final isManual = prefs.getBool(_isManualKey) ?? false;
      final timestampString = prefs.getString(_locationTimestampKey);

      if (latitude != null &&
          longitude != null &&
          city != null &&
          country != null &&
          countryCode != null &&
          timestampString != null) {
        return LocationData(
          latitude: latitude,
          longitude: longitude,
          city: city,
          country: country,
          countryCode: countryCode,
          isManual: isManual,
          timestamp: DateTime.parse(timestampString),
        );
      }

      return null;
    } catch (e) {
      debugPrint('Kaydedilmiş konum alınamadı: $e');
      return null;
    }
  }

  // TR: Konum verisini kaydet
  // EN: Save location data
  static Future<void> saveLocationData(LocationData locationData) async {
    try {
      final prefsManager = PreferencesManager();
      await prefsManager.setLocationData(locationData.toJson());

      debugPrint('Konum verisi kaydedildi: ${locationData.toString()}');
    } catch (e) {
      debugPrint('Konum verisi kaydedilemedi: $e');
    }
  }

  // TR: Konum verisini temizle
  // EN: Clear location data
  static Future<void> clearLocationData() async {
    try {
      final prefsManager = PreferencesManager();
      await prefsManager.setLocationData({});

      debugPrint('Konum verisi temizlendi');
    } catch (e) {
      debugPrint('Konum verisi temizlenemedi: $e');
    }
  }

  // TR: Konum verisinin güncel olup olmadığını kontrol et (24 saat)
  // EN: Check if location data is fresh (24 hours)
  static Future<bool> isLocationDataFresh() async {
    final locationData = await getSavedLocation();
    if (locationData == null) return false;

    final now = DateTime.now();
    final difference = now.difference(locationData.timestamp);
    return difference.inHours < 24;
  }
}
