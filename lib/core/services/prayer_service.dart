// TR: KUBBE V4 Prayer Service - Modern Namaz Vakti Servisi
// EN: KUBBE V4 Prayer Service - Modern Prayer Time Service
// TR: LocationService'ten gelen veriye göre API'ler üzerinden namaz vakitlerini alır
// EN: Gets prayer times from APIs based on data from LocationService

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'location_service.dart';
import '../storage/preferences_manager.dart';

// TR: Hicri Takvim verisi modeli
// EN: Hijri Calendar data model
class HijriCalendarData {
  final int day;
  final int month;
  final int year;
  final String monthName;
  final String weekday;
  final String arabicMonthName;

  const HijriCalendarData({
    required this.day,
    required this.month,
    required this.year,
    required this.monthName,
    required this.weekday,
    required this.arabicMonthName,
  });

  // TR: JSON'dan oluştur
  // EN: Create from JSON
  factory HijriCalendarData.fromJson(Map<String, dynamic> json) {
    return HijriCalendarData(
      day: json['day'] ?? 1,
      month: json['month'] ?? 1,
      year: json['year'] ?? 1445,
      monthName: json['month_name'] ?? '',
      weekday: json['weekday'] ?? '',
      arabicMonthName: json['arabic_month_name'] ?? '',
    );
  }

  // TR: Formatlanmış tarih string'i
  // EN: Formatted date string
  String get formattedDate => '$day $monthName $year H';
  String get formattedDateArabic => '$day $arabicMonthName $year H';

  @override
  String toString() {
    return 'HijriCalendarData($formattedDate)';
  }
}

// TR: Namaz vakti verisi modeli
// EN: Prayer time data model
class PrayerTime {
  final String name;
  final String time;
  final DateTime dateTime;

  const PrayerTime({
    required this.name,
    required this.time,
    required this.dateTime,
  });

  // TR: JSON'dan oluştur
  // EN: Create from JSON
  factory PrayerTime.fromJson(
      Map<String, dynamic> json, String name, DateTime date) {
    final timeString = json[name] as String? ?? '';
    final timeParts = timeString.split(':');

    DateTime prayerDateTime;
    if (timeParts.length >= 2) {
      final hour = int.tryParse(timeParts[0]) ?? 0;
      final minute = int.tryParse(timeParts[1]) ?? 0;
      prayerDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
    } else {
      prayerDateTime = date;
    }

    return PrayerTime(
      name: name,
      time: timeString,
      dateTime: prayerDateTime,
    );
  }

  // TR: Formatlanmış zaman
  // EN: Formatted time
  String get formattedTime =>
      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  @override
  String toString() {
    return 'PrayerTime($name: $formattedTime)';
  }
}

// TR: Namaz vakitleri verisi modeli
// EN: Prayer times data model
class PrayerTimesData {
  final DateTime date;
  final LocationData location;
  final HijriCalendarData hijri;
  final PrayerTime imsak;
  final PrayerTime gunes;
  final PrayerTime ogle;
  final PrayerTime ikindi;
  final PrayerTime aksam;
  final PrayerTime yatsi;
  final DateTime timestamp;

  const PrayerTimesData({
    required this.date,
    required this.location,
    required this.hijri,
    required this.imsak,
    required this.gunes,
    required this.ogle,
    required this.ikindi,
    required this.aksam,
    required this.yatsi,
    required this.timestamp,
  });

  // TR: JSON'a dönüştür
  // EN: Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'location': location.toJson(),
      'hijri': {
        'day': hijri.day,
        'month': hijri.month,
        'year': hijri.year,
        'monthName': hijri.monthName,
        'weekday': hijri.weekday,
        'arabicMonthName': hijri.arabicMonthName,
      },
      'prayerTimes': {
        'imsak': imsak.time,
        'gunes': gunes.time,
        'ogle': ogle.time,
        'ikindi': ikindi.time,
        'aksam': aksam.time,
        'yatsi': yatsi.time,
      },
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // TR: JSON'dan oluştur
  // EN: Create from JSON
  factory PrayerTimesData.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date']);
    final location = LocationData.fromJson(json['location']);
    final hijriJson = json['hijri'] as Map<String, dynamic>;
    final prayerTimesJson = json['prayerTimes'] as Map<String, dynamic>;

    return PrayerTimesData(
      date: date,
      location: location,
      hijri: HijriCalendarData.fromJson(hijriJson),
      imsak: PrayerTime.fromJson(prayerTimesJson, 'imsak', date),
      gunes: PrayerTime.fromJson(prayerTimesJson, 'gunes', date),
      ogle: PrayerTime.fromJson(prayerTimesJson, 'ogle', date),
      ikindi: PrayerTime.fromJson(prayerTimesJson, 'ikindi', date),
      aksam: PrayerTime.fromJson(prayerTimesJson, 'aksam', date),
      yatsi: PrayerTime.fromJson(prayerTimesJson, 'yatsi', date),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // TR: Tüm namaz vakitleri listesi
  // EN: List of all prayer times
  List<PrayerTime> get allPrayerTimes => [
        imsak,
        gunes,
        ogle,
        ikindi,
        aksam,
        yatsi,
      ];

  // TR: Bir sonraki namaz vakti
  // EN: Next prayer time
  PrayerTime? get nextPrayerTime {
    final now = DateTime.now();
    final todayPrayers =
        allPrayerTimes.where((p) => p.dateTime.isAfter(now)).toList();
    return todayPrayers.isNotEmpty ? todayPrayers.first : null;
  }

  @override
  String toString() {
    return 'PrayerTimesData(date: ${date.toIso8601String()}, location: ${location.city})';
  }
}

// TR: Modern Prayer Service sınıfı
// EN: Modern Prayer Service class
class PrayerService {
  static const String _lastPrayerUpdateKey = 'lastPrayerUpdate';

  // TR: Türkiye için API URL
  // EN: API URL for Turkey
  static const String _turkeyApiUrl = 'https://ezanvakti.emushaf.net/';

  // TR: Diğer ülkeler için API URL
  // EN: API URL for other countries
  static const String _globalApiUrl =
      'https://api.aladhan.com/v1/timingsByCity';

  // TR: Namaz vakitlerini getir
  // EN: Get prayer times
  static Future<PrayerTimesData?> getPrayerTimes(LocationData location) async {
    try {
      // TR: Önce çevrimdışı veriyi kontrol et
      // EN: First check offline data
      final offlineData = await getOfflinePrayerTimes();
      if (offlineData != null && _isDataFresh(offlineData.timestamp)) {
        debugPrint('Çevrimdışı namaz vakitleri kullanılıyor');
        return offlineData;
      }

      // TR: Çevrimiçi veri al
      // EN: Get online data
      final onlineData = location.isTurkey
          ? await _getTurkeyPrayerTimes(location)
          : await _getGlobalPrayerTimes(location);

      if (onlineData != null) {
        // TR: Veriyi kaydet
        // EN: Save data
        await savePrayerTimes(onlineData);
        return onlineData;
      }

      // TR: Çevrimiçi veri alınamazsa eski çevrimdışı veriyi kullan
      // EN: Use old offline data if online data cannot be fetched
      return offlineData;
    } catch (e) {
      debugPrint('Namaz vakitleri alınamadı: $e');
      // TR: Hata durumunda çevrimdışı veriyi döndür
      // EN: Return offline data in case of error
      return await getOfflinePrayerTimes();
    }
  }

  // TR: Türkiye namaz vakitleri API'si
  // EN: Turkey prayer times API
  static Future<PrayerTimesData?> _getTurkeyPrayerTimes(
      LocationData location) async {
    try {
      final response = await http.get(
        Uri.parse('$_turkeyApiUrl?city=${Uri.encodeComponent(location.city)}'),
        headers: {
          'User-Agent': 'KUBBE-V4/1.0',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseTurkeyApiResponse(data, location);
      } else {
        debugPrint('Türkiye API Hatası: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Türkiye API isteği başarısız: $e');
      return null;
    }
  }

  // TR: Global namaz vakitleri API'si
  // EN: Global prayer times API
  static Future<PrayerTimesData?> _getGlobalPrayerTimes(
      LocationData location) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_globalApiUrl?city=${Uri.encodeComponent(location.city)}&country=${Uri.encodeComponent(location.country)}'),
        headers: {
          'User-Agent': 'KUBBE-V4/1.0',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseGlobalApiResponse(data, location);
      } else {
        debugPrint('Global API Hatası: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Global API isteği başarısız: $e');
      return null;
    }
  }

  // TR: Türkiye API yanıtını parse et
  // EN: Parse Turkey API response
  static PrayerTimesData _parseTurkeyApiResponse(
      Map<String, dynamic> data, LocationData location) {
    final today = DateTime.now();

    // TR: Hicri takvim verisi
    // EN: Hijri calendar data
    final hijriData = data['hijri'] as Map<String, dynamic>? ?? {};
    final hijri = HijriCalendarData(
      day: hijriData['day'] ?? 1,
      month: hijriData['month'] ?? 1,
      year: hijriData['year'] ?? 1445,
      monthName: hijriData['month_name'] ?? '',
      weekday: hijriData['weekday'] ?? '',
      arabicMonthName: hijriData['arabic_month_name'] ?? '',
    );

    // TR: Namaz vakitleri
    // EN: Prayer times
    final times = data['times'] as Map<String, dynamic>? ?? {};

    return PrayerTimesData(
      date: today,
      location: location,
      hijri: hijri,
      imsak: PrayerTime.fromJson(times, 'imsak', today),
      gunes: PrayerTime.fromJson(times, 'gunes', today),
      ogle: PrayerTime.fromJson(times, 'ogle', today),
      ikindi: PrayerTime.fromJson(times, 'ikindi', today),
      aksam: PrayerTime.fromJson(times, 'aksam', today),
      yatsi: PrayerTime.fromJson(times, 'yatsi', today),
      timestamp: DateTime.now(),
    );
  }

  // TR: Global API yanıtını parse et
  // EN: Parse Global API response
  static PrayerTimesData _parseGlobalApiResponse(
      Map<String, dynamic> data, LocationData location) {
    final today = DateTime.now();

    // TR: Hicri takvim verisi (simüle edilmiş)
    // EN: Hijri calendar data (simulated)
    final hijri = _calculateHijriDate(today);

    // TR: Namaz vakitleri
    // EN: Prayer times
    final timings = data['data']?['timings'] as Map<String, dynamic>? ?? {};

    return PrayerTimesData(
      date: today,
      location: location,
      hijri: hijri,
      imsak: PrayerTime.fromJson(timings, 'Fajr', today),
      gunes: PrayerTime.fromJson(timings, 'Sunrise', today),
      ogle: PrayerTime.fromJson(timings, 'Dhuhr', today),
      ikindi: PrayerTime.fromJson(timings, 'Asr', today),
      aksam: PrayerTime.fromJson(timings, 'Maghrib', today),
      yatsi: PrayerTime.fromJson(timings, 'Isha', today),
      timestamp: DateTime.now(),
    );
  }

  // TR: Basit Hicri tarih hesaplaması
  // EN: Simple Hijri date calculation
  static HijriCalendarData _calculateHijriDate(DateTime gregorianDate) {
    // TR: Bu basit bir hesaplamadır, gerçek uygulamada daha hassas bir kütüphane kullanılmalı
    // EN: This is a simple calculation, real application should use a more accurate library
    final hijriMonthNames = [
      'Muharrem',
      'Safar',
      'Rebiülevvel',
      'Rebiülahir',
      'Cemaziyelevvel',
      'Cemaziyelahir',
      'Recep',
      'Şaban',
      'Ramazan',
      'Şevval',
      'Zilkade',
      'Zilhicce'
    ];

    // TR: Yaklaşık Hicri yıl hesabı
    // EN: Approximate Hijri year calculation
    final hijriYear = (gregorianDate.year - 622) * 33 / 32;
    final hijriMonth = (gregorianDate.month - 1) % 12;
    final hijriDay = gregorianDate.day;

    return HijriCalendarData(
      day: hijriDay,
      month: hijriMonth + 1,
      year: hijriYear.round(),
      monthName: hijriMonthNames[hijriMonth],
      weekday: [
        'Pzt',
        'Sal',
        'Çar',
        'Per',
        'Cum',
        'Cmt',
        'Paz'
      ][gregorianDate.weekday - 1],
      arabicMonthName: hijriMonthNames[hijriMonth],
    );
  }

  // TR: Çevrimdışı namaz vakitlerini al
  // EN: Get offline prayer times
  static Future<PrayerTimesData?> getOfflinePrayerTimes() async {
    try {
      final prefsManager = PreferencesManager();
      final prayerTimesJson = prefsManager.getPrayerTimes();

      if (prayerTimesJson != null) {
        final data = json.decode(prayerTimesJson);
        return PrayerTimesData.fromJson(data);
      }

      return null;
    } catch (e) {
      debugPrint('Çevrimdışı namaz vakitleri alınamadı: $e');
      return null;
    }
  }

  // TR: Namaz vakitlerini kaydet
  // EN: Save prayer times
  static Future<void> savePrayerTimes(PrayerTimesData prayerTimes) async {
    try {
      final prefsManager = PreferencesManager();
      await prefsManager.setPrayerTimes(prayerTimes.toJson());

      debugPrint('Namaz vakitleri kaydedildi: ${prayerTimes.toString()}');
    } catch (e) {
      debugPrint('Namaz vakitleri kaydedilemedi: $e');
    }
  }

  // TR: Namaz vakitlerini temizle
  // EN: Clear prayer times
  static Future<void> clearPrayerTimes() async {
    try {
      final prefsManager = PreferencesManager();
      await prefsManager.setPrayerTimes({});

      debugPrint('Namaz vakitleri temizlendi');
    } catch (e) {
      debugPrint('Namaz vakitleri temizlenemedi: $e');
    }
  }

  // TR: Verinin güncel olup olmadığını kontrol et (12 saat)
  // EN: Check if data is fresh (12 hours)
  static bool _isDataFresh(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inHours < 12;
  }

  // TR: Son güncelleme zamanını al
  // EN: Get last update time
  static Future<DateTime?> getLastUpdateTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timeString = prefs.getString(_lastPrayerUpdateKey);
      return timeString != null ? DateTime.parse(timeString) : null;
    } catch (e) {
      debugPrint('Son güncelleme zamanı alınamadı: $e');
      return null;
    }
  }

  // TR: Namaz vakitlerini yenile
  // EN: Refresh prayer times
  static Future<PrayerTimesData?> refreshPrayerTimes() async {
    final location = await LocationService.getSavedLocation();
    if (location == null) {
      debugPrint('Konum bilgisi bulunamadı');
      return null;
    }

    // TR: Zorla çevrimiçi veri al
    // EN: Force online data fetch
    final onlineData = location.isTurkey
        ? await _getTurkeyPrayerTimes(location)
        : await _getGlobalPrayerTimes(location);

    if (onlineData != null) {
      await savePrayerTimes(onlineData);
      return onlineData;
    }

    return null;
  }
}
