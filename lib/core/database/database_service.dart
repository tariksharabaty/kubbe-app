// TR: KUBBE V4 Database Service - Isar Veritabanı Servisi
// EN: KUBBE V4 Database Service - Isar Database Service
// TR: Namaz çetelesi (Lale Bahçesi), zikir kayıtları, kaza namazları ve premium temalar için veritabanı yönetimi
// EN: Database management for Lale Bahcesi, Dhikr records, Missed prayers (Kaza), and Premium themes

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

part 'database_service.g.dart';

/// TR: Lale Bahçesi (Namaz Çetelesi) Koleksiyonu
/// EN: Lale Bahcesi (Prayer Tracker) Collection
@collection
class LaleBahcesi {
  // TR: Benzersiz ID
  // EN: Unique ID
  Id id = Isar.autoIncrement;

  // TR: Tarih (YYYY-MM-DD formatında)
  // EN: Date (in YYYY-MM-DD format)
  @Index(unique: true, replace: true)
  late String date;

  // TR: Namaz vakitleri durumu
  // EN: Prayer times status
  bool fajr = false;
  bool dhuhr = false;
  bool asr = false;
  bool maghrib = false;
  bool isha = false;

  // TR: Oluşturulma tarihi
  // EN: Creation date
  final DateTime createdAt = DateTime.now();

  LaleBahcesi({
    required this.date,
    this.fajr = false,
    this.dhuhr = false,
    this.asr = false,
    this.maghrib = false,
    this.isha = false,
  });

  // TR: Boş constructor (Isar için)
  // EN: Empty constructor (for Isar)
  LaleBahcesi.empty();
}

/// TR: Zikir Kayıtları Koleksiyonu
/// EN: Dhikr Records Collection
@collection
class ZikirKaydi {
  // TR: Benzersiz ID
  // EN: Unique ID
  Id id = Isar.autoIncrement;

  // TR: Zikir adı
  // EN: Dhikr name
  @Index()
  late String name;

  // TR: Mevcut sayaç
  // EN: Current counter
  int count = 0;

  // TR: Hedef sayı
  // EN: Goal count
  int goal = 0;

  // TR: Son güncelleme tarihi
  // EN: Last updated date
  late DateTime lastUpdated;

  // TR: Constructor
  // EN: Constructor
  ZikirKaydi({
    required this.name,
    this.count = 0,
    this.goal = 0,
    required this.lastUpdated,
  });

  // TR: Boş constructor (Isar için)
  // EN: Empty constructor (for Isar)
  ZikirKaydi.empty();
}

/// TR: Kaza Namazları Koleksiyonu
/// EN: Missed Prayers (Kaza) Collection
@collection
class KazaNamazi {
  // TR: Benzersiz ID
  // EN: Unique ID
  Id id = Isar.autoIncrement;

  // TR: Vakit sayaçları
  // EN: Prayer counters
  int fajr = 0;
  int dhuhr = 0;
  int asr = 0;
  int maghrib = 0;
  int isha = 0;
  int witr = 0;

  // TR: Constructor
  // EN: Constructor
  KazaNamazi({
    this.fajr = 0,
    this.dhuhr = 0,
    this.asr = 0,
    this.maghrib = 0,
    this.isha = 0,
    this.witr = 0,
  });
}

/// TR: Premium Tema Bilgileri Koleksiyonu
/// EN: Premium Theme Info Collection
@collection
class PremiumTema {
  // TR: Benzersiz ID
  // EN: Unique ID
  Id id = Isar.autoIncrement;

  // TR: Tema ID (Benzersiz)
  // EN: Theme ID (Unique)
  @Index(unique: true)
  late String themeId;

  // TR: Tema adı
  // EN: Theme name
  late String name;

  // TR: İndirilme durumu
  // EN: Download status
  bool isDownloaded = false;

  // TR: Aktiflik durumu
  // EN: Active status
  bool isActive = false;

  // TR: Yerel dosya yolu (Varsa)
  // EN: Local file path (If any)
  String? localPath;

  // TR: Constructor
  // EN: Constructor
  PremiumTema({
    required this.themeId,
    required this.name,
    this.isDownloaded = false,
    this.isActive = false,
    this.localPath,
  });

  // TR: Boş constructor (Isar için)
  // EN: Empty constructor (for Isar)
  PremiumTema.empty();
}

/// TR: Veritabanı Servisi
/// EN: Database Service
class DatabaseService {
  static DatabaseService? _instance;
  late Isar isar;

  // TR: Singleton pattern
  // EN: Singleton pattern
  DatabaseService._internal();

  static DatabaseService get instance {
    _instance ??= DatabaseService._internal();
    return _instance!;
  }

  // TR: Veritabanını başlat
  // EN: Initialize the database
  Future<void> init() async {
    // TR: Uygulama döküman dizinini al
    // EN: Get application documents directory
    final dir = await getApplicationDocumentsDirectory();

    // TR: Isar'ı aç
    // EN: Open Isar
    isar = await Isar.open(
      [
        LaleBahcesiSchema,
        ZikirKaydiSchema,
        KazaNamaziSchema,
        PremiumTemaSchema,
      ],
      directory: dir.path,
    );

    print('TR: Isar veritabanı başarıyla başlatıldı: ${dir.path}');
    print('EN: Isar database successfully initialized: ${dir.path}');
  }

  // TR: Veritabanını kapat
  // EN: Close the database
  Future<void> close() async {
    await isar.close();
  }

  // TR: Veritabanını temizle
  // EN: Clear the database
  Future<void> clear() async {
    await isar.writeTxn(() async {
      await isar.laleBahcesis.clear();
      await isar.zikirKaydis.clear();
      await isar.kazaNamazis.clear();
      await isar.premiumTemas.clear();
    });
  }
}
