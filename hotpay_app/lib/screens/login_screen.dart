import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'dashboard_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _toRegister() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
  void _toDashboard({bool guest = false}) => Navigator.pushAndRemoveUntil(context, homeRoute(guest: guest), (_) => false);

  void _submit() {
    if (_form.currentState!.validate()) _toDashboard(); // TODO: panggil API login
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
                const SizedBox(height: 8),
                Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(text: 'Sajian Hangat,\n', style: ts(26, w: FontWeight.w800, h: 1.2)),
                      TextSpan(text: 'Siap dalam 3 Menit!', style: ts(26, w: FontWeight.w800, c: AppColors.orange, h: 1.2)),
                    ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text('Nikmati hidangan langsung dari vending machine pintar terdekat.',
                      textAlign: TextAlign.center, style: ts(12, c: AppColors.muted)),
                ),
                const SizedBox(height: 20),
                AuthTabs(loginSelected: true, onLogin: () {}, onRegister: _toRegister),
                const SizedBox(height: 18),
                AppField(
                  label: 'Nomor WhatsApp / HP',
                  hint: '812-3456-7890',
                  icon: Icons.phone_android,
                  prefixText: '+62',
                  controller: _phone,
                  keyboard: TextInputType.phone,
                  validator: (v) => (v == null || v.trim().length < 8) ? 'Nomor tidak valid' : null,
                ),
                const SizedBox(height: 14),
                AppField(
                  label: 'Kata Sandi',
                  hint: 'Ketik kata sandi Anda',
                  icon: Icons.lock_outline,
                  password: true,
                  controller: _pass,
                  validator: (v) => (v == null || v.isEmpty) ? 'Kata sandi wajib diisi' : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                    child: Text('Lupa Kata Sandi?', style: ts(11, w: FontWeight.w800, c: AppColors.orange)),
                  ),
                ),
                PrimaryButton(label: 'Masuk', onPressed: _submit),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: _toRegister,
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: 'Belum punya akun? ', style: ts(12, c: AppColors.muted)),
                      TextSpan(text: 'Daftar Sekarang', style: ts(12, w: FontWeight.w800, c: AppColors.orange)),
                    ])),
                  ),
                ),
                const SizedBox(height: 8),
                SoftButton(label: 'Pesan Cepat sebagai Tamu', icon: Icons.shopping_bag_outlined, onPressed: () => _toDashboard(guest: true)),
              ]),
            ),
          ),
        ),
      );
}
