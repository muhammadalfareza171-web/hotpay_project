import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'new_password_screen.dart';

class ForgotOtpScreen extends StatefulWidget {
  final String phone;
  const ForgotOtpScreen({super.key, required this.phone});
  @override
  State<ForgotOtpScreen> createState() => _ForgotOtpScreenState();
}

class _ForgotOtpScreenState extends State<ForgotOtpScreen> {
  String code = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const BrandHeader(showBack: true),
              const SizedBox(height: 8),
              Text('Verifikasi Identitas Anda', style: ts(22, w: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Masukkan 4 digit kode keamanan yang telah dikirimkan ke WhatsApp resmi SmartBite ke nomor:',
                  style: ts(12, c: AppColors.muted, h: 1.5)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(widget.phone, style: ts(13, w: FontWeight.w700))),
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Text('Ubah', style: ts(11, w: FontWeight.w800, c: AppColors.orange)),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              OtpInput(onChanged: (v) => setState(() => code = v)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(12)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.shield_outlined, size: 18, color: AppColors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Tips Keamanan: Jangan bagikan kode OTP ini kepada siapa pun, termasuk staf operasional atau teknisi Vending Mesin HotPay.',
                        style: ts(10, c: AppColors.muted, h: 1.4)),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Verifikasi & Lanjutkan',
                onPressed: code.length == 4
                    ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewPasswordScreen()))
                    : null,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Batalkan Pemulihan', style: ts(12, w: FontWeight.w700)),
                ),
              ),
            ]),
          ),
        ),
      );
}
