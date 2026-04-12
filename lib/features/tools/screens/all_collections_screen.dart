import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kubbe_app/core/services/history_service.dart';
import 'package:kubbe_app/features/history/data/history_repository.dart';
import 'package:kubbe_app/features/tools/screens/collection_detail_screen.dart';
import 'package:kubbe_app/core/widgets/empty_search_state.dart';
import 'package:kubbe_app/core/widgets/custom_loading_animation.dart';

class AllCollectionsScreen extends StatefulWidget {
  const AllCollectionsScreen({super.key});

  @override
  State<AllCollectionsScreen> createState() => _AllCollectionsScreenState();
}

class _AllCollectionsScreenState extends State<AllCollectionsScreen> {
  final String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    const Color kubbePurple = Color(0xFF4B0082);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: kubbePurple,
        elevation: 0,
        title: Text(
          "Tüm Koleksiyonlar",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: HistoryService.updates,
        builder: (context, value, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _getAllCollections(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomLoadingAnimation());
              }
              if (!snapshot.hasData) {
                // This case would typically handle errors or truly empty data after loading.
                // For now, we'll keep the original placeholder or consider an error state.
                // The animation is used for the waiting state.
                return const Center(child: Text("Veri yüklenemedi veya bulunamadı."));
              }

              final collections = snapshot.data!.where((col) {
                return col['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList();
              
              if (collections.isEmpty && _searchQuery.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.travel_explore_rounded, color: kubbePurple.withValues(alpha: 0.4), size: 80),
                      const SizedBox(height: 16),
                      Text(
                        "Bu kelimeyle eşleşen bir kayıt bulunamadı, seyyah",
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              
              if (collections.isEmpty) {
                return const EmptySearchState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  final col = collections[index];
                  return _buildCollectionM3Card(context, col, kubbePurple);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getAllCollections() async {
    final customLists = await HistoryService.getCustomLists();
    List<Map<String, dynamic>> collections = [];
    
    for (String name in ["Kütüphanem", "Okuduklarım", ...customLists]) {
      final itemIds = await HistoryService.getItemsInCollection(name);
      final items = HistoryRepository.allHistoryItems.where((i) => itemIds.contains(i.id)).toList();
      
      String? coverImage;
      if (items.isNotEmpty) {
        coverImage = items.first.safeImageUrl;
      }

      collections.add({
        'name': name,
        'count': items.length,
        'image': coverImage,
        'items': items,
      });
    }
    return collections;
  }

  Widget _buildCollectionM3Card(BuildContext context, Map<String, dynamic> col, Color purple) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionDetailScreen(
              collectionName: col['name'],
              items: col['items'],
            ),
          ),
        ),
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              // Image Section
              Container(
                width: 120,
                height: 120,
                color: purple.withValues(alpha: 0.05),
                child: col['image'] != null
                    ? CachedNetworkImage(
                        imageUrl: col['image'],
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(Icons.collections_bookmark_rounded, color: Colors.grey),
                      )
                    : const Icon(Icons.collections_bookmark_rounded, color: Colors.grey, size: 40),
              ),
              // Text Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        col['name'],
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${col['count']} Öğe",
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
