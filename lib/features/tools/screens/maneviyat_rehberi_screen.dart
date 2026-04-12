import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// [Removed unused zikirmatik_screen import]


class ManeviyatItem {
  final String category;
  final String title;
  final String content;
  final String? arabic;
  final String? pronunciation;
  final int? targetCount;

  ManeviyatItem({
    required this.category,
    required this.title,
    required this.content,
    this.arabic,
    this.pronunciation,
    this.targetCount,
  });
}

class ManeviyatRehberiScreen extends StatefulWidget {
  const ManeviyatRehberiScreen({super.key});

  @override
  State<ManeviyatRehberiScreen> createState() => _ManeviyatRehberiScreenState();

  // [Statik veritabanı: Ana ekran ve diğer ekranlardan erişim için - Static database for deep-linking]
  static final List<ManeviyatItem> database = [
    // --- DUALAR ---
    ManeviyatItem(
      category: 'Dualar',
      title: 'Yemek Duası',
      content: 'Rabbimize verdiği nimetler için teşekkür ederiz. Peygamberimiz (sav) yemekten sonra bu duayı okurdu.',
      arabic: 'اَلْحَمْدُ لِلّٰهِ الَّذٖى اَطْعَمَنَا وَسَقَانَا وَجECَعَلَنَا مِنَ الْمُسْلِمٖينَ',
      pronunciation: 'Elhamdülillahillezi et’amena ve sekana ve cealena minel müslimin.',
    ),
    ManeviyatItem(
      category: 'Dualar',
      title: 'Seyahat Duası',
      content: 'Yolculuğa çıkarken Allah’ın korumasına sığınmak için okunur.',
      arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنقALIBُونَ',
      pronunciation: 'Sübhânellezî sahhara lenâ hâzâ vemâ künnâ lehû mukrinîn. Ve innâ ilâ rabbinâ lemünkalibûn.',
    ),
    ManeviyatItem(
      category: 'Dualar',
      title: 'Evden Çıkış Duası',
      content: 'Evin bereketini ve dışarıdaki şerlerden korunmayı dileriz.',
      arabic: 'بِسْمِ اللّٰهِ تَوَكَّلْتُ عَلَى اللّٰهِ لَا حَوْلَ وَلَا قُوَّةَ اِلَّا بِاللّٰهِ',
      pronunciation: 'Bismillâhi tevekkeltü alallâh, lâ havle velâ kuvvete illâ billâh.',
    ),
    ManeviyatItem(
      category: 'Dualar',
      title: 'Camiye Giriş Duası',
      content: 'Allah’ın rahmet kapılarını açması için okunur.',
      arabic: 'اَللّٰهُمَّ افْتَحْ لٖى اَبْوَABَ رَحْمَتِكَ',
      pronunciation: 'Allahümme’ftah lî ebvâbe rahmetik.',
    ),
    ManeviyatItem(
      category: 'Dualar',
      title: 'Sıkıntı Duası',
      content: 'Zor zamanlarda ferahlık dilemek için okunur.',
      arabic: 'لَا اِلٰهَ اِلَّا اَنْتَ سُبْحَانَكَ اِنّٖى كُنْتُ مِنَ الظَّALİMٖينَ',
      pronunciation: 'La ilahe illa ente sübhaneke inni küntü minez-zalimin.',
    ),
    ManeviyatItem(
      category: 'Dualar',
      title: 'Uyku Öncesi Duası',
      content: 'Geceyi Allah’ın adıyla bitirmek için okunur.',
      arabic: 'بِاسْمِكَ اللّٰهُمَّ اَمُوتُ وَاَحْيٰى',
      pronunciation: 'Bismikellahümme emütü ve ahya.',
    ),
    ManeviyatItem(
      category: 'Dualar',
      title: 'Şifa Duası',
      content: 'Hastalıklar için Allah’tan şifa dileme duasıdır.',
      arabic: 'اَذْهِBİ الْبAْسَ رَبَّ النَّاسِ اِشْفِ اَنْتَ الشَّAFٖى لَا شِفَاءَ اِلَّا شِفَاؤُكَ شِفَاءً لَا يُغَADİRُ سَقَمًا',
      pronunciation: 'Ezhibil-be’se Rabben-nâsi işfi ente’ş-şâfî, lâ şifâe illâ şifâüke şifâen lâ yüğâdiru sekamâ.',
    ),

    // --- HADİSLER ---
    ManeviyatItem(
      category: 'Hadisler',
      title: 'Niyet Hadisi',
      content: 'Ameller ancak niyetlere göredir; herkes niyetinin karşılığını alır. (Buhâri, Müslim)',
    ),
    ManeviyatItem(
      category: 'Hadisler',
      title: 'Temizlik İmandandır',
      content: 'Temizlik imanın yarısıdır. (Müslim)',
    ),
    ManeviyatItem(
      category: 'Hadisler',
      title: 'Komşu Hakkı',
      content: 'Cebrail bana komşu hakkını o kadar tavsiye etti ki, nerdeyse komşuyu komşuya mirasçı kılacak sandım. (Buhâri)',
    ),

    // --- İLMİHAL ---
    ManeviyatItem(
      category: 'İlmihal',
      title: 'İmanın Şartları (6)',
      content: '1. Allah\'a inanmak\n2. Meleklere inanmak\n3. Kitaplara inanmak\n4. Peygamberlere inanmak\n5. Ahiret gününe inanmak\n6. Kadere (Hayır ve şerrin Allah\'tan geldiğine) inanmak',
    ),
    ManeviyatItem(
      category: 'İlmihal',
      title: 'İslamın Şartları (5)',
      content: '1. Kelime-i Şehadet getirmek\n2. Namaz kılmak\n3. Zekat vermek\n4. Oruç tutmak\n5. Hacca gitmek',
    ),
    ManeviyatItem(
      category: 'İlmihal',
      title: 'Abdestin Farzları (4)',
      content: '1. Yüzü yıkamak\n2. Kolları dirseklerle beraber yıkamak\n3. Başın dörtte birini meshetmek\n4. Ayakları topuklarla beraber yıkamak',
    ),
    
    // --- MEDENİYET ---
    ManeviyatItem(category: 'Medeniyet', title: 'Mescid-i Haram', content: 'Yeryüzünde inşa edilen ilk mescit ve İslamın en kutsal mekanıdır.'),
    ManeviyatItem(category: 'Medeniyet', title: 'Endülüs - El Hamra', content: 'İslam mimarisinin zirve noktalarından biri olan Gırnata\'daki muazzam saray.'),
    ManeviyatItem(category: 'Medeniyet', title: 'Selimiye Camii', content: 'Mimar Sinan\'ın "Ustalık Eserim" dediği, Edirne\'deki eşsiz yapı.'),

    // --- SÖZLER ---
    ManeviyatItem(category: 'Sözler', title: 'Hz. Mevlana', content: 'Gel, ne olursan ol, yine gel. Bizim dergahımız ümitsizlik dergahı değildir.'),
    ManeviyatItem(category: 'Sözler', title: 'Yunus Emre', content: 'Yaratılanı severiz, Yaradan\'dan ötürü.'),
  ];
}

class _ManeviyatRehberiScreenState extends State<ManeviyatRehberiScreen> {
  String _selectedCategory = 'Tümü';
  final List<String> _categories = ['Tümü', 'Dualar', 'Hadisler', 'İlmihal', 'Medeniyet', 'Sözler'];
  Set<String> _completedItems = {};

  @override
  void initState() {
    super.initState();
    _loadCompletionStatus();
  }

  Future<void> _loadCompletionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _completedItems = (prefs.getStringList('maneviyat_completed') ?? []).toSet();
    });
  }

  Future<void> _toggleCompletion(String title) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_completedItems.contains(title)) {
        _completedItems.remove(title);
      } else {
        _completedItems.add(title);
      }
    });
    await prefs.setStringList('maneviyat_completed', _completedItems.toList());
  }

  @override
  Widget build(BuildContext context) {
    List<ManeviyatItem> filteredItems = ManeviyatRehberiScreen.database.where((item) {
      if (_selectedCategory == 'Tümü') return true;
      return item.category == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B0082),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
        title: Text(
          "Maneviyat Rehberi",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                final color = _getCategoryColor(item.category);
                return _buildManeviyatCard(item, color);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              selectedColor: const Color(0xFF4B0082),
              labelStyle: GoogleFonts.outfit(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildManeviyatCard(ManeviyatItem item, Color color) {
    final bool isCompleted = _completedItems.contains(item.title);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManeviyatDetailScreen(
              item: item,
              isCompleted: isCompleted,
              onComplete: () => _toggleCompletion(item.title),
            ),
          ),
        ),
        leading: Icon(_getCategoryIcon(item.category), color: color),
        title: Text(item.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        trailing: isCompleted ? const Icon(Icons.check_circle, color: Colors.amber) : const Icon(Icons.chevron_right),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Dualar': return PhosphorIcons.handsPraying();
      case 'Hadisler': return PhosphorIcons.scroll();
      case 'İlmihal': return PhosphorIcons.bookOpen();
      case 'Medeniyet': return PhosphorIcons.bank();
      case 'Sözler': return PhosphorIcons.quotes();
      default: return PhosphorIcons.info();
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Dualar': return const Color(0xFF4B0082);
      case 'Hadisler': return const Color(0xFF191970);
      case 'İlmihal': return const Color(0xFF006400);
      case 'Medeniyet': return const Color(0xFF7B3F00);
      case 'Sözler': return const Color(0xFFB8860B);
      default: return const Color(0xFF4B0082);
    }
  }
}

class ManeviyatDetailScreen extends StatefulWidget {
  final ManeviyatItem item;
  final bool isCompleted;
  final VoidCallback onComplete;

  const ManeviyatDetailScreen({
    super.key,
    required this.item,
    required this.isCompleted,
    required this.onComplete,
  });

  @override
  State<ManeviyatDetailScreen> createState() => _ManeviyatDetailScreenState();
}

class _ManeviyatDetailScreenState extends State<ManeviyatDetailScreen> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(widget.item.category);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: color),
        ),
        title: Text(widget.item.title, style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (widget.item.arabic != null)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: color.withValues(alpha: 0.1)),
              ),
              child: Text(
                widget.item.arabic!, 
                textAlign: TextAlign.center, 
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(fontSize: 28, height: 1.8, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            widget.item.category == 'Dualar' ? "Anlamı ve Fazileti:" : "Açıklama:",
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          Text(widget.item.content, style: GoogleFonts.inter(fontSize: 17, height: 1.7, color: Colors.black87)),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              widget.onComplete();
              setState(() => _isCompleted = !_isCompleted);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCompleted ? const Color(0xFFFFD700) : const Color(0xFFF3F4F6),
              foregroundColor: _isCompleted ? Colors.white : Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, size: 24),
                const SizedBox(width: 12),
                Text(_isCompleted ? "Tamamlandı" : "Okudum / Tamamladım", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Dualar': return const Color(0xFF4B0082);
      case 'Hadisler': return const Color(0xFF191970);
      case 'İlmihal': return const Color(0xFF006400);
      case 'Medeniyet': return const Color(0xFF7B3F00);
      case 'Sözler': return const Color(0xFFB8860B);
      default: return const Color(0xFF4B0082);
    }
  }
}
