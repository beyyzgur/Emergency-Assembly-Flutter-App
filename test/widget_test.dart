import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:emergency_assembly_app/main.dart';

void main() {
  testWidgets('Uygulama açılır', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    expect(find.text('Emergency Assembly — foundation'), findsOneWidget);
  });
}
