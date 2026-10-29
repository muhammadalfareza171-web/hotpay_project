import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'login_screen.dart';

void showGuestSheet(BuildContext context) {
  showAppSheet(
    context,
    Builder(
      builder: (ctx) => Column(children: [
        pill('FITUR KHUSUS AKUN', AppColors.orangeSoft, AppColors.brown),
        const SizedBox(height: 12),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.lock_outline, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text('Masuk untuk Melihat Riwayat', textAlign: TextAlign.center, style: ts(18, w: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Sebagai tamu (guest), riwayat pesanan tidak tersimpan. Masuk ke akun untuk melihat e-struk & riwayat transaksi Anda.',
            textAlign: TextAlign.center, style: ts(11, c: AppColors.muted, h: 1.5)),
        const SizedBox(height: 12),
        Panel(
          color: AppColors.field,
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            const Icon(Icons.receipt_long_outlined, size: 16, color: AppColors.orange),
            const SizedBox(width: 8),
            Expanded(child: Text('E-Struk & Bukti Transaksi Digital Otomatis Tersimpan', style: ts(10, w: FontWeight.w700))),
          ]),
        ),
        const SizedBox(height: 14),
        PrimaryButton(
          label: 'Masuk ke Akun HotPay',
          onPressed: () {
            Navigator.pop(ctx);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('Tetap Lanjutkan sebagai Tamu', style: ts(11, w: FontWeight.w700, c: AppColors.muted)),
        ),
      ]),
    ),
  );
}
