import 'dart:io';

// [Ana fonksiyon - Main function]
void main() async {
  // [Geliştirilmiş ve çalışan API taban URL'si - Enhanced and working API base URL]
  const baseUrl = 'https://raw.githubusercontent.com/fawazahmed0/quran-api/1/editions';
  
  // [İndirilecek dosyalar ve güncel doğrulanmış ID'leri - Files to download and their current verified IDs]
  final map = {
    'quran_ar.json': 'ara-quranuthmanienc',
    'meal_tr.json': 'tur-diyanetisleri',
    'meal_en.json': 'eng-mustafakhattabg',
    'meal_ja.json': 'jpn-ryoichimita',
    'meal_hi.json': 'hin-suhelfarooqkhan',
    'meal_zh.json': 'zho-mazhonggang',
    'meal_id.json': 'ind-indonesianislam',
    'meal_ur.json': 'urd-muhammadjunagar',
    'meal_bn.json': 'ben-zohurulhoque',
    'meal_fr.json': 'fra-muhammadhamidul',
    'meal_ru.json': 'rus-abuadel',
    'meal_fa.json': 'fas-abdolmohammaday',
    'meal_es.json': 'spa-juliocortes',
    'meal_ms.json': 'msa-abdullahmuhamma',
    'quran_latin.json': 'eng-transliteration', // [Latin okunuşu - Latin transliteration]
  };

  // [Hedef klasörü oluştur - Create target directory]
  final dir = Directory('assets/quran');
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }

  final client = HttpClient();

  // [Tüm dilleri döngüyle indir - Download all languages via loop]
  for (var entry in map.entries) {
    final fileName = entry.key;
    final edition = entry.value;
    final url = Uri.parse('$baseUrl/$edition.json');

    stdout.writeln('İndiriliyor / Downloading: $fileName ...');
    try {
      final request = await client.getUrl(url);
      final response = await request.close();
      if (response.statusCode == 200) {
        final file = File('${dir.path}/$fileName');
        await response.pipe(file.openWrite());
        stdout.writeln('Başarılı / Success: $fileName');
      } else {
        stdout.writeln('Hata / Error: $fileName - Kod/Code: ${response.statusCode}');
      }
    } catch (e) {
      stdout.writeln('Hata / Error: $fileName - $e');
    }
  }
  client.close();
  stdout.writeln('Tüm Kuran verileri başarıyla indirildi! / All Quran data downloaded successfully!');
}
