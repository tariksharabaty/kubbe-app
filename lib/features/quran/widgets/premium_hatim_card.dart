import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../screens/surah_reading_screen.dart';
import '../../../core/state/history_state.dart';
import '../../../core/state/hatim_provider.dart';
import '../../../core/state/hatim_state.dart';
import '../../../core/services/quran_service.dart';

import 'package:confetti/confetti.dart';

class PremiumHatimCard extends StatefulWidget {
  const PremiumHatimCard({super.key});

  @override
  State<PremiumHatimCard> createState() => _PremiumHatimCardState();
}

class _PremiumHatimCardState extends State<PremiumHatimCard> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<ValueNotifier<HistoryData>>().value;
    final hatimProvider = context.watch<HatimProvider>();
    final progress = hatimProvider.getOverallPercentage();
    
    final targetDate = globalHatimState.value.targetDate;
    final hasTarget = targetDate != null;

    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
          },
          child: hasTarget 
            ? _buildActiveState(context, hatimProvider, history, progress, targetDate)
            : _buildEmptyState(context, hatimProvider),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, HatimProvider provider) {
    return Container(
      key: const ValueKey('empty_hatim'),
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A11CB).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white24,
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 48),
          ),
          const SizedBox(height: 24),
          Text(
            "Manevi bir yolculuğa hazır mısın?",
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Hatim hedefini belirle ve bugün başla.",
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => _showTargetSelectionSheet(context, provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6A11CB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text("Hedef Belirle ve Başla", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveState(BuildContext context, HatimProvider hatimProvider, HistoryData history, double progress, DateTime targetDate) {
    // [Akıllı Hedef Verileri - Smart Target Data]
    final dailyGoal = hatimProvider.getDailyGoal();
    final dailyPages = (dailyGoal / 10.3).toStringAsFixed(1);

    return Container(
      key: const ValueKey('active_hatim'),
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4B0082), Color(0xFF2C3E50)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B0082).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // [Sol Taraf: İlerleme Halkası - Left Side: Progress Ring]
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Text(
                      "%${(progress * 100).toInt()}",
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // [Sağ Taraf: Akıllı Hedef - Right Side: Smart Target]
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Akıllı Hedef",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_suggest_rounded, color: Colors.white70, size: 20),
                          onPressed: () => _showTargetSelectionSheet(context, hatimProvider),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTargetRow(Icons.event_note, "Bitiş: ${targetDate.day}/${targetDate.month}/${targetDate.year}"),
                    _buildTargetRow(Icons.auto_graph, "Günlük Hedef: $dailyPages Sayfa"),
                    _buildTargetRow(Icons.timer_outlined, "Hedefine ulaşmak için günde ${(dailyGoal / 20).toStringAsFixed(1)} sayfa okumalısın."),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // [Orta Kısım: Isı Haritası - Middle: Heatmap]
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Haftalık Takip",
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                _buildHeatmap(hatimProvider.dailyStats, dailyGoal),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // [Alt Kısım: Devam Et Butonu - Bottom: Resume Button]
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Hero(
              tag: 'reading-title',
              child: ElevatedButton.icon(
                onPressed: () {
                  final surahs = QuranService.getAllSurahsSync();
                  final surah = surahs.firstWhere(
                    (s) => s.number == history.surahNumber,
                    orElse: () => surahs.first,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SurahReadingScreen(
                        surahNumber: surah.number,
                        surahName: surah.name,
                        arabicName: surah.arabicName,
                        englishName: surah.englishName,
                        verses: const [],
                        verseCount: surah.verseCount,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded, size: 28),
                label: Text("Okumaya Devam Et", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4B0082),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTargetSelectionSheet(BuildContext context, HatimProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hatim Hedefi Belirle", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF4B0082))),
            const SizedBox(height: 16),
            _buildPlanOption(context, provider, "30 Günlük Hatim", DateTime.now().add(const Duration(days: 30)), "monthly"),
            _buildPlanOption(context, provider, "1 Yıllık Hatim", DateTime.now().add(const Duration(days: 365)), "yearly"),
            _buildPlanOption(context, provider, "Kadir Gecesi (14 Nisan)", DateTime(2026, 4, 14), "ramadan"),
            ListTile(
              leading: const Icon(Icons.calendar_month_rounded, color: Color(0xFF4B0082)),
              title: Text("Özel Tarih Seç", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 60)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (picked != null) {
                  provider.updateTargetDate(picked, "custom");
                  if (context.mounted) Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanOption(BuildContext context, HatimProvider provider, String title, DateTime date, String type) {
    return ListTile(
      leading: const Icon(Icons.bolt_rounded, color: Color(0xFF4B0082)),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      onTap: () {
        final isFirstTarget = globalHatimState.value.targetDate == null;
        provider.updateTargetDate(date, type);
        Navigator.pop(context);
        
        if (isFirstTarget) {
          _confettiController.play();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${title} Hatim Hedefi Başlatıldı. Yolculuğun Mübarek Olsun!"),
              backgroundColor: const Color(0xFF4B0082),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
    );
  }

  Widget _buildTargetRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white60),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 13, color: Colors.white70), maxLines: 1)),
        ],
      ),
    );
  }

  Widget _buildHeatmap(Map<String, int> stats, int dailyGoal) {
    return Row(
      children: List.generate(7, (index) {
        final date = DateTime.now().subtract(Duration(days: 6 - index));
        final dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        final count = stats[dateStr] ?? 0;
        
        Color color = Colors.white.withOpacity(0.1);
        if (count > 0) color = const Color(0xFF4B0082).withOpacity(0.3); // Baz Mor
        if (count >= dailyGoal && dailyGoal > 0) {
          color = const Color(0xFF4B0082); // Hedef Gerçekleşti - Deep Purple
        }

        return Container(
          width: 16, height: 16,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        );
      }),
    );
  }
}
