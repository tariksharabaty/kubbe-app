// TR: KUBBE V4 Elite Zekatmatik Screen - V4 Yeniliği
// EN: KUBBE V4 Elite Zekatmatik Screen - V4 Innovation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: One UI tarzı Island (Sonuç Kartı) ve Outfit fontlu modern giriş alanları
// EN: One UI style Island (Result Card) and modern input fields with Outfit font
// TR: Manuel nisap miktarı girişi ve haptic feedback desteği
// EN: Manual nisap amount entry and haptic feedback support

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/haptic_helper.dart';

/// TR: KUBBE V4 Elite Zekatmatik Screen Sınıfı
/// EN: KUBBE V4 Elite Zekatmatik Screen Class
class EliteZekatmatikScreen extends ConsumerStatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const EliteZekatmatikScreen({super.key});

  @override
  ConsumerState<EliteZekatmatikScreen> createState() => _EliteZekatmatikScreenState();
}

class _EliteZekatmatikScreenState extends ConsumerState<EliteZekatmatikScreen> {
  // TR: Form key for validation
  // EN: Form key for validation
  final _formKey = GlobalKey<FormState>();

  // TR: Text controllers (Outfit fontuyla girişler için)
  // EN: Text controllers (for inputs with Outfit font)
  final TextEditingController _altinController = TextEditingController();
  final TextEditingController _gumusController = TextEditingController();
  final TextEditingController _nakitController = TextEditingController();
  final TextEditingController _ticariMalController = TextEditingController();
  final TextEditingController _nisapController = TextEditingController(text: '2800'); // TR: Varsayılan altın gram fiyatı // EN: Default gold gram price

  // TR: Hesaplanan değerler
  // EN: Calculated values
  double _toplamVarlik = 0.0;
  double _zekatMiktari = 0.0;
  bool _nisapAsildi = false;

  @override
  void dispose() {
    _altinController.dispose();
    _gumusController.dispose();
    _nakitController.dispose();
    _ticariMalController.dispose();
    _nisapController.dispose();
    super.dispose();
  }

  // TR: Zekat hesapla
  // EN: Calculate zakat
  void _hesapla() {
    // TR: Haptic feedback - Elite Tok Click
    // EN: Haptic feedback - Elite Tok Click
    HapticHelper.tokClick();

    if (!_formKey.currentState!.validate()) return;

    double altin = double.tryParse(_altinController.text) ?? 0;
    double gumus = double.tryParse(_gumusController.text) ?? 0;
    double nakit = double.tryParse(_nakitController.text) ?? 0;
    double mal = double.tryParse(_ticariMalController.text) ?? 0;
    double altinFiyat = double.tryParse(_nisapController.text) ?? 2800;

    setState(() {
      // TR: Basitleştirilmiş V4 hesaplama mantığı
      // EN: Simplified V4 calculation logic
      // TR: Altın (80.18 gr) bazlı nisap
      // EN: Nisap based on gold (80.18 gr)
      double nisapMiktari = 80.18 * altinFiyat;
      
      // TR: Varlıkların TL karşılığı (Gümüşü 35 TL'den varsayalım)
      // EN: TL equivalent of assets (Assuming silver at 35 TL)
      double altinDegeri = altin * altinFiyat;
      double gumusDegeri = gumus * 35; // TR: Sabit gümüş fiyatı // EN: Constant silver price
      
      _toplamVarlik = altinDegeri + gumusDegeri + nakit + mal;
      _nisapAsildi = _toplamVarlik >= nisapMiktari;
      _zekatMiktari = _nisapAsildi ? _toplamVarlik * 0.025 : 0.0;
    });

    if (_nisapAsildi) {
      HapticHelper.heavyClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KubbeTheme.syOsBackground,
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        title: Text(
          'Elite Zekatmatik',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      // TR: Body
      // EN: Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TR: One UI style 'Island' results card
            // EN: One UI style 'Island' results card
            _buildIslandResult(),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TR: Giriş başlığı
                    // EN: Input title
                    Text(
                      'Varlık Bilgileri',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: KubbeTheme.kubbeIndigo,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // TR: Giriş alanları
                    // EN: Input fields
                    _buildInputField(
                      controller: _altinController,
                      label: 'Altın (Gram)',
                      icon: Icons.auto_awesome_rounded,
                    ),
                    _buildInputField(
                      controller: _gumusController,
                      label: 'Gümüş (Gram)',
                      icon: Icons.blur_on_rounded,
                    ),
                    _buildInputField(
                      controller: _nakitController,
                      label: 'Nakit Para (TL)',
                      icon: Icons.account_balance_wallet_rounded,
                    ),
                    _buildInputField(
                      controller: _ticariMalController,
                      label: 'Ticari Mallar (TL)',
                      icon: Icons.shopping_bag_rounded,
                    ),
                    const SizedBox(height: 24),

                    // TR: Nisap / Altın Fiyatı ayarlama (Manuel giriş)
                    // EN: Nisab / Gold price setting (Manual entry)
                    _buildNisapField(),

                    const SizedBox(height: 32),

                    // TR: Hesapla butonu
                    // EN: Calculate button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _hesapla,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KubbeTheme.kubbeIndigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(KubbeTheme.syOsRadius),
                          ),
                          elevation: 8,
                          shadowColor: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                        ),
                        child: Text(
                          'HESAPLA',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TR: 'Island' Sonuç Kartı oluştur
  // EN: Build 'Island' Result Card
  Widget _buildIslandResult() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            KubbeTheme.kubbeIndigo,
            KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(KubbeTheme.syOsRadius),
        boxShadow: [
          BoxShadow(
            color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            Text(
              'Ödenmesi Gereken Zekat',
              style: GoogleFonts.outfit(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '₺ ${_zekatMiktari.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _nisapAsildi ? Icons.check_circle_rounded : Icons.info_rounded,
                    color: _nisapAsildi ? Colors.greenAccent : Colors.amberAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _nisapAsildi ? 'Nisap Miktarı Aşıldı' : 'Nisap Miktarı Aşılmadı',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (_nisapAsildi) ...[
               const SizedBox(height: 12),
               Text(
                'Toplam Varlık: ₺ ${_toplamVarlik.toStringAsFixed(2)}',
                style: GoogleFonts.outfit(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // TR: Giriş alanı oluştur (Outfit fontuyla)
  // EN: Build input field (with Outfit font)
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(KubbeTheme.syOsRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.outfit(color: KubbeTheme.textSecondary),
            prefixIcon: Icon(icon, color: KubbeTheme.kubbeIndigo, size: 22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(KubbeTheme.syOsRadius),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ),
    );
  }

  // TR: Nisap / Altın Fiyatı giriş alanı
  // EN: Nisab / Gold price input field
  Widget _buildNisapField() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(KubbeTheme.syOsRadius),
        border: Border.all(color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.settings_suggest_rounded, color: KubbeTheme.kubbeIndigo),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Altın Gram Fiyatı (HESAP İÇİN)',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: KubbeTheme.kubbeIndigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _nisapController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                  decoration: const InputDecoration(
                    suffixText: 'TL',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
