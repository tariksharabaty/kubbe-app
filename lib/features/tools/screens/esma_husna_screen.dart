import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/esma_model.dart';

// [Esmâ-ül Hüsnâ Ekranı - Esmâ-ül Hüsnâ Screen]
class EsmaHusnaScreen extends StatefulWidget {
  const EsmaHusnaScreen({super.key});

  @override
  State<EsmaHusnaScreen> createState() => _EsmaHusnaScreenState();
}

class _EsmaHusnaScreenState extends State<EsmaHusnaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFF4B0082);
    final filteredList = esmaList.where((e) {
      return e.nameTurkish.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.nameArabic.contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: purple,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(PhosphorIcons.caretLeft(), color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Esmâ-ül Hüsnâ",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // [Modern Arama Barı - Modern Search Bar]
          Container(
            color: purple,
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "İsimlerde ara...",
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.15),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final esma = filteredList[index];
                return _buildEsmaCard(context, esma, purple);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEsmaCard(BuildContext context, Esma esma, Color purple) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: purple.withValues(alpha: 0.1),
          child: Text(esma.index, style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        title: Text(
          esma.nameTurkish,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Text(
          esma.meaning,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: Text(
          esma.nameArabic,
          style: GoogleFonts.amiri(fontSize: 22, color: purple, fontWeight: FontWeight.bold),
        ),
        onTap: () => _showEsmaDetail(context, esma, purple),
      ),
    );
  }

  void _showEsmaDetail(BuildContext context, Esma esma, Color purple) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 32),
            // [Arapça Hat Sanatı - Arabic Calligraphy]
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: purple.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Text(
                esma.nameArabic,
                style: GoogleFonts.amiri(
                  fontSize: 56, // [KESİNLİKLE Büyük Font - Definitely Large Font]
                  fontWeight: FontWeight.bold,
                  color: purple,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              esma.nameTurkish,
              style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Text("Sıra: ${esma.index}", style: TextStyle(color: purple, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, -10)),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(PhosphorIcons.bookOpen(), color: purple, size: 24),
                          const SizedBox(width: 12),
                          Text("Derin Anlamı", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        esma.meaning,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          height: 1.8,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
