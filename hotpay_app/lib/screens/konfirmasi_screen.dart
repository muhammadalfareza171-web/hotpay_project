import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import 'qris_pay_screen.dart';

class KonfirmasiScreen extends StatelessWidget {
  final MenuItem item;
  final int qty;
  const KonfirmasiScreen({super.key, required this.item, required this.qty});

  int get total => item.price * qty;

  Widget _row(IconData i, String l, String v, {Color? vc}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Icon(i, size: 13, color: AppColors.muted),
          const SizedBox(width: 6),
          Text(l, style: ts(11, c: AppColors.muted)),
          const Spacer(),
          Text(v, style: ts(11, w: FontWeight.w800, c: vc ?? AppColors.text)),
        ]),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: SafeArea(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(children: [
                Text('Total Pembayaran', style: ts(11, c: AppColors.muted)),
                const Spacer(),
                Text(rp(total), style: ts(18, w: FontWeight.w800)),
              ]),
              const SizedBox(height: 10),
              PrimaryButton(
                label: 'BAYAR SEKARANG',
                onPressed: () {
                  final order = Order(no: newOrderNo(), item: item, qty: qty);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => QrisPayScreen(order: order)));
                },
              ),
            ]),
          ),
        ),
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
            BrandHeader(showBack: true, subtitle: 'KONFIRMASI PESANAN', trailing: AvatarButton(onTap: () {})),
            Text('Konfirmasi Pesanan', style: ts(22, w: FontWeight.w800)),
            const SizedBox(height: 12),
            Panel(
              color: AppColors.field,
              child: Row(children: [
                const Icon(Icons.storefront, color: AppColors.orange),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Vending Machine #VM-01', style: ts(12, w: FontWeight.w800)),
                    Text('PT. Jaya Abadi, Mukakuning', style: ts(10, c: AppColors.muted)),
                    const SizedBox(height: 2),
                    Text('Induksi: 85°C Aktif  •  ± 180s Dispenser', style: ts(9, c: AppColors.brown)),
                  ]),
                ),
                pill('Siap Masak', AppColors.greenSoft, AppColors.green),
              ]),
            ),
            const SizedBox(height: 12),
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('Ringkasan Makanan', style: ts(13, w: FontWeight.w800)),
                  const Spacer(),
                  pill('$qty Porsi', AppColors.orangeSoft, AppColors.brown),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  FoodImage(item.image, width: 48, height: 48, radius: 10),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${qty}x ${item.name}', style: ts(12, w: FontWeight.w800)),
                      Text('Sajian panas siap saji', style: ts(10, c: AppColors.muted)),
                    ]),
                  ),
                  Text(rp(total), style: ts(12, w: FontWeight.w800)),
                ]),
                const Divider(height: 22),
                _row(Icons.inventory_2_outlined, 'Porsi & Ukuran', '$qty Porsi Standar (${item.portion.contains('(') ? item.portion.split('(').last.replaceAll(')', '') : item.portion})'),
                _row(Icons.bolt, 'Pemanasan Otomatis', '< 3 Menit'),
                _row(Icons.thermostat, 'Suhu Penyajian', 'Garansi Panas 85°C', vc: AppColors.green),
                const SizedBox(height: 8),
                Panel(
                  color: AppColors.field,
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Subtotal Ringkasan', style: ts(10, w: FontWeight.w700)),
                        Text('$qty Menu Siap Saji Kios', style: ts(9, c: AppColors.muted)),
                      ]),
                    ),
                    Text(rp(total), style: ts(14, w: FontWeight.w800)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('Metode Pembayaran', style: ts(13, w: FontWeight.w800)),
                  const Spacer(),
                  Text('Otomatis Terverifikasi', style: ts(9, w: FontWeight.w700, c: AppColors.orange)),
                ]),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppColors.field, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.orange)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.qr_code_2, color: AppColors.text),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Text('QRIS Terpadu  ', style: ts(12, w: FontWeight.w800)),
                            pill('Instan', AppColors.greenSoft, AppColors.green, size: 8),
                          ]),
                          Text('Semua E-Wallet & Mobile Banking', style: ts(10, c: AppColors.muted)),
                        ]),
                      ),
                      const Icon(Icons.check_circle, color: AppColors.brown, size: 20),
                    ]),
                    const SizedBox(height: 8),
                    Text('Kode QRIS dibuat otomatis setelah konfirmasi dan terhubung langsung ke sistem dispenser mesin.',
                        style: ts(9, c: AppColors.muted, h: 1.4)),
                  ]),
                ),
              ]),
            ),
          ]),
        ),
      );
}
