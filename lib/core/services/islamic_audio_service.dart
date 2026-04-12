import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'quran_service.dart';

enum AudioQuality {
  dataSaver, // 64kbps
  standard, // 128kbps
  highQuality, // 192kbps
}

enum AudioUiState {
  hidden,
  bar,
  bubble,
}

class AudioTrack {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final String? artwork;
  final String? imageUrl;
  final Map<AudioQuality, String> urls;
  final String? audioUrl;
  final Map<String, dynamic>? extras;
  final bool canPlayInBackground;
  final bool isYouTube;
  final String? category;
  final String? arabicName;

  AudioTrack({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.artwork,
    this.imageUrl,
    this.urls = const {},
    this.audioUrl,
    this.extras,
    this.canPlayInBackground = true,
    this.isYouTube = false,
    this.category,
    this.arabicName,
  });

  MediaItem toMediaItem(AudioQuality quality) {
    final String safeId = id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : id;
    final String safeTitle = title.isEmpty ? 'Kubbe Ses' : title;
    final String safeArtist = artist.isEmpty ? 'Bilinmeyen' : artist;

    Uri safetyUri;
    try {
      final String? finalArtwork = imageUrl ?? artwork;
      if (finalArtwork == null || finalArtwork.isEmpty || finalArtwork.contains('qurancdn.com') || finalArtwork.startsWith('asset:')) {
        safetyUri = Uri.parse('https://placehold.co/400x400/4B0082/FFFFFF/png?text=Kubbe');
      } else {
        safetyUri = Uri.parse(finalArtwork);
      }
    } catch (e) {
      safetyUri = Uri.parse('https://placehold.co/400x400/4B0082/FFFFFF/png?text=Kubbe');
    }

    return MediaItem(
      id: safeId,
      title: safeTitle,
      displayTitle: safeTitle,
      displaySubtitle: safeArtist,
      artist: safeArtist,
      album: album ?? 'Kubbe',
      artUri: safetyUri,
      extras: extras,
    );
  }
}

class IslamicAudioService extends ChangeNotifier with WidgetsBindingObserver {
  static final IslamicAudioService _instance = IslamicAudioService._internal();
  factory IslamicAudioService() => _instance;
  static IslamicAudioService get instance => _instance;
  IslamicAudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  AudioQuality _quality = AudioQuality.standard;
  AudioTrack? _currentTrack;
  List<AudioTrack> _playlist = [];
  AudioUiState _uiState = AudioUiState.hidden; 
  final ValueNotifier<bool> isUiVisible = ValueNotifier(true);
  final ValueNotifier<AudioUiState> uiStateNotifier = ValueNotifier(AudioUiState.hidden);
  Timer? _sleepTimer;

  int? _currentAyah;
  int? _activeWordIndex;
  List<Map<String, dynamic>> _wordTimestamps = [];
  List<int> _wordOffsets = []; // [Her ayetin kelime başlangıç ofseti - Word start offset for each ayah]

  final StreamController<int?> _currentAyahController = StreamController<int?>.broadcast();
  final StreamController<int> _scrollRequestController = StreamController<int>.broadcast();
  final StreamController<String> _errorController = StreamController<String>.broadcast();
  final StreamController<int> _wordIndexController = StreamController<int>.broadcast();
  
  int? get currentAyah => _currentAyah;
  int? get currentPlayingAyahId => _currentAyah; // Alias for UI conditional checks - UI kontrolleri için takma ad
  int? get activeWordIndex => _activeWordIndex;
  Stream<int?> get currentAyahStream => _currentAyahController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<int> get scrollRequests => _scrollRequestController.stream;
  Stream<int> get activeWordIndexStream => _wordIndexController.stream;
  AudioPlayer get player => _player;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  AudioQuality get quality => _quality;
  AudioTrack? get currentTrack => _currentTrack;
  List<AudioTrack> get playlist => _playlist;
  AudioUiState get uiState => _uiState;
  List<Map<String, dynamic>> get wordTimestamps => _wordTimestamps;

  /// [Ayetin başlangıç ve bitiş zamanını ms olarak döndür - Get start/end time of verse in ms]
  Map<String, int>? getVerseTiming(int ayahIndex) {
    if (_wordOffsets.isEmpty || ayahIndex >= _wordOffsets.length) return null;
    
    final startWordIdx = _wordOffsets[ayahIndex];
    final endWordIdx = (ayahIndex + 1 < _wordOffsets.length) 
        ? _wordOffsets[ayahIndex + 1] - 1
        : _wordTimestamps.length - 1;

    if (startWordIdx >= _wordTimestamps.length || endWordIdx >= _wordTimestamps.length) return null;

    final startWord = _wordTimestamps[startWordIdx];
    final endWord = _wordTimestamps[endWordIdx];

    final startMs = _ptrans(startWord['timestamp_from'] ?? startWord['audio']?['timestamp_from']);
    final endMs = _ptrans(endWord['timestamp_to'] ?? endWord['audio']?['timestamp_to']);

    return {'start': startMs, 'end': endMs};
  }

  int _ptrans(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    return int.tryParse(val.toString()) ?? 0;
  }

  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    final prefs = await SharedPreferences.getInstance();
    final qualityIndex = prefs.getInt('audio_quality') ?? 1;
    _quality = AudioQuality.values[qualityIndex];

    _player.currentIndexStream.listen((index) {
      if (index != null && index < _playlist.length) {
        _currentTrack = _playlist[index];
        _handleQuranMetadata(_currentTrack!);
        notifyListeners();
      }
    });

    _player.playerStateStream.listen((state) => notifyListeners());
    _player.positionStream.listen((position) => _updateActiveWord(position));
  }

  void setCurrentAyah(int? ayah) {
    _currentAyah = ayah;
    _currentAyahController.add(ayah);
    notifyListeners();
  }

  void setWordTimestamps(List<Map<String, dynamic>> timestamps, List<int> offsets) {
    _wordTimestamps = timestamps;
    _wordOffsets = offsets;
    _activeWordIndex = null;
    notifyListeners();
  }

  void _updateActiveWord(Duration position) {
    if (_wordTimestamps.isEmpty) return;
    int newIndex = -1;
    final ms = position.inMilliseconds;

    // Saniyenin binde biri (ms) hassasiyetinde kelimeyi bul - Find word with ms precision
    for (int i = 0; i < _wordTimestamps.length; i++) {
        final word = _wordTimestamps[i];
        
        // [Hassas zamanlama verilerini ayıkla - Extract precise timing data]
        dynamic timestampFrom = word['timestamp_from'];
        dynamic timestampTo = word['timestamp_to'];
        
        if (timestampFrom == null && word['audio'] != null) {
          timestampFrom = word['audio']['timestamp_from'];
          timestampTo = word['audio']['timestamp_to'];
        }

        if (timestampFrom != null && timestampTo != null) {
          final int from = (timestampFrom is int) ? timestampFrom : int.tryParse(timestampFrom.toString()) ?? 0;
          final int to = (timestampTo is int) ? timestampTo : int.tryParse(timestampTo.toString()) ?? 0;

          if (ms >= from && ms <= to) {
              newIndex = i;
              break;
          }
        }
    }

    if (newIndex != -1 && newIndex != _activeWordIndex) {
      _activeWordIndex = newIndex;
      
      // [Kelime indeksinden ayet indeksini bul - Find ayah index from word index]
      int newAyah = -1;
      for (int i = 0; i < _wordOffsets.length; i++) {
        if (_activeWordIndex! >= _wordOffsets[i]) {
          newAyah = i + 1; // 1-based index
        } else {
          break;
        }
      }

      if (newAyah != -1 && newAyah != _currentAyah) {
        _currentAyah = newAyah;
        _currentAyahController.add(_currentAyah);
      }
      
      _wordIndexController.add(_activeWordIndex!);
      notifyListeners();
    }
  }

  // [Global kelime indeksini yerel ayet indeksine dönüştür - Map global word index to local ayah index]
  int getLocalWordIndex(int ayahIndex) {
    if (_activeWordIndex == null || _wordOffsets.isEmpty || ayahIndex >= _wordOffsets.length) return -1;
    
    final start = _wordOffsets[ayahIndex];
    final end = (ayahIndex + 1 < _wordOffsets.length) ? _wordOffsets[ayahIndex + 1] : _wordTimestamps.length;
    
    if (_activeWordIndex! >= start && _activeWordIndex! < end) {
      return _activeWordIndex! - start;
    }
    return -1;
  }

  void _handleQuranMetadata(AudioTrack track) {
    if (track.extras?['is_quran'] == true) {
      final surahId = track.extras?['surah_id'];
      if (surahId != null) {
        QuranService.fetchVerseWords(surahId).then((versesRaw) {
          final verses = versesRaw.map((v) => Map<String, dynamic>.from(v)).toList(); // Safe map casting - Güvenli harita dönüştürme
          if (verses.isNotEmpty) {
            List<Map<String, dynamic>> allSurahWords = [];
            List<int> offsets = [];
            int currentOffset = 0;

            for (var verse in verses) {
              offsets.add(currentOffset);
              if (verse['words'] != null) {
                final words = List<Map<String, dynamic>>.from(verse['words'].map((w) => Map<String, dynamic>.from(w))); // Deep safe cast - Derinlemesine güvenli dönüştürme
                allSurahWords.addAll(words);
                currentOffset += words.length;
              }
            }
            setWordTimestamps(allSurahWords, offsets);
          }
        }).catchError((e) {
          debugPrint("Quran metadata error: $e");
          return null;
        });
      }
    } else {
      _currentAyah = null;
      _currentAyahController.add(null);
      _activeWordIndex = null;
      _wordTimestamps = [];
    }
  }

  Future<void> play(AudioTrack track, {Duration? position}) async {
    if (track.audioUrl == null || track.audioUrl!.isEmpty || track.audioUrl == 'null') {
      _errorController.add("Ses kaynağı bulunamadı.");
      return;
    }

    try {
      _currentTrack = track;
      _uiState = AudioUiState.bar;
      uiStateNotifier.value = AudioUiState.bar;
      _handleQuranMetadata(track);
      notifyListeners();

      final audioSource = AudioSource.uri(
        Uri.parse(track.audioUrl!),
        tag: track.toMediaItem(_quality),
      );

      await _player.stop();
      await _player.setAudioSource(audioSource, initialPosition: position);
      await _player.play();
    } catch (e) {
      _errorController.add("Hata: $e");
    }
  }

  Future<void> playTrack(AudioTrack track, {Duration? position}) => play(track, position: position);

  Future<void> setPlaylist(List<AudioTrack> tracks, {int initialIndex = 0}) async {
    _playlist = tracks;
    _currentTrack = tracks[initialIndex];
    try {
      final sources = tracks.map((t) => AudioSource.uri(Uri.parse(t.audioUrl ?? ''), tag: t.toMediaItem(_quality))).toList();
      await _player.setAudioSource(ConcatenatingAudioSource(children: sources), initialIndex: initialIndex);
      await _player.play();
      _uiState = AudioUiState.bar;
      uiStateNotifier.value = AudioUiState.bar;
      notifyListeners();
    } catch (e) {
        debugPrint("Playlist error: $e");
    }
  }

  void togglePlayPause() {
    if (_player.playing) _player.pause(); else _player.play();
    notifyListeners();
  }

  void pause() {
    _player.pause();
    notifyListeners();
  }

  void stop() {
    _player.stop();
    _currentTrack = null;
    _uiState = AudioUiState.hidden;
    uiStateNotifier.value = AudioUiState.hidden;
    notifyListeners();
  }

  void skipToNext() => _player.hasNext ? _player.seekToNext() : null;
  void skipToPrevious() => _player.hasPrevious ? _player.seekToPrevious() : null;

  // [Ayet Seviyesi Gezintisi - Ayah Level Navigation]
  Future<void> nextAyah() async {
    if (_currentAyah == null || _wordOffsets.isEmpty) return;
    final totalAyahs = _wordOffsets.length;
    if (_currentAyah! < totalAyahs) {
        final timing = getVerseTiming(_currentAyah!); // [Bir sonraki ayet - Next ayah index is currentAyah! because it's 1-based]
        if (timing != null) {
            await _player.seek(Duration(milliseconds: timing['start']!));
            _currentAyah = _currentAyah! + 1; // [Manuel indeks güncelle - Manual index update]
            _currentAyahController.add(_currentAyah!);
            notifyListeners(); // [UI'ı güncellemeye zorla - Force UI update]
        }
    } else {
        skipToNext();
    }
  }

  Future<void> previousAyah() async {
    if (_currentAyah == null || _wordOffsets.isEmpty) return;
    if (_currentAyah! > 1) {
        final timing = getVerseTiming(_currentAyah! - 2); // [Önceki ayet - Previous ayah]
        if (timing != null) {
            await _player.seek(Duration(milliseconds: timing['start']!));
            _currentAyah = _currentAyah! - 1; // [Manuel indeks güncelle - Manual index update]
            _currentAyahController.add(_currentAyah!);
            notifyListeners(); // [UI'ı güncellemeye zorla - Force UI update]
        }
    } else {
        skipToPrevious();
    }
  }

  // [Sure Seviyesi Gezintisi - Surah Level Navigation]
  void nextSurah() => skipToNext();
  void previousSurah() => skipToPrevious();

  // [Aliases for requested naming - İstenen isimler için takma adlar]
  Future<void> skipToNextAyah() => nextAyah();
  Future<void> skipToPreviousAyah() => previousAyah();
  void skipToNextSurah() => nextSurah();
  void skipToPreviousSurah() => previousSurah();

  Future<void> setQuality(AudioQuality quality) async {
    _quality = quality;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('audio_quality', quality.index);
    if (_player.playing && _currentTrack != null) play(_currentTrack!, position: _player.position);
    notifyListeners();
  }

  void startSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    if (minutes > 0) _sleepTimer = Timer(Duration(minutes: minutes), () => pause());
  }

  void setUiState(AudioUiState state) {
    _uiState = state;
    uiStateNotifier.value = state;
    notifyListeners();
  }

  // [10 saniye ileri/geri sar - Skip 10 seconds forward/backward]
  Future<void> seek10s(bool forward) async {
    final currentPos = _player.position;
    final duration = _player.duration ?? Duration.zero;
    final skip = const Duration(seconds: 10);
    
    Duration targetPos;
    if (forward) {
      targetPos = currentPos + skip;
      if (targetPos > duration) targetPos = duration;
    } else {
      targetPos = currentPos - skip;
      if (targetPos < Duration.zero) targetPos = Duration.zero;
    }
    
    await _player.seek(targetPos);
  }

  void requestScrollToAyah(int ayah) => _scrollRequestController.add(ayah);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _currentTrack != null && !_currentTrack!.canPlayInBackground) {
      _player.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollRequestController.close();
    _currentAyahController.close();
    _errorController.close();
    _wordIndexController.close();
    super.dispose();
  }
}
