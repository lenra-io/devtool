import 'package:client/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Main test', (WidgetTester tester) async {
    await tester.pumpWidget(DevTools());

    expect(find.byType(DevTools), findsOneWidget);
  });
}