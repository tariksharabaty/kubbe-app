// TR: KUBBE V4 Zekatmatik Hesaplama - V1'den miras alındı
// EN: KUBBE V4 Zekat Calculator - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: V1'deki altın, gümüş, nakit ve mal varlığı bazlı zekat hesaplama algoritmasını port et
// EN: Port V1's gold, silver, cash and asset based zakat calculation algorithm
// TR: Nisap miktarı (80.18 gr altın) kontrolünü güncel veriye göre yapacak şekilde kurgula
// EN: Structure to check nisap amount (80.18 gr gold) based on current data

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TR: KUBBE V4 Zekat Hesaplama Sınıfı
/// EN: KUBBE V4 Zakat Calculation Class
/// TR: V1'deki zekat hesaplama mantığını modern Flutter ile birleştirir
/// EN: Combines V1's zakat calculation logic with modern Flutter
/// TR: Altın, gümüş, nakit ve mal varlığı bazlı hesaplamalar
/// EN: Calculations based on gold, silver, cash and assets
/// TR: Nisap miktarı kontrolü ve güncel veri entegrasyonu
/// EN: Nisap amount control and current data integration
/// TR: V1'den miras alındı ve modernize edildi
/// EN: Inherited from V1 and modernized
class ZekatCalculator {
  // TR: Nisap miktarları (V1'den miras alındı)
  // EN: Nisap amounts (inherited from V1)
  static const double _nisapAltinGram =
      80.18; // TR: Altın nisabı (gram) // EN: Gold nisap (grams)
  static const double _nisapGumusGram =
      567.0; // TR: Gümüş nisabı (gram) // EN: Silver nisap (grams)

  // TR: Zekat oranları (V1'den miras alındı)
  // EN: Zakat rates (inherited from V1)
  static const double _zekatOrani =
      0.025; // TR: %2.5 zekat oranı // EN: 2.5% zakat rate

  // TR: Güncel değerler (gelecekte API'den alınacak)
  // EN: Current values (will be taken from API in future)
  static const double _altinGramFiyati =
      2800.0; // TR: 1 gram altın fiyatı (TL) // EN: 1 gram gold price (TL)
  static const double _gumusGramFiyati =
      35.0; // TR: 1 gram gümüş fiyatı (TL) // EN: 1 gram silver price (TL)

  // TR: Zekat hesapla
  // EN: Calculate zakat
  // TR: TR: Verilen varlıklara göre zekat miktarını hesaplar
  // EN: EN: Calculates zakat amount based on given assets
  ZekatSonucu zekatHesapla({
    required double altinMiktari,
    required double gumusMiktari,
    required double nakitMiktari,
    required double digerVarliklar,
    double altinGramFiyati = _altinGramFiyati,
    double gumusGramFiyati = _gumusGramFiyati,
  }) {
    try {
      // TR: Altın varlığını hesapla
      // EN: Calculate gold assets
      final altinVarligi = altinMiktari * altinGramFiyati;
      final altinNisap = _nisapAltinGram * altinGramFiyati;
      final altinZekati =
          altinVarligi >= altinNisap ? altinVarligi * _zekatOrani : 0.0;

      // TR: Gümüş varlığını hesapla
      // EN: Calculate silver assets
      final gumusVarligi = gumusMiktari * gumusGramFiyati;
      final gumusNisap = _nisapGumusGram * gumusGramFiyati;
      final gumusZekati =
          gumusVarligi >= gumusNisap ? gumusVarligi * _zekatOrani : 0.0;

      // TR: Nakit varlığını hesapla
      // EN: Calculate cash assets
      final nakitVarligi = nakitMiktari;
      final nakitNisap =
          altinNisap; // TR: Nakit için altın nisabı kullanılır // EN: Gold nisab is used for cash
      final nakitZekati =
          nakitVarligi >= nakitNisap ? nakitVarligi * _zekatOrani : 0.0;

      // TR: Diğer varlıkları hesapla
      // EN: Calculate other assets
      final digerVarliklarToplam = digerVarliklar;
      final digerNisap =
          altinNisap; // TR: Diğer varlıklar için altın nisabı kullanılır // EN: Gold nisab is used for other assets
      final digerZekat = digerVarliklarToplam >= digerNisap
          ? digerVarliklarToplam * _zekatOrani
          : 0.0;

      // TR: Toplam varlığı hesapla
      // EN: Calculate total assets
      final toplamVarlik =
          altinVarligi + gumusVarligi + nakitVarligi + digerVarliklarToplam;

      // TR: Toplam zekatı hesapla
      // EN: Calculate total zakat
      final toplamZekat = altinZekati + gumusZekati + nakitZekati + digerZekat;

      // TR: Nisap aşıldı mı kontrol et
      // EN: Check if nisab is exceeded
      final nisapAsildi = toplamVarlik >= altinNisap;

      return ZekatSonucu(
        altinVarligi: altinVarligi,
        altinZekati: altinZekati,
        gumusVarligi: gumusVarligi,
        gumusZekati: gumusZekati,
        nakitVarligi: nakitVarligi,
        nakitZekati: nakitZekati,
        digerVarliklar: digerVarliklarToplam,
        digerZekat: digerZekat,
        toplamVarlik: toplamVarlik,
        toplamZekat: toplamZekat,
        nisapAsildi: nisapAsildi,
      );
    } catch (e) {
      // TR: Hata durumunda
      // EN: On error
      debugPrint('TR: Zekat hesaplama hatası: $e');
      debugPrint('EN: Zakat calculation error: $e');

      // TR: Boş sonuç döndür
      // EN: Return empty result
      return ZekatSonucu(
        altinVarligi: 0.0,
        altinZekati: 0.0,
        gumusVarligi: 0.0,
        gumusZekati: 0.0,
        nakitVarligi: 0.0,
        nakitZekati: 0.0,
        digerVarliklar: 0.0,
        digerZekat: 0.0,
        toplamVarlik: 0.0,
        toplamZekat: 0.0,
        nisapAsildi: false,
      );
    }
  }

  // TR: Altın zekatını hesapla
  // EN: Calculate gold zakat
  // TR: TR: Sadece altın varlıklarına göre zekat hesaplar
  // EN: EN: Calculates zakat based only on gold assets
  double altinZekatiHesapla(double altinMiktari,
      {double altinGramFiyati = _altinGramFiyati}) {
    final altinVarligi = altinMiktari * altinGramFiyati;
    final altinNisap = _nisapAltinGram * altinGramFiyati;

    return altinVarligi >= altinNisap ? altinVarligi * _zekatOrani : 0.0;
  }

  // TR: Gümüş zekatını hesapla
  // EN: Calculate silver zakat
  // TR: TR: Sadece gümüş varlıklarına göre zekat hesaplar
  // EN: EN: Calculates zakat based only on silver assets
  double gumusZekatiHesapla(double gumusMiktari,
      {double gumusGramFiyati = _gumusGramFiyati}) {
    final gumusVarligi = gumusMiktari * gumusGramFiyati;
    const gumusNisap = _nisapGumusGram * _gumusGramFiyati;

    return gumusVarligi >= gumusNisap ? gumusVarligi * _zekatOrani : 0.0;
  }

  // TR: Nakit zekatını hesapla
  // EN: Calculate cash zakat
  // TR: TR: Sadece nakit varlıklarına göre zekat hesaplar
  // EN: EN: Calculates zakat based only on cash assets
  double nakitZekatiHesapla(double nakitMiktari) {
    const nakitNisap = _nisapAltinGram * _altinGramFiyati;

    return nakitMiktari >= nakitNisap ? nakitMiktari * _zekatOrani : 0.0;
  }

  // TR: Nisap kontrolü yap
  // EN: Check nisab
  // TR: TR: Verilen varlığın nisap miktarını aşıp aşmadığını kontrol eder
  // EN: EN: Checks if given asset exceeds nisab amount
  bool nisapKontrolu(double varlikMiktari, String varlikTuru) {
    switch (varlikTuru.toLowerCase()) {
      case 'altin':
        final altinVarligi = varlikMiktari * _altinGramFiyati;
        const altinNisap = _nisapAltinGram * _altinGramFiyati;
        return altinVarligi >= altinNisap;
      case 'gumus':
        final gumusVarligi = varlikMiktari * _gumusGramFiyati;
        const gumusNisap = _nisapGumusGram * _gumusGramFiyati;
        return gumusVarligi >= gumusNisap;
      case 'nakit':
        const nakitNisap = _nisapAltinGram * _altinGramFiyati;
        return varlikMiktari >= nakitNisap;
      default:
        const genelNisap = _nisapAltinGram * _altinGramFiyati;
        return varlikMiktari >= genelNisap;
    }
  }

  // TR: Zekat oranını al
  // EN: Get zakat rate
  // TR: TR: Zekat oranını döndürür
  // EN: EN: Returns zakat rate
  double get zekatOrani => _zekatOrani;

  // TR: Nisap miktarlarını al
  // EN: Get nisab amounts
  // TR: TR: Nisap miktarlarını döndürür
  // EN: EN: Returns nisab amounts
  Map<String, double> get nisapMiktarlari => {
        'altin_gram': _nisapAltinGram,
        'gumus_gram': _nisapGumusGram,
        'altin_tl': _nisapAltinGram * _altinGramFiyati,
        'gumus_tl': _nisapGumusGram * _gumusGramFiyati,
      };

  // TR: Güncel fiyatları al
  // EN: Get current prices
  // TR: TR: Güncel fiyatları döndürür
  // EN: EN: Returns current prices
  Map<String, double> get guncelFiyatlar => {
        'altin_gram': _altinGramFiyati,
        'gumus_gram': _gumusGramFiyati,
      };

  // TR: Zekat bilgilerini formatla
  // EN: Format zakat information
  // TR: TR: Zekat sonucunu kullanıcı dostu bir formatta döndürür
  // EN: EN: Returns zakat result in user-friendly format
  Map<String, String> formatZekatBilgisi(ZekatSonucu sonuc,
      {String language = 'tr'}) {
    if (language == 'tr') {
      return {
        'altin_varligi':
            'Altın Varlığı: ${sonuc.altinVarligi.toStringAsFixed(2)} TL',
        'altin_zekati':
            'Altın Zekatı: ${sonuc.altinZekati.toStringAsFixed(2)} TL',
        'gumus_varligi':
            'Gümüş Varlığı: ${sonuc.gumusVarligi.toStringAsFixed(2)} TL',
        'gumus_zekati':
            'Gümüş Zekatı: ${sonuc.gumusZekati.toStringAsFixed(2)} TL',
        'nakit_varligi':
            'Nakit Varlığı: ${sonuc.nakitVarligi.toStringAsFixed(2)} TL',
        'nakit_zekati':
            'Nakit Zekatı: ${sonuc.nakitZekati.toStringAsFixed(2)} TL',
        'diger_varliklar':
            'Diğer Varlıklar: ${sonuc.digerVarliklar.toStringAsFixed(2)} TL',
        'diger_zekat': 'Diğer Zekat: ${sonuc.digerZekat.toStringAsFixed(2)} TL',
        'toplam_varlik':
            'Toplam Varlık: ${sonuc.toplamVarlik.toStringAsFixed(2)} TL',
        'toplam_zekat':
            'Toplam Zekat: ${sonuc.toplamZekat.toStringAsFixed(2)} TL',
        'nisap_durumu': sonuc.nisapAsildi ? 'Nisap Aşıldı' : 'Nisap Aşılmadı',
        'mesaj': sonuc.nisapAsildi
            ? 'Zekat vermeniz gerekmektedir. Allah (cc) kabul etsin.'
            : 'Henüz zekat vermek zorunda değilsiniz. Allah (cc) zenginlik versin.',
      };
    } else {
      return {
        'altin_varligi':
            'Gold Assets: ${sonuc.altinVarligi.toStringAsFixed(2)} TL',
        'altin_zekati':
            'Gold Zakat: ${sonuc.altinZekati.toStringAsFixed(2)} TL',
        'gumus_varligi':
            'Silver Assets: ${sonuc.gumusVarligi.toStringAsFixed(2)} TL',
        'gumus_zekati':
            'Silver Zakat: ${sonuc.gumusZekati.toStringAsFixed(2)} TL',
        'nakit_varligi':
            'Cash Assets: ${sonuc.nakitVarligi.toStringAsFixed(2)} TL',
        'nakit_zekati':
            'Cash Zakat: ${sonuc.nakitZekati.toStringAsFixed(2)} TL',
        'diger_varliklar':
            'Other Assets: ${sonuc.digerVarliklar.toStringAsFixed(2)} TL',
        'diger_zekat': 'Other Zakat: ${sonuc.digerZekat.toStringAsFixed(2)} TL',
        'toplam_varlik':
            'Total Assets: ${sonuc.toplamVarlik.toStringAsFixed(2)} TL',
        'toplam_zekat':
            'Total Zakat: ${sonuc.toplamZekat.toStringAsFixed(2)} TL',
        'nisap_durumu':
            sonuc.nisapAsildi ? 'Nisab Exceeded' : 'Nisab Not Exceeded',
        'mesaj': sonuc.nisapAsildi
            ? 'You are required to pay zakat. May Allah accept it.'
            : 'You are not required to pay zakat yet. May Allah grant you wealth.',
      };
    }
  }

  // TR: Zekat önerisi oluştur
  // EN: Create zakat suggestion
  // TR: TR: Zekat önerisi metni oluşturur
  // EN: EN: Creates zakat suggestion text
  String zekatOnerisi(ZekatSonucu sonuc, {String language = 'tr'}) {
    if (language == 'tr') {
      if (sonuc.nisapAsildi) {
        return 'Zekatınızı vermek için en uygun zaman. ${sonuc.toplamZekat.toStringAsFixed(2)} TL zekat vererek fakirliğe ortak olabilirsiniz.';
      } else {
        final nisapFarki =
            (_nisapAltinGram * _altinGramFiyati) - sonuc.toplamVarlik;
        return 'Nisap miktarına ulaşmak için ${nisapFarki.toStringAsFixed(2)} TL daha varlığa ihtiyacınız var.';
      }
    } else {
      if (sonuc.nisapAsildi) {
        return 'It\'s the perfect time to give your zakat. You can share in poverty by giving ${sonuc.toplamZekat.toStringAsFixed(2)} TL zakat.';
      } else {
        final nisapFarki =
            (_nisapAltinGram * _altinGramFiyati) - sonuc.toplamVarlik;
        return 'You need ${nisapFarki.toStringAsFixed(2)} TL more assets to reach the nisab amount.';
      }
    }
  }

  // TR: Zekat takvimini hesapla
  // EN: Calculate zakat calendar
  // TR: TR: Zekat takvimini hesaplar (gelecekte geliştirilebilir)
  // EN: EN: Calculates zakat calendar (to be developed in future)
  Map<String, dynamic> zekatTakvimiHesapla(DateTime hesaplamaTarihi) {
    // TR: Basit takvim hesaplaması (V1 mantığı)
    // EN: Simple calendar calculation (V1 logic)
    final takvimYili = hesaplamaTarihi.year;
    final ramazanBaslangici = DateTime(
        takvimYili, 4, 1); // TR: Basit hesaplama // EN: Simple calculation

    return {
      'hesaplama_tarihi': hesaplamaTarihi.toIso8601String(),
      'ramazan_baslangici': ramazanBaslangici.toIso8601String(),
      'zekat_yili': takvimYili,
      'onerilen_tarih': ramazanBaslangici.toIso8601String(),
      'mesaj': 'Zekatınızı Ramazan ayında vermek daha faziletlidır.',
    };
  }
}

// TR: Zekat Hesaplama Sonucu Sınıfı
// EN: Zakat Calculation Result Class
/// TR: Zekat hesaplama sonucunu temsil eder
/// EN: Represents zakat calculation result
/// TR: Tüm varlık türleri ve zekat miktarını içerir
/// EN: Contains all asset types and zakat amount
class ZekatSonucu {
  // TR: Altın varlığı
  // EN: Gold assets
  final double altinVarligi;

  // TR: Altın zekatı
  // EN: Gold zakat
  final double altinZekati;

  // TR: Gümüş varlığı
  // EN: Silver assets
  final double gumusVarligi;

  // TR: Gümüş zekatı
  // EN: Silver zakat
  final double gumusZekati;

  // TR: Nakit varlığı
  // EN: Cash assets
  final double nakitVarligi;

  // TR: Nakit zekatı
  // EN: Cash zakat
  final double nakitZekati;

  // TR: Diğer varlıklar
  // EN: Other assets
  final double digerVarliklar;

  // TR: Diğer zekat
  // EN: Other zakat
  final double digerZekat;

  // TR: Toplam varlık
  // EN: Total assets
  final double toplamVarlik;

  // TR: Toplam zekat
  // EN: Total zakat
  final double toplamZekat;

  // TR: Nisap aşıldı mı?
  // EN: Is nisab exceeded?
  final bool nisapAsildi;

  // TR: Constructor
  // EN: Constructor
  ZekatSonucu({
    required this.altinVarligi,
    required this.altinZekati,
    required this.gumusVarligi,
    required this.gumusZekati,
    required this.nakitVarligi,
    required this.nakitZekati,
    required this.digerVarliklar,
    required this.digerZekat,
    required this.toplamVarlik,
    required this.toplamZekat,
    required this.nisapAsildi,
  });

  // TR: String gösterimi
  // EN: String representation
  @override
  String toString() {
    return 'ZekatSonucu(toplamVarlik: ${toplamVarlik.toStringAsFixed(2)}, toplamZekat: ${toplamZekat.toStringAsFixed(2)}, nisapAsildi: $nisapAsildi)';
  }
}

/// TR: Zekatmatik Provider - V4 yeniliği
/// EN: Zekatmatik Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
/// TR: V1'den miras alındı
/// EN: Inherited from V1
final zekatmatikProvider = Provider((ref) => ZekatCalculator());
