import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:cbb_bluechips_mobile/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App builds and shows a MaterialApp', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CbbBlueChipsApp());

    // Verifies the root MaterialApp exists.
    expect(find.byType(MaterialApp), findsOneWidget);

    // Let initial frames settle (e.g., SplashScreen animations/timers).
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    // Sanity check: no exceptions thrown during first build.
    expect(tester.takeException(), isNull);
  });
}
