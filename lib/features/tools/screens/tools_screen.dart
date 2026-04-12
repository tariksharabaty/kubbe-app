import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:kubbe_app/features/tools/screens/esma_husna_screen.dart';
import 'package:kubbe_app/features/home/screens/takvim_screen.dart';
import 'package:kubbe_app/features/tools/screens/dini_gunler_screen.dart';
import 'package:kubbe_app/features/tools/screens/zekatmatik_screen.dart';
import 'package:kubbe_app/features/lale_bahcesi/screens/lale_bahcesi_screen.dart';
import '../../zikirmatik/screens/zikirmatik_screen.dart';
import '../../history/data/history_repository.dart';
import '../../history/screens/tarihin_kubbesi_screen.dart';
import '../../../core/services/history_service.dart';
import '../../../core/widgets/custom_loading_animation.dart';
import './collection_detail_screen.dart';
import './all_collections_screen.dart';
import './developer_settings_screen.dart';
import './maneviyat_rehberi_screen.dart';
import './dream_interpretation_screen.dart';
import '../../mosque/screens/nearby_mosques_screen.dart';
import './kaza_namaz_screen.dart';


class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _visualCollections = []; // [Görsel Koleksiyon Verileri]
  int _devTapCount = 0; // [Geliştirici modu sayacı]

  @override
  void initState() {
    super.initState();
    _loadData();
    HistoryService.updates.addListener(_loadData);
  }

  @override
  void dispose() {
    HistoryService.updates.removeListener(_loadData);
    super.dispose();
  }

  Future<void> _loadData() async {
    // [Koleksiyon verilerini hazırla | Prepare collection data]
    final customLists = await HistoryService.getCustomLists();
      List<Map<String, dynamic>> visualCollections = [];
      for (String name in ["Kütüphanem", "Okuduklarım", ...customLists]) {
        final itemIds = await HistoryService.getItemsInCollection(name);
        List<HistoryItem> items = [];
        
        for (String id in itemIds) {
          // [Repoda ara - Search in repo]
          final repoItem = HistoryRepository.allHistoryItems.where((i) => i.id == id).firstOrNull;
          if (repoItem != null) {
            items.add(repoItem);
          } else {
            // [Metadata'dan çek - Fetch from metadata]
            final meta = await HistoryService.getMetadata(id);
            if (meta != null) {
              items.add(HistoryItem(
                id: id,
                name: meta['title'] ?? "İsimsiz",
                category: "isaret", // [Özel kategori - Custom category]
                date: "",
                location: "",
                respectMessage: "",
                shortDescription: meta['subtitle'] ?? "",
                fullDescription: meta['subtitle'] ?? "",
                imageUrl: null,
                quote: "",
                famousQuotes: [],
                legacyWorks: [],
                tombLocation: "",
              ));
            }
          }
        }
        
        String? coverImage;
        if (items.isNotEmpty) {
          coverImage = items.first.safeImageUrl;
        }

        visualCollections.add({
          'name': name,
          'count': items.length,
          'image': coverImage,
          'items': items,
        });
      }

    if (mounted) {
      setState(() {
        _visualCollections = visualCollections;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: Center(child: CustomLoadingAnimation()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // [1. BÖLÜM: Profil (Hünkâr Paneli) | Section 1: Profile]
          SliverToBoxAdapter(child: _buildSeyyahProfileHeader()),

          // [2. BÖLÜM: Koleksiyonlarım (Playlist Kartları) | Section 2: Collections]
          SliverToBoxAdapter(child: _buildCollectionHeader()),
          SliverToBoxAdapter(child: _buildVisualCollections()),

          // [3. BÖLÜM: Kubbe Araçları (Grid) | Section 3: Tools Grid]
          SliverToBoxAdapter(child: _buildSectionTitle("Kubbe Araçları")),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: _buildToolCards(context),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
          
          // [Sürüm Bilgisi ve Gizli Giriş | Version Info & Hidden Entry]
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _devTapCount++;
                      if (_devTapCount >= 7) {
                        _devTapCount = 0;
                        HapticFeedback.heavyImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DeveloperSettingsScreen()),
                        );
                      }
                    });
                  },
                  child: Text(
                    "Uygulama Sürümü: 1.0.0",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddListDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Yeni Liste Oluştur", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Liste Adı (Örn: Kudüs Gezim)",
            hintStyle: GoogleFonts.inter(fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Vazgeç", style: GoogleFonts.inter(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await HistoryService.createCustomList(controller.text);
                if (!context.mounted) return;
                Navigator.pop(context);
                _loadData(); // Veriyi yenile
              }
            },
            child: Text("Oluştur", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF4B0082))),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCollection(String name) {
    if (name == "Kütüphanem" || name == "Okuduklarım") return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Listeyi Sil", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Text("'$name' listesini ve içindekileri silmek istediğinize emin misiniz?", style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Vazgeç", style: GoogleFonts.inter(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await HistoryService.deleteCustomList(name);
              if (!context.mounted) return;
              Navigator.pop(context);
              _loadData();
            },
            child: const Text("Sil", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 16, 12),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AllCollectionsScreen())),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Koleksiyonlarım",
                  style: GoogleFonts.outfit(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: const Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  PhosphorIcons.caretRight(), 
                  color: const Color(0xFF2D3436), // Yazı ile aynı renk
                  size: 18
                ),
              ],
            ),
            IconButton(
              onPressed: _showAddListDialog,
              icon: Icon(PhosphorIcons.plusCircle(), color: const Color(0xFF4B0082), size: 26),
              tooltip: "Yeni Liste",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeyyahProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Merhaba",
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4B0082),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Kubbe'nin sonsuz deryasında keşfe devam et.",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 20, 
          fontWeight: FontWeight.bold, 
          color: const Color(0xFF2D3436),
        ),
      ),
    );
  }

  Widget _buildVisualCollections() {
    final double cardWidth = MediaQuery.of(context).size.width * 0.38; // [%38 Genişlik | 38% Width]
    final double cardHeight = cardWidth * 0.65; // [Yatay 16:9 Yakın | Landscape ~16:9]

    return SizedBox(
      height: cardHeight + 16, // Padding için ek alan
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        physics: const BouncingScrollPhysics(),
        itemCount: _visualCollections.length,
        itemBuilder: (context, index) {
          final collection = _visualCollections[index];
          return _buildPlaylistCard(collection);
        },
      ),
    );
  }

  Widget _buildPlaylistCard(Map<String, dynamic> collection) {
    final List<HistoryItem> items = collection['items'] ?? [];
    final String? coverImage = collection['image'];
    final double cardWidth = MediaQuery.of(context).size.width * 0.38;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CollectionDetailScreen(
                  collectionName: collection['name'],
                  items: items,
                ),
              ),
            );
          },
          onLongPress: () => _confirmDeleteCollection(collection['name']),
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Arka plan resmi veya desen
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: coverImage != null
                    ? CachedNetworkImage(
                        imageUrl: coverImage,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFF4B0082),
                          child: Icon(PhosphorIcons.bank(), color: Colors.white, size: 32),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF4B0082), Color(0xFF6A1B9A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(PhosphorIcons.bookmarks(), color: Colors.white30, size: 40),
                      ),
              ),
              // [Karartma ve Yazı | Overlay and Text]
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.6)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection['name'],
                      style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${collection['count']} Öğe",
                      style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.8), fontSize: 11),
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


  List<Widget> _buildToolCards(BuildContext context) {
    return [
      _buildToolCard(
        context: context,
        title: "Rüya Tabiri",
        subtitle: "AI ile rüya yorumlama",
        icon: PhosphorIcons.moonStars(),
        baseColor: const Color(0xFF4B0082),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DreamInterpretationScreen()));
        },
      ),
      _buildToolCard(
        context: context,
        title: "Maneviyat Rehberi",
        subtitle: "Ayet ve Hadislerden Dualar",
        icon: PhosphorIcons.handsPraying(),
        baseColor: const Color(0xFF4B0082),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ManeviyatRehberiScreen()));
        },
      ),
      _buildToolCard(
        context: context,
        title: "Tarihin Kubbesi",
        subtitle: "Medeniyet and Şahsiyetler",
        icon: PhosphorIcons.castleTurret(),
        baseColor: const Color(0xFF5D4037),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TarihinKubbesiScreen()));
        },
      ),
      _buildToolCard(
        context: context,
        title: "Zikirmatik",
        subtitle: "Dijital tesbih ve ibadet",
        icon: PhosphorIcons.fingerprint(),
        baseColor: const Color(0xFF9C27B0),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ZikirmatikScreen())),
      ),
      _buildToolCard(
        context: context,
        title: "Takvim",
        subtitle: "Vakitler ve Hatırlatıcılar",
        icon: PhosphorIcons.calendarBlank(),
        baseColor: const Color(0xFF03A9F4),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TakvimScreen())),
      ),
      _buildToolCard(
        context: context,
        title: "Esmâ-ül Hüsnâ",
        subtitle: "99 İsim ve anlamı",
        icon: PhosphorIcons.sparkle(),
        baseColor: const Color(0xFFFF9800),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EsmaHusnaScreen())),
      ),
      _buildToolCard(
        context: context,
        title: "Dini Günler",
        subtitle: "Mübarek günler ve geceler",
        icon: PhosphorIcons.calendarStar(),
        baseColor: const Color(0xFF4CAF50),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DiniGunlerScreen())),
      ),
      _buildToolCard(
        context: context,
        title: "Zekatmatik",
        subtitle: "Zekatını hesapla",
        icon: PhosphorIcons.calculator(),
        baseColor: const Color(0xFF795548),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ZekatmatikScreen())),
      ),
      _buildToolCard(
        context: context,
        title: "Yakındaki Camiler",
        subtitle: "Overpass API ile cami bul",
        icon: Icons.mosque_rounded,
        baseColor: const Color(0xFF4B0082),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NearbyMosquesScreen()));
        },
      ),
      _buildToolCard(
        context: context,
        title: "Lale Bahçesi",
        subtitle: "Namaz takibi ve ağaçlar",
        icon: PhosphorIcons.flower(),
        baseColor: const Color(0xFFE91E63),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LaleBahcesiScreen())),
      ),
      _buildToolCard(
        context: context,
        title: "Kaza Takibi",
        subtitle: "Namaz ve oruç borçları",
        icon: PhosphorIcons.clockCounterClockwise(),
        baseColor: const Color(0xFF4B0082),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const KazaNamazScreen()));
        },
      ),

    ];
  }

  Widget _buildToolCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color baseColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: baseColor.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: baseColor, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
