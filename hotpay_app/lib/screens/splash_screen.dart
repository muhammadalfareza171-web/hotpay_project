import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Widget _stat(IconData i, String big, String small) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Icon(i, size: 16, color: AppColors.orange),
            const SizedBox(height: 4),
            Text(big, style: ts(12, w: FontWeight.w800)),
            Text(small, style: ts(9, c: AppColors.muted)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const BrandHeader(),
              const SizedBox(height: 8),
              Stack(children: [
                const FoodImage('assets/images/mie_tarempa_ayam.jpg', width: double.infinity, height: 220, radius: 20),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Text('85°C Freshly Cooked', style: ts(10, w: FontWeight.w700)),
                  ),
                ),
              ]),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.orangeSoft, borderRadius: BorderRadius.circular(20)),
                child: Text('VENDING MESIN KULINER RIAU', style: ts(9, w: FontWeight.w800, c: AppColors.brown)),
              ),
              const SizedBox(height: 12),
              Text('Makan Enak & Hangat,\nSiap dalam 3 Menit!', textAlign: TextAlign.center, style: ts(24, w: FontWeight.w800, h: 1.2)),
              const SizedBox(height: 8),
              Text('Hidangan hangat citra rasa tradisional khas Kepulauan Riau, disajikan kapan saja lewat vending mesin terdekat Anda.',
                  textAlign: TextAlign.center, style: ts(12, c: AppColors.muted, h: 1.5)),
              const SizedBox(height: 16),
              Row(children: [
                _stat(Icons.thermostat, '85°C Presisi', 'Suhu Sendiri Ideal'),
                _stat(Icons.timer_outlined, '180 Detik', 'Tanpa Antre Lama'),
                _stat(Icons.verified_outlined, '100% Higienis', 'Zero Contact Touch'),
              ]),
              const SizedBox(height: 18),
              PrimaryButton(
                label: 'Mulai Pesan Sekarang',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
              ),
              TextButton(
                onPressed: () => Navigator.push(context, homeRoute(guest: true)),
                child: Text('Jelajahi Menu sebagai Tamu', style: ts(12, w: FontWeight.w700, c: AppColors.muted)),
              ),
            ]),
          ),
        ),
      );
}
