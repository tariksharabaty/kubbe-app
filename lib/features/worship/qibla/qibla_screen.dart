// TR: KUBBE V4 Kible Pusulası Ekranı - V1'den miras alındı
// EN: KUBBE V4 Qibla Compass Screen - Inherited from V1
// TR: Tüm kodlarda çift dilde yorum satırı kullan (// TR: ... // EN: ...)
// EN: Use double language comment lines in all code
// TR: 32dp radius'lu bir pusula kadranı tasarla. Kabe yönüne gelince hafif bir titreşim (Haptic) ver.
// EN: Design a 32dp radius compass dial. Give a light haptic feedback when facing Kaaba direction.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptic_utils.dart';
import 'qibla_provider.dart';

/// TR: KUBBE V4 Kible Pusulası Widget'ı
/// EN: KUBBE V4 Qibla Compass Widget
/// TR: V1'deki kible pusulası mantığını modern Flutter ile birleştirir
/// EN: Combines V1's qibla compass logic with modern Flutter
/// TR: 32dp radius'lu pusula kadranı ve görsel geri bildirim
/// EN: 32dp radius compass dial and visual feedback
/// TR: Kabe yönüne gelince titreşim ve görsel uyarı
/// EN: Haptic and visual warning when facing Kaaba direction
/// TR: V4 estetiği ve Sy-OS design language
/// EN: V4 aesthetics and Sy-OS design language
class QiblaScreen extends ConsumerWidget {
  // TR: Constructor
  // EN: Constructor
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TR: Kible durumunu izle
    // EN: Watch qibla state
    final qiblaState = ref.watch(qiblaProvider);
    final qiblaNotifier = ref.read(qiblaProvider.notifier);

    return Scaffold(
      // TR: AppBar
      // EN: AppBar
      appBar: AppBar(
        // TR: Başlık
        // EN: Title
        title: Text(
          'Kible Pusulası',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // TR: Arka plan
        // EN: Background
        backgroundColor: KubbeTheme.kubbeIndigo,
        // TR: Gölge kaldır
        // EN: Remove shadow
        elevation: 0,
        // TR: Eylemler
        // EN: Actions
        actions: [
          // TR: Yardım ikonu
          // EN: Help icon
          IconButton(
            onPressed: () {
              // TR: Yardım dialog'u göster
              // EN: Show help dialog
              _showHelpDialog(context);
            },
            // TR: İkon
            // EN: Icon
            icon: const Icon(
              Icons.help,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),

      // TR: Gövde
      // EN: Body
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // TR: Gradient arka plan
        // EN: Gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              KubbeTheme.kubbeIndigo,
              KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // TR: İçerik
        // EN: Content
        child: SafeArea(
          // TR: Ana içerik
          // EN: Main content
          child: Column(
            children: [
              // TR: Üst bilgi bölümü
              // EN: Top info section
              _buildTopInfo(context, ref, qiblaState),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 20.0),

              // TR: Ana pusula kadranı
              // EN: Main compass dial
              Expanded(
                // TR: Pusula kadranı
                // EN: Compass dial
                child: _buildCompassDial(context, qiblaState, qiblaNotifier),
              ),

              // TR: Boşluk
              // EN: Spacer
              const SizedBox(height: 20.0),

              // TR: Alt kontrol bölümü
              // EN: Bottom control section
              _buildBottomControls(context, qiblaState, qiblaNotifier),
            ],
          ),
        ),
      ),
    );
  }

  // TR: Üst bilgi bölümü oluştur
  // EN: Build top info section
  Widget _buildTopInfo(BuildContext context, WidgetRef ref, QiblaState state) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(32.0),
        // TR: Beyaz arka plan
        // EN: White background
        color: Colors.white.withValues(alpha: 0.1),
        // TR: Kenar
        // EN: Border
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      // TR: İçerik
      // EN: Content
      child: Column(
        children: [
          // TR: Başlık
          // EN: Title
          Text(
            'Kible Yönü',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 8.0),

          // TR: Konum bilgisi
          // EN: Location information
          if (state.latitude != null && state.longitude != null)
            Text(
              'Konum: ${state.latitude!.toStringAsFixed(4)}, ${state.longitude!.toStringAsFixed(4)}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 8.0),

          // TR: Mesafe bilgisi
          // EN: Distance information
          Text(
            ref.read(qiblaProvider.notifier).getDistanceText(),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // TR: Ana pusula kadranı oluştur
  // EN: Build main compass dial
  Widget _buildCompassDial(
    BuildContext context,
    QiblaState state,
    QiblaNotifier notifier,
  ) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(16.0),
      // TR: Pusula kadranı
      // EN: Compass dial
      child: Container(
        // TR: 32dp radius
        // EN: 32dp radius
        decoration: BoxDecoration(
          // TR: Yuvarlak
          // EN: Circle
          shape: BoxShape.circle,
          // TR: Beyaz arka plan
          // EN: White background
          color: Colors.white,
          // TR: Gölge
          // EN: Shadow
          boxShadow: [
            BoxShadow(
              color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
              spreadRadius: 5,
            ),
          ],
        ),
        // TR: İçerik
        // EN: Content
        child: Stack(
          // TR: Alignment
          // EN: Alignment
          alignment: Alignment.center,
          children: [
            // TR: Pusula çemberi
            // EN: Compass circle
            Container(
              width: double.infinity,
              height: double.infinity,
              // TR: Kenar
              // EN: Border
              decoration: BoxDecoration(
                // TR: Yuvarlak
                // EN: Circle
                shape: BoxShape.circle,
                // TR: Kenar
                // EN: Border
                border: Border.all(
                  color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            ),

            // TR: Kible yönü göstergesi
            // EN: Qibla direction indicator
            if (state.isSensorActive)
              Positioned.fill(
                // TR: Kible yönü
                // EN: Qibla direction
                child: Transform.rotate(
                  // TR: Dönüş açısı
                  // EN: Rotation angle
                  angle: -state.qiblaAngle * (3.14159 / 180),
                  // TR: Kible göstergesi
                  // EN: Qibla indicator
                  child: Container(
                    // TR: Kible çizgisi
                    // EN: Qibla line
                    alignment: Alignment.topCenter,
                    // TR: Çizgi
                    // EN: Line
                    child: Container(
                      height: 40,
                      width: 4,
                      // TR: Kible rengi
                      // EN: Qibla color
                      decoration: BoxDecoration(
                        // TR: Renk
                        // EN: Color
                        color: Colors.green,
                        // TR: Yuvarlak
                        // EN: Rounded
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),

            // TR: Mevcut yön göstergesi
            // EN: Current direction indicator
            if (state.isSensorActive)
              Positioned.fill(
                // TR: Mevcut yön
                // EN: Current direction
                child: Transform.rotate(
                  // TR: Dönüş açısı
                  // EN: Rotation angle
                  angle: -state.currentAngle * (3.14159 / 180),
                  // TR: Yön göstergesi
                  // EN: Direction indicator
                  child: Container(
                    // TR: Yön çizgisi
                    // EN: Direction line
                    alignment: Alignment.topCenter,
                    // TR: Çizgi
                    // EN: Line
                    child: Container(
                      height: 50,
                      width: 6,
                      // TR: Yön rengi
                      // EN: Direction color
                      decoration: BoxDecoration(
                        // TR: Renk
                        // EN: Color
                        color: state.isFacingQibla
                            ? Colors.green
                            : KubbeTheme.kubbeIndigo,
                        // TR: Yuvarlak
                        // EN: Rounded
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),

            // TR: Merkez daire
            // EN: Center circle
            Center(
              // TR: Merkez içeriği
              // EN: Center content
              child: Container(
                width: 80,
                height: 80,
                // TR: Merkez dekorasyon
                // EN: Center decoration
                decoration: BoxDecoration(
                  // TR: Yuvarlak
                  // EN: Circle
                  shape: BoxShape.circle,
                  // TR: Gradient arka plan
                  // EN: Gradient background
                  gradient: LinearGradient(
                    colors: [
                      KubbeTheme.kubbeIndigo,
                      KubbeTheme.kubbeIndigo.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // TR: Gölge
                  // EN: Shadow
                  boxShadow: [
                    BoxShadow(
                      color: KubbeTheme.kubbeIndigo.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                // TR: Merkez içeriği
                // EN: Center content
                child: Column(
                  // TR: MainAxisAlignment
                  // EN: MainAxisAlignment
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TR: Kible ikonu
                    // EN: Qibla icon
                    const Icon(
                      Icons.explore,
                      color: Colors.white,
                      size: 30,
                    ),

                    // TR: Boşluk
                    // EN: Spacer
                    const SizedBox(height: 4.0),

                    // TR: Yön metni
                    // EN: Direction text
                    Text(
                      notifier.getDirectionText(state.angleDifference),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // TR: Kible yönü metni
            // EN: Qibla direction text
            if (state.isFacingQibla)
              Positioned(
                // TR: Üst konum
                // EN: Top position
                top: 20,
                // TR: Sol konum
                // EN: Left position
                left: 20,
                // TR: Kible bildirimi
                // EN: Qibla notification
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  // TR: Bildirim dekorasyonu
                  // EN: Notification decoration
                  decoration: BoxDecoration(
                    // TR: 16dp radius
                    // EN: 16dp radius
                    borderRadius: BorderRadius.circular(16.0),
                    // TR: Yeşil arka plan
                    // EN: Green background
                    color: Colors.green,
                    // TR: Gölge
                    // EN: Shadow
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  // TR: Bildirim metni
                  // EN: Notification text
                  child: Text(
                    'KIBLE',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // TR: Hata mesajı
            // EN: Error message
            if (state.errorMessage != null)
              Positioned(
                // TR: Alt konum
                // EN: Bottom position
                bottom: 20,
                // TR: Sol konum
                // EN: Left position
                left: 20,
                // TR: Sağ konum
                // EN: Right position
                right: 20,
                // TR: Hata bildirimi
                // EN: Error notification
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  // TR: Hata dekorasyonu
                  // EN: Error decoration
                  decoration: BoxDecoration(
                    // TR: 16dp radius
                    // EN: 16dp radius
                    borderRadius: BorderRadius.circular(16.0),
                    // TR: Kırmızı arka plan
                    // EN: Red background
                    color: Colors.red.withValues(alpha: 0.8),
                  ),
                  // TR: Hata metni
                  // EN: Error text
                  child: Text(
                    state.errorMessage!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // TR: Alt kontrol bölümü oluştur
  // EN: Build bottom control section
  Widget _buildBottomControls(
    BuildContext context,
    QiblaState state,
    QiblaNotifier notifier,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // TR: 32dp radius
        // EN: 32dp radius
        borderRadius: BorderRadius.circular(32.0),
        // TR: Beyaz arka plan
        // EN: White background
        color: Colors.white.withValues(alpha: 0.1),
        // TR: Kenar
        // EN: Border
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      // TR: İçerik
      // EN: Content
      child: Column(
        children: [
          // TR: Durum metni
          // EN: Status text
          Text(
            state.isFacingQibla
                ? '🌸 MashaAllah! Kıbleye dönük durumdasınız.'
                : 'Cihazınızı kible yönüne çevirin. Allah (cc) sizinle olsun.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,
            ),
          ),

          // TR: Boşluk
          // EN: Spacer
          const SizedBox(height: 16.0),

          // TR: Kontrol butonu
          // EN: Control button
          GestureDetector(
            // TR: Dokunma
            // EN: On tap
            onTap: () {
              // TR: Titreşim ver
              // EN: Give haptic feedback
              HapticUtils.mediumImpact();

              // TR: Pusulayı başlat/durdur
              // EN: Start/stop compass
              if (state.isSensorActive) {
                notifier.stopCompass();
              } else {
                notifier.startCompass();
              }
            },
            // TR: Buton
            // EN: Button
            child: Container(
              width: 60,
              height: 60,
              // TR: Buton dekorasyonu
              // EN: Button decoration
              decoration: BoxDecoration(
                // TR: Yuvarlak
                // EN: Circle
                shape: BoxShape.circle,
                // TR: Gradient arka plan
                // EN: Gradient background
                gradient: LinearGradient(
                  colors: state.isSensorActive
                      ? [Colors.red, Colors.red.withValues(alpha: 0.8)]
                      : [Colors.green, Colors.green.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // TR: Gölge
                // EN: Shadow
                boxShadow: [
                  BoxShadow(
                    color: (state.isSensorActive ? Colors.red : Colors.green)
                        .withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              // TR: İkon içeriği
              // EN: Icon content
              child: Center(
                // TR: İkon
                // EN: Icon
                child: Icon(
                  state.isSensorActive ? Icons.stop : Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TR: Yardım dialog'u göster
  // EN: Show help dialog
  void _showHelpDialog(BuildContext context) {
    showDialog(
      // TR: Dialog
      // EN: Dialog
      context: context,
      builder: (BuildContext context) {
        // TR: AlertDialog
        // EN: AlertDialog
        return AlertDialog(
          // TR: Başlık
          // EN: Title
          title: Text(
            'Kible Pusulası Yardım',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KubbeTheme.kubbeIndigo,
            ),
          ),
          // TR: İçerik
          // EN: Content
          content: Column(
            // TR: Ana içerik
            // EN: Main content
            mainAxisSize: MainAxisSize.min,
            children: [
              // TR: Kullanım bilgisi
              // EN: Usage information
              ListTile(
                // TR: Başlık
                // EN: Title
                title: Text(
                  'Nasıl Kullanılır?',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // TR: Alt başlık
                // EN: Subtitle
                subtitle: Text(
                  '1. Başlat butonuna basın\n2. Cihazınızı yavaşça çevirin\n3. Kıble yönüne gelince yeşil ışık yanar',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                // TR: İkon
                // EN: Icon
                leading: const Icon(
                  Icons.info,
                  color: KubbeTheme.kubbeIndigo,
                ),
              ),

              // TR: Hassasiyet bilgisi
              // EN: Accuracy information
              ListTile(
                // TR: Başlık
                // EN: Title
                title: Text(
                  'Hassasiyet',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // TR: Alt başlık
                // EN: Subtitle
                subtitle: Text(
                  '±5 derece hassasiyet ile kible yönünü belirler',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                // TR: İkon
                // EN: Icon
                leading: const Icon(
                  Icons.gps_fixed,
                  color: KubbeTheme.kubbeIndigo,
                ),
              ),
            ],
          ),
          // TR: Butonlar
          // EN: Actions
          actions: [
            // TR: Kapat butonu
            // EN: Close button
            TextButton(
              // TR: Metin
              // EN: Text
              onPressed: () {
                // TR: Dialog'u kapat
                // EN: Close dialog
                Navigator.of(context).pop();
              },
              // TR: Stil
              // EN: Style
              style: TextButton.styleFrom(
                // TR: Metin rengi
                // EN: Text color
                foregroundColor: KubbeTheme.kubbeIndigo,
              ),
              // TR: Metin
              // EN: Text
              child: Text(
                'Kapat',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
