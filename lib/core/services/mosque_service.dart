import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class MosqueItem {
  final String name;
  final double latitude;
  final double longitude;
  final double distance; // in meters
  final Map<String, dynamic> tags; // [Ekstra etiketler için - For extra tags]

  MosqueItem({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.tags = const {},
  });

  bool get isWheelchairAccessible => tags['wheelchair'] == 'yes' || tags['wheelchair'] == 'designated';
  bool get isBlindAccessible => tags['blind'] == 'yes';
}

class MosqueService {
  static List<MosqueItem> _cache = []; // [Önbellek - Cache]

  /// [Kullanıcının mevcut konumunu alır - Gets user's current position]
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  /// [Yakındaki camileri getirir (Cache destekli) - Fetches nearby mosques (Cache supported)]
  static Future<List<MosqueItem>> getNearbyMosques({bool forceRefresh = false}) async {
    // [Cache varsa ve zorunlu yenileme istenmemişse cache'den dön - Return from cache if available and not forced]
    if (!forceRefresh && _cache.isNotEmpty) {
      return _cache;
    }

    final Position? position = await getCurrentPosition();
    if (position == null) return [];

    final String query = '[out:json][timeout:15];(node["amenity"="place_of_worship"]["religion"="muslim"](around:5000,${position.latitude},${position.longitude});way["amenity"="place_of_worship"]["religion"="muslim"](around:5000,${position.latitude},${position.longitude});relation["amenity"="place_of_worship"]["religion"="muslim"](around:5000,${position.latitude},${position.longitude}););out center 100;';
    final String url = 'https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'KubbeApp/1.0'},
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List elements = (data['elements'] as List? ?? [])
            .where((e) => e['tags'] != null)
            .toList();
        
        _cache = elements.map((e) {
          final tags = e['tags'] as Map<String, dynamic>;
          final String name = tags['name'] ?? 'Bilinmeyen Cami';
          final double lat = (e['lat'] ?? (e['center'] != null ? e['center']['lat'] : 0.0)).toDouble();
          final double lon = (e['lon'] ?? (e['center'] != null ? e['center']['lon'] : 0.0)).toDouble();

          final double distance = Geolocator.distanceBetween(
            position.latitude, 
            position.longitude, 
            lat, 
            lon
          );

          return MosqueItem(
            name: name,
            latitude: lat,
            longitude: lon,
            distance: distance,
            tags: tags,
          );
        }).where((m) => m.latitude != 0.0).toList()..sort((a, b) => a.distance.compareTo(b.distance));

        return _cache;
      }
    } catch (e) {
      debugPrint('MosqueService Overpass Error: $e');
    }

    return _cache.isNotEmpty ? _cache : [];
  }

  static void clearCache() {
    _cache = [];
  }
}
