import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'quran_repository.dart';

// Kuran veri modeli - Quran data model
class QuranSurah {
  final int number; // Sure numarası - Surah number
  final String name; // Türkçe adı - Turkish name
  final String arabicName; // Arapça adı - Arabic name
  final String englishName; // İngilizce adı - English name
  final String location; // Vahiy yeri - Revelation place
  final int verseCount; // Ayet sayısı - Verse count
  final List<QuranVerse> verses; // Ayetler - Verses

  // Constructor - Yapıcı metot
  QuranSurah({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.englishName,
    required this.location,
    required this.verseCount,
    required this.verses,
  });

  // JSON'dan nesne oluşturma - Create object from JSON
  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    List<QuranVerse> versesList = [];
    if (json['verses'] != null) {
      versesList = (json['verses'] as List)
          .map((verseJson) => QuranVerse.fromJson(Map<String, dynamic>.from(verseJson))) // Safely cast map to avoid type error - Tip hatasını önlemek için güvenli dönüştürme
          .toList();
    }

    return QuranSurah(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? '',
      englishName: json['englishName'] ?? '',
      location: json['location'] ?? '',
      verseCount: json['verseCount'] ?? 0,
      verses: versesList,
    );
  }

  // Nesneyi JSON'a dönüştürme - Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'arabicName': arabicName,
      'englishName': englishName,
      'location': location,
      'verseCount': verseCount,
      'verses': verses.map((verse) => verse.toJson()).toList(),
    };
  }
}

// Kuran ayet modeli - Quran verse model
class QuranVerse {
  final int surahId; // Sure numarası - Surah ID
  final int number; // Ayet numarası - Verse number
  final String arabic; // Arapça metin - Arabic text
  final String turkish; // Türkçe meal - Turkish translation
  final String transliteration; // Latin harfleriyle okunuş - Transliteration
  final String? tafsir; // Tefsir metni - Tafsir text
  final String? audio; // Ses dosyası yolu - Audio file path
  final List<Map<String, dynamic>>? words; // Kelime detayları - Word details

  QuranVerse({
    required this.surahId,
    required this.number,
    required this.arabic,
    required this.turkish,
    required this.transliteration,
    this.tafsir,
    this.audio,
    this.words,
  });

  // JSON'dan nesne oluşturma - Create object from JSON
  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    // [Güvenli haritalama ve tür dönüşümü - Safe mapping and type conversion]
    final translationsRaw = json['translations'];
    final Map<String, dynamic> translations = translationsRaw != null 
        ? Map<String, dynamic>.from(translationsRaw is Map ? translationsRaw : {}) 
        : {};
    final trText = translations['tr'] ?? json['turkish'] ?? '';
    
    final tafsirRaw = json['tafsir'];
    final Map<String, dynamic> tafsirMap = tafsirRaw != null 
        ? Map<String, dynamic>.from(tafsirRaw is Map ? tafsirRaw : {})
        : {};
    final trTafsir = tafsirMap['tr'] ?? (tafsirRaw?.toString() ?? '');

    return QuranVerse(
      surahId: json['surahId'] ?? json['chapter'] ?? 1,
      number: json['number'] ?? 0,
      arabic: json['arabic'] ?? '',
      turkish: trText,
      transliteration: json['transliteration'] ?? '',
      tafsir: trTafsir.isNotEmpty ? trTafsir : null,
      audio: json['audio'],
      words: json['words'] != null 
          ? (json['words'] as List).map((w) => Map<String, dynamic>.from(w)).toList() 
          : null,
    );
  }

  // Nesneyi JSON'a dönüştürme - Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'surahId': surahId,
      'number': number,
      'arabic': arabic,
      '篤urkish': turkish,
      'transliteration': transliteration,
      'tafsir': tafsir,
      'audio': audio,
      'words': words,
    };
  }
}

// Kuran servisi - Quran service
class QuranService {
  static final QuranRepository _repository = QuranRepository();

  static Future<void> init() async {
    await _repository.init();
  }

  static const String _apiBaseUrl = 'https://api.quran.com/api/v4';

  // [Hafız/Okuyucu listesini getir - Fetch reciters list]
  static Future<List<Map<String, dynamic>>> fetchReciters() async {
    try {
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/resources/recitations?language=tr'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> recs = data['recitations'] ?? [];
        return recs.map((r) => Map<String, dynamic>.from(r)).toList(); // Safe map casting - Güvenli harita dönüştürme
      }
    } catch (e) {
      debugPrint('Error fetching reciters: $e');
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchVerseWords(int surahNumber) async {
    await init();
    final verses = _repository.getVerses(surahNumber);
    return verses;
  }

  // [Hafız/Sura bazlı ses URL'sini getir - Fetch audio URL based on reciter/surah]
  static Future<String?> fetchAudioUrl(int reciterId, int surahId) async {
    try {
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/chapter_recitations/$reciterId/$surahId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
          final Map<String, dynamic> audioFile = Map<String, dynamic>.from(data['audio_file'] ?? {}); // Safe map casting - Güvenli harita dönüştürme
          if (audioFile['audio_url'] != null) {
            String url = audioFile['audio_url'];
            if (!url.startsWith('http')) {
              url = 'https://verses.quran.com/$url';
            }
            return url;
          }
      }
    } catch (e) {
      debugPrint('Error fetching audio URL: $e');
    }
    return null;
  }

  // [30 Cüz başlangıç ve bitiş koordinatları - Coordinates for 30 Juz (Start/End)]
  static const Map<int, Map<String, List<int>>> _juzRanges = {
    1: {'start': [1, 1], 'end': [2, 141]},
    2: {'start': [2, 142], 'end': [2, 252]},
    3: {'start': [2, 253], 'end': [3, 92]},
    4: {'start': [3, 93], 'end': [4, 23]},
    5: {'start': [4, 24], 'end': [4, 147]},
    6: {'start': [4, 148], 'end': [5, 81]},
    7: {'start': [5, 82], 'end': [6, 110]},
    8: {'start': [6, 111], 'end': [7, 87]},
    9: {'start': [7, 88], 'end': [8, 40]},
    10: {'start': [8, 41], 'end': [9, 92]},
    11: {'start': [9, 93], 'end': [11, 5]},
    12: {'start': [11, 6], 'end': [12, 52]},
    13: {'start': [12, 53], 'end': [14, 52]},
    14: {'start': [15, 1], 'end': [16, 128]},
    15: {'start': [17, 1], 'end': [18, 74]},
    16: {'start': [18, 75], 'end': [20, 135]},
    17: {'start': [21, 1], 'end': [22, 78]},
    18: {'start': [23, 1], 'end': [25, 20]},
    19: {'start': [25, 21], 'end': [27, 55]},
    20: {'start': [27, 56], 'end': [29, 45]},
    21: {'start': [29, 46], 'end': [33, 30]},
    22: {'start': [33, 31], 'end': [36, 27]},
    23: {'start': [36, 28], 'end': [39, 31]},
    24: {'start': [39, 32], 'end': [41, 46]},
    25: {'start': [41, 47], 'end': [45, 37]},
    26: {'start': [46, 1], 'end': [51, 30]},
    27: {'start': [51, 31], 'end': [57, 29]},
    28: {'start': [58, 1], 'end': [66, 12]},
    29: {'start': [67, 1], 'end': [77, 50]},
    30: {'start': [78, 1], 'end': [114, 6]},
  };

  static int getJuzOfSurah(int surahNumber) {
    for (var entry in _juzRanges.entries) {
      int juz = entry.key;
      int startChapter = entry.value['start']![0];
      int startVerse = entry.value['start']![1];
      int endChapter = entry.value['end']![0];
      int endVerse = entry.value['end']![1];

      if (surahNumber == startChapter) {
        if (1 >= startVerse) return juz;
      } else if (surahNumber > startChapter && surahNumber < endChapter) {
        return juz;
      } else if (surahNumber == endChapter) {
        if (1 <= endVerse) return juz;
      }
    }
    return 1;
  }

  Future<List<QuranVerse>> getJuzVerses(int juzNumber) async {
    await init();
    final range = _juzRanges[juzNumber];
    if (range == null) return [];

    final startSurah = range['start']![0];
    final startAyah = range['start']![1];
    final endSurah = range['end']![0];
    final endAyah = range['end']![1];

    List<QuranVerse> result = [];

    for (int surah = startSurah; surah <= endSurah; surah++) {
      final allVerses = _repository.getVerses(surah);
      
      for (int i = 0; i < allVerses.length; i++) {
        final verseJson = allVerses[i];
        final ayahNum = i + 1;

        // Skip ayahs before the start of the juz
        if (surah == startSurah && ayahNum < startAyah) continue;
        // Stop at the last ayah of the juz
        if (surah == endSurah && ayahNum > endAyah) break;

        result.add(QuranVerse(
          surahId: surah,
          number: ayahNum,
          arabic: _repository.getVerseText(verseJson, isArabic: true),
          turkish: _repository.getVerseText(verseJson, isArabic: false),
          transliteration: _repository.getTransliteration(verseJson),
          tafsir: _repository.getTafsir(verseJson),
          words: _repository.getWords(verseJson),
        ));
      }
    }
    return result;
  }

  Future<List<String>> getSurahVerses(
    int number, {
    bool isArabic = true,
    String langCode = 'tr',
    bool isJuz = false,
    bool isLatin = false,
  }) async {
    await init();
    _repository.setLanguage(langCode);
    final verses = _repository.getVerses(number);
    
    if (isArabic) {
      return verses.map((v) => _repository.getVerseText(v, isArabic: true)).toList();
    } else if (isLatin) {
      return verses.map((v) => _repository.getTransliteration(v)).toList();
    } else {
      return verses.map((v) => _repository.getVerseText(v, isArabic: false)).toList();
    }
  }

  static bool isMakki(int surahNumber) {
    const madaniSurahs = {2, 3, 4, 5, 8, 9, 22, 24, 33, 47, 48, 49, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 76, 98, 110};
    return !madaniSurahs.contains(surahNumber);
  }

  static List<QuranSurah> getAllSurahsSync() {
    final surahDatas = _repository.getAllSurahs();
    // Safely cast map to avoid type errors - Tip hatalarını önlemek için güvenli dönüştürme
    return surahDatas.map((json) => QuranSurah.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  static Future<List<QuranSurah>> getAllSurahs() async {
    await init();
    final surahDatas = _repository.getAllSurahs();
    // Safely cast map to avoid type errors - Tip hatalarını önlemek için güvenli dönüştürme
    return surahDatas.map((json) => QuranSurah.fromJson(Map<String, dynamic>.from(json))).toList();
  }
}
