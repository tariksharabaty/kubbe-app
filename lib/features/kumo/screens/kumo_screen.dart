import 'package:flutter/material.dart';

// Kumo Yapay Zeka Ekranı - Kumo AI Screen
class KumoScreen extends StatelessWidget {
  const KumoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.smart_toy, size: 80, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Kumo', // Kumo - Kumo
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Yapay Zeka Asistanınız', // Yapay Zeka Asistanınız - Your AI Assistant
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
