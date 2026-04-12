import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../home/services/ezan_vakti_service.dart';
import 'package:kubbe_app/core/widgets/custom_loading_animation.dart';
import 'package:kubbe_app/core/constants/religious_data.dart'; // [Dini Günler Detay Verisi - Religious Day Detail Data]
import '../../../core/services/history_service.dart';

class DiniGunlerScreen extends StatefulWidget {
  const DiniGunlerScreen({super.key});

  @override
  State<DiniGunlerScreen> createState() => _DiniGunlerScreenState();
}

class _CurrentReligiousDay {
  final String date;
  final String dayName;
  final String hijri;
  final String name;
  final Color color;

  _CurrentReligiousDay({
    required this.date,
    required this.dayName,
    required this.hijri,
    required this.name,
    required this.color,
  });
}

class _DiniGunlerScreenState extends State<DiniGunlerScreen> {
  final EzanVaktiService _ezanService = EzanVaktiService();
  List<dynamic> _apiDays = [];
  bool _isLoading = true;

  // [Statik 2026 verileri ve gün isimleri - Static 2026 data and day names]
  final List<_CurrentReligiousDay> _staticDays = [
    _CurrentReligiousDay(date: "15 Ocak 2026", dayName: "Perşembe", hijri: "26 Recep 1447", name: "Miraç Kandili", color: const Color(0xFF9C27B0)),
    _CurrentReligiousDay(date: "2 Şubat 2026", dayName: "Pazartesi", hijri: "14 Şaban 1447", name: "Berat Kandili", color: const Color(0xFF673AB7)),
    _CurrentReligiousDay(date: "19 Şubat 2026", dayName: "Perşembe", hijri: "1 Ramazan 1447", name: "Ramazan Ayı Başlangıcı", color: const Color(0xFF4CAF50)),
    _CurrentReligiousDay(date: "16 Mart 2026", dayName: "Pazartesi", hijri: "26 Ramazan 1447", name: "Kadir Gecesi", color: const Color(0xFFFFC107)),
    _CurrentReligiousDay(date: "20 Mart 2026", dayName: "Cuma", hijri: "1 Şevval 1447", name: "Ramazan Bayramı (1. Gün)", color: const Color(0xFFE91E63)),
    _CurrentReligiousDay(date: "21 Mart 2026", dayName: "Cumartesi", hijri: "2 Şevval 1447", name: "Ramazan Bayramı (2. Gün)", color: const Color(0xFFE91E63)),
    _CurrentReligiousDay(date: "22 Mart 2026", dayName: "Pazar", hijri: "3 Şevval 1447", name: "Ramazan Bayramı (3. Gün)", color: const Color(0xFFE91E63)),
    _CurrentReligiousDay(date: "27 Mayıs 2026", dayName: "Çarşamba", hijri: "10 Zilhicce 1447", name: "Kurban Bayramı (1. Gün)", color: const Color(0xFF2196F3)),
    _CurrentReligiousDay(date: "25 Haziran 2026", dayName: "Perşembe", hijri: "10 Muharrem 1448", name: "Aşure Günü", color: const Color(0xFF795548)),
    _CurrentReligiousDay(date: "24 Ağustos 2026", dayName: "Pazartesi", hijri: "11 Rebiülevvel 1448", name: "Mevlid Kandili", color: const Color(0xFFFF5722)),
    _CurrentReligiousDay(date: "10 Aralık 2026", dayName: "Perşembe", hijri: "1 Recep 1448", name: "Regaib Kandili", color: const Color(0xFF9C27B0)),
  ];

  @override
  void initState() {
    super.initState();
    _fetchDays();
    HistoryService.updates.addListener(_onServiceUpdate);
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    HistoryService.updates.removeListener(_onServiceUpdate);
    super.dispose();
  }

  Future<void> _fetchDays() async {
    final days = await _ezanService.getReligiousDays("2026");
    if (mounted) {
      setState(() {
        _apiDays = days;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Dini Günler",
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Color(0xFF4B0082),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(PhosphorIcons.caretLeft(), color: const Color(0xFF4B0082)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CustomLoadingAnimation())
        : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                "2026 Önemli Tarihler",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B0082),
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 16),
              ...(_apiDays.isNotEmpty ? _apiDays.map((day) {
                final dateStr = day['MiladiTarihKisa'] ?? "";
                bool isPassed = false;
                try {
                  final now = DateTime.now();
                  final parts = dateStr.split('.');
                  if (parts.length == 3) {
                    final date = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
                    isPassed = date.isBefore(DateTime(now.year, now.month, now.day));
                  }
                } catch (_) {}

                return _buildDayCard(
                  context,
                  _CurrentReligiousDay(
                    name: day['Adi'] ?? "",
                    date: day['MiladiTarihKisa'] ?? "",
                    dayName: "Günü", 
                    hijri: day['HicriTarih'] ?? "",
                    color: const Color(0xFF4CAF50),
                  ),
                  isPassed: isPassed,
                );
              }) : _staticDays.map((day) {
                bool isPassed = false;
                try {
                  final now = DateTime.now();
                  // date format: "15 Ocak 2026"
                  final months = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"];
                  final parts = day.date.split(' ');
                  if (parts.length == 3) {
                    int dayValue = int.parse(parts[0]);
                    int monthValue = months.indexOf(parts[1]) + 1;
                    int yearValue = int.parse(parts[2]);
                    final date = DateTime(yearValue, monthValue, dayValue);
                    isPassed = date.isBefore(DateTime(now.year, now.month, now.day));
                  }
                } catch (_) {}
                return _buildDayCard(context, day, isPassed: isPassed);
              })),
            ],
          ),
    );
  }

  // [İlerlemeci Dini Gün Bilgi Penceresi - Progressive Religious Day Detail Sheet]
  void _showDayDetailSheet(BuildContext context, _CurrentReligiousDay day) {
    // [Veriyi map'ten çekiyoruz, yoksa varsayılan metin veriyoruz - Fetch data from map or use defaults]
    final detay = diniGunlerBilgisi[day.name] ?? {
      "aciklama": "${day.name} İslam alemi için çok özel ve mübarek bir gündür.",
      "oneri": "Bu özel günü dua, zikir ve ibadetlerle değerlendirmek tavsiye edilir."
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      showDragHandle: false, // [Handle Silindi - Handle Deleted]
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // [Başlık ve İkon - Title and Icon]
            Icon(PhosphorIcons.sparkle(), color: day.color, size: 40),
            const SizedBox(height: 15),
            Text(day.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Outfit')),
            Text(day.hijri, style: TextStyle(color: day.color, fontSize: 16, fontWeight: FontWeight.w600)),
            const Divider(height: 40, thickness: 1),
            
            // [İçerik: Günün Anlamı - Content: Day's Meaning]
            const Align(alignment: Alignment.centerLeft, child: Text("Günün Anlamı", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            const SizedBox(height: 8),
            Text(detay["aciklama"]!, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5)),
            const SizedBox(height: 20),
            
            // [İçerik: Ne Yapılmalı? - Content: What to Do?]
            const Align(alignment: Alignment.centerLeft, child: Text("Ne Yapılmalı?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            const SizedBox(height: 8),
            Text(detay["oneri"]!, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5)),
            const SizedBox(height: 30),
            
            // [Kapat butonu - Close Button]
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: day.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text("Anladım", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [Gelişmiş Modern Dini Gün Kartı - Advanced Modern Religious Day Card]
  Widget _buildDayCard(BuildContext context, _CurrentReligiousDay day, {bool isPassed = false}) {
    return Opacity(
      opacity: isPassed ? 0.4 : 1.0,
      child: InkWell(
        onTap: () => _showDayDetailSheet(context, day), 
        borderRadius: BorderRadius.circular(28),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: day.color.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: day.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(PhosphorIcons.leaf(), color: day.color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${day.date} - ${day.dayName}", 
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.hijri,
                      style: TextStyle(
                        color: day.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      day.name,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(PhosphorIcons.caretRight(), size: 14, color: Colors.grey.shade300),
            ],
          ),
        ),
      ),
    );
  }
}
