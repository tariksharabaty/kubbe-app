// TR: KUBBE V4 History Figure Model - V1'den miras alındı
// EN: KUBBE V4 History Figure Model - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki 'MedeniyetBilgisi' yapısını 'HistoryFigure' olarak modernize et
// EN: Modernize V1's 'MedeniyetBilgisi' structure as 'HistoryFigure'
// TR: İsim, Dönem, Başarılar (List), Görsel URL ve Kısa Özet alanlarını ekle
// EN: Add Name, Period, Achievements (List), Image URL and Short Summary fields

/// TR: KUBBE V4 History Figure Model Sınıfı
/// EN: KUBBE V4 History Figure Model Class
/// TR: V1'deki 'MedeniyetBilgisi' yapısını modernize eder
/// EN: Modernizes V1's 'MedeniyetBilgisi' structure
/// TR: Tarihi şahsiyetler için veri modeli
/// EN: Data model for historical figures
/// TR: Instagram/Pinterest tarzı görsel akış için optimize edilmiş
/// EN: Optimized for Instagram/Pinterest style visual flow
/// TR: V1'den miras alınan veri yapısı V4 estetiğiyle modernize edildi
/// EN: Data structure inherited from V1 modernized with V4 aesthetics
class HistoryFigure {
  // TR: Şahsiyetin ID'si - V1'den miras alındı
  // EN: Figure's ID - Inherited from V1
  final String id;

  // TR: Şahsiyetin tam adı - V1'den miras alındı
  // EN: Figure's full name - Inherited from V1
  final String name;

  // TR: Şahsiyetin dönemi - V1'den miras alındı
  // EN: Figure's period - Inherited from V1
  final String period;

  // TR: Şahsiyetin unvanı - V1'den miras alındı
  // EN: Figure's title - Inherited from V1
  final String title;

  // TR: Başarıları listesi - V1'den miras alındı
  // EN: List of achievements - Inherited from V1
  final List<String> achievements;

  // TR: Görsel URL - V4 yeniliği
  // EN: Image URL - V4 innovation
  final String imageUrl;

  // TR: Kısa özet - V1'den miras alındı
  // EN: Short summary - Inherited from V1
  final String shortSummary;

  // TR: Detaylı açıklama - V1'den miras alındı
  // EN: Detailed description - Inherited from V1
  final String description;

  // TR: Kategori - V4 yeniliği
  // EN: Category - V4 innovation
  final HistoryCategory category;

  // TR: Doğum tarihi - V1'den miras alındı
  // EN: Birth date - Inherited from V1
  final String birthDate;

  // TR: Vefat tarihi - V1'den miras alındı
  // EN: Death date - Inherited from V1
  final String deathDate;

  // TR: Şahsiyetin türü - V4 yeniliği
  // EN: Figure type - V4 innovation
  final FigureType figureType;

  // TR: Önem derecesi - V4 yeniliği
  // EN: Importance level - V4 innovation
  final int importanceLevel;

  // TR: Constructor
  // EN: Constructor
  const HistoryFigure({
    required this.id,
    required this.name,
    required this.period,
    required this.title,
    required this.achievements,
    required this.imageUrl,
    required this.shortSummary,
    required this.description,
    required this.category,
    required this.birthDate,
    required this.deathDate,
    required this.figureType,
    this.importanceLevel = 1,
  });

  // TR: From factory method - V1'den miras alındı
  // EN: From factory method - Inherited from V1
  // TR: JSON'dan HistoryFigure oluştur
  // EN: Create HistoryFigure from JSON
  factory HistoryFigure.fromJson(Map<String, dynamic> json) {
    return HistoryFigure(
      id: json['id'] as String,
      name: json['name'] as String,
      period: json['period'] as String,
      title: json['title'] as String,
      achievements: (json['achievements'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      imageUrl: json['imageUrl'] as String,
      shortSummary: json['shortSummary'] as String,
      description: json['description'] as String,
      category: HistoryCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => HistoryCategory.other,
      ),
      birthDate: json['birthDate'] as String,
      deathDate: json['deathDate'] as String,
      figureType: FigureType.values.firstWhere(
        (e) => e.name == json['figureType'],
        orElse: () => FigureType.other,
      ),
      importanceLevel: json['importanceLevel'] as int? ?? 1,
    );
  }

  // TR: To JSON method - V1'den miras alındı
  // EN: To JSON method - Inherited from V1
  // TR: HistoryFigure'ı JSON'a dönüştür
  // EN: Convert HistoryFigure to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'period': period,
      'title': title,
      'achievements': achievements,
      'imageUrl': imageUrl,
      'shortSummary': shortSummary,
      'description': description,
      'category': category.name,
      'birthDate': birthDate,
      'deathDate': deathDate,
      'figureType': figureType.name,
      'importanceLevel': importanceLevel,
    };
  }

  // TR: CopyWith method - V1'den miras alındı
  // EN: CopyWith method - Inherited from V1
  // TR: Yeni HistoryFigure nesnesi oluştur
  // EN: Create new HistoryFigure instance
  HistoryFigure copyWith({
    String? id,
    String? name,
    String? period,
    String? title,
    List<String>? achievements,
    String? imageUrl,
    String? shortSummary,
    String? description,
    HistoryCategory? category,
    String? birthDate,
    String? deathDate,
    FigureType? figureType,
    int? importanceLevel,
  }) {
    return HistoryFigure(
      id: id ?? this.id,
      name: name ?? this.name,
      period: period ?? this.period,
      title: title ?? this.title,
      achievements: achievements ?? this.achievements,
      imageUrl: imageUrl ?? this.imageUrl,
      shortSummary: shortSummary ?? this.shortSummary,
      description: description ?? this.description,
      category: category ?? this.category,
      birthDate: birthDate ?? this.birthDate,
      deathDate: deathDate ?? this.deathDate,
      figureType: figureType ?? this.figureType,
      importanceLevel: importanceLevel ?? this.importanceLevel,
    );
  }

  // TR: Equality operator
  // EN: Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryFigure &&
        other.id == id &&
        other.name == name &&
        other.period == period &&
        other.title == title &&
        other.achievements == achievements &&
        other.imageUrl == imageUrl &&
        other.shortSummary == shortSummary &&
        other.description == description &&
        other.category == category &&
        other.birthDate == birthDate &&
        other.deathDate == deathDate &&
        other.figureType == figureType &&
        other.importanceLevel == importanceLevel;
  }

  // TR: Hash code
  // EN: Hash code
  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      period,
      title,
      achievements,
      imageUrl,
      shortSummary,
      description,
      category,
      birthDate,
      deathDate,
      figureType,
      importanceLevel,
    );
  }

  // TR: String representation
  // EN: String representation
  @override
  String toString() {
    return 'HistoryFigure('
        'id: $id, '
        'name: $name, '
        'period: $period, '
        'title: $title, '
        'category: $category, '
        'figureType: $figureType'
        ')';
  }
}

// TR: History Category Enum - V4 yeniliği
// EN: History Category Enum - V4 innovation
// TR: Tarihi şahsiyet kategorileri
// EN: Historical figure categories
enum HistoryCategory {
  // TR: Osmanlı padişahları
  // EN: Ottoman sultans
  sultans,

  // TR: İslam alimleri
  // EN: Islamic scholars
  scholars,

  // TR: Şairler ve yazarlar
  // EN: Poets and writers
  poets,

  // TR: Askeri komutanlar
  // EN: Military commanders
  commanders,

  // TR: Sanatkarlar
  // EN: Artists
  artists,

  // TR: Bilim insanları
  // EN: Scientists
  scientists,

  // TR: Diğer
  // EN: Other
  other,
}

// TR: Kategori adını al - Extension
// EN: Get category display name - Extension
extension HistoryCategoryExtension on HistoryCategory {
  String get categoryDisplayName {
    switch (this) {
      case HistoryCategory.sultans:
        return 'Padişahlar';
      case HistoryCategory.scholars:
        return 'Alimler';
      case HistoryCategory.poets:
        return 'Şairler';
      case HistoryCategory.commanders:
        return 'Komutanlar';
      case HistoryCategory.artists:
        return 'Sanatkarlar';
      case HistoryCategory.scientists:
        return 'Bilim İnsanları';
      case HistoryCategory.other:
        return 'Diğer';
    }
  }
}

// TR: Figure Type Enum - V4 yeniliği
// EN: Figure Type Enum - V4 innovation
// TR: Şahsiyet türleri
// EN: Figure types
enum FigureType {
  // TR: Padişah
  // EN: Sultan
  sultan,

  // TR: Şeyhülislam
  // EN: Sheikh al-Islam
  sheikhulislam,

  // TR: Şair
  // EN: Poet
  poet,

  // TR: Alim
  // EN: Scholar
  scholar,

  // TR: Komutan
  // EN: Commander
  commander,

  // TR: Sanatkar
  // EN: Artist
  artist,

  // TR: Bilim insanı
  // EN: Scientist
  scientist,

  // TR: Diğer
  // EN: Other
  other,
}

// TR: Tür adını al - Extension
// EN: Get figure type display name - Extension
extension FigureTypeExtension on FigureType {
  String get figureTypeDisplayName {
    switch (this) {
      case FigureType.sultan:
        return 'Padişah';
      case FigureType.sheikhulislam:
        return 'Şeyhülislam';
      case FigureType.poet:
        return 'Şair';
      case FigureType.scholar:
        return 'Alim';
      case FigureType.commander:
        return 'Komutan';
      case FigureType.artist:
        return 'Sanatkar';
      case FigureType.scientist:
        return 'Bilim İnsanı';
      case FigureType.other:
        return 'Diğer';
    }
  }
}

// TR: History Figure Extension - V4 yeniliği
// EN: History Figure Extension - V4 innovation
// TR: HistoryFigure için yardımcı metodlar
// EN: Helper methods for HistoryFigure
extension HistoryFigureExtension on HistoryFigure {
  // TR: Kategori adını Türkçe olarak al
  // EN: Get category name in Turkish
  String get categoryDisplayName {
    switch (category) {
      case HistoryCategory.sultans:
        return 'Padişahlar';
      case HistoryCategory.scholars:
        return 'Alimler';
      case HistoryCategory.poets:
        return 'Şairler';
      case HistoryCategory.commanders:
        return 'Komutanlar';
      case HistoryCategory.artists:
        return 'Sanatkarlar';
      case HistoryCategory.scientists:
        return 'Bilim İnsanları';
      case HistoryCategory.other:
        return 'Diğer';
    }
  }

  // TR: Şahsiyet türünü Türkçe olarak al
  // EN: Get figure type name in Turkish
  String get figureTypeDisplayName {
    switch (figureType) {
      case FigureType.sultan:
        return 'Padişah';
      case FigureType.sheikhulislam:
        return 'Şeyhülislam';
      case FigureType.poet:
        return 'Şair';
      case FigureType.scholar:
        return 'Alim';
      case FigureType.commander:
        return 'Komutan';
      case FigureType.artist:
        return 'Sanatkar';
      case FigureType.scientist:
        return 'Bilim İnsanı';
      case FigureType.other:
        return 'Diğer';
    }
  }

  // TR: Ömür süresini hesapla
  // EN: Calculate lifespan
  String get lifespan {
    return '$birthDate - $deathDate';
  }

  // TR: Başarı sayısını al
  // EN: Get achievement count
  int get achievementCount {
    return achievements.length;
  }

  // TR: İlk başarıyı al
  // EN: Get first achievement
  String get firstAchievement {
    return achievements.isNotEmpty ? achievements.first : '';
  }

  // TR: Önem derecesine göre renk al
  // EN: Get color by importance level
  String get importanceColor {
    switch (importanceLevel) {
      case 5:
        return '#FFD700'; // TR: Altın // EN: Gold
      case 4:
        return '#C0C0C0'; // TR: Gümüş // EN: Silver
      case 3:
        return '#CD7F32'; // TR: Bronz // EN: Bronze
      default:
        return '#4B0082'; // TR: Kubbe Indigo // EN: Kubbe Indigo
    }
  }

  // TR: Arama için anahtar kelimeler oluştur
  // EN: Create keywords for search
  List<String> get searchableKeywords {
    final keywords = <String>[];
    keywords.addAll(name.toLowerCase().split(' '));
    keywords.addAll(title.toLowerCase().split(' '));
    keywords.addAll(period.toLowerCase().split(' '));
    keywords.addAll(categoryDisplayName.toLowerCase().split(' '));
    keywords.addAll(figureTypeDisplayName.toLowerCase().split(' '));
    keywords.addAll(achievements.map((a) => a.toLowerCase()));
    return keywords.toSet().toList();
  }

  // TR: Kart için özet oluştur
  // EN: Create summary for card
  String get cardSummary {
    const maxLength = 100;
    if (shortSummary.length <= maxLength) return shortSummary;
    return '${shortSummary.substring(0, maxLength - 3)}...';
  }

  // TR: Görsel URL'i kontrol et
  // EN: Check image URL
  bool get hasValidImageUrl {
    return imageUrl.isNotEmpty && imageUrl.startsWith('http');
  }

  // TR: Placeholder görsel URL'i al
  // EN: Get placeholder image URL
  String get placeholderImageUrl {
    return 'assets/images/placeholder_${category.name}.png';
  }

  // TR: Detay sayfası için URL oluştur
  // EN: Create URL for detail page
  String get detailPageUrl {
    return '/history/detail/$id';
  }

  // TR: Paylaşım metni oluştur
  // EN: Create sharing text
  String get shareText {
    return '$name - $title\n$period\n\n$shortSummary\n\n#KUBBE #Tarih #$categoryDisplayName';
  }
}

// TR: History Figure List Extension - V4 yeniliği
// EN: History Figure List Extension - V4 innovation
// TR: List<HistoryFigure> için yardımcı metodlar
// EN: Helper methods for List<HistoryFigure>
extension HistoryFigureListExtension on List<HistoryFigure> {
  // TR: Kategoriye göre filtrele
  // EN: Filter by category
  List<HistoryFigure> filterByCategory(HistoryCategory category) {
    return where((figure) => figure.category == category).toList();
  }

  // TR: Şahsiyet türüne göre filtrele
  // EN: Filter by figure type
  List<HistoryFigure> filterByFigureType(FigureType figureType) {
    return where((figure) => figure.figureType == figureType).toList();
  }

  // TR: Önem derecesine göre filtrele
  // EN: Filter by importance level
  List<HistoryFigure> filterByImportanceLevel(int level) {
    return where((figure) => figure.importanceLevel == level).toList();
  }

  // TR: İsme göre ara
  // EN: Search by name
  List<HistoryFigure> searchByName(String query) {
    return where(
            (figure) => figure.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // TR: Anahtar kelimeye göre ara
  // EN: Search by keywords
  List<HistoryFigure> searchByKeywords(String query) {
    return where((figure) => figure.searchableKeywords
        .any((keyword) => keyword.contains(query.toLowerCase()))).toList();
  }

  // TR: Önem derecesine göre sırala
  // EN: Sort by importance level
  List<HistoryFigure> sortByImportanceLevel() {
    final sorted = List<HistoryFigure>.from(this);
    sorted.sort((a, b) => b.importanceLevel.compareTo(a.importanceLevel));
    return sorted;
  }

  // TR: İsme göre sırala
  // EN: Sort by name
  List<HistoryFigure> sortByName() {
    final sorted = List<HistoryFigure>.from(this);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }

  // TR: Döneme göre sırala
  // EN: Sort by period
  List<HistoryFigure> sortByPeriod() {
    final sorted = List<HistoryFigure>.from(this);
    sorted.sort((a, b) => a.period.compareTo(b.period));
    return sorted;
  }

  // TR: Rastgele seç
  // EN: Random selection
  List<HistoryFigure> randomSelection(int count) {
    if (count >= length) return this;

    final shuffled = List<HistoryFigure>.from(this)..shuffle();
    return shuffled.take(count).toList();
  }

  // TR: Kategori sayısını al
  // EN: Get category count
  int getCountByCategory(HistoryCategory category) {
    return where((figure) => figure.category == category).length;
  }

  // TR: En önemli şahsiyeti al
  // EN: Get most important figure
  HistoryFigure? getMostImportant() {
    if (isEmpty) return null;
    return sortByImportanceLevel().first;
  }

  // TR: Tüm kategorileri al
  // EN: Get all categories
  List<HistoryCategory> getAllCategories() {
    return map((figure) => figure.category).toSet().toList();
  }

  // TR: Tüm şahsiyet türlerini al
  // EN: Get all figure types
  List<FigureType> getAllFigureTypes() {
    return map((figure) => figure.figureType).toSet().toList();
  }
}
