import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ZekatmatikScreen extends StatefulWidget {
  const ZekatmatikScreen({super.key});

  @override
  State<ZekatmatikScreen> createState() => _ZekatmatikScreenState();
}

class _ZekatmatikScreenState extends State<ZekatmatikScreen> {
  final TextEditingController _cash = TextEditingController();
  final TextEditingController _gold = TextEditingController();
  final TextEditingController _trade = TextEditingController();
  final TextEditingController _debts = TextEditingController();
  double _totalZekat = 0.0;

  void _calculate() {
    double valCash = double.tryParse(_cash.text) ?? 0;
    double valGold = double.tryParse(_gold.text) ?? 0;
    double valTrade = double.tryParse(_trade.text) ?? 0;
    double valDebts = double.tryParse(_debts.text) ?? 0;

    double netAssets = (valCash + valGold + valTrade) - valDebts;
    setState(() {
      _totalZekat = netAssets > 0 ? netAssets * 0.025 : 0.0; // [1/40 kuralı - 1/40 rule]
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // [Arka plan rengi - Background color]
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Zekatmatik",
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(PhosphorIcons.caretLeft(), color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.info(), color: const Color(0xFF4B0082)), // [Bilgi ikonu - Info icon]
            onPressed: () => _showZekatInfo(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildInput("Eldeki Nakit (TL)", _cash, PhosphorIcons.wallet()),
            const SizedBox(height: 16),
            _buildInput("Altın ve Ziynet Değeri (TL)", _gold, PhosphorIcons.coins()),
            const SizedBox(height: 16),
            _buildInput("Ticari Mallar (TL)", _trade, PhosphorIcons.storefront()),
            const SizedBox(height: 16),
            _buildInput("Borçlar ve Giderler (TL)", _debts, PhosphorIcons.minusCircle()),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B0082),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: const Text(
                "Zekatımı Hesapla",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (_totalZekat > 0) _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF4B0082)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
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
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(PhosphorIcons.checkCircle(), color: Colors.white, size: 40),
          const SizedBox(height: 16),
          const Text(
            "Vermeniz Gereken Zekat",
            style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Text(
            "₺${_totalZekat.toStringAsFixed(2).replaceAll('.', ',')}",
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Kırkta Bir ( %2,5 )",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // [Zekat Bilgilendirme Paneli - Zakat Info Panel]
  void _showZekatInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text("Zekat Hakkında", style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF4B0082))),
            const SizedBox(height: 16),
            _buildInfoRow(PhosphorIcons.star(), "Nisab Miktarı: 80.18 gram altın veya karşılığı nakit paranız varsa zekat düşer."),
            _buildInfoRow(PhosphorIcons.percent(), "Hesaplama Oranı: Toplam mal varlığınızın %2,5'i (1/40) zekat olarak verilir."),
            _buildInfoRow(PhosphorIcons.timer(), "Yıllanma: Malın üzerinden bir hicri yılın geçmesi gerekir."),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B0082),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Anladım", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF4B0082), size: 24),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[800], height: 1.5))),
        ],
      ),
    );
  }
}
