import 'package:flutter_test/flutter_test.dart';
import 'package:hotpay_app/main.dart';

void main() {
  testWidgets('Splash HotPay tampil dengan tombol mulai', (WidgetTester tester) async {
    await tester.pumpWidget(const HotPayApp());

    expect(find.text('HotPay'), findsOneWidget);
    expect(find.text('Mulai Pesan Sekarang'), findsOneWidget);
  });
}
