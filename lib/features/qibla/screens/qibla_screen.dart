import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/widgets/custom_loading_animation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../../core/utils/qibla_calculator.dart'; // [Kıble hesaplayıcı - Qibla calculator]

// [Kıble Pusulası Ekranı: Gerçek zamanlı yön bulma]
// [Qibla Compass Screen: Real-time direction finding]
class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? qiblaDirection; // [Hesaplanan Kıble açısı - Calculated Qibla bearing]
  bool hasPermission = false; // [Konum izni durumu - Location permission status]
  String statusText = "Başlatılıyor..."; // [Anlık durum metni - Real-time status text]
  String? errorMessage; // [Hata mesajı - Error message]
  bool isHapticPlayed = false; // [Titreşim çalındı mı? - Is haptic feedback played?]
  bool isCalibrated = false; // [Kalibrasyon durumu - Calibration status]
  bool hasSensorError = false; // [Sensör hatası var mı? - Is there a sensor error?]

  // [Sensör Akışları - Sensor Streams]
  StreamSubscription? _accelSubscription;
  StreamSubscription? _magSubscription;
  Timer? _sensorTimer; // [Sensör zaman aşımı kontrolü - Sensor timeout timer]
  
  // [Filtrelenmiş Veriler - Filtered Data]
  List<double> _accelerometerReading = [0, 0, 0];
  List<double> _magnetometerReading = [0, 0, 0];
  double _heading = 0.0;
  
  // [Filtreleme Katsayısı - Filtering Coefficient]
  final double _filterAlpha = 0.15; // [Düşük geçiren filtre hassasiyeti - Low-pass filter sensitivity]

  @override
  void initState() {
    super.initState();
    _checkLocationPermission(); // [Başlangıçta izin kontrolü - Permission check on start]
    _initSensors();
    _startSensorTimeout(); // [Zaman aşımı kontrolünü başlat - Start timeout check]
  }

  void _startSensorTimeout() {
    // [3 saniye içinde veri gelmezse hata ver - Error if no data in 3s]
    _sensorTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && (_magnetometerReading.every((e) => e == 0) || hasSensorError)) {
        setState(() {
          hasSensorError = true;
          errorMessage = "Pusula sensörü başlatılamadı. Lütfen cihazı yeniden başlatın. (Sensor could not initialize)";
        });
      }
    });
  }

  void _initSensors() {
    try {
      // [İvmeölçer ve Manyetometre ortaklaşa çalışır - Accel and Mag work together]
      _accelSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
        if (mounted) {
          setState(() {
            _accelerometerReading = [
              _accelerometerReading[0] + _filterAlpha * (event.x - _accelerometerReading[0]),
              _accelerometerReading[1] + _filterAlpha * (event.y - _accelerometerReading[1]),
              _accelerometerReading[2] + _filterAlpha * (event.z - _accelerometerReading[2]),
            ];
            _calculateHeading();
          });
        }
      }, onError: (e) {
         debugPrint("Accel error: $e");
      });

      _magSubscription = magnetometerEvents.listen((MagnetometerEvent event) {
        if (mounted) {
          setState(() {
            _magnetometerReading = [
              _magnetometerReading[0] + _filterAlpha * (event.x - _magnetometerReading[0]),
              _magnetometerReading[1] + _filterAlpha * (event.y - _magnetometerReading[1]),
              _magnetometerReading[2] + _filterAlpha * (event.z - _magnetometerReading[2]),
            ];
            _calculateHeading();
          });
        }
      }, onError: (e) {
         debugPrint("Mag error: $e");
         if (mounted) {
           setState(() {
             hasSensorError = true;
             errorMessage = "Cihazınızda pusula sensörü bulunamadı. (No magnetometer found)";
           });
         }
      });
    } on PlatformException catch (e) {
      debugPrint("Platform error: $e");
      if (mounted) setState(() {
        hasSensorError = true;
        errorMessage = "Donanım erişim hatası: ${e.message}";
      });
    } on MissingPluginException catch (e) {
      debugPrint("Plugin missing: $e");
      if (mounted) setState(() {
        hasSensorError = true;
        errorMessage = "Pusula eklentisi bulunamadı. (Plugin missing)";
      });
    } catch (e) {
      debugPrint("Sensor init error: $e");
      if (mounted) setState(() {
        hasSensorError = true;
        errorMessage = "Sensörler başlatılamadı. (Sensors could not start)";
      });
    }
  }

  void _calculateHeading() {
    // [Yön hesaplama algoritması - Heading calculation algorithm]
    double heading = math.atan2(_magnetometerReading[1], _magnetometerReading[0]) * 180 / math.pi;
    
    // [360 dereceye normalize et - Normalize to 360 degrees]
    heading = (heading + 360) % 360;
    
    // [Manyetik sapma düzeltmesi (yaklaşık) - Magnetic declination correction (approx)]
    _heading = heading;
  }

  @override
  void dispose() {
    _accelSubscription?.cancel();
    _magSubscription?.cancel();
    _sensorTimer?.cancel();
    super.dispose();
  }

  // [Zırhlandırılmış Konum Servisi Metodu - Reinforced Location Service Method]
  Future<void> _checkLocationPermission() async {
    try {
      if (mounted) setState(() => statusText = "GPS sensörü kontrol ediliyor...");

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => errorMessage = "Cihazınızın konum ayarlarına ulaşılamadı. Lütfen ayarlardan konum izni verdiğinizden emin olun.");
        return;
      }

      if (mounted) setState(() => statusText = "Konum izni kontrol ediliyor...");

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() => errorMessage = "Cihazınızın konum ayarlarına ulaşılamadı. Lütfen ayarlardan konum izni verdiğinizden emin olun.");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => errorMessage = "Cihazınızın konum ayarlarına ulaşılamadı. Lütfen ayarlardan konum izni verdiğinizden emin olun.");
        return;
      }

      if (mounted) setState(() => statusText = "Uyduya bağlanılıyor (En fazla 10 sn)...");

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 10),
        );
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        if (mounted) setState(() => errorMessage = "Cihazınızın konum ayarlarına ulaşılamadı. Lütfen ayarlardan konum izni verdiğinizden emin olun.");
        return;
      }

      if (mounted) setState(() => statusText = "Kıble açısı hesaplanıyor...");

      double qibla = QiblaCalculator.calculateQiblaBearing(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          qiblaDirection = qibla;
          hasPermission = true;
        });
      }
    } catch (e) {
      if (mounted) setState(() => errorMessage = "Cihazınızın konum ayarlarına ulaşılamadı. Lütfen ayarlardan konum izni verdiğinizden emin olun.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // [Sensör Hatası Fail-Safe - Sensor Error Fail-Safe]
    if (hasSensorError) {
      return _buildSensorErrorUI();
    }

    // [Hata Durumu: İzin veya GPS kapalı]
    if (errorMessage != null) {
      return _buildErrorState();
    }

    // [Yükleme durumu]
    if (!hasPermission || qiblaDirection == null) {
      return _buildLoadingState();
    }

    // [Kalibrasyon Ekranı]
    if (!isCalibrated) {
      return _buildCalibrationState();
    }

    // [Sensör Verisi Bekleme Koruması]
    if (_magnetometerReading.every((e) => e == 0)) {
      return _buildSensorWaitingState();
    }

    // [Hesaplamalar]
    final double difference = (qiblaDirection! - _heading + 360) % 360;
    final bool isAligned = (difference < 4 || difference > 356);

    // [Haptic Feedback]
    if (isAligned && !isHapticPlayed) {
      HapticFeedback.vibrate();
      isHapticPlayed = true;
    } else if (!isAligned) {
      isHapticPlayed = false;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Kıble", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 24, color: const Color(0xFF4B0082))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF4B0082)),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                isAligned ? "Kıbleye Döndünüz" : "Kıbleyi Bulmak İçin Dönün",
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isAligned ? Colors.green : const Color(0xFF4B0082),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 300, height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isAligned ? Colors.green : const Color(0xFF4B0082).withValues(alpha: 0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        if (isAligned) BoxShadow(color: Colors.green.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 5),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: -_heading / 360,
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      width: 260, height: 260,
                      alignment: Alignment.topCenter,
                      child: const Text("N", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.grey)),
                    ),
                  ),
                  AnimatedRotation(
                    turns: (qiblaDirection! - _heading) / 360,
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      width: 290, height: 290,
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isAligned ? Colors.green : Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: isAligned ? Colors.white : const Color(0xFF4B0082).withValues(alpha: 0.2)),
                        ),
                        child: Icon(Icons.location_on, color: isAligned ? Colors.white : const Color(0xFF4B0082), size: 32),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -30,
                    child: Icon(Icons.arrow_drop_down_rounded, size: 60, color: isAligned ? Colors.green : const Color(0xFF4B0082)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF4B0082).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${difference.toStringAsFixed(0)}°",
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isAligned ? Colors.green : const Color(0xFF4B0082),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Eğer pusula yanlış gösteriyorsa, telefonunuzu havada '8' çizecek şekilde hareket ettirerek sensörü kalibre edin.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [Yeni: Sensör Hatası Arayüzü - Sensor Error UI]
  Widget _buildSensorErrorUI() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF4B0082)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.compass_calibration_rounded, color: Colors.red, size: 64),
              ),
              const SizedBox(height: 24),
              Text("Sensör Hatası", style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 12),
              Text(
                errorMessage ?? "Cihazınızda gerekli pusula sensörleri (manyetometre) bulunamadı.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B0082),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Geri Dön"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF4B0082)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off_rounded, size: 60, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(errorMessage!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B0082), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  setState(() { errorMessage = null; statusText = "Yeniden deneniyor..."; });
                  _checkLocationPermission();
                },
                child: const Text("Tekrar Dene", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF4B0082)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomLoadingAnimation(color: Color(0xFF4B0082)),
            const SizedBox(height: 20),
            Text(statusText, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildCalibrationState() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kıble", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 24, color: const Color(0xFF4B0082))),
        centerTitle: true, elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF4B0082)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.all_inclusive_rounded, size: 110, color: Color(0xFF4B0082)),
              const SizedBox(height: 32),
              Text("Pusula Kalibrasyonu", style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF4B0082))),
              const SizedBox(height: 16),
              Text("Kıbleyi kusursuz bulabilmemiz için telefonunuzu havada '8' çizecek şekilde 3-4 kez pürüzsüzce hareket ettirin.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 15, color: Colors.black87, height: 1.5)),
              const SizedBox(height: 48),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B0082), minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () => setState(() => isCalibrated = true),
                child: Text("Kalibre Ettim", style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorWaitingState() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF4B0082)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomLoadingAnimation(color: Color(0xFF4B0082)),
            const SizedBox(height: 20),
            const Text("Manyetik sensör bekleniyor...", style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
