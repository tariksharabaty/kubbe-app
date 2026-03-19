// TR: KUBBE V4 Prayer Service - V1'den miras alındı ve modernize edildi
// EN: KUBBE V4 Prayer Service - Inherited from V1 and modernized
import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:kubbe/core/services/location_service.dart';
import '../storage/preferences_manager.dart';

/// TR: KUBBE V4 Prayer Service Sınıfı
/// EN: KUBBE V4 Prayer Service Class
class PrayerService {
  // TR: Türkiye sınırları koordinatları - Düzeltilmiş V1 mantığı
  // EN: Turkey border coordinates - Corrected V1 logic
  static const double _turkeyNorth = 42.12;
  static const double _turkeySouth = 35.81;
  static const double _turkeyWest = 25.66;
  static const double _turkeyEast = 44.82;

  // TR: Vakit hesaplama metodu - 'adhan' paketi v2.0+ ile güncellendi
  // EN: Prayer times calculation method - Updated with 'adhan' package v2.0+
  static PrayerTimes calculatePrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? date,
  }) {
    final calculationDate = date ?? DateTime.now();
    final coordinates = Coordinates(latitude, longitude);

    // TR: Türkiye için Diyanet metodunu kullan
    // EN: Use Diyanet method for Turkey
    final params = CalculationParameters(
      fajrAngle: 18.0,
      ishaAngle: 17.0,
      method: CalculationMethod.turkey,
      madhab: Madhab.shafi,
    );

    return PrayerTimes(
      coordinates,
      DateComponents.from(calculationDate),
      params,
    );
  }

  // TR: Türkiye sınırları içinde mi kontrolü
  // EN: Check if within Turkey borders
  static bool _isWithinTurkey(double latitude, double longitude) {
    return latitude >= _turkeySouth &&
        latitude <= _turkeyNorth &&
        longitude >= _turkeyWest &&
        longitude <= _turkeyEast;
  }

  // TR: Mevcut konum için vakitleri al
  // EN: Get prayer times for current location
  static Future<PrayerTimes?> getCurrentPrayerTimes() async {
    try {
      final position = await LocationService.getCurrentPosition();
      return calculatePrayerTimes(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      if (kDebugMode) {
        print('TR: Mevcut konum vakitleri alınamadı: $e');
        print('EN: Failed to get current prayer times: $e');
      }
      return null;
    }
  }

  // TR: Belirli tarih ve konum için vakitleri al
  // EN: Get prayer times for specific date and location
  static PrayerTimes? getPrayerTimesForDate({
    required DateTime date,
    required double latitude,
    required double longitude,
  }) {
    try {
      return calculatePrayerTimes(
        latitude: latitude,
        longitude: longitude,
        date: date,
      );
    } catch (e) {
      return null;
    }
  }

  // TR: Bugünkü namaz vakitlerini kayıtlı konumla al
  // EN: Get today's prayer times with saved location
  static Future<PrayerTimes?> getTodayPrayerTimes() async {
    try {
      final location = await PreferencesManager.getLastKnownLocation();
      final latitude = location.$1;
      final longitude = location.$2;

      if (latitude == null || longitude == null) {
        return null;
      }

      return calculatePrayerTimes(latitude: latitude, longitude: longitude);
    } catch (e) {
      return null;
    }
  }

  // TR: Sonraki vakti al - 'adhan' paketinin modern metodu ile
  // EN: Get next prayer - With modern method from 'adhan' package
  static Prayer getNextPrayerTime(PrayerTimes prayerTimes) {
    return prayerTimes.nextPrayer();
  }

  // TR: Sonraki vakite kalan süreyi hesapla
  // EN: Calculate time remaining until next prayer
  static Duration getTimeUntilNextPrayer(PrayerTimes prayerTimes) {
    final nextPrayer = getNextPrayerTime(prayerTimes);
    DateTime? nextPrayerTime;

    // TR: Eğer sonraki vakit İmsak ise, yarınki İmsak'ı al
    // EN: If next prayer is Fajr, get tomorrow's Fajr
    if (nextPrayer == Prayer.fajr) {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowPrayerTimes = calculatePrayerTimes(
        latitude: prayerTimes.coordinates.latitude,
        longitude: prayerTimes.coordinates.longitude,
        date: tomorrow,
      );
      nextPrayerTime = tomorrowPrayerTimes.fajr;
    } else {
      final prayerTime = prayerTimes.timeForPrayer(nextPrayer);
      if (prayerTime != null) {
        nextPrayerTime = prayerTime;
      }
    }

    return nextPrayerTime!.difference(DateTime.now());
  }

  // TR: Mevcut vakti al - 'adhan' paketinin modern metodu ile
  // EN: Get current prayer - With modern method from 'adhan' package
  static Prayer getCurrentPrayer(PrayerTimes prayerTimes) {
    return prayerTimes.currentPrayer();
  }

  // TR: Vakit zamanını formatla
  // EN: Format prayer time for display
  static String formatPrayerTime(DateTime? time) {
    if (time == null) return '--:--';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // TR: Namaz adını Türkçe olarak al
  // EN: Get prayer name in Turkish
  static String getPrayerNameTurkish(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'İmsak';
      case Prayer.sunrise:
        return 'Güneş';
      case Prayer.dhuhr:
        return 'Öğle';
      case Prayer.asr:
        return 'İkindi';
      case Prayer.maghrib:
        return 'Akşam';
      case Prayer.isha:
        return 'Yatsı';
      case Prayer.none:
        return 'Vakit Yok';
    }
  }

  // TR: Hesaplama metodu adını al
  // EN: Get calculation method name
  static Future<String> getCalculationMethodName() async {
    final location = await PreferencesManager.getLastKnownLocation();
    final latitude = location.$1;
    final longitude = location.$2;

    if (latitude == null || longitude == null) {
      return 'Bilinmiyor';
    }

    return _isWithinTurkey(latitude, longitude) ? 'Diyanet' : 'MWL';
  }

  // TR: Konumu kaydet ve vakitleri hesapla
  // EN: Save location and calculate prayer times
  static Future<PrayerTimes?> saveLocationAndCalculate({
    required double latitude,
    required double longitude,
    String? cityName,
  }) async {
    final prefs = PreferencesManager();
    await prefs.setLastKnownLocation(latitude, longitude);
    if (cityName != null) {
      await prefs.setSelectedCity(cityName);
    }
    return calculatePrayerTimes(latitude: latitude, longitude: longitude);
  }

  // TR: Konum için kıble yönünü al
  // EN: Get Qibla direction for location
  static double getQiblaDirection(double latitude, double longitude) {
    final coordinates = Coordinates(latitude, longitude);
    return Qibla(coordinates).direction;
  }

  // TR: Ay vakitlerini al
  // EN: Get month prayer times
  static List<PrayerTimes> getMonthPrayerTimes({
    required DateTime month,
    required double latitude,
    required double longitude,
  }) {
    final prayerTimesList = <PrayerTimes>[];
    final year = month.year;
    final monthNumber = month.month;
    final daysInMonth = DateTime(year, monthNumber + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, monthNumber, day);
      final prayerTimes = getPrayerTimesForDate(
        date: date,
        latitude: latitude,
        longitude: longitude,
      );
      if (prayerTimes != null) {
        prayerTimesList.add(prayerTimes);
      }
    }
    return prayerTimesList;
  }

  // TR: Vakit detaylarını al
  // EN: Get prayer details
  static PrayerDetail? getPrayerDetail(PrayerTimes prayerTimes, Prayer prayer) {
    final prayerTime = prayerTimes.timeForPrayer(prayer);
    if (prayerTime == null) return null;

    return PrayerDetail(
      prayer: prayer,
      turkishName: getPrayerNameTurkish(prayer),
      time: prayerTime,
      formattedTime: formatPrayerTime(prayerTime),
      isNext: getNextPrayerTime(prayerTimes) == prayer,
      isCurrent: getCurrentPrayer(prayerTimes) == prayer,
      timeUntilNext: getTimeUntilNextPrayer(prayerTimes),
    );
  }

  // TR: Tüm vakit detaylarını al
  // EN: Get all prayer details
  static List<PrayerDetail> getAllPrayerDetails(PrayerTimes prayerTimes) {
    return Prayer.values.where((p) => p != Prayer.none).map((prayer) {
      final prayerTime = prayerTimes.timeForPrayer(prayer);
      return PrayerDetail(
        prayer: prayer,
        turkishName: getPrayerNameTurkish(prayer),
        time: prayerTime ?? DateTime.now(),
        formattedTime: formatPrayerTime(prayerTime),
        isNext: getNextPrayerTime(prayerTimes) == prayer,
        isCurrent: getCurrentPrayer(prayerTimes) == prayer,
        timeUntilNext: getTimeUntilNextPrayer(prayerTimes),
      );
    }).toList();
  }
}

// Data models...
class PrayerTimeData {
  final Prayer prayer;
  final DateTime time;
  final String name;
  final bool isNext;
  final Duration? timeRemaining;

  PrayerTimeData({
    required this.prayer,
    required this.time,
    required this.name,
    this.isNext = false,
    this.timeRemaining,
  });

  factory PrayerTimeData.fromPrayerTimes(
    PrayerTimes prayerTimes,
    Prayer prayer, {
    bool isNext = false,
    Duration? timeRemaining,
  }) {
    final time = prayerTimes.timeForPrayer(prayer);
    return PrayerTimeData(
      prayer: prayer,
      time: time ?? DateTime.now(),
      name: PrayerService.getPrayerNameTurkish(prayer),
      isNext: isNext,
      timeRemaining: timeRemaining,
    );
  }
  String get formattedTime => PrayerService.formatPrayerTime(time);
}

class DailyPrayerSchedule {
  final DateTime date;
  final PrayerTimes prayerTimes;
  final List<PrayerTimeData> prayerTimesList;
  final Prayer currentPrayer;
  final Prayer nextPrayer;
  final Duration? timeUntilNext;

  DailyPrayerSchedule({
    required this.date,
    required this.prayerTimes,
    required this.prayerTimesList,
    required this.currentPrayer,
    required this.nextPrayer,
    this.timeUntilNext,
  });

  factory DailyPrayerSchedule.fromPrayerTimes(PrayerTimes prayerTimes) {
    final prayerTimesList =
        Prayer.values.where((p) => p != Prayer.none).map((prayer) {
      return PrayerTimeData.fromPrayerTimes(prayerTimes, prayer);
    }).toList();

    return DailyPrayerSchedule(
      date: DateTime.now(),
      prayerTimes: prayerTimes,
      prayerTimesList: prayerTimesList,
      currentPrayer: prayerTimes.currentPrayer(),
      nextPrayer: prayerTimes.nextPrayer(),
      timeUntilNext: PrayerService.getTimeUntilNextPrayer(prayerTimes),
    );
  }
}

class PrayerDetail {
  final Prayer prayer;
  final String turkishName;
  final DateTime time;
  final String formattedTime;
  final bool isNext;
  final bool isCurrent;
  final Duration? timeUntilNext;

  PrayerDetail({
    required this.prayer,
    required this.turkishName,
    required this.time,
    required this.formattedTime,
    this.isNext = false,
    this.isCurrent = false,
    this.timeUntilNext,
  });
}
