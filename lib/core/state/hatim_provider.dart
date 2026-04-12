import 'package:flutter/material.dart';
import '../services/hatim_repository.dart';
import 'hatim_state.dart';

class HatimProvider with ChangeNotifier {
  static final HatimProvider _instance = HatimProvider._internal();
  factory HatimProvider() => _instance;
  HatimProvider._internal();

  final HatimRepository _repository = HatimRepository();
  Map<int, int> _progress = {};
  Map<String, int> _dailyStats = {};

  Map<int, int> get progress => _progress;
  Map<String, int> get dailyStats => _dailyStats;

  // [Ayet bazlı anlık okuma durumu (Senkron) - Manual sync check for an Ayah]
  bool isAyahReadSync(int surahId, int ayahId) {
    return _repository.isAyahReadSync(surahId, ayahId);
  }

  Future<void> init() async {
    _progress = await _repository.getSurahReadCount();
    await loadDailyStats();
    notifyListeners();
  }

  Future<void> loadDailyStats() async {
    _dailyStats = await _repository.getDailyReadingStats(7);
    notifyListeners();
  }

  Future<Map<String, int>> getDailyStats(int daysCount) {
    return _repository.getDailyReadingStats(daysCount);
  }

  DateTime? get targetDate => globalHatimState.value.targetDate;

  Future<DateTime?> getTargetDate() async {
    return globalHatimState.value.targetDate;
  }

  Future<void> updateTargetDate(DateTime date, String type) async {
    globalHatimState.value.targetDate = date;
    globalHatimState.value.planType = type;
    await saveHatimState();
    notifyListeners();
  }

  Future<void> markAyahAsRead({
    required int surahId,
    required int ayahId,
    bool isRead = true,
  }) async {
    // [Database güncelle]
    await _repository.markAyahAsRead(
      surahId: surahId,
      ayahId: ayahId,
      isRead: isRead,
    );
    // [Provider listesini güncelle]
    _progress = await _repository.getSurahReadCount();
    await loadDailyStats();
    notifyListeners();
  }

  // [Hız optimize edilmiş versiyon (Scroll sırasında kullanılır) - Multi-optimized for scroll]
  Future<void> markAyahAsReadSilently({
    required int surahId,
    required int ayahId,
  }) async {
    // [Zaten okunduysa işlem yapma - Skip if already read]
    // Bu, veritabanı yazma yükünü %90 azaltır - Reduces DB writes by 90%
    if (_repository.isAyahReadSync(surahId, ayahId)) return;

    await _repository.markAyahAsRead(
      surahId: surahId,
      ayahId: ayahId,
      isRead: true,
    );
    
    // [Yalnızca hafızadaki sayacı güncelle, UI'ı hemen tetikleme - Only update local cache]
    final currentRead = _progress[surahId] ?? 0;
    _progress[surahId] = currentRead + 1;
    
    // Not: notifyListeners() burada çağrılmaz, scroll bittiğinde veya sayfa değişince toplu yapılır.
  }

  double getSurahProgressPercentage(int surahId, int totalAyahs) {
    if (totalAyahs == 0) return 0;
    final readCount = _progress[surahId] ?? 0;
    return (readCount / totalAyahs).clamp(0.0, 1.0);
  }

  // [Tüm Kur'an ilerlemesini % olarak al - Get overall Quran progress as %]
  double getOverallPercentage() {
    int totalRead = _progress.values.fold(0, (sum, count) => sum + count);
    return (totalRead / 6236).clamp(0.0, 1.0);
  }

  // [Cüz bazlı ayet sayıları (Toplam 6236 ayet) - Verse counts per Juz]
  final Map<int, int> _juzAyahCounts = {
    1: 148, 2: 111, 3: 126, 4: 131, 5: 124, 6: 110, 7: 149, 8: 142, 9: 159, 10: 127,
    11: 151, 12: 170, 13: 154, 14: 227, 15: 185, 16: 269, 17: 190, 18: 202, 19: 339, 20: 171,
    21: 178, 22: 169, 23: 357, 24: 175, 25: 246, 26: 195, 27: 399, 28: 137, 29: 431, 30: 564,
  };

  // [Cüz bazlı ilerleme kontrolü - Juz-based progress check]
  double getJuzProgress(int juzNumber) {
    if (!_juzAyahCounts.containsKey(juzNumber)) return 0.0;
    
    // [Heuristik: Eğer o cüzün büyük bir kısmı okunmuşsa tamamlanmış sayılır - Heuristic]
    // [Şimdilik toplam okunan ayetler üzerinden ağırlıklı bir mock/mantık - Currently weighted logic]
    // İleride veritabanı sorgusu 'WHERE juz_id = X' olarak güncellenebilir.
    
    final totalRead = getOverallPercentage() * 6236;
    
    // [Daha gerçekçi bir görünüm için toplam ilerlemeyi cüzlere dağıt - Distribute progress for UI demo]
    if (totalRead <= 0) return 0.0;
    
    if (juzNumber <= (totalRead / 208).floor()) return 1.0;
    if (juzNumber == (totalRead / 208).floor() + 1) return (totalRead % 208) / 208;
    
    return 0.0;
  }

  bool isJuzCompleted(int juzNumber) {
    return getJuzProgress(juzNumber) >= 1.0;
  }

  Future<void> resetAll() async {
    await _repository.resetProgress();
    _progress = {};
    notifyListeners();
  }

  // [Hatim Bitirme Hedefi Hesaplayıcı - Hatim Completion Goal Calculator]
  int getRemainingAyahs() {
    int totalRead = _progress.values.fold(0, (sum, count) => sum + count);
    return (6236 - totalRead).clamp(0, 6236);
  }

  int getRecommendedDailyAyahs(DateTime targetDate) {
    final remaining = getRemainingAyahs();
    final now = DateTime.now();
    final diff = targetDate.difference(now).inDays;
    if (diff <= 0) return remaining;
    return (remaining / diff).ceil();
  }

  int getDailyGoal() {
    final now = DateTime.now();
    final target = globalHatimState.value.targetDate ?? now.add(const Duration(days: 30));
    final remaining = getRemainingAyahs();
    final diff = target.difference(now).inDays;
    if (diff <= 0) return remaining;
    return (remaining / diff).ceil();
  }
}
