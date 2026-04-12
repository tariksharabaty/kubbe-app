import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:easy_localization/easy_localization.dart'; // [Çoklu dil desteği - Multi-language support]


import '../../../core/models/prayer_time_model.dart';
import '../../../core/models/location_model.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/history_service.dart';
import '../../../core/utils/string_extensions.dart';
import '../../../ui/widgets/pulsing_loader.dart';
import '../../../ui/widgets/ramadan_custom_card.dart';
import '../../../core/state/hatim_state.dart';
import '../../../core/state/prayer_time_provider.dart';
import 'package:provider/provider.dart';

import '../../tools/screens/maneviyat_rehberi_screen.dart'; // [Maneviyat Rehberi | Spiritual Guide]
import '../../settings/screens/settings_screen.dart';
import '../../quran/screens/surah_reading_screen.dart';
import '../../history/screens/history_detail_screen.dart';
import '../../history/screens/tarihin_kubbesi_screen.dart';
import '../../history/data/history_repository.dart';
// [Hızlı Erişim Ekranları - Quick Access Screens]
import '../../lale_bahcesi/screens/lale_bahcesi_screen.dart';
import '../../zikirmatik/screens/zikirmatik_screen.dart';
import '../widgets/daily_pearl_card.dart'; // [Günün İncileri Modüler Kart | Daily Pearl Modular Card]
import 'location_selection_screen.dart';
import 'takvim_screen.dart';
import 'package:quran/quran.dart' as quran;


// Ana Sayfa Ekranı - Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Veri ve durum değişkenleri - Data and state variables
  bool _isInScreenshotMode = false;
  bool _isFastingModeActive = false;
  
  // [Sağlayıcı üzerinden yönetiliyor - Managed via Provider]
  LocationModel _currentLocation = const LocationModel(sehir: 'İstanbul', ulke: 'Türkiye'); 
  
  int _nextPrayerIndex = 0; // [Sonraki namaz indeksi - Next prayer index]
  bool _isGettingLocation = false; // [Konum alınıyor mu? - Getting location?]
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0; // Mevcut sayfa indeksi 

  // [Vakit Durum Değişkenleri - Prayer State Variables]
  Timer? _timer;
  PrayerTimeModel? _currentPrayerTimes;
  String _countdownText = "--:--:--";
  String _nextPrayerName = "Gökyüzüyle bağın koptu...";
  String _specialLabel = "";
  String _specialTime = "00:00:00";

  // [Dinamik İsim Haritası - Dynamic Name Map]
  static const Map<String, String> _prayerNameMap = {
    'İmsak': 'İmsaka',
    'Güneş': 'Güneşe',
    'Öğle': 'Öğleye',
    'İkindi': 'İkindiye',
    'Akşam': 'Akşama',
    'Yatsı': 'Yatsıya',
    'Fajr': 'İmsaka',
    'Imsak': 'İmsaka',
    'Sunrise': 'Güneşe',
    'Dhuhr': 'Öğleye',
    'Asr': 'İkindiye',
    'Maghrib': 'Akşama',
    'Isha': 'Yatsıya',
  };

  // [Yeni Özel İftar/Sahur Modülü - New Special Iftar/Sahur Module]
  Timer? _specialTimer;

  // [Hatim Takibi Verileri - Hatim Tracking Data]
  int lastReadSurah = 1;
  int lastReadAyah = 1;
  String lastReadSurahName = 'Fatiha';
  bool hasHatimPlan = false; // [Hatim planı var mı? - Has hatim plan?]
  
  // [Gelecek verisi değişkeni | Future data variable]
  late Future<List<Map<String, dynamic>>> _dailyContentFuture;

  @override
  void initState() {
    super.initState();
    initHatimState(); // [Kritik: Uygulama açıldığında hafızayı yükler - Loads storage on app start]
    _loadLastRead(); // [Son okunanı yükle - Load last read]
    _loadScreenshotMode(); // [Geliştirici modunu yükle]
    _loadFastingMode();
    HistoryService.updates.addListener(_onServiceUpdate);
    _fetchRealPrayerTimes(); // [API'den gerçek verileri çek - Fetch real data from API]
    _dailyContentFuture = _getDailyContent(); // [Veriyi sadece bir kez başlat | Initialize data only once]
    FlutterNativeSplash.remove(); // [Splash ekranını kaldır - Remove splash screen]
  }

  // [Günün içeriğini hazırlayan asenkron fonksiyon | Async function preparing daily content]
  Future<List<Map<String, dynamic>>> _getDailyContent() async {
    // [Yüklenme hissi için kısa bekleme | Short delay for loading feel]
    await Future.delayed(const Duration(milliseconds: 300));
    
    final allItems = HistoryRepository.allHistoryItems;
    final persons = allItems.where((i) => i.category == "kisi").toList();
    final places = allItems.where((i) => i.category == "mekan").toList();
    final events = allItems.where((i) => i.category == "savas" || i.category == "gelenek").toList();
    final civilizations = allItems.where((i) => i.category == "medeniyet").toList();
    
    // [Güne özel sabit içerik algoritması | Day-specific deterministic algorithm]
    final now = HistoryService.getNow(_isInScreenshotMode);
    final int seed = now.year * 10000 + now.month * 100 + now.day;
    final random = math.Random(seed);
    
    // [1. Ayet (Quran Package) - Verse]
    final locale = EasyLocalization.of(context)?.locale.languageCode ?? 'tr';
    final int surahNum = (seed % 114) + 1;
    final int totalVerses = quran.getVerseCount(surahNum);
    final int ayahNum = (seed % totalVerses) + 1;

    // [Dinamik Meal Seçimi - Dynamic Translation Selection]
    String meal;
    if (locale == 'en') {
      meal = quran.getVerseTranslation(surahNum, ayahNum, translation: quran.Translation.enSaheeh);
    } else if (locale == 'ar') {
      meal = quran.getVerse(surahNum, ayahNum); // [Arapça için orijinal metin - Original text for Arabic]
    } else {
      meal = quran.getVerseTranslation(surahNum, ayahNum, translation: quran.Translation.trSaheeh);
    }

    
    // [2. Hadis & Dua (Spiritual Database) - Prophetic Tradition & Prayer]
    final hadisler = ManeviyatRehberiScreen.database.where((i) => i.category == 'Hadisler').toList();
    final dualar = ManeviyatRehberiScreen.database.where((i) => i.category == 'Dualar').toList();
    
    final person = persons.isNotEmpty ? persons[random.nextInt(persons.length)] : null;
    final place = places.isNotEmpty ? places[random.nextInt(places.length)] : null;
    final event = events.isNotEmpty ? events[random.nextInt(events.length)] : null;
    final civ = civilizations.isNotEmpty ? civilizations[random.nextInt(civilizations.length)] : null;
    final hadis = hadisler.isNotEmpty ? hadisler[random.nextInt(hadisler.length)] : null;
    final dua = dualar.isNotEmpty ? dualar[random.nextInt(dualar.length)] : null;


    // [Özel Gün Kontrolü - Special Day Check]
    final hijri = HijriCalendar.fromDate(now);
    Map<String, dynamic>? specialDayCard;
    if (hijri.hMonth == 9) {
      specialDayCard = {
        "type": "SpecialDay",
        "title": "Ramazan-ı Şerif",
        "content": "On bir ayın sultanı Ramazan ayındayız. Bu ayın bereketi üzerinize olsun.",
        "source": "Mübarek Ay",
        "icon": PhosphorIcons.moonStars(),
      };
    }

    return [
      if (specialDayCard != null) specialDayCard,
      {
        "type": "Ayet",
        "title": "Günün Ayeti",
        "content": meal,
        "source": "${quran.getSurahNameTurkish(surahNum)}, $ayahNum",
        "surah": surahNum,
        "ayah": ayahNum,
        "icon": PhosphorIcons.bookBookmark(),
      },

      if (hadis != null) {
        "type": "Hadis",
        "title": "Günün Hadisi",
        "content": hadis.content,
        "source": hadis.title,
        "item": hadis,
        "icon": PhosphorIcons.sparkle(),
      },
      if (dua != null) {
        "type": "Dua",
        "title": "Günün Duası",
        "content": dua.content,
        "source": dua.title,
        "item": dua,
        "icon": PhosphorIcons.handsPraying(),
      },
      if (person != null) {
        "type": "Şahsiyet",
        "title": "Günün Şahsiyeti",
        "content": person.name,
        "subtitle": person.shortDescription,
        "id": person.id,
        "item": person,
        "icon": PhosphorIcons.userFocus(),
      },
      if (event != null) {
        "type": "Olay",
        "title": "Günün Olayı",
        "content": event.name,
        "subtitle": event.shortDescription,
        "id": event.id,
        "item": event,
        "icon": PhosphorIcons.shield(),
      },
      if (place != null) {
        "type": "Mekan",
        "title": "Günün Mekanı",
        "content": place.name,
        "subtitle": place.shortDescription,
        "id": place.id,
        "item": place,
        "icon": PhosphorIcons.castleTurret(),
      },
      if (civ != null) {
        "type": "Medeniyet",
        "title": "Günün Medeniyeti",
        "content": civ.name,
        "subtitle": civ.shortDescription,
        "id": civ.id,
        "item": civ,
        "icon": PhosphorIcons.bank(),
      },
    ];
  }

  @override
  void dispose() {
    HistoryService.updates.removeListener(_onServiceUpdate);
    _timer?.cancel(); // [Zamanlayıcıyı iptet - Cancel timer]
    _specialTimer?.cancel(); // [Özel sayacı temizle - Clear special timer]
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadScreenshotMode() async {
    final active = await HistoryService.isScreenshotMode();
    if (mounted) setState(() => _isInScreenshotMode = active);
  }

  Future<void> _loadFastingMode() async {
    final active = await HistoryService.isFastingModeActive();
    if (mounted) setState(() => _isFastingModeActive = active);
  }

  void _onServiceUpdate() {
    _loadScreenshotMode().then((_) {
      _loadFastingMode().then((_) {
        _fetchRealPrayerTimes();
        setState(() {
          _dailyContentFuture = _getDailyContent();
        });
      });
    });
  }

  Future<void> _fetchRealPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final country = prefs.getString('selected_country') ?? _currentLocation.ulke;
    final city = prefs.getString('selected_city') ?? _currentLocation.sehir;

    if (mounted) {
      await context.read<PrayerTimeProvider>().fetchData(city, country);
    }
  }

  void _processNextPrayer(PrayerTimeModel data) {
    final now = HistoryService.getNow(_isInScreenshotMode);
    final times = [data.imsak, data.gunes, data.ogle, data.ikindi, data.aksam, data.yatsi];
    
    DateTime? nextTarget;
    String nextName = "Vakit";
    int nextIdx = 0;

    for (int i = 0; i < times.length; i++) {
      List<String> parts = times[i].split(':');
      DateTime time = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
      
      if (time.isAfter(now)) {
        nextTarget = time;
        nextName = PrayerTimeModel.prayerNames[i];
        nextIdx = i;
        break;
      }
    }

    if (nextTarget == null) {
      List<String> parts = times[0].split(':');
      nextTarget = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1])).add(const Duration(days: 1));
      nextName = "İmsak";
      nextIdx = 0;
    }

    if (mounted) {
      setState(() { 
        _currentPrayerTimes = data;
        _nextPrayerName = _prayerNameMap[nextName] ?? nextName;
        _nextPrayerIndex = nextIdx;
        _updateSpecialTimer(); 
      });
    }
    
    _startTimer(nextTarget);
  }

  // [Zamanlayıcı Motoru - Timer Engine]
  void _startTimer(DateTime targetTime) {
    _timer?.cancel(); // [Eski sayacı temizle - Clear old timer]
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      // [Zaman Dilimi Zekası: Cihaz saatini değil, şehrin gerçek saatini al | Timezone Intelligence]
      final String? savedTimezone = _currentPrayerTimes?.timezone;
      DateTime now;
      
      try {
        if (savedTimezone != null) {
          now = tz.TZDateTime.now(tz.getLocation(savedTimezone));
        } else {
          now = HistoryService.getNow(_isInScreenshotMode);
        }
      } catch (e) {
        now = HistoryService.getNow(_isInScreenshotMode);
      }
      
      // [Zamanı Dondur Kontrolü - Freeze Time Check]
      final isStopped = await HistoryService.isStopTimeActive();
      if (isStopped) {
        if (mounted) {
          setState(() {
            _countdownText = "00:18:19"; // Sabit test değeri - Fixed test value
            _specialTime = "00:18:19";
          });
        }
        return;
      }

      // [Ana Sayaç Güncelleme - Main Timer Update]
      final difference = targetTime.difference(now);
      if (difference.isNegative) {
        if (mounted) {
          setState(() {
            _countdownText = "00:00:00";
            timer.cancel();
            _fetchRealPrayerTimes();
          });
        }
      } else {
        _countdownText = _formatDuration(difference);
      }

      if (mounted) setState(() {}); // [Tüm sayacı tazele - Refresh all timers]
    });
  }

  // [Hatasız İftar-Sahur Sayacı Döngüsü - Error-Free Iftar-Sahur Timer Loop]
  Future<void> _updateSpecialTimer() async {
    _specialTimer?.cancel();

    _specialTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      
      final String? savedTimezone = _currentPrayerTimes?.timezone;
      DateTime now;
      try {
        if (savedTimezone != null) {
          now = tz.TZDateTime.now(tz.getLocation(savedTimezone));
        } else {
          now = HistoryService.getNow(_isInScreenshotMode);
        }
      } catch (e) {
        now = HistoryService.getNow(_isInScreenshotMode);
      }

      if (_currentPrayerTimes == null) return; // Tomorrow prayer times removed for simplification from Aladhan implementation requirements.

      DateTime imsakBugun = _parseSpecialTime(_currentPrayerTimes!.imsak, false);
      DateTime aksamBugun = _parseSpecialTime(_currentPrayerTimes!.aksam, false);
      DateTime imsakYarin = _parseSpecialTime(_currentPrayerTimes!.imsak, true); // Fallback to today+1 for imsak yarin if not present in simplified provider


      DateTime target;
      
      // [Akıllı Karar Mekanizması - Smart Decision Logic]
      if (now.isBefore(imsakBugun)) {
        target = imsakBugun;
        _specialLabel = "sahura";
      } else if (now.isBefore(aksamBugun)) {
        target = aksamBugun;
        _specialLabel = "iftara";
      } else {
        target = imsakYarin;
        _specialLabel = "sahura";
      }

      final diff = target.difference(now);
      if (mounted) {
        setState(() {
          _specialTime = "${diff.inHours.toString().padLeft(2, '0')}:${(diff.inMinutes % 60).toString().padLeft(2, '0')}:${(diff.inSeconds % 60).toString().padLeft(2, '0')}";
        });
      }
    });
  }

  // [İftar/Sahur İçin Vakit Ayrıştırıcı - Time Parser for Iftar/Sahur]
  DateTime _parseSpecialTime(String timeStr, bool isTomorrow) {
    final now = HistoryService.getNow(_isInScreenshotMode);
    final p = timeStr.split(':');
    DateTime d = DateTime(now.year, now.month, now.day, int.parse(p[0]), int.parse(p[1]));
    return isTomorrow ? d.add(const Duration(days: 1)) : d;
  }


  // [Süreyi formatlar - Formats duration: HH:mm:ss]
  String _formatDuration(Duration d) {
    String h = d.inHours.toString().padLeft(2, '0');
    String m = (d.inMinutes % 60).toString().padLeft(2, '0');
    String s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  // [Son okunan ayet verilerini hafızadan oku - Load last read verse from memory]
  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        lastReadSurah = prefs.getInt('last_read_surah') ?? 1;
        lastReadAyah = prefs.getInt('last_read_ayah') ?? 1;
        lastReadSurahName = prefs.getString('last_read_surah_name') ?? 'Fatiha';
        hasHatimPlan = prefs.getBool('has_hatim_plan') ?? false;
      });
    }
  }

  // Namaz vakitlerini yükle - Load prayer times
  Future<void> _loadPrayerTimes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final country = prefs.getString('selected_country') ?? _currentLocation.ulke;
      final city = prefs.getString('selected_city') ?? _currentLocation.sehir;

      if (mounted) {
        context.read<PrayerTimeProvider>().fetchData(city, country);
      }
    } catch (e) {
      debugPrint('LoadPrayerTimes error: $e');
    }
  }


  Future<void> _getLocationWithGPS() async {
    setState(() => _isGettingLocation = true);
    try {
      // [GPS'ten ham konumu al - Get raw GPS]
      final loc = await LocationService.getCurrentLocation().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException("Konum alınamadı");
        },
      );
      
      if (loc != null && mounted) {
        setState(() {
          _currentLocation = loc;
          // [Kritik: Şehir değişimini hemen yansıtmak zorundayız]
        });
        _fetchRealPrayerTimes(); // [Yeni konum için vakitleri anında çek]
      } else {
        throw Exception("Konum bulunamadı");
      }
    } catch (e) {
      if (mounted) {
        // [Zula Konum (B Planı) - Fail-safe Location]
        setState(() {
          _currentLocation = LocationModel(
            sehir: "İstanbul",
            ulke: "Türkiye",
            bolge: "",
          );
        });
        _loadPrayerTimes();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Konum alınamadı, Ankara baz alınıyor."),
            backgroundColor: Colors.orangeAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }




  @override
  Widget build(BuildContext context) {
    final prayerProvider = context.watch<PrayerTimeProvider>();
    final prayerTimes = prayerProvider.prayerTimes;
    
    // [Vakit Değişimi Hesaplaması - Check for next target if data changed]
    if (prayerTimes != null) {
      _processNextPrayer(prayerTimes);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // [Mor header için beyaz ikonlar - White icons for purple header]
        statusBarBrightness: Brightness.dark,    // [iOS: Beyaz ikonlar - White icons]
      ),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.only(
            bottom: 100,
          ), // [Alt barın altından geçmesi için boşluk - Spacing for bottom bar]
          children: [
            _buildPurpleIsland(),
            _buildPrayerTimesGrid(),
                
            // [Ana Menü Başlığı - Main Menu Header]
            
            // 1. Günün İncileri (Carousel)
            _buildDailyCarousel(),

            // 2. Lale Bahçesi (Özel Kart)
            _buildFeatureActionCard(
              title: "Lale Bahçesi",
              subtitle: "İyilik ve Güzelliklerin Merkezi",
              icon: PhosphorIcons.flower(),
              color: Colors.pink,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LaleBahcesiScreen())),
            ),

            // 3. Tarih Kubbesi (Kart)
            _buildFeatureActionCard(
              title: "Tarihin Kubbesi",
              subtitle: "Geçmişin İzinde Bir Yolculuk",
              icon: PhosphorIcons.clockCounterClockwise(),
              color: Colors.brown,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TarihinKubbesiScreen())),
            ),

            // 4. Zikirmatik (Kart)
            _buildFeatureActionCard(
              title: "Zikirmatik",
              subtitle: "Kalbin Huzur Bulduğu Anlar",
              icon: PhosphorIcons.fingerprint(),
              color: Colors.teal,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ZikirmatikScreen())),
            ),

            const SizedBox(height: 20),
            
            // [Dinamik Hatim Panosu - Dynamic Hatim Dashboard]
            ValueListenableBuilder<HatimData>(
              valueListenable: globalHatimState,
              builder: (context, hatimData, _) {
                if (hatimData.activePlan == null || hatimData.activePlan!.isEmpty) {
                  return const SizedBox.shrink();
                }
                return _buildHatimTrackingCard(
                  surahNum: hatimData.readCuz,
                  ayahNum: hatimData.readAyet,
                  surahName: hatimData.activePlan!,
                );
              },
            ),

            // [Asil Ramazan Temalı İftar/Sahur Kartı - Noble Ramazan-Themed Iftar/Sahur Card]
            if (_isFastingModeActive || HijriCalendar.fromDate(HistoryService.getNow(_isInScreenshotMode)).hMonth == 9)
            RamadanCustomCard(
              label: _specialLabel,
              time: _specialTime,
            ),
            
            // [Destek Ol Kartı - Support Card]
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Builder(
                builder: (context) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F2937) : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0xFF4B0082).withValues(alpha: 0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(PhosphorIcons.heart(PhosphorIconsStyle.fill), color: const Color(0xFF4B0082), size: 40),
                        const SizedBox(height: 16),
                        Text(
                          "Kubbe'yi Destekleyin",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4B0082),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Bu yolculukta bize destek olmak ister misiniz? Gelişime katkıda bulunmak için tıkla.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                title: Text("Kubbe'ye Destek Ol", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                                content: const Text("Kubbe'nin inşasına katkıda bulunmak ve yeni özellikleri desteklemek için yakında ödeme altyapımız eklenecektir. İlginiz için teşekkür ederiz."),
                                actions: [
                                  _buildPacketAction(onPressed: () => Navigator.pop(context), title: "Kapat"),
                                ],
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4B0082).withValues(alpha: 0.1),
                              foregroundColor: const Color(0xFF4B0082),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text("Destek Ol", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // [Yerel Saat Kartı - Local Time Card]
            _buildLocalTimeCard(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // [Kapat butonu için küçük yardımcı - Small helper for close button]
  Widget _buildPacketAction({required VoidCallback onPressed, required String title}) {
    return TextButton(onPressed: onPressed, child: Text(title));
  }

  String _getGreeting() {
    final hour = HistoryService.getNow(_isInScreenshotMode).hour;
    
    // [Öncelikli Gece Selamlaması: 03:00 - 05:00]
    if (hour >= 3 && hour < 5) return 'Gecenin sessizliğinde uyananlara selam olsun...';

    final List<String> greetings;
    if (hour >= 5 && hour < 12) {
      greetings = ['Günaydın', 'Hayırlı Sabahlar', 'Sabah-ı Şerifleriniz Hayrolsun', 'Nurlu Sabahlar', 'Gününüz Bereketli Olsun'];
    } else if (hour >= 12 && hour < 17) {
      greetings = ['Tünaydın', 'Hayırlı Günler', 'Gününüz Aydın Olsun', 'Vaktiniz Nur Olsun', 'Bereketli Günler'];
    } else if (hour >= 17 && hour < 21) {
      greetings = ['İyi Akşamlar', 'Hayırlı Akşamlar', 'Akşam-ı Şerifler Hayrolsun', 'Huzurlu Akşamlar'];
    } else {
      greetings = ['İyi Geceler', 'Hayırlı Geceler', 'Geceniz Mübarek Olsun', 'Huzurlu Geceler', 'Allah Rahatlık Versin'];
    }
    return greetings[HistoryService.getNow(_isInScreenshotMode).day % greetings.length];
  }

  Widget _buildPurpleIsland() {
    final String greeting = _getGreeting();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 16, 24, 32),
      decoration: BoxDecoration(
        color: const Color(0xFF4B0082),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // [ÜST SATIR: Konum ve Ayarlar - TOP ROW: Location and Settings]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sol Üst: Konum Barı (Dinamik Genişlik)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const LocationSelectionScreen())
                      );
                      if (result != null && result is LocationModel && mounted) {
                        setState(() => _currentLocation = result);
                        _fetchRealPrayerTimes();
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(PhosphorIcons.mapPin(PhosphorIconsStyle.fill), color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "${_currentLocation.sehir}, ${_currentLocation.ulke}",
                            style: GoogleFonts.outfit(
                              color: Colors.white, 
                              fontWeight: FontWeight.bold, 
                              fontSize: 16
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down_rounded, 
                            color: Colors.white.withValues(alpha: 0.6), 
                            size: 20
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Otomatik konum butonu
                  IconButton(
                    onPressed: _isGettingLocation ? null : _getLocationWithGPS,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: _isGettingLocation 
                      ? const SizedBox(
                          width: 20, 
                          height: 20, 
                          child: PulsingLoader(size: 10, color: Colors.white)
                        )
                      : const Icon(Icons.my_location, color: Colors.white, size: 20),
                  ),
                ],
              ),

              // Sağ Üst: Aksiyonlar (Mikrofon ve Ayarlar)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
                    iconSize: 24,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(PhosphorIcons.gear(), color: Colors.white),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // [ORTA ÜST: Selamlama - CENTER TOP: Greeting]
          Text(
            greeting,
            style: GoogleFonts.outfit(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),

          const SizedBox(height: 20),

          // [ALT BÖLÜM: Takvim ve Sayaç (Simetrik) - BOTTOM SECTION: Calendar and Timer (Symmetric)]
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Sol: Takvim (Sağa Hizalı)
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TakvimScreen())),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('dd MMMM', 'tr').format(HistoryService.getNow(_isInScreenshotMode)),
                        style: GoogleFonts.outfit(
                          color: Colors.white, 
                          fontSize: 22, 
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        _currentPrayerTimes?.hicriTarih.split(',')[0] ?? "...",
                        style: GoogleFonts.outfit(
                          color: Colors.white.withValues(alpha: 0.6), 
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ORTA: Nefes Alan Ayırıcı
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.1, end: 0.5),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                builder: (context, opacity, child) {
                  return Container(
                    width: 1,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white.withValues(alpha: opacity),
                  );
                },
              ),

              // Sağ: Sayaç (Vakit Yukarıda, Rakam Aşağıda)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nextPrayerName.toLocaleUpperCase('tr'),
                      style: GoogleFonts.outfit(
                        color: Colors.white.withValues(alpha: 0.7), 
                        fontSize: 16, 
                        fontWeight: FontWeight.w700, 
                        letterSpacing: 1.2
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _countdownText.substring(0, 5),
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, height: 1.1),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _countdownText.substring(5),
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.5), 
                            fontSize: 16, 
                            fontWeight: FontWeight.w600,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // [Yıldız Parçacıkları - Star Particles]

  Widget _buildPrayerTimesGrid() {
    if (_currentPrayerTimes == null) return const SizedBox.shrink();
    final times = [
      {'label': 'İmsak', 'time': _currentPrayerTimes!.imsak, 'icon': PhosphorIcons.sunHorizon()},
      {'label': 'Güneş', 'time': _currentPrayerTimes!.gunes, 'icon': PhosphorIcons.sun()},
      {'label': 'Öğle', 'time': _currentPrayerTimes!.ogle, 'icon': PhosphorIcons.sunDim()},
      {'label': 'İkindi', 'time': _currentPrayerTimes!.ikindi, 'icon': PhosphorIcons.cloudSun()},
      {'label': 'Akşam', 'time': _currentPrayerTimes!.aksam, 'icon': PhosphorIcons.moonStars()},
      {'label': 'Yatsı', 'time': _currentPrayerTimes!.yatsi, 'icon': PhosphorIcons.moon()},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              _buildPrayerCard(times[0], 0),
              const SizedBox(width: 8),
              _buildPrayerCard(times[1], 1),
              const SizedBox(width: 8),
              _buildPrayerCard(times[2], 2),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildPrayerCard(times[3], 3),
              const SizedBox(width: 8),
              _buildPrayerCard(times[4], 4),
              const SizedBox(width: 8),
              _buildPrayerCard(times[5], 5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(Map<String, dynamic> data, int index) {
    final bool isNext = index == _nextPrayerIndex;
    final primaryColor = const Color(0xFF4B0082);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isNext ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              data['label'] as String,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                color: isNext ? Colors.white.withValues(alpha: 0.8) : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Icon(
              data['icon'] as IconData,
              size: 20,
              color: isNext ? Colors.white : primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              data['time'] as String,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isNext ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF2D3436))),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(PhosphorIcons.caretRight(), color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }







  // [Sadeleştirilmiş Ana Ekran Hatim Kartı - Simplified Home Screen Hatim Card]
  Widget _buildHatimTrackingCard({
    required int surahNum,
    required int ayahNum,
    required String surahName,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B0082).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    PhosphorIcons.bookOpen(),
                    color: const Color(0xFF4B0082),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting().toLocaleUpperCase('tr'),
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4B0082),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kaldığın Yer: $surahName',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Ayet: $ayahNum',
                        style: GoogleFonts.poppins( // [Ayet sayısı için Poppins | Poppins for ayah count]
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4B0082).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahReadingScreen(
                        surahNumber: surahNum,
                        surahName: surahName,
                        arabicName: surahName, // [Arapça isim yedeği - Arabic fallback]
                        englishName: surahName,
                        verses: const [],
                        verseCount: 30,
                      ),
                    ),
                  );
                },
                icon: Icon(PhosphorIcons.play()),
                label: const Text('Okumaya Devam Et'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B0082),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [Yeni: Günün İncileri Carousel Sistemi | New Daily Pearls Carousel System]
  Widget _buildDailyCarousel() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _dailyContentFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              height: 220,
             child: Center(child: PulsingLoader()),
            ),
          );
        }

        final cards = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text(
                "Günün İncileri",
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ),
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                itemCount: cards.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.hasContentDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.08)).clamp(0.9, 1.0);
                      }
                      return Transform.scale(
                        scale: value,
                        child: DailyPearlCard(
                          data: card,
                          onRefresh: () => setState(() {
                            _dailyContentFuture = _getDailyContent();
                          }),
                          onTap: () => _handleCardRouting(card),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(cards.length, (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 12 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == index ? const Color(0xFF4B0082) : Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              )),
            ),
          ],
        );
      },
    );
  }

  // [Kart Yönlendirme Mantığı - Card Routing Logic]
  void _handleCardRouting(Map<String, dynamic> data) {
    if (data['type'] == 'Ayet') {
      final int surahNum = data['surah'] ?? 2;
      final int ayahNum = data['ayah'] ?? 1;
      final surahInfo = _getSurahMetadata(surahNum);
      
      Navigator.push(context, MaterialPageRoute(builder: (context) => SurahReadingScreen(
        surahNumber: surahNum,
        surahName: surahInfo['name'] ?? "Bakara",
        arabicName: surahInfo['arabic'] ?? "البقرة",
        englishName: surahInfo['english'] ?? "Al-Baqarah",
        verses: const [],
        verseCount: surahInfo['count'] ?? 286,
        initialAyah: ayahNum, // [Tam olarak bu ayete git - Go exactly to this ayah]
      )));
    } else if (data['type'] == 'Dua' || data['type'] == 'Hadis') {

       final item = data['item'] as ManeviyatItem;
       Navigator.push(context, MaterialPageRoute(builder: (context) => ManeviyatDetailScreen(
         item: item,
         isCompleted: false,
         onComplete: () {},
       )));
    } else if (data['item'] != null && data['item'] is HistoryItem) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetailScreen(item: data['item'])));
    }
  }

// [Removed old card builder]


  Widget _buildLocalTimeCard() {
    final String? savedTimezone = _currentPrayerTimes?.timezone;
    if (savedTimezone == null) return const SizedBox.shrink();

    // [Smart Hiding Logic]
    try {
      final deviceTz = tz.local.name;
      if (savedTimezone == deviceTz) return const SizedBox.shrink();
    } catch (_) {}

    String localTimeStr = "--:--";
    
    try {
      final nowInTz = tz.TZDateTime.now(tz.getLocation(savedTimezone));
      localTimeStr = DateFormat('HH:mm').format(nowInTz);
    } catch (e) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4B0082), Color(0xFF191970)], // Mor - Gece Mavisi Geçişi
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16), // [Premium M3 Radius]
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4B0082).withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(PhosphorIcons.clock(PhosphorIconsStyle.fill), color: Colors.white, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentLocation.sehir,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    "Yerel Saat",
                    style: GoogleFonts.inter(
                      fontSize: 13, 
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              localTimeStr,
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [Sure Metadata Yardımcısı: 114 Sure için temel veriler - Surah Metadata Helper: Basic data for 114 surahs]

  Map<String, dynamic> _getSurahMetadata(int number) {
    // [Not: Tam liste veritabanında var ama hızlı erişim için mini-map - Note: Full list is in DB but mini-map for quick access]
    final Map<int, Map<String, dynamic>> meta = {
      1: {'name': 'Fatiha', 'arabic': 'الفاتحة', 'english': 'Al-Fatiha', 'count': 7},
      2: {'name': 'Bakara', 'arabic': 'البقرة', 'english': 'Al-Baqarah', 'count': 286},
      3: {'name': 'Âl-i İmrân', 'arabic': 'آل عمران', 'english': 'Ali \'Imran', 'count': 200},
      4: {'name': 'Nisâ', 'arabic': 'النساء', 'english': 'An-Nisa', 'count': 176},
      // ... Diğerleri varsayılan olarak döner veya servis çağırmalıdır - Others default or should call service
    };
    return meta[number] ?? {'name': 'Kuran', 'arabic': 'القرآن', 'english': 'Quran', 'count': 0};
  }
}
// [Yıldızlar Çizici - Star Painter]
class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final random = math.Random(42);
    for (int i = 0; i < 20; i++) {
      final offset = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      final radius = random.nextDouble() * 1.5 + 0.5;
      final opacity = random.nextDouble() * 0.3 + 0.1;
      canvas.drawCircle(offset, radius, paint..color = Colors.white.withValues(alpha: opacity));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
