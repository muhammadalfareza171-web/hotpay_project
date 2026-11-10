import 'package:flutter_test/flutter_test.dart';
import 'package:hotpay_app/main.dart';

void main() {
  testWidgets('HotPayApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HotPayApp());

    // Verify that the splash screen shows HotPay title
    expect(find.text('HotPay'), findsWidgets);
  });
}
