// TR: KUBBE V4 Elite Splash Screen - Ultra Minimal
// EN: KUBBE V4 Elite Splash Screen - Ultra Minimal

import 'package:flutter/material.dart';

/// TR: Elite Splash Screen - Ultra Minimal
/// EN: Elite Splash Screen - Ultra Minimal
class EliteSplashScreen extends StatefulWidget {
  const EliteSplashScreen({super.key});

  @override
  State<EliteSplashScreen> createState() => _EliteSplashScreenState();
}

class _EliteSplashScreenState extends State<EliteSplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      // TR: Hata durumunda direkt home'a git
      // EN: Go directly to home on error
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox.shrink(),
      ),
    );
  }
}
