// TR: KUBBE V4 Prayer Tracker Provider - V1'den miras alındı
// EN: KUBBE V4 Prayer Tracker Provider - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki namaz işaretleme mantığını aktar
// EN: Transfer V1's prayer marking logic
// TR: 'isCompleted' durumunu tarih bazlı (YYYY-MM-DD) olarak 'shared_preferences' içinde sakla
// EN: Store 'isCompleted' status in 'shared_preferences' in date-based format (YYYY-MM-DD)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/haptic_utils.dart';

/// TR: KUBBE V4 Prayer Tracker State Sınıfı
/// EN: KUBBE V4 Prayer Tracker State Class
/// TR: Namaz takibi durumunu temsil eden veri modeli
/// EN: Data model representing prayer tracking state
/// TR: Tarih bazlı namaz durumlarını içerir
/// EN: Contains date-based prayer statuses
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
class PrayerTrackerState {
  // TR: Namaz durumları
  // EN: Prayer statuses
  final Map<String, bool> prayerStatuses;

  // TR: Son güncelleme tarihi
  // EN: Last update date
  final DateTime lastUpdateDate;

  // TR: Tamamlanan namaz sayısı
  // EN: Completed prayer count
  final int completedCount;

  // TR: Toplam namaz sayısı
  // EN: Total prayer count
  final int totalCount;

  // TR: Constructor
  // EN: Constructor
  const PrayerTrackerState({
    required this.prayerStatuses,
    required this.lastUpdateDate,
    this.completedCount = 0,
    this.totalCount = 5,
  });

  // TR: CopyWith metodu
  // EN: CopyWith method
  PrayerTrackerState copyWith({
    Map<String, bool>? prayerStatuses,
    DateTime? lastUpdateDate,
    int? completedCount,
    int? totalCount,
  }) {
    return PrayerTrackerState(
      prayerStatuses: prayerStatuses ?? this.prayerStatuses,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      completedCount: completedCount ?? this.completedCount,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  // TR: Equality operator
  // EN: Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrayerTrackerState &&
        other.prayerStatuses == prayerStatuses &&
        other.lastUpdateDate == lastUpdateDate &&
        other.completedCount == completedCount &&
        other.totalCount == totalCount;
  }

  // TR: Hash code
  // EN: Hash code
  @override
  int get hashCode {
    return Object.hash(
      prayerStatuses,
      lastUpdateDate,
      completedCount,
      totalCount,
    );
  }

  // TR: String representation
  // EN: String representation
  @override
  String toString() {
    return 'PrayerTrackerState(completedCount: $completedCount, lastUpdateDate: $lastUpdateDate)';
  }
}

/// TR: KUBBE V4 Prayer Tracker Notifier Sınıfı
/// EN: KUBBE V4 Prayer Tracker Notifier Class
/// TR: V1'deki namaz işaretleme mantığını Riverpod Notifier olarak uygular
/// EN: Implements V1's prayer marking logic as Riverpod Notifier
/// TR: Namaz durumlarını yönetir ve tarih bazlı olarak saklar
/// EN: Manages prayer statuses and stores them in date-based format
/// TR: YYYY-MM-DD formatında shared_preferences içinde saklama
/// EN: Stores in shared_preferences in YYYY-MM-DD format
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
class PrayerTrackerNotifier extends Notifier<PrayerTrackerState> {
  // TR: SharedPreferences instance
  // EN: SharedPreferences instance
  SharedPreferences? _prefs;

  // TR: Namaz anahtarları
  // EN: Prayer keys
  static const List<String> _prayerKeys = [
    'fajr', // TR: İmsak // EN: Fajr
    'dhuhr', // TR: Öğle // EN: Dhuhr
    'asr', // TR: İkindi // EN: Asr
    'maghrib', // TR: Akşam // EN: Maghrib
    'isha', // TR: Yatsı // EN: Isha
  ];

  // TR: Namaz isimleri (Türkçe)
  // EN: Prayer names (Turkish)
  static const List<String> _prayerNamesTR = [
    'İmsak',
    'Öğle',
    'İkindi',
    'Akşam',
    'Yatsı',
  ];

  // TR: Başlangıç durumu
  // EN: Initial state
  @override
  PrayerTrackerState build() {
    // TR: SharedPreferences'i başlat
    // EN: Initialize SharedPreferences
    _initializePrefs();

    // TR: Varsayılan durum
    // EN: Default state
    return PrayerTrackerState(
      prayerStatuses: {},
      lastUpdateDate: DateTime.now(),
      completedCount: 0,
      totalCount: 5,
    );
  }

  // TR: SharedPreferences'i başlat
  // EN: Initialize SharedPreferences
  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();

    // TR: Bugünün durumunu yükle
    // EN: Load today's status
    await _loadTodayStatus();
  }

  // TR: Bugünün durumunu yükle
  // EN: Load today's status
  Future<void> _loadTodayStatus() async {
    final now = DateTime.now();
    final todayKey = _getTodayKey(now);

    // TR: Bugünün namaz durumlarını yükle
    // EN: Load today's prayer statuses
    final prayerStatuses = <String, bool>{};
    int completedCount = 0;

    for (int i = 0; i < _prayerKeys.length; i++) {
      final prayerKey = _prayerKeys[i];
      final statusKey = '${todayKey}_$prayerKey';
      final isCompleted = _prefs?.getBool(statusKey) ?? false;

      prayerStatuses[prayerKey] = isCompleted;
      if (isCompleted) {
        completedCount++;
      }
    }

    // TR: Son güncelleme tarihini al
    // EN: Get last update date
    final lastUpdateStr = _prefs?.getString('${todayKey}_lastUpdate');
    final lastUpdateDate =
        lastUpdateStr != null ? DateTime.parse(lastUpdateStr) : now;

    // TR: Durumu güncelle
    // EN: Update state
    state = PrayerTrackerState(
      prayerStatuses: prayerStatuses,
      lastUpdateDate: lastUpdateDate,
      completedCount: completedCount,
      totalCount: _prayerKeys.length,
    );
  }

  // TR: Bugünün anahtarını al
  // EN: Get today's key
  String _getTodayKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // TR: Namaz durumunu değiştir
  // EN: Toggle prayer status
  // TR: TR: Belirtilen namazın durumunu değiştirir (tamamlandı/tamamlanmadı)
  // EN: EN: Toggles the status of specified prayer (completed/incomplete)
  Future<void> togglePrayerStatus(String prayerKey) async {
    final now = DateTime.now();
    final todayKey = _getTodayKey(now);
    final statusKey = '${todayKey}_$prayerKey';

    // TR: Mevcut durumu al
    // EN: Get current status
    final currentStatus = state.prayerStatuses[prayerKey] ?? false;
    final newStatus = !currentStatus;

    // TR: Titreşim ver
    // EN: Give haptic feedback
    if (newStatus) {
      // TR: Namaz tamamlandı - başarı titreşimi
      // EN: Prayer completed - success vibration
      await HapticUtils.successVibration();
    } else {
      // TR: Namaz iptal edildi - hafif titreşim
      // EN: Prayer cancelled - light vibration
      await HapticUtils.lightImpact();
    }

    // TR: Durumu güncelle
    // EN: Update status
    final newPrayerStatuses = Map<String, bool>.from(state.prayerStatuses);
    newPrayerStatuses[prayerKey] = newStatus;

    // TR: Tamamlanan sayacı hesapla
    // EN: Calculate completed count
    final newCompletedCount =
        newPrayerStatuses.values.where((status) => status).length;

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(
      prayerStatuses: newPrayerStatuses,
      lastUpdateDate: now,
      completedCount: newCompletedCount,
    );

    // TR: Kaydet
    // EN: Save
    await _prefs?.setBool(statusKey, newStatus);
    await _prefs?.setString('${todayKey}_lastUpdate', now.toIso8601String());
  }

  // TR: Namaz durumunu ayarla
  // EN: Set prayer status
  // TR: TR: Belirtilen namazın durumunu ayarlar
  // EN: EN: Sets the status of specified prayer
  Future<void> setPrayerStatus(String prayerKey, bool isCompleted) async {
    final now = DateTime.now();
    final todayKey = _getTodayKey(now);
    final statusKey = '${todayKey}_$prayerKey';

    // TR: Mevcut durumla aynı mı kontrol et
    // EN: Check if same as current status
    if (state.prayerStatuses[prayerKey] == isCompleted) {
      return;
    }

    // TR: Titreşim ver
    // EN: Give haptic feedback
    if (isCompleted) {
      // TR: Namaz tamamlandı - başarı titreşimi
      // EN: Prayer completed - success vibration
      await HapticUtils.successVibration();
    } else {
      // TR: Namaz iptal edildi - hafif titreşim
      // EN: Prayer cancelled - light vibration
      await HapticUtils.lightImpact();
    }

    // TR: Durumu güncelle
    // EN: Update status
    final newPrayerStatuses = Map<String, bool>.from(state.prayerStatuses);
    newPrayerStatuses[prayerKey] = isCompleted;

    // TR: Tamamlanan sayacı hesapla
    // EN: Calculate completed count
    final newCompletedCount =
        newPrayerStatuses.values.where((status) => status).length;

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(
      prayerStatuses: newPrayerStatuses,
      lastUpdateDate: now,
      completedCount: newCompletedCount,
    );

    // TR: Kaydet
    // EN: Save
    await _prefs?.setBool(statusKey, isCompleted);
    await _prefs?.setString('${todayKey}_lastUpdate', now.toIso8601String());
  }

  // TR: Tüm namazları tamamlandı olarak işaretle
  // EN: Mark all prayers as completed
  // TR: TR: Bugünkü tüm namazları tamamlandı olarak işaretler
  // EN: EN: Marks all prayers of today as completed
  Future<void> markAllPrayersCompleted() async {
    final now = DateTime.now();
    final todayKey = _getTodayKey(now);

    // TR: Güçlü titreşim ver
    // EN: Give strong haptic feedback
    await HapticUtils.heavyImpact();

    // TR: Tüm namazları tamamlandı olarak ayarla
    // EN: Set all prayers as completed
    final newPrayerStatuses = <String, bool>{};
    for (final prayerKey in _prayerKeys) {
      newPrayerStatuses[prayerKey] = true;
      final statusKey = '${todayKey}_$prayerKey';
      await _prefs?.setBool(statusKey, true);
    }

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(
      prayerStatuses: newPrayerStatuses,
      lastUpdateDate: now,
      completedCount: _prayerKeys.length,
    );

    // TR: Son güncelleme tarihini kaydet
    // EN: Save last update date
    await _prefs?.setString('${todayKey}_lastUpdate', now.toIso8601String());
  }

  // TR: Tüm namazları sıfırla
  // EN: Reset all prayers
  // TR: TR: Bugünkü tüm namaz durumlarını sıfırlar
  // EN: EN: Resets all prayer statuses of today
  Future<void> resetAllPrayers() async {
    final now = DateTime.now();
    final todayKey = _getTodayKey(now);

    // TR: Güçlü titreşim ver
    // EN: Give strong haptic feedback
    await HapticUtils.heavyImpact();

    // TR: Tüm namazları sıfırla
    // EN: Reset all prayers
    final newPrayerStatuses = <String, bool>{};
    for (final prayerKey in _prayerKeys) {
      newPrayerStatuses[prayerKey] = false;
      final statusKey = '${todayKey}_$prayerKey';
      await _prefs?.setBool(statusKey, false);
    }

    // TR: State'i güncelle
    // EN: Update state
    state = state.copyWith(
      prayerStatuses: newPrayerStatuses,
      lastUpdateDate: now,
      completedCount: 0,
    );

    // TR: Son güncelleme tarihini kaydet
    // EN: Save last update date
    await _prefs?.setString('${todayKey}_lastUpdate', now.toIso8601String());
  }

  // TR: Namaz durumunu al
  // EN: Get prayer status
  // TR: TR: Belirtilen namazın durumunu döndürür
  // EN: EN: Returns the status of specified prayer
  bool getPrayerStatus(String prayerKey) {
    return state.prayerStatuses[prayerKey] ?? false;
  }

  // TR: Namaz ismini al
  // EN: Get prayer name
  // TR: TR: Belirtilen namazın Türkçe adını döndürür
  // EN: EN: Returns Turkish name of specified prayer
  String getPrayerName(String prayerKey, {String language = 'tr'}) {
    final index = _prayerKeys.indexOf(prayerKey);
    if (index >= 0 && index < _prayerNamesTR.length) {
      return _prayerNamesTR[index];
    }
    return prayerKey;
  }

  // TR: İlerleme yüzdesini al
  // EN: Get progress percentage
  // TR: TR: Tamamlanan namazların yüzdesini döndürür
  // EN: EN: Returns percentage of completed prayers
  double getProgressPercentage() {
    if (state.totalCount <= 0) return 0.0;
    return state.completedCount / state.totalCount;
  }

  // TR: Tüm namazlar tamamlandı mı?
  // EN: Are all prayers completed?
  // TR: TR: Tüm namazların tamamlandığını kontrol eder
  // EN: EN: Checks if all prayers are completed
  bool areAllPrayersCompleted() {
    return state.completedCount == state.totalCount;
  }

  // TR: Geçmiş günlerin durumunu al
  // EN: Get past days status
  // TR: TR: Geçmiş bir günün namaz durumlarını döndürür
  // EN: EN: Returns prayer statuses of a past day
  Future<Map<String, bool>> getPastDayStatus(DateTime date) async {
    final dayKey = _getTodayKey(date);
    final prayerStatuses = <String, bool>{};

    for (final prayerKey in _prayerKeys) {
      final statusKey = '${dayKey}_$prayerKey';
      final isCompleted = _prefs?.getBool(statusKey) ?? false;
      prayerStatuses[prayerKey] = isCompleted;
    }

    return prayerStatuses;
  }

  // TR: İstatistikleri al
  // EN: Get statistics
  // TR: TR: Namaz takibi istatistiklerini döndürür
  // EN: EN: Returns prayer tracking statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final now = DateTime.now();
    final statistics = <String, dynamic>{};

    // TR: Son 7 günün istatistikleri
    // EN: Last 7 days statistics
    final last7DaysStats = <Map<String, dynamic>>[];
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final dayKey = _getTodayKey(date);
      final dayStatuses = await getPastDayStatus(date);
      final completedCount =
          dayStatuses.values.where((status) => status).length;

      last7DaysStats.add({
        'date': date.toIso8601String(),
        'dayKey': dayKey,
        'completedCount': completedCount,
        'totalCount': _prayerKeys.length,
        'percentage': completedCount / _prayerKeys.length,
      });
    }

    statistics['last7Days'] = last7DaysStats;
    statistics['today'] = {
      'completedCount': state.completedCount,
      'totalCount': state.totalCount,
      'percentage': getProgressPercentage(),
      'lastUpdate': state.lastUpdateDate.toIso8601String(),
    };

    return statistics;
  }
}

/// TR: Prayer Tracker Provider - V4 yeniliği
/// EN: Prayer Tracker Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
/// TR: V1'den miras alındı
/// EN: Inherited from V1
final prayerTrackerProvider =
    NotifierProvider<PrayerTrackerNotifier, PrayerTrackerState>(() {
  return PrayerTrackerNotifier();
});

/// TR: Prayer Tracker State Provider - V4 yeniliği
/// EN: Prayer Tracker State Provider - V4 innovation
/// TR: Mevcut namaz takibi durumunu sağlar
/// EN: Provides current prayer tracking state
final prayerTrackerStateProvider = Provider<PrayerTrackerState>((ref) {
  return ref.watch(prayerTrackerProvider);
});
