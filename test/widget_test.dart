// Bu temel Flutter widget testidir - This is a basic Flutter widget test
//
// Widget ile etkileşim kurmak için flutter_test paketindeki WidgetTester
// yardımcı programını kullanın - To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package

import 'package:flutter_test/flutter_test.dart';
import 'package:kubbe_app/main.dart';

// Ana test fonksiyonu - Main test function
void main() {
  // Uygulama başlatma testi - App startup test
  testWidgets('Uygulama başlatma testi - App startup test', (
    WidgetTester tester,
  ) async {
    // Uygulamayı oluştur ve çerçeveyi tetikle - Build our app and trigger a frame
    await tester.pumpWidget(const KubbeApp(isFirstLaunch: false));

    // Ana sayfanın yüklendiğini doğrula - Verify home page is loaded
    expect(find.text('Ana Sayfa'), findsOneWidget);
    expect(find.text('Kuran'), findsOneWidget);
    expect(find.text('Kıble'), findsOneWidget);
    expect(find.text('Araçlar'), findsOneWidget);
  });
}
