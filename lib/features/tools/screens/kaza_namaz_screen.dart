import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/widgets/pulsing_loader.dart';

class KazaNamazScreen extends StatefulWidget {
  const KazaNamazScreen({super.key});

  @override
  State<KazaNamazScreen> createState() => _KazaNamazScreenState();
}

class _KazaNamazScreenState extends State<KazaNamazScreen> {
  final Color kubbePurple = const Color(0xFF6A1B9A);
  final Color goldColor = const Color(0xFFFFD700);
  bool _isLoading = true;

  final List<String> _prayerVakitler = [
    'Sabah', 'Öğle', 'İkindi', 'Akşam', 'Yatsı', 'Vitir'
  ];


  Map<String, int> _prayerCounts = {};
  int _orucCount = 0;

  // [Hesaplayıcı Belleği - Calculator Persistence]
  String _gender = 'Erkek';
  int _currentAge = 0;
  int _pubertyAge = 15;
  int _calcYear = 0;
  int _calcMonth = 0;
  int _calcDay = 0;
  int _calcKazaOruc = 0;
  int _calcKefaretCount = 0;
  int _reglDays = 6;
  bool _isVitirEnabled = true;




  @override
  void initState() {
    super.initState();
    _loadKazaData();
  }

  Future<void> _loadKazaData() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> prayerCounts = {};

    for (String vakit in _prayerVakitler) {
      prayerCounts[vakit] = prefs.getInt('kaza_namaz_$vakit') ?? 0;
    }

    if (mounted) {
      setState(() {
        _prayerCounts = prayerCounts;
        _orucCount = prefs.getInt('kaza_oruc_main') ?? 0;
        
        // [Belleği Yükle - Load Calculator Inputs]
        _gender = prefs.getString('kaza_calc_gender') ?? 'Erkek';
        _currentAge = prefs.getInt('kaza_calc_currentAge') ?? 0;
        _pubertyAge = prefs.getInt('kaza_calc_pubertyAge') ?? (_gender == 'Erkek' ? 15 : 12);
        _calcYear = prefs.getInt('kaza_calc_year') ?? 0;
        _calcMonth = prefs.getInt('kaza_calc_month') ?? 0;
        _calcDay = prefs.getInt('kaza_calc_day') ?? 0;
        _calcKazaOruc = prefs.getInt('kaza_calc_ko') ?? 0;
        _calcKefaretCount = prefs.getInt('kaza_calc_kc') ?? 0;
        _reglDays = prefs.getInt('kaza_calc_regl') ?? 6;
        _isVitirEnabled = prefs.getBool('kaza_vitir_enabled') ?? true;




        _isLoading = false;
      });
    }
  }

  Future<void> _updatePrayerCount(String vakit, int change) async {
    setState(() {
      _prayerCounts[vakit] = (_prayerCounts[vakit] ?? 0) + change;
      if ((_prayerCounts[vakit] ?? 0) < 0) _prayerCounts[vakit] = 0;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('kaza_namaz_$vakit', _prayerCounts[vakit]!);
  }


  Future<void> _updateOrucCount(int change) async {
    setState(() {
      _orucCount += change;
      if (_orucCount < 0) _orucCount = 0;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('kaza_oruc_main', _orucCount);
  }



  int _calculateTotalPrayerDebt() {
    int total = 0;
    for (int count in _prayerCounts.values) {
      total += count;
    }
    return total;
  }


  int _calculateTotalOrucDebt() {
    return _orucCount;
  }

  void _showCalculator() {
    final TextEditingController currentAgeController = TextEditingController(text: _currentAge > 0 ? _currentAge.toString() : "");
    final TextEditingController pubertyAgeController = TextEditingController(text: _pubertyAge.toString());
    final TextEditingController yearController = TextEditingController(text: _calcYear > 0 ? _calcYear.toString() : "");
    final TextEditingController monthController = TextEditingController(text: _calcMonth > 0 ? _calcMonth.toString() : "");
    final TextEditingController dayController = TextEditingController(text: _calcDay > 0 ? _calcDay.toString() : "");
    final TextEditingController kazaOrucController = TextEditingController(text: _calcKazaOruc > 0 ? _calcKazaOruc.toString() : "");
    final TextEditingController kefaretCountController = TextEditingController(text: _calcKefaretCount > 0 ? _calcKefaretCount.toString() : "");
    final TextEditingController reglDaysController = TextEditingController(text: _reglDays.toString());

    String localGender = _gender;
    bool localVitirEnabled = _isVitirEnabled;


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24, right: 24, top: 32,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hesaplama Sihirbazı",
                      style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: kubbePurple),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // [Cinsiyet Seçimi - Gender Selection]
                Center(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Erkek', label: Text('Erkek'), icon: Icon(Icons.male)),
                      ButtonSegment(value: 'Kadın', label: Text('Kadın'), icon: Icon(Icons.female)),
                    ],
                    selected: {localGender},
                    onSelectionChanged: (Set<String> newSelection) {
                      setModalState(() {
                        localGender = newSelection.first;
                        if (localGender == 'Kadın') {
                          pubertyAgeController.text = "12";
                        } else {
                          pubertyAgeController.text = "15";
                        }
                      });
                    },
                    style: SegmentedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      selectedBackgroundColor: kubbePurple,
                      selectedForegroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (localGender == 'Kadın') ...[
                  _buildTextField("Aylık Ortalama Özel Gün (Regl)", reglDaysController, false),
                  const SizedBox(height: 16),
                ],




                Row(
                  children: [
                    Expanded(child: _buildTextField("Şu Anki Yaş", currentAgeController, false)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField("Ergenlik Yaşı", pubertyAgeController, false)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField("Yıl", yearController, false)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField("Ay", monthController, false)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField("Gün", dayController, false)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField("Normal Kaza Orucu (Gün)", kazaOrucController, false),
                const SizedBox(height: 12),
                _buildTextField("Bozulan Oruç (Kefaret Sayısı)", kefaretCountController, false),
                const SizedBox(height: 16),

                SwitchListTile(
                  title: Text("Vitir Namazı Hesaplansın", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600)),
                  subtitle: Text("Hanefi mezhebine göre Vitir namazının kazası vaciptir.", style: GoogleFonts.outfit(fontSize: 12)),
                  value: localVitirEnabled,
                  activeThumbColor: kubbePurple,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setModalState(() => localVitirEnabled = val),
                ),
                const SizedBox(height: 24),

                // [Hesapla Butonu - Calculate Button]
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      final age = int.tryParse(currentAgeController.text) ?? 0;
                      final pub = int.tryParse(pubertyAgeController.text) ?? 0;
                      final ageDebt = (age > pub) ? (age - pub) * 365 : 0;

                      final y = int.tryParse(yearController.text) ?? 0;
                      final m = int.tryParse(monthController.text) ?? 0;
                      final d = int.tryParse(dayController.text) ?? 0;
                      final manualNamazDays = (y * 365) + (m * 30) + d;

                      final totalNamazDays = ageDebt + manualNamazDays;

                      final ko = int.tryParse(kazaOrucController.text) ?? 0;
                      final kc = int.tryParse(kefaretCountController.text) ?? 0;
                      final totalOruc = ko + (kc * 61);
                      final regl = int.tryParse(reglDaysController.text) ?? 6;
                      final vitirEnabled = localVitirEnabled;


                      _confirmRecalculation(
                        totalNamazDays, 
                        totalOruc,
                        gender: localGender,
                        age: age,
                        pub: pub,
                        y: y, m: m, d: d,
                        ko: ko, kc: kc,
                        regl: regl,
                        vitir: vitirEnabled,
                      );


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kubbePurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text("Hesapla ve Kaydet", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildTextField(String label, TextEditingController controller, bool autofocus) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      autofocus: autofocus,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: GoogleFonts.outfit(fontSize: 16),
      onTap: () {
        if (controller.text == '0') {
          controller.clear();
        }
      },
      onChanged: (value) {
        if (value == '0') {
          controller.clear();
        }
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: "0",
        labelStyle: GoogleFonts.outfit(color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kubbePurple, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  void _confirmRecalculation(
    int totalNamazDays, 
    int totalOruc, 
    {required String gender, required int age, required int pub, required int y, required int m, required int d, required int ko, required int kc, required int regl, required bool vitir}
  ) {


    if (totalNamazDays == 0 && totalOruc == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen geçerli değerler girin!")));
      return;
    }

    bool hasData = _prayerCounts.values.any((v) => v > 0) || _orucCount > 0;
    
    if (hasData) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Uyarı"),
          content: const Text("Mevcut verileriniz silinip yeniden hesaplanacaktır, onaylıyor musunuz?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Vazgeç")),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _performCalculation(totalNamazDays, totalOruc, gender: gender, age: age, pub: pub, y: y, m: m, d: d, ko: ko, kc: kc, regl: regl, vitir: vitir);
              },


              child: const Text("Evet, Hesapla", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      _performCalculation(totalNamazDays, totalOruc, gender: gender, age: age, pub: pub, y: y, m: m, d: d, ko: ko, kc: kc, regl: regl, vitir: vitir);
    }


  }

  Future<void> _performCalculation(
    int totalNamazDays, 
    int totalOruc,
    {required String gender, required int age, required int pub, required int y, required int m, required int d, required int ko, required int kc, required int regl, required bool vitir}
  ) async {
    final prefs = await SharedPreferences.getInstance();
    
    int finalNamazDays = totalNamazDays;

    
    // [Kadın Muafiyet Formülü - Women's Exemption Formula]
    if (gender == 'Kadın') {
      int totalDays = totalNamazDays;
      int totalMonths = totalDays ~/ 30;
      int exemptDays = totalMonths * regl;
      finalNamazDays = totalDays - exemptDays;
    }

    for (String vakit in _prayerVakitler) {
      if (vakit == 'Vitir' && !vitir) continue;
      await prefs.setInt('kaza_namaz_$vakit', finalNamazDays);
    }


    await prefs.setInt('kaza_oruc_main', totalOruc);

    // [Belleği Kaydet - Save Input Memory]
    await prefs.setString('kaza_calc_gender', gender);
    await prefs.setInt('kaza_calc_currentAge', age);
    await prefs.setInt('kaza_calc_pubertyAge', pub);
    await prefs.setInt('kaza_calc_year', y);
    await prefs.setInt('kaza_calc_month', m);
    await prefs.setInt('kaza_calc_day', d);
    await prefs.setInt('kaza_calc_ko', ko);
    await prefs.setInt('kaza_calc_kc', kc);
    await prefs.setInt('kaza_calc_regl', regl);
    await prefs.setBool('kaza_vitir_enabled', vitir);



    if (mounted) {
      Navigator.pop(context); // Close bottom sheet
      _loadKazaData();
      HapticFeedback.heavyImpact();
    }
  }



  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: PulsingLoader());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Kaza Defteri", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: kubbePurple)),
        actions: [
          IconButton(
            onPressed: _showCalculator,
            icon: Icon(PhosphorIcons.calculator(PhosphorIconsStyle.bold), color: kubbePurple),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopOverviewCard(),
            const SizedBox(height: 24),
            _buildUniversalGrid(),
          ],
        ),
      ),
    );
  }



  Widget _buildTopOverviewCard() {
    final totalNamaz = _calculateTotalPrayerDebt();
    final totalOruc = _calculateTotalOrucDebt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kubbePurple,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: kubbePurple.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildTotalItem("🕌 Namaz", totalNamaz)),
                const VerticalDivider(color: Colors.white24, thickness: 1, indent: 8, endIndent: 8),
                Expanded(child: _buildTotalItem("🌙 Oruç", totalOruc)),
              ],
            ),
          ),
        ],
      ),
    );
  }






  Widget _buildTotalItem(String title, int count) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _formatNumber(count),
            maxLines: 1,
            style: GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),

      ],
    );
  }


  Widget _buildUniversalGrid() {
    double cardWidth = (MediaQuery.of(context).size.width - 48 - 12) / 2;
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _buildPrayerCard('Sabah', cardWidth),
        _buildPrayerCard('Öğle', cardWidth),
        _buildPrayerCard('İkindi', cardWidth),
        _buildPrayerCard('Akşam', cardWidth),
        _buildPrayerCard('Yatsı', cardWidth),
        _buildOrucGridCard(cardWidth),
        if (_isVitirEnabled) 
          _buildPrayerCard('Vitir', MediaQuery.of(context).size.width - 48),
      ],
    );
  }







  Widget _buildPrayerCard(String vakit, double width) {
    final count = _prayerCounts[vakit] ?? 0;
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 140),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(vakit, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
            const SizedBox(height: 6),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _formatNumber(count),
                  maxLines: 1,
                  style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w900, color: kubbePurple),
                ),
              ),
            ),

            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HoldToCompleteButton(
                  onComplete: () => _updatePrayerCount(vakit, -1),
                  color: kubbePurple,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _updatePrayerCount(vakit, 1);
                  },
                  icon: Icon(Icons.undo_rounded, size: 20, color: Colors.grey[400]),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildOrucGridCard(double width) {
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 140),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.deepOrange.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Oruç", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.deepOrange)),
            const SizedBox(height: 6),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _formatNumber(_orucCount),
                  maxLines: 1,
                  style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.deepOrange),
                ),
              ),
            ),

            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HoldToCompleteButton(
                  onComplete: () => _updateOrucCount(-1),
                  color: Colors.deepOrange,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _updateOrucCount(1);
                  },
                  icon: Icon(Icons.undo_rounded, size: 20, color: Colors.grey[400]),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }





  String _formatNumber(int number) {

    return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}

class HoldToCompleteButton extends StatefulWidget {
  final VoidCallback onComplete;
  final Color color;

  const HoldToCompleteButton({super.key, required this.onComplete, required this.color});


  @override
  State<HoldToCompleteButton> createState() => _HoldToCompleteButtonState();
}

class _HoldToCompleteButtonState extends State<HoldToCompleteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onComplete();
      }
    });
  }

  void _onComplete() {
    HapticFeedback.mediumImpact();
    widget.onComplete();
    setState(() => _isSuccess = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isSuccess = false);
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onComplete();
      },
      onLongPressStart: (_) => _controller.forward(),
      onLongPressEnd: (_) {
        if (!_controller.isCompleted) {
          _controller.reverse();
        }
      },

      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isSuccess ? Colors.green : widget.color.withValues(alpha: 0.1),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: _controller.value,
                    strokeWidth: 3,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  ),
                ),
                Icon(
                  _isSuccess ? Icons.check : Icons.check_circle_outline_rounded,
                  color: _isSuccess ? Colors.white : widget.color,
                  size: 24,
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
