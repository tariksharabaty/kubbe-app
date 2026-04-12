import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// [Hatim Veri Modeli - Hatim Data Model]
class HatimData {
  String? activePlan;
  String? planType; // [monthly, yearly, custom, ramadan]
  DateTime? targetDate;
  int readCuz;
  int readPage;
  int readAyet;

  HatimData({
    this.activePlan, 
    this.planType,
    this.targetDate,
    this.readCuz = 0, 
    this.readPage = 0, 
    this.readAyet = 0,
  });
}

// [Küresel Hatim Değişkeni - Global Hatim State]
final ValueNotifier<HatimData> globalHatimState = ValueNotifier(HatimData());

// [Hafızadan Yükle - Load from Storage]
// Uygulama açılışında çağrılmalıdır - Should be called on app startup
Future<void> initHatimState() async {
  final prefs = await SharedPreferences.getInstance();
  final targetStr = prefs.getString('hatim_target_date');
  globalHatimState.value = HatimData(
    activePlan: prefs.getString('hatim_plan'),
    planType: prefs.getString('hatim_plan_type'),
    targetDate: targetStr != null ? DateTime.parse(targetStr) : null,
    readCuz: prefs.getInt('hatim_cuz') ?? 0,
    readPage: prefs.getInt('hatim_page') ?? 0,
    readAyet: prefs.getInt('hatim_ayet') ?? 0,
  );
}

// [Hafızaya Kaydet - Save to Storage]
// Veriyi kalıcı olarak diske yazar - Persistently writes data to disk
Future<void> saveHatimState() async {
  final prefs = await SharedPreferences.getInstance();
  final data = globalHatimState.value;
  
  if (data.activePlan != null) {
    await prefs.setString('hatim_plan', data.activePlan!);
  } else {
    await prefs.remove('hatim_plan');
  }

  if (data.planType != null) {
    await prefs.setString('hatim_plan_type', data.planType!);
  } else {
    await prefs.remove('hatim_plan_type');
  }

  if (data.targetDate != null) {
    await prefs.setString('hatim_target_date', data.targetDate!.toIso8601String());
  } else {
    await prefs.remove('hatim_target_date');
  }

  await prefs.setInt('hatim_cuz', data.readCuz);
  await prefs.setInt('hatim_page', data.readPage);
  await prefs.setInt('hatim_ayet', data.readAyet);
}

// [İlerleme veya Plan Ekleme - Add Progress or Set Plan]
// Veriyi günceller ve anında kaydeder - Updates data and saves instantly
void addHatimProgress({int cuz = 0, int page = 0, int ayet = 0, String? newPlan}) {
  final current = globalHatimState.value;
  globalHatimState.value = HatimData(
    activePlan: newPlan ?? current.activePlan,
    readCuz: current.readCuz + cuz,
    readPage: current.readPage + page,
    readAyet: current.readAyet + ayet,
  );
  saveHatimState(); // [Değişikliği anında diske yaz - Write change to disk immediately]
}

// [Planı Sıfırla - Clear Plan]
// Hatim verilerini temizler - Clears hatim data
void clearHatimPlan() {
  globalHatimState.value = HatimData();
  saveHatimState();
}
