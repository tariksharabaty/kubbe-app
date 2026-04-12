import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VoiceSearchModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _VoiceSearchContent(),
    );
  }
}

class _VoiceSearchContent extends StatelessWidget {
  const _VoiceSearchContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sizi dinliyorum...",
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4B0082),
            ),
          ),
          const SizedBox(height: 60),
          const _WavyAnimation(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _WavyAnimation extends StatefulWidget {
  const _WavyAnimation();

  @override
  State<_WavyAnimation> createState() => _WavyAnimationState();
}

class _WavyAnimationState extends State<_WavyAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ...List.generate(3, (index) {
              double progress = (_controller.value + index / 3) % 1.0;
              return Container(
                width: 120 * progress,
                height: 120 * progress,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4B0082).withValues(alpha: (1.0 - progress) * 0.3),
                ),
              );
            }),
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF6A0DAD), Color(0xFF4B0082)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF4B0082),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: const Icon(
                Icons.mic_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        );
      },
    );
  }
}
