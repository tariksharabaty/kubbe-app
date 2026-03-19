// TR: KUBBE V4 Elite Card Component - V4 standartları
// EN: KUBBE V4 Elite Card Component - V4 standards
// TR: V4 standartlarında 32dp radius, hafif mor gölge ve 'Sy-OS' ferahlığına sahip kart bileşeni
// EN: Card component with 32dp radius, light purple shadow and 'Sy-OS' spaciousness according to V4 standards
// TR: KUBBE tasarım dilinin temel kart bileşeni
// EN: Fundamental card component of KUBBE design language

import 'package:flutter/material.dart';

/// TR: KUBBE V4 Elite Kart Bileşeni
/// EN: KUBBE V4 Elite Card Component
/// TR: V4 standartlarında tasarlanmış, 32dp radius ve hafif mor gölgeye sahip asil kart
/// EN: Noble card designed with V4 standards, 32dp radius and light purple shadow
/// TR: 'Sy-OS' ferahlığı ve modern estetiği birleştirir
/// EN: Combines 'Sy-OS' spaciousness and modern aesthetics
class KubbeCard extends StatelessWidget {
  // TR: Kart içeriği
  // EN: Card content
  final Widget child;

  // TR: Kart yüksekliği (varsayılan: 8dp)
  // EN: Card elevation (default: 8dp)
  final double elevation;

  // TR: Kenar boşluğu (varsayılan: 16dp)
  // EN: Margin (default: 16dp)
  final EdgeInsetsGeometry margin;

  // TR: İç boşluk (varsayılan: 16dp)
  // EN: Padding (default: 16dp)
  final EdgeInsetsGeometry padding;

  // TR: Kart rengi (varsayılan: beyaz)
  // EN: Card color (default: white)
  final Color color;

  // TR: Gölge rengi (varsayılan: hafif mor)
  // EN: Shadow color (default: light purple)
  final Color shadowColor;

  // TR: Oncallback fonksiyonu
  // EN: Oncallback function
  final VoidCallback? onTap;

  // TR: Constructor
  // EN: Constructor
  const KubbeCard({
    super.key,
    required this.child,
    this.elevation = 8.0,
    this.margin = const EdgeInsets.all(16.0),
    this.padding = const EdgeInsets.all(16.0),
    this.color = const Color(0xFFFFFFFF),
    this.shadowColor = const Color(
        0x1A9C27B0), // TR: Hafif mor gölge // EN: Light purple shadow
    this.onTap,
  });

  // TR: V4 standartlarında kart oluşturur
  // EN: Creates card with V4 standards
  @override
  Widget build(BuildContext context) {
    // TR: Tıklanabilir kart için InkWell kullan
    // EN: Use InkWell for clickable card
    Widget cardChild = Container(
      margin: margin,
      decoration: BoxDecoration(
        // TR: V4 standart 32dp radius
        // EN: V4 standard 32dp radius
        borderRadius: BorderRadius.circular(32.0),

        // TR: Hafif mor gölge
        // EN: Light purple shadow
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: elevation * 2,
            offset: Offset(0, elevation),
            spreadRadius: 1,
          ),
        ],

        // TR: Kart rengi
        // EN: Card color
        color: color,
      ),
      // TR: İç boşluk
      // EN: Padding
      padding: padding,
      // TR: Çocuk widget
      // EN: Child widget
      child: child,
    );

    // TR: Tıklanabilirlik varsa Material ile sar
    // EN: Wrap with Material if clickable
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          // TR: V4 standart radius
          // EN: V4 standard radius
          borderRadius: BorderRadius.circular(32.0),
          // TR: Tıklama efekti
          // EN: Tap effect
          splashColor: Colors.purple.withValues(alpha: 0.1),
          highlightColor: Colors.purple.withValues(alpha: 0.05),
          // TR: Tıklama callback'i
          // EN: Tap callback
          onTap: onTap,
          // TR: Kart child
          // EN: Card child
          child: cardChild,
        ),
      );
    }

    return cardChild;
  }
}

/// TR: KUBBE V4 Elite Kart Variant'ları
/// EN: KUBBE V4 Elite Card Variants
/// TR: Farklı kullanım senaryoları için kart varyasyonları
/// EN: Card variations for different use cases

/// TR: Basit kart - İçerik ve padding ile
/// EN: Simple card - with content and padding
class KubbeSimpleCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  // TR: Constructor
  // EN: Constructor
  const KubbeSimpleCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return KubbeCard(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? EdgeInsets.zero,
      onTap: onTap,
      child: child,
    );
  }
}

/// TR: Başlıklı kart - Başlık ve içerik ile
/// EN: Titled card - with title and content
class KubbeTitledCard extends StatelessWidget {
  final String title;
  final Widget child;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  // TR: Constructor
  // EN: Constructor
  const KubbeTitledCard({
    super.key,
    required this.title,
    required this.child,
    this.titleStyle,
    this.margin,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TR: V4 başlık stili
    // EN: V4 title style
    final defaultTitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color:
              const Color(0xFF1A237E), // TR: KUBBE Indigo // EN: KUBBE Indigo
        );

    return KubbeCard(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(20.0),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TR: Başlık
          // EN: Title
          Text(
            title,
            style: titleStyle ?? defaultTitleStyle,
          ),
          // TR: Başlık ile içerik arası boşluk
          // EN: Space between title and content
          const SizedBox(height: 12.0),
          // TR: İçerik
          // EN: Content
          child,
        ],
      ),
    );
  }
}

/// TR: İkonlu kart - İkon, başlık ve içerik ile
/// EN: Icon card - with icon, title and content
class KubbeIconCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Color? iconColor;
  final double iconSize;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  // TR: Constructor
  // EN: Constructor
  const KubbeIconCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.iconColor,
    this.iconSize = 24.0,
    this.titleStyle,
    this.margin,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TR: V4 ikon rengi
    // EN: V4 icon color
    final defaultIconColor = iconColor ??
        const Color(0xFF9C27B0); // TR: KUBBE Purple // EN: KUBBE Purple

    // TR: V4 başlık stili
    // EN: V4 title style
    final defaultTitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color:
              const Color(0xFF1A237E), // TR: KUBBE Indigo // EN: KUBBE Indigo
        );

    return KubbeCard(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(20.0),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TR: İkon
          // EN: Icon
          Icon(
            icon,
            color: defaultIconColor,
            size: iconSize,
          ),
          // TR: İkon ile içerik arası boşluk
          // EN: Space between icon and content
          const SizedBox(width: 16.0),
          // TR: Başlık ve içerik
          // EN: Title and content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TR: Başlık
                // EN: Title
                Text(
                  title,
                  style: titleStyle ?? defaultTitleStyle,
                ),
                // TR: Başlık ile içerik arası boşluk
                // EN: Space between title and content
                const SizedBox(height: 8.0),
                // TR: İçerik
                // EN: Content
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// TR: Resimli kart - Resim, başlık ve içerik ile
/// EN: Image card - with image, title and content
class KubbeImageCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Widget child;
  final double imageHeight;
  final BoxFit imageFit;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  // TR: Constructor
  // EN: Constructor
  const KubbeImageCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.child,
    this.imageHeight = 120.0,
    this.imageFit = BoxFit.cover,
    this.titleStyle,
    this.margin,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TR: V4 başlık stili
    // EN: V4 title style
    final defaultTitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color:
              const Color(0xFF1A237E), // TR: KUBBE Indigo // EN: KUBBE Indigo
        );

    return KubbeCard(
      margin: margin ?? EdgeInsets.zero,
      padding:
          EdgeInsets.zero, // TR: Resim kenar boşluğu yok // EN: No image margin
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TR: Resim
          // EN: Image
          ClipRRect(
            // TR: Üst köşeler yuvarlak
            // EN: Rounded top corners
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
            child: Image.asset(
              imageUrl,
              height: imageHeight,
              width: double.infinity,
              fit: imageFit,
              errorBuilder: (context, error, stackTrace) {
                // TR: Resim yüklenemezse placeholder
                // EN: Placeholder if image fails to load
                return Container(
                  height: imageHeight,
                  color: const Color(
                      0xFFF5F5F5), // TR: Gri arka plan // EN: Gray background
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Color(0xFF9E9E9E), // TR: Gri ikon // EN: Gray icon
                      size: 48.0,
                    ),
                  ),
                );
              },
            ),
          ),
          // TR: Başlık ve içerik için padding
          // EN: Padding for title and content
          Padding(
            padding: padding ?? const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TR: Başlık
                // EN: Title
                Text(
                  title,
                  style: titleStyle ?? defaultTitleStyle,
                ),
                // TR: Başlık ile içerik arası boşluk
                // EN: Space between title and content
                const SizedBox(height: 12.0),
                // TR: İçerik
                // EN: Content
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// TR: Eylem kartı - Başlık, içerik ve eylem butonu ile
/// EN: Action card - with title, content and action button
class KubbeActionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final String actionText;
  final VoidCallback onAction;
  final TextStyle? titleStyle;
  final TextStyle? actionStyle;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  // TR: Constructor
  // EN: Constructor
  const KubbeActionCard({
    super.key,
    required this.title,
    required this.child,
    required this.actionText,
    required this.onAction,
    this.titleStyle,
    this.actionStyle,
    this.margin,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TR: V4 başlık stili
    // EN: V4 title style
    final defaultTitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color:
              const Color(0xFF1A237E), // TR: KUBBE Indigo // EN: KUBBE Indigo
        );

    // TR: V4 eylem butonu stili
    // EN: V4 action button style
    final defaultActionStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color:
              const Color(0xFF9C27B0), // TR: KUBBE Purple // EN: KUBBE Purple
        );

    return KubbeCard(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(20.0),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TR: Başlık
          // EN: Title
          Text(
            title,
            style: titleStyle ?? defaultTitleStyle,
          ),
          // TR: Başlık ile içerik arası boşluk
          // EN: Space between title and content
          const SizedBox(height: 12.0),
          // TR: İçerik
          // EN: Content
          child,
          // TR: İçerik ile eylem arası boşluk
          // EN: Space between content and action
          const SizedBox(height: 16.0),
          // TR: Eylem butonu
          // EN: Action button
          GestureDetector(
            onTap: onAction,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  actionText,
                  style: actionStyle ?? defaultActionStyle,
                ),
                // TR: Ok ikonu
                // EN: Arrow icon
                const SizedBox(width: 4.0),
                const Icon(
                  Icons.arrow_forward,
                  size: 16.0,
                  color:
                      Color(0xFF9C27B0), // TR: KUBBE Purple // EN: KUBBE Purple
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
