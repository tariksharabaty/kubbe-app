import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:ui'; // Bulanıklaştırma işlemleri için - For blurring operations
import 'package:palette_generator/palette_generator.dart'; // Renk paleti oluşturma - Palette generation
import '../../../core/services/islamic_audio_service.dart';

/// [FullAudioPlayerScreen] Tam ekran gelişmiş oynatıcı - Full screen advanced player
class FullAudioPlayerScreen extends StatefulWidget {
  const FullAudioPlayerScreen({super.key});

  @override
  State<FullAudioPlayerScreen> createState() => _FullAudioPlayerScreenState();
}

class _FullAudioPlayerScreenState extends State<FullAudioPlayerScreen> {
  PaletteGenerator? _paletteGenerator;

  // [Bilingual Comments: Türkçe açıklama - English explanation]

  @override
  void initState() {
    super.initState();
    _updatePalette();
  }

  /// Görselden renk paleti oluşturur - Generates color palette from image
  Future<void> _updatePalette() async {
    final audioService = IslamicAudioService();
    final track = audioService.currentTrack;
    if (track?.artwork != null) {
      final palette = await PaletteGenerator.fromImageProvider(
        NetworkImage(track!.artwork!),
        maximumColorCount: 10,
      );
      if (mounted) {
        setState(() => _paletteGenerator = palette);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioService = IslamicAudioService();
    final track = audioService.currentTrack;

    if (track == null) return const SizedBox.shrink();

    // [Baskın rengi belirle - Determine dominant color]
    final Color dominantColor = _paletteGenerator?.dominantColor?.color ?? theme.colorScheme.primaryContainer;
    final Color bgColor = Color.lerp(dominantColor, Colors.black, 0.7) ?? Colors.black;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: bgColor, // Dinamik koyu arka plan - Dynamic dark background
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Stack(
          children: [
            // [Arka plan Bulanık Kapak - Background Blurred Artwork]
            if (track.artwork != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.4,
                  child: Image.network(track.artwork!, fit: BoxFit.cover),
                ),
              ),
            
            // [Buzlu Cam Etkisi - Frosted Glass Effect]
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  _buildTopHandle(),
                  _buildHeader(track),
                  const Spacer(),
                  Expanded(
                    child: _buildMainArtwork(track, dominantColor),
                  ),
                  const Spacer(),
                  _buildMetadata(track),
                  const SizedBox(height: 32),
                  _buildProgressBar(audioService),
                  const SizedBox(height: 16),
                  _buildControls(audioService),
                  const Spacer(),
                  _buildFooter(context, audioService),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHandle() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget _buildHeader(AudioTrack track) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: Icon(PhosphorIcons.caretDown(), color: Colors.white), onPressed: () => Navigator.pop(context)),
          Column(
            children: [
              Text('KUBBE MÜZİK', style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
              Text(track.artist, style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          IconButton(icon: Icon(PhosphorIcons.dotsThreeVertical(), color: Colors.white), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildMainArtwork(AudioTrack track, Color dominantColor) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: dominantColor.withValues(alpha: 0.4), blurRadius: 60, spreadRadius: 5),
            ],
            image: track.artwork != null ? DecorationImage(image: NetworkImage(track.artwork!), fit: BoxFit.cover) : null,
          ),
          child: track.artwork == null ? const Center(child: Icon(Icons.music_note, color: Colors.white, size: 80)) : null,
        ),
      ),
    );
  }

  Widget _buildMetadata(AudioTrack track) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Text(track.title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          if (track.extras != null && track.extras!['ayah'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(text: "Ayet: "),
                    TextSpan(
                      text: "${track.extras!['ayah']}",
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
            ),
          Text("Resul: ${track.artist}", style: GoogleFonts.inter(color: Colors.white70, fontSize: 16), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildProgressBar(IslamicAudioService audioService) {
    return StreamBuilder<Duration>(
      stream: audioService.player.positionStream,
      builder: (context, snapshot) {
        final pos = snapshot.data ?? Duration.zero;
        final dur = audioService.player.duration ?? Duration.zero;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Colors.white,
                ),
                child: Slider(
                  value: pos.inSeconds.toDouble(),
                  max: dur.inSeconds.toDouble() > 0 ? dur.inSeconds.toDouble() : 1.0,
                  onChanged: (v) => audioService.player.seek(Duration(seconds: v.toInt())),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(pos), style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                  Text(_formatDuration(dur), style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControls(IslamicAudioService audioService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: Icon(PhosphorIcons.shuffle(), color: Colors.white54), onPressed: () {}),
          IconButton(icon: Icon(PhosphorIcons.skipBack(PhosphorIconsStyle.fill), color: Colors.white, size: 36), onPressed: () => audioService.skipToPrevious()),

          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: IconButton(
              icon: Icon(audioService.player.playing ? PhosphorIcons.pause(PhosphorIconsStyle.fill) : PhosphorIcons.play(PhosphorIconsStyle.fill), color: Colors.black, size: 40),
              onPressed: () => audioService.togglePlayPause(),
            ),
          ),
          IconButton(icon: Icon(PhosphorIcons.skipForward(PhosphorIconsStyle.fill), color: Colors.white, size: 36), onPressed: () => audioService.skipToNext()),

          IconButton(icon: Icon(PhosphorIcons.repeat(), color: Colors.white54), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, IslamicAudioService audioService) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(onPressed: () {}, icon: Icon(PhosphorIcons.playlist(), color: Colors.white70), label: Text('Koleksiyonlar', style: GoogleFonts.inter(color: Colors.white70))),
          IconButton(icon: Icon(PhosphorIcons.broadcast(), color: Colors.white70), onPressed: () {}),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }
}
