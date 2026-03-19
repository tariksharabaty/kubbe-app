// TR: KUBBE V4 History Screen - V1'den miras alındı
// EN: KUBBE V4 History Screen - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Instagram/Pinterest tarzı dikey bir akış kur
// EN: Create Instagram/Pinterest style vertical flow
// TR: Kartlar: 32dp radius, 'AsyncImage' (Coil/CachedNetworkImage) desteği, üzerinde 'Outfit Bold' ile yazılmış isimler
// EN: Cards: 32dp radius, 'AsyncImage' (Coil/CachedNetworkImage) support, names written with 'Outfit Bold'
// TR: Her kart tıklandığında V1'deki 'card_detay_ekrani.dart'ın modern bir versiyonuna (V4 Detail Screen) gitsin
// EN: When each card is clicked, go to a modern version of V1's 'card_detay_ekrani.dart' (V4 Detail Screen)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../models/history_figure.dart';
import '../data/history_repository.dart';

/// TR: KUBBE V4 History Screen Sınıfı
/// EN: KUBBE V4 History Screen Class
/// TR: Instagram/Pinterest tarzı dikey akış ile tarihi şahsiyetler
/// EN: Historical figures with Instagram/Pinterest style vertical flow
/// TR: V1'deki 'card_detay_ekrani.dart' mantığı modernize edildi
/// EN: V1's 'card_detay_ekrani.dart' logic modernized
/// TR: 32dp radius kartlar ve Outfit Bold başlıklar
/// EN: 32dp radius cards and Outfit Bold headings
/// TR: Sy-OS design language ile modernize edildi
/// EN: Modernized with Sy-OS design language
class HistoryScreen extends ConsumerStatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

// TR: History Screen State
// EN: History Screen State
class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  // TR: Repository instance
  // EN: Repository instance
  final HistoryRepository _repository = HistoryRepository();

  // TR: Scroll controller
  // EN: Scroll controller
  final ScrollController _scrollController = ScrollController();

  // TR: Arama controller
  // EN: Search controller
  final TextEditingController _searchController = TextEditingController();

  // TR: Arama durumu
  // EN: Search state
  bool _isSearching = false;

  // TR: Seçili kategori
  // EN: Selected category
  HistoryCategory? _selectedCategory;

  // TR: Yükleniyor durumu
  // EN: Loading state
  bool _isLoading = false;

  // TR: Şahsiyet listesi
  // EN: Figures list
  List<HistoryFigure> _figures = [];

  @override
  void initState() {
    super.initState();
    _loadFigures();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // TR: Şahsiyetleri yükle
  // EN: Load figures
  void _loadFigures() {
    setState(() {
      _isLoading = true;
    });

    // TR: Verileri yükle
    // EN: Load data
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _figures = _repository.getAllFigures();
        _isLoading = false;
      });
    });
  }

  // TR: Arama yap
  // EN: Search
  void _searchFigures(String query) {
    setState(() {
      if (query.isEmpty) {
        _figures = _selectedCategory != null
            ? _repository.getFiguresByCategory(_selectedCategory!)
            : _repository.getAllFigures();
      } else {
        _figures = _repository.searchFigures(query);
      }
    });
  }

  // TR: Kategori filtrele
  // EN: Filter by category
  void _filterByCategory(HistoryCategory? category) {
    setState(() {
      _selectedCategory = category;
      if (category == null) {
        _figures = _repository.getAllFigures();
      } else {
        _figures = _repository.getFiguresByCategory(category);
      }
    });
  }

  // TR: Detay sayfasına git
  // EN: Navigate to detail page
  void _navigateToDetail(HistoryFigure figure) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HistoryDetailScreen(figure: figure),
      ),
    );
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
          'Tarih Kubbeleri',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        // TR: Arama butonu
        // EN: Search button
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _loadFigures();
                }
              });
            },
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
        // TR: Arama alanı
        // EN: Search field
        bottom: _isSearching
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Tarih ara...',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    onChanged: _searchFigures,
                  ),
                ),
              )
            : null,
      ),

      // TR: Body
      // EN: Body
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // TR: Kategori filtreleri
                // EN: Category filters
                _buildCategoryFilters(),

                // TR: Şahsiyet listesi
                // EN: Figures list
                Expanded(
                  child: _buildFiguresList(),
                ),
              ],
            ),
    );
  }

  // TR: Kategori filtreleri oluştur
  // EN: Build category filters
  Widget _buildCategoryFilters() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          // TR: Tümü butonu
          // EN: All button
          _buildCategoryChip(
            label: 'Tümü',
            isSelected: _selectedCategory == null,
            onTap: () => _filterByCategory(null),
          ),

          // TR: Kategori butonları
          // EN: Category buttons
          ...HistoryCategory.values.map((category) {
            return _buildCategoryChip(
              label: _getCategoryDisplayName(category),
              isSelected: _selectedCategory == category,
              onTap: () => _filterByCategory(category),
            );
          }),
        ],
      ),
    );
  }

  // TR: Kategori chip'i oluştur
  // EN: Build category chip
  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            // TR: 32dp radius - Sy-OS standartı
            // EN: 32dp radius - Sy-OS standard
            borderRadius: BorderRadius.circular(32.0),
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      KubbeTheme.kubbeIndigo,
                      KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                    ],
                  )
                : null,
            // TR: Kenar
            // EN: Border
            border: isSelected
                ? null
                : Border.all(
                    color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                    width: 1,
                  ),
            // TR: Renk
            // EN: Color
            color: isSelected ? null : Colors.transparent,
          ),
          // TR: Metin
          // EN: Text
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : KubbeTheme.kubbeIndigo,
            ),
          ),
        ),
      ),
    );
  }

  // TR: Şahsiyet listesi oluştur
  // EN: Build figures list
  Widget _buildFiguresList() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio:
            0.65, // TR: Dikey kartlar için // EN: For vertical cards
      ),
      itemCount: _figures.length,
      itemBuilder: (context, index) {
        return _buildFigureCard(_figures[index]);
      },
    );
  }

  // TR: Şahsiyet kartı oluştur
  // EN: Build figure card
  Widget _buildFigureCard(HistoryFigure figure) {
    return GestureDetector(
      onTap: () => _navigateToDetail(figure),
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
              Colors.white,
              Colors.white.withValues(alpha: 0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
        // TR: Kart içeriği
        // EN: Card content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TR: Görsel
            // EN: Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // TR: Üst köşeler yuvarlak
                  // EN: Top corners rounded
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: LinearGradient(
                    colors: [
                      KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
                      KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                // TR: Placeholder görsel
                // EN: Placeholder image
                child: Stack(
                  children: [
                    // TR: Görsel
                    // EN: Image
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        // TR: Üst köşeler yuvarlak
                        // EN: Top corners rounded
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0),
                        ),
                        // TR: Görsel
                        // EN: Image
                        image: DecorationImage(
                          image: AssetImage(figure.hasValidImageUrl
                              ? figure.imageUrl
                              : figure.placeholderImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // TR: Önem derecesi rozeti
                    // EN: Importance badge
                    if (figure.importanceLevel >= 3)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            // TR: Yuvarlak
                            // EN: Circle
                            shape: BoxShape.circle,
                            // TR: Gradient arka plan
                            // EN: Gradient background
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber,
                                Colors.orange,
                              ],
                            ),
                          ),
                          // TR: İkon
                          // EN: Icon
                          child: const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // TR: Metin içeriği
            // EN: Text content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TR: İsim - Outfit Bold
                    // EN: Name - Outfit Bold
                    Text(
                      figure.name,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: KubbeTheme.kubbeIndigo,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // TR: Boşluk
                    // EN: Spacer
                    const SizedBox(height: 4.0),

                    // TR: Dönem
                    // EN: Period
                    Text(
                      figure.period,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.withValues(alpha: 0.7),
                      ),
                    ),

                    // TR: Boşluk
                    // EN: Spacer
                    const SizedBox(height: 4.0),

                    // TR: Kısa özet
                    // EN: Short summary
                    Text(
                      figure.cardSummary,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.withValues(alpha: 0.8),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // TR: Boşluk
                    // EN: Spacer
                    const Spacer(),

                    // TR: Kategori etiketi
                    // EN: Category tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
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
                      // TR: Kategori metni
                      // EN: Category text
                      child: Text(
                        figure.categoryDisplayName,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: KubbeTheme.kubbeIndigo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TR: Kategori display adı
  // EN: Category display name
  String _getCategoryDisplayName(HistoryCategory category) {
    switch (category) {
      case HistoryCategory.sultans:
        return 'Padişahlar';
      case HistoryCategory.scholars:
        return 'Alimler';
      case HistoryCategory.poets:
        return 'Şairler';
      case HistoryCategory.commanders:
        return 'Komutanlar';
      case HistoryCategory.artists:
        return 'Sanatkarlar';
      case HistoryCategory.scientists:
        return 'Bilim İnsanları';
      case HistoryCategory.other:
        return 'Diğer';
    }
  }
}

/// TR: KUBBE V4 History Detail Screen - V1'den miras alındı
/// EN: KUBBE V4 History Detail Screen - Inherited from V1
/// TR: V1'deki 'card_detay_ekrani.dart' mantığı modernize edildi
/// EN: V1's 'card_detay_ekrani.dart' logic modernized
/// TR: Detaylı şahsiyet bilgileri
/// EN: Detailed figure information
/// TR: Sy-OS design language ile modernize edildi
/// EN: Modernized with Sy-OS design language
class HistoryDetailScreen extends StatelessWidget {
  // TR: Şahsiyet
  // EN: Figure
  final HistoryFigure figure;

  // TR: Constructor
  // EN: Constructor
  const HistoryDetailScreen({
    super.key,
    required this.figure,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          figure.name,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),

      // TR: Body
      // EN: Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TR: Görsel
            // EN: Image
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                // TR: 32dp radius - Sy-OS standartı
                // EN: 32dp radius - Sy-OS standard
                borderRadius: BorderRadius.circular(32.0),
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
                    KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
                  ],
                ),
              ),
              // TR: Görsel
              // EN: Image
              child: Container(
                decoration: BoxDecoration(
                  // TR: 32dp radius
                  // EN: 32dp radius
                  borderRadius: BorderRadius.circular(32.0),
                  // TR: Görsel
                  // EN: Image
                  image: DecorationImage(
                    image: AssetImage(figure.hasValidImageUrl
                        ? figure.imageUrl
                        : figure.placeholderImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 20.0),

            // TR: Başlık ve dönem
            // EN: Title and period
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                // TR: 32dp radius - Sy-OS standartı
                // EN: 32dp radius - Sy-OS standard
                borderRadius: BorderRadius.circular(32.0),
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: [
                    KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
                    KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
                  ],
                ),
              ),
              // TR: İçerik
              // EN: Content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TR: İsim - Outfit Bold
                  // EN: Name - Outfit Bold
                  Text(
                    figure.name,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: KubbeTheme.kubbeIndigo,
                    ),
                  ),

                  // TR: Unvan
                  // EN: Title
                  Text(
                    figure.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                    ),
                  ),

                  // TR: Dönem
                  // EN: Period
                  Text(
                    figure.period,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 20.0),

            // TR: Açıklama
            // EN: Description
            Container(
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
              // TR: İçerik
              // EN: Content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TR: Başlık
                  // EN: Title
                  Text(
                    'Hakkında',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: KubbeTheme.kubbeIndigo,
                    ),
                  ),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(height: 12.0),

                  // TR: Açıklama metni
                  // EN: Description text
                  Text(
                    figure.description,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 20.0),

            // TR: Başarılar
            // EN: Achievements
            if (figure.achievements.isNotEmpty)
              Container(
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
                // TR: İçerik
                // EN: Content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TR: Başlık
                    // EN: Title
                    Text(
                      'Başarıları',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KubbeTheme.kubbeIndigo,
                      ),
                    ),

                    // TR: Boşluk
                    // EN: Spacer
                    const SizedBox(height: 12.0),

                    // TR: Başarı listesi
                    // EN: Achievement list
                    ...figure.achievements.map((achievement) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TR: Madde imi
                            // EN: Bullet point
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                // TR: Yuvarlak
                                // EN: Circle
                                shape: BoxShape.circle,
                                // TR: Gradient arka plan
                                // EN: Gradient background
                                gradient: LinearGradient(
                                  colors: [
                                    KubbeTheme.kubbeIndigo,
                                    KubbeTheme.kubbeIndigo
                                        .withValues(alpha: 0.8),
                                  ],
                                ),
                              ),
                            ),

                            // TR: Boşluk
                            // EN: Spacer
                            const SizedBox(width: 12.0),

                            // TR: Başarı metni
                            // EN: Achievement text
                            Expanded(
                              child: Text(
                                achievement,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

            // TR: Boşluk
            // EN: Spacer
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
