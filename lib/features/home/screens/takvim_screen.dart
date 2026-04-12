import 'package:flutter/material.dart';
import 'package:kubbe_app/core/widgets/custom_loading_animation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../home/services/ezan_vakti_service.dart';

// [Yeni Nesil Takvim Ekranı: TableCalendar + Dinamik Vakit Paneli - Next-Gen Calendar Screen: TableCalendar + Dynamic Prayer Panel]
class TakvimScreen extends StatefulWidget {
  const TakvimScreen({super.key});

  @override
  State<TakvimScreen> createState() => _TakvimScreenState();
}

class _TakvimScreenState extends State<TakvimScreen> {
  final EzanVaktiService _ezanService = EzanVaktiService();
  
  // [Takvim Durum Değişkenleri - Calendar State Variables]
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  
  Map<String, String>? _prayerTimes;
  bool _isLoading = false;
  String _hijriDate = "";
  String? _specialDayName;

  // [İşaretlenecek Önemli Dini Günler (2026) - Important Religious Days to Mark]
  final Map<DateTime, String> _religiousEvents = {
    DateTime(2026, 1, 15): "Miraç Kandili",
    DateTime(2026, 2, 2): "Berat Kandili",
    DateTime(2026, 2, 19): "Ramazan Ayı Başlangıcı",
    DateTime(2026, 3, 16): "Kadir Gecesi",
    DateTime(2026, 3, 20): "Ramazan Bayramı (1. Gün)",
    DateTime(2026, 3, 21): "Ramazan Bayramı (2. Gün)",
    DateTime(2026, 3, 22): "Ramazan Bayramı (3. Gün)",
    DateTime(2026, 5, 27): "Kurban Bayramı (1. Gün)",
    DateTime(2026, 6, 16): "Hicri Yılbaşı",
    DateTime(2026, 6, 25): "Aşure Günü",
    DateTime(2026, 8, 24): "Mevlid Kandili",
    DateTime(2026, 12, 10): "Regaib Kandili",
  };

  @override
  void initState() {
    super.initState();
    _loadDayData(_selectedDay);
  }

  // [Dinamik Veri Yükleyici - API ve Hicri Entegrasyonu]
  Future<void> _loadDayData(DateTime date) async {
    setState(() {
      _isLoading = true;
      _specialDayName = _checkSpecialDay(date);
    });

    // [Hicri Tarihi Hesapla - Hijri Date Calculation]
    final hijri = HijriCalendar.fromDate(date);
    _hijriDate = "${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear}";

    // [Vakitleri API'den çek (İstanbul Örneği) - Fetch times from API (Istanbul Example)]
    final allTimes = await _ezanService.getPrayerTimesByCity("539");
    
    if (allTimes.isNotEmpty) {
      final int dayIndex = (date.day - 1).clamp(0, allTimes.length - 1);
      final dayData = allTimes[dayIndex];

      if (mounted) {
        setState(() {
          _prayerTimes = {
            "İmsak": dayData['Imsak'],
            "Güneş": dayData['Gunes'],
            "Öğle": dayData['Ogle'],
            "İkindi": dayData['Ikindi'],
            "Akşam": dayData['Aksam'],
            "Yatsı": dayData['Yatsi'],
          };
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _checkSpecialDay(DateTime date) {
    for (var entry in _religiousEvents.entries) {
      if (entry.key.year == date.year && entry.key.month == date.month && entry.key.day == date.day) {
        return entry.value;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // [Modern Soft Arka Plan - Modern Soft Background]
      appBar: AppBar(
        title: const Text("Takvim & Vakitler", style: TextStyle(fontFamily: 'Outfit', color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // [1. Üst Kısım: İnteraktif Takvim - Top Section: Interactive Calendar]
          _buildCalendarSection(),

          // [2. Alt Panel: Detaylar ve Vakitler - Bottom Panel: Details and Times]
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // [Tarih Başlıkları - Date Headers]
                    Text(_hijriDate, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4B0082), fontFamily: 'Outfit')),
                    Text("${_selectedDay.day} ${_getMonthName(_selectedDay.month)} ${_selectedDay.year}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
                    
                    if (_specialDayName != null) ...[
                      const SizedBox(height: 16),
                      _buildSpecialDayInfoBanner(_specialDayName!),
                    ],

                    const SizedBox(height: 24),
                    
                    // [Namaz Vakitleri Izgarası - Prayer Times Grid]
                    _buildPrayerTimesGrid(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15)],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          _loadDayData(selectedDay);
        },
        onFormatChanged: (format) => setState(() => _calendarFormat = format),
        // [Noktalı İşaretleyici Mantığı - Dot Marker Logic]
        eventLoader: (day) {
          if (_checkSpecialDay(day) != null) return ['Event'];
          return [];
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return Positioned(
                bottom: 4,
                child: Container(
                  width: 5, height: 5,
                  decoration: const BoxDecoration(color: Color(0xFF4B0082), shape: BoxShape.circle),
                ),
              );
            }
            return null;
          },
        ),
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(color: Color(0xFF4B0082), shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: Color(0xFFE1BEE7), shape: BoxShape.circle),
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(color: Colors.redAccent),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildSpecialDayInfoBanner(String name) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFF4B0082).withValues(alpha: 0.1), const Color(0xFF4B0082).withValues(alpha: 0.05)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4B0082).withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Color(0xFF4B0082), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Günün Önemi", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                Text(name, style: const TextStyle(color: Color(0xFF4B0082), fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesGrid() {
    if (_isLoading) return const Padding(padding: EdgeInsets.all(40), child: Center(child: CustomLoadingAnimation()));
    
    if (_prayerTimes == null) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, 
        mainAxisSpacing: 12, 
        crossAxisSpacing: 12, 
        childAspectRatio: 0.9, // 3 sütun için daha dikey bir görünüm
      ),
      itemCount: _prayerTimes!.length,
      itemBuilder: (context, index) {
        String key = _prayerTimes!.keys.elementAt(index);
        String val = _prayerTimes!.values.elementAt(index);
        
        IconData iconData;
        switch (key) {
          case 'İmsak': iconData = Icons.wb_twilight; break;
          case 'Güneş': iconData = Icons.wb_sunny_outlined; break;
          case 'Öğle': iconData = Icons.wb_sunny; break;
          case 'İkindi': iconData = Icons.brightness_6; break;
          case 'Akşam': iconData = Icons.nights_stay_outlined; break;
          default: iconData = Icons.nightlight_round; // Yatsı
        }

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 3 sütunda merkezleme daha iyi durur
            children: [
              Icon(iconData, size: 20, color: const Color(0xFF4B0082).withValues(alpha: 0.8)),
              const SizedBox(height: 8),
              Text(key, style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(val, style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4B0082))),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"];
    return months[month - 1];
  }
}
