import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import 'help_screen.dart';

void showPaymentFailedSheet(BuildContext context, Order order, VoidCallback onRegenerate) {
  showAppSheet(
    context,
    Builder(
      builder: (ctx) => Column(children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(color: AppColors.redSoft, shape: BoxShape.circle),
          child: const Icon(Icons.timer_off_outlined, color: AppColors.red),
        ),
        const SizedBox(height: 10),
        pill('WAKTU PEMBAYARAN HABIS / GAGAL', AppColors.redSoft, AppColors.red),
        const SizedBox(height: 10),
        Text('Pembayaran Tidak Berhasil', textAlign: TextAlign.center, style: ts(20, w: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Batas waktu QRIS kedaluwarsa atau transaksi belum terverifikasi oleh gateway perbankan. Jangan khawatir, saldo Anda tidak terpotong.',
            textAlign: TextAlign.center, style: ts(11, c: AppColors.muted, h: 1.5)),
        const SizedBox(height: 14),
        Panel(
          color: AppColors.orangeSoft,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.lunch_dining, color: AppColors.orange),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Porsi Anda Tetap Dicadangkan', style: ts(12, w: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('Porsi di baki dispenser tetap hangat higienis. Generate kode QR baru sekarang sebelum batas reservasi berakhir.',
                    style: ts(10, c: AppColors.muted, h: 1.4)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        Panel(
          color: AppColors.field,
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            FoodImage(order.item.image, width: 40, height: 40, radius: 8),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('#${order.no} • VM-01 Gambir', style: ts(9, c: AppColors.muted)),
                Text(order.item.name, style: ts(12, w: FontWeight.w800)),
                Text('Siap saji suhu 68°C', style: ts(9, w: FontWeight.w700, c: AppColors.green)),
              ]),
            ),
            Text(rp(order.total), style: ts(12, w: FontWeight.w800)),
          ]),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          label: 'Buat Kode QR Baru (Generate Ulang)',
          icon: Icons.refresh,
          onPressed: () {
            Navigator.pop(ctx);
            onRegenerate();
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            Navigator.push(context, MaterialPageRoute(builder: (_) => HelpScreen(orderNo: order.no)));
          },
          child: Text('Ada kendala saldo terpotong? Hubungi Bantuan Operator', textAlign: TextAlign.center, style: ts(10, w: FontWeight.w700, c: AppColors.brown)),
        ),
      ]),
    ),
    dismissible: false,
  );
}
