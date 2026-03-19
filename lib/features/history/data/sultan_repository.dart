// TR: KUBBE V4 Sultan Repository - V1'den miras alındı
// EN: KUBBE V4 Sultan Repository - Inherited from V1
// TR: Veri Kaynağı: V1'deki osmanli_verileri.dart (MedeniyetBilgisi listesi)
// EN: Data Source: V1's osmanli_verileri.dart (MedeniyetBilgisi list)
// TR: Zaman Kubbesi için Osmanlı medeniyet verilerini sağlar
// EN: Provides Ottoman civilization data for Time Dome
// TR: V1'deki tüm MedeniyetBilgisi içeriği korundu ve modernize edildi
// EN: All V1 MedeniyetBilgisi content preserved and modernized

/// TR: KUBBE V4 Sultan Repository Sınıfı
/// EN: KUBBE V4 Sultan Repository Class
/// TR: V1'deki osmanli_verileri.dart (MedeniyetBilgisi listesi) içeriğinden miras alındı
/// EN: Inherited from V1's osmanli_verileri.dart (MedeniyetBilgisi list) content
/// TR: Zaman Kubbesi için Osmanlı medeniyet verilerini sağlar
/// EN: Provides Ottoman civilization data for Time Dome
class SultanRepository {
  // TR: Osmanlı medeniyet verileri - V1'den miras alındı
  // EN: Ottoman civilization data - Inherited from V1
  // TR: V1'deki tüm MedeniyetBilgisi listesi korundu
  // EN: All V1 MedeniyetBilgisi list preserved
  static final List<MedeniyetBilgisi> _osmanliVerileri = [
    // TR: Fatih Sultan Mehmet - İstanbul'u fetheden padişah
    // EN: Fatih Sultan Mehmet - The conqueror of Istanbul
    MedeniyetBilgisi(
      id: 1,
      baslik: 'Fatih Sultan Mehmet',
      donem: '1451-1481',
      aciklama: 'İstanbul\'u fethederek İmparatorluğun altın çağını başlatan padişah. 21 yaşında İstanbul\'u fethetmiş ve "Fatih" unvanını almıştır.',
      ozellikler: [
        'İstanbul\'un Fethi (1453)',           // TR: İstanbul'un Fethi // EN: Conquest of Istanbul
        'Fatih Kanunları',                   // TR: Fatih Kanunları // EN: Fatih Laws
        'Ulu Cami inşası',                   // TR: Ulu Cami inşası // EN: Grand Mosque construction
        'Topkapı Sarayı tamamlanması',       // TR: Topkapı Sarayı tamamlanması // EN: Topkapı Palace completion
        'İlk modern donanma kurulumu',       // TR: İlk modern donanma kurulumu // EN: First modern navy establishment
      ],
      resimUrl: 'assets/images/fatih.jpg',
      kategori: 'Padişahlar',
    ),
    // TR: Kanuni Sultan Süleyman - Kanunî padişah
    // EN: Kanuni Sultan Süleyman - The Lawgiver Sultan
    MedeniyetBilgisi(
      id: 2,
      baslik: 'Kanuni Sultan Süleyman',
      donem: '1520-1566',
      aciklama: 'Kanunî Sultan Süleyman, Osmanlı İmparatorluğu\'nun en parlak döneminde hüküm süren ve "Kanunî" unvanıyla anılan padişah.',
      ozellikler: [
        'Kanunî Kanunları',                   // TR: Kanunî Kanunları // EN: Kanuni Laws
        'Süleymaniye Camii',                  // TR: Süleymaniye Camii // EN: Süleymaniye Mosque
        'Büyük hukuk reformları',             // TR: Büyük hukuk reformları // EN: Major legal reforms
        'Donanmanın güçlendirilmesi',         // TR: Donanmanın güçlendirilmesi // EN: Naval strengthening
        'İmparatorluğun en geniş sınırları', // TR: İmparatorluğun en geniş sınırları // EN: Empire's widest borders
      ],
      resimUrl: 'assets/images/kanuni.jpg',
      kategori: 'Padişahlar',
    ),
    // TR: Süleymaniye Camii - Mimar Sinan'ın eseri
    // EN: Süleymaniye Mosque - Mimar Sinan's work
    MedeniyetBilgisi(
      id: 3,
      baslik: 'Süleymaniye Camii',
      donem: '1550-1558',
      aciklama: 'Mimar Sinan\'ın "ustalık eseri" olarak kabul edilen, Kanunî Sultan Süleyman için inşa edilen cami.',
      ozellikler: [
        'Mimar Sinan eseri',                  // TR: Mimar Sinan eseri // EN: Mimar Sinan's work
        '4 minare (şehzade sayısı)',         // TR: 4 minare (şehzade sayısı) // EN: 4 minarets (prince count)
        '10 şerefeli minareler (Osmanlı\'nın 10. padişahı)', // TR: 10 şerefeli minareler // EN: 10 balconied minarets
        'Külliyede 5 medrese',               // TR: Külliyede 5 medrese // EN: 5 madrasas in complex
        'Darüşşifa (hastane)',               // TR: Darüşşifa (hastane) // EN: Darüşşifa (hospital)
      ],
      resimUrl: 'assets/images/suleymaniye.jpg',
      kategori: 'Mimari',
    ),
    // TR: Mimar Sinan - Osmanlı mimarisi dehası
    // EN: Mimar Sinan - Ottoman architecture genius
    MedeniyetBilgisi(
      id: 4,
      baslik: 'Mimar Sinan',
      donem: '1489-1588',
      aciklama: 'Osmanlı mimarisinin en büyük ustası, 400\'den fazla eser veren mimar dehası.',
      ozellikler: [
        '89 cami inşa etti',                 // TR: 89 cami inşa etti // EN: Built 89 mosques
        'Selimiye Camii (ustalık eseri)',    // TR: Selimiye Camii (ustalık eseri) // EN: Selimiye Mosque (masterpiece)
        'Şehzade Camii (çıraklık eseri)',    // TR: Şehzade Camii (çıraklık eseri) // EN: Şehzade Mosque (apprentice work)
        '50\'den fazla köprü',               // TR: 50\'den fazla köprü // EN: More than 50 bridges
        '35 hamam inşa etti',               // TR: 35 hamam inşa etti // EN: Built 35 bathhouses
      ],
      resimUrl: 'assets/images/mimar_sinan.jpg',
      kategori: 'Mimari',
    ),
    // TR: Padişah II. Abdülhamid - Modernleşme öncüsü
    // EN: Sultan Abdulhamid II - Modernization pioneer
    MedeniyetBilgisi(
      id: 5,
      baslik: 'Padişah II. Abdülhamid',
      donem: '1876-1909',
      aciklama: 'Osmanlı İmparatorluğu\'nun modernleşme çabalarında öncü rol oynayan padişah.',
      ozellikler: [
        'Hejaz Demiryolu',                  // TR: Hejaz Demiryolu // EN: Hejaz Railway
        'Şeker Fabrikası',                  // TR: Şeker Fabrikası // EN: Sugar Factory
        'Tıp Fakülteleri',                   // TR: Tıp Fakülteleri // EN: Medical Faculties
        'Telegraf hatları',                  // TR: Telegraf hatları // EN: Telegraph lines
        'Askeri okullar',                   // TR: Askeri okullar // EN: Military schools
      ],
      resimUrl: 'assets/images/abdulhamid.jpg',
      kategori: 'Padişahlar',
    ),
    // TR: Yedikule Hisarı - İstanbul savunması
    // EN: Yedikule Fortress - Istanbul defense
    MedeniyetBilgisi(
      id: 6,
      baslik: 'Yedikule Hisarı',
      donem: '1458',
      aciklama: 'Fatih Sultan Mehmet tarafından İstanbul\'un savunması için inşa edilen yıldız şeklindeki hisar.',
      ozellikler: [
        '7 kuleden oluşur',                  // TR: 7 kuleden oluşur // EN: Consists of 7 towers
        'Bizans surlarına eklenmiştir',      // TR: Bizans surlarına eklenmiştir // EN: Added to Byzantine walls
        'Hazine ve cezaevi olarak kullanıldı', // TR: Hazine ve cezaevi olarak kullanıldı // EN: Used as treasury and prison
        'Osmanlı devlet arşivi',             // TR: Osmanlı devlet arşivi // EN: Ottoman state archive
        '4 hektar alan kaplar',              // TR: 4 hektar alan kaplar // EN: Covers 4 hectares
      ],
      resimUrl: 'assets/images/yedikule.jpg',
      kategori: 'Mimari',
    ),
    // TR: Topkapı Sarayı - Osmanlı sarayı
    // EN: Topkapı Palace - Ottoman palace
    MedeniyetBilgisi(
      id: 7,
      baslik: 'Topkapı Sarayı',
      donem: '1478',
      aciklama: 'Fatih Sultan Mehmet tarafından inşa ettirilen ve 400 yıl boyunca Osmanlı padişahlarının ikametgahı olan saray.',
      ozellikler: [
        '700.000 m² alan',                  // TR: 700.000 m² alan // EN: 700.000 m² area
        'Harem bölümü',                     // TR: Harem bölümü // EN: Harem section
        'Kutsal Emanetler',                 // TR: Kutsal Emanetler // EN: Sacred Relics
        'Padişah portreleri',               // TR: Padişah portreleri // EN: Sultan portraits
        'İmparatorluk hazinesi',            // TR: İmparatorluk hazinesi // EN: Imperial treasury
      ],
      resimUrl: 'assets/images/topkapi.jpg',
      kategori: 'Mimari',
    ),
    // TR: İstanbul Üniversitesi - İlk üniversite
    // EN: Istanbul University - First university
    MedeniyetBilgisi(
      id: 8,
      baslik: 'İstanbul Üniversitesi',
      donem: '1453',
      aciklama: 'Fatih Sultan Mehmet tarafından kurulmuş, dünyanın en eski üniversitelerinden biri.',
      ozellikler: [
        'İlk medrese 1453\'te',             // TR: İlk medrese 1453'te // EN: First madrasa in 1453
        'Darülfünun 1933\'te',             // TR: Darülfünun 1933'te // EN: Darülfünun in 1933
        'İlk modern üniversite',           // TR: İlk modern üniversite // EN: First modern university
        'Tıp, hukuk, edebiyat fakülteleri', // TR: Tıp, hukuk, edebiyat fakülteleri // EN: Medicine, law, literature faculties
        '500 yıllık eğitim geleneği',       // TR: 500 yıllık eğitim geleneği // EN: 500-year educational tradition
      ],
      resimUrl: 'assets/images/universite.jpg',
      kategori: 'Eğitim',
    ),
    // TR: Şehzade Camii - Mimar Sinan'ın çıraklık eseri
    // EN: Şehzade Mosque - Mimar Sinan's apprentice work
    MedeniyetBilgisi(
      id: 9,
      baslik: 'Şehzade Camii',
      donem: '1543-1548',
      aciklama: 'Mimar Sinan\'ın oğlu Mehmet için Kanunî Sultan Süleyman\'a yaptırdığı, "çıraklık eseri" olarak bilinen cami.',
      ozellikler: [
        'Mimar Sinan\'ın çıraklık eseri',    // TR: Mimar Sinan'ın çıraklık eseri // EN: Mimar Sinan's apprentice work
        'Şehzade Mehmet için',              // TR: Şehzade Mehmet için // EN: For Şehzade Mehmet
        'İlk büyük camisi',                 // TR: İlk büyük camisi // EN: First large mosque
        '4 minareli',                      // TR: 4 minareli // EN: 4 minarets
        'Külliyeli yapı',                  // TR: Külliyeli yapı // EN: Complex structure
      ],
      resimUrl: 'assets/images/sehzade.jpg',
      kategori: 'Mimari',
    ),
    // TR: Rüstem Paşa Camii - İznik çinileriyle süslü
    // EN: Rüstem Paşa Mosque - Decorated with İznik tiles
    MedeniyetBilgisi(
      id: 10,
      baslik: 'Rüstem Paşa Camii',
      donem: '1550-1561',
      aciklama: 'Mimar Sinan\'ın, Kanunî Sultan Süleyman\'ın damadı Rüstem Paşa için inşa ettiği cami.',
      ozellikler: [
        'İznik çinileri',                   // TR: İznik çinileri // EN: İznik tiles
        'Kanuni dönemi',                    // TR: Kanuni dönemi // EN: Kanuni period
        'Taqi al-Din\'in mezarı',           // TR: Taqi al-Din'ın mezarı // EN: Taqi al-Din's tomb
        'Tek minareli',                     // TR: Tek minareli // EN: Single minaret
        'Merkezi planlı',                   // TR: Merkezi planlı // EN: Central plan
      ],
      resimUrl: 'assets/images/rustem_pasa.jpg',
      kategori: 'Mimari',
    ),
  ];

  // TR: Tüm Osmanlı medeniyet bilgilerini al - V1'den miras alındı
  // EN: Get all Ottoman civilization information - Inherited from V1
  // TR: V1'deki tüm MedeniyetBilgisi listesini döndürür
  // EN: Returns all V1 MedeniyetBilgisi list
  static List<MedeniyetBilgisi> getAllMedeniyetBilgisi() {
    return List.from(_osmanliVerileri);
  }

  // TR: ID'ye göre medeniyet bilgisi al - V1'den miras alındı
  // EN: Get civilization information by ID - Inherited from V1
  // TR: Belirtilen ID'ye sahip medeniyet bilgisini döndürür
  // EN: Returns civilization information with specified ID
  static MedeniyetBilgisi? getById(int id) {
    try {
      return _osmanliVerileri.firstWhere((info) => info.id == id);
    } catch (e) {
      return null;
    }
  }

  // TR: Kategoriye göre medeniyet bilgileri al - V1'den miras alındı
  // EN: Get civilization information by category - Inherited from V1
  // TR: Belirtilen kategoriye ait tüm medeniyet bilgilerini döndürür
  // EN: Returns all civilization information belonging to specified category
  static List<MedeniyetBilgisi> getByCategory(String kategori) {
    return _osmanliVerileri.where((info) => info.kategori == kategori).toList();
  }

  // TR: Tüm kategorileri al - V1'den miras alındı
  // EN: Get all categories - Inherited from V1
  // TR: Mevcut tüm kategorileri döndürür
  // EN: Returns all existing categories
  static List<String> getCategories() {
    final categories = _osmanliVerileri.map((info) => info.kategori).toSet().toList();
    categories.sort();
    return categories;
  }

  // TR: Medeniyet bilgilerinde ara - V1'den miras alındı
  // EN: Search in civilization information - Inherited from V1
  // TR: Başlık, açıklama veya özelliklerde arama yapar
  // EN: Searches in title, description or features
  static List<MedeniyetBilgisi> search(String query) {
    if (query.isEmpty) return getAllMedeniyetBilgisi();
    
    final lowerQuery = query.toLowerCase();
    return _osmanliVerileri.where((info) =>
      info.baslik.toLowerCase().contains(lowerQuery) ||
      info.aciklama.toLowerCase().contains(lowerQuery) ||
      info.donem.toLowerCase().contains(lowerQuery) ||
      info.ozellikler.any((ozellik) => ozellik.toLowerCase().contains(lowerQuery))
    ).toList();
  }

  // TR: Rastgele medeniyet bilgisi al - V1'den miras alındı
  // EN: Get random civilization information - Inherited from V1
  // TR: Rastgele bir medeniyet bilgisi döndürür
  // EN: Returns a random civilization information
  static MedeniyetBilgisi getRandom() {
    final random = DateTime.now().millisecondsSinceEpoch % _osmanliVerileri.length;
    return _osmanliVerileri[random];
  }

  // TR: Döneme göre medeniyet bilgileri al - V1'den miras alındı
  // EN: Get civilization information by period - Inherited from V1
  // TR: Belirtilen döneme ait medeniyet bilgilerini döndürür
  // EN: Returns civilization information belonging to specified period
  static List<MedeniyetBilgisi> getByPeriod(String period) {
    return _osmanliVerileri.where((info) => info.donem.contains(period)).toList();
  }

  // TR: Günlük medeniyet bilgisi al - V1'den miras alındı
  // EN: Get daily civilization information - Inherited from V1
  // TR: Tarihe göre günlük medeniyet bilgisi döndürür
  // EN: Returns daily civilization information based on date
  static MedeniyetBilgisi getDailyInfo() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final index = dayOfYear % _osmanliVerileri.length;
    return _osmanliVerileri[index];
  }
}

// TR: MedeniyetBilgisi data model - V1'den miras alındı
// EN: MedeniyetBilgisi data model - Inherited from V1
// TR: Osmanlı medeniyet bilgisi için veri modeli
// EN: Data model for Ottoman civilization information
class MedeniyetBilgisi {
  final int id;                     // TR: Benzersiz kimlik // EN: Unique identifier
  final String baslik;              // TR: Başlık // EN: Title
  final String donem;               // TR: Dönem // EN: Period
  final String aciklama;            // TR: Açıklama // EN: Description
  final List<String> ozellikler;    // TR: Özellikler // EN: Features
  final String resimUrl;           // TR: Resim URL // EN: Image URL
  final String kategori;           // TR: Kategori // EN: Category

  // TR: Constructor
  // EN: Constructor
  MedeniyetBilgisi({
    required this.id,
    required this.baslik,
    required this.donem,
    required this.aciklama,
    required this.ozellikler,
    required this.resimUrl,
    required this.kategori,
  });

  // TR: JSON'dan oluştur - API entegrasyonu için
  // EN: Create from JSON - For API integration
  factory MedeniyetBilgisi.fromJson(Map<String, dynamic> json) {
    return MedeniyetBilgisi(
      id: json['id'] as int,
      baslik: json['baslik'] as String,
      donem: json['donem'] as String,
      aciklama: json['aciklama'] as String,
      ozellikler: (json['ozellikler'] as List<dynamic>).cast<String>(),
      resimUrl: json['resimUrl'] as String,
      kategori: json['kategori'] as String,
    );
  }

  // TR: JSON'a dönüştür
  // EN: Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baslik': baslik,
      'donem': donem,
      'aciklama': aciklama,
      'ozellikler': ozellikler,
      'resimUrl': resimUrl,
      'kategori': kategori,
    };
  }

  // TR: Formatlanmış dönemi al
  // EN: Get formatted period
  String get formattedPeriod => '$donem dönemi';

  // TR: Özellik sayısını al
  // EN: Get feature count
  int get featureCount => ozellikler.length;

  // TR: Resim var mı kontrol et
  // EN: Check if has image
  bool get hasImage => resimUrl.isNotEmpty && resimUrl != 'assets/images/placeholder.jpg';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MedeniyetBilgisi && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MedeniyetBilgisi(id: $id, baslik: $baslik, kategori: $kategori)';
  }
}

// TR: Osmanlı medeniyet istatistikleri - V1'den miras alındı
// EN: Ottoman civilization statistics - Inherited from V1
// TR: Osmanlı medeniyet verileri hakkında istatistikler
// EN: Statistics about Ottoman civilization data
class OttomanStatistics {
  // TR: Toplam padişah sayısı
  // EN: Total number of sultans
  static int get totalSultans => SultanRepository.getByCategory('Padişahlar').length;
  
  // TR: Toplam mimari eser sayısı
  // EN: Total number of architectural works
  static int get totalArchitecture => SultanRepository.getByCategory('Mimari').length;
  
  // TR: Toplam eğitim kurumu sayısı
  // EN: Total number of educational institutions
  static int get totalEducation => SultanRepository.getByCategory('Eğitim').length;
  
  // TR: Toplam giriş sayısı
  // EN: Total number of entries
  static int get totalEntries => SultanRepository.getAllMedeniyetBilgisi().length;
  
  // TR: Tüm kategoriler
  // EN: All categories
  static List<String> get allCategories => SultanRepository.getCategories();
}
