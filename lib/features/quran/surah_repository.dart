// TR: KUBBE V4 Surah Repository - JSON tabanlı
// EN: KUBBE V4 Surah Repository - JSON-based
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki 114 sure verisini JSON dosyasından okuyan modern repository
// EN: Modern repository that reads V1's 114 surah data from JSON file
// TR: Riverpod FutureProvider ile UI'a sunum
// EN: Serving to UI with Riverpod FutureProvider

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/surah.dart';

/// TR: KUBBE V4 Surah Repository Sınıfı
/// EN: KUBBE V4 Surah Repository Class
/// TR: JSON tabanlı sure verisi yönetimi
/// EN: JSON-based surah data management
/// TR: V4 yeniliği ve Sy-OS design language
/// EN: V4 innovation and Sy-OS design language
class SurahRepository {
  // TR: JSON verisi cache'i - Performans için
  // EN: JSON data cache - For performance
  static List<Surah>? _cachedSurahs;

  // TR: JSON dosyasından tüm sureleri yükle - V1'den miras alındı
  // EN: Load all surahs from JSON file - Inherited from V1
  static Future<List<Surah>> loadSurahsFromJson() async {
    // TR: Cache kontrolü
    // EN: Cache check
    if (_cachedSurahs != null) {
      return _cachedSurahs!;
    }

    try {
      // TR: JSON dosyasını oku
      // EN: Read JSON file
      final jsonString =
          await rootBundle.loadString('assets/data/quran_data.json');
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      // TR: Sure listesini dönüştür
      // EN: Convert surah list
      final surahsList = (jsonData['surahs'] as List<dynamic>)
          .map((json) => Surah.fromJson(json as Map<String, dynamic>))
          .toList();

      // TR: Cache'e al
      // EN: Cache it
      _cachedSurahs = surahsList;

      return _cachedSurahs!;
    } catch (e) {
      // TR: Hata durumunda boş liste dön
      // EN: Return empty list on error
      return [];
    }
  }

  // TR: Tüm sureleri al - V1'den miras alındı
  // EN: Get all surahs - Inherited from V1
  static Future<List<Surah>> getAllSurahs() async {
    return await loadSurahsFromJson();
  }

  // TR: ID'ye göre sure al - V1'den miras alındı
  // EN: Get surah by ID - Inherited from V1
  static Future<Surah?> getSurahById(int id) async {
    final surahs = await loadSurahsFromJson();
    try {
      return surahs.firstWhere((surah) => surah.id == id);
    } catch (e) {
      return null;
    }
  }

  // TR: İsme göre sure ara - V4 yeniliği
  // EN: Search surah by name - V4 innovation
  static Future<List<Surah>> searchSurahs(String query) async {
    final surahs = await loadSurahsFromJson();
    final lowerQuery = query.toLowerCase();

    return surahs.where((surah) {
      return surah.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // TR: İniş yerine göre sureleri al - V4 yeniliği
  // EN: Get surahs by revelation place - V4 innovation
  static Future<List<Surah>> getSurahsByCity(String city) async {
    final surahs = await loadSurahsFromJson();
    return surahs.where((surah) => surah.city == city).toList();
  }

  // TR: Ayet sayısına göre sureleri al - V4 yeniliği
  // EN: Get surahs by verse count - V4 innovation
  static Future<List<Surah>> getSurahsByVerseCountRange(
      int min, int max) async {
    final surahs = await loadSurahsFromJson();
    return surahs
        .where(
            (surah) => surah.verses.length >= min && surah.verses.length <= max)
        .toList();
  }

  // TR: İlk 10 sureyi al - V4 yeniliği
  // EN: Get first 10 surahs - V4 innovation
  static Future<List<Surah>> getFirstSurahs(int count) async {
    final surahs = await loadSurahsFromJson();
    return surahs.take(count).toList();
  }

  // TR: Son 10 sureyi al - V4 yeniliği
  // EN: Get last 10 surahs - V4 innovation
  static Future<List<Surah>> getLastSurahs(int count) async {
    final surahs = await loadSurahsFromJson();
    return surahs.skip(surahs.length - count).toList();
  }

  // TR: Mekke surelerini al - V4 yeniliği
  // EN: Get Mekki surahs - V4 innovation
  static Future<List<Surah>> getMekkiSurahs() async {
    return await getSurahsByCity('Mekke');
  }

  // TR: Medine surelerini al - V4 yeniliği
  // EN: Get Medini surahs - V4 innovation
  static Future<List<Surah>> getMediniSurahs() async {
    return await getSurahsByCity('Medine');
  }

  // TR: İstatistikler - V4 yeniliği
  // EN: Statistics - V4 innovation
  static Future<Map<String, int>> getStatistics() async {
    final surahs = await loadSurahsFromJson();
    final mekkiCount = surahs.where((s) => s.city == 'Mekke').length;
    final medineCount = surahs.where((s) => s.city == 'Medine').length;
    final totalVerses =
        surahs.fold<int>(0, (sum, surah) => sum + surah.verses.length);

    return {
      'total_surahs': surahs.length,
      'mekki_surahs': mekkiCount,
      'medini_surahs': medineCount,
      'total_verses': totalVerses,
      'average_verses': (totalVerses / surahs.length).round(),
    };
  }

  // TR: Öne çıkan sureler - V4 yeniliği
  // EN: Featured surahs - V4 innovation
  static Future<List<Surah>> getFeaturedSurahs() async {
    final featuredIds = [
      1,
      2,
      36,
      55,
      67,
      112
    ]; // Fatiha, Bakara, Yasin, Rahman, Mülk, İhlas

    final featuredSurahs = <Surah>[];

    for (final id in featuredIds) {
      final surah = await getSurahById(id);
      if (surah != null) {
        featuredSurahs.add(surah);
      }
    }

    return featuredSurahs;
  }

  // TR: Arama önerileri - V4 yeniliği
  // EN: Search suggestions - V4 innovation
  static Future<List<String>> getSearchSuggestions() async {
    final surahs = await loadSurahsFromJson();
    final suggestions = <String>[];

    // TR: Sure isimlerinden öneriler
    // EN: Suggestions from surah names
    suggestions.addAll(surahs.map((s) => s.name));

    return suggestions.toSet().take(20).toList();
  }

  // TR: Veri doğrulama - V4 yeniliği
  // EN: Data validation - V4 innovation
  static Future<bool> validateData() async {
    final surahs = await loadSurahsFromJson();

    // TR: Boş veri kontrolü
    // EN: Empty data check
    if (surahs.isEmpty) return false;

    // TR: Gerekli alanlar kontrolü
    // EN: Required fields check
    for (final surah in surahs) {
      if (surah.id <= 0 || surah.name.isEmpty || surah.verses.isEmpty) {
        return false;
      }
    }

    // TR: Tekrarlayan ID kontrolü
    // EN: Duplicate ID check
    final ids = surahs.map((s) => s.id).toSet();
    if (ids.length != surahs.length) return false;

    // TR: Toplam sure sayısı kontrolü
    // EN: Total surah count check
    if (surahs.length != 114) return false;

    return true;
  }

  // TR: Veri yenileme - V1'den miras alındı
  // EN: Data refresh - Inherited from V1
  static void refreshData() {
    // TR: Cache'i temizle
    // EN: Clear cache
    _cachedSurahs = null;
  }

  // TR: Paylaşım metni - V4 yeniliği
  // EN: Sharing text - V4 innovation
  static Future<String> createShareText(Surah surah) async {
    return '${surah.verses.length} ayet • ${surah.city}';
  }
}

/// TR: Surah Repository Provider - V4 yeniliği
/// EN: Surah Repository Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
final surahRepositoryProvider = Provider<SurahRepository>((ref) {
  return SurahRepository();
});

/// TR: All Surahs Provider - V4 yeniliği
/// EN: All Surahs Provider - V4 innovation
/// TR: UI için tüm sureleri sağlar
/// EN: Provides all surahs for UI
final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  return await SurahRepository.getAllSurahs();
});

/// TR: Surah by ID Provider - V4 yeniliği
/// EN: Surah by ID Provider - V4 innovation
/// TR: ID'ye göre sure sağlar
/// EN: Provides surah by ID
final surahByIdProvider = FutureProvider.family<Surah?, int>((ref, id) async {
  return await SurahRepository.getSurahById(id);
});

/// TR: Search Results Provider - V4 yeniliği
/// EN: Search Results Provider - V4 innovation
/// TR: Arama sonuçları sağlar
/// EN: Provides search results
final surahSearchProvider =
    FutureProvider.family<List<Surah>, String>((ref, query) async {
  return await SurahRepository.searchSurahs(query);
});

/// TR: Featured Surahs Provider - V4 yeniliği
/// EN: Featured Surahs Provider - V4 innovation
/// TR: Öne çıkan sureleri sağlar
/// EN: Provides featured surahs
final featuredSurahsProvider = FutureProvider<List<Surah>>((ref) async {
  return await SurahRepository.getFeaturedSurahs();
});

/// TR: Statistics Provider - V4 yeniliği
/// EN: Statistics Provider - V4 innovation
/// TR: İstatistikleri sağlar
/// EN: Provides statistics
final surahStatisticsProvider = FutureProvider<Map<String, int>>((ref) async {
  return await SurahRepository.getStatistics();
});
