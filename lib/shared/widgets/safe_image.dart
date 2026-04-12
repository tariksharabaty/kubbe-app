import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'pulsing_loader.dart';

/// [Güvenli Görsel Yükleyici | Safe Image Loader]
/// Görsel yükleme hatalarını (Asset veya Network) yakalar ve uygulamanın çökmesini önler.
/// Catches image loading errors (Asset or Network) and prevents the app from crashing.
class SafeImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool isNetwork;
  final BorderRadius? borderRadius;

  const SafeImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.isNetwork = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (isNetwork) {
      imageWidget = CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => const PulsingLoader(size: 30),
        errorWidget: (context, url, error) => _buildFallback(),
      );
    } else {
      imageWidget = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, color: Colors.grey[400], size: 24),
          const SizedBox(height: 4),
          Text(
            "Görsel Yüklenemedi\nImage not found",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 10),
          ),
        ],
      ),
    );
  }
}
