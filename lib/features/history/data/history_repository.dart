// TR: KUBBE V4 History Repository - V1'den miras alındı
// EN: KUBBE V4 History Repository - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki 'osmanli_verileri.dart' içeriğini (Padişahlar, Alimler) bu repository içine tıkır tıkır aktar
// EN: Transfer V1's 'osmanli_verileri.dart' content (Sultans, Scholars) exactly to this repository
// TR: Her veriye V4 tasarımı için uygun placeholder görsel yolları ata
// EN: Assign appropriate placeholder image paths for V4 design for each data

import '../models/history_figure.dart';

/// TR: KUBBE V4 History Repository Sınıfı
/// EN: KUBBE V4 History Repository Class
/// TR: V1'deki 'osmanli_verileri.dart' içeriğini modernize eder
/// EN: Modernizes V1's 'osmanli_verileri.dart' content
/// TR: Tarihi şahsiyet verilerini yönetir
/// EN: Manages historical figure data
/// TR: Instagram/Pinterest tarzı görsel akış için optimize edilmiş
/// EN: Optimized for Instagram/Pinterest style visual flow
/// TR: V1'den miras alınan veri yapısı V4 estetiğiyle modernize edildi
/// EN: Data structure inherited from V1 modernized with V4 aesthetics
class HistoryRepository {
  // TR: Singleton pattern - V1'den miras alındı
  // EN: Singleton pattern - Inherited from V1
  static final HistoryRepository _instance = HistoryRepository._internal();

  // TR: Factory constructor
  // EN: Factory constructor
  factory HistoryRepository() => _instance;

  // TR: Private constructor
  // EN: Private constructor
  HistoryRepository._internal();

  // TR: Tüm tarihi şahsiyetler - V1'den miras alındı
  // EN: All historical figures - Inherited from V1
  final List<HistoryFigure> _allFigures = [];

  // TR: Repository başlatma - V1'den miras alındı
  // EN: Initialize repository - Inherited from V1
  void initialize() {
    if (_allFigures.isNotEmpty) {
      return; // TR: Zaten başlatılmışsa // EN: Already initialized
    }

    // TR: V1'den miras alınan Osmanlı padişahları
    // EN: Ottoman sultans inherited from V1
    _allFigures.addAll(_osmanliSultans);

    // TR: V1'den miras alınan İslam alimleri
    // EN: Islamic scholars inherited from V1
    _allFigures.addAll(_islamicScholars);

    // TR: V1'den miras alınan Osmanlı şairleri
    // EN: Ottoman poets inherited from V1
    _allFigures.addAll(_ottomanPoets);

    // TR: V1'den miras alınan Osmanlı komutanları
    // EN: Ottoman commanders inherited from V1
    _allFigures.addAll(_ottomanCommanders);
  }

  // TR: Tüm şahsiyetleri al - V1'den miras alındı
  // EN: Get all figures - Inherited from V1
  List<HistoryFigure> getAllFigures() {
    initialize();
    return List.unmodifiable(_allFigures);
  }

  // TR: Kategoriye göre şahsiyetleri al - V1'den miras alındı
  // EN: Get figures by category - Inherited from V1
  List<HistoryFigure> getFiguresByCategory(HistoryCategory category) {
    initialize();
    return _allFigures.filterByCategory(category);
  }

  // TR: ID'ye göre şahsiyet al - V1'den miras alındı
  // EN: Get figure by ID - Inherited from V1
  HistoryFigure? getFigureById(String id) {
    initialize();
    try {
      return _allFigures.firstWhere((figure) => figure.id == id);
    } catch (e) {
      return null;
    }
  }

  // TR: İsme göre şahsiyet ara - V1'den miras alındı
  // EN: Search figure by name - Inherited from V1
  List<HistoryFigure> searchFigures(String query) {
    initialize();
    return _allFigures.searchByKeywords(query);
  }

  // TR: Rastgele şahsiyetler al - V1'den miras alındı
  // EN: Get random figures - Inherited from V1
  List<HistoryFigure> getRandomFigures(int count) {
    initialize();
    return _allFigures.randomSelection(count);
  }

  // TR: Önemli şahsiyetleri al - V1'den miras alındı
  // EN: Get important figures - Inherited from V1
  List<HistoryFigure> getImportantFigures() {
    initialize();
    return _allFigures.where((figure) => figure.importanceLevel >= 3).toList();
  }

  // TR: V1'den miras alınan Osmanlı padişahları
  // EN: Ottoman sultans inherited from V1
  List<HistoryFigure> get _osmanliSultans => [
        const HistoryFigure(
          id: 'sultan_1',
          name: 'Fatih Sultan Mehmet',
          period: '1451-1481',
          title: 'Fatih Sultan',
          achievements: [
            'İstanbul\'u fethetti',
            'Yeniçeri ordusunu kurdu',
            'Kanunnameleri hazırladı',
            'Sanat ve bilimi destekledi',
          ],
          imageUrl: 'assets/images/sultans/fatih_sultan_mehmet.jpg',
          shortSummary: 'İstanbul\'u fetheden büyük Osmanlı padişahı',
          description:
              'Fatih Sultan Mehmet, 1453 yılında İstanbul\'u fethederek Bizans İmparatorluğu\'na son verdi ve Osmanlı İmparatorluğu\'nu zirveye taşıdı. Eğitime, sanata ve bilime büyük önem veren bir hükümdardı.',
          category: HistoryCategory.sultans,
          birthDate: '1432',
          deathDate: '1481',
          figureType: FigureType.sultan,
          importanceLevel: 5,
        ),
        const HistoryFigure(
          id: 'sultan_2',
          name: 'Kanuni Sultan Süleyman',
          period: '1520-1566',
          title: 'Kanuni',
          achievements: [
            'Kanunları ile ünlü',
            'Avrupa\'ya seferler düzenledi',
            'Sanat ve mimariyi destekledi',
            'Devleti zirveye taşıdı',
          ],
          imageUrl: 'assets/images/sultans/kanuni_sultan_suleyman.jpg',
          shortSummary: 'Kanunları ile tanınan büyük Osmanlı padişahı',
          description:
              'Kanuni Sultan Süleyman, Osmanlı İmparatorluğu\'nun en parlak dönemini yaşattı. Kanunlarıyla adından bahsettiren, devleti zirveye taşıyan ve sanata büyük destek veren bir hükümdardı.',
          category: HistoryCategory.sultans,
          birthDate: '1494',
          deathDate: '1566',
          figureType: FigureType.sultan,
          importanceLevel: 5,
        ),
        const HistoryFigure(
          id: 'sultan_3',
          name: 'Yavuz Sultan Selim',
          period: '1512-1520',
          title: 'Yavuz',
          achievements: [
            'Safevî devletini yendi',
            'Memlûk Devleti\'ni yıktı',
            'Halife unvanını aldı',
            'İslam dünyasına hükmetti',
          ],
          imageUrl: 'assets/images/sultans/yavuz_sultan_selim.jpg',
          shortSummary: 'İki denizde birden hükümdar olan padişah',
          description:
              'Yavuz Sultan Selim, Safevî ve Memlûk devletlerini yenerek İslam dünyasında büyük bir güç haline geldi. "Selim-i Yavuz" unvanıyla tanınır.',
          category: HistoryCategory.sultans,
          birthDate: '1470',
          deathDate: '1520',
          figureType: FigureType.sultan,
          importanceLevel: 4,
        ),
        const HistoryFigure(
          id: 'sultan_4',
          name: 'II. Abdülhamid',
          period: '1876-1909',
          title: 'Ulu Hakan',
          achievements: [
            'Demiryolları inşa etti',
            'Eğitim reformları yaptı',
            'Askeri modernizasyon',
            'Bağımsızlık mücadelesi',
          ],
          imageUrl: 'assets/images/sultans/abdulhamid_2.jpg',
          shortSummary: 'Osmanlı\'yı modernleştiren son büyük padişah',
          description:
              'II. Abdülhamid, Osmanlı İmparatorluğu\'nu modernleştirmek için büyük çabalar harcadı. Demiryollar, telegraf ve eğitim alanlarında önemli reformlar yaptı.',
          category: HistoryCategory.sultans,
          birthDate: '1842',
          deathDate: '1918',
          figureType: FigureType.sultan,
          importanceLevel: 4,
        ),
      ];

  // TR: V1'den miras alınan İslam alimleri
  // EN: Islamic scholars inherited from V1
  List<HistoryFigure> get _islamicScholars => [
        const HistoryFigure(
          id: 'scholar_1',
          name: 'İmam-ı Azam Ebu Hanife',
          period: '699-767',
          title: 'İmam-ı Azam',
          achievements: [
            'Hanefi mezhebinin kurucusu',
            'Fıkhın babası olarak kabul edilir',
            'Binlerce öğrenci yetiştirdi',
            'İslam hukukuna büyük katkı',
          ],
          imageUrl: 'assets/images/scholars/ebu_hanife.jpg',
          shortSummary: 'Hanefi mezhebinin kurucusu ve fıkhın babası',
          description:
              'İmam-ı Azam Ebu Hanife, İslam hukukunun en önemli alimlerinden biridir. Hanefi mezhebinin kurucusu olarak kabul edilir ve eserleri günümüzde de okunmaktadır.',
          category: HistoryCategory.scholars,
          birthDate: '699',
          deathDate: '767',
          figureType: FigureType.scholar,
          importanceLevel: 5,
        ),
        const HistoryFigure(
          id: 'scholar_2',
          name: 'İmam-ı Gazali',
          period: '1058-1111',
          title: 'Hüccetü\'l-İslam',
          achievements: [
            'İhya-u Ulumiddin yazdı',
            'Felsefe ile ilahiyatı birleştirdi',
            'Sufizmi sistemleştirdi',
            'Tasavvufa büyük katkı',
          ],
          imageUrl: 'assets/images/scholars/imam_gazali.jpg',
          shortSummary: 'İhya-u Ulumiddin\'in yazarı ve büyük İslam alimi',
          description:
              'İmam-ı Gazali, İslam düşünce tarihinde en önemli şahsiyetlerden biridir. "İhya-u Ulumiddin" adlı eseriyle İslam dünyasında büyük etki bırakmıştır.',
          category: HistoryCategory.scholars,
          birthDate: '1058',
          deathDate: '1111',
          figureType: FigureType.scholar,
          importanceLevel: 5,
        ),
        const HistoryFigure(
          id: 'scholar_3',
          name: 'Mevlana Celaleddin-i Rumi',
          period: '1207-1273',
          title: 'Mevlana',
          achievements: [
            'Mesnevi yazdı',
            'Sema ayinini başlattı',
            'Evrensel sevgi mesajı',
            'Batı dünyasında etkin',
          ],
          imageUrl: 'assets/images/scholars/mevlana.jpg',
          shortSummary: 'Mesnevi\'nin yazarı ve evrensel düşünür',
          description:
              'Mevlana Celaleddin-i Rumi, "Mesnevi" adlı eseriyle İslam tasavvufunda derin izler bırakmıştır. Sevgi ve hoşgörü mesajıyla dünyada tanınan bir düşünürdür.',
          category: HistoryCategory.scholars,
          birthDate: '1207',
          deathDate: '1273',
          figureType: FigureType.scholar,
          importanceLevel: 5,
        ),
        const HistoryFigure(
          id: 'scholar_4',
          name: 'İbn-i Sina',
          period: '980-1037',
          title: 'Şeyhü\'r-Rais',
          achievements: [
            'El-Kanun fi\'t-Tıb yazdı',
            'Felsefede öncü',
            'Tıp bilimine katkı',
            'Batı tıbbına etki',
          ],
          imageUrl: 'assets/images/scholars/ibni_sina.jpg',
          shortSummary: 'Tıp ve felsefenin büyük İslam alimi',
          description:
              'İbn-i Sina, "El-Kanun fi\'t-Tıb" adlı eseriyle tıp tarihinde önemli bir yer tutar. Hem tıp hem de felsefe alanlarında çığır açan çalışmalara imza atmıştır.',
          category: HistoryCategory.scholars,
          birthDate: '980',
          deathDate: '1037',
          figureType: FigureType.scholar,
          importanceLevel: 5,
        ),
      ];

  // TR: V1'den miras alınan Osmanlı şairleri
  // EN: Ottoman poets inherited from V1
  List<HistoryFigure> get _ottomanPoets => [
        const HistoryFigure(
          id: 'poet_1',
          name: 'Yunus Emre',
          period: '1238-1320',
          title: 'Derviş Şair',
          achievements: [
            'Türkçe şiirin öncüsü',
            'Tasavvuf şiiri yazdı',
            'Halk sevgisiyle tanındı',
            'Evrensel mesajlar',
          ],
          imageUrl: 'assets/images/poets/yunus_emre.jpg',
          shortSummary: 'Türkçe şiirin ve tasavvufun büyük şairi',
          description:
              'Yunus Emre, Türkçe şiirin en önemli temsilcilerinden biridir. Tasavvufi şiirleriyle halkın kalbinde yer edinmiş ve evrensel mesajlar vermiştir.',
          category: HistoryCategory.poets,
          birthDate: '1238',
          deathDate: '1320',
          figureType: FigureType.poet,
          importanceLevel: 5,
        ),
        const HistoryFigure(
          id: 'poet_2',
          name: 'Fuzuli',
          period: '1483-1556',
          title: 'Divan Şairi',
          achievements: [
            'Leyla ile Mecnun yazdı',
            'Divan şiirinin ustası',
            'Arapça, Farsça, Türkçe yazdı',
            'Şiirde mükemmeliyet',
          ],
          imageUrl: 'assets/images/poets/fuzuli.jpg',
          shortSummary: 'Leyla ile Mecnun\'un yazarı ve divan şiiri ustası',
          description:
              'Fuzuli, "Leyla ile Mecnun" mesnevisiyle Türk edebiyatında önemli bir yer tutar. Divan şiirinin en büyük ustalarından biri olarak kabul edilir.',
          category: HistoryCategory.poets,
          birthDate: '1483',
          deathDate: '1556',
          figureType: FigureType.poet,
          importanceLevel: 4,
        ),
        const HistoryFigure(
          id: 'poet_3',
          name: 'Baki',
          period: '1526-1600',
          title: 'Sultan Şairleri',
          achievements: [
            'Divan şiirinin sultanı',
            'Kasideleriyle ünlü',
            'Osmanlı saray şairi',
            'Şiirde incelik',
          ],
          imageUrl: 'assets/images/poets/baki.jpg',
          shortSummary: 'Divan şiirinin sultanı olarak bilinen şair',
          description:
              'Baki, divan şiirinin en önemli şairlerinden biridir. "Sultan-ı Şairan" unvanıyla tanınır ve kasideleriyle divan şiirine yeni bir boyut kazandırmıştır.',
          category: HistoryCategory.poets,
          birthDate: '1526',
          deathDate: '1600',
          figureType: FigureType.poet,
          importanceLevel: 4,
        ),
      ];

  // TR: V1'den miras alınan Osmanlı komutanları
  // EN: Ottoman commanders inherited from V1
  List<HistoryFigure> get _ottomanCommanders => [
        const HistoryFigure(
          id: 'commander_1',
          name: 'Barbaros Hayrettin Paşa',
          period: '1478-1546',
          title: 'Kaptan-ı Derya',
          achievements: [
            'Akdeniz\'e hükmetti',
            'Cezayir\'i fethetti',
            'Donanma kurdu',
            'Haşmetli komutan',
          ],
          imageUrl: 'assets/images/commanders/barbaros_hayrettin.jpg',
          shortSummary: 'Akdeniz\'in kaptanı ve büyük denizci',
          description:
              'Barbaros Hayrettin Paşa, Osmanlı donanmasının kurucusu ve en büyük denizcilerinden biridir. Akdeniz\'e hükmederek Osmanlı\'yı deniz gücü haline getirdi.',
          category: HistoryCategory.commanders,
          birthDate: '1478',
          deathDate: '1546',
          figureType: FigureType.commander,
          importanceLevel: 5,
        ),
        const HistoryFigure(
          id: 'commander_2',
          name: 'Sultan Alparslan',
          period: '1029-1072',
          title: 'Sultan-ı Azam',
          achievements: [
            'Malazgirt zaferi',
            'Anadolu\'yu açtı',
            'Selçuklu devletini büyüttü',
            'İslam ordularını yönetti',
          ],
          imageUrl: 'assets/images/commanders/alparslan.jpg',
          shortSummary: 'Malazgirt zaferinin kahramanı',
          description:
              'Sultan Alparslan, 1071 Malazgirt zaferiyle Anadolu\'nun kapılarını Türklere açan büyük komutandır. Selçuklu devletini zirveye taşıdı.',
          category: HistoryCategory.commanders,
          birthDate: '1029',
          deathDate: '1072',
          figureType: FigureType.commander,
          importanceLevel: 5,
        ),
        const HistoryFigure(
          id: 'commander_3',
          name: 'Mehmet the Conqueror',
          period: '1430-1481',
          title: 'Fatih',
          achievements: [
            'İstanbul\'u fethetti',
            'Yeniçeri ordusu kurdu',
            'Askeri deha',
            'Stratejist komutan',
          ],
          imageUrl: 'assets/images/commanders/fatih_commander.jpg',
          shortSummary: 'İstanbul\'u fetheden askeri deha',
          description:
              'Mehmet the Conqueror, sadece İstanbul\'u fethetmekle kalmayıp aynı zamanda askeri dehasıyla da tanınan büyük bir komutandır.',
          category: HistoryCategory.commanders,
          birthDate: '1430',
          deathDate: '1481',
          figureType: FigureType.commander,
          importanceLevel: 5,
        ),
      ];

  // TR: İstatistikler - V1'den miras alındı
  // EN: Statistics - Inherited from V1
  Map<String, int> getStatistics() {
    initialize();
    return {
      'total_figures': _allFigures.length,
      'sultans': _allFigures.getCountByCategory(HistoryCategory.sultans),
      'scholars': _allFigures.getCountByCategory(HistoryCategory.scholars),
      'poets': _allFigures.getCountByCategory(HistoryCategory.poets),
      'commanders': _allFigures.getCountByCategory(HistoryCategory.commanders),
      'important_figures':
          _allFigures.where((f) => f.importanceLevel >= 3).length,
    };
  }

  // TR: Veri yenileme - V1'den miras alındı
  // EN: Data refresh - Inherited from V1
  void refreshData() {
    _allFigures.clear();
    initialize();
  }

  // TR: Veri doğrulama - V1'den miras alındı
  // EN: Data validation - Inherited from V1
  bool validateData() {
    initialize();

    // TR: Boş ID kontrolü
    // EN: Empty ID check
    for (final figure in _allFigures) {
      if (figure.id.isEmpty) return false;
      if (figure.name.isEmpty) return false;
      if (figure.period.isEmpty) return false;
    }

    // TR: Tekrarlayan ID kontrolü
    // EN: Duplicate ID check
    final ids = _allFigures.map((f) => f.id).toSet();
    if (ids.length != _allFigures.length) return false;

    return true;
  }

  // TR: Placeholder görsel yolları - V4 yeniliği
  // EN: Placeholder image paths - V4 innovation
  String getPlaceholderImageUrl(HistoryCategory category) {
    switch (category) {
      case HistoryCategory.sultans:
        return 'assets/images/placeholders/sultan_placeholder.jpg';
      case HistoryCategory.scholars:
        return 'assets/images/placeholders/scholar_placeholder.jpg';
      case HistoryCategory.poets:
        return 'assets/images/placeholders/poet_placeholder.jpg';
      case HistoryCategory.commanders:
        return 'assets/images/placeholders/commander_placeholder.jpg';
      case HistoryCategory.artists:
        return 'assets/images/placeholders/artist_placeholder.jpg';
      case HistoryCategory.scientists:
        return 'assets/images/placeholders/scientist_placeholder.jpg';
      case HistoryCategory.other:
        return 'assets/images/placeholders/other_placeholder.jpg';
    }
  }

  // TR: Görsel yollarını doğrula - V4 yeniliği
  // EN: Validate image paths - V4 innovation
  List<String> validateImagePaths() {
    initialize();
    final invalidPaths = <String>[];

    for (final figure in _allFigures) {
      if (!figure.hasValidImageUrl) {
        invalidPaths.add('${figure.name}: ${figure.imageUrl}');
      }
    }

    return invalidPaths;
  }

  // TR: Arama önerileri - V4 yeniliği
  // EN: Search suggestions - V4 innovation
  List<String> getSearchSuggestions() {
    initialize();
    final suggestions = <String>[];

    // TR: İsimler
    // EN: Names
    suggestions.addAll(_allFigures.map((f) => f.name));

    // TR: Kategoriler
    // EN: Categories
    final categories = _allFigures.map((f) => f.category).toSet();
    suggestions.addAll(categories.map((c) => c.categoryDisplayName));

    // TR: Şahsiyet türleri
    // EN: Figure types
    final figureTypes = _allFigures.map((f) => f.figureType).toSet();
    suggestions.addAll(figureTypes.map((t) => t.figureTypeDisplayName));

    // TR: Dönemler
    // EN: Periods
    suggestions.addAll(_allFigures.map((f) => f.period));

    return suggestions.toSet().take(20).toList();
  }

  // TR: Öne çıkan şahsiyetler - V4 yeniliği
  // EN: Featured figures - V4 innovation
  List<HistoryFigure> getFeaturedFigures() {
    initialize();
    final featured = _allFigures.where((f) => f.importanceLevel >= 4).toList();
    featured.sort((a, b) => b.importanceLevel.compareTo(a.importanceLevel));
    return featured.take(6).toList();
  }

  // TR: Yeni eklenenler - V4 yeniliği
  // EN: Recently added - V4 innovation
  List<HistoryFigure> getRecentlyAdded() {
    initialize();
    // TR: V4'de yeni eklenenleri simüle et
    // EN: Simulate newly added in V4
    final figures = List<HistoryFigure>.from(_allFigures);
    figures.shuffle();
    return figures.take(4).toList();
  }

  // TR: Popüler şahsiyetler - V4 yeniliği
  // EN: Popular figures - V4 innovation
  List<HistoryFigure> getPopularFigures() {
    initialize();
    // TR: Önem derecesine göre popülerleri al
    // EN: Get popular by importance level
    final popular = _allFigures.where((f) => f.importanceLevel >= 3).toList();
    popular.sort((a, b) => b.importanceLevel.compareTo(a.importanceLevel));
    return popular.take(8).toList();
  }
}
