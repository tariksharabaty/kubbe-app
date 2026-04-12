import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:provider/provider.dart';
import '../../../core/state/hatim_provider.dart';

class HatimDashboardScreen extends StatefulWidget {
  const HatimDashboardScreen({super.key});

  @override
  State<HatimDashboardScreen> createState() => _HatimDashboardScreenState();
}

class _HatimDashboardScreenState extends State<HatimDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HatimProvider().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Hatim Panosu",
          style: GoogleFonts.inter(
            color: const Color(0xFF4B0082),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4B0082)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF4B0082)),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<HatimProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(provider),
                const SizedBox(height: 32),
                Text(
                  "Kubbe Geometrisi",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Her kare bir sureyi temsil eder. Okudukça derin mor renge boyanır.",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 114,
                  itemBuilder: (context, index) {
                    final surahId = index + 1;
                    final totalAyahs = quran.getVerseCount(surahId);
                    final progress = provider.getSurahProgressPercentage(surahId, totalAyahs);

                    return _buildProgressCell(surahId, progress);
                  },
                ),
                const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(HatimProvider provider) {
    int totalRead = provider.progress.values.fold(0, (sum, count) => sum + count);
    double overallPercent = (totalRead / 6236).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B0082), Color(0xFF6C63FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B0082).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hatim Yolculuğu",
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "%${(overallPercent * 100).toStringAsFixed(1)}",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.auto_awesome, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: overallPercent,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "$totalRead / 6236 Ayet okundu",
            style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCell(int surahId, double progress) {
    // [Isı Haritası Mantığı - Heatmap Logic]
    // Az okunanlar açık mor, çok okunanlar derin mor
    final Color cellColor = progress == 0 
        ? Colors.grey.withOpacity(0.1)
        : const Color(0xFF4B0082).withOpacity(0.1 + (progress * 0.9));

    return Tooltip(
      message: "${quran.getSurahName(surahId)}: %${(progress * 100).toInt()}",
      child: Container(
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: progress > 0 ? const Color(0xFF4B0082).withOpacity(0.3) : Colors.transparent,
            width: 1,
          ),
          boxShadow: progress > 0.8 ? [
            BoxShadow(
              color: const Color(0xFF4B0082).withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
            )
          ] : [],
        ),
        child: Center(
          child: Text(
            surahId.toString(),
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: progress > 0.5 ? Colors.white : const Color(0xFF4B0082).withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
