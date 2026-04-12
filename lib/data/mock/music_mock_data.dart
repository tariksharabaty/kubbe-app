import '../../core/services/islamic_audio_service.dart';

/// [MusicMockData] Kubbe Müzik için gerçek ve zengin veriler - Real and rich data for Kubbe Music
class MusicMockData {
  // [Bilingual Comments: Türkçe açıklama - English explanation]

  /// Müzik kategorileri - Music categories
  static final List<String> categories = [
    'Haftanın Popülerleri', // Popular of the Week
    'Zikirler', // Dhikrs
    'İlahiler', // Nasheeds
    'Tasavvuf Müzikleri', // Sufi Music
    'Huzur Veren Kur\'an', // Melodic Quran
  ];

  /// [fullTracks] YT Music tarzı zengin ve güvenilir veri seti - Rich and reliable dataset in YT Music style
  static final List<AudioTrack> fullTracks = [
    // --- KARIŞIK / ÖNERİLENLER ---
    AudioTrack(id: '1', title: 'Hasbi Rabbi', artist: 'Sami Yusuf', category: 'İlahi', artwork: 'https://images.unsplash.com/photo-1584551246679-0daf3d275d0f?auto=format&fit=crop&w=300', urls: {AudioQuality.standard: 'https://server8.mp3quran.net/afs/001.mp3'}, isYouTube: false),
    AudioTrack(id: '2', title: 'Ya Mustafa', artist: 'Maher Zain', category: 'İlahi', artwork: 'https://images.unsplash.com/photo-1564121211835-e88c852648ab?auto=format&fit=crop&w=300', urls: {AudioQuality.standard: 'https://server8.mp3quran.net/afs/002.mp3'}, isYouTube: false),
    
    // --- ZİKİRLER ---
    AudioTrack(id: '3', title: 'Subhanallah', artist: 'Huzur Zikri', category: 'Zikir', artwork: 'https://images.unsplash.com/photo-1542816417-0983c9c9ad53?auto=format&fit=crop&w=300', urls: {AudioQuality.standard: 'https://server8.mp3quran.net/afs/003.mp3'}, isYouTube: false),
    AudioTrack(id: '4', title: 'Elhamdülillah', artist: 'Sabah Zikri', category: 'Zikir', artwork: 'https://images.unsplash.com/photo-1519817650390-64a93db51149?auto=format&fit=crop&w=300', urls: {AudioQuality.standard: 'https://server8.mp3quran.net/afs/004.mp3'}, isYouTube: false),
    AudioTrack(id: '5', title: 'Allahu Ekber', artist: 'Toplu Zikir', category: 'Zikir', artwork: 'https://images.unsplash.com/photo-1604085572504-a392ddf0d86a?auto=format&fit=crop&w=300', urls: {AudioQuality.standard: 'https://server8.mp3quran.net/afs/005.mp3'}, isYouTube: false),

    // --- KUR'AN TİLAVETİ ---
    AudioTrack(id: '6', title: 'Yasin Suresi', artist: 'Mishary Rashid', category: 'Kur\'an', artwork: 'https://images.unsplash.com/photo-1576766125468-b5cbbf2032ee?auto=format&fit=crop&w=300', urls: {AudioQuality.standard: 'https://server8.mp3quran.net/afs/036.mp3'}, isYouTube: false),
    AudioTrack(id: '7', title: 'Rahman Suresi', artist: 'Mishary Rashid', category: 'Kur\'an', artwork: 'https://images.unsplash.com/photo-1585036156171-384164a8c675?auto=format&fit=crop&w=300', urls: {AudioQuality.standard: 'https://server8.mp3quran.net/afs/055.mp3'}, isYouTube: false),
    AudioTrack(id: '8', title: 'Mülk Suresi', artist: 'Mishary Rashid', category: 'Kur\'an', artwork: 'https://images.unsplash.com/photo-1609599006353-e629aaab21ce?auto=format&fit=crop&w=300', urls: {AudioQuality.standard: 'https://server8.mp3quran.net/afs/067.mp3'}, isYouTube: false),
  ];

  /// Mock parçalar - Mock tracks
  static List<AudioTrack> getMockTracks(String category) {
    String searchCat = category;
    if (category == 'İlahiler') searchCat = 'İlahi';
    if (category == 'Zikirler') searchCat = 'Zikir';
    if (category == 'Huzur Veren Kur\'an') searchCat = 'Kur\'an';

    final filtered = fullTracks.where((t) => t.category == searchCat).toList();
    
    return filtered.isNotEmpty ? filtered : fullTracks;
  }
}
