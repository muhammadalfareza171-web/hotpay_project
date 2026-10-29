import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/order.dart';
import 'dashboard_screen.dart';
import 'help_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 0, 8),
        child: Text(t, style: ts(9, w: FontWeight.w800, c: AppColors.muted)),
      );

  Widget _item(IconData i, String title, String sub, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Panel(
          child: Row(children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(10)),
              child: Icon(i, size: 18, color: AppColors.orange),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: ts(12, w: FontWeight.w800)),
                Text(sub, style: ts(9, c: AppColors.muted)),
              ]),
            ),
            const Icon(Icons.chevron_right, color: AppColors.muted),
          ]),
        ),
      );

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Anda perlu masuk lagi untuk melihat riwayat pesanan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Keluar')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
            const BrandHeader(showBack: true, subtitle: 'PROFIL'),
            ValueListenableBuilder<UserProfile>(
              valueListenable: UserStore.profile,
              builder: (context, u, _) => Panel(
                color: AppColors.orangeSoft,
                child: Row(children: [
                  CircleAvatar(radius: 24, backgroundColor: Colors.white, child: Text(u.initials, style: ts(14, w: FontWeight.w800, c: AppColors.brown))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(u.name, style: ts(15, w: FontWeight.w800)),
                      Text('ID: #SB-98421', style: ts(10, c: AppColors.muted)),
                      Text('+62 ${u.phone}', style: ts(10, c: AppColors.muted)),
                    ]),
                  ),
                  IconButton(
                    onPressed: () => showEditProfileSheet(context),
                    icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.brown),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                ]),
              ),
            ),
            _section('AKTIVITAS SAYA'),
            _item(Icons.receipt_long_outlined, 'Riwayat Transaksi & E-Struk', 'Pesanan telah disajikan hangat',
                () => Navigator.pushAndRemoveUntil(context, homeRoute(tab: 2), (_) => false)),
            _section('PENGATURAN & KEAMANAN'),
            _item(Icons.badge_outlined, 'Informasi Pribadi & Edit Profil', 'Kelola nama, email, dan tanggal lahir',
                () => showEditProfileSheet(context)),
            _section('BANTUAN & LAYANAN'),
            _item(Icons.help_outline, 'Pusat Bantuan Kios & FAQ Dispensing', 'Panduan pengambilan makanan cepat',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()))),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: const Size.fromHeight(46),
                backgroundColor: AppColors.redSoft,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout, size: 16, color: AppColors.red),
              label: Text('Keluar dari Akun', style: ts(12, w: FontWeight.w800, c: AppColors.red)),
            ),
            const SizedBox(height: 14),
            Center(child: Text('HotPay Vending Mesin', style: ts(10, w: FontWeight.w700, c: AppColors.muted))),
            Center(child: Text('Versi 1.0 (Build 2024.10)', style: ts(9, c: AppColors.muted))),
          ]),
        ),
      );
}

void showEditProfileSheet(BuildContext context) {
  showAppSheet(context, const _EditProfileForm());
}

class _EditProfileForm extends StatefulWidget {
  const _EditProfileForm();
  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: UserStore.profile.value.name);
  late final _email = TextEditingController(text: UserStore.profile.value.email);
  late final _phone = TextEditingController(text: UserStore.profile.value.phone);

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    // TODO: kirim perubahan ke server.
    UserStore.profile.value = UserProfile(name: _name.text.trim(), email: _email.text.trim(), phone: _phone.text.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _form,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Informasi Pribadi', style: ts(15, w: FontWeight.w800)),
            Text('Kelola data akun & preferensi konsumen', style: ts(10, c: AppColors.muted)),
            const SizedBox(height: 12),
            Panel(
              color: AppColors.field,
              padding: const EdgeInsets.all(10),
              child: Row(children: [
                CircleAvatar(backgroundColor: AppColors.orangeSoft, child: Text(UserStore.profile.value.initials, style: ts(12, w: FontWeight.w800, c: AppColors.brown))),
                const SizedBox(width: 10),
                Expanded(child: Text(UserStore.profile.value.name, style: ts(12, w: FontWeight.w800))),
                OutlinedButton(
                  onPressed: () => comingSoon(context),
                  child: Text('Ubah Foto', style: ts(10, w: FontWeight.w800, c: AppColors.brown)),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            AppField(label: 'NAMA LENGKAP', hint: 'Nama lengkap', icon: Icons.person_outline, controller: _name,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null),
            const SizedBox(height: 10),
            AppField(label: 'ALAMAT EMAIL', hint: 'nama@email.com', icon: Icons.mail_outline, controller: _email, keyboard: TextInputType.emailAddress,
                validator: (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v ?? '') ? null : 'Email tidak valid'),
            const SizedBox(height: 10),
            AppField(label: 'NOMOR WHATSAPP / HP', hint: '812-xxxx-xxxx', icon: Icons.phone_android, prefixText: '+62', controller: _phone, keyboard: TextInputType.phone,
                validator: (v) => (v == null || v.trim().length < 8) ? 'Nomor tidak valid' : null),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: SoftButton(label: 'Batal', onPressed: () => Navigator.pop(context))),
              const SizedBox(width: 10),
              Expanded(child: PrimaryButton(label: 'Simpan Perubahan', icon: null, onPressed: _save)),
            ]),
          ]),
        ),
      );
}
