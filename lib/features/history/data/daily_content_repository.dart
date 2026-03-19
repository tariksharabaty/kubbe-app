// TR: KUBBE V4 Daily Content Repository - V1'den miras alındı
// EN: KUBBE V4 Daily Content Repository - Inherited from V1
// TR: Veri Kaynağı: V1'deki dua_data_1.dart ve ayet_verileri.dart listeleri
// EN: Data Source: V1's dua_data_1.dart and ayet_verileri.dart lists
// TR: Günün İçeriği motoru için dua ve ayet verilerini sağlar
// EN: Provides dua and ayet data for Daily Content engine
// TR: V1'deki tüm dua ve ayet içeriği korundu ve modernize edildi
// EN: All V1 dua and ayet content preserved and modernized
import '../../../core/utils/turkish_utils.dart';

/// TR: KUBBE V4 Daily Content Repository Sınıfı
/// EN: KUBBE V4 Daily Content Repository Class
/// TR: V1'deki dua_data_1.dart ve ayet_verileri.dart listelerinden miras alındı
/// EN: Inherited from V1's dua_data_1.dart and ayet_verileri.dart lists
/// TR: Günün İçeriği motoru için dua ve ayet verilerini sağlar
/// EN: Provides dua and ayet data for Daily Content engine
class DailyContentRepository {
  // TR: Dua verileri - V1'deki dua_data_1.dart'den miras alındı
  // EN: Dua data - Inherited from V1's dua_data_1.dart
  // TR: V1'deki tüm dua listesi korundu
  // EN: All V1 dua list preserved
  static final List<Dua> _duaVerileri = [
    // TR: Sabah Duası - Güne başlarken okunan dua
    // EN: Morning Dua - Prayer read at the beginning of the day
    Dua(
      id: 1,
      baslik: 'Sabah Duası',
      arapca: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
      turkce: 'Allah\'ım! Sabahleyin seninle başladık, akşamlayınca seninle bitirdik. Seninle yaşarız, seninle ölürüz. Kalkış da sanadır.',
      meali: 'Allah\'ım! Sabahleyin seninle başladık, akşamlayınca seninle bitirdik. Seninle yaşarız, seninle ölürüz. Kalkış da sanadır.',
      kategori: 'Günlük Dualar',
      zaman: 'Sabah',
    ),
    // TR: Akşam Duası - Günde biterken okunan dua
    // EN: Evening Dua - Prayer read at the end of the day
    Dua(
      id: 2,
      baslik: 'Akşam Duası',
      arapca: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ',
      turkce: 'Allah\'ım! Sen benim Rabbimsin. Senden başka ilah yoktur. Beni yaratan ve ben de senin kulum olan Sen\'in ahdine ve vaadine gücüm yettiğince uyarım.',
      meali: 'Allah\'ım! Sen benim Rabbimsin. Senden başka ilah yoktur. Beni yaratan ve ben de senin kulum olan Sen\'in ahdine ve vaadine gücüm yettiğince uyarım.',
      kategori: 'Günlük Dualar',
      zaman: 'Akşam',
    ),
    // TR: Habeşistan Duası - Kur'an'daki ünlü dua
    // EN: Habeşistan Dua - Famous dua from Quran
    Dua(
      id: 3,
      baslik: 'Habeşistan Duası',
      arapca: 'اللَّهُمَّ رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      turkce: 'Allah\'ım! Rabbimiz! Bize dünyada güzel bir hayat, ahirette de güzel bir hayat ver ve bizi cehennem azabından koru.',
      meali: 'Allah\'ım! Rabbimiz! Bize dünyada güzel bir hayat, ahirette de güzel bir hayat ver ve bizi cehennem azabından koru.',
      kategori: 'Kur\'an Duaları',
      zaman: 'Her zaman',
    ),
    // TR: Rızık Duası - Helal rızık için
    // EN: Rızık Dua - For halal sustenance
    Dua(
      id: 4,
      baslik: 'Rızık Duası',
      arapca: 'اللَّهُمَّ ارْزُقْنِي عِلْمًا نَافِعًا وَرِزْقًا طَيِّبًا وَعَمَلًا مُتَقَبَّلًا',
      turkce: 'Allah\'ım! Bana faydalı ilim, helal rızık ve kabul olunan amel ver.',
      meali: 'Allah\'ım! Bana faydalı ilim, helal rızık ve kabul olunan amel ver.',
      kategori: 'Rızık Duaları',
      zaman: 'Her zaman',
    ),
    // TR: Sağlık Duası - Sağlık için
    // EN: Sağlık Dua - For health
    Dua(
      id: 5,
      baslik: 'Sağlık Duası',
      arapca: 'اللَّهُمَّ اشْفِنِي وَاشْفِ فِيَّ الشِّفَاءَ، وَلَا تُدْرِكْنِي فِيهِ السُّقْمُ',
      turkce: 'Allah\'ım! Şifa ver ve beni şifa ile şifalandır. Bu hastalık bana ulaşmasın.',
      meali: 'Allah\'ım! Şifa ver ve beni şifa ile şifalandır. Bu hastalık bana ulaşmasın.',
      kategori: 'Sağlık Duaları',
      zaman: 'Hastalık anında',
    ),
    // TR: Namaz Sonrası Duası - Namazdan sonra
    // EN: Namaz Sonrası Dua - After prayer
    Dua(
      id: 6,
      baslik: 'Namaz Sonrası Duası',
      arapca: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ، الْحَيَّ الْقَيُّومَ، وَأَتُوبُ إِلَيْهِ',
      turkce: 'Büyük Allah\'tan, O\'ndan başka ilah olmayandan, Hay ve Kayyum olan Allah\'tan af dilerim ve O\'na tevbe ederim.',
      meali: 'Büyük Allah\'tan, O\'ndan başka ilah olmayandan, Hay ve Kayyum olan Allah\'tan af dilerim ve O\'na tevbe ederim.',
      kategori: 'Namaz Duaları',
      zaman: 'Namaz sonrası',
    ),
    // TR: Seyahat Duası - Yolculukta
    // EN: Seyahat Dua - During journey
    Dua(
      id: 7,
      baslik: 'Seyahat Duası',
      arapca: 'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى',
      turkce: 'Allah\'ım! Bu seyahatimizde senden doğruluk ve takva dileriz.',
      meali: 'Allah\'ım! Bu seyahatimizde senden doğruluk ve takva dileriz.',
      kategori: 'Seyahat Duaları',
      zaman: 'Seyahatte',
    ),
    // TR: Öğretmen Duası - İlim için
    // EN: Öğretmen Dua - For knowledge
    Dua(
      id: 8,
      baslik: 'Öğretmen Duası',
      arapca: 'رَبِّ زِدْنِي عِلْمًا وَوَفِّقْنِي لِفَهْمِهِ وَتَذَكُّرِهِ',
      turkce: 'Rabbim! Bana ilim artır, onu anlamama ve hatırlamama yardım et.',
      meali: 'Rabbim! Bana ilim artır, onu anlamama ve hatırlamama yardım et.',
      kategori: 'İlim Duaları',
      zaman: 'Ders öncesi/sonrası',
    ),
  ];

  // TR: Ayet verileri - V1'deki ayet_verileri.dart'den miras alındı
  // EN: Ayet data - Inherited from V1's ayet_verileri.dart
  // TR: V1'deki tüm ayet listesi korundu
  // EN: All V1 ayet list preserved
  static final List<Ayet> _ayetVerileri = [
    // TR: Ayetü'l-Kursi - En ünlü ayet
    // EN: Ayetü'l-Kursi - The most famous verse
    Ayet(
      id: 1,
      sure: 'Bakara',
      sureNo: 2,
      ayetNo: 255,
      ayet: 'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاء وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ',
      turkceMeali: 'Allah, kendisinden başka ilah olmayandır, O, Hay ve Kayyum\'dur. O ne bir uyuklama tutar, ne de bir uyku. Göklerde ve yerde olanların tamamı O\'nundur. O\'nun huzurunda ancak O\'nun izniyle şefaat edebilir. O, önlerinde ve arkalarında olanları bilir. Onların ilmindekinden ancak dilediği kadar kavrarlar. O\'nun kürsüsü gökleri ve yerleri kuşatmıştır. Onları korumak O\'na ağır gelmez. O, yüce ve büyüktür.',
      konu: 'Allah\'ın varlığı ve birliği',
      kategori: 'En ünlü ayetler',
    ),
    // TR: Bakara 286 - Mağfiret duası
    // EN: Bakara 286 - Forgiveness dua
    Ayet(
      id: 2,
      sure: 'Bakara',
      sureNo: 2,
      ayetNo: 286,
      ayet: 'لَّا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا أَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
      turkceMeali: 'Allah, bir kimseye ancak gücünün yettiği kadar yükler. Kazandığının karşılığını o, kazandığı günahın cezasını da çeker. Rabbimiz! Eğer unutur veya yanılış yaparsak bizi ceba etme. Rabbimiz! Bize, bize önceki ümmetlere yüklediğin gibi ağır bir yükleme. Rabbimiz! Gücümüzün yetmeyeceği şeyi bize yükleme. Bizi affet, bağışla ve merhamet et. Sen bizim mevlanımızsın, kâfirler topluluğuna karşı bize yardım et.',
      konu: 'Allah\'ın rahmeti ve mağfireti',
      kategori: 'Dualar',
    ),
    // TR: Ali İmran 173 - Zikir ve tefekkür
    // EN: Ali İmran 173 - Zikir and contemplation
    Ayet(
      id: 3,
      sure: 'Ali İmran',
      sureNo: 3,
      ayetNo: 173,
      ayet: 'الَّذِينَ يَذْكُرُونَ اللَّهَ قِيَامًا وَقُعُودًا وَعَلَىٰ جُنُوبِهِمْ وَيَتَفَكَّرُونَ فِي خَلْقِ السَّمَاوَاتِ وَالْأَرْضِ رَبَّنَا مَا خَلَقْتَ هَذَا بَاطِلًا سُبْحَانَكَ فَقِنَا عَذَابَ النَّارِ',
      turkceMeali: 'İnanan ve kalpleri Allah\'ı anmakla huzura erenler var ya. Unutmayın, kalpler ancak Allah\'ı anmakla huzura erer.',
      konu: 'Zikir ve tefekkür',
      kategori: 'İbadet',
    ),
    // TR: Maide 54 - Tövbe
    // EN: Maide 54 - Repentance
    Ayet(
      id: 4,
      sure: 'Maide',
      sureNo: 5,
      ayetNo: 54,
      ayet: 'وَمَن يَتَوَلَّ يَوْمَئِذٍ فَإِلَيْهِ مَتَاعُهُ قَلِيلًا ثُمَّ نُصَلِّيهِ جَهَنَّمَ وَذَلِكَ عَلَى اللَّهِ يَسِيرٌ',
      turkceMeali: 'O gün kim dönüp Allah\'a yönelirse, ona geçici bir meta verilir. Sonra onu cehennemde kılınırız. Bu Allah için kolaydır.',
      konu: 'Tövbe ve dönüş',
      kategori: 'Tövbe',
    ),
    // TR: En'am 152 - Vahiy ve kitaplar
    // EN: En'am 152 - Revelation and books
    Ayet(
      id: 5,
      sure: 'En\'am',
      sureNo: 6,
      ayetNo: 152,
      ayet: 'ثُمَّ آتَيْنَا مُوسَى الْكِتَابَ تَمَامًا عَلَى الَّذِي أَحْسَنَ وَبَيَّنَّا فِيهِ لِكُلِّ شَيْءٍ هُدًى وَرَحْمَةً لَّعَلَّهُم بِرَبِّهِمْ يُشْرِكُونَ',
      turkceMeali: 'Sonra Musa\'ya, her şeyde hidayet ve rahmet olmak üzere, en güzel şekilde Kitab\'ı tam olarak verdik. Umulur ki, Rablerine ortak koşmazlar.',
      konu: 'Vahiy ve kitaplar',
      kategori: 'Kur\'an',
    ),
    // TR: Araf 31 - Helal ve haram
    // EN: Araf 31 - Halal and haram
    Ayet(
      id: 6,
      sure: 'Araf',
      sureNo: 7,
      ayetNo: 31,
      ayet: 'يَا بَنِي آدَمَ خُذُوا زِينَتَكُمْ عِندَ كُلِّ مَسْجِدٍ وَكُلُوا وَاشْرَبُوا وَلَا تُسْرِفُوا إِنَّهُ لَا يُحِبُّ الْمُسْرِفِينَ',
      turkceMeali: 'Ey Adem oğulları! Her camiye gittiğinizde süsünüzü giyin. Yiyin, için ama israf etmeyin. Çünkü Allah israf edenleri sevmez.',
      konu: 'Helal ve haram',
      kategori: 'İslam yaşam tarzı',
    ),
    // TR: Rad 28 - Kalp huzuru
    // EN: Rad 28 - Heart peace
    Ayet(
      id: 7,
      sure: 'Rad',
      sureNo: 13,
      ayetNo: 28,
      ayet: 'الَّذِينَ آمَنُوا وَتَطْمَئِنَّ قُلُوبُهُم بِذِكْرِ اللَّهِ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
      turkceMeali: 'İnanan ve kalpleri Allah\'ı anmakla huzura erenler var ya. Unutmayın, kalpler ancak Allah\'ı anmakla huzura erer.',
      konu: 'Kalp huzuru',
      kategori: 'Zikir',
    ),
    // TR: İsra 82 - Kur\'an'ın şifası
    // EN: İsra 82 - Quran's healing
    Ayet(
      id: 8,
      sure: 'İsra',
      sureNo: 17,
      ayetNo: 82,
      ayet: 'وَنُنَزِّلُ مِنَ الْقُرْآنِ مَا هُوَ شِفَاءٌ وَرَحْمَةٌ لِّلْمُؤْمِنِينَ وَلَا يَزِيدُ الظَّالِمِينَ إِلَّا خَسَارًا',
      turkceMeali: 'Kur\'an\'dan müminler için bir şifa ve rahmet indirir. Zalimlere ise o, zarardan başka bir şey artırır.',
      konu: 'Kur\'an\'ın şifası',
      kategori: 'Şifa',
    ),
  ];

  // TR: Tüm duaları al - V1'den miras alındı
  // EN: Get all duas - Inherited from V1
  // TR: V1'deki tüm dua listesini döndürür
  // EN: Returns all V1 dua list
  static List<Dua> getAllDuas() {
    return List.from(_duaVerileri);
  }

  // TR: ID'ye göre dua al - V1'den miras alındı
  // EN: Get dua by ID - Inherited from V1
  // TR: Belirtilen ID'ye sahip duayı döndürür
  // EN: Returns dua with specified ID
  static Dua? getDuaById(int id) {
    try {
      return _duaVerileri.firstWhere((dua) => dua.id == id);
    } catch (e) {
      return null;
    }
  }

  // TR: Kategoriye göre dualar al - V1'den miras alındı
  // EN: Get duas by category - Inherited from V1
  // TR: Belirtilen kategoriye ait tüm duaları döndürür
  // EN: Returns all duas belonging to specified category
  static List<Dua> getDuasByCategory(String kategori) {
    return _duaVerileri.where((dua) => dua.kategori == kategori).toList();
  }

  // TR: Zaman göre dualar al - V1'den miras alındı
  // EN: Get duas by time - Inherited from V1
  // TR: Belirtilen zamana ait duaları döndürür
  // EN: Returns duas belonging to specified time
  static List<Dua> getDuasByTime(String zaman) {
    return _duaVerileri.where((dua) => dua.zaman == zaman).toList();
  }

  // TR: Tüm ayetleri al - V1'den miras alındı
  // EN: Get all ayets - Inherited from V1
  // TR: V1'deki tüm ayet listesini döndürür
  // EN: Returns all V1 ayet list
  static List<Ayet> getAllAyets() {
    return List.from(_ayetVerileri);
  }

  // TR: ID'ye göre ayet al - V1'den miras alındı
  // EN: Get ayet by ID - Inherited from V1
  // TR: Belirtilen ID'ye sahip ayeti döndürür
  // EN: Returns ayet with specified ID
  static Ayet? getAyetById(int id) {
    try {
      return _ayetVerileri.firstWhere((ayet) => ayet.id == id);
    } catch (e) {
      return null;
    }
  }

  // TR: Sureye göre ayetler al - V1'den miras alındı
  // EN: Get ayets by surah - Inherited from V1
  // TR: Belirtilen sureye ait tüm ayetleri döndürür
  // EN: Returns all ayets belonging to specified surah
  static List<Ayet> getAyetsBySurah(String sure) {
    return _ayetVerileri.where((ayet) => ayet.sure == sure).toList();
  }

  // TR: Kategoriye göre ayetler al - V1'den miras alındı
  // EN: Get ayets by category - Inherited from V1
  // TR: Belirtilen kategoriye ait tüm ayetleri döndürür
  // EN: Returns all ayets belonging to specified category
  static List<Ayet> getAyetsByCategory(String kategori) {
    return _ayetVerileri.where((ayet) => ayet.kategori == kategori).toList();
  }

  // TR: Günlük içerik al - V1'den miras alındı
  // EN: Get daily content - Inherited from V1
  // TR: Tarihe göre günlük dua ve ayet döndürür
  // EN: Returns daily dua and ayet based on date
  static DailyContent getDailyContent() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    
    final duaIndex = dayOfYear % _duaVerileri.length;
    final ayetIndex = (dayOfYear + 1) % _ayetVerileri.length; // TR: +1 farklı içerik için // EN: +1 for different content
    
    return DailyContent(
      dua: _duaVerileri[duaIndex],
      ayet: _ayetVerileri[ayetIndex],
      date: DateTime.now(),
    );
  }

  // TR: Belirli tarih için içerik al - V1'den miras alındı
  // EN: Get content for specific date - Inherited from V1
  // TR: Belirtilen tarih için günlük dua ve ayet döndürür
  // EN: Returns daily dua and ayet for specified date
  static DailyContent getContentForDate(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    
    final duaIndex = dayOfYear % _duaVerileri.length;
    final ayetIndex = (dayOfYear + 1) % _ayetVerileri.length;
    
    return DailyContent(
      dua: _duaVerileri[duaIndex],
      ayet: _ayetVerileri[ayetIndex],
      date: date,
    );
  }

  // TR: Dualar ve ayetlerde ara - V1'den miras alındı
  // EN: Search in duas and ayets - Inherited from V1
  // TR: Başlık, Türkçe, meal veya konularda arama yapar
  // EN: Searches in title, Turkish, meaning, or topics
  static List<DailyContentItem> search(String query) {
    if (query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    final results = <DailyContentItem>[];
    
    // TR: Dualarda ara
    // EN: Search in duas
    for (final dua in _duaVerileri) {
      if (dua.baslik.toLowerCase().contains(lowerQuery) ||
          dua.turkce.toLowerCase().contains(lowerQuery) ||
          dua.meali.toLowerCase().contains(lowerQuery)) {
        results.add(DailyContentItem.dua(dua));
      }
    }
    
    // TR: Ayetlerde ara
    // EN: Search in ayets
    for (final ayet in _ayetVerileri) {
      if (ayet.sure.toLowerCase().contains(lowerQuery) ||
          ayet.turkceMeali.toLowerCase().contains(lowerQuery) ||
          ayet.konu.toLowerCase().contains(lowerQuery)) {
        results.add(DailyContentItem.ayet(ayet));
      }
    }
    
    return results;
  }

  // TR: Rastgele dua al - V1'den miras alındı
  // EN: Get random dua - Inherited from V1
  // TR: Rastgele bir dua döndürür
  // EN: Returns a random dua
  static Dua getRandomDua() {
    final random = DateTime.now().millisecondsSinceEpoch % _duaVerileri.length;
    return _duaVerileri[random];
  }

  // TR: Rastgele ayet al - V1'den miras alındı
  // EN: Get random ayet - Inherited from V1
  // TR: Rastgele bir ayet döndürür
  // EN: Returns a random ayet
  static Ayet getRandomAyet() {
    final random = DateTime.now().millisecondsSinceEpoch % _ayetVerileri.length;
    return _ayetVerileri[random];
  }

  // TR: Tüm dua kategorilerini al - V1'den miras alındı
  // EN: Get all dua categories - Inherited from V1
  // TR: Mevcut tüm dua kategorilerini döndürür
  // EN: Returns all existing dua categories
  static List<String> getDuaCategories() {
    final categories = _duaVerileri.map((dua) => dua.kategori).toSet().toList();
    categories.sort();
    return categories;
  }

  // TR: Tüm ayet kategorilerini al - V1'den miras alındı
  // EN: Get all ayet categories - Inherited from V1
  // TR: Mevcut tüm ayet kategorilerini döndürür
  // EN: Returns all existing ayet categories
  static List<String> getAyetCategories() {
    final categories = _ayetVerileri.map((ayet) => ayet.kategori).toSet().toList();
    categories.sort();
    return categories;
  }
}

// TR: Dua data model - V1'den miras alındı
// EN: Dua data model - Inherited from V1
// TR: Dua bilgisi için veri modeli
// EN: Data model for dua information
class Dua {
  final int id;                     // TR: Benzersiz kimlik // EN: Unique identifier
  final String baslik;              // TR: Başlık // EN: Title
  final String arapca;             // TR: Arapça metin // EN: Arabic text
  final String turkce;             // TR: Türkçe çeviri // EN: Turkish translation
  final String meali;              // TR: Meal // EN: Meaning
  final String kategori;           // TR: Kategori // EN: Category
  final String zaman;              // TR: Zaman // EN: Time

  // TR: Constructor
  // EN: Constructor
  Dua({
    required this.id,
    required this.baslik,
    required this.arapca,
    required this.turkce,
    required this.meali,
    required this.kategori,
    required this.zaman,
  });

  // TR: Formatlanmış başlığı al - V1 Turkish utils kullanır
  // EN: Get formatted title - Uses V1 Turkish utils
  String get formattedBaslik => TurkishUtils.toTitleCase(baslik);
  
  // TR: Formatlanmış kategoriyi al - V1 Turkish utils kullanır
  // EN: Get formatted category - Uses V1 Turkish utils
  String get formattedKategori => TurkishUtils.toTitleCase(kategori);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Dua && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// TR: Ayet data model - V1'den miras alındı
// EN: Ayet data model - Inherited from V1
// TR: Kur'an ayeti için veri modeli
// EN: Data model for Quran verse
class Ayet {
  final int id;                     // TR: Benzersiz kimlik // EN: Unique identifier
  final String sure;                // TR: Sure adı // EN: Surah name
  final int sureNo;                 // TR: Sure numarası // EN: Surah number
  final int ayetNo;                 // TR: Ayet numarası // EN: Verse number
  final String ayet;                // TR: Arapça ayet // EN: Arabic verse
  final String turkceMeali;         // TR: Türkçe meal // EN: Turkish meaning
  final String konu;                // TR: Konu // EN: Topic
  final String kategori;            // TR: Kategori // EN: Category

  // TR: Constructor
  // EN: Constructor
  Ayet({
    required this.id,
    required this.sure,
    required this.sureNo,
    required this.ayetNo,
    required this.ayet,
    required this.turkceMeali,
    required this.konu,
    required this.kategori,
  });

  // TR: Formatlanmış sure adını al - V1 Turkish utils kullanır
  // EN: Get formatted surah name - Uses V1 Turkish utils
  String get formattedSure => TurkishUtils.toTitleCase(sure);
  
  // TR: Formatlanmış konuyu al - V1 Turkish utils kullanır
  // EN: Get formatted topic - Uses V1 Turkish utils
  String get formattedKonu => TurkishUtils.toTitleCase(konu);
  
  // TR: Sure bilgisini al
  // EN: Get surah information
  String get sureInfo => '$sure Suresi $ayetNo. Ayet';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ayet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// TR: Günlük içerik model - V1'den miras alındı
// EN: Daily content model - Inherited from V1
// TR: Günlük dua ve ayet için veri modeli
// EN: Data model for daily dua and ayet
class DailyContent {
  final Dua dua;                    // TR: Günlük dua // EN: Daily dua
  final Ayet ayet;                  // TR: Günlük ayet // EN: Daily ayet
  final DateTime date;              // TR: Tarih // EN: Date

  // TR: Constructor
  // EN: Constructor
  DailyContent({
    required this.dua,
    required this.ayet,
    required this.date,
  });

  // TR: Formatlanmış tarihi al
  // EN: Get formatted date
  String get formattedDate => '${date.day}/${date.month}/${date.year}';
}

// TR: Günlük içerik öğesi - Arama sonuçları için
// EN: Daily content item - For search results
// TR: Arama sonuçları için veri modeli
// EN: Data model for search results
class DailyContentItem {
  final Dua? dua;                  // TR: Dua // EN: Dua
  final Ayet? ayet;                // TR: Ayet // EN: Ayet

  // TR: Constructor
  // EN: Constructor
  DailyContentItem({this.dua, this.ayet});

  // TR: Dua factory constructor
  // EN: Dua factory constructor
  factory DailyContentItem.dua(Dua dua) => DailyContentItem(dua: dua);
  
  // TR: Ayet factory constructor
  // EN: Ayet factory constructor
  factory DailyContentItem.ayet(Ayet ayet) => DailyContentItem(ayet: ayet);

  // TR: Başlığı al
  // EN: Get title
  String get title => dua?.formattedBaslik ?? ayet?.formattedSure ?? '';
  
  // TR: Alt başlığı al
  // EN: Get subtitle
  String get subtitle => dua?.formattedKategori ?? ayet?.formattedKonu ?? '';
  
  // TR: İçeriği al
  // EN: Get content
  String get content => dua?.meali ?? ayet?.turkceMeali ?? '';
  
  // TR: Türünü al
  // EN: Get type
  String get type => dua != null ? 'Dua' : 'Ayet';
}
