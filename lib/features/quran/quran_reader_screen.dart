// TR: KUBBE V4 Quran Reader Screen - V1'den miras alındı
// EN: KUBBE V4 Quran Reader Screen - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Elite okuma deneyimi. V1'deki sesli dinleme (just_audio) mantığını buraya bağla
// EN: Elite reading experience. Connect V1's audio listening (just_audio) logic here

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/theme/app_theme.dart';
import '../../core/storage/preferences_manager.dart';
import '../../core/models/surah.dart';

/// TR: KUBBE V4 Quran Reader Screen Sınıfı
/// EN: KUBBE V4 Quran Reader Screen Class
/// TR: V1'deki Kur'an okuma mantığı modernize edildi
/// EN: Modernized V1's Quran reading logic
/// TR: Elite okuma deneyimi ve sesli dinleme
/// EN: Elite reading experience and audio listening
/// TR: just_audio entegrasyonu ve ses kontrolü
/// EN: just_audio integration and audio control
/// TR: V1'den miras alınan mantık V4 estetiğiyle modernize edildi
/// EN: Logic inherited from V1 modernized with V4 aesthetics
class QuranReaderScreen extends ConsumerStatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const QuranReaderScreen({super.key, required this.surah});

  // TR: Sure
  // EN: Surah
  final Surah surah;

  @override
  ConsumerState<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

// TR: Quran Reader Screen State
// EN: Quran Reader Screen State
class _QuranReaderScreenState extends ConsumerState<QuranReaderScreen> {
  // TR: Audio player
  // EN: Audio player
  AudioPlayer? _audioPlayer;

  // TR: Scroll controller
  // EN: Scroll controller
  final ScrollController _scrollController = ScrollController();

  // TR: Font boyutu
  // EN: Font size
  double _fontSize = 20.0;

  // TR: Ses durumu
  // EN: Audio state
  bool _isPlaying = false;

  // TR: Mevcut pozisyonu
  // EN: Playback position
  Duration _position = Duration.zero;

  // TR: Mevcut hızı
  // EN: Playback speed
  // ignore: unused_field
  double _playbackSpeed = 1.0;

  // TR: Ses süresi
  // EN: Audio duration
  Duration _duration = Duration.zero;

  // TR: Gece modu
  // EN: Night mode
  bool _isNightMode = false;

  // TR: Tekrar modu
  // EN: Repeat mode
  bool _isRepeat = false;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
    _loadSettings();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // TR: Audio player'ı başlat
  // EN: Initialize audio player
  void _initializeAudioPlayer() {
    _audioPlayer = AudioPlayer();

    // TR: Audio listener'ları ayarla
    // EN: Set up audio listeners
    _audioPlayer!.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer!.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    _audioPlayer!.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  // TR: Ayarları yükle
  // EN: Load settings
  void _loadSettings() {
    final preferences = ref.read(preferencesStateProvider);
    setState(() {
      _fontSize = preferences.fontSize;
      _isNightMode = preferences.isDarkMode;
    });
  }

  // TR: Ses oynat/durdur
  // EN: Play/pause audio
  void _toggleAudio() {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    if (_isPlaying) {
      _audioPlayer?.pause();
    } else {
      _audioPlayer?.play();
    }
  }

  // TR: Sıfırla
  // EN: Reset
  void _resetAudio() {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    _audioPlayer?.seek(Duration.zero);
  }

  // TR: Tekrar aç/kapat
  // EN: Toggle repeat
  void _toggleRepeat() {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _isRepeat = !_isRepeat;
    });

    // TR: Tekrar ayarı
    // EN: Set repeat
    _audioPlayer?.setLoopMode(_isRepeat ? LoopMode.one : LoopMode.off);
  }

  // TR: Hızı ayarla
  // EN: Set speed
  void _setPlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });

    _audioPlayer?.setSpeed(speed);
  }

  // TR: Font boyutunu ayarla
  // EN: Set font size
  Future<void> _setFontSize(double size) async {
    setState(() {
      _fontSize = size;
    });

    // TR: Preferences'e kaydet
    // EN: Save to preferences
    final prefsManager = PreferencesManager();
    await prefsManager.setFontSize(size);
  }

  // TR: Gece modunu aç/kapat
  // EN: Toggle night mode
  Future<void> _toggleNightMode() async {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _isNightMode = !_isNightMode;
    });

    // TR: Preferences'e kaydet
    // EN: Save to preferences
    final prefsManager = PreferencesManager();
    await prefsManager
        .setThemeMode(_isNightMode ? ThemeMode.dark : ThemeMode.light);
  }

  // TR: Format zaman
  // EN: Format time
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TR: Sure adı
            // EN: Surah name
            Text(
              widget.surah.name,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),

            // TR: Bilgi
            // EN: Info
            Text(
              'Sure ${widget.surah.id} • ${widget.surah.verses.length} ayet',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        // TR: Arka plan
        // EN: Background
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // TR: Gölge kaldır
        // EN: Remove shadow
        elevation: 0,
        // TR: Eylemler
        // EN: Actions
        actions: [
          // TR: Gece modu butonu
          // EN: Night mode button
          IconButton(
            onPressed: _toggleNightMode,
            icon: Icon(
              _isNightMode ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).iconTheme.color,
            ),
          ),

          // TR: Font ayarları
          // EN: Font settings
          PopupMenuButton<String>(
            icon: Icon(
              Icons.text_fields,
              color: Theme.of(context).iconTheme.color,
            ),
            // TR: Menü öğeleri
            // EN: Menu items
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'small',
                // TR: Küçük font
                // EN: Small font
                child: Text(
                  'Küçük Font',
                  style: GoogleFonts.inter(fontSize: 14),
                ),
              ),
              PopupMenuItem(
                value: 'medium',
                // TR: Orta font
                // EN: Medium font
                child: Text(
                  'Orta Font',
                  style: GoogleFonts.inter(fontSize: 14),
                ),
              ),
              PopupMenuItem(
                value: 'large',
                // TR: Büyük font
                // EN: Large font
                child: Center(
                  child: Text(
                    'Büyük Font',
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'extra_large',
                // TR: Çok büyük font
                // EN: Extra large font
                child: Text(
                  'Çok Büyük Font',
                  style: GoogleFonts.inter(fontSize: 14),
                ),
              ),
            ],
            // TR: Seçim
            // EN: Selection
            onSelected: (value) {
              switch (value) {
                case 'small':
                  _setFontSize(16.0);
                  break;
                case 'medium':
                  _setFontSize(20.0);
                  break;
                case 'large':
                  _setFontSize(24.0);
                  break;
                case 'extra_large':
                  _setFontSize(28.0);
                  break;
              }
            },
          ),

          // TR: Mushaf seçici
          // EN: Mushaf picker
          IconButton(
            onPressed: () {
              // TR: Mushaf picker'ı göster
              // EN: Show mushaf picker
              _showMushafPicker();
            },
            icon: Icon(
              Icons.auto_stories,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),

      // TR: Body
      // EN: Body
      body: Container(
        decoration: BoxDecoration(
          // TR: Gradient arka plan
          // EN: Gradient background
          gradient: LinearGradient(
            colors: _isNightMode
                ? [
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2C2C2C),
                  ]
                : [
                    const Color(0xFFF5F5F5),
                    const Color(0xFFE8E8E8),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // TR: İçerik
        // EN: Content
        child: Column(
          children: [
            // TR: Ses kontrol paneli
            // EN: Audio control panel
            _buildAudioControls(),

            // TR: Kur'an metni
            // EN: Quran text
            Expanded(
              child: _buildQuranText(),
            ),

            // TR: Gece modu overlay
            // EN: Night mode overlay
            if (_isNightMode)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: 0.3),
              ),
          ],
        ),
      ),
    );
  }

  // TR: Ses kontrol paneli oluştur
  // EN: Build audio control panel
  Widget _buildAudioControls() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // TR: 32dp radius - Sy-OS standartı
        // EN: 32dp radius - Sy-OS standard
        borderRadius: BorderRadius.circular(32.0),
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withValues(alpha: 0.95),
          ],
        ),
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      // TR: Kontrol içeriği
      // EN: Control content
      child: Column(
        children: [
          // TR: Süre göstergesi
          // EN: Progress bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              // TR: 2dp radius
              // EN: 2dp radius
              borderRadius: BorderRadius.circular(2.0),
              // TR: Gradient arka plan
              // EN: Gradient background
              gradient: LinearGradient(
                colors: [
                  KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                  KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
                ],
              ),
            ),
            // TR: Süre göstergesi
            // EN: Progress indicator
            child: LinearProgressIndicator(
              value: _duration.inSeconds > 0
                  ? _position.inSeconds / _duration.inSeconds
                  : 0.0,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                KubbeTheme.kubbeIndigo,
              ),
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 16.0),

          // TR: Zaman ve kontrol satırı
          // EN: Time and control row
          Row(
            children: [
              // TR: Zaman bilgisi
              // EN: Time information
              Expanded(
                // TR: Zaman metni
                // EN: Time text
                child: Center(
                  child: Text(
                    '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // TR: Hız kontrolü
              // EN: Speed control
              Row(
                children: [
                  // TR: 0.5x butonu
                  // EN: 0.5x button
                  GestureDetector(
                    onTap: () => _setPlaybackSpeed(0.5),
                    // TR: Buton
                    // EN: Button
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        // TR: Yuvarlak
                        // EN: Circle
                        shape: BoxShape.circle,
                        // TR: Gradient arka plan
                        // EN: Gradient background
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.withValues(alpha: 0.3),
                            Colors.grey.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      // TR: İkon
                      // EN: Icon
                      child: Center(
                        child: Text(
                          '0.5x',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // TR: 1x butonu
                  // EN: 1x button
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _setPlaybackSpeed(1.0),
                    // TR: Buton
                    // EN: Button
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        // TR: Yuvarlak
                        // EN: Circle
                        shape: BoxShape.circle,
                        // TR: Gradient arka plan
                        // EN: Gradient background
                        gradient: LinearGradient(
                          colors: [
                            KubbeTheme.kubbeIndigo,
                            KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      // TR: İkon
                      // EN: Icon
                      child: Center(
                        child: Text(
                          '1x',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // TR: 1.5x butonu
                  // EN: 1.5x button
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _setPlaybackSpeed(1.5),
                    // TR: Buton
                    // EN: Button
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        // TR: Yuvarlak
                        // EN: Circle
                        shape: BoxShape.circle,
                        // TR: Gradient arka plan
                        // EN: Gradient background
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.withValues(alpha: 0.3),
                            Colors.grey.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      // TR: İkon
                      // EN: Icon
                      child: Center(
                        child: Text(
                          '1.5x',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // TR: Kontrol butonları
              // EN: Control buttons
              Row(
                children: [
                  // TR: Sıfırla butonu
                  // EN: Reset button
                  GestureDetector(
                    onTap: _resetAudio,
                    // TR: Buton
                    // EN: Button
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        // TR: Yuvarlak
                        // EN: Circle
                        shape: BoxShape.circle,
                        // TR: Gradient arka plan
                        // EN: Gradient background
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.withValues(alpha: 0.3),
                            Colors.grey.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      // TR: İkon
                      // EN: Icon
                      child: const Center(
                        child: Icon(
                          Icons.refresh,
                          size: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(width: 8),

                  // TR: Tekrar butonu
                  // EN: Repeat button
                  GestureDetector(
                    onTap: _toggleRepeat,
                    // TR: Buton
                    // EN: Button
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        // TR: Yuvarlak
                        // EN: Circle
                        shape: BoxShape.circle,
                        // TR: Gradient arka plan
                        // EN: Gradient background
                        gradient: _isRepeat
                            ? LinearGradient(
                                colors: [
                                  KubbeTheme.kubbeIndigo,
                                  KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.grey.withValues(alpha: 0.3),
                                  Colors.grey.withValues(alpha: 0.1),
                                ],
                              ),
                      ),
                      // TR: İkon
                      // EN: Icon
                      child: Center(
                        child: Icon(
                          _isRepeat ? Icons.repeat : Icons.repeat_one,
                          size: 16,
                          color: _isRepeat ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  // TR: Boşluk
                  // EN: Spacer
                  const SizedBox(width: 8),

                  // TR: Oynat/durdur butonu
                  // EN: Play/pause button
                  GestureDetector(
                    onTap: _toggleAudio,
                    // TR: Buton
                    // EN: Button
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        // TR: Yuvarlak
                        // EN: Circle
                        shape: BoxShape.circle,
                        // TR: Gradient arka plan
                        // EN: Gradient background
                        gradient: LinearGradient(
                          colors: [
                            KubbeTheme.kubbeIndigo,
                            KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                          ],
                        ),
                        // TR: Gölge
                        // EN: Shadow
                        boxShadow: [
                          BoxShadow(
                            color:
                                KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                            blurRadius: 8.0,
                            offset: const Offset(0, 2),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      // TR: İkon
                      // EN: Icon
                      child: Center(
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TR: Kur'an metni oluştur
  // EN: Build Quran text
  Widget _buildQuranText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // TR: 32dp radius - Sy-OS standartı
        // EN: 32dp radius - Sy-OS standard
        borderRadius: BorderRadius.circular(32.0),
        // TR: Gradient arka plan
        // EN: Gradient background
        gradient: LinearGradient(
          colors: _isNightMode
              ? [
                  const Color(0xFF2C2C2C),
                  const Color(0xFF1A1A1A),
                ]
              : [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.95),
                ],
        ),
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      // TR: Metin içeriği
      // EN: Text content
      child: SingleChildScrollView(
        controller: _scrollController,
        // TR: Demo metin
        // EN: Demo text
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TR: Bismillah
            // EN: Bismillah
            Text(
              'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
              style: GoogleFonts.inter(
                fontSize: _fontSize + 4,
                fontWeight: FontWeight.bold,
                color: _isNightMode ? Colors.white : Colors.black87,
                height: 2.0,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.right,
            ),

            // TR: Sure başlığı
            // EN: Surah header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              // TR: Başlık metni
              // EN: Header text
              child: Text(
                widget.surah.name,
                style: GoogleFonts.inter(
                  fontSize: _fontSize + 2,
                  fontWeight: FontWeight.bold,
                  color: _isNightMode ? Colors.white : Colors.black87,
                  height: 2.0,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // TR: Demo ayetler
            // EN: Demo verses
            ...List.generate(widget.surah.verses.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                // TR: Ayet numarası
                // EN: Verse number
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TR: Ayet numarası
                    // EN: Verse number
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        // TR: 16dp radius
                        // EN: 16dp radius
                        borderRadius: BorderRadius.circular(16.0),
                        // TR: Gradient arka plan
                        // EN: Gradient background
                        gradient: LinearGradient(
                          colors: [
                            KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
                            KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      // TR: Ayet numarası metni
                      // EN: Verse number text
                      child: Text(
                        'Ayet ${index + 1}',
                        style: GoogleFonts.inter(
                          fontSize: _fontSize - 2,
                          fontWeight: FontWeight.w600,
                          color: KubbeTheme.kubbeIndigo,
                        ),
                      ),
                    ),

                    // TR: Ayet metni
                    // EN: Verse text
                    Text(
                      // TR: Demo ayet metni
                      // EN: Demo verse text
                      index == 0
                          ? 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ'
                          : index == 1
                              ? 'الرَّحْمَنِ الرَّحِيمِ'
                              : index == 2
                                  ? 'مَالِكِ يَوْمِ الدِّينِ'
                                  : index == 3
                                      ? 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ'
                                      : 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
                      style: GoogleFonts.inter(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.normal,
                        color: _isNightMode ? Colors.white : Colors.black87,
                        height: 2.0,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // TR: Mushaf picker göster
  // EN: Show mushaf picker
  void _showMushafPicker() {
    showModalBottomSheet(
      context: context,
      // TR: Arka plan
      // EN: Background
      backgroundColor: Colors.transparent,
      // TR: Builder
      // EN: Builder
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            // TR: 32dp radius üst köşeler
            // EN: 32dp radius top corners
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withValues(alpha: 0.95),
              ],
            ),
          ),
          // TR: İçerik
          // EN: Content
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TR: Başlık
              // EN: Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                // TR: Başlık metni
                // EN: Header text
                child: Text(
                  'Yazı Tipi Seçimi',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: KubbeTheme.kubbeIndigo,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // TR: Yazı tipleri listesi
              // EN: Font types list
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                // TR: Yazı tipi seçenekleri
                // EN: Font type options
                children: [
                  _buildMushafOption(
                    'Hüsrev Hattı',
                    'Klasik Osmanlı yazı stili',
                    'assets/fonts/husrev.ttf',
                  ),
                  _buildMushafOption(
                    'Medine Hattı',
                    'Modern ve okunaklı yazı stili',
                    'assets/fonts/medine.ttf',
                  ),
                  _buildMushafOption(
                    'Naskh',
                    'Kufi yazı stili',
                    'assets/fonts/naskh.ttf',
                  ),
                  _buildMushafOption(
                    'Thuluth',
                    'Arapça kaligrafi stili',
                    'assets/fonts/thuluth.ttf',
                  ),
                  _buildMushafOption(
                    'Uthmani',
                    'Modern Arapça yazı stili',
                    'assets/fonts/uthmani.ttf',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // TR: Mushaf seçeneği oluştur
  // EN: Build mushaf option
  Widget _buildMushafOption(String title, String description, String fontPath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      // TR: Seçenek
      // EN: Option
      child: GestureDetector(
        onTap: () {
          // TR: Haptic feedback
          // EN: Haptic feedback
          HapticFeedback.lightImpact();

          // TR: Modal'ı kapat
          // EN: Close modal
          Navigator.of(context).pop();

          // TR: Font ayarı
          // EN: Font setting
          // Font değiştirme mantığı
        },
        // TR: Seçenek container
        // EN: Option container
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            // TR: 16dp radius
            // EN: 16dp radius
            borderRadius: BorderRadius.circular(16.0),
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: LinearGradient(
              colors: [
                KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
                KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
              ],
            ),
            // TR: Kenar
            // EN: Border
            border: Border.all(
              color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          // TR: Seçenek içeriği
          // EN: Option content
          child: Row(
            children: [
              // TR: İkon
              // EN: Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  // TR: Yuvarlak
                  // EN: Circle
                  shape: BoxShape.circle,
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: LinearGradient(
                    colors: [
                      KubbeTheme.kubbeIndigo,
                      KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                // TR: İkon içeriği
                // EN: Icon content
                child: const Center(
                  child: Icon(
                    Icons.text_fields,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(width: 16.0),

              // TR: Metin
              // EN: Text
              Expanded(
                // TR: Metin içeriği
                // EN: Text content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TR: Başlık
                    // EN: Title
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: KubbeTheme.kubbeIndigo,
                      ),
                    ),

                    // TR: Açıklama
                    // EN: Description
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
