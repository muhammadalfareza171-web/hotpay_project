import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import 'order_done_screen.dart';
import 'preparing_screen.dart';

class StrukScreen extends StatelessWidget {
  final Order order;
  const StrukScreen({super.key, required this.order});

  Widget _kv(String k, String v, {Color? vc, bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 4, child: Text(k, style: ts(10, c: AppColors.muted))),
          Expanded(flex: 6, child: Text(v, textAlign: TextAlign.right, style: ts(10, w: bold ? FontWeight.w800 : FontWeight.w600, c: vc ?? AppColors.text))),
        ]),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
            BrandHeader(showBack: true, subtitle: 'E-STRUK', trailing: AvatarButton(onTap: () {})),
            Panel(
              color: AppColors.greenSoft,
              child: Row(children: [
                const Icon(Icons.check_circle_outline, color: AppColors.green),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text('Transaksi Berhasil  ', style: ts(12, w: FontWeight.w800)),
                      pill('LUNAS', AppColors.green, Colors.white, size: 8),
                    ]),
                    Text('Sistem telah memverifikasi pembayaran Anda via QRIS', style: ts(9, c: AppColors.muted)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            Panel(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(
                  child: Column(children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: AppColors.orangeSoft, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.local_fire_department, color: AppColors.orange),
                    ),
                    const SizedBox(height: 6),
                    Text('HotPay', style: ts(16, w: FontWeight.w800)),
                    Text('Vending Mesin Otomatis Makanan Hangat 24 Jam', style: ts(9, c: AppColors.muted)),
                    const SizedBox(height: 10),
                    Panel(
                      color: AppColors.field,
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        Text('TOTAL PEMBAYARAN BERHASIL', style: ts(8, w: FontWeight.w800, c: AppColors.brown)),
                        Text(rp(order.total), style: ts(22, w: FontWeight.w800, c: AppColors.brown)),
                        Text('Terverifikasi Aman Bank Indonesia (QRIS)', style: ts(8, c: AppColors.muted)),
                      ]),
                    ),
                  ]),
                ),
                const Divider(height: 24),
                _kv('No. Transaksi', '#${order.no}', bold: true),
                _kv('Waktu & Tanggal', fmtDate(order.time)),
                _kv('Lokasi Kios', 'Kios VM-01 (Bay ${order.bay})\nPT. Jaya Abadi, Mukakuning'),
                _kv('Metode Pembayaran', 'QRIS Dinamis', bold: true),
                const Divider(height: 24),
                Text('RINCIAN MENU SIAP SAJI', style: ts(9, w: FontWeight.w800, c: AppColors.muted)),
                const SizedBox(height: 8),
                Panel(
                  color: AppColors.field,
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    FoodImage(order.item.image, width: 44, height: 44, radius: 8),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(order.item.name, style: ts(12, w: FontWeight.w800)),
                        Text('Kuantitas: ${order.qty} porsi', style: ts(9, c: AppColors.muted)),
                      ]),
                    ),
                    Text(rp(order.total), style: ts(12, w: FontWeight.w800)),
                  ]),
                ),
                const SizedBox(height: 8),
                _kv('Porsi Standar', order.item.portion),
                _kv('Suhu Saji', 'Hangat 85°C', vc: AppColors.green),
                _kv('Waktu Saji Otomatis', order.item.time),
                const Divider(height: 24),
                _kv('Subtotal (${order.qty} Porsi)', rp(order.total)),
                _kv('Biaya Layanan Kios Otomatis', 'GRATIS', vc: AppColors.green, bold: true),
                _kv('Pajak Restoran (PPN 11%)', 'Sudah Termasuk'),
                const Divider(height: 24),
                Row(children: [
                  Text('Total Bersih', style: ts(14, w: FontWeight.w800)),
                  const Spacer(),
                  Text(rp(order.total), style: ts(18, w: FontWeight.w800)),
                ]),
              ]),
            ),
            const SizedBox(height: 12),
            // TODO: hasilkan PDF (paket pdf/printing) dan bagikan (share_plus).
            PrimaryButton(label: 'Unduh E-Struk Resmi (PDF)', icon: Icons.download, onPressed: () => comingSoon(context)),
            const SizedBox(height: 8),
            SoftButton(label: 'Bagikan ke WhatsApp / Email', icon: Icons.share, onPressed: () => comingSoon(context)),
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => order.status == OrderStatus.done ? OrderDoneScreen(order: order) : PreparingScreen(order: order))),
              child: Text('Lihat Status Dispenser & Pengambilan Makanan', style: ts(11, w: FontWeight.w700, c: AppColors.brown)),
            ),
          ]),
        ),
      );
}
