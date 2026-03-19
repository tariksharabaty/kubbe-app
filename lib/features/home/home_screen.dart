// TR: KUBBE V4 Home Screen - Sygrad Elite Redesign
// EN: KUBBE V4 Home Screen - Sygrad Elite Redesign

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../core/theme/app_theme.dart';
import '../../core/services/location_service.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/theme/theme_manager.dart';
import '../../core/services/prayer_service.dart';

/// TR: KUBBE V4 Home Screen Sınıfı
/// EN: KUBBE V4 Home Screen Class
/// TR: Tamamen yenilenmiş, "Purple Island" ve Grid yapılı yeni ana ekran
/// EN: Completely redesigned, new home screen with "Purple Island" and grid structure
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  LocationData? _currentLocation;
  late AnimationController _dotController;
  late Animation<double> _dotAnimation;
  Timer? _timer;
  DateTime _now = DateTime.now();
  PrayerTimesData? _prayerData;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    
    // TR: Saniye başı güncelleme için timer
    // EN: Timer for second-by-second updates
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });

    // TR: Eflatun nokta animasyonu kurulumu
    // EN: Purple dot animation setup
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _dotAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _dotController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dotController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final location = await LocationService.getSavedLocation();
    if (mounted) {
      setState(() {
        _currentLocation = location;
      });
      if (location != null) {
        final data = await PrayerService.getPrayerTimes(location);
        if (mounted) {
          setState(() {
            _prayerData = data;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TR: One UI Standard UI Yapısı - Full Screen
    // EN: One UI Standard UI Structure - Full Screen
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // TR: M3 Temiz Arka Plan // EN: M3 Clean Background
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildPurpleIsland(),
            _buildCleanGrid(),
            const SizedBox(height: 12),
            _buildSupportButton(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  // TR: Mor "Ada" (Island) Katmanı
  // EN: Purple "Island" Layer
  Widget _buildPurpleIsland() {
    final topPadding = MediaQuery.of(context).padding.top;
    
    // TR: Tarih formatlama (9 Mart 2026 Pazartesi formatı için)
    // EN: Date formatting (for 9 March 2026 Monday format)
    final df = DateFormat('d MMMM yyyy EEEE', 'tr_TR');
    final formattedDate = df.format(_now);
    
    // TR: Hicri Takvim
    final hDate = HijriCalendar.now();
    final hijriStr = "${hDate.hDay} ${hDate.longMonthName} ${hDate.hYear}";

    // TR: Vakit hesaplama logic
    String currentVakit = "İkindi";
    String nextVakit = "Akşam";
    String countdownStr = "00:00:00";
    
    if (_prayerData != null) {
      final next = _prayerData!.nextPrayerTime;
      if (next != null) {
        nextVakit = next.name;
        final diff = next.dateTime.difference(_now);
        final h = diff.inHours.toString().padLeft(2, '0');
        final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
        final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
        countdownStr = "$h:$m:$s";
      }
      currentVakit = _getCurrentVakitName();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(28, topPadding + 16, 28, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6A1B9A), // TR: Üst Mor // EN: Top Purple
            KubbeTheme.kubbeIndigo, // TR: #4B0082
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 25,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TR: Özel Üst Bar
          _buildCustomAppBar(),
          
          const SizedBox(height: 32),
          
          // TR: Miladi Tarih - Outfit Bold
          Text(
            formattedDate,
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // TR: Hicri Takvim - Inter
          Text(
            hijriStr,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // TR: Mevcut Vakit - Inter Eflatun
          Text(
            currentVakit,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFFE0B0FF),
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // TR: Zaman Sayaçı ve Saniye - Poppins Bold
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                DateFormat('HH:mm').format(_now),
                style: GoogleFonts.poppins(
                  fontSize: 88,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -2,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                ":${DateFormat('ss').format(_now)}",
                style: GoogleFonts.poppins(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE0B0FF),
                ),
              ),
              const SizedBox(width: 16),
              // TR: Eflatun nokta animasyonu
              FadeTransition(
                opacity: _dotAnimation,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0B0FF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Color(0xFFE0B0FF), blurRadius: 15, spreadRadius: 3)
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // TR: Geri Sayım Metni - Outfit
          Text(
            "$nextVakit vaktine $countdownStr kaldı",
            style: GoogleFonts.outfit(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // TR: Üst Bar (Konum ve İkonlar)
  Widget _buildCustomAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // TR: Konum Bölümü
        InkWell(
          onTap: () {
            HapticHelper.tokClick();
            _showLocationSelector();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  _currentLocation?.city ?? "İstanbul, Türkiye",
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Icon(Icons.arrow_drop_down_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    HapticHelper.tokClick();
                    _getCurrentLocation();
                  },
                  icon: const Icon(Icons.gps_fixed_rounded, color: Colors.white, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
        
        // TR: İkonlar Bölümü
        Row(
          children: [
            IconButton(
              onPressed: () => HapticHelper.tokClick(),
              icon: const Icon(Icons.bookmark_outline_rounded, color: Colors.white, size: 28),
            ),
            IconButton(
              onPressed: () => HapticHelper.tokClick(),
              icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 28),
            ),
          ],
        ),
      ],
    );
  }

  // TR: Vakitler Izgarası (Grid) - 2 Sütun x 3 Satır
  Widget _buildCleanGrid() {
    if (_prayerData == null) {
      return const Padding(
        padding: EdgeInsets.all(60.0),
        child: CircularProgressIndicator(color: KubbeTheme.kubbeIndigo),
      );
    }
    
    final times = [
      {'name': 'İmsak', 'time': _prayerData!.imsak.time, 'icon': Icons.wb_twilight_rounded},
      {'name': 'Güneş', 'time': _prayerData!.gunes.time, 'icon': Icons.wb_sunny_outlined},
      {'name': 'Öğle', 'time': _prayerData!.ogle.time, 'icon': Icons.wb_sunny_rounded},
      {'name': 'İkindi', 'time': _prayerData!.ikindi.time, 'icon': Icons.lightbulb_outline},
      {'name': 'Akşam', 'time': _prayerData!.aksam.time, 'icon': Icons.nightlight_round},
      {'name': 'Yatsı', 'time': _prayerData!.yatsi.time, 'icon': Icons.nights_stay_rounded},
    ];

    final currentVakitName = _getCurrentVakitName();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: times.map((data) {
          final isNext = data['name'] == currentVakitName;
          return _buildVakitCard(
            data['name'] as String,
            data['time'] as String,
            data['icon'] as IconData,
            isNext,
          );
        }).toList(),
      ),
    );
  }

  // TR: Vakit Kartı - One UI 32dp Radius
  Widget _buildVakitCard(String name, String time, IconData icon, bool isHighlighted) {
    return Container(
      decoration: BoxDecoration(
        color: isHighlighted ? KubbeTheme.kubbeIndigo : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: isHighlighted 
                ? KubbeTheme.kubbeIndigo.withValues(alpha: 0.3) 
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => HapticHelper.tokClick(),
          borderRadius: BorderRadius.circular(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isHighlighted ? Colors.white : Colors.grey.shade400,
                size: 32,
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isHighlighted ? Colors.white.withValues(alpha: 0.9) : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TR: Destek Ol Butonu - One UI 32dp Radius
  Widget _buildSupportButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: KubbeTheme.kubbeIndigo,
          minimumSize: const Size(double.infinity, 72),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 4,
          shadowColor: Colors.black12,
        ),
        onPressed: () {
          HapticHelper.tokClick();
          _showSupportDialog();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 28),
            const SizedBox(width: 14),
            Text(
              'Destek Ol',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TR: Yardımcı Mantıksal Metotlar
  // EN: Helper Logical Methods

  String _getCurrentVakitName() {
    if (_prayerData == null) return "İkindi";
    final now = _now;
    if (now.isBefore(_prayerData!.imsak.dateTime)) return "Yatsı";
    if (now.isBefore(_prayerData!.gunes.dateTime)) return "İmsak";
    if (now.isBefore(_prayerData!.ogle.dateTime)) return "Güneş";
    if (now.isBefore(_prayerData!.ikindi.dateTime)) return "Öğle";
    if (now.isBefore(_prayerData!.aksam.dateTime)) return "İkindi";
    if (now.isBefore(_prayerData!.yatsi.dateTime)) return "Akşam";
    return "Yatsı";
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = await LocationService.getCurrentLocation();
      if (location != null) {
        setState(() => _currentLocation = location);
        final data = await PrayerService.getPrayerTimes(location);
        if (mounted) setState(() => _prayerData = data);
      }
    } catch (e) {
      debugPrint("Konum hatası: $e");
    }
  }

  void _showLocationSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text("Şehir Seç", style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: LocationService.turkishCities.length,
                itemBuilder: (context, index) {
                  final city = LocationService.turkishCities[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
                    title: Text(city.name, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500)),
                    onTap: () async {
                      Navigator.pop(context);
                      final loc = await LocationService.selectManualCity(city);
                      setState(() => _currentLocation = loc);
                      final data = await PrayerService.getPrayerTimes(loc);
                      if (mounted) setState(() => _prayerData = data);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: Text("Teşekkürler", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Text("Desteğiniz bizim için çok kıymetli. Kubbe V4 sizi seviyor!", style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Harika", style: GoogleFonts.outfit(color: KubbeTheme.kubbeIndigo, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
