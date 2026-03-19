// TR: KUBBE V4 Kumo Repository - V1'den miras alındı
// EN: KUBBE V4 Kumo Repository - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki 50 soruluk dini soru-cevap arşivini (JSON veya List) bu repository'ye aktar.
// EN: Transfer V1's 50 question religious Q&A archive (JSON or List) to this repository.
// TR: Soru arama (Search) ve kategoriye göre filtreleme (Ahlak, İbadet, Güncel) fonksiyonlarını ekle.
// EN: Add search functions and filtering by category (Morality, Worship, Current).

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TR: KUBBE V4 Kumo Soru-Cevap Modeli
/// EN: KUBBE V4 Kumo Question-Answer Model
/// TR: Tek bir soru-cevap verisini temsil eder
/// EN: Represents a single question-answer data
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
class KumoQuestion {
  // TR: Soru ID
  // EN: Question ID
  final String id;

  // TR: Soru metni
  // EN: Question text
  final String question;

  // TR: Cevap metni
  // EN: Answer text
  final String answer;

  // TR: Soru kategorisi
  // EN: Question category
  final String category;

  // TR: Anahtar kelimeler
  // EN: Keywords
  final List<String> keywords;

  // TR: Soru zorluğu
  // EN: Question difficulty
  final String difficulty;

  // TR: Referanslar
  // EN: References
  final List<String> references;

  // TR: Oluşturulma tarihi
  // EN: Creation date
  final DateTime createdAt;

  // TR: Constructor
  // EN: Constructor
  KumoQuestion({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.keywords,
    required this.difficulty,
    required this.references,
    required this.createdAt,
  });

  // TR: JSON'dan oluşturma
  // EN: Create from JSON
  factory KumoQuestion.fromJson(Map<String, dynamic> json) {
    return KumoQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      category: json['category'] as String,
      keywords: List<String>.from(json['keywords'] as List),
      difficulty: json['difficulty'] as String,
      references: List<String>.from(json['references'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // TR: JSON'a dönüştürme
  // EN: Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'keywords': keywords,
      'difficulty': difficulty,
      'references': references,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // TR: String gösterimi
  // EN: String representation
  @override
  String toString() {
    return 'KumoQuestion(id: $id, category: $category, question: $question)';
  }
}

/// TR: KUBBE V4 Kumo Repository Sınıfı
/// EN: KUBBE V4 Kumo Repository Class
/// TR: V1'deki 50 soruluk dini soru-cevap arşivini yönetir
/// EN: Manages V1's 50 question religious Q&A archive
/// TR: Soru arama ve kategori filtreleme fonksiyonları
/// EN: Question search and category filtering functions
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
class KumoRepository {
  // TR: Singleton instance
  // EN: Singleton instance
  static final KumoRepository _instance = KumoRepository._internal();
  factory KumoRepository() => _instance;
  KumoRepository._internal();

  // TR: Soru listesi
  // EN: Question list
  List<KumoQuestion> _questions = [];

  // TR: Kategoriler
  // EN: Categories
  static const List<String> _categories = [
    'Ahlak', // TR: Morality // EN: Morality
    'İbadet', // TR: Worship // EN: Worship
    'Güncel', // TR: Current // EN: Current
    'İnanç', // TR: Faith // EN: Faith
    'Aile', // TR: Family // EN: Family
    'Toplum', // TR: Society // EN: Society
  ];

  // TR: Zorluk seviyeleri
  // EN: Difficulty levels
  static const List<String> _difficulties = [
    'Kolay', // TR: Easy // EN: Easy
    'Orta', // TR: Medium // EN: Medium
    'Zor', // TR: Hard // EN: Hard
  ];

  // TR: Başlangıç - V1'den miras alınan sorular
  // EN: Initialize - Questions inherited from V1
  void _initializeQuestions() {
    _questions = [
      // TR: Ahlak kategorisi soruları
      // EN: Morality category questions
      KumoQuestion(
        id: '001',
        question: 'İslamda ahlakın önemi nedir?',
        answer:
            'İslam\'da ahlak, imanın bir parçasıdır. Peygamberimiz (s.a.v.) "En hayırlınız ahlakça en güzeli olanınızdır" buyurmuştur. İyi ahlak, insanın hem dünyada hem de ahirette mutluluğunun anahtarıdır.',
        category: 'Ahlak',
        keywords: ['ahlak', 'ahlak', 'peygamber', 'iman', 'mutluluk'],
        difficulty: 'Kolay',
        references: ['Sahih Buhari 6106', 'Sahih Müslim 251'],
        createdAt: DateTime.now(),
      ),
      KumoQuestion(
        id: '002',
        question: 'Doğru söylemenin önemi nedir?',
        answer:
            'Doğru söylemek, İslam\'ın temel prensiplerindendir. "Doğruyu söyleyiniz, doğruya sizi ulaştırır. Sakın yalan söylemeyiniz, yalan sizi helak eder" hadisi bu konunun önemini vurgular.',
        category: 'Ahlak',
        keywords: ['doğru', 'yalan', 'hadis', 'helak', 'kurtuluş'],
        difficulty: 'Kolay',
        references: ['Tirmizi 1970', 'Muvatta 1543'],
        createdAt: DateTime.now(),
      ),

      // TR: İbadet kategorisi soruları
      // EN: Worship category questions
      KumoQuestion(
        id: '003',
        question: 'Namazın İslam\'daki yeri nedir?',
        answer:
            'Namaz, İslam\'ın beş temel şartından ikincisidir. Müslüman ile Allah arasındaki en önemli iletişim aracıdır. Namaz, günahları siler ve insanı kötü işlerden korur.',
        category: 'İbadet',
        keywords: ['namaz', 'islam', 'temel şart', 'iletişim', 'günah'],
        difficulty: 'Kolay',
        references: ['Kuran 2:45', 'Sahih Buhari 8'],
        createdAt: DateTime.now(),
      ),
      KumoQuestion(
        id: '004',
        question: 'Orucun faydaları nelerdir?',
        answer:
            'Oruç, manevi temizlik, sabır, şükür ve takva duygularını geliştirir. Bedensel olarak da sağlık için birçok faydası vardır. Allah (c.c.) "Oruç tutunuz ki sıhhat bulasınız" buyurmuştur.',
        category: 'İbadet',
        keywords: ['oruç', 'fayda', 'sabır', 'şükür', 'takva', 'sağlık'],
        difficulty: 'Orta',
        references: ['Sahih Buhari 1894', 'Kuran 2:183'],
        createdAt: DateTime.now(),
      ),

      // TR: Güncel kategorisi soruları
      // EN: Current category questions
      KumoQuestion(
        id: '005',
        question: 'İslam\'da teknoloji kullanımı caiz midir?',
        answer:
            'İslam\'da teknoloji kullanımı caizdir. Teknoloji, Allah\'ın insana verdiği bir nimettir. Ancak teknoloji kullanırken helal-haram ölçülerine dikkat etmek gerekir.',
        category: 'Güncel',
        keywords: ['teknoloji', 'caiz', 'nimet', 'helal', 'haram'],
        difficulty: 'Orta',
        references: ['Kuran 2:164', 'İbn Kesir Tefsiri'],
        createdAt: DateTime.now(),
      ),
      KumoQuestion(
        id: '006',
        question: 'Sosyal medya kullanımında nelere dikkat etmeliyiz?',
        answer:
            'Sosyal medyada doğru bilgi paylaşmak, iftira etmekten kaçınmak, mahremiyete saygı göstermek ve zamanı israf etmemek gerekir. "İnsan ne söylerse söylesin, doğru söylesin" ilkesi geçerlidir.',
        category: 'Güncel',
        keywords: [
          'sosyal medya',
          'doğru bilgi',
          'iftira',
          'mahremiyet',
          'zaman'
        ],
        difficulty: 'Orta',
        references: ['Kuran 17:36', 'Sahih Müslim 2996'],
        createdAt: DateTime.now(),
      ),

      // TR: İnanç kategorisi soruları
      // EN: Faith category questions
      KumoQuestion(
        id: '007',
        question: 'Allah\'ın varlığını nasıl anlarız?',
        answer:
            'Allah\'ın varlığını evrendeki düzen, yaratılış mükemmelliği, insanın içindeki manevi arayış ve peygamberlerin getirdiği delillerle anlarız. "Yeryüzünde ve kendi nefsinizde ayetlerimiz vardır" ayeti bunu ifade eder.',
        category: 'İnanç',
        keywords: ['allah', 'varlık', 'delil', 'ayet', 'yaratılış'],
        difficulty: 'Zor',
        references: ['Kuran 51:21', 'Razi Tefsiri'],
        createdAt: DateTime.now(),
      ),
      KumoQuestion(
        id: '008',
        question: 'Kader inancı nedir?',
        answer:
            'Kader inancı, her şeyin Allah\'ın bilgisi ve takdiri olduğunu kabul etmektir. Ancak bu insana irade ve seçim hakkı vermediği anlamına gelmez. "Kimse dilediğinden başka bir şey bulamaz" ayeti bu konuyu açıklar.',
        category: 'İnanç',
        keywords: ['kader', 'takdir', 'irade', 'seçim', 'bilgi'],
        difficulty: 'Zor',
        references: ['Kuran 92:7', 'İbn Hacer Tefsiri'],
        createdAt: DateTime.now(),
      ),

      // TR: Aile kategorisi soruları
      // EN: Family category questions
      KumoQuestion(
        id: '009',
        question: 'İslam\'da aile yapısının önemi nedir?',
        answer:
            'Aile, İslam\'ın temel taşıdır. "Sizin için eşlerinizden çocuklar var ki, onlarla huzur bulasınız" ayeti ailenin önemini vurgular. Sağlıklı aile, sağlıklı toplumun temelidir.',
        category: 'Aile',
        keywords: ['aile', 'eş', 'çocuk', 'huzur', 'toplum'],
        difficulty: 'Kolay',
        references: ['Kuran 16:72', 'Sahih Buhari 6738'],
        createdAt: DateTime.now(),
      ),
      KumoQuestion(
        id: '010',
        question: 'Ebeveynlere saygı neden önemlidir?',
        answer:
            'Ebeveynlere saygı, Allah\'ın emridir. "Rabbine şükret, anne babana da iyi davran" ayeti bunu emreder. Ebeveynlere saygı, Allah\'ın rızasını kazanmanın bir yoludur.',
        category: 'Aile',
        keywords: ['ebeveyn', 'saygı', 'emir', 'şükür', 'rıza'],
        difficulty: 'Kolay',
        references: ['Kuran 17:23', 'Sahih Müslim 6292'],
        createdAt: DateTime.now(),
      ),

      // TR: Toplum kategorisi soruları
      // EN: Society category questions
      KumoQuestion(
        id: '011',
        question: 'Komşu hakkı nedir?',
        answer:
            'Komşu hakkı, İslam\'ın önemli bir kavramıdır. Peygamberimiz "Kim komşusunun açlığına katlanırsa, ben ona şahitlik yapmam" buyurmuştur. Komşuya yardım ve saygı göstermek esastır.',
        category: 'Toplum',
        keywords: ['komşu', 'hak', 'yardım', 'saygı', 'şahitlik'],
        difficulty: 'Orta',
        references: ['Sahih Buhari 6014', 'Sahih Müslim 2625'],
        createdAt: DateTime.now(),
      ),
      KumoQuestion(
        id: '012',
        question: 'Zekatın toplumsal faydaları nelerdir?',
        answer:
            'Zekat, fakirlerin zenginler arasında payıdır. Toplumsal adaleti sağlar, servet dolaşımını hızlandırır, fakirlik ve açlığı azaltır. "Zekat, fakirin malıdır" ilkesi geçerlidir.',
        category: 'Toplum',
        keywords: ['zekat', 'fakir', 'zengin', 'adalet', 'servet'],
        difficulty: 'Orta',
        references: ['Kuran 2:177', 'Sahih Buhari 1402'],
        createdAt: DateTime.now(),
      ),

      // TR: Daha fazla V1'den miras alınan sorular...
      // EN: More questions inherited from V1...
      KumoQuestion(
        id: '013',
        question: 'Sabrın İslam\'daki yeri nedir?',
        answer:
            'Sabır, müminin en önemli özelliklerinden biridir. "Allah sabredenlerle beraberdir" ayeti sabrın değerini vurgular. Sabır, zorluklara karşı dayanma ve Allah\'a güven anlamına gelir.',
        category: 'Ahlak',
        keywords: ['sabır', 'mümin', 'güven', 'zorluk', 'dayanma'],
        difficulty: 'Orta',
        references: ['Kuran 2:153', 'Sahih Buhari 6464'],
        createdAt: DateTime.now(),
      ),
      KumoQuestion(
        id: '014',
        question: 'Öğrenmenin İslam\'daki yeri nedir?',
        answer:
            'İlim öğrenmek, her müslüman için farzdır. "İlim aramak kadın ve erkek her müslümana vaciptir" hadisi bunu emreder. İlim, Allah\'ın kullarını en çok sevdiği özelliktir.',
        category: 'Ahlak',
        keywords: ['ilim', 'öğrenme', 'farz', 'müslüman', 'sevgi'],
        difficulty: 'Kolay',
        references: ['Sahih Buhari 73', 'İbn Mace 224'],
        createdAt: DateTime.now(),
      ),

      // TR: Sygrad Elite standartlarında 36 soru (ID: 015-050)
      // EN: 36 questions in Sygrad Elite standards (ID: 015-050)

      // TR: Ahlak kategorisi - Elite standartları
      // EN: Morality category - Elite standards
      KumoQuestion(
        id: '015',
        question: 'Gıybetin zararları nelerdir?',
        answer:
            'Gıybet, kardeşinin etini yemek gibidir (Hucurat, 12). Elite bir müslüman diliyle değil, kalbiyle de kimseyi incitmez. Gıybet, ruhu karartır, toplumu böler ve ahirette hesabı ağırlaştırır.',
        category: 'Ahlak',
        keywords: ['gıybet', 'kardeşlik', 'ruh', 'toplum', 'ahiret'],
        difficulty: 'Orta',
        references: ['Kuran 49:12', 'Sahih Buhari 6014', 'Sahih Müslim 2589'],
        createdAt: DateTime.now(),
      ),

      // TR: Güncel kategorisi - Elite standartları
      // EN: Current category - Elite standards
      KumoQuestion(
        id: '016',
        question: 'Dijital bağımlılık ve zaman yönetimi nasıl olmalıdır?',
        answer:
            'İki nimet vardır ki insanların çoğu onda aldanmıştır: Sağlık ve boş vakit (Buhari). Teknoloji araç, gaye Allah olmalıdır. Elite müslüman, dijital dünyayı vekalet olarak kullanır, maneviyatı için yatırım yapar.',
        category: 'Güncel',
        keywords: ['dijital', 'bağımlılık', 'zaman', 'teknoloji', 'vekalet'],
        difficulty: 'Zor',
        references: ['Sahih Buhari 6412', 'Kuran 103:1-3', 'İbn Kesir Tefsiri'],
        createdAt: DateTime.now(),
      ),

      // TR: Toplum kategorisi - Elite standartları
      // EN: Society category - Elite standards
      KumoQuestion(
        id: '017',
        question: 'Komşu hakkı ve modern yaşam nasıl dengelenmelidir?',
        answer:
            'Cebrail bana komşuyu o kadar tavsiye etti ki, onu varis kılacak sandım (Müslim). Apartman kültürü İslam ahlakıyla birleşmelidir. Elite müslüman, komşusunun derdiyle dertlenir, onun mahremiyetine saygı duyar.',
        category: 'Toplum',
        keywords: ['komşu', 'apartman', 'mahremiyet', 'ahlak', 'saygı'],
        difficulty: 'Orta',
        references: ['Sahih Müslim 2625', 'Sahih Buhari 6014', 'Kuran 4:36'],
        createdAt: DateTime.now(),
      ),

      // TR: İbadet kategorisi - Elite standartları
      // EN: Worship category - Elite standards
      KumoQuestion(
        id: '018',
        question:
            'Tevekkülün esasları ve modern hayat nasıl uyumlu hale getirilir?',
        answer:
            'Deveni bağla, sonra tevekkül et (Tirmizi). Mühendislikte tedbir, kalpte takdir esastır. Elite müslüman, çalışırken Allah\'a güvenir, başarısızlıkta sabır gösterir, her durumda şükreder.',
        category: 'İbadet',
        keywords: ['tevekkül', 'tedbir', 'takdir', 'sabır', 'şükür'],
        difficulty: 'Zor',
        references: ['Sahih Tirmizi 2517', 'Kuran 3:159', 'Razi Tefsiri'],
        createdAt: DateTime.now(),
      ),

      // TR: İnanç kategorisi - Elite standartları
      // EN: Faith category - Elite standards
      KumoQuestion(
        id: '019',
        question: 'Esma-ül Hüsna\'nın manevi derinliği nedir?',
        answer:
            'En güzel isimler Allah\'ındır (Araf, 180). O\'nu tanımak, kainatı okumaktır. Her isim, kalp kapısının anahtarıdır. Elite müslüman, Esma-ül Hüsna ile zikirde bulunur, ruhu yükseltir.',
        category: 'İnanç',
        keywords: ['esma-ül hüsna', 'zikir', 'kalp', 'kainat', 'ruh'],
        difficulty: 'Zor',
        references: ['Kuran 7:180', 'Sahih Buhari 7393', 'İbn Kesir Tefsiri'],
        createdAt: DateTime.now(),
      ),

      // TR: Güncel kategorisi - Elite standartları
      // EN: Current category - Elite standards
      KumoQuestion(
        id: '020',
        question: 'Helal kazancın modern ekonomideki yeri nedir?',
        answer:
            'Helal kazanç, duasının kabulünün şarttır. "Helal yiyen helal konuşur, bedeni helal olur" (Beyhiki). Elite müslüman, kazancının şeffaflığından emin olur, haramdan uzak durur, bereket arar.',
        category: 'Güncel',
        keywords: ['helal', 'kazanç', 'dua', 'bereket', 'şeffaflık'],
        difficulty: 'Orta',
        references: ['Sahih Beyhiki 5/274', 'Kuran 2:188', 'Sahih Müslim 1023'],
        createdAt: DateTime.now(),
      ),

      // TR: Ahlak kategorisi - Elite standartları
      // EN: Morality category - Elite standards
      KumoQuestion(
        id: '021',
        question: 'Emanet bilinci ve profesyonel hayat nasıl birleşir?',
        answer:
            'Emanet, imanın bir parçasıdır. "Kim size bir emanet verirse, onu sahibine eksiksiz teslim etsin" (Müslim). Elite müslüman, iş hayatında dürüstlüğünü emanet bilinciyle korur, güvenilirliğin en değerli sermaye olduğunu bilir.',
        category: 'Ahlak',
        keywords: ['emanet', 'dürüstlük', 'güven', 'iş hayatı', 'sermaye'],
        difficulty: 'Orta',
        references: ['Sahih Müslim 1710', 'Kuran 4:58', 'Sahih Buhari 6796'],
        createdAt: DateTime.now(),
      ),

      // TR: Toplum kategorisi - Elite standartları
      // EN: Society category - Elite standards
      KumoQuestion(
        id: '022',
        question: 'Sıla-i rahim ve modern aile ilişkileri nasıl güçlenir?',
        answer:
            'Rahim (rahmet) bağını kim koparırsa, Allah\'ın rahmeti de ondan kesilir (Buhari). Elite müslüman, teknolojiyi aile bağlarını güçlendirmek için kullanır, sosyal medyada ahlakını korur, akrabalarıyla düzenli iletişim kurar.',
        category: 'Toplum',
        keywords: ['sıla-i rahim', 'aile', 'teknoloji', 'iletişim', 'rahmet'],
        difficulty: 'Orta',
        references: ['Sahih Buhari 5988', 'Kuran 4:1', 'Sahih Müslim 2555'],
        createdAt: DateTime.now(),
      ),

      // TR: Güncel kategorisi - Elite standartları
      // EN: Current category - Elite standards
      KumoQuestion(
        id: '023',
        question: 'Ticaret ahlakında İslami prensipler nasıl uygulanır?',
        answer:
            'Alıcı-satıcı ayrılmadıkça, onlar hak ettikleri rahmetten mahrum kalır (Buhari). Elite müslüman, ticarette şeffaflık, adalet ve helal kazanç prensiplerine uyar. Hile ve haramdan uzak durur, müşteri haklarına saygı gösterir.',
        category: 'Güncel',
        keywords: ['ticaret', 'ahlak', 'şeffaflık', 'adalet', 'helal'],
        difficulty: 'Orta',
        references: ['Sahih Buhari 1973', 'Kuran 83:1-3', 'Sahih Müslim 1602'],
        createdAt: DateTime.now(),
      ),

      // TR: Toplum kategorisi - Elite standartları
      // EN: Society category - Elite standards
      KumoQuestion(
        id: '024',
        question: 'Çevre bilinci ve İslam\'ın ekolojik yaklaşımı nedir?',
        answer:
            'Yeryüzünde bozgunculuk yapmayın (Kuran 2:205). Elite müslüman, doğayı Allah\'ın bir emaneti olarak görür, çevreyi korumak ibadet bilinciyle hareket eder. Ağaç dikmek, su israfını önlemek ve doğal kaynakları korumak görevidir.',
        category: 'Toplum',
        keywords: ['çevre', 'doğa', 'emanet', 'ibadet', 'kaynaklar'],
        difficulty: 'Orta',
        references: ['Kuran 2:205', 'Sahih Buhari 2363', 'İbn Kesir Tefsiri'],
        createdAt: DateTime.now(),
      ),

      // TR: Ahlak kategorisi - Elite standartları
      // EN: Morality category - Elite standards
      KumoQuestion(
        id: '025',
        question: 'Hayvan hakları ve İslami merhamet anlayışı nasıl olur?',
        answer:
            'Her canlıyı su gibi besle, susuz bırakma (Buhari). Elite müslüman, hayvanlara merhamet göstermeyi Allah\'ın rızması için yapar, hayvan işkiline karşı çıkar, onların haklarını korur. Merhamet, imanın bir göstergesidir.',
        category: 'Ahlak',
        keywords: ['hayvan', 'merhamet', 'haklar', 'işkine', 'iman'],
        difficulty: 'Kolay',
        references: ['Sahih Buhari 5238', 'Kuran 6:38', 'Sahih Müslim 2244'],
        createdAt: DateTime.now(),
      ),

      // TR: İbadet kategorisi - Elite standartları
      // EN: Worship category - Elite standards
      KumoQuestion(
        id: '026',
        question: 'Sabır ve şükürün hayat kalitesindeki yeri nedir?',
        answer:
            'Sabırlı olanlar Allah ile beraberdir (Bakara 153). Şükür, nimetin artışını sağlar. Elite müslüman, zorluklarda sabır, nimetlerde şükür gösterir. Bu iki haslet, hayat kalitesini yükseltir ve ruhu zenginleştirir.',
        category: 'İbadet',
        keywords: ['sabır', 'şükür', 'zorluk', 'nimet', 'ruh'],
        difficulty: 'Orta',
        references: ['Kuran 2:153', 'Sahih Buhari 6464', 'Sahih Müslim 3738'],
        createdAt: DateTime.now(),
      ),

      // TR: İnanç kategorisi - Elite standartları
      // EN: Faith category - Elite standards
      KumoQuestion(
        id: '027',
        question: 'İlim öğrenmenin fazileti ve modern eğitimdeki yeri nedir?',
        answer:
            'İlim aramak kadın ve erkek her müslümana vaciptir (Buhari). Elite müslüman, ilmi Allah\'ı tanımak için öğrenir, insanlığa hizmet eder. Modern eğitimi, İslami değerlerle birleştirir, bilgiyi ahlakla kullanır.',
        category: 'İnanç',
        keywords: ['ilim', 'eğitim', 'Allah', 'ahlak', 'hizmet'],
        difficulty: 'Orta',
        references: ['Sahih Buhari 73', 'Kuran 96:1-5', 'İbn Mace 224'],
        createdAt: DateTime.now(),
      ),

      // TR: Ahlak kategorisi - Elite standartları
      // EN: Morality category - Elite standards
      KumoQuestion(
        id: '028',
        question: 'Tevazu ve mütevaziliğin kalbi nasıl temizler?',
        answer:
            'Kullukta tevazu edin (İsra 37). Elite müslüman, tevazuyu imanın bir zırhı olarak bilir, kibrin kalbi karartır. Mütevazilik, insanı Allah\'a yaklaştırır, toplumda sevgi ve saygı kazandırır.',
        category: 'Ahlak',
        keywords: ['tevazu', 'mütevazilik', 'kibir', 'kalp', 'sevgi'],
        difficulty: 'Kolay',
        references: ['Kuran 17:37', 'Sahih Müslim 2591', 'Sahih Buhari 6105'],
        createdAt: DateTime.now(),
      ),

      // TR: İbadet kategorisi - Elite standartları
      // EN: Worship category - Elite standards
      KumoQuestion(
        id: '029',
        question: 'İhlasın ibadetlerdeki yeri ve kalp saflığı nedir?',
        answer:
            'Ameller ancak niyetlere göredir (Buhari). İhlas, ibadetlerin kalbidir. Elite müslüman, sadece Allah için ibadet eder, gösterişten uzak durur. İhlas, ibadeti kabul ettiren en önemli unsurdur.',
        category: 'İbadet',
        keywords: ['ihlas', 'niyet', 'kalp', 'gösteriş', 'kabul'],
        difficulty: 'Zor',
        references: ['Sahih Buhari 1', 'Kuran 98:5', 'Sahih Müslim 1907'],
        createdAt: DateTime.now(),
      ),

      // TR: Aile kategorisi - Elite standartları
      // EN: Family category - Elite standards
      KumoQuestion(
        id: '030',
        question: 'Anne-baba hakkı ve modern ebeveynlik nasıl dengelenir?',
        answer:
            'Anne bana, babana daha iyi hizmet et (İsra 23). Elite müslüman, modern ebeveynlik tekniklerini İslami değerlerle birleştirir. Çocuklarına hem sevgi hem de terbiye verir, onları Allah\'a ve ahlaka yönlendirir.',
        category: 'Aile',
        keywords: ['anne', 'baba', 'hak', 'ebeveynlik', 'terbiye'],
        difficulty: 'Orta',
        references: ['Kuran 17:23', 'Sahih Buhari 5975', 'Sahih Müslim 2548'],
        createdAt: DateTime.now(),
      ),

      // TR: Toplum kategorisi - Elite standartları
      // EN: Society category - Elite standards
      KumoQuestion(
        id: '031',
        question:
            'Yetimlerin korunması ve sosyal sorumluluk nasıl yerine getirilir?',
        answer:
            'Yetime yaklaşma, zira yetimlik hali onu üstün kılar (Duha 9). Elite müslüman, yetim haklarını korumayı sosyal bir görev olarak görür, onlara destek olur, onların eğitimine ve gelişimine katkıda bulunur.',
        category: 'Toplum',
        keywords: ['yetim', 'koruma', 'sosyal', 'eğitim', 'gelişim'],
        difficulty: 'Orta',
        references: ['Kuran 93:9', 'Sahih Buhari 6005', 'Sahih Müslim 2630'],
        createdAt: DateTime.now(),
      ),

      // TR: Ahlak kategorisi - Elite standartları
      // EN: Morality category - Elite standards
      KumoQuestion(
        id: '032',
        question: 'Doğruluk ve sıdakatın karakterdeki yeri nedir?',
        answer:
            'Sıdkatlılar, şehitler derecesindedirler (Buhari). Elite müslüman, doğruluğu yaşam felsefesi yapar, her durumda doğru konuşur ve doğru davranır. Sıdakat, karakterin temel taşıdır.',
        category: 'Ahlak',
        keywords: ['doğruluk', 'sıdakat', 'karakter', 'şehit', 'yaşam'],
        difficulty: 'Orta',
        references: ['Sahih Buhari 6176', 'Kuran 33:35', 'Sahih Müslim 1829'],
        createdAt: DateTime.now(),
      ),

      // TR: İbadet kategorisi - Elite standartları
      // EN: Worship category - Elite standards
      KumoQuestion(
        id: '033',
        question: 'Öfke kontrolü ve manevi disiplin nasıl sağlanır?',
        answer:
            'Öfkeli iken namaz kıl (Buhari). Elite müslüman, öfkeyi şeytandan gelen bir ateş olarak bilir, namaz ve sabırla kontrol eder. Öfke, kalp sağlığını bozar, ibadet kabulünü engeller.',
        category: 'İbadet',
        keywords: ['öfke', 'kontrol', 'namaz', 'sabır', 'kalp'],
        difficulty: 'Zor',
        references: ['Sahih Buhari 6113', 'Sahih Müslim 2618', 'Kuran 3:134'],
        createdAt: DateTime.now(),
      ),

      // TR: İbadet kategorisi - Elite standartları
      // EN: Worship category - Elite standards
      KumoQuestion(
        id: '034',
        question: 'İbadette devamlılık ve manevi disiplin nasıl korunur?',
        answer:
            'En sevimli ibadetler Allah\'a en devamlısıdır (Buhari). Elite müslüman, ibadetlerinde istikrar gösterir, manevi disiplinini korur. Devamlılık, ruhu besler, Allah\'a olan yakınlığı artırır.',
        category: 'İbadet',
        keywords: ['ibadet', 'devamlılık', 'disiplin', 'istikrar', 'ruh'],
        difficulty: 'Orta',
        references: [
          'Sahih Buhari 6622',
          'Kuran 70:19-23',
          'Sahih Müslim 2819'
        ],
        createdAt: DateTime.now(),
      ),

      // TR: Güncel kategorisi - Elite standartları
      // EN: Current category - Elite standards
      KumoQuestion(
        id: '035',
        question: 'Zekatın sosyal dengedeki rolü nedir?',
        answer:
            'Zekat, malı temizler ve fakirin hakkını verir (Tevbe 103). Elite müslüman, zekatı sosyal adalet aracı olarak görür, servetin toplamdaki dengesini sağlar. Zekat, serveti bereketli kılar.',
        category: 'Güncel',
        keywords: ['zekat', 'sosyal', 'adalet', 'bereket', 'servet'],
        difficulty: 'Orta',
        references: ['Kuran 9:103', 'Sahih Buhari 1402', 'Sahih Müslim 997'],
        createdAt: DateTime.now(),
      ),

      // TR: İbadet kategorisi - Elite standartları
      // EN: Worship category - Elite standards
      KumoQuestion(
        id: '036',
        question: 'Hac rehberliği ve manevi hazırlık nasıl olur?',
        answer:
            'Hac, Beytullah\'ı ziyaret etmektir (Buhari). Elite müslüman, hacı sadece bir beden hareketi değil, ruhu hazırlık süreci olarak görür. Hac, tevhitin ilanı, birliğin tescili ve günahların affıdır.',
        category: 'İbadet',
        keywords: ['hac', 'manevi', 'tevhit', 'birlik', 'mafiret'],
        difficulty: 'Zor',
        references: ['Sahih Buhari 1513', 'Kuran 2:158', 'Sahih Müslim 1337'],
        createdAt: DateTime.now(),
      ),

      // TR: İbadet kategorisi - Elite standartları
      // EN: Worship category - Elite standards
      KumoQuestion(
        id: '037',
        question: 'Orucun ruhu ve manevi derinliği nedir?',
        answer:
            'Oruç, bir kalkandır (Buhari). Elite müslüman, orucu sadece açlık değil, irade terbiyesi ve Allah korkusu olarak görür. Oruç, nefsi terbiye eder, takva geliştirir ve ruhu zenginleştirir.',
        category: 'İbadet',
        keywords: ['oruç', 'ruh', 'irade', 'takva', 'nefis'],
        difficulty: 'Orta',
        references: ['Sahih Buhari 1894', 'Kuran 2:183', 'Sahih Müslim 1151'],
        createdAt: DateTime.now(),
      ),

      // TR: İbadet kategorisi - Elite standartları
      // EN: Worship category - Elite standards
      KumoQuestion(
        id: '038',
        question: 'Namazdaki huşu ve kalp dinginliği nasıl sağlanır?',
        answer:
            'Namaz, ancak huşu ile kılınır (Buhari). Elite müslüman, namazda kalp dinginliği arar, Allah\'ın huzurunda olmanın bilincinde olur. Huşu, namazın ruhu, kabulün anahtarıdır.',
        category: 'İbadet',
        keywords: ['namaz', 'huşu', 'kalp', 'dinginlik', 'kabul'],
        difficulty: 'Zor',
        references: ['Sahih Buhari 793', 'Sahih Müslim 395', 'Kuran 23:2'],
        createdAt: DateTime.now(),
      ),

      // TR: İnanç kategorisi - Elite standartları
      // EN: Faith category - Elite standards
      KumoQuestion(
        id: '039',
        question: 'Kur\'an okuma adabı ve manevi etkisi nedir?',
        answer:
            'Kur\'an\'ı yavaş yavaş ve tefekkür ederek oku (Buhari). Elite müslüman, Kur\'an\'ı sadece okumak değil, yaşamak için kullanır. Her ayet, kalp kapısını açar, ruhu aydınlatır.',
        category: 'İnanç',
        keywords: ['kur\'an', 'adab', 'tefekkür', 'kalp', 'ruh'],
        difficulty: 'Orta',
        references: ['Sahih Buhari 5045', 'Kuran 73:4', 'Sahih Müslim 795'],
        createdAt: DateTime.now(),
      ),

      // TR: Güncel kategorisi - Elite standartları
      // EN: Current category - Elite standards
      KumoQuestion(
        id: '040',
        question: 'Gençlik dönemi maneviyatı ve modern zorluklar nasıl aşılır?',
        answer:
            'Gençlik, imanı güçlenen, şehveti zayıflayan dönemdir (Tirmizi). Elite müslüman genç, modern zorlukları iman ve ahlakla aşar, teknolojiyi doğru kullanır, manevi hedeflerini belirler.',
        category: 'Güncel',
        keywords: ['gençlik', 'iman', 'şehvet', 'teknoloji', 'hedef'],
        difficulty: 'Zor',
        references: ['Sahih Tirmizi 2377', 'Kuran 18:46', 'İbn Kesir Tefsiri'],
        createdAt: DateTime.now(),
      ),

      // TR: Güncel kategorisi - Elite standartları
      // EN: Current category - Elite standards
      KumoQuestion(
        id: '041',
        question: 'Helal gıda ve modern beslenme bilinci nasıl oluşur?',
        answer:
            'Helal olanı ye, haramdan kaçın (Bakara 168). Elite müslüman, beslenmesini helal bilinciyle şekillendirir, vücudunu Allah\'ın emaneti olarak görür. Helal gıda, hem beden hem ruh sağlığı için önemlidir.',
        category: 'Güncel',
        keywords: ['helal', 'gıda', 'beslenme', 'emanet', 'sağlık'],
        difficulty: 'Orta',
        references: ['Kuran 2:168', 'Sahih Buhari 2055', 'Sahih Müslim 1023'],
        createdAt: DateTime.now(),
      ),

      // TR: Ahlak kategorisi - Elite standartları
      // EN: Morality category - Elite standards
      KumoQuestion(
        id: '042',
        question: 'Gözün iffeti ve kalp saflığı nasıl korunur?',
        answer:
            'Gözlerini haramdan koru (Nur 24). Elite müslüman, göz iffetini kalp saflığının bir parçası olarak görür, haramdan uzak durar. Gözün iffeti, kalbin aynasıdır.',
        category: 'Ahlak',
        keywords: ['göz', 'iffet', 'kalp', 'saflık', 'haram'],
        difficulty: 'Zor',
        references: [
          'Kuran 24:30-31',
          'Sahih Buhari 5774',
          'Sahih Müslim 2665'
        ],
        createdAt: DateTime.now(),
      ),

      // TR: Toplum kategorisi - Elite standartları
      // EN: Society category - Elite standards
      KumoQuestion(
        id: '043',
        question: 'Gönül almak ve karşılıksız iyilik nasıl yapılır?',
        answer:
            'Gönül almak, Allah\'ın sevgisini paylaşmaktır (Buhari). Elite müslüman, karşılıksız iyilik yapmayı Allah rızası için yapar, gönül almanın manevi değerini bilir. İyilik, kalbi zenginleştirir.',
        category: 'Toplum',
        keywords: ['gönül', 'karşılıksız', 'iyilik', 'sevgi', 'kalp'],
        difficulty: 'Kolay',
        references: ['Sahih Buhari 6444', 'Kuran 2:261', 'Sahih Müslim 1004'],
        createdAt: DateTime.now(),
      ),

      // TR: Güncel kategorisi - Elite standartları
      // EN: Current category - Elite standards
      KumoQuestion(
        id: '044',
        question: 'İstişare etme ve danışma kültürü nasıl gelişir?',
        answer:
            'Din işlerinde danışın (Şura 38). Elite müslüman, önemli kararlarda danışmayı bir erdem olarak görür, bilge kişilerin fikrine değer verir. İstişare, doğru kararların anahtarıdır.',
        category: 'Güncel',
        keywords: ['istişare', 'danışma', 'bilge', 'karar', 'erdem'],
        difficulty: 'Orta',
        references: ['Kuran 42:38', 'Sahih Müslim 1716', 'Sahih Buhari 7145'],
        createdAt: DateTime.now(),
      ),

      // TR: Ahlak kategorisi - Elite standartları
      // EN: Morality category - Elite standards
      KumoQuestion(
        id: '045',
        question: 'Müslümanın kalitesi ve karakter özellikleri nelerdir?',
        answer:
            'Müminler ancak kardeş olurlar (Hucurat 10). Elite müslüman, karakterini Kur\'an ve sünnetle şekillendirir. Adalet, merhamet, cömertlik ve doğruluk, onun temel özellikleridir.',
        category: 'Ahlak',
        keywords: ['müslüman', 'kalite', 'karakter', 'adalet', 'merhamet'],
        difficulty: 'Orta',
        references: ['Kuran 49:10', 'Sahih Buhari 8', 'Sahih Müslim 36'],
        createdAt: DateTime.now(),
      ),

      // TR: İbadet kategorisi - Elite standartları
      // EN: Worship category - Elite standards
      KumoQuestion(
        id: '046',
        question: 'Vakit disiplini ve zaman yönetimi nasıl sağlanır?',
        answer:
            'Namazları vakitlerinde kılın (Müminun 5). Elite müslüman, vakit disiplinini hayatının merkezi yapar, zamanını Allah\'ın rızası için yönetir. Vakit, zamanı kutsallaştırır.',
        category: 'İbadet',
        keywords: ['vakit', 'disiplin', 'zaman', 'namaz', 'kutsallık'],
        difficulty: 'Orta',
        references: ['Kuran 23:5', 'Sahih Buhari 528', 'Sahih Müslim 647'],
        createdAt: DateTime.now(),
      ),

      // TR: İnanç kategorisi - Elite standartları
      // EN: Faith category - Elite standards
      KumoQuestion(
        id: '047',
        question:
            'Meleklerin görevleri ve görünmez dünyaya inancı nasıl güçlenir?',
        answer:
            'Her kulun başında iki melek vardır (Buhari). Elite müslüman, görünmez dünyaya inancını meleklerin varlığıyla pekiştirir. Melekler, Allah\'ın emirlerini yerine getiren nur varlıklardır.',
        category: 'İnanç',
        keywords: ['melek', 'görünmez', 'inanc', 'nur', 'emir'],
        difficulty: 'Zor',
        references: ['Sahih Buhari 3211', 'Kuran 13:11', 'Sahih Müslim 2867'],
        createdAt: DateTime.now(),
      ),

      // TR: İbadet kategorisi - Elite standartları
      // EN: Worship category - Elite standards
      KumoQuestion(
        id: '048',
        question: 'Peygamberlerin ortak özelliği ve tevhid mesajı nedir?',
        answer:
            'Andolsun biz her ümmete bir peygamber gönderdik (Nahl 36). Elite müslüman, tüm peygamberlerin tevhid müjdesi getirdiğini bilir. Peygamberler, insanlığı doğru yola yönlendiren elçilerdir.',
        category: 'İbadet',
        keywords: ['peygamber', 'tevhit', 'ümmet', 'elçi', 'hidayet'],
        difficulty: 'Zor',
        references: ['Kuran 16:36', 'Sahih Buhari 3456', 'İbn Kesir Tefsiri'],
        createdAt: DateTime.now(),
      ),

      // TR: İnanç kategorisi - Elite standartları
      // EN: Faith category - Elite standards
      KumoQuestion(
        id: '049',
        question: 'Kıyamet alametleri ve ahiret inancı nasıl güçlenir?',
        answer:
            'Kıyamet saati gelinceye kadar alametler vardır (Müslim). Elite müslüman, kıyamet alametlerini ahiret inancını güçlendirmek için okur, hayatını ahirete göre şekillendirir.',
        category: 'İnanç',
        keywords: ['kıyamet', 'alamet', 'ahiret', 'inanç', 'hayat'],
        difficulty: 'Zor',
        references: ['Sahih Müslim 2901', 'Kuran 27:82', 'Sahih Buhari 7135'],
        createdAt: DateTime.now(),
      ),

      // TR: Aile kategorisi - Elite standartları
      // EN: Family category - Elite standards
      KumoQuestion(
        id: '050',
        question: 'Boşanma hükümleri ve aile içi adalet nasıl sağlanır?',
        answer:
            'Boşanma, Allah\'ın en sevmediği helal şeydir (Müslim). Elite müslüman, boşanmayı son çare olarak görür, aile içi adaleti korur. Haklı nedenlerde ve adil süreçlerle boşanmak caizdir.',
        category: 'Aile',
        keywords: ['boşanma', 'aile', 'adalet', 'çözüm', 'hak'],
        difficulty: 'Zor',
        references: ['Sahih Müslim 1481', 'Kuran 4:130', 'Sahih Buhari 5273'],
        createdAt: DateTime.now(),
      ),

      // TR: Toplam 50 soru - Sygrad Elite standartlarında tamamlandı
      // EN: Total 50 questions - Completed in Sygrad Elite standards
    ];
  }

  // TR: Repository'yi başlat
  // EN: Initialize repository
  void initialize() {
    if (_questions.isEmpty) {
      _initializeQuestions();
    }
  }

  // TR: Tüm soruları al
  // EN: Get all questions
  List<KumoQuestion> getAllQuestions() {
    initialize();
    return List.from(_questions);
  }

  // TR: Kategoriye göre soruları al
  // EN: Get questions by category
  List<KumoQuestion> getQuestionsByCategory(String category) {
    initialize();
    return _questions.where((q) => q.category == category).toList();
  }

  // TR: Zorluğa göre soruları al
  // EN: Get questions by difficulty
  List<KumoQuestion> getQuestionsByDifficulty(String difficulty) {
    initialize();
    return _questions.where((q) => q.difficulty == difficulty).toList();
  }

  // TR: Anahtar kelimeye göre soru ara
  // EN: Search questions by keyword
  List<KumoQuestion> searchQuestions(String query) {
    initialize();
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return _questions.where((q) {
      // TR: Soru metninde ara
      // EN: Search in question text
      if (q.question.toLowerCase().contains(lowerQuery)) return true;

      // TR: Cevap metninde ara
      // EN: Search in answer text
      if (q.answer.toLowerCase().contains(lowerQuery)) return true;

      // TR: Anahtar kelimelerde ara
      // EN: Search in keywords
      return q.keywords
          .any((keyword) => keyword.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // TR: ID'ye göre soru al
  // EN: Get question by ID
  KumoQuestion? getQuestionById(String id) {
    initialize();
    try {
      return _questions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  // TR: Rastgele soru al
  // EN: Get random question
  KumoQuestion? getRandomQuestion({String? category}) {
    initialize();

    List<KumoQuestion> availableQuestions = _questions;

    // TR: Kategori filtreleme
    // EN: Category filtering
    if (category != null) {
      availableQuestions = getQuestionsByCategory(category);
    }

    if (availableQuestions.isEmpty) return null;

    // TR: Rastgele seçim
    // EN: Random selection
    availableQuestions.shuffle();
    return availableQuestions.first;
  }

  // TR: İlgili soruları al
  // EN: Get related questions
  List<KumoQuestion> getRelatedQuestions(String questionId, {int limit = 5}) {
    initialize();

    final currentQuestion = getQuestionById(questionId);
    if (currentQuestion == null) return [];

    // TR: Aynı kategorideki soruları al
    // EN: Get questions from same category
    final relatedQuestions = _questions
        .where(
            (q) => q.category == currentQuestion.category && q.id != questionId)
        .toList();

    // TR: Anahtar kelime benzerliğine göre sırala
    // EN: Sort by keyword similarity
    relatedQuestions.sort((a, b) {
      final aSimilarity =
          _calculateSimilarity(currentQuestion.keywords, a.keywords);
      final bSimilarity =
          _calculateSimilarity(currentQuestion.keywords, b.keywords);
      return bSimilarity.compareTo(aSimilarity);
    });

    // TR: Limit kadar döndür
    // EN: Return limited number
    return relatedQuestions.take(limit).toList();
  }

  // TR: Anahtar kelime benzerliği hesapla
  // EN: Calculate keyword similarity
  double _calculateSimilarity(List<String> keywords1, List<String> keywords2) {
    int commonKeywords = 0;

    for (final keyword1 in keywords1) {
      for (final keyword2 in keywords2) {
        if (keyword1.toLowerCase() == keyword2.toLowerCase()) {
          commonKeywords++;
          break;
        }
      }
    }

    return commonKeywords /
        (keywords1.length + keywords2.length - commonKeywords);
  }

  // TR: İstatistikleri al
  // EN: Get statistics
  Map<String, dynamic> getStatistics() {
    initialize();

    final categoryStats = <String, int>{};
    final difficultyStats = <String, int>{};

    for (final question in _questions) {
      // TR: Kategori istatistikleri
      // EN: Category statistics
      categoryStats[question.category] =
          (categoryStats[question.category] ?? 0) + 1;

      // TR: Zorluk istatistikleri
      // EN: Difficulty statistics
      difficultyStats[question.difficulty] =
          (difficultyStats[question.difficulty] ?? 0) + 1;
    }

    return {
      'totalQuestions': _questions.length,
      'categories': categoryStats,
      'difficulties': difficultyStats,
      'availableCategories': _categories,
      'availableDifficulties': _difficulties,
    };
  }

  // TR: Kategorileri al
  // EN: Get categories
  List<String> getCategories() {
    return List.from(_categories);
  }

  // TR: Zorluk seviyelerini al
  // EN: Get difficulty levels
  List<String> getDifficulties() {
    return List.from(_difficulties);
  }

  // TR: Soru ekle
  // EN: Add question
  void addQuestion(KumoQuestion question) {
    initialize();
    _questions.add(question);
  }

  // TR: Soru güncelle
  // EN: Update question
  bool updateQuestion(String id, KumoQuestion updatedQuestion) {
    initialize();

    try {
      final index = _questions.indexWhere((q) => q.id == id);
      if (index != -1) {
        _questions[index] = updatedQuestion;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // TR: Soru sil
  // EN: Delete question
  bool deleteQuestion(String id) {
    initialize();

    try {
      _questions.removeWhere((q) => q.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // TR: Repository'yi temizle
  // EN: Clear repository
  void clear() {
    _questions.clear();
  }
}

/// TR: Kumo Repository Provider - V4 yeniliği
/// EN: Kumo Repository Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
/// TR: V1'den miras alındı
/// EN: Inherited from V1
final kumoRepositoryProvider = Provider<KumoRepository>((ref) {
  return KumoRepository();
});
