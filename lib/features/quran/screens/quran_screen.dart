import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/quran_service.dart';
import '../../../core/state/history_state.dart';
import '../../../core/state/hatim_provider.dart';
import '../../../core/state/quran_settings_state.dart';
import '../widgets/quran_settings_ui.dart';
import '../widgets/premium_hatim_card.dart';
import '../widgets/surah_info_sheet.dart';
import 'surah_reading_screen.dart';
import '../../../core/widgets/voice_search_modal.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'; // [Yerel veri saklama - Local storage]
import '../../../core/widgets/custom_loading_animation.dart';
import '../../../core/state/hatim_state.dart'; // [Küresel hatim hafızası - Global hatim state]
import 'package:flutter/rendering.dart'; // [Kaydırma yönü tespiti için - For scroll direction detection]


class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFabExtended = true; // [FAB genişlik durumu - FAB extension state]

  // Dinamik sureler listesi - Dynamic surahs list
  late Future<List<QuranSurah>> _surahsFuture;
  List<QuranSurah>? _cachedSurahs; // [Önbelleğe alınmış sureler - Cached surahs]

  // [Son okunan verileri - Last read data artık globalHistoryState üzerinden takip ediliyor]

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController.addListener(() => setState(() {})); // Update FAB when tab changes
    _surahsFuture =
        QuranService.getAllSurahs(); // Kuran verilerini yükle - Load Quran data
    _surahsFuture.then((value) {
      if (mounted) {
        setState(() => _cachedSurahs = value);
      }
    });

    _loadLastRead(); // [Son okunanı yükle - Load last read]
  }


  // [Son okunan verilerini hafızadan oku - Load last read data from memory]
  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      // [Küresel geçmişi belleğe al - Load global history to memory]
      globalHistoryState.value = HistoryData(
        surahNumber: prefs.getInt('last_read_surah') ?? 1,
        ayahNumber: prefs.getInt('last_read_ayah') ?? 1,
        surahName: prefs.getString('last_read_surah_name') ?? 'Fatiha',
        pageNumber: prefs.getInt('last_read_page') ?? 1,
      );

      // [Küresel hatim verisini yükle - Load global hatim data]
      globalHatimState.value = HatimData(
        activePlan: prefs.getString('hatim_plan_type') != null ? (prefs.getString('hatim_plan_type') == 'yillik' ? 'Yıllık Hatim' : 'Aylık Hatim') : null,
        readCuz: prefs.getInt('read_juz') ?? 0,
        readPage: prefs.getInt('read_pages') ?? 0,
        readAyet: prefs.getInt('read_ayahs') ?? 0,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // [Gelişmiş Arama Paneli (Arama Motoru) - Advanced Search Panel (Search Engine)]
  void _showAdvancedSearch(BuildContext context) {
    String searchQuery = "";
    final allSurahs = _cachedSurahs ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setPanelState) {
            // [Arama sorgusuna göre sureleri filtrele - Filter surahs by search query]
            final filteredSurahs = allSurahs.where((s) {
              final query = searchQuery.toLowerCase().trim();
              return s.name.toLowerCase().contains(query) ||
                  s.number.toString().contains(query);
            }).toList();

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                children: [
                  // [Modern Başlık ve TextField - Modern Title and TextField]
                  Text(
                    "Akıllı Arama",
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4B0082),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    autofocus: true,
                    onChanged: (val) {
                      setPanelState(() {
                        searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Sure adı veya numarası yazın...",
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF4B0082)),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.mic_rounded, color: Color(0xFF4B0082)),
                            onPressed: () => VoiceSearchModal.show(context),
                          ),
                          if (searchQuery.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear), 
                              onPressed: () => setPanelState(() => searchQuery = "")
                            ),
                        ],
                      ),
                      filled: true,
                      fillColor: Colors.grey.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      searchQuery.isEmpty ? "Hızlı Erişim" : "${filteredSurahs.length} sonuç bulundu",
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (searchQuery.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildQuickAccessBtn(context, "Yasin", 36),
                          _buildQuickAccessBtn(context, "Mülk", 67),
                          _buildQuickAccessBtn(context, "Nebe", 78),
                          _buildQuickAccessBtn(context, "Fetih", 48),
                          _buildQuickAccessBtn(context, "Vakıa", 56),
                          _buildQuickAccessBtn(context, "Kehf", 18),
                        ],
                      ),
                    ),

                  // [Arama Sonuçları Listesi - Search Results List]
                  Expanded(
                    child: filteredSurahs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  "Aradığınız sure bulunamadı",
                                  style: GoogleFonts.inter(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: filteredSurahs.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final surah = filteredSurahs[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF4B0082),
                                  radius: 18,
                                  child: Text(
                                    surah.number.toString(),
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  surah.name,
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  "${surah.verseCount} Ayet • ${surah.location}",
                                  style: GoogleFonts.inter(fontSize: 12),
                                ),
                                trailing: Text(
                                  surah.arabicName,
                                  style: GoogleFonts.amiri(fontSize: 20, color: const Color(0xFF4B0082)),
                                ),
                                onTap: () {
                                  Navigator.pop(context); // [Arama panelini kapat - Close search panel]
                                  
                                  // [Seçili sure sayfasına git - Navigate to selected surah page]
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SurahReadingScreen(
                                        surahName: surah.name,
                                        arabicName: surah.arabicName, // [Arama sonucundan Arapça isim - Arabic name from search result]
                                        surahNumber: surah.number,
                                        englishName: surah.name,
                                        verses: const [], // [Veriler iç sayfada yüklenecek - Data will be loaded inside]
                                        verseCount: surah.verseCount,
                                        isJuzMode: false,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickAccessBtn(BuildContext context, String name, int number) {
    return ActionChip(
      label: Text(name),
      labelStyle: GoogleFonts.outfit(fontSize: 13, color: const Color(0xFF4B0082), fontWeight: FontWeight.bold),
      backgroundColor: const Color(0xFF4B0082).withValues(alpha: 0.1),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahReadingScreen(
              surahName: name,
              arabicName: name,
              surahNumber: number,
              englishName: name,
              verses: const [],
              verseCount: 30,
            ),
          ),
        );
      },
    );
  }

  // [Hızlı Kuran Ayarları - Quick Quran Settings]
  void _showQuranSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuranSettingsPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFF4B0082);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: purple,
        elevation: 0,
        title: Text(
          'Kuran-ı Kerim',
          style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false, // [Sola yatık daha modern - Left aligned is more modern]
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.magnifyingGlass(), color: Colors.white),
            onPressed: () => _showAdvancedSearch(context),
          ),
          IconButton(
            icon: Icon(PhosphorIcons.gear(), color: Colors.white),
            onPressed: () => _showQuranSettings(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<HistoryData>(
        valueListenable: globalHistoryState,
        builder: (context, history, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: premiumQuranGradient, // [Asil gradyan - Premium gradient]
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              isExtended: _isFabExtended, // [Kaydırmaya duyarlı durum - Scroll reactive state]
              backgroundColor: Colors.transparent, // [Gradyanın görünmesi için - To show the gradient]
              elevation: 0,
              onPressed: () {
                // [Son kalınan yere git - Navigate to last read]
                // [Gerçek verileri depodan çek - Fetch real data from repository]
                final surahData = QuranService.getAllSurahsSync().firstWhere(
                  (s) => s.number == history.surahNumber,
                  orElse: () => QuranSurah(
                    number: history.surahNumber,
                    name: history.surahName,
                    arabicName: history.surahName,
                    englishName: history.surahName,
                    location: 'Mekke',
                    verseCount: 7,
                    verses: [],
                  ),
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahReadingScreen(
                      surahName: surahData.name,
                      arabicName: surahData.arabicName,
                      surahNumber: surahData.number,
                      englishName: surahData.englishName,
                      verses: const [],
                      verseCount: surahData.verseCount,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.history, color: Colors.white), // [Yeni ikon: Geçmiş - New icon: History]
              label: Text(
                _tabController.index == 0 
                    ? "${history.surahName}, ${history.ayahNumber}"
                    : _tabController.index == 1
                        ? "${globalHatimState.value.readCuz > 0 ? globalHatimState.value.readCuz : 1}. Cüz'den Devam Et"
                        : "Sayfa ${history.pageNumber}'ten Devam Et",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
      ),
      body: Column(
        children: [
          /* [Üst Arama Kısmı - Moved to AppBar] */
          // [Sekme Menüsü - Tab Menu]
          Container(
            color: purple,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
              tabs: const [
                Tab(text: 'Sureler'),
                Tab(text: 'Cüzler'),
                Tab(text: 'Sayfalar'),
              ],
            ),
          ),
          // [Sekme İçerikleri - Tab Contents]
          Expanded(
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.reverse) {
                  if (_isFabExtended) setState(() => _isFabExtended = false);
                } else if (notification.direction == ScrollDirection.forward) {
                  if (!_isFabExtended) setState(() => _isFabExtended = true);
                }
                return true;
              },
              child: TabBarView(
                controller: _tabController,
                children: [_buildSurahsTab(), _buildJuzsTab(), _buildPagesTab()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sureler sekmesi - Surahs tab
  Widget _buildSurahsTab() {
    return FutureBuilder<List<QuranSurah>>(
      future: _surahsFuture, // [Türkçe] - [English]
      builder: (context, snapshot) {
        // Kritik Durum Kontrolü - Critical State Check
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomLoadingAnimation(color: Color(0xFF4B0082)),
                const SizedBox(height: 16),
                Text(
                  "Kur'an-ı Kerim Yükleniyor...",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF4B0082),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Sure listesi yüklenemedi."));
        }

        // Başarılı yükleme - Successful load
        final surahs = snapshot.data!;
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Sureler listesi - Surahs list
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildSurahCard(context, surahs[index], index);
              }, childCount: surahs.length),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 140)),
          ],
        );
      },
    );
  }

  // [Tüm sureler için tek tip premium renk geçişi - Unified premium gradient for all surahs]
  static const premiumQuranGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4B0082), // Deep Indigo / Mor
      Color(0xFF3498DB), // Elegant Steel Light Blue / Açık Mavi
    ],
  );

  // Sure kartı - Surah card
  Widget _buildSurahCard(BuildContext context, QuranSurah surah, int index) {
    final surahNumber = surah.number;
    final surahName = surah.name;
    final arabicName = surah.arabicName.isNotEmpty ? surah.arabicName : surah.name;
    final verseCount = surah.verseCount;
    final location = surah.location;

    return Container(
      height: 110, // [Daha zarif ve kibar yükseklik - More elegant and refined height]
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: premiumQuranGradient, // [Tek tip premium gradyan - Unified premium gradient]
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurahReadingScreen(
                  surahName: surahName,
                  arabicName: arabicName,
                  surahNumber: surahNumber,
                  englishName: surahName,
                  verses: const [],
                  verseCount: verseCount,
                  isJuzMode: false,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              // [1. Arka Plan: Arapça Hat Sanatı - 1. Background: Arabic Calligraphy]
              Center(
                child: Text(
                  arabicName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: 42, // [Yüksekliğe göre boyut optimize edildi - Size optimized for new height]
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.0,
                  ),
                ),
              ),

              // [2. Sol Alt: Sure Numarası - 2. Bottom Left: Surah Number]
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    surahNumber.toString(),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // [3. Sağ Alt: Detay Bilgiler - 3. Bottom Right: Detailed Info]
              Positioned(
                bottom: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      surahName,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$verseCount Ayet • $location',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
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


  // [Cüzler sekmesi - Juzs tab: Sliver tabanlı modern kaydırma yapısı - Sliver-based modern scroll structure]
  Widget _buildJuzsTab() {
    return CustomScrollView(
      slivers: [
        // [1. En Üstte Premium Hatim Panosu - 1. Premium Hatim Board at the Top]
        const SliverToBoxAdapter(child: PremiumHatimCard()),
        
        // [Cüz Rehberi Butonu - Juz Guide Button]
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: InkWell(
              onTap: () {
                final lastJuz = globalHistoryState.value.pageNumber; 
                _showJuzInfoSheet(context, lastJuz > 0 && lastJuz <= 30 ? lastJuz : 1);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: premiumQuranGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4B0082).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.auto_stories, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      "Cüz Rehberi ve Sırları",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                  ],
                ),
              ),
            ),
          ),
        ),

        // [2. Cüz Izgarası (Sliver) - 2. Juz Grid (Sliver)]
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverJuzGrid(),
        ),
        
        const SliverToBoxAdapter(child: SizedBox(height: 140)),
      ],
    );
  }

  void _showJuzInfoSheet(BuildContext context, int juzNumber) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SurahInfoSheet(
          readingScope: ReadingScope.juz,
          surahNumber: 1, // Focus on juzNumber
          surahName: "$juzNumber. Cüz",
          arabicName: "الجزء $juzNumber",
          verseCount: 20,
          isMakki: true,
          juzNumber: juzNumber,
          pageNumber: 1,
        );
      },
    );
  }

  // Sayfalar sekmesi - Pages tab
  Widget _buildPagesTab() {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        // [3. Sadeleştirilmiş Sayfa Izgarası (5 Sütun) - 3. Simplified Page Grid (5 Columns)]
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // [En sade görünüm için 5 sütun - 5 columns for cleanest look]
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final pageNumber = index + 1;
                return InkWell(
                  onTap: () {
                    // [Artık metin ekranı yerine Mushaf ekranına git - Now go to Mushaf screen instead of text screen]
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahReadingScreen(
                          surahNumber: pageNumber > 114 ? 1 : pageNumber, // Mocking surah loading
                          surahName: "$pageNumber. Sayfa",
                          arabicName: "الصفحة $pageNumber",
                          englishName: "Page $pageNumber",
                          verses: const [],
                          verseCount: 15,
                          isJuzMode: true,
                          initialReadingMode: 'mushaf',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF4B0082).withValues(alpha: 0.15),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // [Çok Hafif Düz Daire Arka Plan - Very Subtle Flat Circle Background]
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF4B0082).withOpacity(0.06), // Çok hafif mor arka plan - Very light purple background
                          ),
                        ),
                        Text(
                          pageNumber.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF4B0082),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 604,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 140)), // [FAB üzerine binmesin diye - To prevent FAB overlap]
      ],
    );
  }
}

// [Cüz Izgarasını Sliver yapısına dönüştür - Convert Juz Grid to Sliver structure]
class SliverJuzGrid extends StatelessWidget {
  const SliverJuzGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HatimProvider>(
      builder: (context, hatimProvider, _) {
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final juzNumber = index + 1;
              final isCompleted = hatimProvider.isJuzCompleted(juzNumber);
              
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCompleted 
                        ? const Color(0xFF4B0082) 
                        : const Color(0xFF4B0082).withOpacity(0.15),
                    width: isCompleted ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahReadingScreen(
                          surahName: "$juzNumber. Cüz",
                          arabicName: "الجزء $juzNumber",
                          surahNumber: juzNumber,
                          englishName: "$juzNumber. Cüz",
                          verses: const [],
                          verseCount: 20,
                          isJuzMode: true,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isCompleted)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            Icons.check_circle,
                            color: Color(0xFF4B0082),
                            size: 20,
                          ),
                        ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            juzNumber.toString(),
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4B0082),
                            ),
                          ),
                          Text(
                            "Cüz",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF4B0082).withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: 30,
          ),
        );
      },
    );
  }
}
