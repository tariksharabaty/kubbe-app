import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/state/theme_provider.dart';
import '../../../core/models/theme_tier.dart';
import '../../../core/models/theme_config.dart';

/// [Tema Seçimi Ekranı | Theme Selection Screen]
/// 4-seviyeli (Default, Free, Premium, Elite) tema sistemini görselleştirir.
/// Visualizes the 4-tier theme system.
class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Tema Galerisi", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: themeProvider.currentTheme.primaryColor,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildTierSection(context, "Varsayılan", ThemeTier.defaultTier, themeProvider),
          _buildTierSection(context, "Ücretsiz Temalar", ThemeTier.free, themeProvider),
          _buildTierSection(context, "Premium (Yakında)", ThemeTier.premium, themeProvider, isLocked: true),
          _buildTierSection(context, "Elite (Yakında)", ThemeTier.elite, themeProvider, isLocked: true),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  Widget _buildTierSection(
    BuildContext context, 
    String title, 
    ThemeTier tier, 
    ThemeProvider provider,
    {bool isLocked = false}
  ) {
    final themes = provider.getThemesByTier(tier);
    if (themes.isEmpty && !isLocked) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Colors.grey[400],
                  ),
                ),
                if (isLocked) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                ],
              ],
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: isLocked ? 3 : themes.length,
              itemBuilder: (context, index) {
                if (isLocked) return _buildPlaceholderCard();
                return _buildThemeCard(context, themes[index], provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, ThemeConfig theme, ThemeProvider provider) {
    final isSelected = provider.currentTheme.id == theme.id;

    return GestureDetector(
      onTap: () => provider.setTheme(theme),
      child: Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.grey[200]!,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Preview Circle
            Expanded(
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                ),
              ),
            ),
            // Theme Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                theme.name,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? theme.primaryColor : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Container(
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Center(
        child: Opacity(
          opacity: 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
              ),
              const SizedBox(height: 12),
              Container(width: 60, height: 8, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
            ],
          ),
        ),
      ),
    );
  }
}
