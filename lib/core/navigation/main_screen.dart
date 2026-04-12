import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/quran/screens/quran_screen.dart';
import '../../features/kumo/screens/kumo_screen.dart';
import '../../features/qibla/screens/qibla_screen.dart';
import '../../features/tools/screens/tools_screen.dart';
// import '../../features/music/screens/music_screen.dart'; // [Müzik sayfası kaldırıldı - Music page removed]
import '../../features/music/widgets/global_audio_player_bar.dart'; // Ses barı bileşeni - Audio bar component






// Ana ekran - Main screen with IndexedStack navigation

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Mevcut sekme indeksi - Current tab index


  @override
  void initState() {
    super.initState();
    // [Güvenli başlangıç indeksi kontrolü - Safe initial index check]
    if (_currentIndex < 0 || _currentIndex >= _pages.length) {
      _currentIndex = 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  // Ana sayfalar listesi - List of main pages
  final List<Widget> _pages = [
    const HomeScreen(),        // 0: Ana Sayfa - Home Page
    const QuranScreen(),       // 1: Kur'an - Quran Reading
    const KumoScreen(),        // 2: Kumo AI - AI Assistant
    const QiblaScreen(),       // 3: Kıble - Qibla Compass
    const ToolsScreen(),       // 4: Araçlar - Religious Tools
  ];


  // Sekme isimleri - Tab names
  static const List<String> _tabTitles = [
    'Ana Sayfa',
    'Kur\'an',
    'Kumo',        // [Müzik yerine Kumo - Kumo instead of Music]
    'Kıble',
    'Araçlar',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Tema uyumlu arka plan - Theme compliant background
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: _buildBottomNavigationBar(),
      ),


      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          const GlobalAudioPlayerBar(), // [Global ses barı artık Stack içerisinde - Global audio bar now in Stack]
        ],
      ),
    );
  }

  // [Alt gezinme çubuğu - Bottom navigation bar]
  Widget _buildBottomNavigationBar() {
    const Color selectedColor = Color(0xFF4B0082);
    const Color unselectedColor = Colors.grey;

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed, // [Instagram Tarzı Sabit Menü - Instagram Style Fixed Menu]
      backgroundColor: Theme.of(context).colorScheme.surface, // Temadan çekilen arka plan - Background from theme
      showSelectedLabels: true, // [Yazıları Göster - Show Labels]
      showUnselectedLabels: true,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      iconSize: 24,
      selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w400),
      elevation: 8,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      onTap: (index) {
        if (index == 2) { // Kıble Tab (Previously 3)
          // Kumo click handling logic can stay if needed, but the original request
          // just said to transition 5 down to 4. 
          // Re-indexing Kumo click logic if it was on index 2 (Music/KUMO?)
          // In original code, index 2 was "Dinle".
        }

        if (index >= 0 && index < _pages.length) {
          setState(() => _currentIndex = index);
          HapticFeedback.lightImpact(); // [Dokunmatik Geri Bildirim - Haptic Feedback]
        }
      },

      items: [
        BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.house()), 
          activeIcon: Icon(PhosphorIcons.house(PhosphorIconsStyle.fill)), 
          label: _tabTitles[0],
        ),
        BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.bookOpen()), 
          activeIcon: Icon(PhosphorIcons.bookOpen(PhosphorIconsStyle.fill)), 
          label: _tabTitles[1],
        ),
        BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.sparkle()), 
          activeIcon: Icon(PhosphorIcons.sparkle(PhosphorIconsStyle.fill)), 
          label: _tabTitles[2],
        ),
        BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.compass()), 
          activeIcon: Icon(PhosphorIcons.compass(PhosphorIconsStyle.fill)), 
          label: _tabTitles[3],
        ),
        BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.squaresFour()), 
          activeIcon: Icon(PhosphorIcons.squaresFour(PhosphorIconsStyle.fill)), 
          label: _tabTitles[4],
        ),

      ],
    );
  }
}
