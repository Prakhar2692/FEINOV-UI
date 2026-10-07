import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:feinov_ui/main.dart';

void main() {
  testWidgets('Feinov app builds with a MaterialApp shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: FeinovApp()));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('FEINOV'), findsOneWidget);
  });
}
