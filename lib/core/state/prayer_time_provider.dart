import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_time_model.dart';

// [Namaz Vakti Sağlayıcısı - Prayer Time Provider]
// [Aladhan API entegrasyonu ve durum yönetimi - Aladhan API integration & state management]
class PrayerTimeProvider extends ChangeNotifier {
  PrayerTimeModel? _prayerTimes;
  PrayerTimeModel? get prayerTimes => _prayerTimes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // [API'den veri çekme - Implementation 2]
  Future<void> fetchData(String city, String country) async {
    _isLoading = true;
    notifyListeners();

    try {
      // [ENDPOINT: Diyanet metodu (13) ile Aladhan API]
      final url = Uri.parse('http://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=13');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // [Debug Log - Implementation 6]
        print('API SUCCESS: ${data['data']['timings']}');

        // [Veri Ayıklama - Implementation 3]
        final timings = data['data']['timings'];
        
        // [Hicri Tarih Ayıklama - Implementation 4]
        final hijri = data['data']['date']['hijri'];
        final hijriDateStr = "${hijri['day']} ${hijri['month']['en']} ${hijri['year']}";
        
        // [Model oluşturma ve atama - Implementation 5]
        _prayerTimes = PrayerTimeModel(
          imsak: timings['Fajr'],
          gunes: timings['Sunrise'],
          ogle: timings['Dhuhr'],
          ikindi: timings['Asr'],
          aksam: timings['Maghrib'],
          yatsi: timings['Isha'],
          hicriTarih: hijriDateStr,
          timezone: data['data']['meta']['timezone'],
        );

        // [Arayüzü bilgilendir - notifyListeners]
        notifyListeners();
      } else {
        print('API FAILED: ${response.statusCode}');
      }
    } catch (e) {
      print('API ERROR: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
