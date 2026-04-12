import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class IlmihalItem {
  final String id;
  final String title;
  final String category; // farz, sunnet, rehber
  final String content;
  final List<String>? steps;
  final List<IconData>? stepIcons;

  IlmihalItem({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    this.steps,
    this.stepIcons,
  });
}

class PrayerItem {
  final String title;
  final String arabic;
  final String pronunciation;
  final String meaning;

  PrayerItem({
    required this.title,
    required this.arabic,
    required this.pronunciation,
    required this.meaning,
  });
}

class HadithItem {
  final String content;
  final String source;

  HadithItem({
    required this.content,
    required this.source,
  });
}

class IlmihalRepository {
  static List<IlmihalItem> allIlmihalItems = [
    IlmihalItem(
      id: "namaz_nasil_kilinir",
      title: "Namaz Nasıl Kılınır?",
      category: "rehber",
      content: "Namaz, İslam'ın beş şartından biri olup, müminin miracıdır. Günde beş vakit eda edilen bu ibadet, kulun Rabbine en yakın olduğu andır. Namaz kılmak için öncelikle niyet edilir, ardından tekbir getirilerek kıyama durulur. Her rekatta Fatiha suresi ve bir zamm-ı sure okunur. Rükû ve secdelerle devam eden namaz, tahiyyata oturulup selam verilerek tamamlanır.",
      steps: [
        "Niyet: Hangi namaz kılınacaksa ona göre kalben niyet edilir.",
        "İftitah Tekbiri: 'Allahu Ekber' diyerek namaza başlanır.",
        "Kıyam: Ayakta durup Kur'an-ı Kerim okunur (Sübhâneke, Fatiha ve bir sure).",
        "Rükû: 'Sübhâne Rabbiye'l-Azîm' diyerek eğilinir.",
        "Secde: Alın ve burun yere değecek şekilde kapanılır, 'Sübhâne Rabbiye'l-A'lâ' denir.",
        "Ka'de-i Ahîre: Namazın sonunda oturup Ettehiyyâtü, Salli-Bârik ve Rabbenâ duaları okunur.",
        "Selam: Önce sağa, sonra sola 'Esselâmü aleyküm ve rahmetullâh' diyerek selam verilir."
      ],
      stepIcons: [
        PhosphorIcons.heart(),
        PhosphorIcons.handsClapping(),
        PhosphorIcons.user(),
        PhosphorIcons.arrowDown(),
        PhosphorIcons.waves(),
        PhosphorIcons.chair(),
        PhosphorIcons.arrowsLeftRight(),
      ],
    ),
    IlmihalItem(
      id: "abdestin_farzlari",
      title: "Abdestin Farzları",
      category: "farz",
      content: "Abdestin farzları dörttür. Bunlardan biri eksik olursa abdest sahih olmaz.",
      steps: [
        "Yüzü yıkamak.",
        "Kolları dirseklerle beraber yıkamak.",
        "Başın dörte birini meshetmek.",
        "Ayakları topuklarla beraber yıkamak."
      ],
      stepIcons: [
        PhosphorIcons.drop(),
        PhosphorIcons.hand(),
        PhosphorIcons.mountains(),
        PhosphorIcons.boot(),
      ],
    ),
    IlmihalItem(
      id: "namazin_sartlari",
      title: "Namazın Şartları",
      category: "farz",
      content: "Namazın geçerli olması için altısı dışında (hazırlık), altısı içinde (rükün) olmak üzere 12 şartı vardır.",
      steps: [
        "Hadesten Taharet: Abdest veya gerekliyse gusül almak.",
        "Necasetten Taharet: Vücut, elbise ve namaz kılınacak yerin temiz olması.",
        "Setr-i Avret: Vücudun örtülmesi gereken yerlerini örtmek.",
        "İstikbal-i Kıble: Namazda Kıble'ye (Kabe'ye) dönmek.",
        "Vakit: Namazı kendi vakti içinde kılmak.",
        "Niyet: Kılınacak namaza niyet etmek.",
        "İftitah Tekbiri: Namaza 'Allahu Ekber' diyerek başlamak.",
        "Kıyam: Namazda ayakta durmak.",
        "Kıraat: Namazda Kur'an okumak.",
        "Rükû: Elleri dizlere koyarak eğilmek.",
        "Sücud: Secdeye varmak.",
        "Ka'de-i Ahîre: Son rekatta 'Ettehiyyâtü' okuyacak kadar oturmak."
      ],
      stepIcons: [
        PhosphorIcons.drop(),
        PhosphorIcons.broom(),
        PhosphorIcons.coatHanger(),
        PhosphorIcons.compass(),
        PhosphorIcons.clock(),
        PhosphorIcons.heart(),
        PhosphorIcons.handsClapping(),
        PhosphorIcons.user(),
        PhosphorIcons.bookOpen(),
        PhosphorIcons.arrowDown(),
        PhosphorIcons.waves(),
        PhosphorIcons.chair(),
      ],
    ),
    IlmihalItem(
      id: "zekat_kimlere_farz",
      title: "Zekat Kimlere Farzdır?",
      category: "farz",
      content: "Zekat, İslam'ın köprüsü ve mali bir ibadettir. Belli bir zenginlik ölçüsüne (nisap miktarı) ulaşan Müslümanların, mallarının belli bir kısmını her yıl ihtiyaç sahiplerine vermesidir. Zekat, toplumsal dayanışmayı artırır ve malı manevi kirlerden arındırır.",
      steps: [
        "Müslüman olmak: Zekat İslam'ın bir şartıdır.",
        "Hür olmak: Esir veya köle olmamak.",
        "Akıl sağlığı yerinde ve bülüğ çağına ermiş olmak (Hanefilere göre).",
        "Nisap miktarı mala sahip olmak: Temel ihtiyaçlar dışında 80.18 gram altın veya karşılığı değere sahip olmak.",
        "Malın üzerinden bir yıl geçmiş olması: Malın artıcı özellikte olması ve tam mülkiyetin bulunması.",
        "Borcundan fazla mala sahip olmak: Borçlar düşüldükten sonra nisap miktarının korunması."
      ],
    ),
  ];
}

class SpiritualRepository {
  static List<PrayerItem> prayers = [
    PrayerItem(
      title: "Uyanınca Okunacak Dua",
      arabic: "اَلْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
      pronunciation: "Elhamdülillahillezi ahyana ba'de ma ematena ve ileyhin-nüşur.",
      meaning: "Bizi öldürdükten sonra dirilten Allah'a hamdolsun. Dönüş ancak O'nadır.",
    ),
    PrayerItem(
      title: "Evden Çıkarken Okunacak Dua",
      arabic: "بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
      pronunciation: "Bismillâhi tevekkeltü alallâh, lâ havle velâ kuvvete illâ billâh.",
      meaning: "Allah'ın ismiyle. Allah'a tevekkül ettim. Güç ve kuvvet ancak Allah'ın yardımıyladır.",
    ),
    PrayerItem(
      title: "Sıkıntı Anında Okunacak Dua",
      arabic: "لَا إِلَهَ إِلَّا أَنْتَ سُBْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
      pronunciation: "Lâ ilâhe illâ ente sübhâneke innî küntü mine’z-zâlimîn.",
      meaning: "Senden başka ilah yoktur. Seni eksikliklerden tenzih ederim. Ben gerçekten zalimlerden oldum.",
    ),
    PrayerItem(
      title: "Yolculuğa Çıkarken Okunacak Dua",
      arabic: "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ",
      pronunciation: "Sübhânellezî sahhara lenâ hâzâ vemâ künnâ lehû mukrinîn. Ve innâ ilâ rabbinâ lemun kalibûn.",
      meaning: "Bunu bizim hizmetimize veren Allah'ı tenzih ederiz, yoksa biz buna güç yetiremezdik. Biz şüphesiz Rabbimize döneceğiz.",
    ),
    PrayerItem(
      title: "Yemekten Sonra Okunacak Dua",
      arabic: "اَلْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ الْمُسْلِمِينَ",
      pronunciation: "Elhamdülillâhillezî et’amenâ ve sekânâ ve ce’alenâ mine’l-müslimîn.",
      meaning: "Bizi yediren, içiren ve Müslüman kılan Allah’a hamdolsun.",
    ),
    PrayerItem(
      title: "Şifa Duası (Hastalık Anında)",
      arabic: "أَذْهِبِ الْبَاسَ رَبَّ النَّاسِ وَاشْفِ أَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءً لَا يُغَادِرُ سَقَمًا",
      pronunciation: "Ezhibil-be’se Rabben-nâsi veşfi ente’ş-Şâfî, lâ şifâe illâ şifâuke şifâen lâ yüğâdiru sekamen.",
      meaning: "Ey insanların Rabbi! Acıyı gider, şifa ver. Şifa veren ancak Sensin. Senin şifandan başka şifa yoktur. Öyle bir şifa ver ki hiç hastalık bırakmasın.",
    ),
    PrayerItem(
      title: "Camiiye Girerken Okunacak Dua",
      arabic: "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
      pronunciation: "Allahümmeftah lî ebvâbe rahmetike.",
      meaning: "Allah'ım, bana rahmet kapılarını aç.",
    ),
    PrayerItem(
      title: "Camiiden Çıkarken Okunacak Dua",
      arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ",
      pronunciation: "Allahümme innî es’elüke min fadlike.",
      meaning: "Allah'ım, Senin fazlından (iyiliğinden) isterim.",
    ),
    PrayerItem(
      title: "Hapşırınca Okunacak Dua",
      arabic: "الْحَمْدُ لِلَّهِ",
      pronunciation: "Elhamdülillah.",
      meaning: "Allah'a hamdolsun.",
    ),
    PrayerItem(
      title: "Hapşırana Karşı Söylenecek Söz",
      arabic: "يَرْحَمُكَ اللَّهُ",
      pronunciation: "Yerhamükellah.",
      meaning: "Allah sana merhamet etsin.",
    ),
    PrayerItem(
      title: "Gusül Abdesti Niyeti",
      arabic: "نَوَيْتُ الْغُسْلَ لِرَفْعِ الْجَنَابَةِ",
      pronunciation: "Niyetü’l-gusle lirah’il-cenabeti.",
      meaning: "Cenabetten temizlenmek için gusül abdesti almaya niyet ettim.",
    ),
    PrayerItem(
      title: "Uyku Öncesi Okunacak Dua",
      arabic: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
      pronunciation: "Bismikellahümme emütü ve ahya.",
      meaning: "Allah'ım, Senin isminle ölür (uyur) ve dirilirim (uyanırım).",
    ),
    PrayerItem(
      title: "Aynaya Bakınca Okunacak Dua",
      arabic: "اللَّهُمَّ كَمَا أَحْسَنْتَ خَلْقِي فَأَحْسِنْ خُلُقِي",
      pronunciation: "Allahümme kema ahsentee halkî feahsin hulukî.",
      meaning: "Allah'ım, yaratılışımı güzel kıldığın gibi ahlakımı da güzel kıl.",
    ),
    PrayerItem(
      title: "Zor Bir İşle Karşılaşınca",
      arabic: "اللَّهُمَّ لا سَهْلَ إِلاَّ ما جَعَلْتَهُ سَهْلاً، وأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا",
      pronunciation: "Allahümme lâ sehle illâ mâ cealtehû sehlen ve ente tecalü’l-hazne izâ şi’te sehlen.",
      meaning: "Allah'ım, Senin kolay kıldığından başka hiçbir kolay yoktur. Sen istediğin zaman zoru kolay kılarsın.",
    ),
    PrayerItem(
      title: "İlim Talebi Duası",
      arabic: "رَبِّ زِدْنِي عِلْمًا وَفَهْمًا وَأَلْحِقْنِي بِالصَّالِحِينَ",
      pronunciation: "Rabbi zidnî ilmen ve fehmen ve elhıknî bi’s-salihîn.",
      meaning: "Rabbim, ilmimi ve anlayışımı artır, beni salihler arasına kat.",
    ),
    PrayerItem(
      title: "Sınav Öncesi Okunacak Dua",
      arabic: "رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِّن لِّسَانِي يَفْقَهُوا قَوْلِي",
      pronunciation: "Rabbi'şrah lî sadrî ve yessir lî emrî va'hlul ukdeten min lisânî yefkahû kavlî.",
      meaning: "Rabbim! Gönlümü ferahlat, işimi kolaylaştır. Dilimdeki düğümü çöz ki sözümü anlasınlar. (Tâ-Hâ, 25-28)",
    ),
    PrayerItem(
      title: "Tevbe ve İstiğfar Duası",
      arabic: "أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيَّ الْقَيُّومَ وَأَتُوبُ إِلَيْهِ",
      pronunciation: "Estağfirullahel'azîmellezî lâ ilâhe illâ hüvel hayyel kayyûme ve etûbü ileyh.",
      meaning: "Kendisinden başka ilah olmayan, ebedi hayatla diri olan (Hayy) ve her şeyi ayakta tutan (Kayyum) Büyük Allah'tan bağışlanma diler ve O'na tevbe ederim.",
    ),
    PrayerItem(
      title: "Ana-Baba İçin Dua",
      arabic: "رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمüؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ",
      pronunciation: "Rabbenâğfirlî ve livâlideyye ve lil-mü'minîne yevme yekûmü'l-hisâb.",
      meaning: "Rabbimiz! Hesabın görüleceği gün beni, anamı, babamı ve bütün müminleri bağışla. (İbrahim, 41)",
    ),
    PrayerItem(
      title: "Nazar İçin Şifa Duası",
      arabic: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَAMْمَةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ",
      pronunciation: "Eûzü bikelimâtillâhit-tâmmeti min külli şeytânin ve hâmmetin ve min külli aynin lâmmetin.",
      meaning: "Her türlü şeytandan, zararlı hayvanlardan ve kem gözlerden Allah’ın tam kelimelerine sığınırım.",
    ),
  ];

  static List<HadithItem> hadiths = [
    HadithItem(
      content: "Ameller niyetlere göredir.",
      source: "Buhari",
    ),
    HadithItem(
      content: "Sizin en hayırlınız Kur’an’ı öğrenen ve öğretendir.",
      source: "Tirmizi",
    ),
    HadithItem(
      content: "Temizlik imanın yarısıdır.",
      source: "Müslim",
    ),
    HadithItem(
      content: "Müslüman, dilinden ve elinden Müslümanların emin olduğu kimsedir.",
      source: "Buhari",
    ),
    HadithItem(
      content: "Hiçbiriniz, kendisi için istediğini kardeşi için de istemedikçe kamil mümin olamaz.",
      source: "Müslim",
    ),
    HadithItem(
      content: "Komşusu açken tok yatan bizden değildir.",
      source: "Hâkim",
    ),
    HadithItem(
      content: "İnsanlara merhamet etmeyene Allah da merhamet etmez.",
      source: "Müslim",
    ),
    HadithItem(
      content: "Kolaylaştırınız, zorlaştırmayınız; müjdeleyiniz, nefret ettirmeyiniz.",
      source: "Buhari",
    ),
    HadithItem(
      content: "Dua, ibadetin özüdür.",
      source: "Tirmizi",
    ),
    HadithItem(
      content: "Bizi aldatan bizden değildir.",
      source: "Müslim",
    ),
    HadithItem(
      content: "En hayırlı ev, içinde yetime iyilik edilen evdir.",
      source: "İbn Mâce",
    ),
    HadithItem(
      content: "İşçiye ücretini teri kurumadan veriniz.",
      source: "İbn Mâce",
    ),
    HadithItem(
      content: "Hediyeleşin ki birbirinizi sevesiniz.",
      source: "Muvatta",
    ),
    HadithItem(
      content: "Güçlü kimse, güreşte galip gelen değil, öfke anında kendine hakim olandır.",
      source: "Buhari",
    ),
    HadithItem(
      content: "Utanmıyorsan dilediğini yap!",
      source: "Buhari",
    ),
    HadithItem(
      content: "İman yetmiş küsur şubedir. En üstünü 'Lâ ilâhe illallah' demek, en altı ise yoldan eziyet veren bir şeyi kaldırmaktır.",
      source: "Müslim",
    ),
    HadithItem(
      content: "Zulüm, kıyamet gününde karanlıktır.",
      source: "Müslim",
    ),
    HadithItem(
      content: "Allah, sizin dış görünüşünüze ve mallarınıza bakmaz; O, sizin kalplerinize ve amellerinize bakar.",
      source: "Müslim",
    ),
  ];
}
