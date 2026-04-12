class DuaItem {
  final String id;
  final String title;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String category; // 'quran', 'hadith', 'daily'
  final String? source;
  final List<Map<String, dynamic>>? wordTimings; // [Kelime Bazlı Zamanlama - Karaoke Setup]

  DuaItem({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.category,
    this.source,
    this.wordTimings,
  });
}
