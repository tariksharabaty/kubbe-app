import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/state/quran_settings_state.dart';

class SurahInfoSheet extends StatelessWidget {
  final ReadingScope readingScope;
  final int? surahNumber;
  final String? surahName;
  final String? arabicName;
  final int? verseCount;
  final bool? isMakki;
  final int? juzNumber;
  final int? pageNumber;

  const SurahInfoSheet({
    super.key,
    required this.readingScope,
    this.surahNumber,
    this.surahName,
    this.arabicName,
    this.verseCount,
    this.isMakki,
    this.juzNumber,
    this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // [Header: Premium Gradient]
              _buildHeader(),

              // [Body: Information Sections]
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: _buildBodyContent(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    String title = "";
    String? subtitle;
    String? topTitle;

    switch (readingScope) {
      case ReadingScope.surah:
      case ReadingScope.ayah:
        topTitle = arabicName;
        title = surahName ?? "Sure";
        subtitle = "${isMakki == true ? "Mekki" : "Medeni"} • ${verseCount ?? 0} Ayet";
        break;
      case ReadingScope.juz:
        title = "${juzNumber}. Cüz Rehberi";
        subtitle = "Cüz Bilgileri • 20 Sayfa";
        break;
      case ReadingScope.page:
        title = "${pageNumber}. Sayfa Özeti";
        subtitle = "Ayetlerin Kısa Tefsiri";
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4B0082), // Deep Purple
            Color(0xFF3498DB), // Steel Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          if (topTitle != null) ...[
            Text(
              topTitle,
              style: GoogleFonts.amiri(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              subtitle,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBodyContent(BuildContext context) {
    switch (readingScope) {
      case ReadingScope.surah:
      case ReadingScope.ayah:
        return _buildSurahBody();
      case ReadingScope.juz:
        return _buildJuzBody();
      case ReadingScope.page:
        return _buildPageBody();
    }
  }

  List<Widget> _buildSurahBody() {
    return [
      _buildSectionTitle("Surenin Sırları"),
      const SizedBox(height: 12),
      Text(
        "Nuzul Sebebi: Bu mübarek sure, Kur'an-ı Kerim'in derin hidayet rehberlerinden biridir. Medine döneminde nazil olmuştur ve toplumsal düzeni pekiştirir.\n\nFazileti: Efendimiz (sav) bu surenin her ayetinde büyük şifalar olduğunu buyurmuştur. Okunması rızkın bolluğuna ve manevi huzura vesile olur.",
        style: GoogleFonts.inter(fontSize: 15, color: Colors.black87, height: 1.6),
      ),
      const SizedBox(height: 24),
      _buildSectionTitle("Tecvit Ansiklopedisi"),
      const SizedBox(height: 12),
      
      // Category: Nun-i Sakin ve Tenvin
      _buildTajweedCategoryTitle("Nûn-i Sâkin ve Tenvin"),
      _buildTajweedExpansionTile("İhfa (Gizleme)", "Sakin nun veya tenvinin 'ihfa harflerinden' önce gelmesiyle oluşur. Ses genizden getirilir.", ["ت", "ث", "ج", "د", "ذ", "ز", "س", "ش", "ص", "ض", "ط", "ظ", "ف", "ق", "ك"], "مِنْ قَبْلُ - أَنْفُسَكُمْ", "Gizleme"),
      _buildTajweedExpansionTile("İzhar (Açıklama)", "Sakin nun veya tenvinin 'boğaz harflerinden' önce gelmesiyle oluşur. Ses net çıkarılır.", ["أ", "هـ", "ع", "ح", "غ", "خ"], "مِنْ حَيْثُ - أَنْعَمْتَ", "Açıklama"),
      _buildTajweedExpansionTile("İklab (Çevirme)", "Sakin nun veya tenvinin 'Be' harfinden önce gelmesiyle 'Mim' sesine dönüşmesidir.", ["ب"], "مِنْ بَعْدِ", "Çevirme"),
      _buildTajweedExpansionTile("İdgam-ı Maalgunne", "Sakin nun veya tenvinin (ي، م، ن، و) harflerine uğramasıyla genizden ses verilerek okunmasıdır.", ["ي", "م", "ن", "و"], "مَنْ يَقُولُ", "Bitişik"),
      _buildTajweedExpansionTile("İdgam-ı Bilagunne", "Sakin nun veya tenvinin (ل، ر) harflerine uğramasıyla genizsiz okunmasıdır.", ["ل", "ر"], "مِنْ رَبِّكَ", "Bitişsiz"),

      const SizedBox(height: 16),
      // Category: Medler
      _buildTajweedCategoryTitle("Medler (Uzatmalara)"),
      _buildTajweedExpansionTile("Med-i Tabii", "Asli uzatmadır. Harf-i medden sonra sebeb-i med gelmezse 1 elif miktarı uzatılır.", ["ا", "و", "ي"], "قَالَ - يَقُولُ", "Asli Med"),
      _buildTajweedExpansionTile("Med-i Muttasıl", "Med harfinden sonra hemze aynı kelimede gelirse 4 elif uzatılır.", ["ء"], "جَاءَ", "Vacip Med"),
      _buildTajweedExpansionTile("Med-i Munfasıl", "Med harfi ve hemze ayrı kelimelerde gelirse 4 elif uzatılır.", ["ء"], "يَا أَيُّهَا", "Caiz Med"),
      _buildTajweedExpansionTile("Med-i Lazım", "Medden sonra sükun-u lazım gelirse 4 elif uzatılır. Her zaman uzatılır.", ["ّ", "ْ"], "الضَّالِّينَ", "Lazım Med"),
      _buildTajweedExpansionTile("Med-i Arız", "Durulduğunda ortaya çıkan sükun sebepli uzatmadır.", ["ْ"], "نَسْتَعِينُ", "Geçici Med"),
      _buildTajweedExpansionTile("Med-i Lin", "Vav ve Ya harflerinden sonra sükun gelmesiyle oluşan yumuşak uzatmadır.", ["و", "ي"], "قُرَيْشٍ", "Yumuşak Med"),

      const SizedBox(height: 16),
      // Category: Diger
      _buildTajweedCategoryTitle("Diğer Kurallar"),
      _buildTajweedExpansionTile("Kalkale (Vurgu)", "Kutbu Cedid harflerinde yapılan sarsma ve kuvvet verme kuralıdır.", ["ق", "ط", "ب", "ج", "د"], "أَبْطَلَ - لَمْ يَلِدْ", "Sarsma"),
      _buildTajweedExpansionTile("Ra'nın Hükümleri", "Ra harfinin harekesine göre ince veya kalın okunması kuralıdır.", ["ر"], "رَبِّ - رِزْقاً", "Hüküm"),
      _buildTajweedExpansionTile("Lafzatullah", "Allah lafzındaki 'Lam' harfinin makamına göre kalın veya ince okunmasıdır.", ["ل"], "اللَّهِ", "Yüceltme"),
      _buildTajweedExpansionTile("Zamir", "Kelime sonundaki 'He' harfinin uzatılıp uzatılmayacağı kuralıdır.", ["هـ"], "لَهُ - مِنْهُ", "Ek"),
    ];
  }

  Widget _buildTajweedCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF4B0082).withOpacity(0.6),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTajweedExpansionTile(String title, String explanation, List<String> letters, String example, String category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4B0082).withOpacity(0.1)),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF4B0082)),
        ),
        subtitle: Text(category, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4B0082).withOpacity(0.1),
          child: Text(letters.first, style: GoogleFonts.amiri(color: const Color(0xFF4B0082), fontWeight: FontWeight.bold)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Text("Açıklama:", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(explanation, style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, height: 1.4)),
                const SizedBox(height: 12),
                Text("Harfler:", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: letters.map((l) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF4B0082).withOpacity(0.2)),
                    ),
                    child: Text(l, style: GoogleFonts.amiri(fontSize: 18, color: const Color(0xFF4B0082))),
                  )).toList(),
                ),
                const SizedBox(height: 16),
                Text("Örnek:", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3498DB).withOpacity(0.3)),
                  ),
                  child: Text(
                    example,
                    style: GoogleFonts.amiri(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildJuzBody() {
    final surahs = _getSurahsForJuz(juzNumber ?? 1);
    final theme = _getJuzTheme(juzNumber ?? 1);

    return [
      _buildSectionTitle("Bu Cüzdeki Sureler"),
      const SizedBox(height: 16),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: surahs.map((s) => _buildScopeChip(s)).toList(),
      ),
      const SizedBox(height: 24),
      _buildSectionTitle("Cüzün Sırları ve Teması"),
      const SizedBox(height: 12),
      Text(
        theme,
        style: GoogleFonts.inter(fontSize: 15, color: Colors.black87, height: 1.6),
      ),
    ];
  }

  List<String> _getSurahsForJuz(int juz) {
    // [Cüzlerdeki sure dağılımı - Surah distribution in Juz]
    final Map<int, List<String>> juzToSurahs = {
      1: ["Fâtiha", "Bakara (1-141)"],
      2: ["Bakara (142-252)"],
      3: ["Bakara (253-286)", "Âl-i İmrân (1-92)"],
      4: ["Âl-i İmrân (93-200)", "Nisâ (1-23)"],
      5: ["Nisâ (24-147)"],
      6: ["Nisâ (148-176)", "Mâide (1-81)"],
      7: ["Mâide (82-120)", "En'âm (1-110)"],
      8: ["En'âm (111-165)", "A'râf (1-87)"],
      9: ["A'râf (88-206)", "Enfâl (1-40)"],
      10: ["Enfâl (41-75)", "Tevbe (1-92)"],
      11: ["Tevbe (93-129)", "Yûnus", "Hûd (1-5)"],
      12: ["Hûd (6-123)", "Yûsuf (1-52)"],
      13: ["Yûsuf (53-111)", "Ra'd", "İbrâhîm (1-52)"],
      14: ["Hicr", "Nahl"],
      15: ["İsrâ", "Kehf (1-74)"],
      16: ["Kehf (75-110)", "Meryem", "Tâhâ"],
      17: ["Enbiyâ", "Hac"],
      18: ["Mü'minûn", "Nûr", "Furkân (1-20)"],
      19: ["Furkân (21-77)", "Şuarâ", "Neml (1-55)"],
      20: ["Neml (56-93)", "Kasas", "Ankebût (1-45)"],
      21: ["Ankebût (46-69)", "Rûm", "Lokmân", "Secde", "Ahzâb (1-30)"],
      22: ["Ahzâb (31-73)", "Sebe'", "Fâtır", "Yâsîn (1-27)"],
      23: ["Yâsîn (28-83)", "Sâffât", "Sâd", "Zümer (1-31)"],
      24: ["Zümer (32-75)", "Mü'min", "Fussilet (1-46)"],
      25: ["Fussilet (47-54)", "Şûrâ", "Zuhruf", "Duhân", "Câsiye"],
      26: ["Ahkâf", "Muhammed", "Fetih", "Hucurât", "Kâf", "Zâriyât (1-30)"],
      27: ["Zâriyât (31-60)", "Tûr", "Necm", "Kamer", "Rahmân", "Vâkıa", "Hadîd"],
      28: ["Mücâdele", "Haşr", "Mümtehine", "Saf", "Cum'a", "Münâfikûn", "Teğâbün", "Talâk", "Tahrîm"],
      29: ["Mülk", "Kalem", "Hâkka", "Meâric", "Nûh", "Cin", "Müzzemmil", "Müddessir", "Kıyâme", "İnsân", "Mürselât"],
      30: ["Nebe'", "Nâziât", "Abese", "Tekvîr", "İnfitâr", "Mutaffifîn", "İnşikâk", "Burûc", "Târık", "A'lâ", "Ğâşiye", "Fecr", "Beled", "Şems", "Leyl", "Duha", "İnşirah", "Tin", "Alak", "Kadir", "Beyyine", "Zilzal", "Adiyat", "Kari'a", "Tekasür", "Asr", "Hümeze", "Fil", "Kureyş", "Ma'un", "Kevser", "Kafirun", "Nasr", "Tebbet", "İhlas", "Felak", "Nas"],
    };
    return juzToSurahs[juz] ?? ["Sure Bilgisi Bulunamadı"];
  }

  String _getJuzTheme(int juz) {
    // [Cüzlerin ana temaları - Main themes of Juzes]
    final Map<int, String> juzThemes = {
      1: "Yaratılış, insanın yeryüzündeki halifelik görevi ve Fâtiha suresinin özeti. İman ve ibadet esasları.",
      2: "Kıble değişimi, sabır ve namazın önemi, temel İslam hukukuna giriş (Oruç, Hac, Miras).",
      3: "Âyetü'l-Kürsi'nin derinliği, infakın önemi ve Âl-i İmrân suresinin başında tevhid vurgusu.",
      4: "İman kuvveti, Uhud savaşı ibretleri ve aile hayatının temelleri (Nisâ suresi başlangıcı).",
      5: "Yetim hakları, kadınların hakları ve adaletli bir toplumun inşası için gereken hukuk kuralları.",
      6: "Ehl-i Kitap ile diyalog, Mâide suresindeki helal-haram hükümleri ve sözleşmelere sadakat.",
      7: "Görünen ve görünmeyen ayetler, Peygamberlerin Allah sevgisi ve En'âm suresindeki tevhid delilleri.",
      8: "İslami hayat tarzı, A'râf suresindeki geçmiş ümmetlerin akıbetleri ve ibret verici kıssalar.",
      9: "Hidayet ve delalet ayrımı, Enfâl suresindeki Allah yolunda yardımlaşma ve manevi hazırlık.",
      10: "Bedir Savaşı ruhu, Tevbe suresindeki samimiyet vurgusu ve Allah yolunda harcamanın önemi.",
      30: "Kıyamet sahneleri, ahiret inancı ve kısa surelerdeki derin hikmetler. Amme cüzünün özeti.",
    };
    return juzThemes[juz] ?? "Bu cüzde temel olarak iman esasları, ahlaki prensipler ve peygamber hayatlarından ibretler anlatılmaktadır.";
  }

  List<Widget> _buildPageBody() {
    return [
      _buildSectionTitle("Sayfanın Özeti"),
      const SizedBox(height: 12),
      Text(
        "Bu sayfa, hidayetin önemini ve Allah'ın birliğini tasdik eden delilleri içermektedir. Müminlere zorluklar karşısında sabırlı olmaları tavsiye edilir.",
        style: GoogleFonts.inter(fontSize: 15, color: Colors.black87, height: 1.6),
      ),
      const SizedBox(height: 24),
      _buildSectionTitle("Önemli Kelimeler"),
      const SizedBox(height: 12),
      _buildWordTile("El-Hidaye", "Doğru yol, rehberlik, karanlıktan ışığa çıkış."),
      _buildWordTile("Es-Sabr", "Zorluklara karşı metanetli olmak, şikayeti terk etmek."),
      _buildWordTile("El-Müminun", "Kalbiyle tasdik eden, güven veren gerçek inananlar."),
    ];
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF4B0082),
      ),
    );
  }


  Widget _buildWordTile(String word, String meaning) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(word, style: GoogleFonts.amiri(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF4B0082))),
          const SizedBox(height: 4),
          Text(meaning, style: GoogleFonts.inter(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildScopeChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFF4B0082).withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF4B0082))),
    );
  }
}
