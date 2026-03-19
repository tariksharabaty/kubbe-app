// TR: KUBBE V4 Zekatmatik Ekranı - V1'den miras alındı
// EN: KUBBE V4 Zekatmatik Screen - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Kullanıcının veri girişi yapabileceği, sonucu 32dp radius'lu bir 'Elite' kartta gösteren ekranı kur.
// EN: Build screen where user can enter data and view result in a 32dp radius 'Elite' card.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../core/components/elite_input_field.dart';
import 'zekat_calculator.dart';

/// TR: KUBBE V4 Zekatmatik Widget'ı
/// EN: KUBBE V4 Zekatmatik Widget
/// TR: V1'deki zekat hesaplama mantığını modern Flutter ile birleştirir
/// EN: Combines V1's zakat calculation logic with modern Flutter
/// TR: Kullanıcı dostu veri girişi ve Elite kart gösterimi
/// EN: User-friendly data entry and Elite card display
/// TR: 32dp radius ve V4 estetiği
/// EN: 32dp radius and V4 aesthetics
/// TR: Sy-OS design language
/// EN: Sy-OS design language
class ZekatmatikScreen extends ConsumerStatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const ZekatmatikScreen({super.key});

  @override
  ConsumerState<ZekatmatikScreen> createState() => _ZekatmatikScreenState();
}

class _ZekatmatikScreenState extends ConsumerState<ZekatmatikScreen> {
  // TR: Form key
  // EN: Form key
  final _formKey = GlobalKey<FormState>();

  // TR: Text controllers
  // EN: Text controllers
  final _altinController = TextEditingController();
  final _gumusController = TextEditingController();
  final _nakitController = TextEditingController();
  final _digerController = TextEditingController();

  // TR: Focus nodes
  // EN: Focus nodes
  final _altinFocus = FocusNode();
  final _gumusFocus = FocusNode();
  final _nakitFocus = FocusNode();
  final _digerFocus = FocusNode();

  // TR: Zekat sonucu
  // EN: Zakat result
  ZekatSonucu? _zekatSonucu;

  @override
  void dispose() {
    // TR: Controller'ları temizle
    // EN: Clean up controllers
    _altinController.dispose();
    _gumusController.dispose();
    _nakitController.dispose();
    _digerController.dispose();

    // TR: Focus node'ları temizle
    // EN: Clean up focus nodes
    _altinFocus.dispose();
    _gumusFocus.dispose();
    _nakitFocus.dispose();
    _digerFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TR: Zekatmatik provider
    // EN: Zekatmatik provider
    final zekatmatik = ref.read(zekatmatikProvider);

    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'Zekatmatik',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // TR: Arka plan
        // EN: Background
        backgroundColor: KubbeTheme.kubbeIndigo,
        // TR: Gölge kaldır
        // EN: Remove shadow
        elevation: 0,
        // TR: Eylemler
        // EN: Actions
        actions: [
          // TR: Bilgi ikonu
          // EN: Info icon
          IconButton(
            onPressed: () {
              // TR: Bilgi dialog'u göster
              // EN: Show info dialog
              _showInfoDialog(context);
            },
            // TR: İkon
            // EN: Icon
            icon: const Icon(
              Icons.info,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),

      // TR: Gövde
      // EN: Body
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // TR: Gradient arka plan
        // EN: Gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              KubbeTheme.kubbeIndigo,
              KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // TR: İçerik
        // EN: Content
        child: SafeArea(
          // TR: Ana içerik
          // EN: Main content
          child: SingleChildScrollView(
            // TR: Padding
            // EN: Padding
            padding: const EdgeInsets.all(16.0),
            // TR: Form
            // EN: Form
            child: Form(
              // TR: Form key
              // EN: Form key
              key: _formKey,
              // TR: Form içeriği
              // EN: Form content
              child: Column(
                // TR: Ana içerik
                // EN: Main content
                children: [
                  // TR: Başlık bölümü
                  // EN: Header section
                  _buildHeader(),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(height: 20.0),

                  // TR: Veri girişi bölümü
                  // EN: Data entry section
                  _buildDataEntrySection(),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(height: 20.0),

                  // TR: Hesapla butonu
                  // EN: Calculate button
                  _buildCalculateButton(zekatmatik),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(height: 20.0),

                  // TR: Sonuç kartı
                  // EN: Result card
                  if (_zekatSonucu != null) _buildResultCard(zekatmatik),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TR: Başlık bölümü oluştur
  // EN: Build header section
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(32.0),
        // TR: Beyaz arka plan
        // EN: White background
        color: Colors.white.withValues(alpha: 0.1),
        // TR: Kenar
        // EN: Border
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      // TR: İçerik
      // EN: Content
      child: Column(
        children: [
          // TR: Başlık
          // EN: Title
          Text(
            'Zekat Hesaplama',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 8.0),

          // TR: Açıklama
          // EN: Description
          Text(
            'Altın, gümüş, nakit ve diğer varlıklarınıza göre zekat miktarını hesaplayın.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // TR: Veri girişi bölümü oluştur
  // EN: Build data entry section
  Widget _buildDataEntrySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(32.0),
        // TR: Beyaz arka plan
        // EN: White background
        color: Colors.white,
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      // TR: İçerik
      // EN: Content
      child: Column(
        children: [
          // TR: Altın girişi
          // EN: Gold entry
          EliteInputField(
            // TR: Label
            // EN: Label
            label: 'Altın (Gram)',
            // TR: Controller
            // EN: Controller
            controller: _altinController,
            // TR: Focus node
            // EN: Focus node
            focusNode: _altinFocus,
            // TR: Keyboard type
            // EN: Keyboard type
            keyboardType: TextInputType.number,
            // TR: Validator
            // EN: Validator
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen altın miktarını girin';
              }
              final number = double.tryParse(value);
              if (number == null || number < 0) {
                return 'Lütfen geçerli bir sayı girin';
              }
              return null;
            },
            // TR: Icon
            // EN: Icon
            icon: Icons.monetization_on,
            // TR: Hint text
            // EN: Hint text
            hintText: 'Örn: 100',
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 16.0),

          // TR: Gümüş girişi
          // EN: Silver entry
          EliteInputField(
            // TR: Label
            // EN: Label
            label: 'Gümüş (Gram)',
            // TR: Controller
            // EN: Controller
            controller: _gumusController,
            // TR: Focus node
            // EN: Focus node
            focusNode: _gumusFocus,
            // TR: Keyboard type
            // EN: Keyboard type
            keyboardType: TextInputType.number,
            // TR: Validator
            // EN: Validator
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen gümüş miktarını girin';
              }
              final number = double.tryParse(value);
              if (number == null || number < 0) {
                return 'Lütfen geçerli bir sayı girin';
              }
              return null;
            },
            // TR: Icon
            // EN: Icon
            icon: Icons.monetization_on,
            // TR: Hint text
            // EN: Hint text
            hintText: 'Örn: 500',
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 16.0),

          // TR: Nakit girişi
          // EN: Cash entry
          EliteInputField(
            // TR: Label
            // EN: Label
            label: 'Nakit (TL)',
            // TR: Controller
            // EN: Controller
            controller: _nakitController,
            // TR: Focus node
            // EN: Focus node
            focusNode: _nakitFocus,
            // TR: Keyboard type
            // EN: Keyboard type
            keyboardType: TextInputType.number,
            // TR: Validator
            // EN: Validator
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen nakit miktarını girin';
              }
              final number = double.tryParse(value);
              if (number == null || number < 0) {
                return 'Lütfen geçerli bir sayı girin';
              }
              return null;
            },
            // TR: Icon
            // EN: Icon
            icon: Icons.attach_money,
            // TR: Hint text
            // EN: Hint text
            hintText: 'Örn: 10000',
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 16.0),

          // TR: Diğer varlıklar girişi
          // EN: Other assets entry
          EliteInputField(
            // TR: Label
            // EN: Label
            label: 'Diğer Varlıklar (TL)',
            // TR: Controller
            // EN: Controller
            controller: _digerController,
            // TR: Focus node
            // EN: Focus node
            focusNode: _digerFocus,
            // TR: Keyboard type
            // EN: Keyboard type
            keyboardType: TextInputType.number,
            // TR: Validator
            // EN: Validator
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen diğer varlıklar miktarını girin';
              }
              final number = double.tryParse(value);
              if (number == null || number < 0) {
                return 'Lütfen geçerli bir sayı girin';
              }
              return null;
            },
            // TR: Icon
            // EN: Icon
            icon: Icons.account_balance,
            // TR: Hint text
            // EN: Hint text
            hintText: 'Örn: 50000',
          ),
        ],
      ),
    );
  }

  // TR: Hesapla butonu oluştur
  // EN: Build calculate button
  Widget _buildCalculateButton(ZekatCalculator zekatmatik) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      // TR: Buton
      // EN: Button
      child: ElevatedButton(
        // TR: onPressed callback
        // EN: onPressed callback
        onPressed: () {
          // TR: Titreşim ver
          // EN: Give haptic feedback
          HapticUtils.mediumImpact();

          // TR: Formu doğrula
          // EN: Validate form
          if (_formKey.currentState!.validate()) {
            // TR: Zekatı hesapla
            // EN: Calculate zakat
            final altin = double.tryParse(_altinController.text) ?? 0.0;
            final gumus = double.tryParse(_gumusController.text) ?? 0.0;
            final nakit = double.tryParse(_nakitController.text) ?? 0.0;
            final diger = double.tryParse(_digerController.text) ?? 0.0;

            // TR: Zekatı hesapla
            // EN: Calculate zakat
            final sonuc = zekatmatik.zekatHesapla(
              altinMiktari: altin,
              gumusMiktari: gumus,
              nakitMiktari: nakit,
              digerVarliklar: diger,
            );

            // TR: Durumu güncelle
            // EN: Update state
            setState(() {
              _zekatSonucu = sonuc;
            });
          }
        },
        // TR: Stil
        // EN: Style
        style: ElevatedButton.styleFrom(
          // TR: Padding
          // EN: Padding
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          // TR: Arka plan
          // EN: Background
          backgroundColor: KubbeTheme.kubbeIndigo,
          // TR: Gölge
          // EN: Shadow
          elevation: 8,
          // TR: Shape
          // EN: Shape
          shape: RoundedRectangleBorder(
            // TR: 32dp radius
            // EN: 32dp radius
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        // TR: Buton içeriği
        // EN: Button content
        child: Text(
          'Zekat Hesapla',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // TR: Sonuç kartı oluştur
  // EN: Build result card
  Widget _buildResultCard(ZekatCalculator zekatmatik) {
    // TR: Zekat bilgilerini formatla
    // EN: Format zakat information
    final bilgiler = zekatmatik.formatZekatBilgisi(_zekatSonucu!);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(32.0),
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: [
            _zekatSonucu!.nisapAsildi ? Colors.green : Colors.orange,
            _zekatSonucu!.nisapAsildi
                ? Colors.green.withValues(alpha: 0.8)
                : Colors.orange.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: (_zekatSonucu!.nisapAsildi ? Colors.green : Colors.orange)
                .withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      // TR: İçerik
      // EN: Content
      child: Column(
        children: [
          // TR: Başlık
          // EN: Title
          Row(
            // TR: MainAxisAlignment
            // EN: MainAxisAlignment
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TR: İkon
              // EN: Icon
              Icon(
                _zekatSonucu!.nisapAsildi ? Icons.check_circle : Icons.info,
                color: Colors.white,
                size: 24,
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(width: 8.0),

              // TR: Başlık metni
              // EN: Title text
              Text(
                _zekatSonucu!.nisapAsildi
                    ? 'Zekat Hesaplandı'
                    : 'Nisap Aşılmadı',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 20.0),

          // TR: Toplam varlık
          // EN: Total assets
          _buildInfoRow(
            'Toplam Varlık',
            bilgiler['toplam_varlik']!,
            Icons.account_balance_wallet,
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 12.0),

          // TR: Toplam zekat
          // EN: Total zakat
          _buildInfoRow(
            'Toplam Zekat',
            bilgiler['toplam_zekat']!,
            Icons.volunteer_activism,
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 20.0),

          // TR: Mesaj
          // EN: Message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            // TR: Mesaj dekorasyonu
            // EN: Message decoration
            decoration: BoxDecoration(
              // TR: 16dp radius
              // EN: 16dp radius
              borderRadius: BorderRadius.circular(16.0),
              // TR: Beyaz arka plan
              // EN: White background
              color: Colors.white.withValues(alpha: 0.2),
            ),
            // TR: Mesaj içeriği
            // EN: Message content
            child: Text(
              bilgiler['mesaj']!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TR: Bilgi satırı oluştur
  // EN: Build info row
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      // TR: MainAxisAlignment
      // EN: MainAxisAlignment
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // TR: Label ve ikon
        // EN: Label and icon
        Row(
          children: [
            // TR: İkon
            // EN: Icon
            Icon(
              icon,
              color: Colors.white.withValues(alpha: 0.8),
              size: 20,
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(width: 8.0),

            // TR: Label
            // EN: Label
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),

        // TR: Değer
        // EN: Value
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // TR: Bilgi dialog'u göster
  // EN: Show info dialog
  void _showInfoDialog(BuildContext context) {
    final zekatmatik = ref.read(zekatmatikProvider);
    final nisapBilgileri = zekatmatik.nisapMiktarlari;

    showDialog(
      // TR: Dialog
      // EN: Dialog
      context: context,
      builder: (BuildContext context) {
        // TR: AlertDialog
        // EN: AlertDialog
        return AlertDialog(
          // TR: Başlık
          // EN: Title
          title: Text(
            'Zekat Bilgileri',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),
          // TR: İçerik
          // EN: Content
          content: Column(
            // TR: Ana içerik
            // EN: Main content
            mainAxisSize: MainAxisSize.min,
            children: [
              // TR: Nisap bilgileri
              // EN: Nisab information
              ListTile(
                // TR: Başlık
                // EN: Title
                title: Text(
                  'Nisap Miktarları',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // TR: Alt başlık
                // EN: Subtitle
                subtitle: Text(
                  'Altın: ${nisapBilgileri['altin_gram']?.toStringAsFixed(2)} gram (${nisapBilgileri['altin_tl']?.toStringAsFixed(2)} TL)\n'
                  'Gümüş: ${nisapBilgileri['gumus_gram']?.toStringAsFixed(2)} gram (${nisapBilgileri['gumus_tl']?.toStringAsFixed(2)} TL)',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                // TR: İkon
                // EN: Icon
                leading: const Icon(
                  Icons.info,
                  color: KubbeTheme.kubbeIndigo,
                ),
              ),

              // TR: Zekat oranı
              // EN: Zakat rate
              ListTile(
                // TR: Başlık
                // EN: Title
                title: Text(
                  'Zekat Oranı',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // TR: Alt başlık
                // EN: Subtitle
                subtitle: Text(
                  'Varlıkların %${(zekatmatik.zekatOrani * 100).toInt()}\'i',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                // TR: İkon
                // EN: Icon
                leading: const Icon(
                  Icons.percent,
                  color: KubbeTheme.kubbeIndigo,
                ),
              ),
            ],
          ),
          // TR: Butonlar
          // EN: Actions
          actions: [
            // TR: Kapat butonu
            // EN: Close button
            TextButton(
              // TR: Metin
              // EN: Text
              onPressed: () {
                // TR: Dialog'u kapat
                // EN: Close dialog
                Navigator.of(context).pop();
              },
              // TR: Stil
              // EN: Style
              style: TextButton.styleFrom(
                // TR: Metin rengi
                // EN: Text color
                foregroundColor: KubbeTheme.kubbeIndigo,
              ),
              // TR: Metin
              // EN: Text
              child: Text(
                'Kapat',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
