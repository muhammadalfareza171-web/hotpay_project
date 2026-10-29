import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'dashboard_screen.dart';

/// Tampilan contoh pemilih akun. Untuk login Google sungguhan gunakan
/// paket `google_sign_in` / Firebase Auth, bukan sheet statis ini.
void showGoogleAccountSheet(BuildContext context) {
  showAppSheet(
    context,
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Pilih akun untuk HotPay', style: ts(16, w: FontWeight.w800)),
      Text('Lanjutkan pendaftaran ke Hot Food Vending Mesin', style: ts(11, c: AppColors.muted)),
      const SizedBox(height: 14),
      _account('Ahmad Pratama', 'ahmad.pratama@gmail.com', 'AP', true),
      const SizedBox(height: 8),
      _account('Budi Prasetyo (Work)', 'budi.prasetyo@techcorp.id', 'BP', false),
      const SizedBox(height: 8),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.person_add_alt_1_outlined),
        title: Text('Gunakan akun Google lain', style: ts(13, w: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
      const SizedBox(height: 8),
      Builder(
        builder: (ctx) => PrimaryButton(
          label: 'Lanjutkan sebagai Ahmad',
          icon: null,
          onPressed: () => Navigator.pushAndRemoveUntil(ctx, homeRoute(), (_) => false),
        ),
      ),
      const SizedBox(height: 8),
      Builder(builder: (ctx) => SoftButton(label: 'Batal', onPressed: () => Navigator.pop(ctx))),
    ]),
  );
}

Widget _account(String name, String email, String initials, bool primary) => Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: primary ? AppColors.field : Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        CircleAvatar(backgroundColor: AppColors.orangeSoft, child: Text(initials, style: ts(12, w: FontWeight.w800, c: AppColors.brown))),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: ts(13, w: FontWeight.w700)),
            Text(email, style: ts(11, c: AppColors.muted)),
          ]),
        ),
        Icon(primary ? Icons.radio_button_checked : Icons.radio_button_unchecked, size: 18, color: AppColors.orange),
      ]),
    );
