import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Logo HotPay memakai gambar logo sendiri.
///
/// 1) Simpan gambar di: assets/images/logo_hotpay.png
///    (ubah [logoAsset] di bawah jika nama/format file Anda berbeda)
/// 2) Pastikan folder assets terdaftar di pubspec.yaml (lihat catatan).
class HotPayLogo extends StatelessWidget {
  /// Lokasi gambar logo Anda.
  static const String logoAsset = 'assets/images/logo_hotpay_full.png';

  final bool showSubtitle;
  final double iconSize;
  final double fontSize;
  final Color? textColor;

  /// true  = gambar logo + tulisan "HotPay" di sebelahnya (seperti sebelumnya).
  /// false = hanya gambar logo (pakai ini jika gambar Anda sudah ada tulisannya).
  final bool showText;

  /// Tidak perlu diisi: logo sudah transparan. Isi hanya jika memakai gambar
  /// yang masih punya latar. Latar belakang gambar logo
  /// (yang putih/terang) akan menyatu dengan warna ini.
  /// Isi `null` jika gambar logo Anda sudah transparan (PNG tanpa latar).
  final Color? barColor;

  const HotPayLogo({
    super.key,
    this.showSubtitle = true,
    this.iconSize = 28,
    this.fontSize = 20,
    this.textColor,
    this.showText = true,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final double size = iconSize + 8;

    final Widget logo = Image.asset(
      logoAsset,
      height: size,
      fit: BoxFit.contain,
      // Menyatukan latar gambar dengan warna bar (multiply).
      color: barColor,
      colorBlendMode: barColor == null ? null : BlendMode.multiply,
      // Jika file belum ada / salah nama, tampilkan ikon api sementara.
      errorBuilder: (context, error, stackTrace) {
        // Muncul di Debug Console jika gambar logo gagal dimuat.
        debugPrint('LOGO GAGAL DIMUAT dari "$logoAsset": $error');
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: iconSize,
          ),
        );
      },
    );

    if (!showText) return logo;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logo,
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'HotPay',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    color: textColor ?? AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            if (showSubtitle)
              Text(
                'HOT FOOD VENDING MESIN',
                style: TextStyle(
                  fontSize: fontSize * 0.42,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.6,
                ),
              ),
          ],
        ),
      ],
    );
  }
}