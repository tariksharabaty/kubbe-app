// TR: KUBBE V4 Günün Ayeti Kartı - V4 standartları
// EN: KUBBE V4 Daily Verse Card - V4 standards
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Ana sayfada görünecek, günün ayetini gösteren, Outfit fontlu, 32dp radius'lu asil ayet kartı.
// EN: Daily verse card that will appear on home page, showing daily verse, with Outfit font and 32dp radius.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// TR: KUBBE V4 Günün Ayeti Kartı Widget'ı
/// EN: KUBBE V4 Daily Verse Card Widget
/// TR: Günün ayetini gösteren asil kart
/// EN: Elegant card showing daily verse
/// TR: 32dp radius ve Outfit font ile V4 estetiği
/// EN: V4 aesthetics with 32dp radius and Outfit font
/// TR: Günlük ayet gösterimi ve paylaşım özellikleri
/// EN: Daily verse display and sharing features
/// TR: Sy-OS design language
/// EN: Sy-OS design language
class GununAyetiKarti extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const GununAyetiKarti({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TR: Static ayet verisi (V1'den miras alındı)
    // EN: Static verse data (inherited from V1)
    final dailyVerse = _getDailyVerse();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // TR: Kart container
      // EN: Card container
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          // TR: 32dp radius - Sy-OS standartı
          // EN: 32dp radius - Sy-OS standard
          borderRadius: BorderRadius.circular(32.0),
          // TR: Gradient arka plan
          // EN: Gradient background
          gradient: LinearGradient(
            colors: [
              const Color(0xFF4CAF50), // TR: Yeşil // EN: Green
              const Color(0xFF4CAF50).withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // TR: Gölge
          // EN: Shadow
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        // TR: Kart içeriği
        // EN: Card content
        child: _buildVerseContent(context, dailyVerse),
      ),
    );
  }

  // TR: Ayet içeriği oluştur
  // EN: Build verse content
  Widget _buildVerseContent(BuildContext context, Map<String, String> verse) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TR: Üst satır - Ayet bilgisi
        // EN: Top row - Verse information
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TR: Ayet bilgisi
            // EN: Verse information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TR: Sure adı
                // EN: Surah name
                Text(
                  verse['surahName']!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(height: 4.0),

                // TR: Ayet numarası
                // EN: Verse number
                Text(
                  'Ayet ${verse['verseNumber']}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // TR: Ayet ikonu
            // EN: Verse icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                // TR: Yuvarlak
                // EN: Circle
                shape: BoxShape.circle,
                // TR: Beyaz arka plan
                // EN: White background
                color: Colors.white.withValues(alpha: 0.2),
              ),
              // TR: İkon içeriği
              // EN: Icon content
              child: const Center(
                // TR: Kitap ikonu
                // EN: Book icon
                child: Icon(
                  Icons.menu_book,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),

        // TR: Boşluk
        // EN: Spacer
        const SizedBox(height: 16.0),

        // TR: Ayet metni
        // EN: Verse text
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            // TR: 16dp radius
            // EN: 16dp radius
            borderRadius: BorderRadius.circular(16.0),
            // TR: Beyaz arka plan
            // EN: White background
            color: Colors.white.withValues(alpha: 0.1),
            // TR: Kenar
            // EN: Border
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          // TR: Ayet içeriği
          // EN: Verse content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TR: Ayet metni
              // EN: Verse text
              Text(
                verse['arabicText']!,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.5,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 12.0),

              // TR: Türkçe meal
              // EN: Turkish meaning
              Text(
                verse['turkishMeaning']!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        // TR: Boşluk
        // EN: Spacer
        const SizedBox(height: 16.0),

        // TR: Alt satır - Tarih ve paylaşım
        // EN: Bottom row - Date and sharing
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TR: Tarih bilgisi
            // EN: Date information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Günün Ayeti',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  _formatDate(DateTime.now()),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // TR: Paylaşım butonları
            // EN: Share buttons
            Row(
              children: [
                // TR: Kopyala butonu
                // EN: Copy button
                GestureDetector(
                  onTap: () {
                    // TR: Ayeti kopyala
                    // EN: Copy verse
                    _copyVerse(verse);
                  },
                  // TR: Buton
                  // EN: Button
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      // TR: Yuvarlak
                      // EN: Circle
                      shape: BoxShape.circle,
                      // TR: Beyaz arka plan
                      // EN: White background
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    // TR: İkon içeriği
                    // EN: Icon content
                    child: const Center(
                      // TR: Kopyala ikonu
                      // EN: Copy icon
                      child: Icon(
                        Icons.copy,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(width: 8.0),

                // TR: Paylaş butonu
                // EN: Share button
                GestureDetector(
                  onTap: () {
                    // TR: Ayeti paylaş
                    // EN: Share verse
                    _shareVerse(verse);
                  },
                  // TR: Buton
                  // EN: Button
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      // TR: Yuvarlak
                      // EN: Circle
                      shape: BoxShape.circle,
                      // TR: Beyaz arka plan
                      // EN: White background
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    // TR: İkon içeriği
                    // EN: Icon content
                    child: const Center(
                      // TR: Paylaş ikonu
                      // EN: Share icon
                      child: Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // TR: Günün ayetini al (V1'den miras alındı)
  // EN: Get daily verse (inherited from V1)
  Map<String, String> _getDailyVerse() {
    // TR: V1'den miras alınan ayetler
    // EN: Verses inherited from V1
    final verses = [
      {
        'surahName': 'Bakara',
        'verseNumber': '255',
        'arabicText': 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        'turkishMeaning':
            'Allah, Ondan başka ilah yoktur. O, hayıdır, ölümden de yaşayanı da ayakta tutar.',
      },
      {
        'surahName': 'Al-i İmran',
        'verseNumber': '173',
        'arabicText': 'الَّذِينَ يَسْتَمِعُونَ عَلَىٰ رَبِّهِمْ يُحَافِظُونَ',
        'turkishMeaning': 'Rabblerine karşı gelenler, O\'nu korurlar.',
      },
      {
        'surahName': 'Nisa',
        'verseNumber': '1',
        'arabicText':
            'يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ',
        'turkishMeaning':
            'Ey inananlar! Allah\'a, O hakkıyla O\'ndan sakının ve O\'na kul olun.',
      },
      {
        'surahName': 'Maide',
        'verseNumber': '3',
        'arabicText': 'حُرِّمَتِ اللَّيْلِ وَالنَّهَارِ وَالشَّمْسِ',
        'turkishMeaning':
            'Gündüzün ve gecenin, ayın ve güneşin kudretinde deliller vardır akıl sahipleri için.',
      },
      {
        'surahName': 'Enam',
        'verseNumber': '17',
        'arabicText':
            'وَإِنْ مَسَّكُمْ بِرِحْمٍ مّّا رَزَقْنَاكُمْ فَعَلَيْهِ تَشْكُرُ',
        'turkishMeaning':
            'Eğer siz Allah\'ın nimetini sayarsanız, az şükredersiniz.',
      },
    ];

    // TR: Bugüne göre ayet seç (V1 mantığı)
    // EN: Select verse based on today (V1 logic)
    final today = DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year, 1, 1)).inDays;
    final verseIndex = dayOfYear % verses.length;

    return verses[verseIndex];
  }

  // TR: Tarihi formatla
  // EN: Format date
  String _formatDate(DateTime date) {
    final monthsTR = [
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

    return '${date.day} ${monthsTR[date.month - 1]} ${date.year}';
  }

  // TR: Ayet kopyala
  // EN: Copy verse
  void _copyVerse(Map<String, String> verse) {
    // TR: Ayet metnini oluştur
    // EN: Create verse text
    final verseText =
        "${verse['arabic']}\n\n${verse['turkish']}\n\n${verse['meaning']}";

    // TR: Panoya kopyala
    // EN: Copy to clipboard
    Clipboard.setData(ClipboardData(text: verseText));

    // TR: Kopyalandı bildirimini göster (gelecekte eklenebilir)
    // EN: Show copied notification (can be added in future)
  }

// TR: Ayeti paylaş
  // EN: Share verse
  void _shareVerse(Map<String, String> verse) {
    // TR: Paylaşım işlemi (gelecekte eklenecek)
    // EN: Share operation (to be added in future)
    // Implement share functionality
  }
}

/// TR: Günün Ayeti Helper - V4 yeniliği
/// EN: Daily Verse Helper - V4 innovation
/// TR: Günün ayeti kartı için yardımcı fonksiyonlar
/// EN: Helper functions for daily verse card
class GununAyetiHelper {
  // TR: Ayet rengini al
  // EN: Get verse color
  // TR: TR: Sure rengine göre renk döndürür
  // EN: EN: Returns color based on surah color
  static Color getVerseColor(String surahName) {
    // TR: Sure renkleri (V1'den miras alındı)
    // EN: Surah colors (inherited from V1)
    final surahColors = {
      'Bakara': const Color(0xFF2196F3), // TR: Mavi // EN: Blue
      'Al-i İmran': const Color(0xFF4CAF50), // TR: Yeşil // EN: Green
      'Nisa': const Color(0xFF9C27B0), // TR: Mor // EN: Purple
      'Maide': const Color(0xFFFF9800), // TR: Turuncu // EN: Orange
      'Enam': const Color(0xFFFF5722), // TR: Kırmızı // EN: Red
    };

    return surahColors[surahName] ?? const Color(0xFF4CAF50);
  }

  // TR: Ayet ikonunu al
  // EN: Get verse icon
  // TR: TR: Sureye göre ikon döndürür
  // EN: EN: Returns icon based on surah
  static IconData getVerseIcon(String surahName) {
    // TR: Sure ikonları
    // EN: Surah icons
    final surahIcons = {
      'Bakara': Icons.book, // TR: Kitap // EN: Book
      'Al-i İmran': Icons.menu_book, // TR: Kitap // EN: Book
      'Nisa': Icons.description, // TR: Açıklama // EN: Description
      'Maide': Icons.lightbulb, // TR: Ampul // EN: Lightbulb
      'Enam': Icons.favorite, // TR: Kalp // EN: Heart
    };

    return surahIcons[surahName] ?? Icons.menu_book;
  }

  // TR: Ayet önem seviyesini al
  // EN: Get verse importance level
  // TR: TR: Ayetin önem seviyesini döndürür
  // EN: EN: Returns importance level of verse
  static int getVerseImportance(String surahName, int verseNumber) {
    // TR: Önemli ayetler (V1'den miras alındı)
    // EN: Important verses (inherited from V1)
    final importantVerses = {
      'Bakara': [
        255,
        286
      ], // TR: Ayetül-Kursi, Son ayet // EN: Verse of the Throne, Last verse
      'Al-i İmran': [
        173,
        200
      ], // TR: İman edenler, Sabır // EN: Believers, Patience
      'Nisa': [1, 59], // TR: Takva, Hükümler // EN: Piety, Rules
      'Maide': [3, 120], // TR: Deliller, Sözleşme // EN: Signs, Covenant
      'Enam': [17, 114], // TR: Nimet, Şükür // EN: Blessings, Gratitude
    };

    if (importantVerses.containsKey(surahName)) {
      return importantVerses[surahName]!.contains(verseNumber) ? 5 : 3;
    }

    return 3; // TR: Normal önem seviyesi // EN: Normal importance level
  }

  // TR: Ayet açıklamasını al
  // EN: Get verse description
  // TR: TR: Ayetin açıklamasını döndürür
  // EN: EN: Returns description of verse
  static String getVerseDescription(String surahName, int verseNumber,
      {String language = 'tr'}) {
    if (language == 'tr') {
      return '$surahName Suresi $verseNumber. Ayet';
    } else {
      return 'Surah $surahName, Verse $verseNumber';
    }
  }
}

/// TR: Günün Ayeti Provider - V4 yeniliği
/// EN: Daily Verse Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
final gununAyetiProvider = Provider<GununAyetiHelper>((ref) {
  return GununAyetiHelper();
});
