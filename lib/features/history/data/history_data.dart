import 'package:flutter/material.dart';

// [Kategori Modeli - Category Model]
class HistoryCategory {
  final String id;
  final String name;
  final IconData icon;

  HistoryCategory({required this.id, required this.name, required this.icon});
}

// [Tarih Öğesi Modeli - History Item Model]
class HistoryItem {
  final String id;
  final String categoryId;
  final String title;
  final String subtitle;
  final String biography;
  final List<String> achievements;
  final List<String> quotes;
  final Color themeColor;
  final IconData icon;

  HistoryItem({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.subtitle,
    required this.biography,
    required this.achievements,
    required this.quotes,
    this.themeColor = const Color(0xFFD4AF37),
    required this.icon,
  });
}

// [Kategoriler Listesi - Categories List]
final List<HistoryCategory> historyCategories = [
  HistoryCategory(id: "sultans", name: "Padişahlar", icon: Icons.account_balance_rounded),
  HistoryCategory(id: "scholars", name: "Alimler", icon: Icons.menu_book_rounded),
  HistoryCategory(id: "civilizations", name: "Medeniyetler", icon: Icons.fort_rounded),
  HistoryCategory(id: "leaders", name: "Büyük Liderler", icon: Icons.shield_rounded),
];

// [Tarih Öğeleri Verisi - History Items Data]
final List<HistoryItem> historyItems = [
  // --- PADİŞAHLAR ---
  HistoryItem(
    id: "fatih",
    categoryId: "sultans",
    title: "Fatih Sultan Mehmed",
    subtitle: "İstanbul'un Fatihi",
    biography: "Çağ açıp çağ kapatan padişah, İstanbul'un fatihi ve bilim aşığı bir devlet adamıdır.",
    achievements: ["İstanbul'un Fethi (1453)", "Sahn-ı Seman Medreseleri", "Fatih Kanunnamesi"],
    quotes: ["Ya İstanbul beni alır, ya ben İstanbul'u!"],
    icon: Icons.castle_rounded,
    themeColor: const Color(0xFF795548),
  ),
  HistoryItem(
    id: "abdulhamid",
    categoryId: "sultans",
    title: "II. Abdülhamid",
    subtitle: "Ulu Hakan",
    biography: "Siyasi dehasıyla 33 yıl imparatorluğu ayakta tutan dirayetli lider.",
    achievements: ["Hicaz Demiryolu", "Eğitim Reformları", "Yıldız İstihbarat Teşkilatı"],
    quotes: ["Hak arayan varsa hakkını verin, baş kaldıran varsa başını kesin!"],
    icon: Icons.account_balance_rounded,
    themeColor: const Color(0xFF4B0082),
  ),
  
  // --- ALİMLER ---
  HistoryItem(
    id: "gazali",
    categoryId: "scholars",
    title: "İmam Gazali",
    subtitle: "Huccetü'l İslam",
    biography: "İslam dünyasının en büyük mütefekkirlerinden biri, felsefe ve kelam üstadıdır.",
    achievements: ["İhyâu Ulûmiddîn Eseri", "Nizamiye Medreseleri Başmüderrisliği", "Bâtınîlik ile Fikri Mücadele"],
    quotes: ["Bil ki; her hastalık zıddıyla tedavi edilir."],
    icon: Icons.menu_book_rounded,
    themeColor: const Color(0xFF4CAF50),
  ),

  // --- MEDENİYETLER ---
  HistoryItem(
    id: "abbasids",
    categoryId: "civilizations",
    title: "Abbasiler",
    subtitle: "Bilgelik Çağı",
    biography: "İslam'ın altın çağını yaşatan, bilim ve sanatın merkezi olan büyük medeniyet.",
    achievements: ["Beytü'l Hikme'nin Kurulması", "Astronomi ve Kimyada Atılımlar", "Bağdat'ın Bilim Merkezi Oluşu"],
    quotes: ["Bilgi, paylaşıldıkça çoğalan tek hazinedir."],
    icon: Icons.fort_rounded,
    themeColor: const Color(0xFF009688),
  ),

  // --- LİDERLER ---
  HistoryItem(
    id: "saladin",
    categoryId: "leaders",
    title: "Selahaddin Eyyubi",
    subtitle: "Kudüs Fatihi",
    biography: "Hıttin Savaşı ile Kudüs'ü Haçlılardan geri alan, adaleti ve merhametiyle tanınan komutan.",
    achievements: ["Kudüs'ün Fethi (1187)", "Hıttin Zaferi", "Eyyubi Devleti'nin Kurulması"],
    quotes: ["Kudüs işgal altındayken ben nasıl gülebilirim?"],
    icon: Icons.shield_rounded,
    themeColor: const Color(0xFFF44336),
  ),
];
