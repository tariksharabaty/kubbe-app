/// Utility functions for Quranic text and formatting.
class QuranUtils {
  /// Converts standard digits (0-9) to Eastern Arabic numerals (٠-٩).
  static String toArabicNumerals(int number) {
    const eng = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String numStr = number.toString();
    for (int i = 0; i < eng.length; i++) {
      numStr = numStr.replaceAll(eng[i], arabic[i]);
    }
    return numStr;
  }
}
