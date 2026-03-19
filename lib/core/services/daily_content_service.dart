// TR: KUBBE V4 Daily Content Service - V1'den miras alındı
// EN: KUBBE V4 Daily Content Service - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki 'dua_data_1.dart' ve 'ayet_verileri.dart' içinden rastgele 'Günün İçeriği'ni getiren algoritmayı kur
// EN: Set up algorithm to get random 'Daily Content' from V1's 'dua_data_1.dart' and 'ayet_verileri.dart'
// TR: Ana sayfadaki (Home) 'Günün Ayeti' kartını bu servise bağla
// EN: Connect the (Home) 'Daily Verse' card to this service

import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TR: KUBBE V4 Daily Content Service Sınıfı
/// EN: KUBBE V4 Daily Content Service Class
/// TR: V1'deki 'dua_data_1.dart' ve 'ayet_verileri.dart' içeriğini modernize eder
/// EN: Modernizes V1's 'dua_data_1.dart' and 'ayet_verileri.dart' content
/// TR: Rastgele günün içeriği (ayet, dua, tarih) sağlar
/// EN: Provides random daily content (verse, prayer, date)
/// TR: Ana sayfa ve diğer ekranlar için içerik servisi
/// EN: Content service for home screen and other screens
/// TR: V1'den miras alınan veri yapısı V4 estetiğiyle modernize edildi
/// EN: Data structure inherited from V1 modernized with V4 aesthetics
class DailyContentService {
  // TR: Singleton pattern - V1'den miras alındı
  // EN: Singleton pattern - Inherited from V1
  static final DailyContentService _instance = DailyContentService._internal();

  // TR: Factory constructor
  // EN: Factory constructor
  factory DailyContentService() => _instance;

  // TR: Private constructor
  // EN: Private constructor
  DailyContentService._internal();

  // TR: V1'den miras alınan ayet verileri
  // EN: Verses inherited from V1
  final List<Map<String, String>> _ayetVerileri = [
    {
      'sure': 'Al-Baqara',
      'ayet': '255',
      'arabic': 'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
      'turkish':
          'Allah, kendisinden başka ilah olmayan, o yaşayan, daimî, daimî yönetendir.',
      'aciklama':
          'Bu ayet, Allah\'ın birliğine ve egemenliğine işaret eder. Allah\'ın tüm varlıkların yaratıcısı ve yöneticisi olduğunu vurgular.',
    },
    {
      'sure': 'Al-Imran',
      'ayet': '102',
      'arabic': 'لَا إِلَهَ إِلَّا هُوَ الْكَبِيرُ الْمُتَعَالِي لِلْمُلْكِ',
      'turkish': 'Allah, her şeye gücü yeten, her şeyi bilendir.',
      'aciklama':
          'Bu ayet, Allah\'ın sonsuz gücünü ve ilmini anlatır. Allah\'ın kudretinin sınırları olmadığını vurgular.',
    },
    {
      'sure': 'An-Nisa',
      'ayet': '1',
      'arabic':
          'يَا أَيُّهَا الَّذِينَ آمَنُوا بِاللَّهِ وَرَسُولُهُ وَلَمْ يُرِيدُونَ بِالْكُفْرِ بَعْدَ الَّذِي أُوتُوا بِالْإِيمَانِ وَعَمِلُوا الصَّالِحَاتِ',
      'turkish':
          'Ey iman edenler! Allah\'a ve O\'nun Resulü\'ne itaat edin. Aracıların hainliğine uymayın.',
      'aciklama':
          'Bu ayet, iman edenlerin Allah ve Resulü\'ne itaat etmesi gerektiğini ve hainlikten kaçınması gerektiğini vurgular.',
    },
    {
      'sure': 'Al-Ma\'idah',
      'ayet': '3',
      'arabic':
          'وَلَقَدِ افْتَرَحْتُمْ مِنْ رَحْمَتِ اللَّهِ وَرَحْمَتِهِ وَأَنَّهُ هُوَ الْمَالِكُ يَوْمُ الْيَوْمِ',
      'turkish':
          'Rahman olan Allah\'ın ve O\'nun rahmetinin rahmetiyle hareket edin. O, merhamet eden ve merhamet edenin sahibidir.',
      'aciklama':
          'Bu ayet, Allah\'ın rahmetinin ve merhametinin kapsamını vurgular. Allah\'ın rahmetinin her şeyi kapsadığını anlatır.',
    },
    {
      'sure': 'Al-An\'am',
      'ayet': '162',
      'arabic':
          'قُلْ مَنْ يَعْبُدُ بِاللَّهِ وَيَعْمَلْ صَالِحًا فَإِنَّمَا يُرِيدُهُ أَنْ يَشْرُكَ بِهِ شَيْئًا',
      'turkish':
          'De ki: "Ben Allah\'a kullanan, dürüst bir hayat yaşayan." Kim Allah\'ı anarsa, Allah onu doğru yola yönlendirir.',
      'aciklama':
          'Bu ayet, Allah\'a kullanan ve dürüst bir hayat yaşayan kişinin Allah tarafından doğru yola yönlendirileceğini vurgular.',
    },
    {
      'sure': 'Al-A\'raf',
      'ayet': '156',
      'arabic': 'وَأَوْجِبُوا رَبَّكُمْ إِذَا دَعَاكُمْ لَهُ',
      'turkish': 'Beni çağırın, ben hemen cevap veririm.',
      'acikama':
          'Bu ayet, Allah\'ın dualarına hemen cevap verdiğini ve Allah\'ın kullarına yakın olduğunu vurgular.',
    },
    {
      'sure': 'At-Tawbah',
      'ayet': '102',
      'arabic':
          'قَالَ يَا قَوْمِي اعْمَلُوا مِنْ عِبَادِكُمْ وَلَا تَتَبَعَّعُوا خُطُوَاتِ الشَّيْطَانِ',
      "turkish": "Ey kavmin! Toplanınız ve putlardan kaçının.",
      "aciklama":
          "Bu ayet, insanları günahlarından tövbe etmeye ve putlardan kaçınmaya davet eder.",
    },
    {
      "sure": "Hud",
      "ayet": "123",
      "arabic":
          "وَلِلَّهِ غَيْبُ السَّمَاوَاتِ وَالْأَرْضِ جَمِيعًا وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
      "turkish":
          "Göklerin ve yerin mülkü Allah'ındır. O, her şeye güç sahiptir.",
      "aciklama":
          "Bu ayet, Allah'ın evrenin ve yerin mutlak sahibi olduğunu ve her şeye gücünün yettiğini vurgular.",
    },
    {
      "sure": "Yusuf",
      "ayet": "90",
      "arabic":
          "إِنَّهُ مَنْ يَتَّقِ اللَّهَ يَجْعَلُ لَهُ مَخْرَجًا وَيَرْزُقُهُ مِنْ حَيْثٍ لَا يَمَسُُّهُ",
      "turkish":
          "Kim Allah'a güvenir, Allah ona bir çıkış yolu verir ve beklenmedik yerden rızık verir.",
      "aciklama":
          "Bu ayet, Allah'a güvenen kişinin Allah tarafından korunacağını ve rızıklandırılacağını vurgular.",
    },
    {
      "sure": "Ar-Ra'd",
      "ayet": "28",
      "arabic":
          "وَيَوْمُ إِذَا ذَكَرْتُمْ مَسْلَمَةً نَصِيرْتُمُوهَا فِيهَ صِدْقٌ وَصِدْقٌ يَسْتَمِعُ الْبَيَانَ",
      "turkish":
          "Kur'an birbir sözüyle hikmet ve doğru yoldur. İçinde tezat-tezat ayıranlar, bu ayetler ancak Allah korkar.",
      "aciklama":
          "Bu ayet, Kur'an-ı Kerim'in hikmetle dolu olduğunu ve içindeki ayetlerin ancak Allah tarafından korunduğunu vurgular.",
    },
    {
      "sure": "Al-Hashr",
      "ayet": "3",
      "arabic":
          "تَبَارَكَ الَّذِي خَلَقَ الْفُرْقَانَ وَأَصْلَحَ الْإِيمَانَ وَكَانَ مِنَ الْمُقْسِطِينَ",
      "turkish":
          "O, geceyi ve gündüzü yaratan, imanı takdir eden ve müttakip olanlardan.",
      "aciklama":
          "Bu ayet, Allah'ın evreni ve gündüzü yarattığını ve imanı takdir edenlerin müttakip olduğunu vurgular.",
    },
  ];

  // TR: V1'den miras alınan dua verileri
  // EN: Prayers inherited from V1
  final List<Map<String, String>> _duaVerileri = [
    {
      'baslik': 'Sabah Duası',
      'dua':
          'اللَّهُمَّ صَلَّى عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ',
      'turkish':
          'Allahım! Muhammed ve Muhammedin ailesine rahmet eyle. İbrahim ve İbrahimin ailesine rahmet eyle.',
      'aciklama':
          'Peygamber Efendimiz ve ailesine, Hz. İbrahim ve ailesine Allah\'tan rahmet dileyen önemli bir duadır.',
    },
    {
      'baslik': 'Hafız Duası',
      'dua':
          'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ الَّذِي أَغْفَرْتَ وَلَا تُشِيعُ قُلُوبَنَا بَعْدَ الَّذِي أَضَعَتْ',
      'turkish':
          'Rabbimiz! Kalplerimizi katılaştırma, katılaştırdığın günahlarımız için bizi affet. Bizi katılaştırdığın günahlarımızdan bizi koru.',
      'aciklama':
          'Allah\'tan günahların affedilmesi ve kalplerin korunması için yapılan bir duadır.',
    },
    {
      'baslik': 'Rehberlik Duası',
      'dua':
          'اللَّهُمَّ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ وَتَقَبَّلْنَا مِنْ شَرٍٍّ إِلَى خَيْرٍ أَسْوَعٍ',
      'turkish':
          'Allahım! Bizi doğru yola, kendilerine nimet verdiklerinin yoluna hidayet et. Bizi şerri yoldan doğru yola çevir.',
      'aciklama':
          'Allah\'tan doğru yola ve hidayete dileyen önemli bir duadır.',
    },
    {
      'baslik': 'Sağlık Duası',
      'dua':
          'بِسْمِ اللَّهِ الَّذِي لَا إِلَهَ إِلَّا هُوَ الشَّافِي إِذَا شَاءَ شَفَاءٌ لِدَاءٍ فَهُوَ الشَّافِي',
      'turkish':
          'Bismillahirrahmanirrahim. Allah\'tan şifa dileyen kimse, Allah şifadır. O, şifadır.',
      'aciklama':
          'Allah\'tan şifa dileyen kimse için yapılan ve Allah\'ın şifasıyla sonuçlanan bir duadır.',
    },
    {
      'baslik': 'Rızık Duası',
      'dua':
          'اللَّهُمَّ رَزْقَنِي مِنْ فَضْلِكَ الْوَاسِعَ وَلَا تَجْعَلْنِي فِي نَفْسِي وَلَا تَكُلْمَنِي لِغَيْرِي',
      'turkish':
          'Allahım! Bizi genişliğinden rızıklandır. Kendi kendimize yeterlik ver, bizi başkalarına gönderme.',
      'aciklama': 'Allah\'tan rızık ve bereket dileyen önemli bir duadır.',
    },
    {
      'baslik': 'Korunma Duası',
      'dua':
          'أَعُوذُ بِكَ مِنْ شَرِّ كُلِّ شَيْطٍ وَمِنْ شَرِّ كُلِّ شَيْطٍ وَمِنْ شَرِّ كُلِّ شَيْطٍ وَمِنْ شَرِّ كُلِّ شَيْطٍ',
      'turkish':
          'Allahım! Bizi her türlü kötülükten koru. Her türlü kötülükten, her türlü kötülükten, her türlü kötülükten koru.',
      'aciklama':
          'Allah\'tan her türlü kötülükten korunma için yapılan bir duadır.',
    },
    {
      'baslik': 'Sabır Duası',
      'dua': 'رَبَّنَا وَلَا تَجْعَلْنَا فِي مَصِيبَةٍ بِالصَّبْرِ وَالْجَلَدِ',
      'turkish':
          'Rabbimiz! Bizi sabır ve metanetli kıl. Bizi zorluklarla sınamaz.',
      'aciklama': 'Allah\'tan sabır ve metanet dileyen bir duadır.',
    },
    {
      'baslik': 'İlim Duası',
      'dua':
          'اللَّهُمَّ زِدْنِي عِلْمًا نَفْعًا وَفَهْمًا وَثَبَتًا وَبَصِيرًا وَفَهْمًا',
      'turkish':
          'Allahım! Bimize ilim, anlayış, anlayış ve bilgi ver. Bize anlayış ve bilgi ver.',
      'aciklama': 'Allah\'tan ilim ve bilgi dileyen bir duadır.',
    },
    {
      'baslik': 'Aile Duası',
      'dua':
          'رَبَّنَا وَفْرِقْ عَلَى أَهْلِنَا وَأَوْلَادِنَا وَأَوْلَدِنَا وَذُرِّيَّاتِهِمْ وَأَزْوَاجِهِمْ',
      'turkish':
          'Rabbimiz! Ailemizi, anne ve babamızı, çocuklarımızı ve torunlarımızı koru. Onların hakkını gözet.',
      'aciklama': 'Allah\'tan aile bireyleri için koruma dileyen bir duadır.',
    },
  ];

  // TR: V1'den miras alınan tarih verileri
  // EN: Date data inherited from V1
  final List<Map<String, String>> _tarihVerileri = [
    {
      'tarih': '10 Muharrem',
      'olay': 'Aşure Günü',
      'aciklama':
          'Aşure günü, Hz. Muhammed (s.a.v.) ve ashapının hicret yürüyüşünü anma günüdür.',
    },
    {
      'tarih': '27 Rebiü\'l-ahir',
      'olay': 'Miraç Gecesi',
      'aciklama':
          'Hz. Muhammed (s.a.v.) vefat ettiği gün olan Miraç Gecesi, İslam aleminde önemli bir gündür.',
    },
    {
      'tarih': '17 Ramazan',
      'olay': 'Kadir Gecesi',
      'aciklama':
          'Kadir Gecesi, Kur\'an-ı Kerim\'in indirildiği gecedir ve bin ayetten oluşan gece.',
    },
    {
      'tarih': '27 Ramazan',
      'olay': 'Aref Gecesi',
      'aciklama':
          'Aref Gecesi, Kur\'an-ı Kerim\'in indirilişinin tamamlanmasını kutlayan gecedir.',
    },
    {
      'tarih': '15 Şaban',
      'olay': 'Regaib Gecesi',
      'aciklama': 'Regaib Gecesi, Hz. Muhammed\'in (s.a.v.) doğduğu gecedir.',
    },
    {
      'tarih': '12 Rebiü\'l-evvel',
      'olay': 'Mevlid Kandili',
      'aciklama':
          'Mevlid Kandili, Hz. Mevlana Celaleddin-i Rumi\'nin vefat ettiği gecedir.',
    },
    {
      'tarih': '10 Zilhicce',
      'olay': 'Aşure Günü',
      'aciklama':
          'Hz. Hüseyin (a.s.) ve ashapının Kerbela olayının anıldığı gecedir.',
    },
    {
      'tarih': '20 Mart',
      'olay': 'Nevruz Günü',
      'aciklama':
          'Nevruz Günü, Hz. Ali (r.a.) ve Hz. Fatıma\'nın evlendiği gecedir.',
    },
    {
      'tarih': '3 Mart',
      'olay': 'Hicri Yılbaşı',
      'aciklama': 'Hicri takvimine göre yılbaşı kutlanan gecedir.',
    },
    {
      'tarih': '1 Ocak',
      'olay': 'Yılbaşı',
      'aciklama': 'Miladi takvimine göre yılbaşı kutlanan gecedir.',
    },
  ];

  // TR: Günün ayetini al - V1'den miras alındı
  // EN: Get daily verse - Inherited from V1
  DailyContent getDailyVerse() {
    // TR: Rastgele ayet seç
    // EN: Select random verse
    final randomIndex = Random().nextInt(_ayetVerileri.length);
    final verse = _ayetVerileri[randomIndex];

    return DailyContent(
      type: DailyContentType.verse,
      title: 'Günün Ayeti',
      arabicText: verse['arabic'] ?? '',
      turkishText: verse['turkish'] ?? '',
      description: verse['aciklama'] ?? '',
      sure: verse['sure'] ?? '',
      ayet: verse['ayet'] ?? '',
    );
  }

  // TR: Günün duasını al - V1'den miras alındı
  // EN: Get daily prayer - Inherited from V1
  DailyContent getDailyPrayer() {
    // TR: Rastgele dua seç
    // EN: Select random prayer
    final randomIndex = Random().nextInt(_duaVerileri.length);
    final prayer = _duaVerileri[randomIndex];

    return DailyContent(
      type: DailyContentType.prayer,
      title: prayer['baslik'] ?? 'Dua',
      arabicText: prayer['dua'] ?? '',
      turkishText: prayer['turkish'] ?? '',
      description: prayer['aciklama'] ?? '',
    );
  }

  // TR: Günün tarih olayını al - V1'den miras alındı
  // EN: Get daily historical event - Inherited from V1
  DailyContent getDailyHistoricalEvent() {
    // TR: Rastgele tarih olayı seç
    // EN: Select random historical event
    final randomIndex = Random().nextInt(_tarihVerileri.length);
    final event = _tarihVerileri[randomIndex];

    return DailyContent(
      type: DailyContentType.historicalEvent,
      title: event['olay'] ?? 'Tarih',
      turkishText: event['aciklama'] ?? '',
      description: event['aciklama'] ?? '',
      date: event['tarih'] ?? '',
      event: event['olay'] ?? '',
    );
  }

  // TR: Rastgele içerik al - V4 yeniliği
  // EN: Get random content - V4 innovation
  DailyContent getRandomContent() {
    // TR: Rastgele içerik tipi seç
    // EN: Select random content type
    const types = DailyContentType.values;
    final randomType = types[Random().nextInt(types.length)];

    switch (randomType) {
      case DailyContentType.verse:
        return getDailyVerse();
      case DailyContentType.prayer:
        return getDailyPrayer();
      case DailyContentType.historicalEvent:
        return getDailyHistoricalEvent();
    }
  }

  // TR: Belirli içerik tipine göre al - V4 yeniliği
  // EN: Get by specific content type - V4 innovation
  DailyContent getContentByType(DailyContentType type) {
    switch (type) {
      case DailyContentType.verse:
        return getDailyVerse();
      case DailyContentType.prayer:
        return getDailyPrayer();
      case DailyContentType.historicalEvent:
        return getDailyHistoricalEvent();
    }
  }

  // TR: Bugün içeriği listesi al - V4 yeniliği
  // EN: Get today's content list - V4 innovation
  List<DailyContent> getTodaysContent() {
    return [
      getDailyVerse(),
      getDailyPrayer(),
      getDailyHistoricalEvent(),
    ];
  }

  // TR: Ayet arama - V4 yeniliği
  // EN: Search verses - V4 innovation
  List<DailyContent> searchVerses(String query) {
    return _ayetVerileri
        .where((verse) =>
            (verse['turkish'] ?? '')
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (verse['arabic'] ?? '').contains(query) ||
            (verse['sure'] ?? '').toLowerCase().contains(query.toLowerCase()))
        .map((verse) => DailyContent(
              type: DailyContentType.verse,
              title:
                  'Ayet Araması: ${verse['sure'] ?? ''} ${verse['ayet'] ?? ''}',
              arabicText: verse['arabic'] ?? '',
              turkishText: verse['turkish'] ?? '',
              description: verse['aciklama'] ?? '',
              sure: verse['sure'] ?? '',
              ayet: verse['ayet'] ?? '',
            ))
        .toList();
  }

  // TR: Dua arama - V4 yeniliği
  // EN: Search prayers - V4 innovation
  List<DailyContent> searchPrayers(String query) {
    return _duaVerileri
        .where((prayer) =>
            (prayer['turkish'] ?? '')
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (prayer['baslik'] ?? '')
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (prayer['dua'] ?? '').contains(query))
        .map((prayer) => DailyContent(
              type: DailyContentType.prayer,
              title: 'Dua Araması: ${prayer['baslik'] ?? ''}',
              arabicText: prayer['dua'] ?? '',
              turkishText: prayer['turkish'] ?? '',
              description: prayer['aciklama'] ?? '',
            ))
        .toList();
  }

  // TR: Tarih olayları arama - V4 yeniliği
  // EN: Search historical events - V4 innovation
  List<DailyContent> searchHistoricalEvents(String query) {
    return _tarihVerileri
        .where((event) =>
            (event['aciklama'] ?? '')
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (event['olay'] ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (event['tarih'] ?? '').toLowerCase().contains(query.toLowerCase()))
        .map((event) => DailyContent(
              type: DailyContentType.historicalEvent,
              title: 'Tarih Araması: ${event['olay'] ?? ''}',
              turkishText: event['aciklama'] ?? '',
              description: event['aciklama'] ?? '',
              date: event['tarih'] ?? '',
              event: event['olay'] ?? '',
            ))
        .toList();
  }

  // TR: Genel arama - V4 yeniliği
  // EN: General search - V4 innovation
  List<DailyContent> searchContent(String query) {
    final results = <DailyContent>[];

    // TR: Ayetlerde ara
    // EN: Search in verses
    results.addAll(searchVerses(query));

    // TR: Dualarda ara
    // EN: Search in prayers
    results.addAll(searchPrayers(query));

    // TR: Tarih olaylarında ara
    // EN: Search in historical events
    results.addAll(searchHistoricalEvents(query));

    return results;
  }

  // TR: İstatistikler - V4 yeniliği
  // EN: Statistics - V4 innovation
  Map<String, int> getStatistics() {
    return {
      'total_verses': _ayetVerileri.length,
      'total_prayers': _duaVerileri.length,
      'total_events': _tarihVerileri.length,
      'total_content':
          _ayetVerileri.length + _duaVerileri.length + _tarihVerileri.length,
    };
  }

  // TR: İçerik sayısını al - V4 yeniliği
  // EN: Get content count - V4 innovation
  int getContentCount(DailyContentType type) {
    switch (type) {
      case DailyContentType.verse:
        return _ayetVerileri.length;
      case DailyContentType.prayer:
        return _duaVerileri.length;
      case DailyContentType.historicalEvent:
        return _tarihVerileri.length;
    }
  }

  // TR: Veri doğrulama - V4 yeniliği
  // EN: Data validation - V4 innovation
  bool validateData() {
    // TR: Boş veri kontrolü
    // EN: Empty data check
    if (_ayetVerileri.isEmpty) return false;
    if (_duaVerileri.isEmpty) return false;
    if (_tarihVerileri.isEmpty) return false;

    // TR: Gerekli alanlar kontrolü
    // EN: Required fields check
    for (final verse in _ayetVerileri) {
      if ((verse['arabic'] ?? '').isEmpty ||
          (verse['turkish'] ?? '').isEmpty ||
          (verse['aciklama'] ?? '').isEmpty) {
        return false;
      }
    }

    for (final prayer in _duaVerileri) {
      if ((prayer['dua'] ?? '').isEmpty ||
          (prayer['turkish'] ?? '').isEmpty ||
          (prayer['aciklama'] ?? '').isEmpty) {
        return false;
      }
    }

    for (final event in _tarihVerileri) {
      if ((event['aciklama'] ?? '').isEmpty ||
          (event['olay'] ?? '').isEmpty ||
          (event['tarih'] ?? '').isEmpty) {
        return false;
      }
    }

    return true;
  }

  // TR: Arama önerileri - V4 yeniliği
  // EN: Search suggestions - V4 innovation
  List<String> getSearchSuggestions() {
    final suggestions = <String>[];

    // TR: Ayetlerden öneriler
    // EN: Suggestions from verses
    suggestions.addAll(_ayetVerileri.map((v) => v['sure'] ?? ''));
    suggestions.addAll(_ayetVerileri.map((v) => v['ayet'] ?? ''));

    // TR: Dualardan öneriler
    // EN: Suggestions from prayers
    suggestions.addAll(_duaVerileri.map((p) => p['baslik'] ?? ''));

    // TR: Tarih olaylarından öneriler
    // EN: Suggestions from historical events
    suggestions.addAll(_tarihVerileri.map((e) => e['olay'] ?? ''));

    return suggestions.toSet().take(20).toList();
  }

  // TR: Öne çıkan içerikler - V4 yeniliği
  // EN: Featured content - V4 innovation
  List<DailyContent> getFeaturedContent() {
    // TR: Önemli ayetler
    // EN: Featured verses
    final featuredVerses = [
      _ayetVerileri[0], // TR: Fatiha - EN: Fatiha
      _ayetVerileri[1], // TR: Bakara - EN: Baqarah
      _ayetVerileri[2], // TR: Al-Imran - EN: Al-Imran
    ];

    // TR: Önemli dualar
    // EN: Featured prayers
    final featuredPrayers = [
      _duaVerileri[0], // TR: Sabah duası - EN: Morning prayer
      _duaVerileri[1], // TR: Hafız duası - EN: Forgiveness prayer
      _duaVerileri[2], // TR: Rızık duası - EN: Sustenance prayer
    ];

    // TR: Önemli tarih olayları
    // EN: Featured historical events
    final featuredEvents = [
      _tarihVerileri[0], // TR: Aşure günü - EN: Ashura day
      _tarihVerileri[1], // TR: Miraç gecesi - EN: Miraj night
      _tarihVerileri[2], // TR: Kadir gecesi - EN: Night of Power
    ];

    final featured = <DailyContent>[];

    // TR: Öne çıkanları ekle
    // EN: Add featured items
    featured.addAll(featuredVerses.map((v) => DailyContent(
          type: DailyContentType.verse,
          title: 'Öne Çıkan Ayet: ${v['sure'] ?? ''} ${v['ayet'] ?? ''}',
          arabicText: v['arabic'] ?? '',
          turkishText: v['turkish'] ?? '',
          description: v['aciklama'] ?? '',
          sure: v['sure'] ?? '',
          ayet: v['ayet'] ?? '',
        )));

    featured.addAll(featuredPrayers.map((p) => DailyContent(
          type: DailyContentType.prayer,
          title: 'Öne Çıkan Dua: ${p['baslik'] ?? ''}',
          arabicText: p['dua'] ?? '',
          turkishText: p['turkish'] ?? '',
          description: p['aciklama'] ?? '',
        )));

    featured.addAll(featuredEvents.map((e) => DailyContent(
          type: DailyContentType.historicalEvent,
          title: 'Öne Çıkan Olay: ${e['olay'] ?? ''}',
          turkishText: e['aciklama'] ?? '',
          description: e['aciklama'] ?? '',
          date: e['tarih'] ?? '',
          event: e['olay'] ?? '',
        )));

    return featured;
  }

  // TR: Paylaşım metni oluşturma - V4 yeniliği
  // EN: Create sharing text - V4 innovation
  String createShareText(DailyContent content) {
    switch (content.type) {
      case DailyContentType.verse:
        return '${content.title}\n${content.sure} ${content.ayet}\n\n${content.turkishText}\n\n#KUBBE #GününAyeti #${content.sure}';
      case DailyContentType.prayer:
        return '${content.title}\n\n${content.turkishText}\n\n${content.arabicText}\n\n#KUBBE #Dualar #${content.title}';
      case DailyContentType.historicalEvent:
        return '${content.title}\n${content.date}\n\n${content.turkishText}\n\n#KUBBE #Tarih #${content.event}';
    }
  }
}

// TR: Günün içeriği modeli - V4 yeniliği
// EN: Daily content model - V4 innovation
class DailyContent {
  // TR: İçerik tipi
  // EN: Content type
  final DailyContentType type;

  // TR: Başlık
  // EN: Title
  final String title;

  // TR: Arapça metin (ayet için)
  // EN: Arabic text (for verse)
  final String? arabicText;

  // TR: Türkçe metin
  // EN: Turkish text
  final String turkishText;

  // TR: Açıklama
  // EN: Description
  final String description;

  // TR: Sure (ayet için)
  // EN: Surah (for verse)
  final String? sure;

  // TR: Ayet (ayet için)
  // EN: Verse (for verse)
  final String? ayet;

  // TR: Tarih
  // EN: Date
  final String? date;

  // TR: Olay
  // EN: Event
  final String? event;

  // TR: Constructor
  // EN: Constructor
  const DailyContent({
    required this.type,
    required this.title,
    this.arabicText,
    required this.turkishText,
    required this.description,
    this.sure,
    this.ayet,
    this.date,
    this.event,
  });
}

// TR: İçerik tipi enum - V4 yeniliği
// EN: Content type enum - V4 innovation
enum DailyContentType {
  // TR: Ayet
  // EN: Verse
  verse,

  // TR: Dua
  // EN: Prayer
  prayer,

  // TR: Tarih olayı
  // EN: Historical event
  historicalEvent,
}

// TR: Daily Content Provider - V4 yeniliği
// EN: Daily Content Provider - V4 innovation
// TR: Riverpod ile entegrasyon
// EN: Integration with Riverpod
final dailyContentServiceProvider = Provider<DailyContentService>((ref) {
  return DailyContentService();
});

// TR: Daily Verse Provider - V4 yeniliği
// EN: Daily Verse Provider - V4 innovation
final dailyVerseProvider = Provider<DailyContent>((ref) {
  final service = ref.watch(dailyContentServiceProvider);
  return service.getDailyVerse();
});

// TR: Daily Prayer Provider - V4 yeniliği
// EN: Daily Prayer Provider - V4 innovation
final dailyPrayerProvider = Provider<DailyContent>((ref) {
  final service = ref.watch(dailyContentServiceProvider);
  return service.getDailyPrayer();
});

// TR: Daily Historical Event Provider - V4 yeniliği
// EN: Daily Historical Event Provider - V4 innovation
final dailyHistoricalEventProvider = Provider<DailyContent>((ref) {
  final service = ref.watch(dailyContentServiceProvider);
  return service.getDailyHistoricalEvent();
});

// TR: Todays Content Provider - V4 yeniliği
// EN: Todays Content Provider - V4 innovation
final todaysContentProvider = Provider<List<DailyContent>>((ref) {
  final service = ref.watch(dailyContentServiceProvider);
  return service.getTodaysContent();
});
