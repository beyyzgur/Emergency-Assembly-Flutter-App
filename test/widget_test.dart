import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:emergency_assembly_app/main.dart';

void main() {
  testWidgets('Uygulama açılır', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    expect(find.byType(MaterialApp), findsOneWidget);

    // MyApp, yerel açılış ekranı için en fazla beş saniyelik bir zamanlayıcı
    // kurar. Test sonlanmadan bu zamanlayıcıyı çalıştırmak gerekir.
    await tester.pump(const Duration(seconds: 5));
  });
}
