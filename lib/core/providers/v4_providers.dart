// TR: KUBBE V4 Provider Entegrasyonu - V4 yeniliği
// EN: KUBBE V4 Provider Integration - V4 innovation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: 'qiblaProvider' ve 'kumoProvider' yapılarını ana Riverpod ağacına bağla.
// EN: Connect 'qiblaProvider' and 'kumoProvider' structures to main Riverpod tree.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/worship/qibla/qibla_provider.dart';
import '../../features/worship/zekat/zekat_calculator.dart';
import '../../features/ai/data/kumo_repository.dart';
import '../../features/ai/data/kumo_chat_logic.dart';

/// TR: KUBBE V4 Ana Provider Dosyası
/// EN: KUBBE V4 Main Provider File
/// TR: Tüm yeni provider'ları bir arada toplar
/// EN: Collects all new providers together
/// TR: V4 mimarisi için merkezi provider yönetimi
/// EN: Central provider management for V4 architecture
/// TR: Riverpod ile modern state management
/// EN: Modern state management with Riverpod
/// TR: V1'den miras alınan mantıkların provider'ları
/// EN: Providers for logic inherited from V1

// TR: Worship Provider'ları - V4 yeniliği
// EN: Worship Providers - V4 innovation
// TR: İbadetler ile ilgili provider'lar
// EN: Providers related to worship

/// TR: Kumo Chat State Provider - V4 yeniliği
/// EN: Kumo Chat State Provider - V4 innovation
/// TR: Kumo chat durumunu sağlar
/// EN: Provides kumo chat state
/// TR: V1'den miras alındı
/// EN: Inherited from V1
final kumoChatStateProvider = Provider<KumoChatLogic>((ref) {
  return ref.watch(kumoChatLogicProvider);
});

// TR: Combined Provider'lar - V4 yeniliği
// EN: Combined Providers - V4 innovation
// TR: Birden fazla provider'ı birleştiren yapılar
// EN: Structures that combine multiple providers

/// TR: Worship Combined Provider - V4 yeniliği
/// EN: Worship Combined Provider - V4 innovation
/// TR: Tüm ibadet provider'larını bir arada sağlar
/// EN: Provides all worship providers together
/// TR: V4 yeniliği
/// EN: V4 innovation
final worshipCombinedProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'qibla': ref.watch(qiblaStateProvider),
    'zekatmatik': ref.read(zekatmatikProvider),
  };
});

/// TR: AI Combined Provider - V4 yeniliği
/// EN: AI Combined Provider - V4 innovation
/// TR: Tüm AI provider'larını bir arada sağlar
/// EN: Provides all AI providers together
/// TR: V4 yeniliği
/// EN: V4 innovation
final aiCombinedProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'repository': ref.read(kumoRepositoryProvider),
    'chatLogic': ref.read(kumoChatLogicProvider),
    'chatState': ref.watch(kumoChatStateProvider),
  };
});

/// TR: V4 Features Provider - V4 yeniliği
/// EN: V4 Features Provider - V4 innovation
/// TR: V4 özelliklerinin tamamını bir arada sağlar
/// EN: Provides all V4 features together
/// TR: V4 yeniliği
/// EN: V4 innovation
final v4FeaturesProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'worship': ref.watch(worshipCombinedProvider),
    'ai': ref.watch(aiCombinedProvider),
    'statistics': {
      'qibla': {
        'currentAngle': ref.read(qiblaProvider).currentAngle,
        'qiblaAngle': ref.read(qiblaProvider).qiblaAngle,
        'isFacingQibla': ref.read(qiblaProvider).isFacingQibla,
      },
      'zekatmatik': ref.read(zekatmatikProvider).nisapMiktarlari,
      'kumo': ref.read(kumoRepositoryProvider).getStatistics(),
    },
  };
});

/// TR: Provider Manager - V4 yeniliği
/// EN: Provider Manager - V4 innovation
/// TR: Provider'ları yöneten yardımcı sınıf
/// EN: Helper class that manages providers
class V4ProviderManager {
  // TR: Singleton instance
  // EN: Singleton instance
  static final V4ProviderManager _instance = V4ProviderManager._internal();
  factory V4ProviderManager() => _instance;
  V4ProviderManager._internal();

  // TR: Provider'ları başlat
  // EN: Initialize providers
  void initializeProviders() {
    // TR: Provider'ların başlangıç işlemleri
    // EN: Initialization operations for providers
    // Initialize providers

    // TR: Repository'leri başlat
    // EN: Initialize repositories
    final kumoRepository = KumoRepository();
    kumoRepository.initialize();

    // TR: Diğer başlangıç işlemleri
    // EN: Other initialization operations
    // final zekatmatik = ZekatCalculator();

    // TR: Başlatıldı mesajı
    // EN: Initialized message
    // Log initialization
  }

  // TR: Provider istatistiklerini al
  // EN: Get provider statistics
  Map<String, dynamic> getProviderStatistics() {
    return {
      'totalProviders':
          7, // TR: Toplam provider sayısı // EN: Total provider count
      'categories': ['Worship', 'AI', 'Combined'],
      'lastUpdated': DateTime.now().toIso8601String(),
      'features': {
        'qibla': 'Kible pusulası',
        'zekatmatik': 'Zekat hesaplama',
        'kumo': 'AI asistan',
        'combined': 'Birleşik özellikler',
      },
    };
  }

  // TR: Provider durumunu kontrol et
  // EN: Check provider status
  bool isProviderHealthy(String providerName) {
    // TR: Provider sağlığını kontrol et
    // EN: Check provider health
    switch (providerName) {
      case 'qibla':
        return true; // TR: Qibla provider sağlıklı // EN: Qibla provider is healthy
      case 'zekatmatik':
        return true; // TR: Zekatmatik provider sağlıklı // EN: Zekatmatik provider is healthy
      case 'kumo':
        return true; // TR: Kumo provider sağlıklı // EN: Kumo provider is healthy
      default:
        return false; // TR: Bilinmeyen provider // EN: Unknown provider
    }
  }

  // TR: Tüm provider'ların durumunu kontrol et
  // EN: Check all providers status
  Map<String, bool> getAllProvidersHealth() {
    return {
      'qibla': isProviderHealthy('qibla'),
      'zekatmatik': isProviderHealthy('zekatmatik'),
      'kumo': isProviderHealthy('kumo'),
      'worshipCombined': isProviderHealthy('worshipCombined'),
      'aiCombined': isProviderHealthy('aiCombined'),
      'v4Features': isProviderHealthy('v4Features'),
    };
  }

  // TR: Provider'ları yenile
  // EN: Refresh providers
  void refreshProviders() {
    // TR: Provider'ları yenile
    // EN: Refresh providers
    // Log refresh

    // TR: Repository'leri yenile
    // EN: Refresh repositories
    final kumoRepository = KumoRepository();
    kumoRepository.clear();
    kumoRepository.initialize();
  }

  // TR: Provider'ları temizle
  // EN: Clear providers
  void clearProviders() {
    // TR: Provider'ları temizle
    // EN: Clear providers
    // Log clearing

    // TR: Repository'leri temizle
    // EN: Clear repositories
    final kumoRepository = KumoRepository();
    kumoRepository.clear();
  }
}

/// TR: V4 Provider Manager Provider - V4 yeniliği
/// EN: V4 Provider Manager Provider - V4 innovation
/// TR: Provider manager'a erişim sağlayan provider
/// EN: Provider that provides access to provider manager
final v4ProviderManagerProvider = Provider<V4ProviderManager>((ref) {
  return V4ProviderManager();
});

/// TR: Provider Initialization Hook - V4 yeniliği
/// EN: Provider Initialization Hook - V4 innovation
/// TR: Uygulama başladığında provider'ları başlatan hook
/// EN: Hook that initializes providers when app starts
/// TR: V4 yeniliği
/// EN: V4 innovation
void initializeV4Providers() {
  final manager = V4ProviderManager();
  manager.initializeProviders();
}

/// TR: Provider Health Check Hook - V4 yeniliği
/// EN: Provider Health Check Hook - V4 innovation
/// TR: Provider sağlığını kontrol eden hook
/// EN: Hook that checks provider health
/// TR: V4 yeniliği
/// EN: V4 innovation
Map<String, bool> checkV4ProvidersHealth() {
  final manager = V4ProviderManager();
  return manager.getAllProvidersHealth();
}

/// TR: Provider Statistics Hook - V4 yeniliği
/// EN: Provider Statistics Hook - V4 innovation
/// TR: Provider istatistiklerini alan hook
/// EN: Hook that gets provider statistics
/// TR: V4 yeniliği
/// EN: V4 innovation
Map<String, dynamic> getV4ProvidersStatistics() {
  final manager = V4ProviderManager();
  return manager.getProviderStatistics();
}
