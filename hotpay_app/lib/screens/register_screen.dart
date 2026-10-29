import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'google_account_sheet.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool agree = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _pass, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => OtpScreen(phone: '+62 ${_phone.text.trim()}')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Form(
              key: _form,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const BrandHeader(showBack: true),
                Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(text: 'Daftar Akun untuk\n', style: ts(24, w: FontWeight.w800, h: 1.2)),
                      TextSpan(text: 'Akses Lengkap', style: ts(24, w: FontWeight.w800, c: AppColors.orange, h: 1.2)),
                    ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text('Simpan riwayat transaksi lengkap, pantau status pesanan hangat, dan pesan kembali dengan cepat.',
                      textAlign: TextAlign.center, style: ts(11, c: AppColors.muted)),
                ),
                const SizedBox(height: 16),
                AuthTabs(
                  loginSelected: false,
                  onLogin: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                  onRegister: () {},
                ),
                const SizedBox(height: 16),
                AppField(label: 'Nama Lengkap', hint: 'Ahmad Pratama', icon: Icons.person_outline, controller: _name,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null),
                const SizedBox(height: 12),
                AppField(label: 'Nomor WhatsApp / HP', hint: '812-3456-7890', icon: Icons.phone_android, prefixText: '+62',
                    controller: _phone, keyboard: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().length < 8) ? 'Nomor tidak valid' : null),
                const SizedBox(height: 12),
                AppField(label: 'Email Aktif', hint: 'nama@email.com', icon: Icons.mail_outline, controller: _email,
                    keyboard: TextInputType.emailAddress,
                    validator: (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v ?? '') ? null : 'Email tidak valid'),
                const SizedBox(height: 12),
                AppField(label: 'Kata Sandi', hint: 'Minimal 8 karakter', icon: Icons.lock_outline, password: true,
                    controller: _pass, validator: (v) => (v == null || v.length < 8) ? 'Minimal 8 karakter' : null),
                const SizedBox(height: 12),
                AppField(label: 'Konfirmasi Kata Sandi', hint: 'Ulangi kata sandi Anda', icon: Icons.lock_outline, password: true,
                    controller: _confirm, validator: (v) => v != _pass.text ? 'Kata sandi tidak sama' : null),
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: agree,
                  onChanged: (v) => setState(() => agree = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.orange,
                  title: Text('Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi HotPay.', style: ts(11, c: AppColors.muted)),
                ),
                PrimaryButton(label: 'Daftar Akun Baru', onPressed: agree ? _submit : null),
                const SizedBox(height: 16),
                Center(child: Text('ATAU DAFTAR LEBIH CEPAT DENGAN', style: ts(9, w: FontWeight.w700, c: AppColors.muted))),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: AppColors.field),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => showGoogleAccountSheet(context),
                  icon: const Icon(Icons.g_mobiledata, size: 28, color: AppColors.text),
                  label: Text('Google', style: ts(13, w: FontWeight.w700)),
                ),
              ]),
            ),
          ),
        ),
      );
}
