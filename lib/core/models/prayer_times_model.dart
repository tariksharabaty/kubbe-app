// Namaz vakitleri modeli - Prayer times model
class PrayerTimesResponse {
  final List<PrayerTimesData> data; // Veri listesi - Data list

  // Constructor - Yapıcı metot
  PrayerTimesResponse({required this.data});

  // JSON'dan model oluşturma - Create model from JSON
  factory PrayerTimesResponse.fromJson(Map<String, dynamic> json) {
    final List<PrayerTimesData> dataList = [];

    // JSON anahtarlarını kontrol et - Check JSON keys
    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        dataList.add(PrayerTimesData.fromJson(value));
      }
    });

    return PrayerTimesResponse(data: dataList);
  }
}

// Namaz vakitleri verisi - Prayer times data
class PrayerTimesData {
  final String imsak; // İmsak vakti - Fajr time
  final String gunes; // Güneş vakti - Sunrise time
  final String ogle; // Öğle vakti - Dhuhr time
  final String ikindi; // İkindi vakti - Asr time
  final String aksam; // Akşam vakti - Maghrib time
  final String yatsi; // Yatsı vakti - Isha time
  final String hicriTarih; // Hicri tarih - Hijri date
  final String miladiTarih; // Miladi tarih - Gregorian date

  // Constructor - Yapıcı metot
  PrayerTimesData({
    required this.imsak,
    required this.gunes,
    required this.ogle,
    required this.ikindi,
    required this.aksam,
    required this.yatsi,
    required this.hicriTarih,
    required this.miladiTarih,
  });

  // JSON'dan model oluşturma - Create model from JSON
  factory PrayerTimesData.fromJson(Map<String, dynamic> json) {
    return PrayerTimesData(
      imsak: json['Imsak'] ?? json['imsak'] ?? '',
      gunes: json['Gunes'] ?? json['gunes'] ?? '',
      ogle: json['Ogle'] ?? json['ogle'] ?? '',
      ikindi: json['Ikindi'] ?? json['ikindi'] ?? '',
      aksam: json['Aksam'] ?? json['aksam'] ?? '',
      yatsi: json['Yatsi'] ?? json['yatsi'] ?? '',
      hicriTarih: json['HicriTarih'] ?? json['hicriTarih'] ?? '',
      miladiTarih: json['MiladiTarih'] ?? json['miladiTarih'] ?? '',
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
      'MiladiTarih': miladiTarih,
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

  // Zaman formatını doğrula - Validate time format
  bool isValidTimeFormat(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return false;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    return hour != null &&
        minute != null &&
        hour >= 0 &&
        hour <= 23 &&
        minute >= 0 &&
        minute <= 59;
  }

  // Tüm vakitlerin geçerli olup olmadığını kontrol et - Check if all times are valid
  bool get areAllTimesValid {
    return prayerTimes.every((time) => isValidTimeFormat(time));
  }

  // Belirli bir vakti getir - Get specific prayer time
  String? getPrayerTime(String prayerName) {
    final index = prayerNames.indexOf(prayerName);
    if (index != -1 && index < prayerTimes.length) {
      return prayerTimes[index];
    }
    return null;
  }

  @override
  String toString() {
    return 'PrayerTimesData(imsak: $imsak, gunes: $gunes, ogle: $ogle, ikindi: $ikindi, aksam: $aksam, yatsi: $yatsi, hicriTarih: $hicriTarih)';
  }
}

// API yanıt modeli - API response model
class ApiResponse<T> {
  final bool success; // Başarılı mı? - Is successful?
  final T? data; // Veri - Data
  final String? error; // Hata mesajı - Error message

  // Constructor - Yapıcı metot
  ApiResponse({required this.success, this.data, this.error});

  // Başarılı yanıt oluştur - Create success response
  factory ApiResponse.success(T data) {
    return ApiResponse(success: true, data: data);
  }

  // Hatalı yanıt oluştur - Create error response
  factory ApiResponse.error(String error) {
    return ApiResponse(success: false, error: error);
  }
}
