import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'history_service.dart';

// [Favori Modeli - Favorite Model]
class FavoriteItem {
  final int id;
  final String title;
  final String type; // 'surah', 'juz', 'page'
  final int? surahNumber;
  final DateTime date;

  FavoriteItem({
    required this.id,
    required this.title,
    required this.type,
    this.surahNumber,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'surahNumber': surahNumber,
        'date': date.toIso8601String(),
      };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
        id: json['id'],
        title: json['title'],
        type: json['type'],
        surahNumber: json['surahNumber'],
        date: DateTime.parse(json['date']),
      );
}

// [Favori Servisi - Favorite Service]
class FavoriteService {
  static const String _favKey = 'favorites_list';

  // [Favorilere ekle veya çıkar - Add or remove from favorites]
  static Future<bool> toggleFavorite(FavoriteItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final List<FavoriteItem> favorites = await getFavorites();
    
    final int index = favorites.indexWhere((f) => f.id == item.id && f.type == item.type);
    
    if (index >= 0) {
      favorites.removeAt(index);
    } else {
      favorites.add(item);
    }

    final String encoded = jsonEncode(favorites.map((e) => e.toJson()).toList());
    final result = await prefs.setString(_favKey, encoded);
    HistoryService.notifyListeners();
    return result;
  }

  // [İkon durumunu kontrol et - Check icon status]
  static Future<bool> isFavorite(int id, String type) async {
    final favorites = await getFavorites();
    return favorites.any((f) => f.id == id && f.type == type);
  }

  // [Tüm favorileri getir - Get all favorites]
  static Future<List<FavoriteItem>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_favKey);
    if (encoded == null) {
      return [];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(encoded);
      return decoded.map((e) => FavoriteItem.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
