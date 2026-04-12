import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// [Tarih Servisi - History Service]
class HistoryService {
  static const String _savedKey = 'saved_history_ids';
  static const String _readKey = 'read_history_ids'; 
  static const String _visitedKey = 'visited_history_ids';
  static const String _toVisitKey = 'to_visit_history_ids';
  static const String _customListsKey = 'custom_collections_list';
  static const String _collectionItemsPrefix = 'collection_items_';
  static const String _devModeKey = 'dev_mode_active';
  static const String _hiddenCardsKey = 'hidden_cards_visible';
  static const String _stopTimeKey = 'stop_time_active';
  static const String _screenshotModeKey = 'screenshot_mode_active';
  static const String _fastingModeKey = 'fasting_mode_active';
  static const String _saveCountKey = 'app_save_count';
  static const String _isReviewAskedKey = 'is_review_asked';
  static const String _metadataKeyPrefix = 'item_metadata_';

  // [Hafıza Önbelleği | Memory Cache]
  static List<String> _savedIds = [];
  static List<String> _readIds = [];
  static bool _isInitialized = false;

  /// [Servisi Başlat | Initialize Service]
  static Future<void> init() async {
    if (_isInitialized) return;
    _savedIds = await getSavedIds();
    _readIds = await getReadIds();
    _isInitialized = true;
  }

  // [Küresel Bildirim Sistemi | Global Notification System]
  static final ValueNotifier<int> updates = ValueNotifier(0);
  
  static void notifyListeners() {
    updates.value++;
  }

  // [Geliştirici Ayarları | Developer Settings]
  
  static Future<bool> isScreenshotMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_screenshotModeKey) ?? false;
  }

  static Future<void> setScreenshotMode(bool active) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_screenshotModeKey, active);
    notifyListeners();
  }

  static DateTime getNow(bool screenshotModeActive) {
    if (screenshotModeActive) {
      // [10 Mart 2026, 03:35:25]
      return DateTime(2026, 3, 10, 3, 35, 25);
    }
    return DateTime.now();
  }

  // [Metadata Yönetimi | Metadata Management]
  
  static Future<void> saveMetadata(String id, String title, String subtitle) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_metadataKeyPrefix + id, [title, subtitle]);
    notifyListeners();
  }

  static Future<Map<String, String>?> getMetadata(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_metadataKeyPrefix + id);
    if (data == null || data.length < 2) return null;
    return {'title': data[0], 'subtitle': data[1]};
  }

  // [Koleksiyon Yönetimi | Collection Management]

  static Future<List<String>> getCustomLists() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_customListsKey) ?? [];
  }

  static Future<bool> createCustomList(String name) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> lists = await getCustomLists();
    if (!lists.contains(name)) {
      lists.add(name);
      final result = await prefs.setStringList(_customListsKey, lists);
      notifyListeners();
      return result;
    }
    return true;
  }

  static Future<bool> deleteCustomList(String name) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> lists = await getCustomLists();
    lists.remove(name);
    await prefs.setStringList(_customListsKey, lists);
    final result = await prefs.remove(_collectionItemsPrefix + name);
    notifyListeners();
    return result;
  }

  static Future<bool> saveToCollection(String itemId, String collectionName) async {
    final prefs = await SharedPreferences.getInstance();
    final String key = _collectionItemsPrefix + collectionName;
    List<String> items = prefs.getStringList(key) ?? [];
    if (!items.contains(itemId)) {
      items.add(itemId);
      final result = await prefs.setStringList(key, items);
      notifyListeners();
      return result;
    }
    return true;
  }

  static Future<bool> removeFromCollection(String itemId, String collectionName) async {
    final prefs = await SharedPreferences.getInstance();
    final String key = _collectionItemsPrefix + collectionName;
    List<String> items = prefs.getStringList(key) ?? [];
    if (items.contains(itemId)) {
      items.remove(itemId);
      final result = await prefs.setStringList(key, items);
      notifyListeners();
      return result;
    }
    return true;
  }

  static Future<List<String>> getItemsInCollection(String collectionName) async {
    if (collectionName == "Ana Kütüphane" || collectionName == "Kütüphanem") return await getSavedIds();
    if (collectionName == "Okuduklarım") return await getReadIds();
    final prefs = await SharedPreferences.getInstance();
    final String key = _collectionItemsPrefix + collectionName;
    return prefs.getStringList(key) ?? [];
  }

  // [Kütüphaneye Kaydet | Save to Library]

  static Future<List<String>> getSavedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_savedKey) ?? [];
  }

  static Future<bool> isSaved(String itemId) async {
    final savedIds = await getSavedIds();
    return savedIds.contains(itemId);
  }

  static bool isSavedSync(String itemId) {
    return _savedIds.contains(itemId);
  }

  static Future<bool> toggleSave(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedIds = await getSavedIds();
    if (savedIds.contains(itemId)) {
      savedIds.remove(itemId);
    } else {
      savedIds.add(itemId);
    }
    final result = await prefs.setStringList(_savedKey, savedIds);
    _savedIds = savedIds; // Önbelleği güncelle
    if (savedIds.contains(itemId)) {
      await _incrementSaveCount();
    }
    notifyListeners();
    return result;
  }

  static Future<bool> saveOnly(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedIds = await getSavedIds();
    if (!savedIds.contains(itemId)) {
      savedIds.add(itemId);
      final result = await prefs.setStringList(_savedKey, savedIds);
      _savedIds = savedIds; // Önbelleği güncelle
      await _incrementSaveCount();
      notifyListeners();
      return result;
    }
    return true;
  }

  static Future<void> _incrementSaveCount() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(_saveCountKey) ?? 0;
    await prefs.setInt(_saveCountKey, count + 1);
  }

  static Future<void> checkReviewRequired(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(_saveCountKey) ?? 0;
    bool alreadyAsked = prefs.getBool(_isReviewAskedKey) ?? false;

    if (count >= 3 && !alreadyAsked) {
      if (context.mounted) {
        _showReviewDialog(context);
        await prefs.setBool(_isReviewAskedKey, true);
      }
    }
  }

  static void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Kubbe'yi Sevdin mi?"),
        content: const Text(
          "Seyyah, Kubbe'deki yolculuğun nasıl gidiyor? Bize Play Store'da yıldız vererek destek olur musun?"
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Daha Sonra"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // İleride in_app_review buraya bağlanacak
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B0082),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Puan Ver"),
          ),
        ],
      ),
    );
  }

  // [Okundu İşaretleme | Mark as Read]

  static Future<List<String>> getReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_readKey) ?? [];
  }

  static Future<bool> isRead(String itemId) async {
    final readIds = await getReadIds();
    return readIds.contains(itemId);
  }

  static bool isReadSync(String itemId) {
    return _readIds.contains(itemId);
  }

  static Future<bool> toggleRead(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readIds = await getReadIds();
    if (readIds.contains(itemId)) {
      readIds.remove(itemId);
    } else {
      readIds.add(itemId);
    }
    final result = await prefs.setStringList(_readKey, readIds);
    _readIds = readIds; // Önbelleği güncelle
    notifyListeners();
    return result;
  }

  // [İstatistikler | Stats]

  static Future<Map<String, int>> getVefaStats() async {
    final savedIds = await getSavedIds();
    final readIds = await getReadIds();
    return {
      'visited': savedIds.length, 
      'learned': readIds.length,
      'shares': 8, // Statik test değeri
    };
  }

  // [Ziyaret ve Keşfet Durumları | Visits and Discoveries]

  static Future<List<String>> getVisitedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_visitedKey) ?? [];
    return rawList.map((e) => e.split('|')[0]).toList();
  }

  static Future<List<String>> getToVisitIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_toVisitKey) ?? [];
  }

  static Future<void> toggleVisitStatus(String id, bool isVisited) async {
    final prefs = await SharedPreferences.getInstance();
    final key = isVisited ? _visitedKey : _toVisitKey;
    final otherKey = isVisited ? _toVisitKey : _visitedKey;
    
    List<String> list = prefs.getStringList(key) ?? [];
    List<String> otherList = prefs.getStringList(otherKey) ?? [];
    
    if (isVisited) {
      list.removeWhere((e) => e.split('|')[0] == id);
      otherList.remove(id); 
      final now = DateTime.now();
      list.add("$id|${now.toIso8601String()}");
    } else {
      if (!list.contains(id)) {
        list.add(id);
        otherList.removeWhere((e) => e.split('|')[0] == id);
      } else {
        list.remove(id);
      }
    }
    await prefs.setStringList(key, list);
    await prefs.setStringList(otherKey, otherList);
  }

  static String extractDate(String raw) {
    final parts = raw.split('|');
    if (parts.length < 2) return "";
    try {
      final date = DateTime.parse(parts[1]);
      final months = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"];
      return "${date.day} ${months[date.month - 1]}";
    } catch (e) {
      return "";
    }
  }

  // [Geliştirici Modu | Developer Mode]

  static Future<bool> isDevModeActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_devModeKey) ?? false;
  }

  static Future<void> setDevMode(bool active) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_devModeKey, active);
  }

  static Future<bool> isHiddenCardsVisible() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hiddenCardsKey) ?? false;
  }

  static Future<void> setHiddenCardsVisible(bool visible) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hiddenCardsKey, visible);
  }

  static Future<bool> isStopTimeActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_stopTimeKey) ?? false;
  }

  static Future<void> setStopTimeActive(bool active) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_stopTimeKey, active);
    notifyListeners();
  }

  static Future<bool> isFastingModeActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_fastingModeKey) ?? false;
  }

  static Future<void> setFastingMode(bool active) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_fastingModeKey, active);
    notifyListeners();
  }
}
