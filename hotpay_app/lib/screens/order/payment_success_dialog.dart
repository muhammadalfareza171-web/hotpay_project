import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/hotpay_bottom_nav.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/order_session.dart';
import '../../models/menu_item.dart';
import '../../widgets/app_image.dart';

/// Modal Pop Up Dialog "Pembayaran Berhasil"
class PaymentSuccessDialog extends StatelessWidget {
  final MenuItem item;
  final String orderId;

  const PaymentSuccessDialog({
    super.key,
    required this.item,
    this.orderId = '#SB-98284',
  });

  static Future<void> show(
    BuildContext context, {
    required MenuItem item,
    String orderId = '#SB-98284',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (dialogContext) => PaymentSuccessDialog(item: item, orderId: orderId),
    );
  }

  static const _greenText = Color(0xFF047857);
  static const _greenSoft = Color(0xFFD5F5E6);
  static const _orange = Color(0xFFFF6A13);

  @override
  Widget build(BuildContext context) {
    final total = CurrencyFormatter.format(OrderSession.totalFor(item));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ikon centang hijau dengan ring
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Pill status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _greenSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 6, color: _greenText),
                  SizedBox(width: 5),
                  Text(
                    'TRANSMISI SELESAI',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: _greenText,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Judul
            const Text(
              'Pembayaran Berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),

            // Deskripsi
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: 'Pembayaran sebesar '),
                  TextSpan(
                    text: total,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const TextSpan(
                    text: ' telah diterima oleh sistem vending mesin.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Detail Pesanan Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  AppImage(
                    assetPath: item.imageAsset,
                    placeholderLabel: item.name,
                    width: 48,
                    height: 48,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${OrderSession.quantity}× ${item.name}',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$orderId • Slot #02 Mukakuning',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Tombol Utama: Ke Halaman Memasak
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(
                    context,
                    '/order-preparing',
                    arguments: item,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Lihat Status Mesin & Memasak',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Link E-Struk
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/receipt', arguments: item);
              },
              child: const Text(
                'Lihat E-Struk Digital',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB45309),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Halaman "Pembayaran Berhasil" (full page)
class PaymentSuccessScreen extends StatelessWidget {
  final MenuItem item;
  final String orderId;

  const PaymentSuccessScreen({
    super.key,
    required this.item,
    this.orderId = '#SB-98284',
  });

  static const _greenText = Color(0xFF047857);
  static const _greenSoft = Color(0xFFD5F5E6);
  static const _brown = Color(0xFF9A3C00);
  static const _orange = Color(0xFFFF6A13);

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final total = CurrencyFormatter.format(OrderSession.totalFor(item));

    return PopScope(
      // Tombol back tidak kembali ke halaman QRIS, tapi ke beranda
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const HotPayBottomNav(currentIndex: 1),
      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tombol close (kanan atas)
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => _goHome(context),
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDEBF7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Ikon centang dengan ring
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 62,
                      height: 62,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Pill TRANSMISI SELESAI
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _greenSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 6, color: _greenText),
                      SizedBox(width: 5),
                      Text(
                        'TRANSMISI SELESAI',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: _greenText,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Judul
                const Text(
                  'Pembayaran Berhasil!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Deskripsi
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                    children: [
                      const TextSpan(text: 'Pembayaran sebesar '),
                      TextSpan(
                        text: total,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ' telah kami terima. Mesin otomatis mulai memasak hidangan hangat Anda.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Kartu ringkasan pesanan (peach)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3EC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      // Nomor pesanan + LUNAS
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'NOMOR PESANAN',
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textMuted,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  orderId,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _greenSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'LUNAS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: _greenText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Item
                      Row(
                        children: [
                          AppImage(
                            assetPath: item.imageAsset,
                            placeholderLabel: item.name,
                            width: 52,
                            height: 52,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${OrderSession.quantity}× ${item.name}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  total,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Lokasi kios + slot
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE9DB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Kios VM-01 • Mukakuning',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _brown,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _brown,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Slot #02',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Info sensor pengambilan
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EFFC),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE2CF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sensors_rounded,
                          size: 16,
                          color: _orange,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 10.5,
                              height: 1.4,
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sensor Pengambilan Siap: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Dekati dispenser otomatis setelah indikator lampu baki berkedip hijau lembut.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol utama
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/order-preparing',
                        arguments: item,
                      );
                    },
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
                      child: const Text(
                        'Lihat Status Mesin &\nPengambilan Makanan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Link sekunder
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/receipt', arguments: item);
                  },
                  child: const Text(
                    'Unduh E-Struk Digital',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: _brown,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}