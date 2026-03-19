// TR: KUBBE V4 Worship Screen - V1'den miras alındı
// EN: KUBBE V4 Worship Screen - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Grid yapısı (2 sütun) ile şık kartlar: [Zikirmatik, Zekatmatik, Namaz Rehberi, Dualar]
// EN: Grid structure (2 columns) with elegant cards: [Zikirmatik, Zekatmatik, Prayer Guide, Prayers]
// TR: V1'in 'zikirmatik.dart' ve 'zekat_hesaplama_ekrani.dart' logic'lerini bu sayfaya butonlarla bağla
// EN: Connect V1's 'zikirmatik.dart' and 'zekat_hesaplama_ekrani.dart' logic to this page with buttons

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/storage/preferences_manager.dart';

/// TR: KUBBE V4 Worship Screen Sınıfı
/// EN: KUBBE V4 Worship Screen Class
/// TR: V1'deki ibadet araçlarını modernize eder
/// EN: Modernizes V1's worship tools
/// TR: Grid yapısı (2 sütun) ile şık kartlar
/// EN: Grid structure (2 columns) with elegant cards
/// TR: Zikirmatik, Zekatmatik, Namaz Rehberi, Dualar
/// EN: Zikirmatik, Zekatmatik, Prayer Guide, Prayers
/// TR: V1'den miras alınan mantık V4 estetiğiyle modernize edildi
/// EN: Logic inherited from V1 modernized with V4 aesthetics
class WorshipScreen extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const WorshipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TR: Zikir sayacı
    // EN: Zikir counter
    final zikirCounter = ref.watch(preferencesStateProvider).zikirCounter;

    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'İbadetler',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        // TR: Zikir sayacı göster
        // EN: Show zikir counter
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              // TR: 32dp radius - Sy-OS standartı
              // EN: 32dp radius - Sy-OS standard
              borderRadius: BorderRadius.circular(32.0),
              // TR: Gradient arka plan
              // EN: Gradient background
              gradient: LinearGradient(
                colors: [
                  KubbeTheme.kubbeIndigo,
                  KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                ],
              ),
            ),
            // TR: Zikir sayacı metni
            // EN: Zikir counter text
            child: Text(
              'Zikir: $zikirCounter',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      // TR: Body
      // EN: Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // TR: Grid yapısı
        // EN: Grid structure
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.2,
          // TR: İbadet kartları
          // EN: Worship cards
          children: [
            // TR: Zikirmatik
            // EN: Zikirmatik
            _buildWorshipCard(
              context,
              title: 'Zikirmatik',
              subtitle: 'Dhikr Counter',
              icon: Icons.fingerprint,
              color: KubbeTheme.kubbeIndigo,
              onTap: () => _navigateToZikirmatik(context),
            ),

            // TR: Zekatmatik
            // EN: Zekatmatik
            _buildWorshipCard(
              context,
              title: 'Zekatmatik',
              subtitle: 'Zakat Calculator',
              icon: Icons.calculate,
              color: Colors.green,
              onTap: () => _navigateToZekatmatik(context),
            ),

            // TR: Namaz Rehberi
            // EN: Prayer Guide
            _buildWorshipCard(
              context,
              title: 'Namaz Rehberi',
              subtitle: 'Prayer Guide',
              icon: Icons.mosque,
              color: Colors.blue,
              onTap: () => _navigateToPrayerGuide(context),
            ),

            // TR: Dualar
            // EN: Prayers
            _buildWorshipCard(
              context,
              title: 'Dualar',
              subtitle: 'Prayers',
              icon: Icons.book,
              color: Colors.purple,
              onTap: () => _navigateToPrayers(context),
            ),
          ],
        ),
      ),
    );
  }

  // TR: İbadet kartı oluştur
  // EN: Build worship card
  Widget _buildWorshipCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      // TR: Kart container
      // EN: Card container
      child: Container(
        decoration: BoxDecoration(
          // TR: 32dp radius - Sy-OS standartı
          // EN: 32dp radius - Sy-OS standard
          borderRadius: BorderRadius.circular(32.0),
          // TR: Gradient arka plan
          // EN: Gradient background
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // TR: Kenar
          // EN: Border
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
          // TR: Gölge
          // EN: Shadow
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 12.0,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        // TR: Kart içeriği
        // EN: Card content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // TR: İçerik düzeni
          // EN: Content layout
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TR: İkon
              // EN: Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  // TR: Yuvarlak
                  // EN: Circle
                  shape: BoxShape.circle,
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                // TR: İkon
                // EN: Icon
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 12.0),

              // TR: Başlık - Outfit Bold
              // EN: Title - Outfit Bold
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 4.0),

              // TR: Alt başlık
              // EN: Subtitle
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TR: Zikirmatik'e git
  // EN: Navigate to Zikirmatik
  void _navigateToZikirmatik(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ZikirmatikScreen(),
      ),
    );
  }

  // TR: Zekatmatik'e git
  // EN: Navigate to Zekatmatik
  void _navigateToZekatmatik(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ZekatmatikScreen(),
      ),
    );
  }

  // TR: Namaz rehberine git
  // EN: Navigate to Prayer Guide
  void _navigateToPrayerGuide(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PrayerGuideScreen(),
      ),
    );
  }

  // TR: Dualar'a git
  // EN: Navigate to Prayers
  void _navigateToPrayers(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PrayersScreen(),
      ),
    );
  }
}

/// TR: KUBBE V4 Zikirmatik Screen - V1'den miras alındı
/// EN: KUBBE V4 Zikirmatik Screen - Inherited from V1
/// TR: V1'deki 'zikirmatik.dart' mantığı modernize edildi
/// EN: V1's 'zikirmatik.dart' logic modernized
/// TR: Zikir sayacı ve zikir listesi
/// EN: Zikir counter and zikir list
/// TR: Sy-OS design language ile modernize edildi
/// EN: Modernized with Sy-OS design language
class ZikirmatikScreen extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const ZikirmatikScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TR: Zikir sayacı
    // EN: Zikir counter
    final zikirCounter = ref.watch(preferencesStateProvider).zikirCounter;

    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'Zikirmatik',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),

      // TR: Body
      // EN: Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // TR: İçerik
        // EN: Content
        child: Column(
          children: [
            // TR: Zikir sayacı kartı
            // EN: Zikir counter card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                // TR: 32dp radius - Sy-OS standartı
                // EN: 32dp radius - Sy-OS standard
                borderRadius: BorderRadius.circular(32.0),
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    KubbeTheme.kubbeIndigo,
                    KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // TR: Gölge
                // EN: Shadow
                boxShadow: [
                  BoxShadow(
                    color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                    blurRadius: 12.0,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              // TR: İçerik
              // EN: Content
              child: Column(
                children: [
                  // TR: Başlık
                  // EN: Title
                  Text(
                    'Zikir Sayacı',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(height: 20.0),

                  // TR: Sayı
                  // EN: Number - Poppins Bold
                  Text(
                    '$zikirCounter',
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(height: 20.0),

                  // TR: Butonlar
                  // EN: Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // TR: Artır butonu
                      // EN: Increment button
                      GestureDetector(
                        onTap: () => ref
                            .read(preferencesNotifierProvider.notifier)
                            .incrementZikir(),
                        // TR: Buton
                        // EN: Button
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            // TR: Yuvarlak
                            // EN: Circle
                            shape: BoxShape.circle,
                            // TR: Gradient arka plan
                            // EN: Gradient background
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                          // TR: İkon
                          // EN: Icon
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),

                      // TR: Sıfırla butonu
                      // EN: Reset button
                      GestureDetector(
                        onTap: () => ref
                            .read(preferencesNotifierProvider.notifier)
                            .resetZikir(),
                        // TR: Buton
                        // EN: Button
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            // TR: Yuvarlak
                            // EN: Circle
                            shape: BoxShape.circle,
                            // TR: Gradient arka plan
                            // EN: Gradient background
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                          // TR: İkon
                          // EN: Icon
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 20.0),

            // TR: Zikir listesi
            // EN: Zikir list
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // TR: 32dp radius - Sy-OS standartı
                  // EN: 32dp radius - Sy-OS standard
                  borderRadius: BorderRadius.circular(32.0),
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withValues(alpha: 0.95),
                    ],
                  ),
                  // TR: Gölge
                  // EN: Shadow
                  boxShadow: [
                    BoxShadow(
                      color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                // TR: İçerik
                // EN: Content
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  // TR: Zikir listesi
                  // EN: Zikir list
                  child: ListView(
                    children: _getZikirList().map((zikir) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        // TR: Zikir öğesi
                        // EN: Zikir item
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            // TR: 16dp radius
                            // EN: 16dp radius
                            borderRadius: BorderRadius.circular(16.0),
                            // TR: Gradient arka plan
                            // EN: Gradient background
                            gradient: LinearGradient(
                              colors: [
                                KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
                                KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                          // TR: Zikir metni
                          // EN: Zikir text
                          child: Text(
                            zikir,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: KubbeTheme.kubbeIndigo,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TR: Zikir listesi - V1'den miras alındı
  // EN: Zikir list - Inherited from V1
  List<String> _getZikirList() {
    return [
      'Subhanallah',
      'Elhamdulillah',
      'Allahu Akbar',
      'La ilaha illallah',
      'Muhammedun Rasulullah',
      'Astaghfirullah',
      'Hasbunallahu wa ni\'mal wakeel',
      'La hawla wa la quwwata illa billah',
      'Rabbana atina fid dunya hasanah',
      'Rabbana atina fil akhirati hasanah',
    ];
  }
}

/// TR: KUBBE V4 Zekatmatik Screen - V1'den miras alındı
/// EN: KUBBE V4 Zekatmatik Screen - Inherited from V1
/// TR: V1'deki 'zekat_hesaplama_ekrani.dart' mantığı modernize edildi
/// EN: V1's 'zekat_hesaplama_ekrani.dart' logic modernized
/// TR: Zekat hesaplama aracı
/// EN: Zakat calculation tool
/// TR: Sy-OS design language ile modernize edildi
/// EN: Modernized with Sy-OS design language
class ZekatmatikScreen extends StatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const ZekatmatikScreen({super.key});

  @override
  State<ZekatmatikScreen> createState() => _ZekatmatikScreenState();
}

// TR: Zekatmatik Screen State
// EN: Zekatmatik Screen State
class _ZekatmatikScreenState extends State<ZekatmatikScreen> {
  // TR: Form key
  // EN: Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TR: Controllers
  // EN: Controllers
  final TextEditingController _goldController = TextEditingController();
  final TextEditingController _silverController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();

  // TR: Zekat miktarı
  // EN: Zakat amount
  double _zakatAmount = 0.0;

  @override
  void dispose() {
    _goldController.dispose();
    _silverController.dispose();
    _moneyController.dispose();
    super.dispose();
  }

  // TR: Zekat hesapla
  // EN: Calculate zakat
  void _calculateZakat() {
    if (_formKey.currentState?.validate() ?? false) {
      // TR: Altın ve gümüş değerlerini al
      // EN: Get gold and silver values
      final goldValue = double.tryParse(_goldController.text) ?? 0.0;
      final silverValue = double.tryParse(_silverController.text) ?? 0.0;
      final moneyValue = double.tryParse(_moneyController.text) ?? 0.0;

      // TR: Zekat hesapla (2.5%)
      // EN: Calculate zakat (2.5%)
      final totalValue = goldValue + silverValue + moneyValue;
      _zakatAmount = totalValue * 0.025;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'Zekatmatik',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),

      // TR: Body
      // EN: Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // TR: Form
        // EN: Form
        child: Form(
          key: _formKey,
          // TR: İçerik
          // EN: Content
          child: Column(
            children: [
              // TR: Altın değeri
              // EN: Gold value
              TextFormField(
                controller: _goldController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Altın Değeri (TL)',
                  labelStyle: GoogleFonts.inter(
                    color: KubbeTheme.kubbeIndigo,
                  ),
                  // TR: 32dp radius - Sy-OS standartı
                  // EN: 32dp radius - Sy-OS standard
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: const BorderSide(color: KubbeTheme.kubbeIndigo),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: const BorderSide(color: KubbeTheme.kubbeIndigo),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen altın değerini girin';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir sayı girin';
                  }
                  return null;
                },
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 16.0),

              // TR: Gümüş değeri
              // EN: Silver value
              TextFormField(
                controller: _silverController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Gümüş Değeri (TL)',
                  labelStyle: GoogleFonts.inter(
                    color: KubbeTheme.kubbeIndigo,
                  ),
                  // TR: 32dp radius - Sy-OS standartı
                  // EN: 32dp radius - Sy-OS standard
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: const BorderSide(color: KubbeTheme.kubbeIndigo),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: const BorderSide(color: KubbeTheme.kubbeIndigo),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen gümüş değerini girin';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir sayı girin';
                  }
                  return null;
                },
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 16.0),

              // TR: Para değeri
              // EN: Money value
              TextFormField(
                controller: _moneyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Para Değeri (TL)',
                  labelStyle: GoogleFonts.inter(
                    color: KubbeTheme.kubbeIndigo,
                  ),
                  // TR: 32dp radius - Sy-OS standartı
                  // EN: 32dp radius - Sy-OS standard
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: const BorderSide(color: KubbeTheme.kubbeIndigo),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: const BorderSide(color: KubbeTheme.kubbeIndigo),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen para değerini girin';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir sayı girin';
                  }
                  return null;
                },
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 24.0),

              // TR: Hesapla butonu
              // EN: Calculate button
              ElevatedButton(
                onPressed: _calculateZakat,
                // TR: 32dp radius - pill-shape
                // EN: 32dp radius - pill-shape
                style: ElevatedButton.styleFrom(
                  backgroundColor: KubbeTheme.kubbeIndigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                ),
                // TR: Buton metni
                // EN: Button text
                child: Text(
                  'Zekat Hesapla',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 24.0),

              // TR: Sonuç
              // EN: Result
              if (_zakatAmount > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    // TR: 32dp radius - Sy-OS standartı
                    // EN: 32dp radius - Sy-OS standard
                    borderRadius: BorderRadius.circular(32.0),
                    // TR: Gradient arka plan
                    // EN: Gradient background
                    gradient: LinearGradient(
                      colors: [
                        KubbeTheme.kubbeIndigo,
                        KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                      ],
                    ),
                    // TR: Gölge
                    // EN: Shadow
                    boxShadow: [
                      BoxShadow(
                        color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                        blurRadius: 12.0,
                        offset: const Offset(0, 4),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  // TR: Sonuç metni
                  // EN: Result text
                  child: Column(
                    children: [
                      // TR: Başlık
                      // EN: Title
                      Text(
                        'Zekat Miktarı',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      // TR: Boşluk
                      // EN: Spacer
                      const SizedBox(height: 12.0),

                      // TR: Miktar - Poppins Bold
                      // EN: Amount - Poppins Bold
                      Text(
                        '${_zakatAmount.toStringAsFixed(2)} TL',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// TR: KUBBE V4 Prayer Guide Screen - V4 yeniliği
/// EN: KUBBE V4 Prayer Guide Screen - V4 innovation
/// TR: Namaz rehberi
/// EN: Prayer guide
/// TR: Sy-OS design language ile modernize edildi
/// EN: Modernized with Sy-OS design language
class PrayerGuideScreen extends StatelessWidget {
  // TR: Constructor
  // EN: Constructor
  const PrayerGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'Namaz Rehberi',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),

      // TR: Body
      // EN: Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // TR: Namaz listesi
        // EN: Prayer list
        child: ListView(
          children: _getPrayerGuideList().map((guide) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              // TR: Rehber öğesi
              // EN: Guide item
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  // TR: 32dp radius - Sy-OS standartı
                  // EN: 32dp radius - Sy-OS standard
                  borderRadius: BorderRadius.circular(32.0),
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withValues(alpha: 0.95),
                    ],
                  ),
                  // TR: Gölge
                  // EN: Shadow
                  boxShadow: [
                    BoxShadow(
                      color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                // TR: Rehber metni
                // EN: Guide text
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TR: Başlık - Outfit Bold
                    // EN: Title - Outfit Bold
                    Text(
                      guide['title']!,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KubbeTheme.kubbeIndigo,
                      ),
                    ),

                    // TR: Boşluk
                    // EN: Spacer
                    const SizedBox(height: 8.0),

                    // TR: Açıklama
                    // EN: Description
                    Text(
                      guide['description']!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // TR: Namaz rehberi listesi
  // EN: Prayer guide list
  List<Map<String, String>> _getPrayerGuideList() {
    return [
      {
        'title': 'Abdest Almak',
        'description':
            'Abdest almanın adabları ve sırası. Niyet, elleri, yüz, kollar, baş, ayak yıkama sırası.',
      },
      {
        'title': 'Namaz Vakitleri',
        'description':
            '5 vakit namazın zamanları ve namazın farzları. Namazın kılınışı ve sünnetleri.',
      },
      {
        'title': 'Cuma Namazı',
        'description':
            'Cuma namazının önemi ve kılınışı. Cuma namazı farzları ve sünnetleri.',
      },
      {
        'title': 'Bayram Namazı',
        'description':
            'Bayram namazının kılınışı ve önemi. Bayram namazı farzları ve sünnetleri.',
      },
      {
        'title': 'Namazda Dua',
        'description':
            'Namazda ve namaz sonrası yapılacak dualar. Dua etmek için uygun zamanlar.',
      },
    ];
  }
}

/// TR: KUBBE V4 Prayers Screen - V4 yeniliği
/// EN: KUBBE V4 Prayers Screen - V4 innovation
/// TR: Dualar
/// EN: Prayers
/// TR: Sy-OS design language ile modernize edildi
/// EN: Modernized with Sy-OS design language
class PrayersScreen extends StatelessWidget {
  // TR: Constructor
  // EN: Constructor
  const PrayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'Dualar',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),

      // TR: Body
      // EN: Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // TR: Dua listesi
        // EN: Prayer list
        child: ListView(
          children: _getPrayersList().map((prayer) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              // TR: Dua öğesi
              // EN: Prayer item
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  // TR: 32dp radius - Sy-OS standartı
                  // EN: 32dp radius - Sy-OS standard
                  borderRadius: BorderRadius.circular(32.0),
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withValues(alpha: 0.95),
                    ],
                  ),
                  // TR: Gölge
                  // EN: Shadow
                  boxShadow: [
                    BoxShadow(
                      color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                // TR: Dua metni
                // EN: Prayer text
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TR: Başlık - Outfit Bold
                    // EN: Title - Outfit Bold
                    Text(
                      prayer['title']!,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KubbeTheme.kubbeIndigo,
                      ),
                    ),

                    // TR: Boşluk
                    // EN: Spacer
                    const SizedBox(height: 8.0),

                    // TR: Arapça metin
                    // EN: Arabic text
                    Text(
                      prayer['arabic']!,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.right,
                    ),

                    // TR: Boşluk
                    // EN: Spacer
                    const SizedBox(height: 8.0),

                    // TR: Türkçe anlamlam
                    // EN: Turkish translation
                    Text(
                      prayer['turkish']!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // TR: Dua listesi
  // EN: Prayer list
  List<Map<String, String>> _getPrayersList() {
    return [
      {
        'title': 'Fatiha Suresi',
        'arabic':
            'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ (1) الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ (2) الرَّحْمَنِ الرَّحِيمِ (3) مَالِكِ يَوْمِ الدِّينِ (4) إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ (5) اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ (6) صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ (7)',
        'turkish':
            'Hamd, alemlerin ve merhamet eden Allah\'ın adıyla. Rahman ve Rahim olan Allah\'a hamd ederiz. Mülkün ve hükümran sahibi olan Allah\'a hamd ederiz. Sadece sen kullar ve yardım istediğimiz, senin yardım istediğimiz kimsedir. Bizi doğru yola, kendilerine nimet verdiklerinin yoluna hidayet et. Kendilerine gazap ettiklerinin yoluna hidayet et. Onları gazaba uğratma.',
      },
      {
        'title': 'Ayet-el Kürsi',
        'arabic':
            'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ (2) لَهُ الْمُلْكُ (3) الْمُلْكُ الْقُدُُّوسُ (4) الْمُلْكُ الْمُلْكُ (5) الْمُلْكُ الْمُلْكُ (6) الْمُلْكُ الْمُلْكُ',
        'turkish':
            'Allah, kendisinden başka ilah olmayan, o yaşayan, daimî, daimî yöneten, daimî hükümran sahibidir. Gökleri ve yeri ve ikisi arasında bulunan her şeyi yönetir. O, daimî daimî daimî daimî daimî daimî yönetir.',
      },
      {
        'title': 'Amenna',
        'arabic':
            'آمَنَّ بِكَ يَا أَهْلَ الْكِتَابِ آمَنَّ بِمَا أَنْزَلْتَ بِرَسُولِكَ مِنَ الْقُرْآنِ وَمِنَ الْكِتَابِ وَمَا أَنْزَلَتَ بِهِ مِنَ الْحِكْمَةِ وَآمَنَّ بِالْآخِرَةِ وَآمَنَّ بِالْكُفْرِ وَآمَنَّ بِالْفِتْنَةِ',
        'turkish':
            'Ey kitap ehli! Peygamberin indirdiği Kur\'an\'a ve kitaba ve hikmete inandığımız gibi, peygamberin getirdiği hikmete ve ahiret gününe iman ederiz.',
      },
    ];
  }
}
