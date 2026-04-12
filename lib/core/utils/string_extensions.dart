// No import needed for String extension

extension TurkishStringExtension on String {
  /// Türkçeye uygun büyük harf dönüşümü yapar.
  /// 'i' -> 'İ', 'ı' -> 'I' dönüşümlerini garanti eder.
  String toLocaleUpperCase(String locale) {
    if (locale == 'tr') {
      return replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();
    }
    return toUpperCase();
  }

  /// Türkçeye uygun küçük harf dönüşümü yapar.
  String toLocaleLowerCase(String locale) {
    if (locale == 'tr') {
      return replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();
    }
    return toLowerCase();
  }
}
