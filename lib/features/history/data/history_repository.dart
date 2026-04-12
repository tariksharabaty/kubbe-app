import '../../../data/local_history_db.dart'; // [Statik veri kaynağı | Static data source]

// [Tarih Öğeresi Modeli - History Item Model]
class HistoryItem {
  final String id;
  final String name; 
  final String title; 
  final String shortDescription; 
  final String fullDescription; // [Yeni: Detaylı içerik | Full description]
  final String? imageUrl; 
  final String quote; 
  final List<String> extraQuotes; 
  final String tombLocationUrl; 
  final List<String> galleryUrls; 
  final List<String> works; 
  final String era; 
  final String category; // [Yeni: Kişi, Mekan, Medeniyet, Gelenek]
  final bool isFeatured; 
  final String? audioUrl; // [Gelecekteki ses URL'si | Future audio URL]
  final String date; // [Yeni: Tarih bilgisi | Date info]
  final String location; // [Yeni: Konum bilgisi | Location info]
  final List<String> famousQuotes; // [Yeni: En meşhur sözleri | Most famous quotes]
  final List<String> legacyWorks; // [Yeni: Bıraktığı eserler / miras | Legacy works]
  final String respectMessage; // [Yeni: Hürmet mesajı | Respect message]
  final String? tombLocation; // [Yeni: Türbesi / Kabri nerede | Tomb location]
  final List<String>? parties; // [Yeni: Savaşın tarafları | Parties of the battle]
  bool isSaved; 
  bool isRead; 

  HistoryItem({
    required this.id,
    required this.name,
    this.title = "", 
    required this.shortDescription,
    required this.fullDescription,
    this.imageUrl,
    required this.quote,
    this.date = "", 
    this.location = "", 
    this.famousQuotes = const [],
    this.legacyWorks = const [],
    this.tombLocation,
    this.parties, // [V2.9: Savaş tarafları]
    this.respectMessage = "", // [Varsayılan boş | Default empty]
    this.extraQuotes = const [],
    this.tombLocationUrl = "", 
    this.galleryUrls = const [],
    this.works = const [],
    this.era = "Tümü", 
    this.category = "kisi", // [Küçük harf standartı | Lowercase standard]
    this.isFeatured = false,
    this.audioUrl, // [Opsiyonel ses URL'si | Optional audio URL]
    this.isSaved = false,
    this.isRead = false,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      shortDescription: json['shortDescription']?.toString() ?? '',
      fullDescription: (json['fullDescription'] ?? json['detailedContent'])?.toString() ?? '',
      imageUrl: (json['imageUrl'] != null && json['imageUrl'].toString().isNotEmpty) ? json['imageUrl'].toString() : null,
      quote: json['quote']?.toString() ?? '',
      extraQuotes: json['extraQuotes'] is List ? List<String>.from(json['extraQuotes']) : [],
      tombLocationUrl: json['tombLocationUrl']?.toString() ?? '',
      galleryUrls: json['galleryUrls'] is List ? List<String>.from(json['galleryUrls']) : [],
      works: json['works'] is List ? List<String>.from(json['works']) : [],
      era: json['era']?.toString() ?? 'Tümü',
      category: json['category']?.toString() ?? 'kisi',
      isFeatured: json['isFeatured'] == true,
      audioUrl: json['audioUrl']?.toString(),
      date: json['date']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      famousQuotes: json['famousQuotes'] is List ? List<String>.from(json['famousQuotes']) : [],
      legacyWorks: json['legacyWorks'] is List ? List<String>.from(json['legacyWorks']) : [],
      tombLocation: json['tombLocation']?.toString(),
      parties: json['parties'] is List ? List<String>.from(json['parties']) : null,
      respectMessage: json['respectMessage']?.toString() ?? '',
    );
  }

  // [Görsel Filtreleme ve Güvenli Erişim - Image Filtering & Safe Access]
  String? get safeImageUrl {
    if (imageUrl == null) return null;
    
    // [1. Filtre: Geçersiz veya Yoga/Placeholder içeren linkleri engelle - Strict Mode]
    final blacklist = [
      "yoga", "placeholder", "women-stretching", "fitness", "dummy", "test-image", 
      "stock-photo", "vector", "illustration", "female-yoga"
    ];
    
    bool isInvalid = blacklist.any((pattern) => imageUrl!.toLowerCase().contains(pattern));
    
    // [2. Filtre: Eğer imageUrl çok kısaysa veya geçersiz ise varsayılan vakur görseli ver]
    if (isInvalid || imageUrl!.length < 12) {
      return null; // [Geçersizse null dön - Return null if invalid]
    }

    // [Wikimedia/Wikipedia görsellerine izin ver - Allow Wikimedia/Wikipedia images]
    // [Kullanıcı talebi doğrultusunda bu kısıtlama kaldırıldı | Constraint removed per user request]
    
    if (imageUrl != null) {
      if (imageUrl!.startsWith("http://")) return imageUrl!.replaceFirst("http://", "https://");
      if (!imageUrl!.startsWith("https://")) return "https://$imageUrl";
      return imageUrl!;
    }
    
    return null; // [Resim yoksa null dön - Return null if no image]
  }
  // [Dikey Dar Kartlarda Gösterilecek İsim - Name for Vertical Grid Cards]
  String get nameForGrid {
    String cleanName = name.replaceAll(" Han", "").replaceAll("Sultan ", "");
    if (name.contains("Abdülhamid")) return "II. Abdülhamid";
    if (cleanName.length > 15) return "${cleanName.substring(0, 13)}..";
    return cleanName;
  }

  // [Önemli: Detay sayfasında 'Han' hürmeti korunacak, kartlarda kısa isim]
  String get nameForFeatured {
    if (name.contains("Abdülhamid")) return "II. Abdülhamid Han";
    return name; 
  }

  // [Eski Kısaltma Metodu Geriye Uyumluluk İçin]
  String shortenedName(int maxLength) {
    if (maxLength <= 15) return nameForGrid;
    return nameForFeatured;
  }

  String get displaySubtitle {
    return title.isNotEmpty ? title : shortDescription; 
  }

}

// [Tarih Veri Havuzu - History Repository]
class HistoryRepository {
  // [Statik veri listesi | Static data list]
  static List<HistoryItem> get allHistoryItems => LocalHistoryDB.items;
  
  // [Uygulama başlatıldığında veri yükleme (Artık statik) | Load data on app start (Now static)]
  static Future<void> loadData() async {
    // [Statik sistemde veri zaten hazırdır | Data is already ready in static system]
    // [Eski JSON sistemi tamamen devre dışı | Old JSON system completely disabled]
  }

  // [Öne çıkan içerikler | Featured contents]
  static List<HistoryItem> get featuredItems => 
      allHistoryItems.where((item) => item.isFeatured).toList();

  // [Tüm ızgara içeriği | All grid items]
  static List<HistoryItem> get gridItems => allHistoryItems;
}
