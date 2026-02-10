import 'package:evento/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EventoAdminApp());
    expect(find.text('Evento Admin'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
