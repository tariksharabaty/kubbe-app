import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kubbe_app/features/history/data/history_repository.dart';
import 'package:kubbe_app/features/history/screens/history_detail_screen.dart';
import 'package:kubbe_app/core/widgets/empty_search_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../../../core/services/history_service.dart';
import '../../../core/widgets/expandable_search_app_bar.dart';

class CollectionDetailScreen extends StatefulWidget {
  final String collectionName;
  final List<HistoryItem> items;

  const CollectionDetailScreen({
    super.key,
    required this.collectionName,
    required this.items,
  });

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  bool _isGridView = false;
  final Color kubbePurple = const Color(0xFF4B0082);
  late List<HistoryItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
    _loadViewPreference();
  }

  Future<void> _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGridView = prefs.getBool('collection_view_is_grid') ?? false;
    });
  }
  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _items = List.from(widget.items);
      } else {
        _items = widget.items.where((item) {
          final q = query.toLowerCase();
          return item.name.toLowerCase().contains(q) ||
                 item.shortDescription.toLowerCase().contains(q) ||
                 item.quote.toLowerCase().contains(q) ||
                 item.category.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  void _removeItem(String itemId) async {
    // [Koleksiyondan kalıcı olarak sil - Delete permanently from collection]
    if (widget.collectionName == "Kütüphanem" || widget.collectionName == "Ana Kütüphane") {
      await HistoryService.toggleSave(itemId);
    } else if (widget.collectionName == "Okuduklarım") {
      await HistoryService.toggleRead(itemId);
    } else {
      // Özel liste - Custom list
      await HistoryService.removeFromCollection(itemId, widget.collectionName);
    }
    
    if (mounted) {
      setState(() {
        _items.removeWhere((i) => i.id == itemId); // Use _items here
      });
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: ExpandableSearchAppBar(
        title: widget.collectionName,
        onSearchChanged: _onSearch,
        hintText: "Koleksiyonda ara...",
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: kubbePurple,
            ),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: widget.items.isEmpty 
          ? _buildEmptyState()
          : _items.isEmpty
              ? const EmptySearchState()
              : _isGridView 
                  ? _buildGridView(kubbePurple) 
                  : _buildListView(kubbePurple),
    );
  }

  Widget _buildListView(Color kubbePurple) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
          ),
          onDismissed: (_) => _removeItem(item.id),
          child: item.category == "soz" 
            ? _buildQuoteTile(context, item, kubbePurple)
            : _buildItemCard(context, item, kubbePurple),
        );
      },
    );
  }

  Widget _buildGridView(Color kubbePurple) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return item.category == "soz"
            ? _buildQuoteTile(context, item, kubbePurple)
            : _buildGridItemCard(context, item, kubbePurple);
      },
    );
  }

  Widget _buildGridItemCard(BuildContext context, HistoryItem item, Color purple) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HistoryDetailScreen(item: item)),
          ),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    width: double.infinity,
                    color: purple.withValues(alpha: 0.05),
                    child: item.safeImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: item.safeImageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFF4B0082),
                              child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 40),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF4B0082),
                            child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 40),
                          ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.shortDescription,
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_edu, 
            size: 100, 
            color: kubbePurple.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Seyyah, heyben henüz boş.\nKubbe'de keşfe çık.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16, 
                color: Colors.grey[600], 
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, HistoryItem item, Color purple) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HistoryDetailScreen(item: item)),
          ),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: purple.withValues(alpha: 0.05),
                    child: item.safeImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: item.safeImageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFF4B0082),
                              child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 30),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF4B0082),
                            child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 30),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.shortDescription,
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteTile(BuildContext context, HistoryItem item, Color purple) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: purple.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryDetailScreen(item: item)),
        ),
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: item.quote));
          HapticFeedback.heavyImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Söz panoya kopyalandı", style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: kubbePurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: purple.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.edit_note_rounded, color: purple, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.quote.isNotEmpty ? item.quote : item.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF2D3436),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.name,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: purple.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
