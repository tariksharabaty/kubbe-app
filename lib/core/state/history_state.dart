import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryData {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final int pageNumber;

  HistoryData({
    this.surahNumber = 1,
    this.ayahNumber = 1,
    this.surahName = 'Fatiha',
    this.pageNumber = 1,
  });
}

final ValueNotifier<HistoryData> globalHistoryState = ValueNotifier(HistoryData());

Future<void> updateHistoryProgress({
  required int surahNumber,
  required int ayahNumber,
  required String surahName,
  int pageNumber = 1,
}) async {
  globalHistoryState.value = HistoryData(
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    surahName: surahName,
    pageNumber: pageNumber,
  );
  
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('last_read_surah', surahNumber);
  await prefs.setInt('last_read_ayah', ayahNumber);
  await prefs.setString('last_read_surah_name', surahName);
  await prefs.setInt('last_read_page', pageNumber);
}
