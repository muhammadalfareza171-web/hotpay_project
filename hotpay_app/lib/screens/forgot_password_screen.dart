import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'forgot_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const BrandHeader(showBack: true),
              const SizedBox(height: 8),
              Text('Lupa Kata Sandi Anda?', style: ts(22, w: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Masukkan nomor WhatsApp yang terdaftar untuk menerima 4 digit kode verifikasi pemulihan sandi.',
                  style: ts(12, c: AppColors.muted, h: 1.5)),
              const SizedBox(height: 20),
              AppField(label: 'Nomor WhatsApp Terdaftar', hint: '812-xxxx-xxxx', icon: Icons.phone_android, prefixText: '+62',
                  controller: _phone, keyboard: TextInputType.phone, onChanged: (_) => setState(() {})),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.orangeSoft, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.bolt, color: AppColors.orange),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Kode OTP 4 digit akan dikirimkan otomatis.', style: ts(11, c: AppColors.brown))),
                ]),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Kirim Kode OTP Pemulihan',
                onPressed: _phone.text.trim().length >= 8
                    ? () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => ForgotOtpScreen(phone: '+62 ${_phone.text.trim()}')))
                    : null,
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.maybePop(context),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: 'Ingat kata sandi? ', style: ts(12, c: AppColors.muted)),
                    TextSpan(text: 'Masuk Sekarang', style: ts(12, w: FontWeight.w800, c: AppColors.brown)),
                  ])),
                ),
              ),
            ]),
          ),
        ),
      );
}
