import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import 'payment_failed_sheet.dart';
import 'payment_success_sheet.dart';

/// Ubah ke false saat sudah tersambung ke payment gateway sungguhan.
const bool kDemoMode = true;

class QrisPayScreen extends StatefulWidget {
  final Order order;
  const QrisPayScreen({super.key, required this.order});
  @override
  State<QrisPayScreen> createState() => _QrisPayScreenState();
}

class _QrisPayScreenState extends State<QrisPayScreen> {
  static const limit = 300;
  int left = limit;
  int seed = 1;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    seed = widget.order.no.hashCode;
    _start();
  }

  void _start() {
    timer?.cancel();
    left = limit;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => left--);
      if (left <= 0) {
        t.cancel();
        showPaymentFailedSheet(context, widget.order, () => setState(() {
              seed++;
              _start();
            }));
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _paid() {
    timer?.cancel();
    showPaymentSuccessSheet(context, widget.order);
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
          BrandHeader(showBack: true, subtitle: 'PEMBAYARAN', trailing: AvatarButton(onTap: () {})),
          Panel(
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('No. Pesanan', style: ts(9, c: AppColors.muted)),
                Text('#${o.no}', style: ts(16, w: FontWeight.w800)),
              ]),
              const Spacer(),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('Total Tagihan', style: ts(9, c: AppColors.muted)),
                Text(rp(o.total), style: ts(18, w: FontWeight.w800, c: AppColors.brown)),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          Panel(
            child: Column(children: [
              Row(children: [
                Text('QRIS', style: ts(14, w: FontWeight.w800)),
                const Spacer(),
                Text('GPN', style: ts(12, w: FontWeight.w800, c: AppColors.red)),
              ]),
              const SizedBox(height: 10),
              Container(
                width: 220,
                height: 220,
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                // TODO: ganti dengan QR asli dari payment gateway (mis. paket qr_flutter).
                child: CustomPaint(painter: _FakeQrPainter(seed)),
              ),
              const SizedBox(height: 12),
              pill('Bayar sebelum:  ${two(left ~/ 60)}:${two(left % 60)}', AppColors.orangeSoft, AppColors.brown, size: 11),
              const SizedBox(height: 10),
              Text('Pindai kode QR di atas menggunakan aplikasi e-wallet atau mobile banking favorit Anda.',
                  textAlign: TextAlign.center, style: ts(10, c: AppColors.muted, h: 1.4)),
            ]),
          ),
          const SizedBox(height: 12),
          SoftButton(label: 'SIMPAN KODE QR KE GALERI', icon: Icons.download, onPressed: () => comingSoon(context)),
          if (kDemoMode) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _paid,
              child: Text('[Demo] Simulasikan pembayaran berhasil', style: ts(11, w: FontWeight.w700, c: AppColors.muted)),
            ),
          ],
        ]),
      ),
    );
  }
}

/// QR tiruan hanya untuk tampilan. BUKAN kode QR yang dapat dipindai.
class _FakeQrPainter extends CustomPainter {
  final int seed;
  _FakeQrPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    const n = 29;
    final cell = size.width / n;
    final dark = Paint()..color = const Color(0xFF111111);
    final light = Paint()..color = Colors.white;
    final rnd = math.Random(seed);
    bool finder(int x, int y) => (x < 8 && y < 8) || (x >= n - 8 && y < 8) || (x < 8 && y >= n - 8);
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        if (finder(x, y)) continue;
        if (rnd.nextBool()) canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), dark);
      }
    }
    void eye(int ox, int oy) {
      canvas.drawRect(Rect.fromLTWH(ox * cell, oy * cell, 7 * cell, 7 * cell), dark);
      canvas.drawRect(Rect.fromLTWH((ox + 1) * cell, (oy + 1) * cell, 5 * cell, 5 * cell), light);
      canvas.drawRect(Rect.fromLTWH((ox + 2) * cell, (oy + 2) * cell, 3 * cell, 3 * cell), dark);
    }

    eye(0, 0);
    eye(n - 7, 0);
    eye(0, n - 7);
  }

  @override
  bool shouldRepaint(covariant _FakeQrPainter old) => old.seed != seed;
}
