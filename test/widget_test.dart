import 'package:flutter_test/flutter_test.dart';
import 'package:dfb/app.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const DFBApp());
    await tester.pump();
  });
}
