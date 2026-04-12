import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/history_service.dart';
import '../../history/data/history_repository.dart';
import '../../history/screens/history_detail_screen.dart';
import '../../quran/screens/surah_reading_screen.dart';
import '../../../core/services/favorite_service.dart';

// [Favoriler Ekranı - Favorites Screen]
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: const Color(0xFF4B0082),
          foregroundColor: Colors.white,
          title: Text(
            "Kütüphanem",
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorWeight: 3,
            isScrollable: true,
            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "Sureler"),
              Tab(text: "Ziyaret Ettiklerim"),
              Tab(text: "Ziyaret Edeceklerim"),
              Tab(text: "Dualar/Hadisler"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSurahFavorites(),
            _buildHistoryList(isVisited: true),
            _buildHistoryList(isVisited: false),
            _buildEmptyState(context, Icons.favorite_rounded, "Henüz favorilere eklenmiş bir içerik bulunmuyor."),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahFavorites() {
    return FutureBuilder<List<FavoriteItem>>(
      future: FavoriteService.getFavorites(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(context, Icons.book_rounded, "Henüz favorilere eklenmiş bir sure bulunmuyor.");
        }

        final surahs = snapshot.data!.where((f) => f.type == 'surah').toList();

        if (surahs.isEmpty) {
          return _buildEmptyState(context, Icons.book_rounded, "Henüz favorilere eklenmiş bir sure bulunmuyor.");
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            final fav = surahs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF4B0082),
                  child: Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
                ),
                title: Text(fav.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                subtitle: Text("${fav.surahNumber}. Sure"),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahReadingScreen(
                        surahNumber: fav.surahNumber ?? 1,
                        surahName: fav.title,
                        arabicName: fav.title, // [Favorilerde Arapça isim yedeği - Arabic fallback]
                        englishName: fav.title,
                        verses: const [],
                        verseCount: 7,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHistoryList({required bool isVisited}) {
    return FutureBuilder<List<String>>(
      future: isVisited ? HistoryService.getVisitedIds() : HistoryService.getToVisitIds(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(
            context, 
            isVisited ? Icons.map_rounded : Icons.bookmark_added_rounded, 
            isVisited ? "Henüz bir mekan ziyaret etmediniz." : "Henüz bir ziyaret planlamadınız."
          );
        }

        final ids = snapshot.data!;
        final items = HistoryRepository.allHistoryItems.where((item) => ids.contains(item.id)).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) => _buildHistoryCard(context, items[index]),
        );
      },
    );
  }

  Widget _buildHistoryCard(BuildContext context, HistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetailScreen(item: item)));
        },
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: item.safeImageUrl != null
                        ? Image.network(
                            item.safeImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFF4B0082),
                              child: const Icon(Icons.account_balance_rounded, color: Colors.white),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF4B0082),
                            child: const Icon(Icons.account_balance_rounded, color: Colors.white),
                          ),
                  ),
                ),
                PositionCenter(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.explore_rounded, color: Color(0xFF4B0082), size: 30),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.displaySubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, IconData icon, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF4B0082).withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: const Color(0xFF4B0082).withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Liste Boş",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4B0082),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PositionCenter extends StatelessWidget {
  final Widget child;
  const PositionCenter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
