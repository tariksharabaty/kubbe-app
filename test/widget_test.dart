import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kubbe/main.dart';

void main() {
  testWidgets('KUBBE V4 app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: KUBBEV4()));

    // Verify that the app loads with navigation
    expect(find.text('KUBBE V4'), findsOneWidget);
    expect(find.text('Hoş Geldiniz'), findsOneWidget);
  });
}
