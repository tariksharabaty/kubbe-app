import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

class QuranRepository {
  static final QuranRepository _instance = QuranRepository._internal();
  factory QuranRepository() => _instance;
  QuranRepository._internal();

  final Map<int, List<Map<String, dynamic>>> _versesMap = {};
  String _activeLanguage = 'tr';
  bool _isInit = false;

  // [Full 114 Surah Metadata - Instant Metadata Load]
  static const List<Map<String, dynamic>> _surahMetadata = [
    {"number": 1, "name": "Fâtiha", "arabicName": "الفاتحة", "englishName": "Al-Fatiha", "location": "Mekke", "verseCount": 7},
    {"number": 2, "name": "Bakara", "arabicName": "البقرة", "englishName": "Al-Baqara", "location": "Medine", "verseCount": 286},
    {"number": 3, "name": "Âl-i İmrân", "arabicName": "آل عمران", "englishName": "Aal-i-Imran", "location": "Medine", "verseCount": 200},
    {"number": 4, "name": "Nisâ", "arabicName": "النساء", "englishName": "An-Nisa", "location": "Medine", "verseCount": 176},
    {"number": 5, "name": "Mâide", "arabicName": "المائدة", "englishName": "Al-Ma'idah", "location": "Medine", "verseCount": 120},
    {"number": 6, "name": "En'âm", "arabicName": "الأنعام", "englishName": "Al-An'am", "location": "Mekke", "verseCount": 165},
    {"number": 7, "name": "A'râf", "arabicName": "الأعراف", "englishName": "Al-A'raf", "location": "Mekke", "verseCount": 206},
    {"number": 8, "name": "Enfâl", "arabicName": "الأنفال", "englishName": "Al-Anfal", "location": "Medine", "verseCount": 75},
    {"number": 9, "name": "Tevbe", "arabicName": "التوبة", "englishName": "At-Tawbah", "location": "Medine", "verseCount": 129},
    {"number": 10, "name": "Yûnus", "arabicName": "يونس", "englishName": "Yunus", "location": "Mekke", "verseCount": 109},
    {"number": 11, "name": "Hûd", "arabicName": "هود", "englishName": "Hud", "location": "Mekke", "verseCount": 123},
    {"number": 12, "name": "Yûsuf", "arabicName": "يوسف", "englishName": "Yusuf", "location": "Mekke", "verseCount": 111},
    {"number": 13, "name": "Ra'd", "arabicName": "الرعد", "englishName": "Ar-Ra'd", "location": "Medine", "verseCount": 43},
    {"number": 14, "name": "İbrâhîm", "arabicName": "إبراهيم", "englishName": "Ibrahim", "location": "Mekke", "verseCount": 52},
    {"number": 15, "name": "Hicr", "arabicName": "الحجر", "englishName": "Al-Hijr", "location": "Mekke", "verseCount": 99},
    {"number": 16, "name": "Nahl", "arabicName": "النحل", "englishName": "An-Nahl", "location": "Mekke", "verseCount": 128},
    {"number": 17, "name": "İsrâ", "arabicName": "الإسراء", "englishName": "Al-Isra", "location": "Mekke", "verseCount": 111},
    {"number": 18, "name": "Kehf", "arabicName": "الكهف", "englishName": "Al-Kahf", "location": "Mekke", "verseCount": 110},
    {"number": 19, "name": "Meryem", "arabicName": "مريم", "englishName": "Maryam", "location": "Mekke", "verseCount": 98},
    {"number": 20, "name": "Tâhâ", "arabicName": "طه", "englishName": "Ta-Ha", "location": "Mekke", "verseCount": 135},
    {"number": 21, "name": "Enbiyâ", "arabicName": "الأنبياء", "englishName": "Al-Anbiya", "location": "Mekke", "verseCount": 112},
    {"number": 22, "name": "Hac", "arabicName": "الحج", "englishName": "Al-Hajj", "location": "Medine", "verseCount": 78},
    {"number": 23, "name": "Mü'minûn", "arabicName": "المؤمنون", "englishName": "Al-Mu'minun", "location": "Mekke", "verseCount": 118},
    {"number": 24, "name": "Nûr", "arabicName": "النور", "englishName": "An-Nur", "location": "Medine", "verseCount": 64},
    {"number": 25, "name": "Furkân", "arabicName": "الفرقان", "englishName": "Al-Furqan", "location": "Mekke", "verseCount": 77},
    {"number": 26, "name": "Şuarâ", "arabicName": "الشعراء", "englishName": "Ash-Shu'ara", "location": "Mekke", "verseCount": 227},
    {"number": 27, "name": "Neml", "arabicName": "النمل", "englishName": "An-Naml", "location": "Mekke", "verseCount": 93},
    {"number": 28, "name": "Kasas", "arabicName": "القصص", "englishName": "Al-Qasas", "location": "Mekke", "verseCount": 88},
    {"number": 29, "name": "Ankebût", "arabicName": "العنكبوت", "englishName": "Al-Ankabut", "location": "Mekke", "verseCount": 69},
    {"number": 30, "name": "Rûm", "arabicName": "الروم", "englishName": "Ar-Rum", "location": "Mekke", "verseCount": 60},
    {"number": 31, "name": "Lokmân", "arabicName": "لقمان", "englishName": "Luqman", "location": "Mekke", "verseCount": 34},
    {"number": 32, "name": "Secde", "arabicName": "السجدة", "englishName": "As-Sajdah", "location": "Mekke", "verseCount": 30},
    {"number": 33, "name": "Ahzâb", "arabicName": "الأحزاب", "englishName": "Al-Ahzab", "location": "Medine", "verseCount": 73},
    {"number": 34, "name": "Sebe'", "arabicName": "سبأ", "englishName": "Saba", "location": "Mekke", "verseCount": 54},
    {"number": 35, "name": "Fâtır", "arabicName": "فاطر", "englishName": "Fatir", "location": "Mekke", "verseCount": 45},
    {"number": 36, "name": "Yâsîn", "arabicName": "يس", "englishName": "Ya-Sin", "location": "Mekke", "verseCount": 83},
    {"number": 37, "name": "Sâffât", "arabicName": "الصافات", "englishName": "As-Saffat", "location": "Mekke", "verseCount": 182},
    {"number": 38, "name": "Sâd", "arabicName": "ص", "englishName": "Sad", "location": "Mekke", "verseCount": 88},
    {"number": 39, "name": "Zümer", "arabicName": "الزمر", "englishName": "Az-Zumar", "location": "Mekke", "verseCount": 75},
    {"number": 40, "name": "Mü'min (Gâfir)", "arabicName": "غافر", "englishName": "Ghafir", "location": "Mekke", "verseCount": 85},
    {"number": 41, "name": "Fussilet", "arabicName": "فصلت", "englishName": "Fussilat", "location": "Mekke", "verseCount": 54},
    {"number": 42, "name": "Şûrâ", "arabicName": "الشورى", "englishName": "Ash-Shura", "location": "Mekke", "verseCount": 53},
    {"number": 43, "name": "Zuhruf", "arabicName": "الزخرف", "englishName": "Az-Zukhruf", "location": "Mekke", "verseCount": 89},
    {"number": 44, "name": "Duhân", "arabicName": "الدخان", "englishName": "Ad-Dukhan", "location": "Mekke", "verseCount": 59},
    {"number": 45, "name": "Câsiye", "arabicName": "الجاثية", "englishName": "Al-Jathiyah", "location": "Mekke", "verseCount": 37},
    {"number": 46, "name": "Ahkâf", "arabicName": "الأحقاف", "englishName": "Al-Ahqaf", "location": "Mekke", "verseCount": 35},
    {"number": 47, "name": "Muhammed", "arabicName": "محمد", "englishName": "Muhammad", "location": "Medine", "verseCount": 38},
    {"number": 48, "name": "Fetih", "arabicName": "الفتح", "englishName": "Al-Fath", "location": "Medine", "verseCount": 29},
    {"number": 49, "name": "Hucurât", "arabicName": "الحجرات", "englishName": "Al-Hujurat", "location": "Medine", "verseCount": 18},
    {"number": 50, "name": "Kâf", "arabicName": "ق", "englishName": "Qaf", "location": "Mekke", "verseCount": 45},
    {"number": 51, "name": "Zâriyât", "arabicName": "الذاريات", "englishName": "Ad-Dhariyat", "location": "Mekke", "verseCount": 60},
    {"number": 52, "name": "Tûr", "arabicName": "الطور", "englishName": "At-Tur", "location": "Mekke", "verseCount": 49},
    {"number": 53, "name": "Necm", "arabicName": "النجم", "englishName": "An-Najm", "location": "Mekke", "verseCount": 62},
    {"number": 54, "name": "Kamer", "arabicName": "القمر", "englishName": "Al-Qamar", "location": "Mekke", "verseCount": 55},
    {"number": 55, "name": "Rahmân", "arabicName": "الرحمن", "englishName": "Ar-Rahman", "location": "Medine", "verseCount": 78},
    {"number": 56, "name": "Vâkıa", "arabicName": "الواقعة", "englishName": "Al-Waqi'ah", "location": "Mekke", "verseCount": 96},
    {"number": 57, "name": "Hadîd", "arabicName": "الحديد", "englishName": "Al-Hadid", "location": "Medine", "verseCount": 29},
    {"number": 58, "name": "Mücâdele", "arabicName": "المجادلة", "englishName": "Al-Mujadila", "location": "Medine", "verseCount": 22},
    {"number": 59, "name": "Haşr", "arabicName": "الحشر", "englishName": "Al-Hashr", "location": "Medine", "verseCount": 24},
    {"number": 60, "name": "Mümtehine", "arabicName": "الممتحنة", "englishName": "Al-Mumtahanah", "location": "Medine", "verseCount": 13},
    {"number": 61, "name": "Saff", "arabicName": "الصف", "englishName": "As-Saff", "location": "Medine", "verseCount": 14},
    {"number": 62, "name": "Cum'a", "arabicName": "الجمعة", "englishName": "Al-Jumu'ah", "location": "Medine", "verseCount": 11},
    {"number": 63, "name": "Münâfikûn", "arabicName": "المنافقون", "englishName": "Al-Munafiqun", "location": "Medine", "verseCount": 11},
    {"number": 64, "name": "Teğâbün", "arabicName": "التغابن", "englishName": "At-Taghabun", "location": "Medine", "verseCount": 18},
    {"number": 65, "name": "Talâk", "arabicName": "الطلاق", "englishName": "At-Talaq", "location": "Medine", "verseCount": 12},
    {"number": 66, "name": "Tahrîm", "arabicName": "التحريم", "englishName": "At-Tahrim", "location": "Medine", "verseCount": 12},
    {"number": 67, "name": "Mülk", "arabicName": "الملك", "englishName": "Al-Mulk", "location": "Mekke", "verseCount": 30},
    {"number": 68, "name": "Kalem", "arabicName": "القلم", "englishName": "Al-Qalam", "location": "Mekke", "verseCount": 52},
    {"number": 69, "name": "Hâkka", "arabicName": "الحاقة", "englishName": "Al-Haqqah", "location": "Mekke", "verseCount": 52},
    {"number": 70, "name": "Meâric", "arabicName": "المعارج", "englishName": "Al-Ma'arij", "location": "Mekke", "verseCount": 44},
    {"number": 71, "name": "Nûh", "arabicName": "نوح", "englishName": "Nuh", "location": "Mekke", "verseCount": 28},
    {"number": 72, "name": "Cin", "arabicName": "الجن", "englishName": "Al-Jinn", "location": "Mekke", "verseCount": 28},
    {"number": 73, "name": "Müzzemmil", "arabicName": "المزمل", "englishName": "Al-Muzzammil", "location": "Mekke", "verseCount": 20},
    {"number": 74, "name": "Müddessir", "arabicName": "المدثر", "englishName": "Al-Muddaththir", "location": "Mekke", "verseCount": 56},
    {"number": 75, "name": "Kıyâmet", "arabicName": "القيامة", "englishName": "Al-Qiyamah", "location": "Mekke", "verseCount": 40},
    {"number": 76, "name": "İnsân", "arabicName": "الإنسان", "englishName": "Al-Insan", "location": "Medine", "verseCount": 31},
    {"number": 77, "name": "Mürselât", "arabicName": "المرسلات", "englishName": "Al-Mursalat", "location": "Mekke", "verseCount": 50},
    {"number": 78, "name": "Nebe'", "arabicName": "النبأ", "englishName": "An-Naba", "location": "Mekke", "verseCount": 40},
    {"number": 79, "name": "Nâziât", "arabicName": "النازعات", "englishName": "An-Nazi'at", "location": "Mekke", "verseCount": 46},
    {"number": 80, "name": "Abese", "arabicName": "عبس", "englishName": "Abasa", "location": "Mekke", "verseCount": 42},
    {"number": 81, "name": "Tekvîr", "arabicName": "التكوير", "englishName": "At-Takwir", "location": "Mekke", "verseCount": 29},
    {"number": 82, "name": "İnfitâr", "arabicName": "الإنفطار", "englishName": "Al-Infitar", "location": "Mekke", "verseCount": 19},
    {"number": 83, "name": "Mutaffifîn", "arabicName": "المطففين", "englishName": "Al-Mutaffifin", "location": "Mekke", "verseCount": 36},
    {"number": 84, "name": "İnşikâk", "arabicName": "الإنشقاق", "englishName": "Al-Inshiqaq", "location": "Mekke", "verseCount": 25},
    {"number": 85, "name": "Burûc", "arabicName": "البروج", "englishName": "Al-Buruj", "location": "Mekke", "verseCount": 22},
    {"number": 86, "name": "Târık", "arabicName": "الطارق", "englishName": "At-Tariq", "location": "Mekke", "verseCount": 17},
    {"number": 87, "name": "A'lâ", "arabicName": "الأعلى", "englishName": "Al-A'la", "location": "Mekke", "verseCount": 19},
    {"number": 88, "name": "Ğâşiye", "arabicName": "الغاشية", "englishName": "Al-Ghashiyah", "location": "Mekke", "verseCount": 26},
    {"number": 89, "name": "Fecr", "arabicName": "الفجر", "englishName": "Al-Fajr", "location": "Mekke", "verseCount": 30},
    {"number": 90, "name": "Beled", "arabicName": "البلد", "englishName": "Al-Balad", "location": "Mekke", "verseCount": 20},
    {"number": 91, "name": "Şems", "arabicName": "الشمس", "englishName": "Ash-Shams", "location": "Mekke", "verseCount": 15},
    {"number": 92, "name": "Leyl", "arabicName": "الليل", "englishName": "Al-Layl", "location": "Mekke", "verseCount": 21},
    {"number": 93, "name": "Duhâ", "arabicName": "الضحى", "englishName": "Ad-Duha", "location": "Mekke", "verseCount": 11},
    {"number": 94, "name": "İnşirâh", "arabicName": "الشرح", "englishName": "Ash-Sharh", "location": "Mekke", "verseCount": 8},
    {"number": 95, "name": "Tîn", "arabicName": "التين", "englishName": "At-Tin", "location": "Mekke", "verseCount": 8},
    {"number": 96, "name": "Alak", "arabicName": "العلق", "englishName": "Al-'Alaq", "location": "Mekke", "verseCount": 19},
    {"number": 97, "name": "Kadir", "arabicName": "القدر", "englishName": "Al-Qadr", "location": "Mekke", "verseCount": 5},
    {"number": 98, "name": "Beyyine", "arabicName": "البينة", "englishName": "Al-Bayyinah", "location": "Medine", "verseCount": 8},
    {"number": 99, "name": "Zilzâl", "arabicName": "الزلزلة", "englishName": "Az-Zalzalah", "location": "Medine", "verseCount": 8},
    {"number": 100, "name": "Âdiyât", "arabicName": "العاديات", "englishName": "Al-'Adiyat", "location": "Mekke", "verseCount": 11},
    {"number": 101, "name": "Kâria", "arabicName": "القارعة", "englishName": "Al-Qari'ah", "location": "Mekke", "verseCount": 11},
    {"number": 102, "name": "Tekâsür", "arabicName": "التكاثر", "englishName": "At-Takathur", "location": "Mekke", "verseCount": 8},
    {"number": 103, "name": "Asr", "arabicName": "العصر", "englishName": "Al-'Asr", "location": "Mekke", "verseCount": 3},
    {"number": 104, "name": "Hümeze", "arabicName": "الهمزة", "englishName": "Al-Humazah", "location": "Mekke", "verseCount": 9},
    {"number": 105, "name": "Fîl", "arabicName": "الفيل", "englishName": "Al-Fil", "location": "Mekke", "verseCount": 5},
    {"number": 106, "name": "Kureyş", "arabicName": "قريش", "englishName": "Quraish", "location": "Mekke", "verseCount": 4},
    {"number": 107, "name": "Mâûn", "arabicName": "الماعون", "englishName": "Al-Ma'un", "location": "Mekke", "verseCount": 7},
    {"number": 108, "name": "Kevser", "arabicName": "الكوثر", "englishName": "Al-Kawthar", "location": "Mekke", "verseCount": 3},
    {"number": 109, "name": "Kâfirûn", "arabicName": "الكافرون", "englishName": "Al-Kafirun", "location": "Mekke", "verseCount": 6},
    {"number": 110, "name": "Nasr", "arabicName": "النصر", "englishName": "An-Nasr", "location": "Medine", "verseCount": 3},
    {"number": 111, "name": "Tebbet", "arabicName": "المسد", "englishName": "Al-Masad", "location": "Mekke", "verseCount": 5},
    {"number": 112, "name": "İhlâs", "arabicName": "الإخلاص", "englishName": "Al-Ikhlas", "location": "Mekke", "verseCount": 4},
    {"number": 113, "name": "Felak", "arabicName": "الفلق", "englishName": "Al-Falaq", "location": "Mekke", "verseCount": 5},
    {"number": 114, "name": "Nâs", "arabicName": "الناس", "englishName": "An-Nas", "location": "Mekke", "verseCount": 6}
  ];

  Future<void> init() async {
    if (_isInit) return;
    try {
      String arabicResponse;
      String turkishResponse;

      try {
        arabicResponse = await rootBundle.loadString('assets/quran/quran_ar.json');
        turkishResponse = await rootBundle.loadString('assets/quran/meal_tr.json');
      } catch (e) {
        debugPrint('LOG_ERROR: Local JSON not found. Falling back to default Quran package. Error: $e');
        _fallbackToPackage();
        return;
      }
      
      final Map<String, dynamic> arabicData = json.decode(arabicResponse);
      final Map<String, dynamic> turkishData = json.decode(turkishResponse);

      if (arabicData.isEmpty || turkishData.isEmpty) {
        debugPrint('LOG_ERROR: JSON data found but is empty. Triggering fallback.');
        _fallbackToPackage();
        return;
      }

      final List<dynamic> arabicVerses = arabicData['quran'] ?? [];
      final List<dynamic> turkishVerses = turkishData['quran'] ?? [];

      if (arabicVerses.isEmpty || turkishVerses.isEmpty) {
        debugPrint('LOG_ERROR: "quran" list in JSON is missing or empty. Triggering fallback.');
        _fallbackToPackage();
        return;
      }

      _versesMap.clear();
      for (int i = 0; i < arabicVerses.length; i++) {
        final ar = arabicVerses[i];
        final tr = turkishVerses[i];
        
        final int chapter = ar['chapter'];
        final Map<String, dynamic> mergedVerse = {
          'chapter': chapter,
          'number': ar['verse'],
          'arabic': ar['text'],
          'translations': {
            'tr': tr['text'],
          },
          'transliteration': '', 
          'tafsir': {}, 
          'words': [], 
        };

        if (!_versesMap.containsKey(chapter)) {
          _versesMap[chapter] = [];
        }
        _versesMap[chapter]!.add(mergedVerse);
      }

      _isInit = true;
      debugPrint("QuranRepository: Full 6236 Ayahs loaded and grouped.");
    } catch (e) {
      debugPrint("QuranRepository: FATAL ERROR during init: $e");
      _fallbackToPackage();
    }
  }

  void _fallbackToPackage() {
    _versesMap.clear();
    for (int chapter = 1; chapter <= 114; chapter++) {
      final int count = quran.getVerseCount(chapter);
      _versesMap[chapter] = List.generate(count, (i) {
        final int verseNum = i + 1;
        return {
          'chapter': chapter,
          'number': verseNum,
          'arabic': quran.getVerse(chapter, verseNum, verseEndSymbol: true),
          'translations': {
            'tr': quran.getVerseTranslation(chapter, verseNum, translation: quran.Translation.trSaheeh),
          },
          'transliteration': '', 
          'tafsir': {}, 
          'words': [], 
        };
      });
    }
    _isInit = true;
    debugPrint("QuranRepository: Fallback to 'quran' package completed (including translations).");
  }

  void setLanguage(String langCode) {
    _activeLanguage = langCode;
  }

  List<Map<String, dynamic>> getAllSurahs() {
    return _surahMetadata;
  }

  Map<String, dynamic>? getSurah(int surahNumber) {
    try {
      return _surahMetadata.firstWhere((s) => s['number'] == surahNumber);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> getVerses(int surahNumber) {
    return _versesMap[surahNumber] ?? [];
  }

  String getVerseText(Map<String, dynamic> verse, {bool isArabic = true}) {
    if (isArabic) {
      return verse['arabic'] ?? '';
    } else {
      final rawTranslations = verse['translations'];
      final translations = rawTranslations != null ? Map<String, dynamic>.from(rawTranslations as Map) : null; // Safe conversion for nullable Map - Nullable Map için güvenli dönüştürme
      return translations?[_activeLanguage] ?? translations?['tr'] ?? '';
    }
  }

  String getTafsir(Map<String, dynamic> verse) {
    final rawTafsir = verse['tafsir'];
    final tafsir = rawTafsir != null ? Map<String, dynamic>.from(rawTafsir as Map) : null; // Safe conversion for nullable Map - Nullable Map için güvenli dönüştürme
    return tafsir?[_activeLanguage] ?? tafsir?['tr'] ?? '';
  }

  String getTransliteration(Map<String, dynamic> verse) {
    return verse['transliteration'] ?? '';
  }

  List<Map<String, dynamic>> getWords(Map<String, dynamic> verse) {
    if (verse['words'] == null) return [];
    final List<dynamic> words = verse['words'];
    return words.map((w) => Map<String, dynamic>.from(w)).toList();
  }
}
