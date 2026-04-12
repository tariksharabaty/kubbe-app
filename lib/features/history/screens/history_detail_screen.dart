import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // [Haptic & Clipboard]
import 'package:google_fonts/google_fonts.dart'; // [Yazı Tipleri]
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // [Harita Yönlendirme]
import 'package:share_plus/share_plus.dart'; // [Paylaşım | Sharing]
// import 'package:lottie/lottie.dart'; // [Animasyonlar - Kaldırıldı]
// import 'package:barcode_widget/barcode_widget.dart'; // [QR Kod Üretimi - Kaldırıldı]
// import 'package:screenshot/screenshot.dart'; // [Ekran Görüntüsü Yakalama - Kaldırıldı]
// import 'package:gal/gal.dart'; // [Galeriye Kaydetme - Kaldırıldı]

import '../data/history_repository.dart'; // [Veri Modeli]
import '../../../core/services/history_service.dart'; // [Veri Servisi]
import '../../../core/utils/collection_helper.dart'; // [Koleksiyon Yardımcısı]

// [Tarih Detay Ekranı - History Detail Screen (M3 & One UI Redesign)]
class HistoryDetailScreen extends StatefulWidget {
  final HistoryItem item;

  const HistoryDetailScreen({super.key, required this.item});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  bool _isSaved = false;
  bool _isRead = false;
  final Color kubbePurple = const Color(0xFF4B0082); // [Kubbe Moru | Kubbe Purple]

  @override
  void dispose() {
    HistoryService.updates.removeListener(_onServiceUpdate);
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _loadStatus();
    HistoryService.updates.addListener(_onServiceUpdate);
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  Future<void> _loadStatus() async {
    final saved = await HistoryService.isSaved(widget.item.id);
    final read = await HistoryService.isRead(widget.item.id);
    if (mounted) {
      setState(() {
        _isSaved = saved;
        _isRead = read;
      });
    }
  }

  // [Kütüphane Durumunu Yenile | Refresh Library Status]
  void _refreshStatus() => _loadStatus();

  // [Kopyalama İşlemi | Copy to Clipboard]
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Metin kopyalandı! 📋"), duration: Duration(seconds: 1)),
    );
  }

  // [Paylaşım İşlemi (Söz) | Sharing (Quote)]
  void _shareQuote() {
    HapticFeedback.lightImpact(); // [Yeni: Premium Titreşim | Premium Haptic]
    HapticFeedback.mediumImpact();
    Share.share("${widget.item.name}\n\n${widget.item.famousQuotes.isNotEmpty ? widget.item.famousQuotes.first : widget.item.shortDescription}\n\nKubbe Uygulaması üzerinden paylaşıldı.");
  }

  // [Yeni: Derin Bağlantı Paylaşımı | Deep Link Sharing]
  void _shareDeepLink() {
    HapticFeedback.lightImpact(); // [Yeni: Premium Titreşim | Premium Haptic]
    HapticFeedback.mediumImpact();
    final String message = "Tarihin Kubbesi'nde keşfet: ${widget.item.name}\nhttps://kubbe.sygrad.com/history/${widget.item.id}";
    Share.share(message);
  }

  // [Yeni: Akıllı Kütüphaneye Ekleme | Smart Add to Library]
  void _toggleSave() {
    HapticFeedback.lightImpact();
    CollectionHelper.showCollectionSheet(
      context: context,
      itemId: widget.item.id,
      title: widget.item.name,
      onSaved: () async {
        _refreshStatus();
        await HistoryService.checkReviewRequired(context);
      },
    );
  }

  // [Yeni: Sözü Kütüphaneye Ekleme | Save Quote to Library]
  void _toggleQuoteSave() {
    HapticFeedback.lightImpact();
    final String quoteId = "${widget.item.id}_quote";
    final String quoteText = widget.item.famousQuotes.isNotEmpty 
        ? widget.item.famousQuotes.first 
        : widget.item.shortDescription;

    CollectionHelper.showCollectionSheet(
      context: context,
      itemId: quoteId,
      title: "Söz: ${widget.item.name}",
      subtitle: quoteText,
      onSaved: _refreshStatus,
    );
  }



  // [Yeni: Okundu Durumu Tetikleyici | Mark as Read Trigger]
  void _toggleRead() async {
    if (_isRead) return; // [Zaten okunduysa işlem yapma | Don't act if already read]

    HapticFeedback.lightImpact();
    await HistoryService.toggleRead(widget.item.id);
    
    if (mounted) {
      setState(() => _isRead = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Okundu işaretlendi. Hünkâr Paneline eklendi. ✨", style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
          backgroundColor: kubbePurple,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final textColor = Colors.black87;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6), // [Parşömen Arka Plan | Parchment Background]
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // [1. Dinamik SliverAppBar (Kahraman Görseli) | Hero Image SliverAppBar]
          _buildSliverAppBar(),

          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 24),

              // [2. Hürmet Mesajı | Respect Message]
              if (widget.item.respectMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: Text(
                      widget.item.respectMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: kubbePurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              
              const SizedBox(height: 16),

              // [3. Baş Söz / Vurgu Kartı | Main Highlight Card]
              _buildMainHighlightCard(kubbePurple),

              const SizedBox(height: 32),

              // [4. Hayatı / Miras Metni (Dinamik Başlık) | Bio/Legacy Text (Dynamic Title)]
              _buildContentSection(_getDynamicBodyTitle(), widget.item.fullDescription, textColor),

              // [5. Hikmetli Sözler (Dinamik Başlık) | Wise Quotes (Dynamic Title)]
              if (widget.item.famousQuotes.length > 1)
                _buildQuotesSection(_getDynamicQuotesTitle(), widget.item.famousQuotes.skip(1).toList(), textColor),

              // [6. Bıraktığı Eserler (Dinamik) | Legacy Works (Dynamic)]
              if ((widget.item.category == 'kisi' || widget.item.category == 'medeniyet') && widget.item.legacyWorks.isNotEmpty)
                _buildLegacyWorksSection(widget.item.legacyWorks, kubbePurple, textColor),

              // [7. Türbe / Konum (Dinamik Başlık) | Tomb/Location (Dynamic Title)]
              if (widget.item.tombLocation != null)
                _buildTombSection(_getDynamicLocationTitle(), widget.item.tombLocation!, kubbePurple, textColor),

              const SizedBox(height: 48),

              // [8. Akıllı 'Okudum' Butonu | Smart 'I've Read' Button]
              _buildReadStatusButton(),

              const SizedBox(height: 80),
            ]),
          ),
        ],
      ),
    );
  }

  // [Yeni: Okundu Durum Butonu Yapıcı | Read Status Button Builder]
  Widget _buildReadStatusButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 64,
        child: ElevatedButton(
          onPressed: _isRead ? null : _toggleRead,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isRead ? const Color(0xFFE0E0E0) : kubbePurple,
            foregroundColor: _isRead ? const Color(0xFF757575) : Colors.white,
            elevation: _isRead ? 0 : 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isRead) ...[
                const Icon(Icons.check_circle, size: 22),
                const SizedBox(width: 12),
              ],
              Text(
                _isRead ? "Okundu" : "Okudum, Öğrendim",
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  // [SliverAppBar Yapısı | SliverAppBar Structure]
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 350.0,
      floating: false,
      pinned: true,
      backgroundColor: kubbePurple,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light, // [Koyu zeminde beyaz ikonlar - White icons on dark background]
      leading: _buildAppBarCircleBtn(Icons.arrow_back_ios_new_rounded, () => Navigator.pop(context)),
      actions: [
        TweenAnimationBuilder<double>(
          key: ValueKey(HistoryService.isSavedSync(widget.item.id)),
          tween: Tween(begin: 0.8, end: 1.0),
          curve: Curves.elasticOut,
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: _buildAppBarCircleBtn(
                HistoryService.isSavedSync(widget.item.id) 
                  ? PhosphorIcons.bookmarkSimple(PhosphorIconsStyle.fill) 
                  : PhosphorIcons.bookmarkSimple(), 
                _toggleSave
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        _buildAppBarCircleBtn(Icons.share_rounded, _shareDeepLink),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // [Arka Plan Görseli / Placeholder - Background Image / Placeholder]
            widget.item.safeImageUrl != null 
              ? Image.network(
                  widget.item.safeImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholder(kubbePurple),
                )
              : _buildPlaceholder(kubbePurple),
            // [Karartıcı Gradient - Darkening Gradient]
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.3, 1.0],
                ),
              ),
            ),
            // [Görsel Üstü Tipografi - Typography over Image]
            Positioned(
              left: 24,
              bottom: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.item.name,
                    style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  if (widget.item.category == 'savas' && widget.item.parties != null) ...[
                    const SizedBox(height: 12),
                    _buildPartiesSection(widget.item.parties!),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _getCategorySubtitle(),
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.item.date,
                    style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFFE6E6FA), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [AppBar Yuvarlak Buton - AppBar Circle Button]
  // [AppBar Kare/Yuvarlak Buton - AppBar Box Button]
  Widget _buildAppBarCircleBtn(IconData icon, VoidCallback onTap) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 4), // [Dengeli yerleşim | Balanced placement]
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15), // [Koyu zeminde beyaz opaklık | White opacity on dark]
          borderRadius: BorderRadius.circular(12), // [Standart Radius: 12]
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white, size: 20), // [Standart Size: 20]
          onPressed: onTap,
        ),
      ),
    );
  }

  // [Vurgu Kartı | Highlight Card]
  Widget _buildMainHighlightCard(Color purple) {
    final String mainQuote = widget.item.famousQuotes.isNotEmpty ? widget.item.famousQuotes.first : widget.item.shortDescription;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: purple.withValues(alpha: 0.1)),
          boxShadow: [BoxShadow(color: purple.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          children: [
            Text(
              "\"$mainQuote\"",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: purple, fontStyle: FontStyle.italic, height: 1.4),
            ),
            const SizedBox(height: 24),
            // [Kart Altı İşlem Barı - Card Action Bar]
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCardActionBtn(Icons.copy_rounded, "Kopyala", () => _copyToClipboard(mainQuote)),
                const SizedBox(width: 16),
                Builder(
                  builder: (context) {
                    final bool isQuoteSaved = HistoryService.isSavedSync("${widget.item.id}_quote");
                    return _buildCardActionBtn(
                      isQuoteSaved ? PhosphorIcons.bookmarkSimple(PhosphorIconsStyle.fill) : PhosphorIcons.bookmarkSimple(), 
                      "Kaydet", 
                      _toggleQuoteSave
                    );
                  }
                ),
                const SizedBox(width: 16),
                // [Standartlaştırılmış Paylaş Butonu (Gelişmiş Kart Mekanizması) | Standardized Share Button]
                _buildCardActionBtn(Icons.share, "Paylaş", _shareQuote),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // [Dinamik Başlık Yardımcıları | Dynamic Title Helpers]
  String _getCategorySubtitle() {
    switch (widget.item.category) {
      case 'kisi': return "Gönül Mimarı / Devlet Adamı";
      case 'mekan': return "Mukaddes Mekân / Miras";
      case 'eser': return "Kültürel Miras / Başyapıt";
      case 'kurum': return "Tarihi Kurum / Teşkilat";
      case 'savas': return "Destansı Mücadele";
      case 'medeniyet': return "Kadim Medeniyet Mirası";
      default: return "Tarih ve Medeniyet";
    }
  }

  String _getDynamicBodyTitle() {
    switch (widget.item.category) {
      case 'kisi': return 'Hayatı ve Mirası';
      case 'mekan': return 'Tarihçesi ve Mimarisi';
      case 'medeniyet': return 'Kuruluşu ve Yükselişi';
      case 'savas': return 'Savaşın Seyri ve Sonuçları';
      case 'gelenek': return 'Kökleri ve Uygulanışı';
      case 'eser': return 'Eserin İçeriği ve Önemi';
      case 'kurum': return 'Teşkilatın Yapısı';
      default: return 'Detaylı Bilgiler';
    }
  }

  String _getDynamicQuotesTitle() {
    switch (widget.item.category) {
      case 'kisi': return 'Meşhur Sözleri';
      case 'mekan':
      case 'medeniyet': return 'Hakkında Söylenenler';
      case 'savas': return 'Tarihe Geçen Sözler';
      case 'eser': return 'Eserden Hikmetli Sözler';
      case 'kurum': return 'Teşkilatın İlkeleri';
      default: return 'Hikmetli Sözler';
    }
  }

  String _getDynamicLocationTitle() {
    switch (widget.item.category) {
      case 'kisi': return 'Türbesi / Kabri';
      case 'mekan': return 'Konumu';
      case 'medeniyet':
      case 'savas': return 'Gerçekleştiği Coğrafya';
      case 'eser': return 'Manevi Miras';
      case 'kurum': return 'Merkezi / Makâmı';
      default: return 'Konum Bilgisi';
    }
  }

  Widget _buildCardActionBtn(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8), // [Standart Padding: 8]
            decoration: BoxDecoration(
              color: kubbePurple.withValues(alpha: 0.08), 
              borderRadius: BorderRadius.circular(12), // [Standart Radius: 12]
            ),
            child: Icon(icon, color: kubbePurple, size: 20), // [Standart Size: 20]
          ),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: kubbePurple)),
        ],
      ),
    );
  }

  // [Eski özel buton işlevsiz - Standardizasyon sağlandı | Old custom button deprecated]
  // Widget _buildCardActionBtnCustom(VoidCallback onTap) { ... }

  // [Yeni: Savaş Tarafları - Battle Parties]
  Widget _buildPartiesSection(List<String> parties) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildPartyChip(parties[0]),
        Text("VS", style: GoogleFonts.poppins(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
        if (parties.length > 1) _buildPartyChip(parties[1]),
      ],
    );
  }

  Widget _buildPartyChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(text, style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  // [Yeni: Görsel Yoksa Placeholder - Placeholder for Null Image]
  Widget _buildPlaceholder(Color purple) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [purple, purple.withValues(alpha: 0.8)],
        ),
      ),
      child: Center(
        child: Icon(Icons.account_balance_rounded, color: Colors.white.withValues(alpha: 0.1), size: 180),
      ),
    );
  }

  // [İçerik Bölümü - Content Section]
  Widget _buildContentSection(String title, String content, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.inter(fontSize: 16, color: textColor.withValues(alpha: 0.8), height: 1.7),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // [Sözler Bölümü - Quotes Section]
  Widget _buildQuotesSection(String title, List<String> quotes, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 16),
          ...quotes.map((q) => _buildQuoteItem(q, textColor)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildQuoteItem(String quote, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote_rounded, color: kubbePurple.withValues(alpha: 0.3), size: 28),
          const SizedBox(width: 8),
          Expanded(child: Text(quote, style: GoogleFonts.inter(fontSize: 15, fontStyle: FontStyle.italic, color: textColor))),
        ],
      ),
    );
  }

  // [Eserler Bölümü - Legacy Works]
  Widget _buildLegacyWorksSection(List<String> works, Color purple, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text("Bıraktığı Eserler", style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: works.length,
            itemBuilder: (context, index) => _buildLegacyWorkCard(works[index], purple, textColor),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildLegacyWorkCard(String name, Color purple, Color textColor) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: textColor), maxLines: 2, overflow: TextOverflow.ellipsis),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionBox(
                Icons.location_on_outlined, 
                purple, 
                () => _launchMaps('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(name)}')
              ),
              _buildActionBox(
                _isSaved ? PhosphorIcons.bookmarkSimple(PhosphorIconsStyle.fill) : PhosphorIcons.bookmarkSimple(), 
                purple, 
                _toggleSave
              ),
            ],
          ),
        ],
      ),
    );
  }

  // [Yardımcı: Aksiyon Kutusu - Action Box Helper]
  Widget _buildActionBox(IconData icon, Color purple, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: purple.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: purple, size: 20),
      ),
    );
  }

  // [Türbe / Konum Bölümü - Tomb Section]
  Widget _buildTombSection(String title, String location, Color purple, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _launchMaps(location), // [Konuma Gitme Entegrasyonu | Maps Integration]
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: purple.withValues(alpha: 0.05), // [M3 Tonal Surface]
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: purple.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded, color: purple, size: 24),
                  const SizedBox(width: 16),
                  Expanded(child: Text(location, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textColor))),
                  Icon(Icons.open_in_new_rounded, color: purple.withValues(alpha: 0.4), size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchMaps(String location) async {
    final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}";
    final uri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
