import 'package:flutter/material.dart';

// [Hatim Panosu Ekranı: Kullanıcının hatim planlarını yönettiği ekran - Hatim Dashboard Screen: Managing hatim plans]
class HatimPanosuScreen extends StatelessWidget {
  const HatimPanosuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5E35B1), // [Görseldeki spesifik lila/mor tonu - Specific purple tone from the design]
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [Başlık ve Çöp Kutusu İkonu - Title and Delete Icon]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hatim Panosu", 
                      style: TextStyle(fontFamily: 'Outfit', fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Henüz bir plan seçilmedi", 
                      style: TextStyle(fontSize: 16, color: Colors.white70)
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.white70, size: 28),
                  onPressed: () {
                    // [Hatim planını sıfırlama işlemi - Reset hatim plan action]
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),

            // [Aylık Hatim Kartı - Monthly Hatim Card]
            _buildHatimCard(
              title: "Aylık Hatim",
              subtitle: "Günde 20 sayfa ile hatim",
              onPressed: () {
                // [Aylık hatimi başlat - Start monthly hatim]
              },
            ),
            const SizedBox(height: 16),

            // [Yıllık Hatim Kartı - Yearly Hatim Card]
            _buildHatimCard(
              title: "Yıllık Hatim",
              subtitle: "Günde yaklaşık 2 sayfa ile hatim",
              onPressed: () {
                // [Yıllık hatimi başlat - Start yearly hatim]
              },
            ),
          ],
        ),
      ),
    );
  }

  // [Hatim Kartı Oluşturucu - Hatim Card Builder]
  Widget _buildHatimCard({
    required String title, 
    required String subtitle, 
    required VoidCallback onPressed
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), 
              blurRadius: 10, 
              offset: const Offset(0, 4)
            )
          ],
        ),
        child: Row(
          children: [
            // [Sarı Kronometre İkonu - Yellow Timer Icon]
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4), 
                borderRadius: BorderRadius.circular(16)
              ),
              child: const Icon(Icons.timer_outlined, color: Color(0xFFFFCA28), size: 32),
            ),
            const SizedBox(width: 16),
            // [Metin Alanı - Text Area]
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: const TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle, 
                    style: const TextStyle(fontSize: 14, color: Colors.grey)
                  ),
                ],
              ),
            ),
            // [Yönlendirme Oku (Buton Yerine) - Navigation Chevron (Instead of Button)]
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF5E35B1), size: 28),
          ],
        ),
      ),
    );
  }
}
