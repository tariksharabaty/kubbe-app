import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/utils/string_extensions.dart';

class DreamInterpretationScreen extends StatefulWidget {
  const DreamInterpretationScreen({super.key});

  @override
  State<DreamInterpretationScreen> createState() => _DreamInterpretationScreenState();
}

class _DreamInterpretationScreenState extends State<DreamInterpretationScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _dreamController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  late AnimationController _animationController;
  List<Map<String, String>> _filteredDictionary = [];

  final List<Map<String, String>> _dictionary = [
    {'term': 'Ağaç', 'meaning': 'Dinde doğruluğa, berekete ve köklü bir aileye işarettir. Meyveli ağaç rızık, kurumuş ağaç üzüntüdür.'},
    {'term': 'Altın', 'meaning': 'Dünya malına, gam ve kedere, bazen de temiz ve halis amele yorumlanır.'},
    {'term': 'Bal', 'meaning': 'Helal rızka, Kur\'an okumaya ve ilim öğrenmeye delalet eder.'},
    {'term': 'Cami', 'meaning': 'Huzura, güvenliğe, tövbe etmeye ve helal kazanca işarettir.'},
    {'term': 'Deniz', 'meaning': 'Büyük rızık, kazanç ve bazen de hayırlı bir yolculuktur. Berrak deniz huzur, dalgalı deniz heyecandır.'},
    {'term': 'Ekmek', 'meaning': 'İlim, rızık ve helal kazancın sembolüdür. Taze ekmek bolluk, bayat ekmek kanaattir.'},
    {'term': 'Fırın', 'meaning': 'Geçim kolaylığına, rızık kapısının bolluğuna ve hane içindeki berekete delalettir.'},
    {'term': 'Güneş', 'meaning': 'Devlet başkanı, yükseliş, parlayan şans ve hidayet yoluna girmeye yorulur.'},
    {'term': 'Hazine', 'meaning': 'İlim öğrenmeye, beklemediğiniz yerden gelecek kısmete veya manevi bir yükselişe işarettir.'},
    {'term': 'Irmak', 'meaning': 'Cömert ve asil bir kimse ile tanışmaya, kesintisiz rızka ve huzura yorulur.'},
    {'term': 'İnci', 'meaning': 'Kur\'an okumaya, hikmetli söze ve hayırlı bir evlada delalettir.'},
    {'term': 'Kapı', 'meaning': 'Rızık kapısına, evlenmeye veya yeni bir hayat başlangıcına işarettir.'},
    {'term': 'Lamba', 'meaning': 'Ümit, irşad edici bir zat, zihin açıklığı ve karanlık işlerin aydınlanmasıdır.'},
    {'term': 'Meyve', 'meaning': 'Mal, evlat ve helal kazançla müjdelenmeye, amellerin karşılığını almaya işarettir.'},
    {'term': 'Namaz', 'meaning': 'Dini selamete, borçlardan kurtulmaya, güvene ve hayırlı bir akıbete yorulur.'},
    {'term': 'Ok', 'meaning': 'Bir yere gönderilecek habere, hedefe ulaşmaya veya sözün tesirine delalettir.'},
    {'term': 'Para', 'meaning': 'Dedikodu veya kısa süreli sıkıntıya işarettir; gümüş para sevinç, kağıt para biraz daha hayırlıdır.'},
    {'term': 'Rüzgar', 'meaning': 'Müjdeli haber, toplumda çıkacak hayırlı değişiklik veya bazen de ilahi bir rahmettir.'},
    {'term': 'Su', 'meaning': 'Hayat, rızık, bereket ve her türlü darlığın gitmesidir. Berrak su her zaman hayırdır.'},
    {'term': 'Şenlik', 'meaning': 'Üzüntüden kurtulmaya, hane içindeki feraha ve sevince işarettir.'},
    {'term': 'Tesbih', 'meaning': 'Takva, zikir, huzur ve salih amellere devam etmeye, sabrın meyvesini almaya yorulur.'},
    {'term': 'Uçmak', 'meaning': 'Yücelmeye, mevki sahibi olmaya, sıkıntılardan uzaklaşmaya veya hayırlı bir seyahate işarettir.'},
    {'term': 'Üzüm', 'meaning': 'Zamanında görüldüyse bol rızık ve kazançtır. Salkım halinde olması toplu maldır.'},
    {'term': 'Vapur', 'meaning': 'Kurtuluşa, selamete ve zorluklardan sonra gelecek ferahlığa delalet eder.'},
    {'term': 'Yağmur', 'meaning': 'Umumi rahmet, bereket ve dertlerin bitmesiyle gelen ferahlıktır.'},
    {'term': 'Yılan', 'meaning': 'Gizli bir düşmana, bazen de nefse hakim olma uyarısına işarettir.'},
    {'term': 'Yıldız', 'meaning': 'Alimlere, rehber kimselere, yüce mertebelere ve duaların kabulüne delalet eder.'},
    {'term': 'Zeytin', 'meaning': 'Bereket, helal rızık, hidayete erme ve uzun ömre delalettir.'},
    {'term': 'Abdest', 'meaning': 'Sıkıntılardan temizlenmeye, duaların kabulüne ve manevi koruma altına girmeye işarettir.'},
    {'term': 'Bebek', 'meaning': 'Müjdeli haber, yeni başlangıçlar, hane içindeki neşe ve berekettir.'},
    {'term': 'Çay', 'meaning': 'Huzurlu bir meclise, dostlarla sohbete ve ferahlığa yorulur.'},
    {'term': 'Kitap', 'meaning': 'İlim, müjde, kuvvet ve hikmet sahibi bir hayata işarettir.'},
  ];

  @override
  void initState() {
    super.initState();
    _filteredDictionary = _dictionary;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void _filterDictionary(String query) {
    setState(() {
      _filteredDictionary = _dictionary
          .where((item) => item['term']!.toLocaleLowerCase('tr').contains(query.toLocaleLowerCase('tr')))
          .toList();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dreamController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFF4B0082);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(PhosphorIcons.caretLeft(), color: purple),
        ),
        title: Text("Rüya Tabiri", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: purple)),
      ),
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          if (notification.scrollDelta != null && notification.scrollDelta! > 10) {
            if (_isSearchExpanded || FocusScope.of(context).hasFocus) {
              FocusScope.of(context).unfocus();
              setState(() => _isSearchExpanded = false);
            }
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInputSection(purple),
              _buildDictionaryHeader(purple),
              _buildDictionaryList(purple),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(Color purple) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4B0082), Color(0xFF6A1B9A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: purple.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(PhosphorIcons.sparkle(PhosphorIconsStyle.fill), color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Text(
                  "Rüyanızı Anlatın",
                  style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _dreamController,
                    enabled: false,
                    maxLines: 5,
                    style: GoogleFonts.inter(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Rüyanızı detaylıca anlatın...",
                      hintStyle: GoogleFonts.inter(color: Colors.white30),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Yakında Kumo ile...",
                      style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: purple),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.5),
                  foregroundColor: purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text("Yapay Zeka Hazırlanıyor...".toLocaleUpperCase('tr'), style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDictionaryHeader(Color purple) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(PhosphorIcons.bookOpen(), color: purple, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "İslami Rüya Sözlüğü",
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF2D3436)),
            ),
          ),
          _buildExpandingSearch(purple),
        ],
      ),
    );
  }

  Widget _buildExpandingSearch(Color purple) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isSearchExpanded ? 200 : 40,
      child: _isSearchExpanded
          ? TextField(
              controller: _searchController,
              onChanged: _filterDictionary,
              autofocus: true,
              style: GoogleFonts.inter(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Ara...",
                filled: true,
                fillColor: purple.withValues(alpha: 0.05),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _isSearchExpanded = false;
                      _searchController.clear();
                      _filterDictionary('');
                    });
                  },
                  child: const Icon(Icons.close, size: 16),
                ),
              ),
            )
          : IconButton(
              icon: Icon(PhosphorIcons.magnifyingGlass(), color: purple, size: 24),
              onPressed: () => setState(() => _isSearchExpanded = true),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
    );
  }

  Widget _buildDictionaryList(Color purple) {
    if (_filteredDictionary.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(PhosphorIcons.magnifyingGlass(), size: 48, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text("Aradığınız terim bulunamadı.", style: GoogleFonts.inter(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredDictionary.length,
      itemBuilder: (context, index) {
        final item = _filteredDictionary[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Text(
              item['term']![0],
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: purple.withValues(alpha: 0.3)),
            ),
            title: Text(
              item['term']!,
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF2D3436)),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  item['meaning']!,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
