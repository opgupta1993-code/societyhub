import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:societyhub/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SocietyHubApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Login Screen renders with the header text
    expect(find.textContaining('Your society'), findsOneWidget);
  });
}
