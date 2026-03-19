// TR: KUBBE V4 Shimmer Loading Effect - V4 yeniliği
// EN: KUBBE V4 Shimmer Loading Effect - V4 innovation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Resim yüklemelerinde 'Shimmer' efekti kullanarak "Elite" bir yükleme deneyimi sağla.
// EN: Provide "Elite" loading experience using 'Shimmer' effect for image loading.

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

/// TR: KUBBE V4 Shimmer Loading Widget'ı
/// EN: KUBBE V4 Shimmer Loading Widget
/// TR: Resim ve içerik yüklemeleri için şık shimmer efektleri
/// EN: Elegant shimmer effects for image and content loading
/// TR: V4 estetiği ve Sy-OS design language
/// EN: V4 aesthetics and Sy-OS design language
class V4ShimmerLoading extends StatelessWidget {
  // TR: Yüklenme tipi
  // EN: Loading type
  final ShimmerType type;

  // TR: Boyut
  // EN: Size
  final double? width;
  final double? height;

  // TR: Radius
  // EN: Radius
  final double? borderRadius;

  // TR: Renk
  // EN: Color
  final Color? baseColor;
  final Color? highlightColor;

  // TR: Constructor
  // EN: Constructor
  const V4ShimmerLoading({
    super.key,
    this.type = ShimmerType.card,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    // TR: Shimmer efektini oluştur
    // EN: Create shimmer effect
    return Shimmer.fromColors(
      // TR: Temel renk
      // EN: Base color
      baseColor: baseColor ?? Colors.grey.withValues(alpha: 0.3),
      // TR: Vurgu rengi
      // EN: Highlight color
      highlightColor: highlightColor ?? Colors.grey.withValues(alpha: 0.1),
      // TR: Çocuk widget
      // EN: Child widget
      child: _buildShimmerWidget(),
    );
  }

  // TR: Shimmer widget'ı oluştur
  // EN: Build shimmer widget
  Widget _buildShimmerWidget() {
    switch (type) {
      case ShimmerType.card:
        return _buildCardShimmer();
      case ShimmerType.avatar:
        return _buildAvatarShimmer();
      case ShimmerType.list:
        return _buildListShimmer();
      case ShimmerType.image:
        return _buildImageShimmer();
      case ShimmerType.text:
        return _buildTextShimmer();
      case ShimmerType.button:
        return _buildButtonShimmer();
      case ShimmerType.custom:
        return _buildCustomShimmer();
    }
  }

  // TR: Kart shimmer'ı oluştur
  // EN: Build card shimmer
  Widget _buildCardShimmer() {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 120,
      // TR: Dekorasyon
      // EN: Decoration
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(borderRadius ?? 32.0),
        // TR: Arka plan
        // EN: Background
        color: Colors.white,
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  // TR: Avatar shimmer'ı oluştur
  // EN: Build avatar shimmer
  Widget _buildAvatarShimmer() {
    return Container(
      width: width ?? 60,
      height: height ?? 60,
      // TR: Dekorasyon
      // EN: Decoration
      decoration: BoxDecoration(
        // TR: Yuvarlak
        // EN: Circle
        shape: BoxShape.circle,
        // TR: Arka plan
        // EN: Background
        color: Colors.white,
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  // TR: Liste shimmer'ı oluştur
  // EN: Build list shimmer
  Widget _buildListShimmer() {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 80,
      // TR: Padding
      // EN: Padding
      padding: const EdgeInsets.all(16.0),
      // TR: Dekorasyon
      // EN: Decoration
      decoration: BoxDecoration(
        // TR: 16dp radius
        // EN: 16dp radius
        borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
        // TR: Arka plan
        // EN: Background
        color: Colors.white,
      ),
      // TR: İçerik
      // EN: Content
      child: Row(
        // TR: MainAxisAlignment
        // EN: MainAxisAlignment
        children: [
          // TR: Avatar
          // EN: Avatar
          Container(
            width: 40,
            height: 40,
            // TR: Dekorasyon
            // EN: Decoration
            decoration: BoxDecoration(
              // TR: Yuvarlak
              // EN: Circle
              shape: BoxShape.circle,
              // TR: Arka plan
              // EN: Background
              color: Colors.grey.withValues(alpha: 0.3),
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(width: 12.0),

          // TR: Metin alanı
          // EN: Text area
          Expanded(
            // TR: Metin shimmer
            // EN: Text shimmer
            child: Column(
              // TR: Ana içerik
              // EN: Main content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TR: Başlık
                // EN: Title
                Container(
                  width: double.infinity,
                  height: 16,
                  // TR: Dekorasyon
                  // EN: Decoration
                  decoration: BoxDecoration(
                    // TR: 8dp radius
                    // EN: 8dp radius
                    borderRadius: BorderRadius.circular(8.0),
                    // TR: Arka plan
                    // EN: Background
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                ),

                // TR: Boşluk
                // EN: Spacer
                const SizedBox(height: 8.0),

                // TR: Alt başlık
                // EN: Subtitle
                Container(
                  width: 200,
                  height: 12,
                  // TR: Dekorasyon
                  // EN: Decoration
                  decoration: BoxDecoration(
                    // TR: 6dp radius
                    // EN: 6dp radius
                    borderRadius: BorderRadius.circular(6.0),
                    // TR: Arka plan
                    // EN: Background
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TR: Resim shimmer'ı oluştur
  // EN: Build image shimmer
  Widget _buildImageShimmer() {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 200,
      // TR: Dekorasyon
      // EN: Decoration
      decoration: BoxDecoration(
        // TR: 16dp radius
        // EN: 16dp radius
        borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
        // TR: Arka plan
        // EN: Background
        color: Colors.white,
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  // TR: Metin shimmer'ı oluştur
  // EN: Build text shimmer
  Widget _buildTextShimmer() {
    return Container(
      width: width ?? 200,
      height: height ?? 16,
      // TR: Dekorasyon
      // EN: Decoration
      decoration: BoxDecoration(
        // TR: 8dp radius
        // EN: 8dp radius
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
        // TR: Arka plan
        // EN: Background
        color: Colors.grey.withValues(alpha: 0.3),
      ),
    );
  }

  // TR: Buton shimmer'ı oluştur
  // EN: Build button shimmer
  Widget _buildButtonShimmer() {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 50,
      // TR: Dekorasyon
      // EN: Decoration
      decoration: BoxDecoration(
        // TR: 100dp radius (pill shape)
        // EN: 100dp radius (pill shape)
        borderRadius: BorderRadius.circular(100.0),
        // TR: Arka plan
        // EN: Background
        color: Colors.white,
        // TR: Gölge
        // EN: Shadow
        boxShadow: [
          BoxShadow(
            color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  // TR: Özel shimmer'ı oluştur
  // EN: Build custom shimmer
  Widget _buildCustomShimmer() {
    return Container(
      width: width ?? 100,
      height: height ?? 100,
      // TR: Dekorasyon
      // EN: Decoration
      decoration: BoxDecoration(
        // TR: Radius
        // EN: Radius
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
        // TR: Arka plan
        // EN: Background
        color: Colors.white,
      ),
    );
  }
}

/// TR: Shimmer Loading Tipi
/// EN: Shimmer Loading Type
enum ShimmerType {
  // TR: Kart
  // EN: Card
  card,

  // TR: Avatar
  // EN: Avatar
  avatar,

  // TR: Liste
  // EN: List
  list,

  // TR: Resim
  // EN: Image
  image,

  // TR: Metin
  // EN: Text
  text,

  // TR: Buton
  // EN: Button
  button,

  // TR: Özel
  // EN: Custom
  custom,
}

/// TR: V4 Shimmer Builder Widget - V4 yeniliği
/// EN: V4 Shimmer Builder Widget - V4 innovation
/// TR: Koşullu shimmer efektleri için builder widget
/// EN: Builder widget for conditional shimmer effects
class V4ShimmerBuilder extends StatelessWidget {
  // TR: Yüklenme durumu
  // EN: Loading state
  final bool isLoading;

  // TR: Child widget
  // EN: Child widget
  final Widget child;

  // TR: Shimmer widget
  // EN: Shimmer widget
  final Widget? shimmerWidget;

  // TR: Constructor
  // EN: Constructor
  const V4ShimmerBuilder({
    super.key,
    required this.isLoading,
    required this.child,
    this.shimmerWidget,
  });

  @override
  Widget build(BuildContext context) {
    // TR: Yüklenme durumuna göre widget döndür
    // EN: Return widget based on loading state
    if (isLoading) {
      return shimmerWidget ?? const V4ShimmerLoading();
    } else {
      return child;
    }
  }
}

/// TR: V4 Image Loader - V4 yeniliği
/// EN: V4 Image Loader - V4 innovation
/// TR: Resim yüklemeleri için shimmer efektli loader
/// EN: Shimmer effect loader for image loading
class V4ImageLoader extends StatefulWidget {
  // TR: Resim URL'si
  // EN: Image URL
  final String imageUrl;

  // TR: Yüklenme widget'ı
  // EN: Loading widget
  final Widget? loadingWidget;

  // TR: Hata widget'ı
  // EN: Error widget
  final Widget? errorWidget;

  // TR: Genişlik
  // EN: Width
  final double? width;

  // TR: Yükseklik
  // EN: Height
  final double? height;

  // TR: Fit
  // EN: Fit
  final BoxFit fit;

  // TR: Constructor
  // EN: Constructor
  const V4ImageLoader({
    super.key,
    required this.imageUrl,
    this.loadingWidget,
    this.errorWidget,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  State<V4ImageLoader> createState() => _V4ImageLoaderState();
}

class _V4ImageLoaderState extends State<V4ImageLoader> {
  // TR: Yüklenme durumu
  // EN: Loading state
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // TR: Resmi yükle
    // EN: Load image
    _loadImage();
  }

  // TR: Resmi yükle
  // EN: Load image
  void _loadImage() async {
    // TR: Gelecekte NetworkImage ile implemente edilebilir
    // EN: Can be implemented with NetworkImage in future
    // TR: Şimdilik geçici yükleme simülasyonu
    // EN: Temporary loading simulation for now
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasError =
            false; // TR: Hata simülasyonu için true yapılabilir // EN: Can be set to true for error simulation
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TR: Yüklenme durumuna göre widget döndür
    // EN: Return widget based on loading state
    if (_isLoading) {
      return widget.loadingWidget ??
          V4ShimmerLoading(
            type: ShimmerType.image,
            width: widget.width,
            height: widget.height,
          );
    } else if (_hasError) {
      return widget.errorWidget ?? _buildErrorWidget();
    } else {
      return _buildImageWidget();
    }
  }

  // TR: Resim widget'ı oluştur
  // EN: Build image widget
  Widget _buildImageWidget() {
    // TR: Geçici resim implementasyonu
    // EN: Temporary image implementation
    return Container(
      width: widget.width,
      height: widget.height,
      // TR: Dekorasyon
      // EN: Decoration
      decoration: BoxDecoration(
        // TR: 16dp radius
        // EN: 16dp radius
        borderRadius: BorderRadius.circular(16.0),
        // TR: Gradient arka plan (geçici)
        // EN: Gradient background (temporary)
        gradient: LinearGradient(
          colors: [
            KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
            KubbeTheme.kubbeIndigo.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      // TR: İçerik
      // EN: Content
      child: Center(
        // TR: İkon
        // EN: Icon
        child: Icon(
          Icons.image,
          color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.5),
          size: 40,
        ),
      ),
    );
  }

  // TR: Hata widget'ı oluştur
  // EN: Build error widget
  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      // TR: Dekorasyon
      // EN: Decoration
      decoration: BoxDecoration(
        // TR: 16dp radius
        // EN: 16dp radius
        borderRadius: BorderRadius.circular(16.0),
        // TR: Arka plan
        // EN: Background
        color: Colors.grey.withValues(alpha: 0.1),
      ),
      // TR: İçerik
      // EN: Content
      child: const Center(
        // TR: İkon ve metin
        // EN: Icon and text
        child: Column(
          // TR: MainAxisAlignment
          // EN: MainAxisAlignment
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TR: İkon
            // EN: Icon
            Icon(
              Icons.error,
              color: Colors.grey,
              size: 40,
            ),

            // TR: Boşluk
            // EN: Spacer
            SizedBox(height: 8.0),

            // TR: Metin
            // EN: Text
            Text(
              'Resim yüklenemedi',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// TR: V4 List Loading Widget - V4 yeniliği
/// EN: V4 List Loading Widget - V4 innovation
/// TR: Liste yüklemeleri için shimmer efektli widget
/// EN: Shimmer effect widget for list loading
class V4ListLoading extends StatelessWidget {
  // TR: Eleman sayısı
  // EN: Item count
  final int itemCount;

  // TR: Eleman yüksekliği
  // EN: Item height
  final double itemHeight;

  // TR: Constructor
  // EN: Constructor
  const V4ListLoading({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    // TR: Shimmer listesi oluştur
    // EN: Create shimmer list
    return ListView.builder(
      // TR: Eleman sayısı
      // EN: Item count
      itemCount: itemCount,
      // TR: Builder
      // EN: Builder
      itemBuilder: (context, index) {
        return Padding(
          // TR: Padding
          // EN: Padding
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          // TR: Shimmer öğesi
          // EN: Shimmer item
          child: V4ShimmerLoading(
            type: ShimmerType.list,
            height: itemHeight,
          ),
        );
      },
    );
  }
}

/// TR: V4 Card Loading Widget - V4 yeniliği
/// EN: V4 Card Loading Widget - V4 innovation
/// TR: Kart yüklemeleri için shimmer efektli widget
/// EN: Shimmer effect widget for card loading
class V4CardLoading extends StatelessWidget {
  // TR: Kart sayısı
  // EN: Card count
  final int cardCount;

  // TR: Kart yüksekliği
  // EN: Card height
  final double cardHeight;

  // TR: Constructor
  // EN: Constructor
  const V4CardLoading({
    super.key,
    this.cardCount = 3,
    this.cardHeight = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    // TR: Column ile kartları oluştur
    // EN: Create cards with Column
    return Column(
      // TR: Ana içerik
      // EN: Main content
      children: List.generate(
        cardCount,
        (index) => Padding(
          // TR: Padding
          // EN: Padding
          padding: const EdgeInsets.all(8.0),
          // TR: Shimmer kartı
          // EN: Shimmer card
          child: V4ShimmerLoading(
            type: ShimmerType.card,
            height: cardHeight,
          ),
        ),
      ),
    );
  }
}
