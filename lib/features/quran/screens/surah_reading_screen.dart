import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart'; // [ScrollDirection için - For ScrollDirection]

import '../../../core/widgets/custom_loading_animation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/favorite_service.dart';
import 'dart:async';
import '../../../core/services/quran_service.dart';
import 'package:kubbe_app/core/state/hatim_state.dart';
import '../../../core/services/islamic_audio_service.dart';
import '../../../core/state/history_state.dart';
import '../../../core/state/quran_settings_state.dart';
import '../../../core/state/hatim_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/quran_settings_ui.dart';
import '../widgets/surah_info_sheet.dart'; // [Premium Ayarlar Arayüzü]
import '../widgets/ayah_card.dart'; // [Ayet Kartı Bileşeni - Ayah Card Component]
import '../widgets/mushaf_view.dart'; // [Mushaf Görünümü Bileşeni]
import '../../../core/utils/collection_helper.dart'; // [Koleksiyon Yardımcı - Collection Helper]
import '../../music/widgets/global_audio_player_bar.dart'; // Ses barı bileşeni - Audio bar component



class SurahReadingScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final String arabicName; // [Arapça şık başlık için - For elegant Arabic title]
  final String englishName;
  final List<String> verses;
  final int verseCount;
  final String initialReadingMode;
  final bool isJuzMode;
  final int? initialAyah; // [Yeni: Başlangıç ayeti (Derin Linkleme için) - New: Initial ayah for deep linking]

  const SurahReadingScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.arabicName, 
    required this.englishName,
    required this.verses,
    required this.verseCount,
    this.initialReadingMode = 'ayet',
    this.isJuzMode = false,
    this.initialAyah,
  });

  @override
  State<SurahReadingScreen> createState() => _SurahReadingScreenState();
}

class _SurahReadingScreenState extends State<SurahReadingScreen> {
  // State variables
  List<QuranVerse> versesData = [];
  bool isLoading = true;
  bool showMeal = true;
  bool showLatin = false;
  String readingMode = 'ayet';
  double arabicFontSize = 28;
  double mealFontSize = 16;
  final ScrollController _scrollController = ScrollController(); // [Kaydırma kontrolcü - Scroll controller]
  bool _hasScrolledToInitial = false; // [Başlangıç ayetine kaydırıldı mı? - Scrolled to initial ayah?]
  String selectedArabicFont = 'Amiri Quran';
  bool isAddedToHatimTop = false;
  bool isFavorite = false;
  bool _isTransitioning = false; // [Geçiş durumu kontrolü - Transition state control]
  Timer? _scrollDebounceTimer;
  bool get hasActiveHatimPlan => globalHatimState.value.activePlan != null;
  int currentPlayIndex = -1;
  bool isAutoScrolling = false;
  ReadingScope? _lastScope;
  
  final ValueNotifier<double> _kineticSpeed = ValueNotifier(2.0);
  final ValueNotifier<bool> _isSliderVisible = ValueNotifier(false);
  Timer? _sliderHideTimer;

  bool isEzberMode = false;
  Timer? _autoScrollTimer;

  final List<GlobalKey> ayahKeys = [];
  StreamSubscription? _scrollSubscription;

  @override
  void initState() {
    super.initState();
    readingMode = widget.initialReadingMode;
    _loadData();
    _loadSettings();
    _checkFavorite();
    
    // [Servisten gelen kaydırma isteklerini dinle - Listen to scroll requests from service]
    _scrollSubscription = IslamicAudioService().scrollRequests.listen((ayahIndex) {
      _scrollToAyah(ayahIndex);
    });

    _scrollController.addListener(_onScroll);
    
    // [Ayarlar değişimini dinle - Listen for settings changes]
    _lastScope = context.read<QuranSettingsState>().readingScope;
    context.read<QuranSettingsState>().addListener(_onSettingsChange);
  }

  void _onSettingsChange() {
    if (!mounted) return;
    final newScope = context.read<QuranSettingsState>().readingScope;
    if (_lastScope != null && _lastScope != newScope) {
      // [Kapsam değiştiyse veriyi yeniden yükle - Reload data if scope changed]
      setState(() {
        isLoading = true;
        _loadData();
      });
    }
    _lastScope = newScope;
  }

  void _onScroll() {
    if (_scrollDebounceTimer?.isActive ?? false) _scrollDebounceTimer!.cancel();
    _scrollDebounceTimer = Timer(const Duration(seconds: 2), () {
      _saveCurrentVisibleAyah();
    });
  }

  void _saveCurrentVisibleAyah() {
    if (!mounted || versesData.isEmpty) return;
    
    if (readingMode == 'mushaf' || ayahKeys.isEmpty) {
      updateHistoryProgress(
        surahNumber: versesData.first.surahId,
        ayahNumber: versesData.first.number,
        surahName: widget.surahName,
        pageNumber: widget.isJuzMode ? widget.surahNumber : 1,
      );
      return;
    }
    
    for (int i = 0; i < ayahKeys.length; i++) {
      final key = ayahKeys[i];
      if (key.currentContext != null) {
        final renderBox = key.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          if (position.dy >= 0 && position.dy < MediaQuery.of(context).size.height / 2) {
             final visibleVerse = versesData[i];
             updateHistoryProgress(
               surahNumber: visibleVerse.surahId,
               ayahNumber: visibleVerse.number,
               surahName: widget.surahName, // [Cüz ismi veya Sure ismi - Juz/Surah name]
               pageNumber: widget.isJuzMode ? widget.surahNumber : 1,
             );
             // [Arka planda sessizce işaretle - Silent background mark]
             context.read<HatimProvider>().markAyahAsReadSilently(
               surahId: visibleVerse.surahId,
               ayahId: visibleVerse.number,
             );
             break;
          }
        }
      }
    }
  }

  void _scrollToAyah(int ayahIndex) {
    // Ayah Index 1-based geliyor - Ayah Index is 1-based
    final index = ayahIndex - 1;
    if (index >= 0 && index < ayahKeys.length) {
      final key = ayahKeys[index];
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.1, // Ekranın üst kısmına yakın hizala - Align near the top of the screen
        );
      }
    }
  }

  Future<void> _checkFavorite() async {
    final status = await FavoriteService.isFavorite(
      widget.surahNumber,
      'surah',
    );
    if (mounted) setState(() => isFavorite = status);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      arabicFontSize = prefs.getDouble('arabicFontSize') ?? 28;
      mealFontSize = prefs.getDouble('mealFontSize') ?? 16;
      showMeal = prefs.getBool('showMeal') ?? true;
      showLatin = prefs.getBool('showLatin') ?? false;
      selectedArabicFont =
          prefs.getString('selectedArabicFont') ?? 'Amiri Quran';
      _kineticSpeed.value = prefs.getDouble('auto_scroll_speed') ?? 2.0;
    });
  }

  void _saveKineticSpeed(double speed) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('auto_scroll_speed', speed);
    // [Küresel state'i de güncelle - Also update global state]
    QuranSettingsState().updateAutoScrollSpeed(speed);
  }

  void _wakeUpSlider() {
    if (!isAutoScrolling) return;
    _isSliderVisible.value = true;
    _sliderHideTimer?.cancel();
    _sliderHideTimer = Timer(const Duration(seconds: 3), () {
      _isSliderVisible.value = false;
    });
  }



  Future<void> _loadData() async {
    try {
      final quranService = QuranService();
      // [Ayarlar üzerinden güncel kapsamı al - Get current scope from settings]
      final settings = context.read<QuranSettingsState>();
      final bool isCurrentJuzMode = settings.readingScope == ReadingScope.juz;
      
      if (isCurrentJuzMode) {
        // [Cüz modunda tüm cüzü yükle - Load entire juz: juzNumber is encoded in surahNumber for this route]
        versesData = await quranService.getJuzVerses(widget.surahNumber);
      } else {
        // [Normal surah modunda tek sureyi yükle - Load single surah]
        final arabicData = await quranService.getSurahVerses(
          widget.surahNumber,
          isArabic: true,
        );
        final turkishData = await quranService.getSurahVerses(
          widget.surahNumber,
          isArabic: false,
          langCode: 'tr',
        );
        final latinData = await quranService.getSurahVerses(
          widget.surahNumber,
          isArabic: false,
          isLatin: true,
        );

        versesData = List.generate(arabicData.length, (i) {
          return QuranVerse(
            surahId: widget.surahNumber,
            number: i + 1,
            arabic: arabicData[i],
            turkish: i < turkishData.length ? turkishData[i] : '',
            transliteration: i < latinData.length ? latinData[i] : '',
            tafsir: null,
          );
        });
      }

      if (mounted) {
        setState(() {
          // [Kelimeleri asenkron yükle - Load words asynchronously]
          QuranService.fetchVerseWords(versesData.first.surahId).then((apiVerses) {
            if (mounted) {
              setState(() {
                for (int i = 0; i < versesData.length && i < apiVerses.length; i++) {
                  if (versesData[i].surahId != versesData.first.surahId) continue;
                  final wordList = apiVerses[i]['words'] as List?;
                  versesData[i] = QuranVerse(
                    surahId: versesData[i].surahId,
                    number: versesData[i].number,
                    arabic: versesData[i].arabic,
                    turkish: versesData[i].turkish,
                    transliteration: versesData[i].transliteration,
                    tafsir: versesData[i].tafsir,
                    words: wordList != null ? List<Map<String, dynamic>>.from(wordList) : null,
                  );
                }
              });
            }
          });

          ayahKeys.clear();
          ayahKeys.addAll(List.generate(
            versesData.length,
            (index) => GlobalKey(),
          ));
          isLoading = false;
        });

        // [Sayfa açıldığında veya mod değiştiğinde konumu ayarla - Sync position on load/change]
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // [Eğer dışarıdan spesifik bir ayet istendiyse önce ona bak - Priority for specified initialAyah]
          if (widget.initialAyah != null && !_hasScrolledToInitial) {
            // [Vurgulamayı aktifleştir - Activate highlight shadow]
            IslamicAudioService.instance.setCurrentAyah(widget.initialAyah);
            
            // [Ayet konumuna kaydır - Scroll to ayah position]
            Future.delayed(const Duration(milliseconds: 600), () {
              if (mounted && widget.initialAyah != null) {
                final int targetAyah = widget.initialAyah!;
                final int targetIndex = targetAyah - 1; // [1-based Ayah No -> 0-based Index]
                
                if (targetIndex >= 0 && targetIndex < ayahKeys.length) {
                  final key = ayahKeys[targetIndex];
                  if (key.currentContext != null) {
                    Scrollable.ensureVisible(
                      key.currentContext!,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      alignment: 0.1,
                    );
                  }
                } else {
                  _scrollToAyah(targetAyah);
                }
              }
            });



            _hasScrolledToInitial = true;
            return;
          }


          final history = globalHistoryState.value;
          // [Mevcut veri içinde son kalınan ayeti bul ve oraya atla - Find last read ayah and jump]
          int jumpIndex = -1;
          for (int i = 0; i < versesData.length; i++) {
            if (versesData[i].surahId == history.surahNumber && 
                versesData[i].number == history.ayahNumber) {
              jumpIndex = i;
              break;
            }
          }
          
          if (jumpIndex != -1) {
            _scrollToAyah(jumpIndex + 1); // 1-based index
          } else {
            _saveCurrentVisibleAyah();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }

  // [Sonraki sureye geçiş mantığı - Next Surah transition logic]
  Future<void> _handleNextSurahTransition() async {
    if (_isTransitioning || widget.surahNumber >= 114) return;

    setState(() => _isTransitioning = true);
    
    // [Premium titreşim geri bildirimi - Premium haptic feedback]
    HapticFeedback.lightImpact();

    try {
      // [Tüm sureleri getir ve sıradakini bul - Get all surahs and find the next one]
      final allSurahs = await QuranService.getAllSurahs();
      final nextSurah = allSurahs.firstWhere((s) => s.number == widget.surahNumber + 1);

      if (!mounted) return;

      // [Yarım saniye bekleyip geçiş yap - Wait half a second and transition]
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SurahReadingScreen(
              surahNumber: nextSurah.number,
              surahName: nextSurah.name,
              arabicName: nextSurah.arabicName,
              englishName: nextSurah.englishName,
              verses: const [],
              verseCount: nextSurah.verseCount,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isTransitioning = false);
    }
  }

  @override
  void dispose() {
    try {
      context.read<QuranSettingsState>().removeListener(_onSettingsChange);
    } catch (_) {}
    _scrollDebounceTimer?.cancel();
    _autoScrollTimer?.cancel();
    _sliderHideTimer?.cancel();
    _scrollSubscription?.cancel(); // [Aboneliği temizle - Clean up subscription]
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleAutoScroll() {
    setState(() {
      isAutoScrolling = !isAutoScrolling;
    });

    if (isAutoScrolling) {
      _startAutoScroll();
      _wakeUpSlider();
    } else {
      _autoScrollTimer?.cancel();
      _isSliderVisible.value = false;
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (!isAutoScrolling) return;

    // Uzun vadeli, pürüzsüz kaydırma için hız çarpanını ayarla - Set speed multiplier for long-term, smooth scrolling
    double speedVal = _kineticSpeed.value;
    if (speedVal < 0.25) speedVal = 0.25;

    // Pürüzsüzlük için intervali küçült, mesafeyi ayarla - Shrink interval for smoothness, adjust distance
    const int intervalMs = 16; // ~60 FPS
    final double step = (speedVal * intervalMs) / 100.0;

    _autoScrollTimer = Timer.periodic(
      const Duration(milliseconds: intervalMs),
      (timer) {
        if (_scrollController.hasClients) {
          double targetOffset = _scrollController.offset + step;
          if (targetOffset > _scrollController.position.maxScrollExtent) {
            targetOffset = _scrollController.position.maxScrollExtent;
            _toggleAutoScroll(); // Sonuna gelince durdur - Stop at end
          }
          _scrollController.jumpTo(targetOffset);
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final settings = context.watch<QuranSettingsState>();
    final isMushafLayout = settings.readingScope == ReadingScope.page;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isMushafLayout ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: isMushafLayout ? const Color(0xFFFFFFFF) : const Color(0xFFF4F0F9),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4B0082), // Purple
                  Color(0xFF3498DB), // Blue
                ],
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Hero(
            tag: 'reading-title',
            child: Material(
              color: Colors.transparent,
              child: Text(
                widget.isJuzMode ? "Cüz ${widget.surahNumber}" : widget.surahName, // [Dinamik Başlık - Dynamic Title]
                style: GoogleFonts.outfit(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.collections_bookmark, color: Colors.white),
              onPressed: () => _showCollectionSelector(context),
              tooltip: 'Koleksiyona Ekle',
            ),
            Consumer<HatimProvider>(
              builder: (context, hatimProvider, _) {
                if (hatimProvider.targetDate == null) return const SizedBox.shrink();
                return IconButton(
                  icon: Icon(
                    isAddedToHatimTop ? Icons.check_box : Icons.check_box_outline_blank, 
                    color: isAddedToHatimTop ? const Color(0xFFFFD700) : Colors.white,
                  ),
                  onPressed: () {
                    setState(() => isAddedToHatimTop = !isAddedToHatimTop);
                    _markSurahAsRead();
                  },
                  tooltip: 'Hatme Ekle (Tamamını)',
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomLoadingAnimation(color: Color(0xFF4B0082)),
                    const SizedBox(height: 16),
                    Text(
                      "Ayetler Hazırlanıyor...",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF4B0082),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!_isTransitioning &&
                      scrollInfo.metrics.pixels >
                          scrollInfo.metrics.maxScrollExtent + 60) {
                    _handleNextSurahTransition();
                    return true;
                  }
                  return false;
                },
                child: Stack(
                  children: [
                    SafeArea(
                      top: true,
                      bottom: false,
                      child: GestureDetector(
                        onTap: _wakeUpSlider,
                        onPanDown: (_) => _wakeUpSlider(),
                        behavior: HitTestBehavior.translucent,
                        child: isMushafLayout 
                          ? MushafView(initialPage: widget.isJuzMode ? widget.surahNumber : 1)
                          : CustomScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            if (!widget.isJuzMode &&
                                widget.surahNumber != 1 &&
                                widget.surahNumber != 9)
                              _buildBesmeleSection(),
                            SliverList(
                              delegate: SliverChildBuilderDelegate((context, index) {
                                return AyahCard(
                                  surahId: versesData[index].surahId,
                                  verse: versesData[index],
                                  verseNumber: versesData[index].number,
                                  index: index,
                                  isEzberMode: isEzberMode,
                                  ayahKey: ayahKeys[index],
                                );
                              }, childCount: versesData.length),
                            ),
                            if (widget.surahNumber < 114)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.keyboard_arrow_up_rounded,
                                          color: Color(0xFF4B0082),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _isTransitioning 
                                              ? 'Sonraki Sure Yükleniyor...' 
                                              : 'Sonraki Sureye Geçmek İçin Çekin',
                                          style: GoogleFonts.outfit(
                                            color: const Color(0xFF4B0082).withOpacity(0.6),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            const SliverToBoxAdapter(child: SizedBox(height: 150)), 
                          ],
                        ),
                      ),
                    ),
                    
                    if (isAutoScrolling)
                      Positioned(
                        right: 16,
                        bottom: 120,
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _isSliderVisible,
                          builder: (context, isVisible, _) {
                            return AnimatedOpacity(
                              opacity: isVisible ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: ValueListenableBuilder<double>(
                                valueListenable: _kineticSpeed,
                                builder: (context, speed, _) {
                                  return Container(
                                    height: 200,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: Colors.white,
                                          inactiveTrackColor: Colors.white24,
                                          thumbColor: Colors.white,
                                          trackHeight: 4,
                                        ),
                                        child: Slider(
                                          value: speed,
                                          min: 0.25,
                                          max: 10.0,
                                          divisions: 39, 
                                          onChanged: (val) {
                                            _kineticSpeed.value = val;
                                            _startAutoScroll();
                                            _wakeUpSlider();
                                          },
                                          onChangeEnd: (val) {
                                            _saveKineticSpeed(val);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            );
                          }
                        ),
                      ),
                    const GlobalAudioPlayerBar(), // [Ses barı artık en üstte - Audio bar is now on top]
                  ],
                ),
              ),
        bottomNavigationBar: _buildBottomBar(),
        endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.7,
          child: const SettingsContentWidget(),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Builder(
        builder: (innerContext) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomBarButton(
              Icons.info_outline,
              "Bilgi",
              onTap: () {
                _showSurahInfoSheet(context);
              },
            ),
            _buildBottomBarButton(
              isAutoScrolling
                  ? Icons.pause_circle_filled
                  : Icons.play_arrow_rounded,
              isAutoScrolling ? "Durdur" : "Kaydır",
              onTap: _toggleAutoScroll,
              iconColor: isAutoScrolling ? Colors.red : null,
            ),
            _buildBottomBarButton(
              Icons.play_circle_outline_rounded,
              "Dinle",
              iconColor: const Color(0xFF4B0082),
              onTap: () async {
                HapticFeedback.lightImpact();
                final settings = context.read<QuranSettingsState>();
                final audioService = IslamicAudioService();
                final finalUrl = await QuranService.fetchAudioUrl(settings.selectedReciterId, widget.surahNumber);
                
                if (finalUrl == null) {
                  if (innerContext.mounted) {
                    ScaffoldMessenger.of(innerContext).showSnackBar(
                      const SnackBar(content: Text('Ses dosyası bulunamadı.')),
                    );
                  }
                  return;
                }
                final track = AudioTrack(
                  id: 'quran_${widget.surahNumber}',
                  title: widget.surahName,
                  arabicName: widget.arabicName, // Full Arabic Name - Tam Arapça İsim
                  artist: settings.selectedReciterName, 
                  artwork: 'https://placehold.co/400x400/4B0082/FFFFFF/png?text=Quran',
                  category: 'Kuran',
                  imageUrl: 'asset:///assets/images/app_logo.png',
                  audioUrl: finalUrl,
                  isYouTube: false,
                  extras: {
                    'surah_id': widget.surahNumber,
                    'is_quran': true,
                    'reciter_id': settings.selectedReciterId,
                    'arabic_name': widget.arabicName, // Also pass via extras for safety - Güvenlik için eklere de ekle
                  },
                );
                
                await audioService.play(track);
                audioService.setUiState(AudioUiState.bar);
              },
            ),
            _buildBottomBarButton(
              isEzberMode ? Icons.visibility_off : Icons.school_outlined,
              "Ezber",
              onTap: () => setState(() => isEzberMode = !isEzberMode),
              iconColor: isEzberMode ? const Color(0xFF4B0082) : null,
            ),
            _buildBottomBarButton(
              Icons.settings,
              "Ayarlar",
              onTap: () {
                Scaffold.of(innerContext).openEndDrawer();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBesmeleSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFF4B0082).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  selectedArabicFont,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Rahmân ve Rahîm olan Allah\'ın adıyla',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSurahInfoSheet(BuildContext context) {
    final settings = context.read<QuranSettingsState>();
    
    // [Bulunulan Cüz ve Sayfayı belirle - Determine current Juz and Page]
    // Not: Gerçek veriye ulaşılamıyorsa varsayılan değerler kullanılır
    int currentJuz = (widget.surahNumber / 4).ceil(); // Basit bir eşleme örneği
    int currentPage = widget.surahNumber * 5; // Basit bir eşleme örneği

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SurahInfoSheet(
          readingScope: widget.isJuzMode ? ReadingScope.juz : settings.readingScope,
          juzNumber: widget.isJuzMode ? widget.surahNumber : currentJuz,
          surahNumber: widget.surahNumber,
          surahName: widget.surahName,
          arabicName: widget.arabicName,
          verseCount: widget.verseCount,
          isMakki: true,
          pageNumber: currentPage,
        );
      },
    );
  }

  void _showCollectionSelector(BuildContext context) {
    CollectionHelper.showCollectionSheet(
      context: context,
      itemId: 'surah_${widget.surahNumber}',
      title: widget.surahName,
      subtitle: widget.englishName,
    );
  }

  void _markSurahAsRead() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.surahName} hatminize eklendi."),
        backgroundColor: const Color(0xFF2ECC71),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildBottomBarButton(IconData icon, String label, {VoidCallback? onTap, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: iconColor ?? const Color(0xFF4B0082)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
