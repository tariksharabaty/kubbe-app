// TR: KUBBE V4 Database Initialization Service
// EN: KUBBE V4 Database Initialization Service
// TR: Uygulama başlangıcında veritabanını başlatmak için servis
// EN: Service for initializing database at app startup

import 'database_service.dart';

/// TR: Veritabanı başlatma servisi
/// EN: Database initialization service
class DatabaseInit {
  static bool _isInitialized = false;

  /// TR: Veritabanını başlatır
  /// EN: Initializes the database
  static Future<void> init() async {
    if (_isInitialized) {
      print('TR: Veritabanı zaten başlatılmış');
      print('EN: Database already initialized');
      return;
    }

    try {
      print('TR: Veritabanı başlatılıyor...');
      print('EN: Initializing database...');
      
      await DatabaseService.instance.init();
      
      _isInitialized = true;
      print('TR: Veritabanı başarıyla başlatıldı');
      print('EN: Database successfully initialized');
    } catch (e) {
      print('TR: Veritabanı başlatma hatası: $e');
      print('EN: Database initialization error: $e');
      rethrow;
    }
  }

  /// TR: Veritabanının başlatılıp başlatılmadığını kontrol eder
  /// EN: Checks if database is initialized
  static bool get isInitialized => _isInitialized;

  /// TR: Veritabanını kapatır
  /// EN: Closes the database
  static Future<void> close() async {
    if (_isInitialized) {
      await DatabaseService.instance.close();
      _isInitialized = false;
      print('TR: Veritabanı kapatıldı');
      print('EN: Database closed');
    }
  }

  /// TR: Veritabanını sıfırlar (geliştirme için)
  /// EN: Resets database (for development)
  static Future<void> reset() async {
    if (_isInitialized) {
      await DatabaseService.instance.clear();
      print('TR: Veritabanı sıfırlandı');
      print('EN: Database reset');
    }
  }
}
