import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran/quran.dart' as quran;
import 'history_state.dart';
import '../services/quran_service.dart';

enum ReadingScope {
  ayah,
  page,
  surah,
  juz,
}

class QuranSettingsState extends ChangeNotifier {
  static final QuranSettingsState _instance = QuranSettingsState._internal();
  factory QuranSettingsState() => _instance;
  QuranSettingsState._internal() {
    _init(); // Auto init when created
  }

  ReadingScope _readingScope = ReadingScope.ayah;
  ReadingScope get readingScope => _readingScope;

  String _mushafFont = 'Amiri';
  String get mushafFont => _mushafFont;

  String _arabicFont = 'Amiri';
  String get arabicFont => _arabicFont;

  String _turkishFont = 'Inter';
  String get turkishFont => _turkishFont;

  int _selectedReciterId = 7; // Default: Mishary Rashid Alafasy
  int get selectedReciterId => _selectedReciterId;

  String _selectedReciterName = 'Mishary Rashid Alafasy';
  String get selectedReciterName => _selectedReciterName;

  bool _showArabic = true;
  bool _showTranslation = true;
  bool _showTafsir = false;
  bool _showTransliteration = false;
  bool _showWordByWord = false;

  bool get showArabic => _showArabic;
  bool get showTranslation => _showTranslation;
  bool get showTafsir => _showTafsir;
  bool get showTransliteration => _showTransliteration;
  bool get showWordByWord => _showWordByWord;

  double _arabicFontSize = 28.0;
  double _translationFontSize = 16.0;
  double _tafsirFontSize = 14.0;
  double _transliterationFontSize = 16.0;
  double _wordByWordFontSize = 14.0;
  double _autoScrollSpeed = 1.0; // [Otomatik kaydırma hızı - Auto scroll speed]

  double get arabicFontSize => _arabicFontSize;
  double get translationFontSize => _translationFontSize;
  double get tafsirFontSize => _tafsirFontSize;
  double get transliterationFontSize => _transliterationFontSize;
  double get wordByWordFontSize => _wordByWordFontSize;
  double get autoScrollSpeed => _autoScrollSpeed;

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _readingScope = ReadingScope.values[prefs.getInt('reading_scope') ?? 0];
    _mushafFont = prefs.getString('mushaf_font') ?? 'Amiri';
    _arabicFont = prefs.getString('arabic_font') ?? 'Amiri';
    _turkishFont = prefs.getString('turkish_font') ?? 'Inter';
    
    _selectedReciterId = prefs.getInt('selected_reciter_id') ?? 7;
    _selectedReciterName = prefs.getString('selected_reciter_name') ?? 'Mishary Rashid Alafasy';

    _showArabic = prefs.getBool('show_arabic') ?? true;
    _showTranslation = prefs.getBool('show_translation') ?? true;
    _showTafsir = prefs.getBool('show_tafsir') ?? false;
    _showTransliteration = prefs.getBool('show_transliteration') ?? false;
    _showWordByWord = prefs.getBool('show_word_by_word') ?? false;

    _arabicFontSize = prefs.getDouble('arabic_font_size') ?? 28.0;
    _translationFontSize = prefs.getDouble('translation_font_size') ?? 16.0;
    _tafsirFontSize = prefs.getDouble('tafsir_font_size') ?? 14.0;
    _transliterationFontSize = prefs.getDouble('transliteration_font_size') ?? 16.0;
    _wordByWordFontSize = prefs.getDouble('word_by_word_font_size') ?? 14.0;
    _autoScrollSpeed = prefs.getDouble('auto_scroll_speed') ?? 1.0;
    notifyListeners();
  }

  void updateScope(ReadingScope scope) {
    syncPositionOnScopeChange(scope);
    _readingScope = scope;
    _saveInt('reading_scope', scope.index);
    notifyListeners();
  }

  void syncPositionOnScopeChange(ReadingScope newScope) {
    // [Okuma kapsamı değiştiğinde konumu senkronize et - Sync position on scope change]
    final currentHistory = globalHistoryState.value;
    final int surah = currentHistory.surahNumber;
    final int ayah = currentHistory.ayahNumber;

    if (newScope == ReadingScope.juz) {
      final int juz = QuranService.getJuzOfSurah(surah);
      updateHistoryProgress(
        surahNumber: surah,
        ayahNumber: ayah,
        surahName: currentHistory.surahName,
        pageNumber: juz, // Cüz modunda sayfa no cüz no'yu tutar - In Juz mode, page number holds juz number
      );
    } else if (newScope == ReadingScope.page) {
      // [Ayetten Sayfaya geçiş - Jump from Ayah to Page]
      // Not: QuranService'e getPageOfAyah eklenebilir veya quran paketi doğrudan kullanılabilir
      final int page = quran.getPageNumber(surah, ayah);
      updateHistoryProgress(
        surahNumber: surah,
        ayahNumber: ayah,
        surahName: currentHistory.surahName,
        pageNumber: page,
      );
    }
  }

  void updateReciter(int id, String name) {
    _selectedReciterId = id;
    _selectedReciterName = name;
    _saveInt('selected_reciter_id', id);
    _saveString('selected_reciter_name', name);
    notifyListeners();
  }

  void updateMushafFont(String fontName) {
    _mushafFont = fontName;
    _saveString('mushaf_font', fontName);
    notifyListeners();
  }

  void updateArabicFont(String fontName) {
    _arabicFont = fontName;
    _saveString('arabic_font', fontName);
    notifyListeners();
  }

  void updateTurkishFont(String fontName) {
    _turkishFont = fontName;
    _saveString('turkish_font', fontName);
    notifyListeners();
  }

  void toggleLayer(String layer, bool value) {
    // Prevent hiding all layers
    if (!value) {
       int activeCount = (_showArabic ? 1 : 0) +
                         (_showTranslation ? 1 : 0) +
                         (_showTafsir ? 1 : 0) +
                         (_showTransliteration ? 1 : 0) +
                         (_showWordByWord ? 1 : 0);
       if (activeCount <= 1) return; // Cannot disable the last active layer
    }

    switch (layer) {
      case 'arabic':
        _showArabic = value;
        _saveBool('show_arabic', value);
        break;
      case 'translation':
        _showTranslation = value;
        _saveBool('show_translation', value);
        break;
      case 'tafsir':
        _showTafsir = value;
        _saveBool('show_tafsir', value);
        break;
      case 'transliteration':
        _showTransliteration = value;
        _saveBool('show_transliteration', value);
        break;
      case 'wordByWord':
        _showWordByWord = value;
        _saveBool('show_word_by_word', value);
        break;
    }
    notifyListeners();
  }

  void updateFontSize(String layer, double value) {
    switch (layer) {
      case 'arabic':
        _arabicFontSize = value;
        _saveDouble('arabic_font_size', value);
        break;
      case 'translation':
        _translationFontSize = value;
        _saveDouble('translation_font_size', value);
        break;
      case 'tafsir':
        _tafsirFontSize = value;
        _saveDouble('tafsir_font_size', value);
        break;
      case 'transliteration':
        _transliterationFontSize = value;
        _saveDouble('transliteration_font_size', value);
        break;
      case 'wordByWord':
        _wordByWordFontSize = value;
        _saveDouble('word_by_word_font_size', value);
        break;
    }
    notifyListeners();
  }

  void updateAutoScrollSpeed(double value) {
    _autoScrollSpeed = value;
    _saveDouble('auto_scroll_speed', value);
    notifyListeners();
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<void> _saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
