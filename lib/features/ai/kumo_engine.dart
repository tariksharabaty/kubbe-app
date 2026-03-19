// TR: KUBBE V4 Kumo AI Engine - V1'den miras alındı
// EN: KUBBE V4 Kumo AI Engine - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki 50 soruluk soru-cevap mantığını ve kategori sistemini (Zekat, Namaz, Ahlak vb.) port et
// EN: Port V1's 50 question-answer logic and category system (Zakat, Prayer, Morality, etc.)
// TR: KUBBE V4 için zeka motoru ve soru-cevap sistemi
// EN: Intelligence engine and question-answer system for KUBBE V4

import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TR: KUBBE V4 Kumo AI Engine Sınıfı
/// EN: KUBBE V4 Kumo AI Engine Class
/// TR: V1'deki soru-cevap mantığını modernize eder
/// EN: Modernizes V1's question-answer logic
/// TR: 50 soruluk zeka motoru ve kategori sistemi
/// EN: 50 question intelligence engine and category system
/// TR: Zekat, Namaz, Ahlak, Tarih, İlim kategorileri
/// EN: Zakat, Prayer, Morality, History, Knowledge categories
/// TR: V1'den miras alınan mantık V4 estetiğiyle modernize edildi
/// EN: Logic inherited from V1 modernized with V4 aesthetics
class KumoEngine {
  // TR: Singleton pattern - V1'den miras alındı
  // EN: Singleton pattern - Inherited from V1
  static final KumoEngine _instance = KumoEngine._internal();

  // TR: Factory constructor
  // EN: Factory constructor
  factory KumoEngine() => _instance;

  // TR: Private constructor
  // EN: Private constructor
  KumoEngine._internal();

  // TR: V1'den miras alınan soru-cevap verileri
  // EN: Question-answer data inherited from V1
  final List<KumoQuestion> _questions = [
    // TR: Zekat kategorisi
    // EN: Zakat category
    const KumoQuestion(
      id: 'zekat_1',
      category: KumoCategory.zekat,
      question: 'Zekatın farz olduğu mal nelerdir?',
      answer:
          'Zekat, bir Müslüman\'ın bir yıl boyunca elinde bulunan ve belirli bir nisaba ulaşan altın, gümüş, ticaret malları, tarım ürünleri, hayvanlar ve toprak gibi malların %2.5\'ini fakirlere vermesidir.',
      difficulty: KumoDifficulty.easy,
      keywords: ['zekat', 'farz', 'mal', 'nisap'],
    ),

    const KumoQuestion(
      id: 'zekat_2',
      category: KumoCategory.zekat,
      question: 'Altın için zekat nisabı nedir?',
      answer:
          'Altın için zekat nisabı 20 dirhem (yaklaşık 85 gram) altındır. Bir yıllık süre sonunda bu miktara ulaşan altından zekat vermek farzdır.',
      difficulty: KumoDifficulty.medium,
      keywords: ['altın', 'nisap', 'zekat', 'dirhem'],
    ),

    const KumoQuestion(
      id: 'zekat_3',
      category: KumoCategory.zekat,
      question: 'Zekat kimlere verilir?',
      answer:
          'Zekat 8 sınıfa verilebilir: 1) Fakirler, 2) Miskinler, 3) Zekat toplayıcıları, 4) Müellefât-ı kalb (kalpleri İslam\'a ısındırılacaklar), 5) Köleler, 6) Borçlular, 7) Allah yolunda cihad edenler, 8) Yolda kalmışlar.',
      difficulty: KumoDifficulty.medium,
      keywords: ['zekat', 'verilecek', 'sınıflar', 'fakir'],
    ),

    const KumoQuestion(
      id: 'zekat_4',
      category: KumoCategory.zekat,
      question: 'Fitre nedir ve kimlere verilir?',
      answer:
          'Fitre, Ramazan Bayramı\'nda her Müslüman\'ın kendi nafakasından fakirlere vermesi gereken bir sadakadır. Fitre, bir kişinin bir günlük yiyeceği kadar gıda maddesi veya bedelidir.',
      difficulty: KumoDifficulty.easy,
      keywords: ['fitre', 'sadaka', 'ramazan', 'fakir'],
    ),

    const KumoQuestion(
      id: 'zekat_5',
      category: KumoCategory.zekat,
      question: 'Zekatın önemi nedir?',
      answer:
          'Zekat, malı temizler, artırır ve bereket getirir. Toplumsal adaleti sağlar, zengin ve fakir arasındaki dengeyi kurar ve Allah\'a şükretmeyi öğretir.',
      difficulty: KumoDifficulty.easy,
      keywords: ['zekat', 'önem', 'bereket', 'adalet'],
    ),

    // TR: Namaz kategorisi
    // EN: Prayer category
    const KumoQuestion(
      id: 'namaz_1',
      category: KumoCategory.namaz,
      question: 'Namazın farzları nelerdir?',
      answer:
          'Namazın 6 farzı vardır: 1) Namaza niyet etmek, 2) Tekbîr-i iftitah getirmek, 3) Kıyam (ayakta durmak), 4) Kıraat (Kur\'an okumak), 5) Rüku ve secde, 6) Oturarak selam vermek.',
      difficulty: KumoDifficulty.easy,
      keywords: ['namaz', 'farz', 'niyet', 'kıyam'],
    ),

    const KumoQuestion(
      id: 'namaz_2',
      category: KumoCategory.namaz,
      question: 'Abdestin farzları nelerdir?',
      answer:
          'Abdestin 4 farzı vardır: 1) Yüzü yıkamak, 2) Kolları dirseklerle birlikte yıkamak, 3) Başın dörtte birini mesh etmek, 4) Ayakları topuklarla birlikte yıkamak.',
      difficulty: KumoDifficulty.easy,
      keywords: ['abdest', 'farz', 'yüz', 'kollar'],
    ),

    const KumoQuestion(
      id: 'namaz_3',
      category: KumoCategory.namaz,
      question: 'Cuma namazı kaç rekatdır?',
      answer:
          'Cuma namazı 2 rekat farz ve 4 rekat sünnettir. Cuma namazı, cuma günü öğle vaktinde cemaatle kılınan bir namazdır.',
      difficulty: KumoDifficulty.easy,
      keywords: ['cuma', 'namaz', 'rekat', 'farz'],
    ),

    const KumoQuestion(
      id: 'namaz_4',
      category: KumoCategory.namaz,
      question: 'Vakit namazları nelerdir?',
      answer:
          '5 vakit namaz vardır: 1) Sabah namazı (2 rekat), 2) Öğle namazı (4 rekat), 3) İkindi namazı (4 rekat), 4) Akşam namazı (3 rekat), 5) Yatsı namazı (4 rekat).',
      difficulty: KumoDifficulty.easy,
      keywords: ['vakit', 'namaz', 'rekat', 'sabah'],
    ),

    const KumoQuestion(
      id: 'namaz_5',
      category: KumoCategory.namaz,
      question: 'Kaza namazı nasıl kılınır?',
      answer:
          'Kaza namazları, kaçırılan namazların yerine kılınan namazlardır. Her kaza namazı, kaçırılan namazın rekatı kadar kılınır. Örneğin, kaçırılan öğle namazı 4 rekat olarak kılınır.',
      difficulty: KumoDifficulty.medium,
      keywords: ['kaza', 'namaz', 'kaçırılan', 'rekat'],
    ),

    // TR: Ahlak kategorisi
    // EN: Morality category
    const KumoQuestion(
      id: 'ahlak_1',
      category: KumoCategory.ahlak,
      question: 'İslam\'da ahlakın önemi nedir?',
      answer:
          'İslam\'da ahlak, dinin temelidir. Peygamber Efendimiz (s.a.v.) "Ben güzel ahlak için gönderildim" buyurmuştur. Ahlak, bir Müslüman\'ın karakterini ve davranışlarını belirler.',
      difficulty: KumoDifficulty.easy,
      keywords: ['ahlak', 'önem', 'İslam', 'peygamber'],
    ),

    const KumoQuestion(
      id: 'ahlak_2',
      category: KumoCategory.ahlak,
      question: 'Doğruluk ve dürüstlük neden önemlidir?',
      answer:
          'Doğruluk ve dürüstlük, Müslüman\'ın temel özellikleridir. Peygamberimiz "Doğruyu söyleyen, cennete gider" buyurmuştur. Dürüstlük, toplumda güveni ve adaleti sağlar.',
      difficulty: KumoDifficulty.easy,
      keywords: ['doğruluk', 'dürüstlük', 'cennet', 'güven'],
    ),

    const KumoQuestion(
      id: 'ahlak_3',
      category: KumoCategory.ahlak,
      question: 'Sabır nedir ve nasıl kazanılır?',
      answer:
          'Sabır, zorluklar karşısında dayanma gücüdür. Sabır, Allah\'ın sevdiği bir özelliktir ve cennetin kapılarından biridir. Sabır, zorluklarla karşılaştığında Allah\'a güvenerek kazanılır.',
      difficulty: KumoDifficulty.medium,
      keywords: ['sabır', 'zorluk', 'cennet', 'güven'],
    ),

    const KumoQuestion(
      id: 'ahlak_4',
      category: KumoCategory.ahlak,
      question: 'Tevekkül nedir?',
      answer:
          'Tevekkül, bir işi yaptıktan sonra sonucu Allah\'a bırakmaktır. Tevekkül, tembellik değil, gayret gösterdikten sonra Allah\'a güvenmektir.',
      difficulty: KumoDifficulty.medium,
      keywords: ['tevekkül', 'güven', 'gayret', 'Allah'],
    ),

    const KumoQuestion(
      id: 'ahlak_5',
      category: KumoCategory.ahlak,
      question: 'Şefkat ve merhamet neden önemlidir?',
      answer:
          'Şefkat ve merhamet, Allah\'ın en güzel sıfatlarındandır. Peygamberimiz "Merhamet edenlere Rahman (Allah) merhamet eder" buyurmuştur. Merhamet, toplumda sevgi ve birliği sağlar.',
      difficulty: KumoDifficulty.easy,
      keywords: ['şefkat', 'merhamet', 'Rahman', 'sevgi'],
    ),

    // TR: Tarih kategorisi
    // EN: History category
    const KumoQuestion(
      id: 'tarih_1',
      category: KumoCategory.tarih,
      question: 'Hicret ne zaman ve neden gerçekleşti?',
      answer:
          'Hicret, 622 yılında Hz. Muhammed (s.a.v.) ve ashabının Mekke\'den Medine\'ye göç etmesidir. Hicret, İslam takviminin başlangıcıdır ve Müslümanların zulümden kurtulması için gerçekleşmiştir.',
      difficulty: KumoDifficulty.easy,
      keywords: ['hicret', 'Mekke', 'Medine', '622'],
    ),

    const KumoQuestion(
      id: 'tarih_2',
      category: KumoCategory.tarih,
      question: 'Bedir Savaşı ne zaman gerçekleşti?',
      answer:
          'Bedir Savaşı, 624 yılında Mekke ile Medine arasında gerçekleşmiştir. Müslümanların ilk büyük zaferidir ve 313 Müslüman, 1000 müşrike karşı savaşmışlardır.',
      difficulty: KumoDifficulty.medium,
      keywords: ['Bedir', 'savaş', '624', 'zafer'],
    ),

    const KumoQuestion(
      id: 'tarih_3',
      category: KumoCategory.tarih,
      question: 'Hz. Osman ne zaman halife oldu?',
      answer:
          'Hz. Osman, 644-656 yılları arasında halifelik yapmıştır. Hz. Osman döneminde Kur\'an-ı Kerim çoğaltılmış ve İslam devleti genişlemiştir.',
      difficulty: KumoDifficulty.medium,
      keywords: ['Osman', 'halife', '644', 'Kur\'an'],
    ),

    const KumoQuestion(
      id: 'tarih_4',
      category: KumoCategory.tarih,
      question: 'İstanbul fethi ne zaman gerçekleşti?',
      answer:
          'İstanbul fethi, 1453 yılında Fatih Sultan Mehmet tarafından gerçekleştirilmiştir. Bu fetih, Bizans İmparatorluğu\'na son vermiş ve Osmanlı İmparatorluğu\'nu zirveye taşımıştır.',
      difficulty: KumoDifficulty.easy,
      keywords: ['İstanbul', 'fetih', '1453', 'Fatih'],
    ),

    const KumoQuestion(
      id: 'tarih_5',
      category: KumoCategory.tarih,
      question: 'Kerbela olayı ne zaman gerçekleşti?',
      answer:
          'Kerbela olayı, 10 Muharrem 680 yılında gerçekleşmiştir. Hz. Hüseyin ve ashabının Kerbela\'da şehit edildiği bu olay, İslam tarihinin en trajik olaylarından biridir.',
      difficulty: KumoDifficulty.medium,
      keywords: ['Kerbela', 'Hüseyin', '680', 'şehit'],
    ),

    // TR: İlim kategorisi
    // EN: Knowledge category
    const KumoQuestion(
      id: 'ilim_1',
      category: KumoCategory.ilim,
      question: 'İslam\'da ilim öğrenmenin önemi nedir?',
      answer:
          'Peygamber Efendimiz (s.a.v.) "İlim öğrenmek her Müslüman üzerine farzdır" buyurmuştur. İlim, Allah\'ı tanımak ve O\'nun emirlerini doğru anlamak için gereklidir.',
      difficulty: KumoDifficulty.easy,
      keywords: ['ilim', 'öğrenmek', 'farz', 'Allah'],
    ),

    const KumoQuestion(
      id: 'ilim_2',
      category: KumoCategory.ilim,
      question: 'Kur\'an-ı Kerim kaç sureden oluşur?',
      answer:
          'Kur\'an-ı Kerim 114 sureden oluşur. En uzun sure Bakara suresi, en kısa sure Kevser suresidir. Kur\'an, 23 yılda nazil olmuştur.',
      difficulty: KumoDifficulty.easy,
      keywords: ['Kur\'an', 'sure', '114', 'Bakara'],
    ),

    const KumoQuestion(
      id: 'ilim_3',
      category: KumoCategory.ilim,
      question: 'Hadis nedir?',
      answer:
          'Hadis, Hz. Muhammed (s.a.v.)\'in sözleri, eylemleri ve onaylarıdır. Hadis, Kur\'an-ı Kerim\'den sonra İslam\'ın ikinci önemli kaynağıdır.',
      difficulty: KumoDifficulty.easy,
      keywords: ['hadis', 'peygamber', 'sözler', 'Kur\'an'],
    ),

    const KumoQuestion(
      id: 'ilim_4',
      category: KumoCategory.ilim,
      question: 'Fıkıh ilmi neyi inceler?',
      answer:
          'Fıkıh ilmi, İslam hukukunu inceler. Namaz, oruç, zekat, hac gibi ibadetlerin nasıl yapılacağını ve İslam\'ın hukuki kurallarını belirler.',
      difficulty: KumoDifficulty.medium,
      keywords: ['fıkıh', 'hukuk', 'ibadet', 'namaz'],
    ),

    const KumoQuestion(
      id: 'ilim_5',
      category: KumoCategory.ilim,
      question: 'Tefsir nedir?',
      answer:
          'Tefsir, Kur\'an-ı Kerim\'in açıklanmasıdır. Tefsir, Kur\'an ayetlerinin anlamını, iniş sebeplerini ve hükümlerini açıklar.',
      difficulty: KumoDifficulty.medium,
      keywords: ['tefsir', 'Kur\'an', 'ayet', 'açıklama'],
    ),

    // TR: Ek sorular - V4 yeniliği
    // EN: Additional questions - V4 innovation
    const KumoQuestion(
      id: 'oruc_1',
      category: KumoCategory.namaz,
      question: 'Oruç tutmak ne zaman farz oldu?',
      answer:
          'Oruç, 2. Hicri yılın Şaban ayında farz kılınmıştır. Ramazan ayında oruç tutmak, her Müslüman üzerine farzdır.',
      difficulty: KumoDifficulty.easy,
      keywords: ['oruç', 'farz', 'Ramazan', 'Şaban'],
    ),

    const KumoQuestion(
      id: 'hac_1',
      category: KumoCategory.namaz,
      question: 'Hac farzı kimler için gereklidir?',
      answer:
          'Hac, mali gücü yeten, akıl sağlığı yerinde ve yol güvenliği olan her Müslüman için ömürde bir kez farzdır.',
      difficulty: KumoDifficulty.easy,
      keywords: ['hac', 'farz', 'Müslüman', 'ömrde'],
    ),

    const KumoQuestion(
      id: 'tesbihat_1',
      category: KumoCategory.namaz,
      question: 'Namaz sonrası tesbihat kaç kere okunur?',
      answer:
          'Namaz sonrası 33 kere "Subhanallah", 33 kere "Elhamdulillah", 33 kere "Allahu Akbar" ve 1 kere "La ilaha illallah" okunur.',
      difficulty: KumoDifficulty.easy,
      keywords: ['tesbihat', 'namaz', 'Subhanallah', '33'],
    ),

    const KumoQuestion(
      id: 'vakit_1',
      category: KumoCategory.namaz,
      question: 'Namaz vakitleri nasıl belirlenir?',
      answer:
          'Namaz vakitleri, güneşin hareketine göre belirlenir. Sabah, öğle, ikindi, akşam ve yatsı namazları belirli astronomik hesaplamalarla belirlenir.',
      difficulty: KumoDifficulty.medium,
      keywords: ['vakit', 'namaz', 'güneş', 'astronomik'],
    ),

    const KumoQuestion(
      id: 'camii_1',
      category: KumoCategory.namaz,
      question: 'Camiin önemi nedir?',
      answer:
          'Cami, Müslümanların toplandığı, ibadet ettiği ve toplumsal hayatın merkezidir. Peygamberimiz "Kim Allah\'ın evini ziyaret ederse, Allah onu misafir eder" buyurmuştur.',
      difficulty: KumoDifficulty.easy,
      keywords: ['cami', 'ibadet', 'toplum', 'misafir'],
    ),
  ];

  // TR: Rastgele soru al - V1'den miras alındı
  // EN: Get random question - Inherited from V1
  KumoQuestion getRandomQuestion() {
    final randomIndex = Random().nextInt(_questions.length);
    return _questions[randomIndex];
  }

  // TR: Kategoriye göre soru al - V4 yeniliği
  // EN: Get question by category - V4 innovation
  KumoQuestion getQuestionByCategory(KumoCategory category) {
    final categoryQuestions =
        _questions.where((q) => q.category == category).toList();
    final randomIndex = Random().nextInt(categoryQuestions.length);
    return categoryQuestions[randomIndex];
  }

  // TR: Zorluğa göre soru al - V4 yeniliği
  // EN: Get question by difficulty - V4 innovation
  KumoQuestion getQuestionByDifficulty(KumoDifficulty difficulty) {
    final difficultyQuestions =
        _questions.where((q) => q.difficulty == difficulty).toList();
    final randomIndex = Random().nextInt(difficultyQuestions.length);
    return difficultyQuestions[randomIndex];
  }

  // TR: Arama yap - V4 yeniliği
  // EN: Search - V4 innovation
  List<KumoQuestion> searchQuestions(String query) {
    return _questions.where((question) {
      final lowerQuery = query.toLowerCase();
      return question.question.toLowerCase().contains(lowerQuery) ||
          question.answer.toLowerCase().contains(lowerQuery) ||
          question.keywords
              .any((keyword) => keyword.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // TR: Kategoriye göre tüm soruları al - V4 yeniliği
  // EN: Get all questions by category - V4 innovation
  List<KumoQuestion> getQuestionsByCategory(KumoCategory category) {
    return _questions.where((q) => q.category == category).toList();
  }

  // TR: Zorluğa göre tüm soruları al - V4 yeniliği
  // EN: Get all questions by difficulty - V4 innovation
  List<KumoQuestion> getQuestionsByDifficulty(KumoDifficulty difficulty) {
    return _questions.where((q) => q.difficulty == difficulty).toList();
  }

  // TR: İstatistikler - V4 yeniliği
  // EN: Statistics - V4 innovation
  Map<String, int> getStatistics() {
    final stats = <String, int>{};

    // TR: Kategori sayıları
    // EN: Category counts
    for (final category in KumoCategory.values) {
      stats[category.name] =
          _questions.where((q) => q.category == category).length;
    }

    // TR: Zorluk sayıları
    // EN: Difficulty counts
    for (final difficulty in KumoDifficulty.values) {
      stats[difficulty.name] =
          _questions.where((q) => q.difficulty == difficulty).length;
    }

    // TR: Toplam soru sayısı
    // EN: Total question count
    stats['total'] = _questions.length;

    return stats;
  }

  // TR: Öne çıkan sorular - V4 yeniliği
  // EN: Featured questions - V4 innovation
  List<KumoQuestion> getFeaturedQuestions() {
    // TR: Her kategoriden 2 soru
    // EN: 2 questions from each category
    final featured = <KumoQuestion>[];

    for (final category in KumoCategory.values) {
      final categoryQuestions =
          _questions.where((q) => q.category == category).toList();
      if (categoryQuestions.isNotEmpty) {
        featured.add(categoryQuestions[0]);
        if (categoryQuestions.length > 1) {
          featured.add(categoryQuestions[1]);
        }
      }
    }

    return featured;
  }

  // TR: Arama önerileri - V4 yeniliği
  // EN: Search suggestions - V4 innovation
  List<String> getSearchSuggestions() {
    final suggestions = <String>[];

    // TR: Sorulardan öneriler
    // EN: Suggestions from questions
    suggestions.addAll(_questions.map((q) => q.question));

    // TR: Anahtar kelimelerden öneriler
    // EN: Suggestions from keywords
    for (final question in _questions) {
      suggestions.addAll(question.keywords);
    }

    // TR: Kategorilerden öneriler
    // EN: Suggestions from categories
    suggestions.addAll(KumoCategory.values.map((c) => c.displayName));

    return suggestions.toSet().take(20).toList();
  }

  // TR: Öğrenme modu - V4 yeniliği
  // EN: Learning mode - V4 innovation
  List<KumoQuestion> getLearningQuestions(KumoCategory category) {
    // TR: Öğrenme için kolay sorular
    // EN: Easy questions for learning
    return _questions
        .where((q) =>
            q.category == category && q.difficulty == KumoDifficulty.easy)
        .take(5)
        .toList();
  }

  // TR: Test modu - V4 yeniliği
  // EN: Test mode - V4 innovation
  List<KumoQuestion> getTestQuestions() {
    // TR: Test için karışık zorlukta sorular
    // EN: Mixed difficulty questions for test
    return _questions
        .where((q) =>
            q.difficulty == KumoDifficulty.medium ||
            q.difficulty == KumoDifficulty.hard)
        .take(10)
        .toList();
  }

  // TR: İlerleme takibi - V4 yeniliği
  // EN: Progress tracking - V4 innovation
  Map<String, dynamic> getProgressStats(List<String> answeredQuestionIds) {
    final totalQuestions = _questions.length;
    final answeredCount = answeredQuestionIds.length;
    final correctCount =
        answeredQuestionIds.length; // TR: Basit takip // EN: Simple tracking

    return {
      'total_questions': totalQuestions,
      'answered_questions': answeredCount,
      'correct_answers': correctCount,
      'completion_percentage': (answeredCount / totalQuestions * 100).round(),
      'categories_progress': _getCategoryProgress(answeredQuestionIds),
    };
  }

  // TR: Kategori ilerlemesi - V4 yeniliği
  // EN: Category progress - V4 innovation
  Map<String, dynamic> _getCategoryProgress(List<String> answeredQuestionIds) {
    final categoryProgress = <String, dynamic>{};

    for (final category in KumoCategory.values) {
      final categoryQuestions =
          _questions.where((q) => q.category == category).toList();
      final answeredInCategory = categoryQuestions
          .where((q) => answeredQuestionIds.contains(q.id))
          .length;
      final totalInCategory = categoryQuestions.length;

      categoryProgress[category.name] = {
        'answered': answeredInCategory,
        'total': totalInCategory,
        'percentage': totalInCategory > 0
            ? (answeredInCategory / totalInCategory * 100).round()
            : 0,
      };
    }

    return categoryProgress;
  }

  // TR: Veri doğrulama - V4 yeniliği
  // EN: Data validation - V4 innovation
  bool validateData() {
    // TR: Boş veri kontrolü
    // EN: Empty data check
    if (_questions.isEmpty) return false;

    // TR: Gerekli alanlar kontrolü
    // EN: Required fields check
    for (final question in _questions) {
      if (question.id.isEmpty ||
          question.question.isEmpty ||
          question.answer.isEmpty) {
        return false;
      }
    }

    // TR: Tekrarlayan ID kontrolü
    // EN: Duplicate ID check
    final ids = _questions.map((q) => q.id).toSet();
    if (ids.length != _questions.length) return false;

    return true;
  }

  // TR: Veri yenileme - V1'den miras alındı
  // EN: Data refresh - Inherited from V1
  void refreshData() {
    // TR: Veriler zaten statik, yenileme gerekmiyor
    // EN: Data is already static, no refresh needed
  }

  // TR: Paylaşım metni - V4 yeniliği
  // EN: Sharing text - V4 innovation
  String createShareText(KumoQuestion question) {
    return 'KUMO AI Sorusu\n\n${question.question}\n\n${question.answer}\n\n#KUBBE #KumoAI #${question.category.displayName}';
  }
}

/// TR: Kumo Soru Modeli - V4 yeniliği
/// EN: Kumo Question Model - V4 innovation
/// TR: Soru-cevap veri modeli
/// EN: Question-answer data model
class KumoQuestion {
  // TR: Soru ID'si
  // EN: Question ID
  final String id;

  // TR: Kategori
  // EN: Category
  final KumoCategory category;

  // TR: Soru metni
  // EN: Question text
  final String question;

  // TR: Cevap metni
  // EN: Answer text
  final String answer;

  // TR: Zorluk seviyesi
  // EN: Difficulty level
  final KumoDifficulty difficulty;

  // TR: Anahtar kelimeler
  // EN: Keywords
  final List<String> keywords;

  // TR: Constructor
  // EN: Constructor
  const KumoQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    required this.difficulty,
    required this.keywords,
  });

  // TR: To JSON
  // EN: To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'question': question,
      'answer': answer,
      'difficulty': difficulty.name,
      'keywords': keywords,
    };
  }

  // TR: From JSON
  // EN: From JSON
  factory KumoQuestion.fromJson(Map<String, dynamic> json) {
    return KumoQuestion(
      id: json['id'] as String,
      category: KumoCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => KumoCategory.namaz,
      ),
      question: json['question'] as String,
      answer: json['answer'] as String,
      difficulty: KumoDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => KumoDifficulty.easy,
      ),
      keywords: (json['keywords'] as List<dynamic>).cast<String>(),
    );
  }

  // TR: CopyWith
  // EN: CopyWith
  KumoQuestion copyWith({
    String? id,
    KumoCategory? category,
    String? question,
    String? answer,
    KumoDifficulty? difficulty,
    List<String>? keywords,
  }) {
    return KumoQuestion(
      id: id ?? this.id,
      category: category ?? this.category,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      difficulty: difficulty ?? this.difficulty,
      keywords: keywords ?? this.keywords,
    );
  }

  // TR: Equality operator
  // EN: Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KumoQuestion &&
        other.id == id &&
        other.category == category &&
        other.question == question &&
        other.answer == answer &&
        other.difficulty == difficulty &&
        other.keywords == keywords;
  }

  // TR: Hash code
  // EN: Hash code
  @override
  int get hashCode {
    return Object.hash(id, category, question, answer, difficulty, keywords);
  }

  // TR: String representation
  // EN: String representation
  @override
  String toString() {
    return 'const KumoQuestion(id: $id, category: $category, question: $question)';
  }
}

/// TR: Kumo Kategori Enum - V4 yeniliği
/// EN: Kumo Category Enum - V4 innovation
/// TR: Soru kategorileri
/// EN: Question categories
enum KumoCategory {
  // TR: Zekat
  // EN: Zakat
  zekat,

  // TR: Namaz
  // EN: Prayer
  namaz,

  // TR: Ahlak
  // EN: Morality
  ahlak,

  // TR: Tarih
  // EN: History
  tarih,

  // TR: İlim
  // EN: Knowledge
  ilim,
}

/// TR: Kumo Zorluk Enum - V4 yeniliği
/// EN: Kumo Difficulty Enum - V4 innovation
/// TR: Soru zorluk seviyeleri
/// EN: Question difficulty levels
enum KumoDifficulty {
  // TR: Kolay
  // EN: Easy
  easy,

  // TR: Orta
  // EN: Medium
  medium,

  // TR: Zor
  // EN: Hard
  hard,
}

/// TR: Kumo Kategori Extension - V4 yeniliği
/// EN: Kumo Category Extension - V4 innovation
/// TR: KumoCategory için yardımcı metodlar
/// EN: Helper methods for KumoCategory
extension KumoCategoryExtension on KumoCategory {
  // TR: Display adı
  // EN: Display name
  String get displayName {
    switch (this) {
      case KumoCategory.zekat:
        return 'Zekat';
      case KumoCategory.namaz:
        return 'Namaz';
      case KumoCategory.ahlak:
        return 'Ahlak';
      case KumoCategory.tarih:
        return 'Tarih';
      case KumoCategory.ilim:
        return 'İlim';
    }
  }

  // TR: Renk
  // EN: Color
  String get color {
    switch (this) {
      case KumoCategory.zekat:
        return '#4CAF50'; // TR: Yeşil // EN: Green
      case KumoCategory.namaz:
        return '#2196F3'; // TR: Mavi // EN: Blue
      case KumoCategory.ahlak:
        return '#9C27B0'; // TR: Mor // EN: Purple
      case KumoCategory.tarih:
        return '#FF9800'; // TR: Turuncu // EN: Orange
      case KumoCategory.ilim:
        return '#607D8B'; // TR: Gri // EN: Grey
    }
  }

  // TR: İkon
  // EN: Icon
  String get icon {
    switch (this) {
      case KumoCategory.zekat:
        return 'assets/icons/zekat.png';
      case KumoCategory.namaz:
        return 'assets/icons/namaz.png';
      case KumoCategory.ahlak:
        return 'assets/icons/ahlak.png';
      case KumoCategory.tarih:
        return 'assets/icons/tarih.png';
      case KumoCategory.ilim:
        return 'assets/icons/ilim.png';
    }
  }
}

/// TR: Kumo Zorluk Extension - V4 yeniliği
/// EN: Kumo Difficulty Extension - V4 innovation
/// TR: KumoDifficulty için yardımcı metodlar
/// EN: Helper methods for KumoDifficulty
extension KumoDifficultyExtension on KumoDifficulty {
  // TR: Display adı
  // EN: Display name
  String get displayName {
    switch (this) {
      case KumoDifficulty.easy:
        return 'Kolay';
      case KumoDifficulty.medium:
        return 'Orta';
      case KumoDifficulty.hard:
        return 'Zor';
    }
  }

  // TR: Renk
  // EN: Color
  String get color {
    switch (this) {
      case KumoDifficulty.easy:
        return '#4CAF50'; // TR: Yeşil // EN: Green
      case KumoDifficulty.medium:
        return '#FF9800'; // TR: Turuncu // EN: Orange
      case KumoDifficulty.hard:
        return '#F44336'; // TR: Kırmızı // EN: Red
    }
  }

  // TR: Puan
  // EN: Points
  int get points {
    switch (this) {
      case KumoDifficulty.easy:
        return 10;
      case KumoDifficulty.medium:
        return 20;
      case KumoDifficulty.hard:
        return 30;
    }
  }
}

/// TR: Kumo Engine Provider - V4 yeniliği
/// EN: Kumo Engine Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
final kumoEngineProvider = Provider<KumoEngine>((ref) {
  return KumoEngine();
});

/// TR: Random Question Provider - V4 yeniliği
/// EN: Random Question Provider - V4 innovation
final randomQuestionProvider = Provider<KumoQuestion>((ref) {
  final engine = ref.watch(kumoEngineProvider);
  return engine.getRandomQuestion();
});

/// TR: Category Questions Provider - V4 yeniliği
/// EN: Category Questions Provider - V4 innovation
final categoryQuestionsProvider =
    Provider.family<List<KumoQuestion>, KumoCategory>((ref, category) {
  final engine = ref.watch(kumoEngineProvider);
  return engine.getQuestionsByCategory(category);
});

/// TR: Search Results Provider - V4 yeniliği
/// EN: Search Results Provider - V4 innovation
final searchResultsProvider =
    Provider.family<List<KumoQuestion>, String>((ref, query) {
  final engine = ref.watch(kumoEngineProvider);
  return engine.searchQuestions(query);
});
