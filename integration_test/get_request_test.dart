import 'package:flutter/material.dart';
import 'package:new_flutter_template/main.dart' as mainEntry;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end Get request test', () {
    /// The test sends Get Request and checks that status code of the response is 200
    testWidgets('Get request test', (tester) async {
      // Start the app
      mainEntry.main();
      await tester.pumpAndSettle();
      await tester.pump(
        const Duration(
          seconds: 1,
        ),
      );

      // Find the "API" button
      final apiButton = find.byIcon(
        Icons.data_object_rounded,
      );
      await tester.tap(apiButton);
      await tester.pump(
        const Duration(
          seconds: 2,
        ),
      );

      // Verify if the API page 1 is displayed and tap continue
      expect(find.text('GET & POST requests'), findsOneWidget);
      final sendButton = find.byIcon(
        Icons.android_rounded,
      );

      /// Tap on Send Button
      await tester.tap(sendButton);
      await tester.pump(
        const Duration(
          seconds: 5,
        ),
      );

      final response = find.textContaining(RegExp(r'ddd'));

      expect(response.hasFound, isTrue, reason: '200 Status code is expected');
    });
  });
}
