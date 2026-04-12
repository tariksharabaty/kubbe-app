import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/custom_loading_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import '../../core/services/favorite_service.dart';
import '../../core/services/history_service.dart';
import '../../features/history/data/history_repository.dart';
import '../../features/history/screens/history_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool _isLoading = true;
  List<FavoriteItem> _favorites = [];
  List<HistoryItem> _visitedHistory = [];
  List<HistoryItem> _toVisitHistory = [];

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    final favList = await FavoriteService.getFavorites();
    final visitedIds = await HistoryService.getVisitedIds();
    final toVisitIds = await HistoryService.getToVisitIds();

    final allHistory = HistoryRepository.allHistoryItems;
    final visitedHistory = allHistory.where((item) => visitedIds.contains(item.id)).toList();
    final toVisitHistory = allHistory.where((item) => toVisitIds.contains(item.id)).toList();

    if (mounted) {
      setState(() {
        _favorites = favList;
        _visitedHistory = visitedHistory;
        _toVisitHistory = toVisitHistory;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CustomLoadingAnimation(color: Color(0xFF4B0082)))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // [Seyyah İstatistik Paneli | Traveler Stats Panel]
                SliverToBoxAdapter(child: _buildSeyyahHeader()),

                // [Son Okuduklarım | Recently Read]
                if (_visitedHistory.isNotEmpty) ...[
                  SliverToBoxAdapter(child: _buildSectionTitle("Son Okuduklarım")),
                  SliverToBoxAdapter(child: _buildRecentlyReadList()),
                ],

                // [Koleksiyonum | My Collection]
                SliverToBoxAdapter(child: _buildSectionTitle("Koleksiyonum")),
                if (_favorites.isNotEmpty || _toVisitHistory.isNotEmpty) 
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // Combine favorites and toVisitHistory for vertical view
                          final totalItems = [..._favorites.map((e) => _buildCollectionItemFromFav(e)), ..._toVisitHistory.map((e) => _buildCollectionItemFromHistory(e))];
                          return totalItems[index];
                        },
                        childCount: _favorites.length + _toVisitHistory.length,
                      ),
                    ),
                  )
                else 
                  SliverToBoxAdapter(child: _buildEmptyState()),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 20, 
          fontWeight: FontWeight.bold, 
          color: const Color(0xFF4B0082),
        ),
      ),
    );
  }

  // [Hünkâr Paneli Özeti: Seyyah İstatistik Paneli | Traveler Stats Panel]
  Widget _buildSeyyahHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF4B0082),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hoş geldin Seyyah,",
                style: GoogleFonts.outfit(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white,
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(PhosphorIcons.user(), color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withValues(alpha: 0.8)),
              children: [
                const TextSpan(text: "Bugüne kadar "),
                TextSpan(
                  text: "12", // [Test statik değer | Static test value]
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const TextSpan(text: " Şahsiyet, "),
                TextSpan(
                  text: "4", // [Test statik değer | Static test value]
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const TextSpan(text: " Medeniyet okudun."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyReadList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: const BouncingScrollPhysics(),
        itemCount: _visitedHistory.length,
        itemBuilder: (context, index) {
          final item = _visitedHistory[index];
          return _buildRecentItemCard(item);
        },
      ),
    );
  }

  Widget _buildRecentItemCard(HistoryItem item) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: InkWell(
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetailScreen(item: item)));
          _loadLibrary();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: item.safeImageUrl != null 
                  ? CachedNetworkImage(
                      imageUrl: item.safeImageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFF4B0082),
                        child: Center(child: Icon(PhosphorIcons.bank(), color: Colors.white, size: 24)),
                      ),
                    )
                  : Container(
                      color: const Color(0xFF4B0082),
                      child: Center(child: Icon(PhosphorIcons.bank(), color: Colors.white, size: 24)),
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            Text(
              item.category,
              style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionItemFromHistory(HistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 60,
            height: 60,
            color: const Color(0xFF4B0082).withValues(alpha: 0.05),
            child: item.safeImageUrl != null 
              ? CachedNetworkImage(
                  imageUrl: item.safeImageUrl!, 
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(PhosphorIcons.bank(), color: Colors.white),
                )
              : Icon(PhosphorIcons.bank(), color: Colors.white),
          ),
        ),
        title: Text(item.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        subtitle: Text("${item.category} • ${item.location}", style: GoogleFonts.inter(fontSize: 12)),
        trailing: Icon(PhosphorIcons.caretRight()),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetailScreen(item: item))),
      ),
    );
  }

  Widget _buildCollectionItemFromFav(FavoriteItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(PhosphorIcons.bookmarkSimple(PhosphorIconsStyle.fill), color: Colors.green),
        ),
        title: Text(item.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        subtitle: Text("Ayet & Dua", style: GoogleFonts.inter(fontSize: 12)),
        trailing: Icon(PhosphorIcons.caretRight()),
        onTap: () {
          // Quran navigation logic...
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Lottie.network(
            'https://lottie.host/6b3c1d93-6b3a-442c-8097-4fbca502759e/X6p4z2l4bH.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 24),
          Text(
            "Kütüphaneniz Boş",
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            "Beğendiğiniz eserleri ve ayetleri burada bulabilirsiniz.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
