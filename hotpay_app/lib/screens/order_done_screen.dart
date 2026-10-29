import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import 'help_screen.dart';

class OrderDoneScreen extends StatelessWidget {
  final Order order;
  const OrderDoneScreen({super.key, required this.order});

  Widget _kv(String k, String v, {Widget? trailing}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Text(k, style: ts(11, c: AppColors.muted)),
          const Spacer(),
          trailing ?? Text(v, style: ts(11, w: FontWeight.w800)),
        ]),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
            BrandHeader(subtitle: 'PESANAN SELESAI', trailing: AvatarButton(onTap: () {})),
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 34),
              ),
            ),
            const SizedBox(height: 10),
            Center(child: Text('PESANAN SELESAI', style: ts(24, w: FontWeight.w800))),
            const SizedBox(height: 4),
            Center(
              child: Text('Makanan hangat kamu sudah keluar! Silakan santap selagi hangat dan nikmati harimu.',
                  textAlign: TextAlign.center, style: ts(11, c: AppColors.muted, h: 1.4)),
            ),
            const SizedBox(height: 14),
            Stack(children: [
              FoodImage(order.item.image, width: double.infinity, height: 150, radius: 16),
              Positioned(left: 8, bottom: 8, child: pill('Disajikan pada 85°C', Colors.white, AppColors.brown)),
              Positioned(right: 8, bottom: 8, child: pill('Freshly Heated', AppColors.green, Colors.white)),
            ]),
            const SizedBox(height: 12),
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.orangeSoft, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.arrow_downward, color: AppColors.orange),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('INSTRUKSI PENGAMBILAN', style: ts(8, w: FontWeight.w800, c: AppColors.orange)),
                      Text('Ambil makanan pada baki bawah mesin', style: ts(13, w: FontWeight.w800)),
                    ]),
                  ),
                ]),
                const SizedBox(height: 10),
                Panel(
                  color: AppColors.field,
                  padding: const EdgeInsets.all(10),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.circle, size: 8, color: AppColors.green),
                      const SizedBox(width: 6),
                      Text('Kompartemen Dispenser', style: ts(10, w: FontWeight.w700)),
                      const Spacer(),
                      Text(order.slot, style: ts(16, w: FontWeight.w800, c: AppColors.orange)),
                    ]),
                    const SizedBox(height: 4),
                    Text('Pintu Vending Mesin telah terbuka otomatis', style: ts(9, c: AppColors.muted)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                pill('BUKTI TRANSAKSI • LUNAS', AppColors.greenSoft, AppColors.green),
                const SizedBox(height: 6),
                _kv('No. Transaksi', '#${order.no}'),
                _kv('Pesanan', '${order.qty}x ${order.item.name}'),
                _kv('Baki Pengambilan', '', trailing: pill('PORT BAY-${order.slot.replaceAll('#', '')}', AppColors.orangeSoft, AppColors.brown)),
                _kv('Waktu Penyelesaian', '${fmtDay(DateTime.now())}, ${fmtClock(DateTime.now())}'),
                const Divider(height: 20),
                Row(children: [
                  Text('Total Dibayar', style: ts(13, w: FontWeight.w800)),
                  const Spacer(),
                  Text(rp(order.total), style: ts(18, w: FontWeight.w800, c: AppColors.brown)),
                ]),
              ]),
            ),
            const SizedBox(height: 14),
            PrimaryButton(label: 'SELESAI', icon: Icons.check, onPressed: () => popToHome(context)),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpScreen(orderNo: order.no))),
              child: Text('Ada kendala pada dispenser? Hubungi Bantuan', style: ts(10, w: FontWeight.w700, c: AppColors.muted)),
            ),
          ]),
        ),
      );
}
