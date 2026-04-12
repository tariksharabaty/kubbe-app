import 'dart:convert'; // [JSON işlemleri için - For JSON operations]
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/services.dart'; // [Haptik titreşim için - For Haptic Feedback]
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // [Kalıcı hafıza için - For persistent storage]
import 'package:wakelock_plus/wakelock_plus.dart'; // [Ekranı açık tutmak için - To keep screen on]

// [Zikirmatik Ekranı: Konfeti Patlamalı ve Analitikli - Zikirmatik Screen: Confetti and Analytics]
class ZikirmatikScreen extends StatefulWidget {
  final String? initialZikirName;
  final int? initialTargetCount;
  const ZikirmatikScreen({super.key, this.initialZikirName, this.initialTargetCount});

  @override
  State<ZikirmatikScreen> createState() => _ZikirmatikScreenState();
}

class _ZikirmatikScreenState extends State<ZikirmatikScreen> with TickerProviderStateMixin {
  int zikirCount = 0; // [Sayaç değeri - Counter value]
  bool isEyeMode = false; // [Göz Koruması Modu - Eye Protection Mode]
  bool isVibrateEnabled = true; // [Titreşim ayarı - Vibration setting]
  bool isWakelockEnabled = false; // [Ekran uyanık kalma ayarı - Wakelock setting]

  // [Akıllı Hedef Değişkenleri - Smart Target Variables]
  String zikirName = ""; // [Zikir adı - Zikir name]
  int targetCount = 0; // [Zikir hedefi - Zikir target]
  
  late AnimationController _completionController; // [Hedef tamamlanınca büyüme için - For scale up on completion]
  late Animation<double> _scaleAnimation;

  late AnimationController _breathingController; // [Nefes alma animasyonu - Breathing animation]
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _loadZikirData(); 
    
    // [Tamamlanma Animasyonu - Completion Animation]
    _completionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _completionController, curve: Curves.elasticOut),
    );

    // [Nefes Alma Animasyonu - Breathing Animation (0.98 - 1.02)]
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    ); // [Artık otomatik başlamıyor - No longer starts automatically]
    _breathingAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _completionController.dispose();
    _breathingController.dispose();
    WakelockPlus.disable(); // [Ekran kilidini bırak - Release wakelock]
    super.dispose();
  }

  // [Zikir verilerini kalıcı hafızaya yükle - Load zikir data]
  Future<void> _loadZikirData() async {
    if (widget.initialZikirName != null || widget.initialTargetCount != null) {
      setState(() {
        zikirName = widget.initialZikirName ?? "";
        targetCount = widget.initialTargetCount ?? 0;
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      zikirName = prefs.getString('zikir_name') ?? "";
      targetCount = prefs.getInt('target_zikr_count') ?? 0; // Corrected key
      isVibrateEnabled = prefs.getBool('zikir_vibrate') ?? true;
      isWakelockEnabled = prefs.getBool('zikir_wakelock') ?? false;
      
      if (isWakelockEnabled) {
        WakelockPlus.enable();
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      zikirCount++;

      // [Kilometre Taşları - Milestone Messages]
      if (zikirCount == 33 || zikirCount == 66 || zikirCount == 99) {
        _showMilestoneSnackbar();
      }

      // [Haptik Senfoni - Haptic Symphony]
      if (targetCount > 0) {
        if (zikirCount == targetCount) {
          // Hedefe ulaşıldığında: Güçlü titreşim ve Nefes animasyonu başlat - Target reached: Heavy impact and start breathing
          if (isVibrateEnabled) HapticFeedback.heavyImpact();
          _completionController.forward().then((_) => _completionController.reverse());
          _breathingController.repeat(reverse: true); // [Nefes başlasın - Start breathing]
          _saveToAnalytics();
        } else if (zikirCount == targetCount - 1) {
          // Hedefe 1 kala: İki kere orta titreşim - 1 before target: Double medium impact
          if (isVibrateEnabled) {
            HapticFeedback.mediumImpact();
            Future.delayed(const Duration(milliseconds: 100), () => HapticFeedback.mediumImpact());
          }
        } else {
          if (isVibrateEnabled) HapticFeedback.lightImpact();
        }
      } else {
        if (isVibrateEnabled) HapticFeedback.lightImpact();
      }
    });
  }

  void _showMilestoneSnackbar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Allah kabul etsin seyyah...',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.8), // Gold tone
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _resetCounter() {
    if (isVibrateEnabled) HapticFeedback.vibrate();
    setState(() {
      zikirCount = 0;
      _breathingController.stop(); // [Nefesi durdur - Stop breathing]
      _breathingController.reset();
    });
  }

  void _resetTarget() {
    if (isVibrateEnabled) HapticFeedback.mediumImpact();
    setState(() {
      zikirName = "";
      targetCount = 0;
      zikirCount = 0;
      _breathingController.stop(); // [Nefesi durdur - Stop breathing]
      _breathingController.reset();
    });
  }

  // [Aylık/Yıllık Özet İçin Veri Biriktirme - Data Accumulation]
  Future<void> _saveToAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    int totalZikr = (prefs.getInt('total_zikr_count') ?? 0) + zikirCount;
    await prefs.setInt('total_zikr_count', totalZikr);

    String today = DateTime.now().toString().split(' ')[0];

    Map<String, dynamic> analyticsData = {
      'date': today,
      'zikir_name': zikirName.isNotEmpty ? zikirName : 'İsimsiz',
      'target_count': targetCount,
      'completed_count': zikirCount,
      'total_count': totalZikr,
      'type': 'daily_zikir_completion',
    };

    List<Map<String, dynamic>> existingData = [];
    String? existingJson = prefs.getString('zikir_analytics');
    if (existingJson != null) {
      try {
        existingData = List<Map<String, dynamic>>.from(jsonDecode(existingJson));
      } catch (e) {
        existingData = [];
      }
    }

    existingData.add(analyticsData);
    await prefs.setString('zikir_analytics', jsonEncode(existingData));
  }

  // [Ayarlar Paneli - Settings Bottom Sheet]
  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final Color textColor = isEyeMode ? Colors.amber.shade700 : Colors.black;
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isEyeMode ? const Color(0xFF121212) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Zikirmatik Ayarları",
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text("Titreşim", style: GoogleFonts.outfit(color: textColor)),
                    subtitle: Text("Her zikirde haptik geri bildirim", style: GoogleFonts.inter(fontSize: 12)),
                    value: isVibrateEnabled,
                    activeThumbColor: const Color(0xFF4B0082),
                    onChanged: (val) async {
                      setSheetState(() => isVibrateEnabled = val);
                      setState(() => isVibrateEnabled = val);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('zikir_vibrate', val);
                    },
                  ),
                  SwitchListTile(
                    title: Text("Ekran Her Zaman Açık", style: GoogleFonts.outfit(color: textColor)),
                    subtitle: Text("Zikir çekerken ekran kapanmaz", style: GoogleFonts.inter(fontSize: 12)),
                    value: isWakelockEnabled,
                    activeThumbColor: const Color(0xFF4B0082),
                    onChanged: (val) async {
                      setSheetState(() => isWakelockEnabled = val);
                      setState(() => isWakelockEnabled = val);
                      
                      if (val) {
                        WakelockPlus.enable();
                      } else {
                        WakelockPlus.disable();
                      }

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('zikir_wakelock', val);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // [Hedef Belirleme Penceresi - Target Setting Bottom Sheet]
  void _showTargetBottomSheet() {
    final TextEditingController nameController = TextEditingController(text: zikirName);
    final TextEditingController targetController = TextEditingController(text: targetCount > 0 ? targetCount.toString() : "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isEyeMode ? const Color(0xFF121212) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Hedef Belirle",
                  style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: isEyeMode ? const Color(0xFF3E2723) : Colors.black),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: "Zikir Adı (Örn: Ya Sabır)",
                    filled: true,
                    fillColor: isEyeMode ? const Color(0xFFFFD54F).withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    prefixIcon: Icon(PhosphorIcons.notePencil(), color: isEyeMode ? const Color(0xFF3E2723) : Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Hedef Sayı (Örn: 99)",
                    filled: true,
                    fillColor: isEyeMode ? const Color(0xFFFFD54F).withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    prefixIcon: Icon(PhosphorIcons.flag(), color: isEyeMode ? const Color(0xFF3E2723) : Colors.black),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEyeMode ? const Color(0xFFD84315) : Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () async {
                      final newName = nameController.text.trim();
                      final inputTarget = targetController.text.trim();
                      final newTarget = inputTarget.isNotEmpty ? (int.tryParse(inputTarget) ?? 0) : targetCount;
                      
                      // [Esnek Hedef: Sadece isim değişmişse hedefi sıfırlama zorunluluğu kalktı]
                      final bool isTargetChanged = inputTarget.isNotEmpty && newTarget != targetCount;

                      if (zikirCount > 0 && isTargetChanged) {
                        // [Güvenlik Sorusu - Security Question]
                        final Color dialogTextColor = isEyeMode ? Colors.amber.shade700 : Colors.black;
                        final bool? shouldReset = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: isEyeMode ? const Color(0xFF121212) : Colors.white,
                            title: Text("Yeni Hedef", style: TextStyle(color: dialogTextColor)),
                            content: Text("Yeni bir hedef belirlediniz. Mevcut zikir sayınız ($zikirCount) sıfırlansın mı?", style: TextStyle(color: dialogTextColor.withValues(alpha: 0.8))),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Kaldığım Yerden Devam Et"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text("Sıfırla"),
                              ),
                            ],
                          ),
                        );

                        if (shouldReset == null) return; // İptal edildi - Cancelled
                        if (shouldReset) {
                          setState(() => zikirCount = 0);
                        }
                      }

                      setState(() {
                        zikirName = newName.isNotEmpty ? newName : zikirName;
                        targetCount = newTarget;
                      });
                      
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('zikir_name', zikirName);
                      await prefs.setInt('target_zikr_count', targetCount);
                      if (isVibrateEnabled) HapticFeedback.lightImpact();
                      
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    child: Text("Başla", style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // [Kehribar Modu Kesin Kurallar: Sadece Siyah ve Amber (#FFBF00)]
    final Color bgColor = isEyeMode ? const Color(0xFF000000) : Colors.white;
    final Color circleColor = isEyeMode ? const Color(0xFFFFBF00).withValues(alpha: 0.1) : const Color(0xFFF5F6F8);
    final Color textColor = isEyeMode ? const Color(0xFFFFBF00) : Colors.black;
    final Color amber = const Color(0xFFFFBF00);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(PhosphorIcons.caretLeft(), color: textColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "ZİKİRMATİK",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 2.0, color: textColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.gear(), color: textColor, size: 26),
            onPressed: _showSettingsBottomSheet,
          ),
          IconButton(
            icon: Icon(isEyeMode ? PhosphorIcons.sun() : PhosphorIcons.eye(), color: textColor, size: 26),
            onPressed: () => setState(() => isEyeMode = !isEyeMode),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GestureDetector(
        onTap: _incrementCounter,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              if (zikirName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    children: [
                      Text(zikirName, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: textColor), textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      if (targetCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(color: circleColor, borderRadius: BorderRadius.circular(20)),
                          child: Text("Hedef: $targetCount", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor.withValues(alpha: 0.7))),
                        ),
                    ],
                  ),
                ),

              Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: ScaleTransition(
                    scale: _breathingAnimation, // [Nefes Animasyonu - Breathing]
                    child: GestureDetector(
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity != 0) {
                        // [Her türlü kaydırma (Up or Down) Artırır - Any swipe increments]
                        _incrementCounter();
                      }
                    },
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isEyeMode 
                            ? [amber.withValues(alpha: 0.2), amber.withValues(alpha: 0.05)]
                            : [const Color(0xFFFDFDFF), const Color(0xFFE8E9F3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          // [Dış Gölge - Outer Shadow (Elevated)]
                          BoxShadow(
                            color: textColor.withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(10, 10),
                          ),
                          // [İç Aydınlık - Inner Highlight (3D Edge)]
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.8),
                            blurRadius: 20,
                            offset: const Offset(-10, -10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          zikirCount.toString(),
                          style: GoogleFonts.poppins(fontSize: 100, fontWeight: FontWeight.w900, color: textColor, height: 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
              
              if (targetCount > 0 && zikirCount >= targetCount)
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40), // [Kurtarılmış Alan - Safe Space]
                      Text(
                        'Elhamdülillah, hedefe ulaştınız.\nDevam edebilir veya sıfırlayabilirsiniz.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, color: isEyeMode ? amber : const Color(0xFF4B0082), height: 1.4),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // [Küçük Sıfırla (Sadece Sayı) - Small Reset (Only Count)]
                    InkWell(
                      onTap: _resetCounter,
                      onLongPress: _resetTarget, // Long press resets everything
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(color: circleColor, borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            Icon(PhosphorIcons.arrowsCounterClockwise(), color: textColor, size: 20),
                            const SizedBox(width: 8),
                            Text("SIFIRLA", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: textColor, letterSpacing: 1.0)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // [Hedef Butonu - Target Button]
                    InkWell(
                      onTap: _showTargetBottomSheet,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
                        child: Icon(PhosphorIcons.flag(), color: textColor, size: 24),
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
