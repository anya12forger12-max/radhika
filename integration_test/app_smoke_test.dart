import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:radhika/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Radhika smoke tests', () {
    testWidgets('app launches without crashing', (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      // Verify the app renders something (splash or login screen)
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
