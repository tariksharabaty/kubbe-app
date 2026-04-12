import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/services.dart';
import '../../../data/models/dua_model.dart';
import '../../../core/services/history_service.dart';
import '../../../core/utils/collection_helper.dart';
import '../../zikirmatik/screens/zikirmatik_screen.dart';

class DuaDetailScreen extends StatefulWidget {
  final DuaItem dua;
  const DuaDetailScreen({super.key, required this.dua});

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  @override
  void initState() {
    super.initState();
    HistoryService.updates.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    HistoryService.updates.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFF4B0082);
    final bool isSaved = HistoryService.isSavedSync(widget.dua.id);
    final bool isRead = HistoryService.isReadSync(widget.dua.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(PhosphorIcons.caretLeft(), color: purple),
        ),
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              HistoryService.toggleRead(widget.dua.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isRead ? "Öğrenilmedi olarak işaretlendi." : "Öğrenildi olarak işaretlendi."),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: isRead ? Colors.grey : Colors.green,
                ),
              );
            },
            icon: Icon(
              isRead ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill) : PhosphorIcons.checkCircle(),
              color: isRead ? Colors.green : purple,
            ),
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              CollectionHelper.toggleSave(context, widget.dua.id, widget.dua.title, "Dua");
            },
            icon: Icon(
              isSaved ? PhosphorIcons.bookmarkSimple(PhosphorIconsStyle.fill) : PhosphorIcons.bookmarkSimple(),
              color: purple,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.dua.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: purple,
              ),
            ),
            if (widget.dua.source != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.dua.source!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 40),
            
            // Arapça Metin
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: purple.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Ses dosyası yakında eklenecek"), behavior: SnackBarBehavior.floating),
                        );
                      },
                      icon: Icon(PhosphorIcons.speakerHigh(), color: purple.withValues(alpha: 0.1)),
                    ),
                  ),
                  Text(
                    widget.dua.arabicText,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.amiri(
                      fontSize: 28,
                      height: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            _buildSection(context, "Okunuşu", widget.dua.transliteration),
            const SizedBox(height: 24),
            _buildSection(context, "Meali", widget.dua.translation),
            
            const SizedBox(height: 40),
            
            // [Zikret Butonu | Zikret Button]
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ZikirmatikScreen(
                        initialZikirName: widget.dua.title,
                        initialTargetCount: 33,
                      ),
                    ),
                  );
                },
                icon: Icon(PhosphorIcons.fingerprint()),
                label: Text("BU DUAYI ZİKRET (33)", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 16,
            height: 1.6,
            color: const Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }
}
