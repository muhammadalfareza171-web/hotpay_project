import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import 'preparing_screen.dart';
import 'struk_screen.dart';

bool _isHome(Route<dynamic> r) => r.settings.name == '/home';

void showPaymentSuccessSheet(BuildContext context, Order order) {
  final nav = Navigator.of(context);
  OrderStore.start(order); // pesanan mulai diproses mesin
  showAppSheet(
    context,
    Builder(
      builder: (ctx) => Column(children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 10),
        pill('TRANSMISI SELESAI', AppColors.greenSoft, AppColors.green),
        const SizedBox(height: 10),
        Text('Pembayaran Berhasil!', style: ts(22, w: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Pembayaran sebesar ${rp(order.total)} telah kami terima. Mesin otomatis mulai memasak hidangan hangat Anda.',
            textAlign: TextAlign.center, style: ts(12, c: AppColors.muted, h: 1.5)),
        const SizedBox(height: 14),
        Panel(
          color: AppColors.orangeSoft,
          child: Column(children: [
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('NOMOR PESANAN', style: ts(8, w: FontWeight.w700, c: AppColors.muted)),
                Text('#${order.no}', style: ts(16, w: FontWeight.w800)),
              ]),
              const Spacer(),
              pill('LUNAS', AppColors.greenSoft, AppColors.green),
            ]),
            const Divider(height: 20),
            Row(children: [
              FoodImage(order.item.image, width: 40, height: 40, radius: 8),
              const SizedBox(width: 10),
              Expanded(child: Text('${order.qty}× ${order.item.name}', style: ts(12, w: FontWeight.w800))),
              Text(rp(order.total), style: ts(12, w: FontWeight.w700)),
            ]),
            const Divider(height: 20),
            Row(children: [
              Text('Kios VM-01 • Mukakuning', style: ts(10, c: AppColors.muted)),
              const Spacer(),
              pill('Slot ${order.slot}', AppColors.brown, Colors.white),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        Panel(
          color: AppColors.field,
          child: Text('Sensor Pengambilan Siap: Dekati dispenser otomatis setelah indikator lampu biru berkedip hijau lembut.',
              style: ts(10, c: AppColors.muted, h: 1.4)),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          label: 'Lihat Status Mesin & Pengambilan Makanan',
          icon: null,
          onPressed: () {
            Navigator.pop(ctx);
            nav.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => PreparingScreen(order: order)), _isHome);
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            nav.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => StrukScreen(order: order)), _isHome);
          },
          child: Text('Unduh E-Struk Digital', style: ts(12, w: FontWeight.w800, c: AppColors.brown)),
        ),
      ]),
    ),
    dismissible: false,
  );
}
