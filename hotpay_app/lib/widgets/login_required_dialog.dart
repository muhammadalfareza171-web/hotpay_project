import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/guest_mode.dart';

/// Popup "Masuk ke Akun HotPay" untuk pengguna tamu.
///
/// Cara pakai di tombol/aksi apa pun:
/// ```dart
/// onTap: () {
///   if (!LoginRequiredDialog.guard(context)) return; // tamu -> popup, berhenti
///   // ... aksi normal untuk pengguna yang sudah login
/// }
/// ```
class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({super.key});

  /// Route tujuan saat menekan "Masuk ke Akun HotPay".
  /// SESUAIKAN dengan route login / halaman awal di MaterialApp kamu.
  static const String loginRoute = '/splash';

  static bool _showing = false;

  /// Mengembalikan `true` jika boleh lanjut (sudah login).
  /// Jika tamu: menampilkan popup dan mengembalikan `false`.
  static bool guard(BuildContext context) {
    if (!GuestMode.isGuest) return true;
    show(context);
    return false;
  }

  static Future<void> show(BuildContext context) async {
    if (_showing) return; // cegah popup bertumpuk
    _showing = true;
    try {
      await showDialog<void>(
        context: context,
        barrierColor: Colors.black54,
        builder: (_) => const LoginRequiredDialog(),
      );
    } finally {
      _showing = false;
    }
  }

  static const _lavender = Color(0xFFE6E5F9);
  static const _orange = Color(0xFFFF6A13);

  void _goToLogin(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    GuestMode.exit();
    navigator.pushNamedAndRemoveUntil(loginRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol close
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                customBorder: const CircleBorder(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDEBF7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            // Ikon gembok dengan ring
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: _orange.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 66,
                  height: 66,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF8A2B), _orange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Pill mode tamu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _lavender,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline_rounded,
                      size: 13, color: AppColors.primaryDark),
                  SizedBox(width: 5),
                  Text(
                    'MODE TAMU',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Masuk ke Akun HotPay',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kamu sedang menjelajah sebagai tamu. Masuk dulu untuk bisa memakai fitur ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),

            // Manfaat masuk akun
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3EC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  _Benefit(
                    icon: Icons.restaurant_menu_rounded,
                    text: 'Pesan makanan hangat dari vending mesin',
                  ),
                  SizedBox(height: 8),
                  _Benefit(
                    icon: Icons.receipt_long_rounded,
                    text: 'Lihat riwayat pesanan & e-struk digital',
                  ),
                  SizedBox(height: 8),
                  _Benefit(
                    icon: Icons.manage_accounts_outlined,
                    text: 'Kelola profil dan bantuan kios',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Tombol masuk
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _goToLogin(context),
                child: Ink(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF8A2B), _orange],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _orange.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Masuk ke Akun HotPay',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),

            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Nanti Saja',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Benefit({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}