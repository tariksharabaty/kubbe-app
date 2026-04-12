import 'package:flutter/material.dart';

// [İstatistik Ekranı: Zikir, Lale ve Kuran Okumaları - Statistics Screen: Zikir, Tulip and Quran Reading Analytics]
class OzetScreen extends StatefulWidget {
  const OzetScreen({super.key});

  @override
  State<OzetScreen> createState() => _OzetScreenState();
}

class _OzetScreenState extends State<OzetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // [Açık, temiz arka plan - Open, clean background]
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "ANALİZ & ÖZET",
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 1.5,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF4B0082),
          labelColor: const Color(0xFF4B0082),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          tabs: const [
            Tab(text: "Aylık Özet"),
            Tab(text: "Yıllık Özet"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatsTab(isMonthly: true),
          _buildStatsTab(isMonthly: false),
        ],
      ),
    );
  }

  Widget _buildStatsTab({required bool isMonthly}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // [Ana Kart - Lale Bahçesi Durumu - Ottoman Tulip Motif Card]
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4B0082), Color(0xFF6A0DAD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4B0082).withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // [Arka Plan Lale Motifi - Background Tulip Motif]
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    Icons.local_florist_rounded,
                    size: 120,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Lale Bahçesi (Namaz)",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isMonthly ? "42 Lale" : "365 Lale",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Açtırdığın muazzam çiçekler",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // [Alt İstatistik Kartları - Bottom Stat Cards]
          Row(
            children: [
              Expanded(
                child: _buildSmallStatCard(
                  title: "Zikir",
                  count: isMonthly ? "5.400" : "42.000",
                  icon: Icons.fingerprint_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSmallStatCard(
                  title: "Kuran",
                  count: isMonthly ? "12 Cüz" : "2 Hatim",
                  icon: Icons.menu_book_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // [Grafik Alanı - Custom Chart Area]
          const Text(
            "İbadet Grafiği",
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              // [Sahte Verilerle Görsel Çubuklar - Custom Bar Chart with Fake Data]
              children:
                  [
                    0.4,
                    0.7,
                    0.5,
                    0.9,
                    1.0,
                    0.8,
                    0.6,
                    1.0,
                    0.8,
                    0.9,
                    0.5,
                    0.6,
                    0.4,
                  ].map((heightPct) {
                    return Container(
                      width: 24,
                      height: 150 * heightPct,
                      decoration: BoxDecoration(
                        color: heightPct > 0.8
                            ? const Color(0xFF4B0082)
                            : const Color(0xFF4B0082).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard({
    required String title,
    required String count,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF4B0082), size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
