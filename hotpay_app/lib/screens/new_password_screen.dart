import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'reset_success_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String get p => _pass.text;
  bool get okLen => p.length >= 8;
  bool get okCase => RegExp(r'[a-z]').hasMatch(p) && RegExp(r'[A-Z]').hasMatch(p);
  bool get okNum => RegExp(r'\d').hasMatch(p);
  bool get okSym => RegExp(r'[^A-Za-z0-9]').hasMatch(p);
  bool get valid => okLen && okCase && okNum && p == _confirm.text;

  Widget _rule(String t, bool ok, {bool optional = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked, size: 14, color: ok ? AppColors.green : AppColors.muted),
          const SizedBox(width: 8),
          Text(t, style: ts(11, c: AppColors.muted)),
          const SizedBox(width: 4),
          Text(optional ? '(Opsional)' : (ok ? '(Terpenuhi)' : ''),
              style: ts(11, w: FontWeight.w700, c: ok ? AppColors.green : AppColors.muted)),
        ]),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const BrandHeader(showBack: true),
              const SizedBox(height: 8),
              Text('Langkah 3 dari 3 • Atur Sandi Baru', style: ts(10, w: FontWeight.w800, c: AppColors.red)),
              const SizedBox(height: 8),
              Text('Buat Kata Sandi Baru', style: ts(22, w: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Pastikan kata sandi HotPay Anda kuat dan aman untuk melindungi akun Anda.', style: ts(12, c: AppColors.muted)),
              const SizedBox(height: 18),
              AppField(label: 'Kata Sandi Baru', hint: 'Masukkan sandi baru', icon: Icons.lock_outline, password: true,
                  controller: _pass, onChanged: (_) => setState(() {})),
              const SizedBox(height: 10),
              _rule('Minimal 8 karakter', okLen),
              _rule('Mengandung huruf besar & kecil', okCase),
              _rule('Mengandung minimal 1 angka', okNum),
              _rule('Simbol khusus (@#\$!)', okSym, optional: true),
              const SizedBox(height: 14),
              AppField(label: 'Konfirmasi Kata Sandi', hint: 'Ulangi kata sandi baru', icon: Icons.lock_outline, password: true,
                  controller: _confirm, onChanged: (_) => setState(() {})),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Simpan Sandi Baru & Masuk',
                // TODO: kirim sandi baru ke server
                onPressed: valid
                    ? () => Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (_) => const ResetSuccessScreen()), (r) => r.isFirst)
                    : null,
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.maybePop(context),
                  child: Text('Batal', style: ts(12, w: FontWeight.w700, c: AppColors.muted)),
                ),
              ),
            ]),
          ),
        ),
      );
}
