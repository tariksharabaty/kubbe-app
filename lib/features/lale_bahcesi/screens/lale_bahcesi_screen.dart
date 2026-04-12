import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // [Kalıcı hafıza için - For persistent storage]

// [Lale Bahçesi Ekranı: Gelişmiş taç yapraklı çiçek tasarımı ve dinamik takvim - Tulip Garden Screen: Advanced petal design and dynamic calendar]
class LaleBahcesiScreen extends StatefulWidget {
  const LaleBahcesiScreen({super.key});

  @override
  State<LaleBahcesiScreen> createState() => _LaleBahcesiScreenState();
}

class _LaleBahcesiScreenState extends State<LaleBahcesiScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<bool> todaysPrayers = [false, false, false, false, false];
  
  // [Namaz renkleri ve isimleri - Prayer colors and names]
  final List<Color> prayerColors = [
    const Color(0xFFFFC107), 
    const Color(0xFFFF9800), 
    const Color(0xFFF44336), 
    const Color(0xFF4CAF50), 
    const Color(0xFF2196F3)
  ];
  final List<String> prayerNames = ["Sabah", "Öğle", "İkindi", "Akşam", "Yatsı"];
  
  DateTime currentMonth = DateTime.now();
  // [Boş Yapraklar: Varsayılan durum için - Empty Leaves: For default state]
  final List<bool> emptyLeaves = [false, false, false, false, false];
  final List<String> monthNames = [
    "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", 
    "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"
  ];

  @override
  void initState() {
    super.initState();
    // [Sekme kontrolcüsü başlatma - Initialize tab controller]
    _tabController = TabController(length: 2, vsync: this);
    _loadTodaysPrayers(); // [Hafızadan Yükle - Load from memory]
  }

  // [Bugünün namaz verilerini hafızadan yükle - Load today's prayer data from memory]
  Future<void> _loadTodaysPrayers() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayKey = "prayers_${now.year}_${now.month}_${now.day}";
    final savedData = prefs.getStringList(todayKey);
    
    if (savedData != null && savedData.length == 5) {
      if (mounted) {
        setState(() {
          todaysPrayers = savedData.map((e) => e == "true").toList();
        });
      }
    }
  }

  @override
  void dispose() {
    // [Kontrolcüyü serbest bırak - Dispose controller]
    _tabController.dispose();
    super.dispose();
  }

  // [Namaz durumunu değiştir ve kaydet - Toggle prayer status and save]
  void _togglePrayer(int index) async {
    HapticFeedback.lightImpact();
    setState(() {
      todaysPrayers[index] = !todaysPrayers[index];
    });

    // [Hafızaya Kaydet - Save to memory]
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayKey = "prayers_${now.year}_${now.month}_${now.day}";
    await prefs.setStringList(
      todayKey, 
      todaysPrayers.map((e) => e.toString()).toList()
    );
  }

  // [Ay gezintisi fonksiyonları - Month navigation functions]
  void _nextMonth() => setState(() => currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1));
  void _prevMonth() => setState(() => currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1));
  
  // [Yıl/Ay seçici diyaloğu - Year/Month selector dialog]
  Future<void> _selectYearMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: currentMonth, 
      firstDate: DateTime(2020), 
      lastDate: DateTime(2030), 
      initialDatePickerMode: DatePickerMode.year
    );
    if (picked != null) setState(() => currentMonth = picked);
  }

  // [Gelişmiş Gerçekçi Yaprak Çizimi - Advanced Realistic Petal Drawing]
  Widget _buildPetal(Color color, double angle, double size) {
    return Transform.rotate(
      angle: angle,
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size * 0.35, // [Yaprak genişliği - Petal width]
        height: size * 0.8, // [Yaprak uzunluğu - Petal length]
        decoration: BoxDecoration(
          color: color,
          // [Gül/Ağaç yaprağı formu veren özel ovallik - Special border radius for petal shape]
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size * 0.4),
            bottomRight: Radius.circular(size * 0.4),
            topRight: Radius.circular(size * 0.05),
            bottomLeft: Radius.circular(size * 0.05),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2)
          ],
        ),
      ),
    );
  }

  // [Dinamik Çiçek Oluşturucu - Dynamic Flower Builder]
  Widget _buildDynamicFlower(List<bool> activeList, double size, Color inactiveColor) {
    return SizedBox(
      width: size, 
      height: size,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: List.generate(5, (index) {
          // [5 yaprağı yelpaze gibi açan açılar - Angles to fan out 5 petals]
          double angle = (index - 2) * 0.45; 
          return Padding(
            padding: EdgeInsets.only(bottom: size * 0.1),
            child: _buildPetal(activeList[index] ? prayerColors[index] : inactiveColor, angle, size),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int currentStreak = todaysPrayers.where((p) => p).length;
    int percentage = (currentStreak / 5 * 100).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA), 
        elevation: 0, 
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(PhosphorIcons.caretLeft(), color: Colors.black, size: 28), 
          onPressed: () => Navigator.pop(context)
        ),
        title: const Text(
          "Lale Bahçesi", 
          style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // [Üst Banner Alanı - Top Banner Area]
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Container(
              width: double.infinity, 
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B0082), Color(0xFF6A0DAD)], 
                  begin: Alignment.topLeft, 
                  end: Alignment.bottomRight
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF4B0082).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Günlük Odak", 
                        style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Manevi Yolculuğun", 
                        style: TextStyle(fontFamily: 'Outfit', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2), 
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                          "Günlük İstikrar: %$percentage", 
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                  _buildDynamicFlower(todaysPrayers, 80, Colors.white.withValues(alpha: 0.15)),
                ],
              ),
            ),
          ),
          
          // [Sekme Seçici - Tab Bar]
          TabBar(
            controller: _tabController, 
            indicatorColor: const Color(0xFFFFC107), 
            indicatorSize: TabBarIndicatorSize.label, 
            indicatorWeight: 3, 
            labelColor: Colors.black, 
            unselectedLabelColor: Colors.grey, 
            labelStyle: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 16),
            tabs: const [Tab(text: "Haftalık"), Tab(text: "Aylık Bakış")],
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController, 
              children: [_buildWeeklyTab(), _buildMonthlyTab()]
            )
          ),
        ],
      ),
      
      // [Alt Etkileşim Butonları - Bottom Interaction Buttons]
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 40, left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)), 
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            bool isSelected = todaysPrayers[index];
            return GestureDetector(
              onTap: () => _togglePrayer(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300), 
                    width: 50, 
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, 
                      color: isSelected ? prayerColors[index] : Colors.grey.withValues(alpha: 0.1), 
                      boxShadow: [
                        if (isSelected) 
                          BoxShadow(color: prayerColors[index].withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 2)
                      ]
                    ),
                    child: Icon(PhosphorIcons.check(), color: isSelected ? Colors.white : Colors.transparent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prayerNames[index], 
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold, 
                      color: isSelected ? prayerColors[index] : Colors.grey
                    )
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // [Haftalık Sekme İçeriği - Weekly Tab Content]
  Widget _buildWeeklyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // [Haftalık Gün Kutuları - Weekly Day Boxes]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              bool isToday = index == DateTime.now().weekday - 1; 
              return Container(
                width: 40, 
                height: 40,
                decoration: BoxDecoration(
                  color: isToday ? const Color(0xFFFFC107).withValues(alpha: 0.2) : Colors.white,
                  borderRadius: BorderRadius.circular(12), 
                  border: Border.all(color: isToday ? const Color(0xFFFFC107) : Colors.grey.withValues(alpha: 0.2), width: 2),
                ),
                // [Sadece bugün canlı, diğer günler BOŞ (emptyLeaves) - Only today is active, others EMPTY]
                child: Center(
                  child: _buildDynamicFlower(
                    isToday ? todaysPrayers : emptyLeaves, 
                    24, 
                    Colors.grey.withValues(alpha: 0.15)
                  )
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          
          // [Haftalık Karne Paneli - Weekly Scorecard Panel]
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(24), 
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Haftalık Karneniz", 
                  style: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)
                ),
                const SizedBox(height: 20),
                ...List.generate(5, (index) {
                  // [Dinamik Haftalık Karne Verisi - Dynamic Weekly Stats]
                  int weeklyCount = todaysPrayers[index] ? 1 : 0; 
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${prayerNames[index]} Namazı", 
                              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)
                            ),
                            Text(
                              "$weeklyCount/7", 
                              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.black)
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // [Namaz İlerleme Çubuğu - Prayer Progress Bar]
                        Container(
                          width: double.infinity, 
                          height: 6, 
                          decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(3)),
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: (MediaQuery.of(context).size.width - 88) * (weeklyCount / 7),
                            height: 6,
                            decoration: BoxDecoration(color: prayerColors[index], borderRadius: BorderRadius.circular(3)),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // [Aylık Sekme İçeriği - Monthly Tab Content]
  Widget _buildMonthlyTab() {
    // [Dinamik Ay Gün Sayısı - Dynamic Month Days Calculation]
    int daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // [Ay/Yıl Seçici - Month/Year Selector]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(PhosphorIcons.caretLeft()), onPressed: _prevMonth),
              InkWell(
                onTap: () => _selectYearMonth(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "${monthNames[currentMonth.month - 1]} ${currentMonth.year}", 
                    style: const TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              IconButton(icon: Icon(PhosphorIcons.caretRight()), onPressed: _nextMonth),
            ],
          ),
          const SizedBox(height: 16),
          
          // [Aylık Takvim Izgarası - Monthly Calendar Grid]
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, 
                crossAxisSpacing: 10, 
                mainAxisSpacing: 10
              ),
              itemCount: daysInMonth, 
              itemBuilder: (context, index) {
                bool isToday = (
                  currentMonth.year == DateTime.now().year && 
                  currentMonth.month == DateTime.now().month && 
                  index + 1 == DateTime.now().day
                );
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isToday ? const Color(0xFFFFC107) : Colors.transparent, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5)
                    ],
                  ),
                  // [Sadece bugün canlı, diğer günler BOŞ (emptyLeaves) - Only today is active, others EMPTY]
                  child: Center(
                    child: _buildDynamicFlower(
                      isToday ? todaysPrayers : emptyLeaves, 
                      20, 
                      Colors.grey.withValues(alpha: 0.15)
                    )
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
