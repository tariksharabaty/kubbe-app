// Namaz vakti modeli - Prayer time model
class PrayerTimeModel {
  final String imsak; // İmsak vakti - Fajr time
  final String gunes; // Güneş vakti - Sunrise time
  final String ogle; // Öğle vakti - Dhuhr time
  final String ikindi; // İkindi vakti - Asr time
  final String aksam; // Akşam vakti - Maghrib time
  final String yatsi; // Yatsı vakti - Isha time
  final String hicriTarih; // Hicri tarih - Hijri date
  final String? timezone; // Zaman dilimi - Timezone

  // Constructor - Yapıcı metot
  PrayerTimeModel({
    required this.imsak,
    required this.gunes,
    required this.ogle,
    required this.ikindi,
    required this.aksam,
    required this.yatsi,
    required this.hicriTarih,
    this.timezone,
  });

  // JSON'dan model oluşturma - Create model from JSON
  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      imsak: json['Imsak'] ?? '',
      gunes: json['Gunes'] ?? '',
      ogle: json['Ogle'] ?? '',
      ikindi: json['Ikindi'] ?? '',
      aksam: json['Aksam'] ?? '',
      yatsi: json['Yatsi'] ?? '',
      hicriTarih: json['HicriTarih'] ?? '',
      timezone: json['Timezone'],
    );
  }

  // Model'i JSON'a çevirme - Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'Imsak': imsak,
      'Gunes': gunes,
      'Ogle': ogle,
      'Ikindi': ikindi,
      'Aksam': aksam,
      'Yatsi': yatsi,
      'HicriTarih': hicriTarih,
      'Timezone': timezone,
    };
  }

  // Namaz vakitleri listesi - List of prayer times
  List<String> get prayerTimes => [imsak, gunes, ogle, ikindi, aksam, yatsi];

  // Namaz isimleri - Prayer names
  static List<String> get prayerNames => [
    'İmsak', // Fajr
    'Güneş', // Sunrise
    'Öğle', // Dhuhr
    'İkindi', // Asr
    'Akşam', // Maghrib
    'Yatsı', // Isha
  ];

  @override
  String toString() {
    return 'PrayerTimeModel(imsak: $imsak, gunes: $gunes, ogle: $ogle, ikindi: $ikindi, aksam: $aksam, yatsi: $yatsi, hicriTarih: $hicriTarih)';
  }
}
