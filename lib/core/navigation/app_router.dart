import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // [Yazı Tipleri - Fonts]
import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/quran/screens/quran_screen.dart';
import '../../features/kumo/screens/kumo_screen.dart';
import '../../features/qibla/screens/qibla_screen.dart';
import '../../features/tools/screens/tools_screen.dart';
import '../../features/history/data/history_repository.dart';
import '../../features/history/screens/history_detail_screen.dart';

// Ana gezinme çerçevesi - Main navigation scaffold
class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  // Sekme isimleri - Tab names
  static const List<String> _tabTitles = [
    'Ana Sayfa', // Ana Sayfa - Home
    'Kuran', // Kuran-ı Kerim - Holy Quran
    'Kumo', // Yapay zeka asistanı - AI assistant
    'Kıble', // Kıble yönü - Qibla direction
    'Araçlar', // İslami araçlar - Islamic tools
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Alt gezinme çubuğu - Bottom navigation bar
  Widget _buildBottomNavigationBar() {

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed, // [Tip Sabitlendi - Type Fixed]
      selectedItemColor: const Color(0xFF4B0082), // [Seçili Renk: Koyu Mor - Selected Color: Dark Purple]
      unselectedItemColor: Colors.grey, // [Seçili Olmayan: Gri - Unselected: Gray]
      showSelectedLabels: true, // [Seçili Etiketleri Göster - Show Selected Labels]
      showUnselectedLabels: true, // [Seçili Olmayan Etiketleri Göster - Show Unselected Labels]
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 10,
      ),
      onTap: (index) {
        // Kumo butonu için özel handling - Special handling for Kumo button
        if (index == 2) {
          context.go('/kumo');
          setState(() {
            _currentIndex = index;
          });
          return;
        }

        setState(() {
          _currentIndex = index;
        });

        // Rota yönlendirmesi - Route navigation
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/quran');
            break;
          case 3:
            context.go('/qibla');
            break;
          case 4:
            context.go('/tools');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined), // Seçili olmayan - Unselected
          activeIcon: const Icon(Icons.home), // Seçili - Selected
          label: _tabTitles[0],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.menu_book_outlined), // Seçili olmayan - Unselected
          activeIcon: const Icon(Icons.menu_book), // Seçili - Selected
          label: _tabTitles[1],
        ),
        BottomNavigationBarItem(
          icon: _buildKumoIcon(), // Kumo ikonu - Kumo icon
          label: _tabTitles[2],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.explore_outlined), // Seçili olmayan - Unselected
          activeIcon: const Icon(Icons.explore), // Seçili - Selected
          label: _tabTitles[3],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.apps_outlined), // Seçili olmayan - Unselected
          activeIcon: const Icon(Icons.apps), // Seçili - Selected
          label: _tabTitles[4],
        ),
      ],
    );
  }

  // Kumo ikonu - Kumo icon
  Widget _buildKumoIcon() {
    final isSelected = _currentIndex == 2;
    const Color purple = Color(0xFF4B0082);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected ? purple.withValues(alpha: 0.1) : Colors.transparent,
        shape: BoxShape.circle,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: purple.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(
        isSelected ? Icons.auto_awesome : Icons.auto_awesome_outlined,
        color: isSelected ? purple : Colors.grey,
        size: 26,
      ),
    );
  }
}

// Uygulama router konfigürasyonu - Application router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => MainScaffold(child: HomeScreen()),
    ),
    GoRoute(
      path: '/quran',
      builder: (context, state) => MainScaffold(child: QuranScreen()),
    ),
    GoRoute(
      path: '/kumo',
      builder: (context, state) => MainScaffold(child: KumoScreen()),
    ),
    GoRoute(
      path: '/qibla',
      builder: (context, state) => MainScaffold(child: QiblaScreen()),
    ),
    GoRoute(
      path: '/tools',
      builder: (context, state) => MainScaffold(child: ToolsScreen()),
    ),
    GoRoute(
      path: '/history/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final item = HistoryRepository.allHistoryItems.firstWhere(
          (element) => element.id == id,
          orElse: () => HistoryRepository.allHistoryItems.first,
        );
        return HistoryDetailScreen(item: item);
      },
    ),
  ],
);
