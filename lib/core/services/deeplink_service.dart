import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import '../../features/history/data/history_repository.dart';
import '../../features/history/screens/history_detail_screen.dart';

class DeepLinkService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static StreamSubscription? _sub;
  static final _appLinks = AppLinks();

  static Future<void> init() async {
    // [1. Uygulama kapalıyken gelen link]
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleLink(initialUri);
      }
    } catch (e) {
      debugPrint("Deep Link Initial Error: $e");
    }

    // [2. Uygulama çalışırken gelen link]
    _sub = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleLink(uri);
        }
      },
      onError: (err) {
        debugPrint("Deep Link Stream Error: $err");
      },
    );
  }

  static void _handleLink(Uri uri) {
    String link = uri.toString();
    debugPrint("Handling Deep Link: $link");

    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'history') {
      final String id = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
      if (id.isNotEmpty) {
        final item = HistoryRepository.allHistoryItems.firstWhere(
          (h) => h.id == id,
          orElse: () => HistoryRepository.allHistoryItems.first,
        );

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => HistoryDetailScreen(item: item),
          ),
        );
      }
    }
  }

  static void dispose() {
    _sub?.cancel();
  }
}
