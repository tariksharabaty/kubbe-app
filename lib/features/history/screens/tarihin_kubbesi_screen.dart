import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:kubbe_app/features/history/screens/history_detail_screen.dart'; 
import '../../../core/widgets/custom_loading_animation.dart';
import '../data/history_repository.dart'; 
import 'dart:math' as math; 
import 'package:flutter/services.dart'; 
import '../../../core/services/history_service.dart';
import 'package:share_plus/share_plus.dart';

// [Tarihin Kubbesi - Medeniyet Yolculuğu Ekranı]
class TarihinKubbesiScreen extends StatefulWidget {
  const TarihinKubbesiScreen({super.key});

  @override
  State<TarihinKubbesiScreen> createState() => _TarihinKubbesiScreenState();
}

class _TarihinKubbesiScreenState extends State<TarihinKubbesiScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _diceController;
  List<HistoryItem> _shuffledFeaturedItems = []; // [Rastgele Öne Çıkanlar - Random Featured Items]
  List<HistoryItem> _filteredItems = []; 

  @override
  void initState() {
    super.initState();
    _diceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    HistoryService.updates.addListener(_onServiceUpdate);
    _loadHistoryData();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    HistoryService.updates.removeListener(_onServiceUpdate);
    _diceController.dispose();
    super.dispose();
  }

  // [Veri Yükleme İşlemi - Data Loading Process]
  Future<void> _loadHistoryData() async {
    await HistoryRepository.loadData();
    
    // [Günün tarihini tohum (seed) olarak kullanarak rastgele 10 içerik seç - Pick 10 random items using today's day as seed]
    final allItems = HistoryRepository.allHistoryItems;
    if (allItems.isNotEmpty) {
      final featuredPool = allItems.where((item) => item.isFeatured).toList();
      final pool = featuredPool.isNotEmpty ? featuredPool : allItems;
      
      // Seeded shuffle: Her kullanıcı o gün aynı listeyi görsün
      final random = math.Random(DateTime.now().day);
      _shuffledFeaturedItems = List<HistoryItem>.from(pool)..shuffle(random);
      
      if (_shuffledFeaturedItems.length > 10) {
        _shuffledFeaturedItems = _shuffledFeaturedItems.take(10).toList();
      }
    }

    if (mounted) {
      setState(() {
        _filteredItems = List.from(allItems);
        _isLoading = false;
      });
    }
  }


  // [Kâşif Modu Rastgele Şahsiyet - Explorer Mode Random Personality]
  void _openRandomPersonality() async {
    final items = HistoryRepository.allHistoryItems;
    if (items.isEmpty) return;
    
    // Yönlendirmeden önce zar animasyonunu oynat
    _diceController.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    final randomItem = items[math.Random().nextInt(items.length)];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryDetailScreen(item: randomItem)),
    );
  }

  // [Hızlı Etkileşim Menüsü - Fast Interaction Menu]
  void _showQuickActions(BuildContext context, HistoryItem item) {
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      showDragHandle: false, // [Handle Silindi - Handle Deleted]
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name,
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(PhosphorIcons.shareNetwork(), color: const Color(0xFF4B0082)),
              title: Text("Hızlı Paylaş", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                Share.share("${item.name}\n\n${item.shortDescription}\n\nKubbe Uygulaması");
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color parchmentBeige = Color(0xFFFDF5E6); 
    const Color deepPurple = Color(0xFF4B0082); 
    const Color nameColor = Color(0xFF1A1A1A); 

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: parchmentBeige,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomLoadingAnimation(color: Color(0xFF4B0082)),
              SizedBox(height: 16),
              Text(
                "Tarih Sayfaları Açılıyor...",
                style: TextStyle(fontFamily: 'Outfit', color: deepPurple, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: parchmentBeige,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // [Üst Başlık ve Arama - App Bar & Search]
            SliverAppBar(
              floating: true,
              backgroundColor: parchmentBeige,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Tarihin Kubbesi",
                style: GoogleFonts.outfit(
                  color: deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.casino_outlined, color: deepPurple),
                  onPressed: _openRandomPersonality,
                ),
                const SizedBox(width: 8),
              ],
            ),

            // [Grid Listesi - Grid List]
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _filteredItems[index];
                    return _buildMasonryCard(context, item, nameColor, deepPurple);
                  },
                  childCount: _filteredItems.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }


  // [Dinamik Staggered Kart (Kategoriye göre yükseklik)]
  Widget _buildMasonryCard(BuildContext context, HistoryItem item, Color nameColor, Color deepPurple) {
    // [Kişiler ince, Mekanlar ve Medeniyetler karemsi, Gelenekler uzun]
    double imageHeight = 140; 
    if (item.category == "Mekan") {
      imageHeight = 180;
    } else if (item.category == "Medeniyet") {
      imageHeight = 200;
    } else if (item.category == "Gelenek") {
      imageHeight = 160;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HistoryDetailScreen(item: item)),
          );
        },
        onLongPress: () => _showQuickActions(context, item),
        borderRadius: BorderRadius.circular(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // [Kart boyunu içeriğe uydurmak için]
          children: [
            Hero(
              tag: item.id,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
                child: _buildNetworkImage(item.safeImageUrl, deepPurple, imageHeight),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.shortenedName(15), 
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: nameColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.displaySubtitle, 
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String? url, Color deepPurple, double height) {
    if (url == null || url.isEmpty) {
      return _buildPlaceholder(deepPurple, height);
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      httpHeaders: const {'User-Agent': 'KubbeApp/1.0'},
      placeholder: (context, url) => Container(
        height: height,
        color: const Color(0xFFFDF5E6), 
        child: Center(
          child: CustomLoadingAnimation(color: deepPurple),
        ),
      ),
      errorWidget: (context, url, error) => _buildPlaceholder(deepPurple, height),
    );
  }

  Widget _buildPlaceholder(Color purple, double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: purple, 
      child: Center(
        child: Icon(PhosphorIcons.bank(), color: Colors.white, size: height * 0.4),
      ),
    );
  }
}
