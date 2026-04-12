import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class HatimRepository {
  static final HatimRepository _instance = HatimRepository._internal();
  factory HatimRepository() => _instance;
  HatimRepository._internal();

  Database? _database;
  final Set<String> _readCache = {}; // [Hafızada tutulan 'Okundu' ayetler anahtarı: "surah_ayah" - Memory cache]

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    // [Başlangıçta tüm okunanları yükle - Load all read ayahs into cache once]
    await _loadCache(); 
    return _database!;
  }

  Future<void> _loadCache() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('hatim_progress', where: 'is_read = 1');
    for (var m in maps) {
      _readCache.add("${m['surah_id']}_${m['ayah_id']}");
    }
  }

  bool isAyahReadSync(int surahId, int ayahId) {
    return _readCache.contains("${surahId}_${ayahId}");
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kubbe_hatim.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE hatim_progress (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              surah_id INTEGER,
              ayah_id INTEGER,
              is_read INTEGER,
              read_date TEXT,
              reading_mode TEXT,
              UNIQUE(surah_id, ayah_id)
            )
          ''');
          await db.execute('''
            CREATE TABLE hatim_settings (
              key TEXT PRIMARY KEY,
              value TEXT
            )
          ''');
      },
    );
  }

  Future<void> markAyahAsRead({
    required int surahId,
    required int ayahId,
    bool isRead = true,
    String? mode,
  }) async {
    final db = await database;
    await db.insert(
      'hatim_progress',
      {
        'surah_id': surahId,
        'ayah_id': ayahId,
        'is_read': isRead ? 1 : 0,
        'read_date': DateTime.now().toIso8601String(),
        'reading_mode': mode ?? 'Sessiz',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // [Önbelliği güncelle - Update cache]
    if (isRead) {
      _readCache.add("${surahId}_${ayahId}");
    } else {
      _readCache.remove("${surahId}_${ayahId}");
    }
  }

  Future<List<Map<String, dynamic>>> getProgress() async {
    final db = await database;
    return await db.query('hatim_progress', where: 'is_read = 1');
  }

  Future<Map<int, int>> getSurahReadCount() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT surah_id, COUNT(*) as count 
      FROM hatim_progress 
      WHERE is_read = 1 
      GROUP BY surah_id
    ''');
    
    return Map.fromIterable(
      maps,
      key: (e) => e['surah_id'] as int,
      value: (e) => e['count'] as int,
    );
  }

  Future<Map<String, int>> getDailyReadingStats(int daysCount) async {
    final db = await database;
    // SQLite strftime assumes ISO8601 format
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT strftime('%Y-%m-%d', read_date) as day, COUNT(*) as count 
      FROM hatim_progress 
      WHERE is_read = 1 
      GROUP BY day 
      ORDER BY day DESC 
      LIMIT ?
    ''', [daysCount]);
    
    return {for (var m in maps) m['day'] as String: m['count'] as int};
  }

  Future<void> saveTargetDate(DateTime date) async {
    final db = await database;
    await db.insert(
      'hatim_settings',
      {'key': 'target_date', 'value': date.toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DateTime?> getTargetDate() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'hatim_settings',
      where: "key = 'target_date'",
    );
    if (maps.isNotEmpty) {
      return DateTime.parse(maps.first['value'] as String);
    }
    return null;
  }

  Future<void> resetProgress() async {
    final db = await database;
    await db.delete('hatim_progress');
  }
}
