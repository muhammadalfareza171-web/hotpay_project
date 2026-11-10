import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import 'auth_widgets.dart';

/// Fitur yang dikunci untuk tamu (guest).
enum GuestFeature { riwayat, pesanan }

/// Bottom sheet "Masuk untuk Melihat Riwayat".
///
/// Pemakaian:
/// ```dart
/// GuestLoginSheet.show(context, feature: GuestFeature.riwayat);
/// ```
class GuestLoginSheet extends StatelessWidget {
  final GuestFeature feature;

  const GuestLoginSheet({
    super.key,
    this.feature = GuestFeature.riwayat,
  });

  static Future<void> show(
    BuildContext context, {
    GuestFeature feature = GuestFeature.riwayat,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return GuestLoginSheet(feature: feature);
      },
    );
  }

  // Warna sesuai desain
  static const Color _navy = Color(0xFF151A3A);
  static const Color _brownText = Color(0xFF5B3F36);
  static const Color _lavender = Color(0xFFF3F3FE);
  static const Color _peach = Color(0xFFFFDCCB);
  static const Color _orange = Color(0xFFF97316);
  static const Color _brown = Color(0xFFB45309);

  bool get _isRiwayat => feature == GuestFeature.riwayat;

  String get _title =>
      _isRiwayat ? 'Masuk untuk Melihat Riwayat' : 'Masuk untuk Melihat Pesanan';

  String get _featureText => _isRiwayat
      ? 'E-Struk & Bukti Transaksi Digital Otomatis Tersimpan'
      : 'Pantau Status Pesanan Anda Secara Real-time';

  IconData get _mainIcon =>
      _isRiwayat ? Icons.receipt_long_rounded : Icons.shopping_bag_rounded;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        16 + (bottomInset > 16 ? bottomInset : 16) + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE3FB),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 14),

            // Badge "FITUR KHUSUS AKUN" + tombol close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _peach,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        size: 18,
                        color: Color(0xFF3B1500),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'FITUR KHUSUS AKUN',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF3B1500),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: _lavender,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: _brownText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ikon utama + badge gembok
            SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF7A1A), Color(0xFFB34100)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE8772E).withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      _mainIcon,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        size: 14,
                        color: _brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Judul
            Text(
              _title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _navy,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 8),

            // Deskripsi
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: _brownText,
                ),
                children: [
                  const TextSpan(text: 'Sebagai tamu ('),
                  const TextSpan(
                    text: 'guest',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                  TextSpan(
                    text: _isRiwayat
                        ? '), riwayat pesanan tidak tersimpan. Masuk ke akun untuk melihat e-struk & riwayat transaksi Anda.'
                        : '), pesanan aktif tidak dapat dipantau. Masuk ke akun untuk melihat status pesanan Anda.',
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),

            // Kotak fitur
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _lavender,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _peach,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      _isRiwayat
                          ? Icons.receipt_long_outlined
                          : Icons.timelapse_rounded,
                      size: 17,
                      color: _brown,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _featureText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _navy,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Tombol masuk ke akun -> langsung ke halaman login
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final navigator = Navigator.of(context);
                  navigator.pop(); // tutup sheet
                  navigator.push(
                    AuthPageRoute(
                      page: const LoginScreen(),
                      name: '/login',
                      fromRight: true,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: _orange.withValues(alpha: 0.45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Masuk ke Akun HotPay',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Tetap sebagai tamu -> tutup sheet
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Tetap Lanjut sebagai Tamu',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _brownText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}