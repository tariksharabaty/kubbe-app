import 'models/dua_model.dart';

class LocalDualarDb {
  static List<DuaItem> get allDualar => [
    ...quranDualari,
    ...hadisDualari,
    ...gunlukDualar,
  ];

  static List<DuaItem> get quranDualari => [
    DuaItem(
      id: 'q_1',
      category: 'quran',
      title: 'İstikamet Duası',
      arabicText: 'اِهْدِنَا الصِّرَاطَ الْمُسْتَق۪يمَۙ',
      transliteration: 'İhdine\'s-sırata\'l-mustekîm.',
      translation: 'Bizi doğru yola ilet.',
      source: 'Fatiha, 6',
    ),
    DuaItem(
      id: 'q_2',
      category: 'quran',
      title: 'Mağfiret Duası',
      arabicText: 'رَبَّنَا ظَلَمْنَٓا اَنْفُسَنَا وَاِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَASِر۪ينَ',
      transliteration: 'Rabbenâ zalemnâ enfusenâ ve in lem tağfirlenâ ve terhamnâ lenekûnenne mine\'l-hâsirîn.',
      translation: 'Rabbimiz! Biz kendimize zulmettik. Eğer bizi bağışlamaz ve bize acımazsan mutlaka ziyan edenlerden oluruz.',
      source: 'A\'râf, 23',
    ),
    DuaItem(
      id: 'q_3',
      category: 'quran',
      title: 'Zürriyet Duası',
      arabicText: 'رَبِّ اجْعَلْن۪ي مُق۪يمَ الصَّلٰوةِ وَمِنْ ذُرِّيَّت۪ي رَبَّنَا وَتَقَبَّلْ دُعَٓاءِ',
      transliteration: 'Rabbic\'alnî mukîme\'s-salâti ve min zurriyyetî rabbenâ ve tekabbel duâ.',
      translation: 'Rabbim! Beni ve neslimi namazı devamlı kılanlardan eyle. Rabbimiz! Duamı kabul et.',
      source: 'İbrahim, 40',
    ),
    DuaItem(
      id: 'q_4',
      category: 'quran',
      title: 'Darlık ve Sıkıntı Duası',
      arabicText: 'لَٓا اِلٰهَ اِلَّٓا اَنْتَ سُبْحَانَكَ اِنّ۪ي كُنْتُ مِنَ الظَّالِم۪ينَۚ',
      transliteration: 'Lâ ilâhe illâ ente subhâneke innî kuntu mine\'z-zâlimîn.',
      translation: 'Senden başka hiçbir ilâh yoktur. Seni eksikliklerden uzak tutarım. Ben gerçekten (nefsine) zulmedenlerden oldum.',
      source: 'Enbiyâ, 87',
    ),
  ];

  static List<DuaItem> get hadisDualari => [
    DuaItem(
      id: 'h_1',
      category: 'hadith',
      title: 'Af ve Afiyet Duası',
      arabicText: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعAFِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ',
      transliteration: 'Allâhumme innî es-eluke\'l-afve ve\'l-âfiyete fi\'d-dunyâ ve\'l-âhirah.',
      translation: 'Allah\'ım! Dünyada ve ahirette Senden af ve afiyet dilerim.',
      source: 'Ebu Dâvûd, Edeb, 110',
    ),
    DuaItem(
      id: 'h_2',
      category: 'hadith',
      title: 'Borç ve Kederden Kurtulma',
      arabicText: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ... وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
      transliteration: 'Allâhumme innî eûzu bike mine\'l-hemmi ve\'l-hazen... ve dale\'id-deyni ve galebeti\'r-ricâl.',
      translation: 'Allah\'ım! Kederden, hüzünden, borç yükünden ve insanların kahrından Sana sığınırım.',
      source: 'Buhari, Deavât, 36',
    ),
    DuaItem(
      id: 'h_3',
      category: 'hadith',
      title: 'Kalbi Sabitleme Duası',
      arabicText: 'يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ',
      transliteration: 'Yâ mukallibe\'l-kulûb sebbit kalbî alâ dînik.',
      translation: 'Ey kalpleri halden hale çeviren Allah\'ım! Kalbimi dinin üzere sabit kıl.',
      source: 'Tirmizi, Deavât, 71',
    ),
  ];

  static List<DuaItem> get gunlukDualar => [
    DuaItem(
      id: 'd_1',
      category: 'daily',
      title: 'Yemeğe Başlarken',
      arabicText: 'بِسْمِ اللّٰهِ وَعَلٰى بَرَكَةِ اللّٰهِ',
      transliteration: 'Bismillâhi ve alâ beraketillâh.',
      translation: 'Allah\'ın adıyla ve Allah\'ın bereketi üzerine (başlarım).',
    ),
    DuaItem(
      id: 'd_2',
      category: 'daily',
      title: 'Rabbi Yessir',
      arabicText: 'رَبِّ يَسِّرْ وَلَا تُعَسِّرْ رَبِّ تَمِّمْ بِالْخَيْرِ',
      transliteration: 'Rabbi yessir velâ tuassir Rabbi temmim bi\'l-hayr.',
      translation: 'Rabbim kolaylaştır, zorlaştırma. Rabbim sonunu hayırla tamamla.',
    ),
    DuaItem(
      id: 'd_3',
      category: 'daily',
      title: 'Sabah Duası',
      arabicText: 'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا',
      transliteration: 'Allâhumme bike asbahnâ ve bike emseynâ.',
      translation: 'Allah\'ım! Senin yardımınla sabaha ulaştık, Senin yardımınla akşama kavuştuk.',
    ),
    DuaItem(
      id: 'd_4',
      category: 'daily',
      title: 'Uyku Duası',
      arabicText: 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي',
      transliteration: 'Bismike Rabbî veda\'tu cenbî.',
      translation: 'Senin adınla Rabbim, yanımı (yatağa) koydum.',
    ),
    DuaItem(
      id: 'd_5',
      category: 'daily',
      title: 'Nazar Duası',
      arabicText: 'مَا شَاءَ اللّٰهُ لَا قُوَّةَ اِلَّا بِاللّٰهِ',
      transliteration: 'Mâşâallâhu lâ kuvvete illâ billâh.',
      translation: 'Allah ne dilerse o olur. Kuvvet ancak Allah ile birdir.',
    ),
  ];
}
