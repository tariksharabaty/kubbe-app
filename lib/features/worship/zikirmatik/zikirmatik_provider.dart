// TR: KUBBE V4 Zikirmatik Provider - V1'den miras alındı
// EN: KUBBE V4 Zikirmatik Provider - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki sayaç mantığını Riverpod 'Notifier' olarak yaz
// EN: Write V1's counter logic as Riverpod 'Notifier'
// TR: 'shared_preferences' ile sayıyı hafızada tut. 33 ve 99'da farklı titreşim (Haptic) ver
// EN: Keep count in memory with 'shared_preferences'. Give different haptic feedback at 33 and 99

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/haptic_utils.dart';

/// TR: KUBBE V4 Zikirmatik State Sınıfı
/// EN: KUBBE V4 Zikirmatik State Class
/// TR: Zikirmatik durumunu temsil eden veri modeli
/// EN: Data model representing zikirmatik state
/// TR: Sayaç, tarih ve diğer bilgileri içerir
/// EN: Contains counter, date and other information
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
class ZikirmatikState {
  // TR: Zikir sayısı
  // EN: Zikir count
  final int count;

  // TR: Başlangıç sayısı
  // EN: Start count
  final int startCount;

  // TR: Hedef sayı
  // EN: Target count
  final int targetCount;

  // TR: Son sıfırlama tarihi
  // EN: Last reset date
  final DateTime? lastResetDate;

  // TR: Bugünkü toplam
  // EN: Today's total
  final int todayTotal;

  // TR: Tüm zamanlar toplamı
  // EN: All time total
  final int allTimeTotal;

  // TR: Constructor
  // EN: Constructor
  const ZikirmatikState({
    required this.count,
    this.startCount = 0,
    this.targetCount = 33,
    this.lastResetDate,
    this.todayTotal = 0,
    this.allTimeTotal = 0,
  });

  // TR: CopyWith metodu
  // EN: CopyWith method
  ZikirmatikState copyWith({
    int? count,
    int? startCount,
    int? targetCount,
    DateTime? lastResetDate,
    int? todayTotal,
    int? allTimeTotal,
  }) {
    return ZikirmatikState(
      count: count ?? this.count,
      startCount: startCount ?? this.startCount,
      targetCount: targetCount ?? this.targetCount,
      lastResetDate: lastResetDate ?? this.lastResetDate,
      todayTotal: todayTotal ?? this.todayTotal,
      allTimeTotal: allTimeTotal ?? this.allTimeTotal,
    );
  }

  // TR: Equality operator
  // EN: Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ZikirmatikState &&
        other.count == count &&
        other.startCount == startCount &&
        other.targetCount == targetCount &&
        other.lastResetDate == lastResetDate &&
        other.todayTotal == todayTotal &&
        other.allTimeTotal == allTimeTotal;
  }

  // TR: Hash code
  // EN: Hash code
  @override
  int get hashCode {
    return Object.hash(
      count,
      startCount,
      targetCount,
      lastResetDate,
      todayTotal,
      allTimeTotal,
    );
  }

  // TR: Mevcut tur ilerlemesini al
  // EN: Get current round progress
  int getCurrentRoundProgress() {
    return count;
  }

  // TR: String representation
  // EN: String representation
  @override
  String toString() {
    return 'ZikirmatikState(count: $count, startCount: $startCount, targetCount: $targetCount)';
  }
}

/// TR: KUBBE V4 Zikirmatik Notifier Sınıfı
/// EN: KUBBE V4 Zikirmatik Notifier Class
/// TR: V1'deki sayaç mantığını Riverpod Notifier olarak uygular
/// EN: Implements V1's counter logic as Riverpod Notifier
/// TR: Zikir sayısını yönetir ve hafızada tutar
/// EN: Manages and stores zikir count in memory
/// TR: 33 ve 99'da özel titreşimler verir
/// EN: Gives special haptic feedback at 33 and 99
/// TR: shared_preferences ile kalıcı saklama
/// EN: Persistent storage with shared_preferences
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
class ZikirmatikNotifier extends Notifier<ZikirmatikState> {
  // TR: SharedPreferences instance
  // EN: SharedPreferences instance
  SharedPreferences? _prefs;

  // TR: Anahtarlar
  // EN: Keys
  static const String _countKey = 'zikirmatik_count';
  static const String _startCountKey = 'zikirmatik_start_count';
  static const String _targetCountKey = 'zikirmatik_target_count';
  static const String _lastResetKey = 'zikirmatik_last_reset';
  static const String _todayTotalKey = 'zikirmatik_today_total';
  static const String _allTimeTotalKey = 'zikirmatik_all_time_total';
  static const String _lastDateKey = 'zikirmatik_last_date';

  // TR: Başlangıç durumu
  // EN: Initial state
  @override
  ZikirmatikState build() {
    // TR: SharedPreferences'i başlat
    // EN: Initialize SharedPreferences
    _initializePrefs();

    // TR: Varsayılan durum
    // EN: Default state
    return const ZikirmatikState(count: 0);
  }

  // TR: SharedPreferences'i başlat
  // EN: Initialize SharedPreferences
  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();

    // TR: Kayıtlı değeri yükle
    // EN: Load saved value
    final count = _prefs?.getInt(_countKey) ?? 0;
    final startCount = _prefs?.getInt(_startCountKey) ?? 0;
    final targetCount = _prefs?.getInt(_targetCountKey) ?? 33;
    final lastResetDateStr = _prefs?.getString(_lastResetKey);
    final todayTotal = _prefs?.getInt(_todayTotalKey) ?? 0;
    final allTimeTotal = _prefs?.getInt(_allTimeTotalKey) ?? 0;

    // TR: Tarihi kontrol et
    // EN: Check date
    DateTime? lastResetDate;
    if (lastResetDateStr != null) {
      lastResetDate = DateTime.parse(lastResetDateStr);
    }

    // TR: Günlük sıfırlama kontrolü
    // EN: Daily reset check
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDateStr = _prefs?.getString(_lastDateKey) ?? '';
    final lastDate =
        lastDateStr.isNotEmpty ? DateTime.parse(lastDateStr) : null;

    if (lastDate == null || !isSameDay(lastDate, today)) {
      // TR: Yeni gün, sıfırla
      // EN: New day, reset
      state = ZikirmatikState(
        count: 0,
        startCount: 0,
        targetCount: targetCount,
        lastResetDate: today,
        todayTotal: 0,
        allTimeTotal: allTimeTotal,
      );

      // TR: Yeni tarihi kaydet
      // EN: Save new date
      await _prefs?.setString(_lastDateKey, today.toIso8601String());
      await _prefs?.setInt(_countKey, 0);
      await _prefs?.setInt(_startCountKey, 0);
      await _prefs?.setString(_lastResetKey, today.toIso8601String());
      await _prefs?.setInt(_todayTotalKey, 0);
    } else {
      // TR: Mevcut durumu yükle
      // EN: Load current state
      state = ZikirmatikState(
        count: count,
        startCount: startCount,
        targetCount: targetCount,
        lastResetDate: lastResetDate,
        todayTotal: todayTotal,
        allTimeTotal: allTimeTotal,
      );
    }
  }

  // TR: Zikir ekle
  // EN: Add zikir
  // TR: TR: Zikir sayısını bir artırır ve titreşim verir
  // EN: EN: Increments zikir count and gives haptic feedback
  Future<void> incrementZikir() async {
    final newCount = state.count + 1;
    final newTodayTotal = state.todayTotal + 1;
    final newAllTimeTotal = state.allTimeTotal + 1;

    // TR: Özel sayılarda titreşim
    // EN: Haptic feedback at special counts
    if (newCount == 33) {
      // TR: 33'te ulaşıldı - orta titreşim
      // EN: Reached 33 - medium haptic
      await HapticUtils.mediumImpact();
    } else if (newCount == 99) {
      // TR: 99'a ulaşıldı - güçlü titreşim
      // EN: Reached 99 - strong haptic
      await HapticUtils.heavyImpact();
    } else {
      // TR: Normal zikir - hafif titreşim
      // EN: Normal zikir - light haptic
      await HapticUtils.lightImpact();
    }

    // TR: Durumu güncelle
    // EN: Update state
    state = state.copyWith(
      count: newCount,
      todayTotal: newTodayTotal,
      allTimeTotal: newAllTimeTotal,
    );

    // TR: Kaydet
    // EN: Save
    await _saveState();
  }

  // TR: Zikir azalt
  // EN: Decrease zikir
  // TR: TR: Zikir sayısını bir azaltır
  // EN: EN: Decrements zikir count by one
  Future<void> decrementZikir() async {
    if (state.count > 0) {
      final newCount = state.count - 1;
      final newTodayTotal = state.todayTotal > 0 ? state.todayTotal - 1 : 0;
      final newAllTimeTotal =
          state.allTimeTotal > 0 ? state.allTimeTotal - 1 : 0;

      // TR: Hafif titreşim
      // EN: Light haptic
      await HapticUtils.lightImpact();

      // TR: Durumu güncelle
      // EN: Update state
      state = state.copyWith(
        count: newCount,
        todayTotal: newTodayTotal,
        allTimeTotal: newAllTimeTotal,
      );

      // TR: Kaydet
      // EN: Save
      await _saveState();
    }
  }

  // TR: Sıfırla
  // EN: Reset
  // TR: TR: Zikir sayacını sıfırlar
  // EN: EN: Resets zikir counter
  Future<void> resetZikir() async {
    // TR: Güçlü titreşim
    // EN: Strong haptic
    await HapticUtils.heavyImpact();

    // TR: Durumu güncelle
    // EN: Update state
    state = state.copyWith(
      count: 0,
      startCount: 0,
      lastResetDate: DateTime.now(),
    );

    // TR: Kaydet
    // EN: Save
    await _saveState();
  }

  // TR: Hedef sayı ayarla
  // EN: Set target count
  // TR: TR: Zikir hedef sayısını ayarlar
  // EN: EN: Sets zikir target count
  Future<void> setTargetCount(int targetCount) async {
    // TR: Hafif titreşim
    // EN: Light haptic
    await HapticUtils.lightImpact();

    // TR: Durumu güncelle
    // EN: Update state
    state = state.copyWith(targetCount: targetCount);

    // TR: Kaydet
    // EN: Save
    await _prefs?.setInt(_targetCountKey, targetCount);
  }

  // TR: Durumu kaydet
  // EN: Save state
  Future<void> _saveState() async {
    await _prefs?.setInt(_countKey, state.count);
    await _prefs?.setInt(_startCountKey, state.startCount);
    await _prefs?.setInt(_targetCountKey, state.targetCount);
    if (state.lastResetDate != null) {
      await _prefs?.setString(
          _lastResetKey, state.lastResetDate!.toIso8601String());
    }
    await _prefs?.setInt(_todayTotalKey, state.todayTotal);
    await _prefs?.setInt(_allTimeTotalKey, state.allTimeTotal);
  }

  // TR: Aynı gün mü kontrolü
  // EN: Same day check
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // TR: İlerleme yüzdesini al
  // EN: Get progress percentage
  double getProgressPercentage() {
    if (state.targetCount <= 0) return 0.0;
    return (state.count % state.targetCount) / state.targetCount;
  }

  // TR: Tamamlanan tur sayısını al
  // EN: Get completed rounds count
  int getCompletedRounds() {
    if (state.targetCount <= 0) return 0;
    return state.count ~/ state.targetCount;
  }

  // TR: Mevcut turdaki ilerlemeyi al
  // EN: Get current round progress
  int getCurrentRoundProgress() {
    if (state.targetCount <= 0) return 0;
    return state.count % state.targetCount;
  }
}

/// TR: Zikirmatik Provider - V4 yeniliği
/// EN: Zikirmatik Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
/// TR: V1'den miras alındı
/// EN: Inherited from V1
final zikirmatikProvider =
    NotifierProvider<ZikirmatikNotifier, ZikirmatikState>(() {
  return ZikirmatikNotifier();
});

/// TR: Zikirmatik State Provider - V4 yeniliği
/// EN: Zikirmatik State Provider - V4 innovation
/// TR: Mevcut zikirmatik durumunu sağlar
/// EN: Provides current zikirmatik state
final zikirmatikStateProvider = Provider<ZikirmatikState>((ref) {
  return ref.watch(zikirmatikProvider);
});
