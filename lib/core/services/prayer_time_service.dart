import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/prayer_time_model.dart';

// [Namaz Vakti Servis Fabrikası - Prayer Time Service Factory]
// [TÜRKİYE: Emushaf API | GLOBAL: Aladhan API]
class PrayerTimeService {
  static const String _emushafBase = 'https://ezanvakti.emushaf.net';
  static const String _aladhanBase = 'https://api.aladhan.com/v1';

  /// [Merkezi Vakit Çekici - Centralized Prayer Times Fetcher]
  static Future<PrayerTimeModel?> getPrayerTimes({
    required String country,
    required String city,
    required String district,
    String? districtId,
    double? latitude,
    double? longitude,
    DateTime? date, // [Opsiyonel tarih desteği - Optional date support]
  }) async {
    final targetDate = date ?? DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final dateSuffix = DateFormat('yyyyMMdd').format(targetDate);
    final cacheKey = 'prayer_times_${city.toLowerCase().replaceAll(' ', '_')}_$dateSuffix';

    
    // [1. Önbellek Kontrolü - Cache Check]
    final String? cachedDataJson = prefs.getString(cacheKey);
    if (cachedDataJson != null) {
      try {
        final Map<String, dynamic> cachedMap = json.decode(cachedDataJson);
        final todayStr = DateFormat('yyyy-MM-dd').format(targetDate);
        
        if (cachedMap.containsKey(todayStr)) {
          return PrayerTimeModel.fromJson(cachedMap[todayStr]);
        }
      } catch (e) {
        debugPrint("Cache decode error: $e");
      }
    }

    // [2. Dinamik Sağlayıcı Seçimi - Dynamic Provider Selection]
    PrayerTimeModel? result;
    print("PrayerTimeService: Fetching for $city, $country..."); // [Log]
    
    if (country.toLowerCase() == 'türkiye' || country.toLowerCase() == 'turkey') {
      result = await _fetchFromEmushaf(country, city, district, districtId, targetDate);
    } else {
      result = await _fetchFromAladhan(country, city, latitude, longitude, targetDate);
    }

    if (result == null) {
      print("PrayerTimeService: FETCH FAILED for $city"); // [Hata Logu]
    } else {
      print("PrayerTimeService: FETCH OK for $city (${result.hicriTarih})"); // [Başarı Logu]
    }

    // [3. Veriyi Önbelleğe Al - Cache the Result]
    if (result != null) {
      final todayStr = DateFormat('yyyy-MM-dd').format(targetDate);

      Map<String, dynamic> cacheMap = {};
      if (cachedDataJson != null) {
        try { cacheMap = json.decode(cachedDataJson); } catch (_) {}
      }
      cacheMap[todayStr] = result.toJson();
      await prefs.setString(cacheKey, json.encode(cacheMap));
    }

    return result;
  }

  /// --- TÜRİYE SAĞLAYICISI (EMUSHAF) ---
  static Future<PrayerTimeModel?> _fetchFromEmushaf(String country, String city, String district, String? overrideId, DateTime targetDate) async {
    try {
      String? targetId = overrideId;
      if (targetId == null) {
        targetId = await _findEmushafId(country, city, district);
      }

      if (targetId != null) {
        final url = '$_emushafBase/vakitler/$targetId';
        print("Emushaf: GET $url");
        final response = await http.get(Uri.parse(url));
        print("Emushaf: STATUS ${response.statusCode}");
        
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            final targetStr = DateFormat('dd.MM.yyyy').format(targetDate);
            final dayData = data.firstWhere(
              (element) => element['MiladiTarihKisa'] == targetStr,
              orElse: () => data[0],
            );

            return PrayerTimeModel(
              imsak: dayData['Imsak'],
              gunes: dayData['Gunes'],
              ogle: dayData['Ogle'],
              ikindi: dayData['Ikindi'],
              aksam: dayData['Aksam'],
              yatsi: dayData['Yatsi'],
              hicriTarih: dayData['HicriTarihKisa'] ?? '',
              timezone: "Europe/Istanbul", 
            );
          }
        }
      } else {
        print("Emushaf: ID NOT FOUND for $city");
      }
    } catch (e) {
      print("Emushaf Error: $e");
    }
    return null;
  }

  /// --- GLOBAL SAĞLAYICI (ALADHAN) ---
  static Future<PrayerTimeModel?> _fetchFromAladhan(String country, String city, double? lat, double? lon, DateTime targetDate) async {
    try {
      Uri url;
      final dateStr = DateFormat('dd-MM-yyyy').format(targetDate);
      
      if (lat != null && lon != null) {
        url = Uri.parse('$_aladhanBase/timings/$dateStr?latitude=$lat&longitude=$lon&method=2');
      } else {
        // [Şehir araması için Aladhan'ın timingsByCity endpoint'i tarih parametresini farklı alıyor olabilir]
        // [Modern Aladhan API'da date path içinde gelmeli: /v1/timingsByCity/:date]
        url = Uri.parse('$_aladhanBase/timingsByCity/$dateStr?city=$city&country=$country&method=2');
      }

      print("Aladhan: GET $url");
      final response = await http.get(url);
      print("Aladhan: STATUS ${response.statusCode}");

      if (response.statusCode == 200) {
        final rawBody = json.decode(response.body);
        final data = rawBody['data'];
        final timings = data['timings'];
        final dateInfo = data['date'];
        final hijri = dateInfo['hijri'];
        final meta = data['meta'];

        return PrayerTimeModel(
          imsak: timings['Fajr'],
          gunes: timings['Sunrise'],
          ogle: timings['Dhuhr'],
          ikindi: timings['Asr'],
          aksam: timings['Maghrib'],
          yatsi: timings['Isha'],
          hicriTarih: "${hijri['day']} ${_getHijriMonthTr(int.parse(hijri['month']['number'].toString()))} ${hijri['year']}",
          timezone: meta['timezone'], 
        );
      }
    } catch (e) {
      print("Aladhan Error: $e");
    }
    return null;
  }

  /// --- HİCRİ AY TÜRKÇELEŞTİRİCİ ---
  static String _getHijriMonthTr(int month) {
    final months = [
      'Muharrem', 'Safer', 'Rebiülevvel', 'Rebiülahir', 'Cemaziyelevvel', 'Cemaziyelahir',
      'Recep', 'Şaban', 'Ramazan', 'Şevval', 'Zilkade', 'Zilhicce'
    ];
    if (month < 1 || month > 12) return "Aylar";
    return months[month - 1];
  }

  /// --- EMUSHAF ID BULUCU (ARDIL ARAMA) ---
  static Future<String?> _findEmushafId(String countryName, String cityName, String districtName) async {
    try {
      // [Normalizasyon fonksiyonu - Normalization function]
      String normalize(String s) => s.toLowerCase()
        .replaceAll('ı', 'i').replaceAll('ğ', 'g').replaceAll('ü', 'u')
        .replaceAll('ş', 's').replaceAll('ö', 'o').replaceAll('ç', 'c')
        .trim();

      final normCity = normalize(cityName);

      // 1. Ülke ID - Country ID
      final countriesRes = await http.get(Uri.parse('$_emushafBase/ulkeler'));
      final nations = json.decode(countriesRes.body) as List;
      final nation = nations.firstWhere(
        (n) {
          final nName = normalize(n['UlkeAd'].toString());
          final nEn = normalize(n['UlkeAdEn'].toString());
          final target = normalize(countryName);
          return nName == target || nEn == target;
        },
        orElse: () => nations.firstWhere((n) => n['UlkeAd'] == "TÜRKİYE"),
      );
      final nationId = nation['UlkeID'];

      // 2. Şehir ID - City ID
      final citiesRes = await http.get(Uri.parse('$_emushafBase/sehirler/$nationId'));
      final cities = json.decode(citiesRes.body) as List;
      final city = cities.firstWhere(
        (c) {
          final cName = normalize(c['SehirAd'].toString());
          final cEn = normalize(c['SehirAdEn'].toString());
          return cName == normCity || cEn == normCity;
        },
        orElse: () => cities.firstWhere((c) => normalize(c['SehirAd'].toString()) == "istanbul"),
      );
      final cityId = city['SehirID'];

      // 3. İlçe ID - District ID
      final districtsRes = await http.get(Uri.parse('$_emushafBase/ilceler/$cityId'));
      final districts = json.decode(districtsRes.body) as List;
      
      final normDist = normalize(districtName);
      final district = districts.firstWhere(
        (d) {
          final dName = normalize(d['IlceAd'].toString());
          final dEn = normalize(d['IlceAdEn'].toString());
          return dName == normDist || dEn == normDist || dName == normCity;
        },
        orElse: () => districts[0],
      );
      return district['IlceID'].toString();
    } catch (e) {
      print("ID Finder Error: $e");
      return null;
    }
  }
}
