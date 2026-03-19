// TR: KUBBE V4 Mushaf Picker - V4 yeniliği
// EN: KUBBE V4 Mushaf Picker - V4 innovation
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: Kullanıcının yazı tipini (Hüsrev Hattı, Medine Hattı vb.) seçebileceği asil bir alt panel (BottomSheet) yap
// EN: Create a noble bottom panel (BottomSheet) where users can select font type (Husrev Script, Medina Script, etc.)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/storage/preferences_manager.dart';

/// TR: KUBBE V4 Mushaf Picker Sınıfı
/// EN: KUBBE V4 Mushaf Picker Class
/// TR: Yazı tipi seçimi için asil alt panel
/// EN: Noble bottom panel for font type selection
/// TR: Hüsrev Hattı, Medine Hattı, Naskh, Thuluth, Uthmani seçenekleri
/// EN: Husrev Script, Medina Script, Naskh, Thuluth, Uthmani options
/// TR: V4 estetiği ve Sy-OS design language
/// EN: V4 aesthetics and Sy-OS design language
/// TR: Haptic feedback ve smooth animasyonlar
/// EN: Haptic feedback and smooth animations
class MushafPicker extends ConsumerStatefulWidget {
  // TR: Constructor
  // EN: Constructor
  const MushafPicker({super.key});

  @override
  ConsumerState<MushafPicker> createState() => _MushafPickerState();
}

// TR: Mushaf Picker State
// EN: Mushaf Picker State
class _MushafPickerState extends ConsumerState<MushafPicker>
    with TickerProviderStateMixin {
  // TR: Animation controller
  // EN: Animation controller
  late AnimationController _animationController;

  // TR: Animation
  // EN: Animation
  late Animation<double> _scaleAnimation;

  // TR: Seçili font
  // EN: Selected font
  MushafFont? _selectedFont;

  // TR: Font seçenekleri
  // EN: Font options
  final List<MushafFont> _fonts = [
    // TR: Hüsrev Hattı
    // EN: Husrev Script
    const MushafFont(
      id: 'husrev',
      name: 'Hüsrev Hattı',
      description: 'Klasik Osmanlı yazı stili',
      fontPath: 'assets/fonts/husrev.ttf',
      previewText: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
      color: '#8B4513', // TR: Kahverengi // EN: Brown
      icon: Icons.history_edu,
      isDefault: true,
    ),

    // TR: Medine Hattı
    // EN: Medina Script
    const MushafFont(
      id: 'medine',
      name: 'Medine Hattı',
      description: 'Modern ve okunaklı yazı stili',
      fontPath: 'assets/fonts/medine.ttf',
      previewText: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
      color: '#2E7D32', // TR: Yeşil // EN: Green
      icon: Icons.auto_stories,
      isDefault: false,
    ),

    // TR: Naskh
    // EN: Naskh
    const MushafFont(
      id: 'naskh',
      name: 'Naskh',
      description: 'Kufi yazı stili',
      fontPath: 'assets/fonts/naskh.ttf',
      previewText: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
      color: '#1565C0', // TR: Mavi // EN: Blue
      icon: Icons.text_format,
      isDefault: false,
    ),

    // TR: Thuluth
    // EN: Thuluth
    const MushafFont(
      id: 'thuluth',
      name: 'Thuluth',
      description: 'Arapça kaligrafi stili',
      fontPath: 'assets/fonts/thuluth.ttf',
      previewText: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
      color: '#6A1B9A', // TR: Mor // EN: Purple
      icon: Icons.brush,
      isDefault: false,
    ),

    // TR: Uthmani
    // EN: Uthmani
    const MushafFont(
      id: 'uthmani',
      name: 'Uthmani',
      description: 'Modern Arapça yazı stili',
      fontPath: 'assets/fonts/uthmani.ttf',
      previewText: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
      color: '#D32F2F', // TR: Kırmızı // EN: Red
      icon: Icons.text_fields,
      isDefault: false,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // TR: Animation controller'ı başlat
    // EN: Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // TR: Animation'u ayarla
    // EN: Set up animation
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    // TR: Animation'u başlat
    // EN: Start animation
    _animationController.forward();

    // TR: Mevcut font'u yükle
    // EN: Load current font
    _loadCurrentFont();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // TR: Mevcut font'u yükle
  // EN: Load current font
  void _loadCurrentFont() {
    final preferences = ref.read(preferencesStateProvider);
    final fontId = preferences.selectedMushafFont;

    setState(() {
      _selectedFont = _fonts.firstWhere(
        (font) => font.id == fontId,
        orElse: () => _fonts.firstWhere((font) => font.isDefault),
      );
    });
  }

  // TR: Font seç
  // EN: Select font
  Future<void> _selectFont(MushafFont font) async {
    // TR: Haptic feedback
    // EN: Haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _selectedFont = font;
    });

    // TR: Preferences'e kaydet
    // EN: Save to preferences
    final prefsManager = PreferencesManager();
    await prefsManager.setMushafFont(font.id);

    // TR: Animation'u yeniden başlat
    // EN: Restart animation
    _animationController.reset();
    _animationController.forward();

    // TR: Modal'ı kapat
    // EN: Close modal
    final navigatorContext = context;
    await Future.delayed(const Duration(milliseconds: 500));
    if (navigatorContext.mounted) {
      Navigator.of(navigatorContext).pop(font);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          // TR: Modal container
          // EN: Modal container
          child: Container(
            decoration: BoxDecoration(
              // TR: 32dp radius üst köşeler
              // EN: 32dp radius top corners
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
              // TR: Gradient arka plan
              // EN: Gradient background
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withValues(alpha: 0.95),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              // TR: Gölge
              // EN: Shadow
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20.0,
                  offset: const Offset(0, -4),
                  spreadRadius: 2,
                ),
              ],
            ),
            // TR: Modal içeriği
            // EN: Modal content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TR: Başlık
                // EN: Header
                _buildHeader(),

                // TR: Font listesi
                // EN: Font list
                _buildFontList(),

                // TR: Alt boşluk
                // EN: Bottom padding
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        );
      },
    );
  }

  // TR: Başlık oluştur
  // EN: Build header
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      // TR: Başlık içeriği
      // EN: Header content
      child: Column(
        children: [
          // TR: Çizgi
          // EN: Line
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              // TR: 2dp radius
              // EN: 2dp radius
              borderRadius: BorderRadius.circular(2.0),
              // TR: Gradient arka plan
              // EN: Gradient background
              gradient: LinearGradient(
                colors: [
                  KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                  KubbeTheme.kubbeIndigo.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 16.0),

          // TR: Başlık metni
          // EN: Header text
          Text(
            'Yazı Tipi Seçimi',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),

          // TR: Alt başlık
          // EN: Subtitle
          Text(
            'Kur\'an-ı Kerim okuma stilinizi seçin',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black87.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  // TR: Font listesi oluştur
  // EN: Build font list
  Widget _buildFontList() {
    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      // TR: Font listesi
      // EN: Font list
      child: ListView(
        children: _fonts.map((font) {
          return _buildFontOption(font);
        }).toList(),
      ),
    );
  }

  // TR: Font seçeneği oluştur
  // EN: Build font option
  Widget _buildFontOption(MushafFont font) {
    final isSelected = _selectedFont?.id == font.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      // TR: Seçenek container
      // EN: Option container
      child: GestureDetector(
        onTap: () => _selectFont(font),
        // TR: Seçenek içeriği
        // EN: Option content
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            // TR: 16dp radius
            // EN: 16dp radius
            borderRadius: BorderRadius.circular(16.0),
            // TR: Gradient arka plan
            // EN: Gradient background
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      Color(int.parse(font.color.replaceFirst('#', '0xFF'))),
                      Color(int.parse(font.color.replaceFirst('#', '0xFF')))
                          .withValues(alpha: 0.8),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withValues(alpha: 0.95),
                    ],
                  ),
            // TR: Kenar
            // EN: Border
            border: Border.all(
              color: isSelected
                  ? Color(int.parse(font.color.replaceFirst('#', '0xFF')))
                  : Colors.black.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
            // TR: Gölge
            // EN: Shadow
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Color(int.parse(font.color.replaceFirst('#', '0xFF')))
                        .withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: isSelected ? 12.0 : 6.0,
                offset: const Offset(0, 2),
                spreadRadius: isSelected ? 2 : 1,
              ),
            ],
          ),
          // TR: Seçenek içeriği
          // EN: Option content
          child: Row(
            children: [
              // TR: İkon
              // EN: Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  // TR: Yuvarlak
                  // EN: Circle
                  shape: BoxShape.circle,
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withValues(alpha: 0.9),
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            Color(int.parse(
                                font.color.replaceFirst('#', '0xFF'))),
                            Color(int.parse(
                                    font.color.replaceFirst('#', '0xFF')))
                                .withValues(alpha: 0.8),
                          ],
                        ),
                ),
                // TR: İkon içeriği
                // EN: Icon content
                child: Center(
                  child: Icon(
                    font.icon,
                    size: 24,
                    color: isSelected
                        ? Color(int.parse(font.color.replaceFirst('#', '0xFF')))
                        : Colors.white,
                  ),
                ),
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(width: 16.0),

              // TR: Metin
              // EN: Text
              Expanded(
                // TR: Metin içeriği
                // EN: Text content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TR: Başlık
                    // EN: Title
                    Text(
                      font.name,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),

                    // TR: Açıklama
                    // EN: Description
                    Text(
                      font.description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.black87.withValues(alpha: 0.7),
                      ),
                    ),

                    // TR: Önizleme
                    // EN: Preview
                    Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        // TR: 8dp radius
                        // EN: 8dp radius
                        borderRadius: BorderRadius.circular(8.0),
                        // TR: Gradient arka plan
                        // EN: Gradient background
                        gradient: LinearGradient(
                          colors: [
                            isSelected
                                ? Colors.white.withValues(alpha: 0.2)
                                : Color(int.parse(
                                        font.color.replaceFirst('#', '0xFF')))
                                    .withValues(alpha: 0.1),
                            isSelected
                                ? Colors.white.withValues(alpha: 0.1)
                                : Color(int.parse(
                                        font.color.replaceFirst('#', '0xFF')))
                                    .withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      // TR: Önizleme metni
                      // EN: Preview text
                      child: Text(
                        font.previewText,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Color(int.parse(
                                  font.color.replaceFirst('#', '0xFF'))),
                          height: 1.5,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),

              // TR: Seçim ikonu
              // EN: Selection icon
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    // TR: Yuvarlak
                    // EN: Circle
                    shape: BoxShape.circle,
                    // TR: Gradient arka plan
                    // EN: Gradient background
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                  // TR: İkon içeriği
                  // EN: Icon content
                  child: Center(
                    child: Icon(
                      Icons.check,
                      size: 16,
                      color: Color(
                          int.parse(font.color.replaceFirst('#', '0xFF'))),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// TR: Mushaf Font Modeli - V4 yeniliği
/// EN: Mushaf Font Model - V4 innovation
/// TR: Font veri modeli
/// EN: Font data model
class MushafFont {
  // TR: Font ID'si
  // EN: Font ID
  final String id;

  // TR: Font adı
  // EN: Font name
  final String name;

  // TR: Açıklama
  // EN: Description
  final String description;

  // TR: Font yolu
  // EN: Font path
  final String fontPath;

  // TR: Önizleme metni
  // EN: Preview text
  final String previewText;

  // TR: Renk
  // EN: Color
  final String color;

  // TR: İkon
  // EN: Icon
  final IconData icon;

  // TR: Varsayılan mı
  // EN: Is default
  final bool isDefault;

  // TR: Constructor
  // EN: Constructor
  const MushafFont({
    required this.id,
    required this.name,
    required this.description,
    required this.fontPath,
    required this.previewText,
    required this.color,
    required this.icon,
    required this.isDefault,
  });

  // TR: To JSON
  // EN: To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fontPath': fontPath,
      'previewText': previewText,
      'color': color,
      'icon': icon.codePoint,
      'isDefault': isDefault,
    };
  }

  // TR: From JSON
  // EN: From JSON
  factory MushafFont.fromJson(Map<String, dynamic> json) {
    return MushafFont(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      fontPath: json['fontPath'] as String,
      previewText: json['previewText'] as String,
      color: json['color'] as String,
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      isDefault: json['isDefault'] as bool,
    );
  }

  // TR: CopyWith
  // EN: CopyWith
  MushafFont copyWith({
    String? id,
    String? name,
    String? description,
    String? fontPath,
    String? previewText,
    String? color,
    IconData? icon,
    bool? isDefault,
  }) {
    return MushafFont(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      fontPath: fontPath ?? this.fontPath,
      previewText: previewText ?? this.previewText,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  // TR: Equality operator
  // EN: Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MushafFont &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.fontPath == fontPath &&
        other.previewText == previewText &&
        other.color == color &&
        other.icon == icon &&
        other.isDefault == isDefault;
  }

  // TR: Hash code
  // EN: Hash code
  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      fontPath,
      previewText,
      color,
      icon,
      isDefault,
    );
  }

  // TR: String representation
  // EN: String representation
  @override
  String toString() {
    return 'MushafFont(id: $id, name: $name, isDefault: $isDefault)';
  }
}

/// TR: Mushaf Picker Helper - V4 yeniliği
/// EN: Mushaf Picker Helper - V4 innovation
/// TR: MushafPicker için yardımcı fonksiyonlar
/// EN: Helper functions for MushafPicker
class MushafPickerHelper {
  // TR: Mushaf picker göster
  // EN: Show mushaf picker
  static Future<MushafFont?> showMushafPicker(BuildContext context) {
    return showModalBottomSheet<MushafFont>(
      context: context,
      // TR: Arka plan
      // EN: Background
      backgroundColor: Colors.transparent,
      // TR: Builder
      // EN: Builder
      builder: (context) {
        return const MushafPicker();
      },
    );
  }

  // TR: Font seçeneklerini al
  // EN: Get font options
  static List<MushafFont> getFontOptions() {
    return [
      const MushafFont(
        id: 'husrev',
        name: 'Hüsrev Hattı',
        description: 'Klasik Osmanlı yazı stili',
        fontPath: 'assets/fonts/husrev.ttf',
        previewText: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
        color: '#8B4513',
        icon: Icons.history_edu,
        isDefault: true,
      ),
      const MushafFont(
        id: 'medine',
        name: 'Medine Hattı',
        description: 'Modern ve okunaklı yazı stili',
        fontPath: 'assets/fonts/medine.ttf',
        previewText: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
        color: '#2E7D32',
        icon: Icons.auto_stories,
        isDefault: false,
      ),
      const MushafFont(
        id: 'naskh',
        name: 'Naskh',
        description: 'Kufi yazı stili',
        fontPath: 'assets/fonts/naskh.ttf',
        previewText: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
        color: '#1565C0',
        icon: Icons.text_format,
        isDefault: false,
      ),
      const MushafFont(
        id: 'thuluth',
        name: 'Thuluth',
        description: 'Arapça kaligrafi stili',
        fontPath: 'assets/fonts/thuluth.ttf',
        previewText: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
        color: '#6A1B9A',
        icon: Icons.brush,
        isDefault: false,
      ),
      const MushafFont(
        id: 'uthmani',
        name: 'Uthmani',
        description: 'Modern Arapça yazı stili',
        fontPath: 'assets/fonts/uthmani.ttf',
        previewText: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
        color: '#D32F2F',
        icon: Icons.text_fields,
        isDefault: false,
      ),
    ];
  }

  // TR: ID'ye göre font al
  // EN: Get font by ID
  static MushafFont? getFontById(String id) {
    final fonts = getFontOptions();
    try {
      return fonts.firstWhere((font) => font.id == id);
    } catch (e) {
      return null;
    }
  }

  // TR: Varsayılan font'u al
  // EN: Get default font
  static MushafFont getDefaultFont() {
    final fonts = getFontOptions();
    return fonts.firstWhere((font) => font.isDefault);
  }

  // TR: Font rengini al
  // EN: Get font color
  static Color getFontColor(String colorHex) {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  // TR: Font adını formatla
  // EN: Format font name
  static String formatFontName(String name) {
    return name.replaceAll(' ', '_').toLowerCase();
  }
}

/// TR: Mushaf Font Provider - V4 yeniliği
/// EN: Mushaf Font Provider - V4 innovation
/// TR: Riverpod ile entegrasyon
/// EN: Integration with Riverpod
final mushafFontProvider = Provider<MushafFont>((ref) {
  final preferences = ref.watch(preferencesStateProvider);
  final fontId = preferences.selectedMushafFont;

  final font = MushafPickerHelper.getFontById(fontId);
  return font ?? MushafPickerHelper.getDefaultFont();
});

/// TR: All Mushaf Fonts Provider - V4 yeniliği
/// EN: All Mushaf Fonts Provider - V4 innovation
final allMushafFontsProvider = Provider<List<MushafFont>>((ref) {
  return MushafPickerHelper.getFontOptions();
});
