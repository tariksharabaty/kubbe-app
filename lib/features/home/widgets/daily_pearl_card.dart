import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/utils/collection_helper.dart';
import '../../../core/services/history_service.dart';

// [Günün İncileri Modüler Kart Bileşeni | Daily Pearls Modular Card Component]
class DailyPearlCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final VoidCallback onRefresh;

  const DailyPearlCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final String type = data['type'] ?? 'Genel';
    final Color primaryColor = _getCategoryColor(type);
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.04), // [M3 Tonal Surface]
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Shrink to content to prevent overflow
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Category and Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(data['icon'] ?? PhosphorIcons.sparkle(), color: primaryColor, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          data['title']?.toString().toUpperCase() ?? type.toUpperCase(),
                          style: GoogleFonts.outfit(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    if (type == 'SpecialDay')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("Özel Gün", style: GoogleFonts.inter(fontSize: 10, color: Colors.amber[900], fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Middle: Content
                Text(
                  data['content'] ?? '',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  maxLines: 4, // Limit lines to prevent vertical overflow
                  overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                ),
                const SizedBox(height: 16),
                // Bottom: Source and Actions
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data['source'] ?? data['subtitle'] ?? '',
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildActionBar(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(

      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionBtn(
          icon: PhosphorIcons.copy(),
          onTap: () {
            HapticFeedback.lightImpact();
            Clipboard.setData(ClipboardData(text: data['content'] ?? ''));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Metin kopyalandı!"), behavior: SnackBarBehavior.floating),
            );
          },
        ),
        const SizedBox(width: 8),
        _buildSaveBtn(context),
        const SizedBox(width: 8),
        _buildActionBtn(
          icon: PhosphorIcons.shareNetwork(),
          onTap: () {
            HapticFeedback.lightImpact();
            Share.share("${data['title']}\n\n${data['content']}\n\nKubbe Uygulaması üzerinden paylaşıldı.");
          },
        ),
      ],
    );
  }

  Widget _buildSaveBtn(BuildContext context) {
    final String finalId = data['id']?.toString() ?? "daily_${data['type']}_${DateTime.now().day}";
    
    return FutureBuilder<bool>(
      future: HistoryService.isSaved(finalId),
      builder: (context, snapshot) {
        final bool isSaved = snapshot.data ?? false;
        return _buildActionBtn(
          icon: isSaved ? PhosphorIcons.bookmarkSimple(PhosphorIconsStyle.fill) : PhosphorIcons.bookmarkSimple(),
          onTap: () {
            HapticFeedback.lightImpact();
            CollectionHelper.showCollectionSheet(
              context: context,
              itemId: finalId,
              title: data['title'].toString(),
              subtitle: data['content'].toString(),
              onSaved: onRefresh,
            );
          },
        );
      }
    );
  }

  Widget _buildActionBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF4B0082)),
      ),
    );
  }

  Color _getCategoryColor(String type) {
    switch (type) {
      case 'Ayet': return const Color(0xFF4B0082);
      case 'Hadis': return const Color(0xFF191970);
      case 'Dua': return const Color(0xFF006400);
      case 'Şahsiyet': return Colors.brown;
      case 'Olay': return Colors.red[900]!;
      case 'Mekan': return Colors.amber[900]!;
      case 'Medeniyet': return Colors.teal[900]!;
      case 'SpecialDay': return Colors.deepOrange;
      default: return const Color(0xFF4B0082);
    }
  }
}
