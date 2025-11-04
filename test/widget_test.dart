// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

<<<<<<< HEAD
import 'package:mobileprogramming_aplikasi_kalkulator_digital_pajakin_aja/main.dart';
=======
<<<<<<< HEAD
import 'package:mobileprogramming_aplikasi_kalkulator_pajak_pajakinaja/main.dart';
=======
import 'package:pajakin_aja/main.dart';
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
>>>>>>> 1430f5cddce99cb320d408ffac2c47989ea3b856

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
