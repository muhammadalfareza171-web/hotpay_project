import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Bottom navigation HotPay: Menu | Pesanan | Riwayat.
///
/// Dipakai di SEMUA halaman (termasuk shell /main) supaya bentuknya seragam.
///
/// [currentIndex]: 0 = Menu, 1 = Pesanan, 2 = Riwayat.
/// - Kalau [onTap] diisi (dipakai di shell /main), tombol memanggil onTap.
/// - Kalau [onTap] kosong (halaman yang dibuka lewat Navigator.push),
///   tombol menavigasi ke route di bawah ini.
/// SESUAIKAN nama route dengan yang ada di MaterialApp kamu.
class HotPayBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const HotPayBottomNav({
    super.key,
    this.currentIndex = 1,
    this.onTap,
  });

  static const String menuRoute = '/main';
  static const String ordersRoute = '/order-preparing';
  static const String historyRoute = '/history';

  void _navigate(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
      return;
    }
    if (index == currentIndex) return;

    final route = switch (index) {
      0 => menuRoute,
      1 => ordersRoute,
      _ => historyRoute,
    };
    Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _item(context, 0, Icons.restaurant_menu_rounded, 'Menu'),
              _item(context, 1, Icons.soup_kitchen_rounded, 'Pesanan'),
              _item(context, 2, Icons.receipt_long_rounded, 'Riwayat'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, int index, IconData icon, String label) {
    final active = index == currentIndex;
    final color = active ? AppColors.primary : AppColors.textPrimary;

    return Expanded(
      child: InkWell(
        onTap: () => _navigate(context, index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}