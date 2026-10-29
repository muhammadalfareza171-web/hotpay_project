import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'dashboard_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String code = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(children: [
              const BrandHeader(showBack: true),
              const SizedBox(height: 8),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.mark_email_read_outlined, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text('Verifikasi Kode OTP', style: ts(20, w: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Masukkan 4-digit kode verifikasi yang telah kami kirimkan melalui WhatsApp ke nomor:',
                  textAlign: TextAlign.center, style: ts(12, c: AppColors.muted)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.phone_android, size: 16, color: AppColors.green),
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
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Verifikasi & Lanjutkan',
                // TODO: verifikasi OTP ke server
                onPressed: code.length == 4
                    ? () => Navigator.pushAndRemoveUntil(context, homeRoute(), (_) => false)
                    : null,
              ),
              const SizedBox(height: 10),
              Text('Enkripsi End-to-End Terjamin. Jangan berikan 4-digit PIN ini kepada siapa pun.',
                  textAlign: TextAlign.center, style: ts(10, c: AppColors.muted)),
            ]),
          ),
        ),
      );
}
