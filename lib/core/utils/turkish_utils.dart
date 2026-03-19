// TR: KUBBE V4 Turkish Utils - V1'den miras alındı
// EN: KUBBE V4 Turkish Utils - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki İ/i ve I/ı hassasiyetli 'toTitleCase' mantığını static bir yardımcı sınıf olarak yaz
// EN: Write V1's İ/i and I/ı sensitive 'toTitleCase' logic as a static helper class
// TR: Türkçe karakterler için özel string manipülasyon fonksiyonları
// EN: Special string manipulation functions for Turkish characters

/// TR: KUBBE V4 Turkish Utils Sınıfı
/// EN: KUBBE V4 Turkish Utils Class
/// TR: V1'deki İ/i ve I/ı hassasiyetli string işleme mantığını korur ve modernize eder
/// EN: Preserves and modernizes V1's İ/i and I/ı sensitive string processing logic
/// TR: Türkçe karakterler için özel string manipülasyon fonksiyonları
/// EN: Special string manipulation functions for Turkish characters
/// TR: Static fonksiyonlar ile kolay kullanım
/// EN: Easy usage with static functions
class TurkishUtils {
  // TR: V1'den miras alınan Türkçe karakter hassasiyetli toTitleCase fonksiyonu
  // EN: Turkish character sensitive toTitleCase function inherited from V1
  // TR: Türkçe karakterlerin (İ/i, I/ı) doğru şekilde işlendiği başlık çevirimi
  // EN: Title case conversion with proper handling of Turkish characters (İ/i, I/ı)
  // TR: V1 mantığı tamamen korundu - hiçbir değişiklik yapılmadı
  // EN: V1 logic completely preserved - no changes made
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;

    // TR: Text'i kelimelere ayır
    // EN: Split text into words
    final words = text.toLowerCase().split(' ');

    // EN: Convert each word to title case
    final titleWords = words.map((word) {
      if (word.isEmpty) return word;

      // TR: Türkçe karakterleri doğru işle - V1 mantığı
      // EN: Handle Turkish characters correctly - V1 logic
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
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // TR: Türkçe karakterleri normalize et - V1'den miras alındı
  // EN: Normalize Turkish characters - Inherited from V1
  // TR: Türkçe karakterleri İngilizce karşılıklarına çevir
  // EN: Convert Turkish characters to English equivalents
  static String removeDiacritics(String text) {
    if (text.isEmpty) return text;

    // TR: Türkçe karakter haritası - V1 mantığı
    // EN: Turkish character map - V1 logic
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
          prayer,
        ); // TR: Başlık formatı // EN: Title case format
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
      'Aralık',
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
  // TR: Metnin ilk kelimesini döndürürür
  // EN: Returns the first word of the text
  static String getFirstWord(String text) {
    if (isEmpty(text)) return '';

    final words = text.trim().split(' ');
    return words.isNotEmpty ? words.first : '';
  }

  // TR: Kelime sayısını al - V1'den miras alındı
  // EN: Get word count - Inherited from V1
  // TR: Metindeki kelime sayısını döndürürür
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

    // TR: Türkçe karakter haritası - V1 mantığı
    // EN: Turkish character map - V1 logic
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

    // TR: Türkçe karakter haritası - V1 mantığı
    // EN: Turkish character map - V1 logic
    final turkishLowerMap = {
      'İ': 'i',
      'I': 'ı',
      'Ç': 'ç',
      'Ğ': 'g',
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

  // TR: Türkçe karakter kontrolü - V1'den miras alındı
  // EN: Turkish character check - Inherited from V1
  // TR: Metnin Türkçe karakter içerip içermediğini kontrol eder
  // EN: Checks if text contains Turkish characters
  static bool containsTurkishCharacters(String text) {
    if (isEmpty(text)) return false;

    // TR: Türkçe karakterler - V1 mantığı
    // EN: Turkish characters - V1 logic
    final turkishChars = [
      'ç',
      'ğ',
      'ı',
      'İ',
      'ö',
      'ş',
      'ü',
      'Ç',
      'Ğ',
      'Ö',
      'Ş',
      'Ü',
    ];

    // TR: Her karakteri kontrol et
    // EN: Check each character
    for (final char in turkishChars) {
      if (text.contains(char)) return true;
    }

    return false;
  }

  // TR: Türkçe karakterleri değiştir - V1'den miras alındı
  // EN: Replace Turkish characters - Inherited from V1
  // TR: Türkçe karakterleri İngilizce karşılıklarına değiştirir
  // EN: Replaces Turkish characters with English equivalents
  static String replaceTurkishCharacters(String text, {bool toEnglish = true}) {
    if (isEmpty(text)) return text;

    if (toEnglish) {
      return removeDiacritics(text);
    } else {
      // TR: İngilizce karakterleri Türkçe karakterlere dönüştür
      // EN: Convert English characters to Turkish characters
      final englishToTurkish = {
        'c': 'ç',
        'C': 'Ç',
        'g': 'ğ',
        'G': 'Ğ',
        'i': 'ı',
        'I': 'İ',
        'o': 'ö',
        'O': 'Ö',
        's': 'ş',
        'S': 'Ş',
        'u': 'ü',
        'U': 'Ü',
      };

      String result = text;
      englishToTurkish.forEach((english, turkish) {
        result = result.replaceAll(english, turkish);
      });

      return result;
    }
  }

  // TR: Validasyon - V1'den miras alındı
  // EN: Validation - Inherited from V1
  // TR: Metnin geçerli olup olmadığını kontrol eder
  // EN: Checks if text is valid
  static bool isValidText(String text) {
    return isNotEmpty(text) && text.trim().isNotEmpty;
  }

  // TR: Email format kontrolü - V1'den miras alındı
  // EN: Email format check - Inherited from V1
  // TR: Metnin email formatında olup olmadığını kontrol eder
  // EN: Checks if text is in email format
  static bool isValidEmail(String email) {
    if (isEmpty(email)) return false;

    // TR: Basit email regex - V1 mantığı
    // EN: Simple email regex - V1 logic
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // TR: Telefon numarası formatla - V1'den miras alındı
  // EN: Format phone number - Inherited from V1
  // TR: Telefon numarasını Türkçe formatında gösterir
  // EN: Displays phone number in Turkish format
  static String formatPhoneNumber(String phone) {
    if (isEmpty(phone)) return '';

    // TR: Sadece rakamları al
    // EN: Get only digits
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      // TR: 05XX XXX XX formatı
      // EN: 05XX XXX XX format
      return '0${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6, 8)} ${digits.substring(8)}';
    } else if (digits.length == 11 && digits.startsWith('0')) {
      // TR: 0 5XX XXX XX formatı
      // EN: 0 5XX XXX XX format
      return '${digits.substring(0, 1)} ${digits.substring(1, 4)} ${digits.substring(4, 7)} ${digits.substring(7, 9)}';
    }

    return phone; // TR: Formatlanamadıysa orijinali döndür // EN: Return original if cannot format
  }

  // TR: URL format kontrolü - V1'den miras alındı
  // EN: URL format check - Inherited from V1
  // TR: Metnin URL formatında olup olmadığını kontrol eder
  // EN: Checks if text is in URL format
  static bool isValidUrl(String url) {
    if (isEmpty(url)) return false;

    // TR: Basit URL regex - V1 mantığı
    // EN: Simple URL regex - V1 logic
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    return urlRegex.hasMatch(url);
  }

  // TR: Karakter sayısını al - V1'den miras alındı
  // EN: Get character count - Inherited from V1
  // TR: Metindeki karakter sayısını döndürürür
  // EN: Returns the character count in the text
  static int getCharacterCount(String text) {
    if (isEmpty(text)) return 0;

    return text.length;
  }

  // TR: Karakter sayısını al (boşluksuz) - V1'den miras alındı
  // EN: Get character count (without spaces) - Inherited from V1
  // TR: Metindeki boşluksuz karakter sayısı döndürürür
  // EN: Returns the character count without spaces in the text
  static int getCharacterCountWithoutSpaces(String text) {
    if (isEmpty(text)) return 0;

    return text.replaceAll(' ', '').length;
  }

  // TR: Metni güvenli hale getir - V1'den miras alındı
  // EN: Make text safe - Inherited from V1
  // TR: Metindeki tehlikeli karakterleri temizler
  // EN: Cleans dangerous characters from text
  static String sanitize(String text) {
    if (isEmpty(text)) return '';

    // TR: HTML tag'lerini temizle
    // EN: Clean HTML tags
    String sanitized = text.replaceAll(RegExp(r'<[^>]*>'), '');

    // TR: Özel karakterleri temizle
    // EN: Clean special characters
    sanitized = sanitized.replaceAll(RegExp(r'[^\w\s\-]'), '');

    return sanitized.trim();
  }

  // TR: Metni slug haline getir - V1'den miras alındı
  // EN: Convert text to slug - Inherited from V1
  // TR: Metni URL için uygun hale getirir
  // EN: Makes text suitable for URL
  static String toSlug(String text) {
    if (isEmpty(text)) return '';

    // TR: Türkçe karakterleri değiştir
    // EN: Replace Turkish characters
    String slug = removeDiacritics(text.toLowerCase());

    // TR: Alfanümerik karakterler dışındakilerini temizle
    // EN: Clean non-alphanumeric characters
    slug = slug.replaceAll(RegExp(r'[^a-z0-9\s-]'), '');

    // TR: Boşlukları tire ile değiştir
    // EN: Replace spaces with hyphens
    slug = slug.replaceAll(RegExp(r'\s+'), '-');

    // TR: Fazla tireleri temizle
    // EN: Clean excess hyphens
    slug = slug.replaceAll(RegExp(r'-+'), '-');

    // TR: Baş ve sondaki tireleri temizle
    // EN: Clean leading and trailing hyphens
    slug = slug.replaceAll(RegExp(r'^-|-$'), '');

    return slug;
  }
}
