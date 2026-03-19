// TR: KUBBE V4 String Utils - V1'den miras alındı
// EN: KUBBE V4 String Utils - Inherited from V1
// TR: V1'deki İ/i ve I/ı hassasiyetli string işleme mantığından miras alındı
// EN: Inherited from V1's İ/i and I/ı sensitive string processing logic
// TR: Türkçe karakterler için özel string manipülasyon fonksiyonları
// EN: Special string manipulation functions for Turkish characters

/// TR: KUBBE V4 String Utils Sınıfı
/// EN: KUBBE V4 String Utils Class
/// TR: V1'deki Turkish string işleme mantığını korur ve modernize eder
/// EN: Preserves and modernizes V1's Turkish string processing logic
/// TR: İ/i ve I/ı hassasiyeti ile string manipülasyon
/// EN: String manipulation with İ/i and I/ı sensitivity
class StringUtils {
  // TR: V1'den miras alınan Türkçe karakter hassasiyetli toTitleCase fonksiyonu
  // EN: Turkish character sensitive toTitleCase function inherited from V1
  // TR: Türkçe karakterlerin (İ/i, I/ı) doğru şekilde işlendiği başlık çevirimi
  // EN: Title case conversion with proper handling of Turkish characters (İ/i, I/ı)
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;

    // TR: Text'i kelimelere ayır
    // EN: Split text into words
    final words = text.toLowerCase().split(' ');

    // EN: Convert each word to title case
    final titleWords = words.map((word) {
      if (word.isEmpty) return word;

      // TR: Türkçe karakterleri doğru işle
      // EN: Handle Turkish characters correctly
      if (word.startsWith('i')) {
        return 'İ${word.substring(1)}';
      } else if (word.startsWith('ı')) {
        return 'I${word.substring(1)}';
      } else {
        // TR: İlk harfi büyüt, geri kalanı küçük tut
        // EN: Capitalize first letter, keep rest lowercase
        return '${word[0].toUpperCase()}${word.substring(1)}';
      }
    });

    // TR: Kelimeleri birleştir ve döndür
    // EN: Join words and return
    return titleWords.join(' ');
  }

  // TR: Cümle başlığı çevirimi - V1'den miras alındı
  // EN: Sentence title case conversion - Inherited from V1
  // TR: Cümlenin sadece baş harfini büyütür
  // EN: Capitalize only the first letter of the sentence
  static String toSentenceCase(String text) {
    if (text.isEmpty) return text;

    // TR: İlk harfi büyüt, geri kalanı küçük tut
    // EN: Capitalize first letter, keep rest lowercase
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }

  // TR: Türkçe karakterleri normalize et - V1'den miras alındı
  // EN: Normalize Turkish characters - Inherited from V1
  // TR: Türkçe karakterleri İngilizce karşılıklarına çevir
  // EN: Convert Turkish characters to English equivalents
  static String removeDiacritics(String text) {
    if (text.isEmpty) return text;

    // TR: Türkçe karakter haritası
    // EN: Turkish character map
    final turkishMap = {
      'ç': 'c',
      'Ç': 'C',
      'ğ': 'g',
      'Ğ': 'G',
      'ı': 'i',
      'İ': 'I',
      'ö': 'o',
      'Ö': 'O',
      'ş': 's',
      'Ş': 'S',
      'ü': 'u',
      'Ü': 'U',
    };

    // TR: Karakterleri değiştir
    // EN: Replace characters
    String normalized = text;
    turkishMap.forEach((turkish, english) {
      normalized = normalized.replaceAll(turkish, english);
    });

    return normalized;
  }

  // TR: Namaz ismini formatla - V1'den miras alındı
  // EN: Format prayer name - Inherited from V1
  // TR: Namaz isimlerini Türkçe olarak formatla
  // EN: Format prayer names in Turkish
  static String formatPrayerName(String prayer) {
    switch (prayer.toLowerCase()) {
      case 'fajr':
        return 'Sabah'; // TR: Sabah namazı // EN: Morning prayer
      case 'sunrise':
        return 'Güneş'; // TR: Güneş doğumu // EN: Sunrise
      case 'dhuhr':
        return 'Öğle'; // TR: Öğle namazı // EN: Noon prayer
      case 'asr':
        return 'İkindi'; // TR: İkindi namazı // EN: Afternoon prayer
      case 'maghrib':
        return 'Akşam'; // TR: Akşam namazı // EN: Evening prayer
      case 'isha':
        return 'Yatsı'; // TR: Yatsı namazı // EN: Night prayer
      default:
        return toTitleCase(
            prayer); // TR: Başlık formatı // EN: Title case format
    }
  }

  // TR: Zaman formatla - V1'den miras alındı
  // EN: Format time - Inherited from V1
  // TR: Zamanı HH:MM formatında göster
  // EN: Display time in HH:MM format
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // TR: Tarih formatla - V1'den miras alındı
  // EN: Format date - Inherited from V1
  // TR: Tarihi Türkçe formatında göster
  // EN: Display date in Turkish format
  static String formatDate(DateTime date) {
    final months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // TR: Sayı formatla - V1'den miras alındı
  // EN: Format number - Inherited from V1
  // TR: Sayıyı binlik ayraçlarla formatla
  // EN: Format number with thousand separators
  static String formatNumber(int number) {
    if (number < 1000) return number.toString();

    // TR: Binlik ayraç ekle
    // EN: Add thousand separators
    final formatted = number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );

    return formatted;
  }

  // TR: Metni kısalt - V1'den miras alındı
  // EN: Truncate text - Inherited from V1
  // TR: Metni belirtilen uzunluktan sonra kısalt
  // EN: Truncate text after specified length
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;

    // TR: Metni kısalt ve son ek ekle
    // EN: Truncate text and add suffix
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  // TR: Boş mu kontrolü - V1'den miras alındı
  // EN: Is empty check - Inherited from V1
  // TR: String'in boş veya sadece boşluk içerip içermediğini kontrol et
  // EN: Check if string is empty or contains only whitespace
  static bool isEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

  // TR: Boş değil mi kontrolü - V1'den miras alındı
  // EN: Is not empty check - Inherited from V1
  // TR: String'in boş olmadığını ve içerik içerdiğini kontrol et
  // EN: Check if string is not empty and contains content
  static bool isNotEmpty(String? text) {
    return !isEmpty(text);
  }

  // TR: İlk kelimeyi al - V1'den miras alındı
  // EN: Get first word - Inherited from V1
  // TR: Metnin ilk kelimesini döndürür
  // EN: Returns the first word of the text
  static String getFirstWord(String text) {
    if (isEmpty(text)) return '';

    final words = text.trim().split(' ');
    return words.isNotEmpty ? words.first : '';
  }

  // TR: Kelime sayısını al - V1'den miras alındı
  // EN: Get word count - Inherited from V1
  // TR: Metindeki kelime sayısını döndürür
  // EN: Returns the word count in the text
  static int getWordCount(String text) {
    if (isEmpty(text)) return 0;

    return text.trim().split(' ').length;
  }

  // TR: Metni temizle - V1'den miras alındı
  // EN: Clean text - Inherited from V1
  // TR: Metnin başındaki ve sonundaki boşlukları temizler
  // EN: Cleans leading and trailing whitespace from text
  static String clean(String text) {
    if (isEmpty(text)) return '';

    return text.trim();
  }

  // TR: Büyük/küçük harf duyarsız karşılaştırma - V1'den miras alındı
  // EN: Case insensitive comparison - Inherited from V1
  // TR: İki metni büyük/küçük harf duyarsız karşılaştırır
  // EN: Compares two texts case insensitively
  static bool equalsIgnoreCase(String a, String b) {
    return a.toLowerCase() == b.toLowerCase();
  }

  // TR: Metni tersine çevir - V1'den miras alındı
  // EN: Reverse text - Inherited from V1
  // TR: Metnin karakterlerini tersine çevirir
  // EN: Reverses the characters of the text
  static String reverse(String text) {
    if (isEmpty(text)) return '';

    return text.split('').reversed.join('');
  }

  // TR: Metni büyük harfe çevir - V1'den miras alındı
  // EN: Convert to uppercase - Inherited from V1
  // TR: Metni Türkçe karakterler dahil büyük harfe çevirir
  // EN: Converts text to uppercase including Turkish characters
  static String toUpperCase(String text) {
    if (isEmpty(text)) return '';

    // TR: Türkçe karakter haritası
    // EN: Turkish character map
    final turkishUpperMap = {
      'i': 'İ',
      'ı': 'I',
      'ç': 'Ç',
      'ğ': 'Ğ',
      'ö': 'Ö',
      'ş': 'Ş',
      'ü': 'Ü',
    };

    // TR: Karakterleri büyük harfe çevir
    // EN: Convert characters to uppercase
    String upperText = text.toUpperCase();
    turkishUpperMap.forEach((lower, upper) {
      upperText = upperText.replaceAll(lower, upper);
    });

    return upperText;
  }

  // TR: Metni küçük harfe çevir - V1'den miras alındı
  // EN: Convert to lowercase - Inherited from V1
  // TR: Metni Türkçe karakterler dahil küçük harfe çevirir
  // EN: Converts text to lowercase including Turkish characters
  static String toLowerCase(String text) {
    if (isEmpty(text)) return '';

    // TR: Türkçe karakter haritası
    // EN: Turkish character map
    final turkishLowerMap = {
      'İ': 'i',
      'I': 'ı',
      'Ç': 'ç',
      'Ğ': 'ğ',
      'Ö': 'ö',
      'Ş': 'ş',
      'Ü': 'ü',
    };

    // TR: Karakterleri küçük harfe çevir
    // EN: Convert characters to lowercase
    String lowerText = text.toLowerCase();
    turkishLowerMap.forEach((upper, lower) {
      lowerText = lowerText.replaceAll(upper, lower);
    });

    return lowerText;
  }
}
