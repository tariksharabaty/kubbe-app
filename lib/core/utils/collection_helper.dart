import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kubbe_app/core/widgets/custom_loading_animation.dart';
import '../services/history_service.dart';

class CollectionHelper {
  static void showCollectionSheet({
    required BuildContext context,
    required String itemId,
    required String title,
    String? subtitle,
    VoidCallback? onSaved,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CollectionSheet(
        itemId: itemId,
        title: title,
        subtitle: subtitle,
        onSaved: onSaved,
      ),
    );
  }

  static void toggleSave(BuildContext context, String itemId, String title, String subtitle) {
    showCollectionSheet(
      context: context,
      itemId: itemId,
      title: title,
      subtitle: subtitle,
    );
  }
}

class _CollectionSheet extends StatefulWidget {
  final String itemId;
  final String title;
  final String? subtitle;
  final VoidCallback? onSaved;

  const _CollectionSheet({
    required this.itemId,
    required this.title,
    this.subtitle,
    this.onSaved,
  });

  @override
  State<_CollectionSheet> createState() => _CollectionSheetState();
}

class _CollectionSheetState extends State<_CollectionSheet> {
  late Future<List<String>> _collectionsFuture;
  final TextEditingController _newCollectionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _collectionsFuture = HistoryService.getCustomLists();
  }

  void _refreshCollections() {
    setState(() {
      _collectionsFuture = HistoryService.getCustomLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 12,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Koleksiyona Ekle",
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4B0082),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          FutureBuilder<List<String>>(
            future: _collectionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomLoadingAnimation());
              }
              
              final collections = snapshot.data ?? [];
              
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Ana Kütüphane Seçeneği
                    _buildCollectionItem(
                      icon: Icons.bookmark_rounded,
                      name: "Kütüphanem",
                      isDefault: true,
                    ),
                    const Divider(),
                    ...collections.map((name) => _buildCollectionItem(
                      icon: Icons.folder_open_rounded,
                      name: name,
                    )),
                    const SizedBox(height: 12),
                    // Yeni Liste Oluştur
                    _buildAddNewAction(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionItem({
    required IconData icon,
    required String name,
    bool isDefault = false,
  }) {
    return FutureBuilder<bool>(
      future: isDefault 
          ? HistoryService.isSaved(widget.itemId)
          : HistoryService.getItemsInCollection(name).then((items) => items.contains(widget.itemId)),
      builder: (context, snapshot) {
        final isInCollection = snapshot.data ?? false;
        
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: const Color(0xFF4B0082)),
          title: Text(
            name,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          trailing: Icon(
            isInCollection ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
            color: isInCollection ? Colors.green : Colors.grey[400],
          ),
          onTap: () async {
            if (isInCollection) {
              if (isDefault) {
                await HistoryService.toggleSave(widget.itemId);
              } else {
                await HistoryService.removeFromCollection(widget.itemId, name);
              }
            } else {
              // [Kaydetmeden önce metadata sakla | Save metadata before bookmarking]
              await HistoryService.saveMetadata(widget.itemId, widget.title, widget.subtitle ?? "");
              
              if (isDefault) {
                await HistoryService.saveOnly(widget.itemId);
              } else {
                await HistoryService.saveToCollection(widget.itemId, name);
              }
            }
            setState(() {});
            if (widget.onSaved != null) widget.onSaved!();
          },
        );
      },
    );
  }

  Widget _buildAddNewAction() {
    return InkWell(
      onTap: _showCreateDialog,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            const Icon(Icons.add_rounded, color: Colors.grey),
            const SizedBox(width: 12),
            Text(
              "Yeni Liste Oluştur",
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Yeni Liste", style: GoogleFonts.outfit()),
        content: TextField(
          controller: _newCollectionController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Liste adı girin...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = _newCollectionController.text.trim();
              if (name.isNotEmpty) {
                await HistoryService.createCustomList(name);
                _newCollectionController.clear();
                if (context.mounted) Navigator.pop(context);
                _refreshCollections();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B0082),
              foregroundColor: Colors.white,
            ),
            child: const Text("Oluştur"),
          ),
        ],
      ),
    );
  }
}
