import 'package:flutter/material.dart';
import '../../core/utils/turkish_utils.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TurkishUtils.toTitleCase('zaman kubbesi'),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold, // Outfit Bold
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    TurkishUtils.toTitleCase('zaman kubbesi'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold, // Outfit Bold
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    TurkishUtils.toSentenceCase(
                        'geçmiş vakitler ve ibadet arşivi yakında...'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
