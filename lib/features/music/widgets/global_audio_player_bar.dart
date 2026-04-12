import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/islamic_audio_service.dart';

class GlobalAudioPlayerBar extends StatelessWidget {
  const GlobalAudioPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: IslamicAudioService(),
      builder: (context, child) {
        final audioService = IslamicAudioService();
        final state = audioService.uiState;
        final track = audioService.currentTrack;

        if (state == AudioUiState.hidden || track == null) return const SizedBox.shrink();
        
        // [Baloncuk modu kontrolü - Bubble mode check]
        if (state == AudioUiState.bubble) {
          return _buildBubblePlayer(context, audioService, track);
        }

        return ValueListenableBuilder<bool>(
          valueListenable: audioService.isUiVisible,
          builder: (context, isUiVisible, child) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                offset: isUiVisible ? Offset.zero : const Offset(0, 1.5),
                duration: const Duration(milliseconds: 300),
                child: _buildSmartPlayerBar(context, audioService, track),
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildBubblePlayer(BuildContext context, IslamicAudioService audioService, AudioTrack track) {
     return Positioned(
       left: 16, // [Bottom-left alignment - Alt-sol hizalama]
       bottom: 20, // [Positioned lower above system navigation - Sistem navigasyonunun hemen üzerinde]
       child: GestureDetector(
         onTap: () => audioService.setUiState(AudioUiState.bar),
         onHorizontalDragEnd: (details) {
           // Horizontal swipe navigation for Ayahs - Ayetler arası yatay kaydırma ile gezinme
           if (details.primaryVelocity != null) {
             if (details.primaryVelocity! > 300) {
               HapticFeedback.lightImpact();
               audioService.skipToNextAyah(); // Swipe right (velocity > 0) to next Ayah - Sağa kaydırma ile sonraki ayet
             } else if (details.primaryVelocity! < -300) {
               HapticFeedback.lightImpact();
               audioService.skipToPreviousAyah(); // Swipe left (velocity < 0) to previous Ayah - Sola kaydırma ile önceki ayet
             }
           }
         },
         child: Hero(
           tag: 'audio_player_hero',
           child: SurahCoverWidget(
             name: track.title,
             arabicName: track.arabicName ?? "ق",
             isQuran: track.extras?['is_quran'] == true,
             isBubble: true,
           ),
         ),
       ),
     );
  }

  Widget _buildSmartPlayerBar(BuildContext context, IslamicAudioService audioService, AudioTrack track) {
    final theme = Theme.of(context);
    final isQuran = track.extras?['is_quran'] == true;

    return Hero(
      tag: 'audio_player_hero',
      child: GestureDetector(
        onTap: () {
            HapticFeedback.lightImpact();
            audioService.nextAyah();
        },
        onLongPress: () {
            HapticFeedback.mediumImpact();
            audioService.nextSurah();
        },
        onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < -300) {
                HapticFeedback.lightImpact();
                audioService.nextAyah();
            } else if (details.primaryVelocity! > 300) {
                HapticFeedback.lightImpact();
                audioService.previousAyah();
            }
        },
        onVerticalDragUpdate: (details) {
            if (details.primaryDelta! > 10) {
                // [Aşağı kaydırma: Çalıyor ise küçült, beklemede ise kapat - Swipe down: Minimize if playing, dismiss if paused]
                HapticFeedback.mediumImpact();
                if (audioService.player.playing) {
                  audioService.setUiState(AudioUiState.bubble);
                } else {
                  audioService.stop();
                }
            }
        },
        child: Container(
          height: 95,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        SurahCoverWidget(
                          name: track.title,
                          arabicName: track.arabicName ?? "ق",
                          isQuran: isQuran,
                        ),
                        const SizedBox(width: 16),
                        
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isQuran)
                                StreamBuilder<int?>(
                                  stream: audioService.currentAyahStream,
                                  builder: (context, snapshot) {
                                    final ayah = snapshot.data ?? 1;
                                    return Text(
                                      "Ayet $ayah",
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                )
                              else
                                Text(
                                  track.artist,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        _buildControls(context, audioService),
                      ],
                    ),
                  ),
                ),
                _buildProgressIndicator(audioService, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, IslamicAudioService audioService) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            audioService.skipToPreviousAyah(); // Use improved naming - İyileştirilmiş isimlendirmeyi kullan
          },
          onLongPress: () {
            HapticFeedback.mediumImpact();
            audioService.skipToPreviousSurah(); // Use improved naming - İyileştirilmiş isimlendirmeyi kullan
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(Icons.skip_previous, size: 28),
          ),
        ),
        IconButton(
          icon: Icon(
            audioService.player.playing 
                ? Icons.pause_circle_filled_rounded 
                : Icons.play_circle_filled_rounded,
            size: 44,
            color: theme.colorScheme.primary,
          ),
          onPressed: () => audioService.togglePlayPause(),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            audioService.skipToNextAyah(); // Use improved naming - İyileştirilmiş isimlendirmeyi kullan
          },
          onLongPress: () {
            HapticFeedback.mediumImpact();
            audioService.skipToNextSurah(); // Use improved naming - İyileştirilmiş isimlendirmeyi kullan
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(Icons.skip_next, size: 28),
          ),
        ),
        _buildSpeedSelector(context, audioService),
      ],
    );
  }

  Widget _buildSpeedSelector(BuildContext context, IslamicAudioService audioService) {
    return PopupMenuButton<double>(
      icon: const Icon(Icons.speed_rounded),
      onSelected: (speed) {
        HapticFeedback.selectionClick();
        audioService.player.setSpeed(speed);
      },
      itemBuilder: (context) => [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0] // Speed limits added: min 0.25, max 2.0 - Hız sınırları eklendi: min 0.25, maks 2.0
          .map((s) => PopupMenuItem(
                value: s,
                child: Text("${s}x", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              ))
          .toList(),
    );
  }

  Widget _buildProgressIndicator(IslamicAudioService audioService, ThemeData theme) {
     return StreamBuilder<Duration>(
      stream: audioService.player.positionStream,
      builder: (context, snapshot) {
        final pos = snapshot.data ?? Duration.zero;
        final dur = audioService.player.duration ?? const Duration(seconds: 1);
        final value = (dur.inMilliseconds > 0) 
            ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0) 
            : 0.0;
        return LinearProgressIndicator(
          value: value,
          minHeight: 3,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        );
      },
    );
  }
}

class SurahCoverWidget extends StatelessWidget {
  final String name;
  final String arabicName;
  final bool isQuran;
  final bool isBubble;

  const SurahCoverWidget({
    super.key,
    required this.name,
    required this.arabicName,
    required this.isQuran,
    this.isBubble = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isBubble ? 60 : 55,
      height: isBubble ? 60 : 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7E5F), Color(0xFFFEB47B)], // [Sunset Orange/Pink to Amber - Günbatımı Turuncu/Pembe]
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12), // [Rounded Rectangle Squircle - Yuvarlatılmış Kare]
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7E5F).withValues(alpha: 0.3), 
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0), // Padding to prevent text overflow in circle - Metin taşmasını önlemek için dolgu
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              isQuran && arabicName.isNotEmpty ? arabicName : "K", // Use Full Arabic Name as requested - Arapça ismini kullan
              style: GoogleFonts.amiri( // Amiri Font for Arabic - Arapça için Amiri Fontu
                fontSize: isBubble ? 24 : 18,
                color: Colors.white, // Pure white for contrast - Kontrast için saf beyaz
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
