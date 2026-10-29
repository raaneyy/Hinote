import 'package:flutter_test/flutter_test.dart';
import 'package:hiyote/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HiyoteApp());
    expect(find.byType(HiyoteApp), findsOneWidget);
  });
}
