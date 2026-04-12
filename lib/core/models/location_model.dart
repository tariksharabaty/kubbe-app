// Konum modeli - Location model
class LocationModel {
  final String sehir;
  final String ulke;
  final String bolge;
  final double latitude;
  final double longitude;
  final String? timezone;

  const LocationModel({
    required this.sehir,
    required this.ulke,
    this.bolge = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.timezone,
  });

  Map<String, dynamic> toJson() => {
    'sehir': sehir,
    'ulke': ulke,
    'bolge': bolge,
    'latitude': latitude,
    'longitude': longitude,
    'timezone': timezone,
  };

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    sehir: json['sehir'],
    ulke: json['ulke'],
    bolge: json['bolge'] ?? '',
    latitude: json['latitude'] ?? 0.0,
    longitude: json['longitude'] ?? 0.0,
    timezone: json['timezone'],
  );

  @override
  String toString() {
    return '$sehir, $ulke${bolge.isNotEmpty ? ' - $bolge' : ''}';
  }
}
