// TR: KUBBE V4 Surah Model - Merkezi Model
// EN: KUBBE V4 Surah Model - Centralized Model
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki 114 sure verisini JSON tabanlı olarak modernize eder
// EN: Modernizes V1's 114 surah data as JSON-based

/// TR: İniş Yeri Enum - V4 yeniliği
/// EN: Revelation Place Enum - V4 innovation
/// TR: İniş yerleri
/// EN: Revelation places
enum RevelationPlace {
  // TR: Mekke
  // EN: Mekka
  mekke,

  // TR: Medine
  // EN: Medina
  medine,
}

/// TR: İniş Yeri Extension - V4 yeniliği
/// EN: Revelation Place Extension - V4 innovation
/// TR: RevelationPlace için yardımcı metodlar
/// EN: Helper methods for RevelationPlace
extension RevelationPlaceExtension on RevelationPlace {
  // TR: Display adı
  // EN: Display name
  String get displayName {
    switch (this) {
      case RevelationPlace.mekke:
        return 'Mekke';
      case RevelationPlace.medine:
        return 'Medine';
    }
  }

  // TR: Renk
  // EN: Color
  String get color {
    switch (this) {
      case RevelationPlace.mekke:
        return '#FF9800'; // TR: Turuncu // EN: Orange
      case RevelationPlace.medine:
        return '#4CAF50'; // TR: Yeşil // EN: Green
    }
  }

  // TR: İkon
  // EN: Icon
  String get icon {
    switch (this) {
      case RevelationPlace.mekke:
        return 'assets/icons/mekke.png';
      case RevelationPlace.medine:
        return 'assets/icons/medine.png';
    }
  }
}

/// TR: Sure Modeli - V4 yeniliği
/// EN: Surah Model - V4 innovation
/// TR: Sure veri modeli - Basitleştirilmiş versiyon
/// EN: Surah data model - Simplified version
class Surah {
  // TR: Sure ID'si
  // EN: Surah ID
  final int id;

  // TR: Sure adı
  // EN: Surah name
  final String name;

  // TR: Ayetler
  // EN: Verses
  final List<String> verses;

  // TR: İniş yeri (şehir)
  // EN: Revelation place (city)
  final String city;

  // TR: Constructor
  // EN: Constructor
  const Surah({
    required this.id,
    required this.name,
    required this.verses,
    required this.city,
  });

  // TR: From JSON
  // EN: From JSON
  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      id: json['id'] as int,
      name: json['name'] as String,
      verses:
          (json['verses'] as List<dynamic>).map((v) => v as String).toList(),
      city: json['city'] as String,
    );
  }

  // TR: To JSON
  // EN: To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'verses': verses,
      'city': city,
    };
  }

  // TR: CopyWith
  // EN: CopyWith
  Surah copyWith({
    int? id,
    String? name,
    List<String>? verses,
    String? city,
  }) {
    return Surah(
      id: id ?? this.id,
      name: name ?? this.name,
      verses: verses ?? this.verses,
      city: city ?? this.city,
    );
  }

  // TR: Equality operator
  // EN: Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Surah &&
        other.id == id &&
        other.name == name &&
        other.verses.toString() == verses.toString() &&
        other.city == city;
  }

  // TR: Hash code
  // EN: Hash code
  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      verses,
      city,
    );
  }

  // TR: String representation
  // EN: String representation
  @override
  String toString() {
    return 'Surah(id: $id, name: $name, verses: ${verses.length}, city: $city)';
  }
}
