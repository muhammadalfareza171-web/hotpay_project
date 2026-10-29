import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'login_screen.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.greenSoft, borderRadius: BorderRadius.circular(20)),
                child: Text('STATUS: AKUN TELAH DIPULIHKAN', style: ts(9, w: FontWeight.w800, c: AppColors.green)),
              ),
              const SizedBox(height: 24),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: AppColors.greenSoft, shape: BoxShape.circle),
                child: const Icon(Icons.verified_user, size: 48, color: AppColors.green),
              ),
              const SizedBox(height: 24),
              Text('Kata Sandi Berhasil Diperbarui!', textAlign: TextAlign.center, style: ts(22, w: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Kata sandi akun HotPay Anda telah berhasil diubah. Sekarang Anda dapat masuk kembali dan menikmati sajian makanan hangat favorit di vending mesin.',
                  textAlign: TextAlign.center, style: ts(12, c: AppColors.muted, h: 1.5)),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Masuk',
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false),
              ),
            ]),
          ),
        ),
      );
}
