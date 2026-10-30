import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/hotpay_bottom_nav.dart';
import '../../core/utils/active_order.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/order_session.dart';
import '../../models/menu_item.dart';
import '../../widgets/hotpay_app_bar.dart';
import '../../widgets/custom_button.dart';
import 'payment_success_dialog.dart';

class QrisPaymentScreen extends StatefulWidget {
  final MenuItem? item;

  const QrisPaymentScreen({super.key, this.item});

  @override
  State<QrisPaymentScreen> createState() => _QrisPaymentScreenState();
}

class _QrisPaymentScreenState extends State<QrisPaymentScreen> {
  late MenuItem _item;
  int _secondsRemaining = 298; // 04:58
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _item = widget.item ?? MenuItem.sampleMenuItems[2]; // Default Mie Sagu
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTimer {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _simulatePaymentSuccess() {
    _timer?.cancel();
    ActiveOrder.start(_item); // pesanan mulai dimasak
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(item: _item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HotPayAppBar(
        showBackButton: true,
        showProfile: true,
      ),
      bottomNavigationBar: const HotPayBottomNav(currentIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Order Number & Total Tagihan Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'No. Pesanan:',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Text(
                              '#SB-98284',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Nomor pesanan disalin!')),
                                );
                              },
                              child: const Icon(
                                Icons.copy_rounded,
                                size: 14,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Tagihan',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(OrderSession.totalFor(_item)),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // QRIS Payment Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 1.2),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  children: [
                    // Header: QRIS & GPN Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'QRIS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF1E2022),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5E7EB),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'QR Code Standar\nPembayaran Nasional',
                                style: TextStyle(
                                  fontSize: 6,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // GPN Red/Blue eagle mark
                        Row(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'GPN',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // QR Code Frame with Red corners
                    Container(
                      width: 210,
                      height: 210,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Indonesian QRIS Red Corner Accents
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(width: 24, height: 4, color: const Color(0xFFEF4444)),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(width: 4, height: 24, color: const Color(0xFFEF4444)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(width: 24, height: 4, color: const Color(0xFFEF4444)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(width: 4, height: 24, color: const Color(0xFFEF4444)),
                          ),

                          // QR Pattern (Custom Drawn QR Graphic)
                          _buildQrGraphic(),

                          // Center HotPay Mini Mark
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary, width: 1.5),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.local_fire_department_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Timer Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF2E8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFFD8BF), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer_outlined, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Bayar sebelum $_formattedTimer',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Instruction Text
                    const Text(
                      'Pindai kode QR di atas menggunakan aplikasi e-wallet atau mobile banking favorit Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textLight,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Save to Gallery Button
              CustomButton(
                type: ButtonType.outline,
                text: 'SIMPAN KODE QR KE GALERI',
                leadingIcon: const Icon(Icons.download_rounded, size: 18, color: AppColors.textPrimary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kode QR berhasil disimpan ke galeri!')),
                  );
                },
              ),
              const SizedBox(height: 14),

              // Simulasi pembayaran berhasil -> pindah ke halaman Pembayaran Berhasil
              CustomButton(
                text: 'Simulasi Pembayaran Berhasil',
                trailingIcon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                onPressed: _simulatePaymentSuccess,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrGraphic() {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        painter: _QrisPatternPainter(),
      ),
    );
  }
}

class _QrisPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E2022)
      ..style = PaintingStyle.fill;

    const blockSize = 6.0;
    final cols = (size.width / blockSize).floor();
    final rows = (size.height / blockSize).floor();

    // Deterministic pseudo-random pattern for QR looks
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        // Corners big markers
        final inTopLeft = (r < 7 && c < 7);
        final inTopRight = (r < 7 && c >= cols - 7);
        final inBottomLeft = (r >= rows - 7 && c < 7);

        if (inTopLeft || inTopRight || inBottomLeft) {
          // outer border
          final isBorder = (r == 0 || r == 6 || c == 0 || c == 6) && inTopLeft ||
              (r == 0 || r == 6 || c == cols - 7 || c == cols - 1) && inTopRight ||
              (r == rows - 7 || r == rows - 1 || c == 0 || c == 6) && inBottomLeft;
          // center dot
          final isCenter = (r >= 2 && r <= 4 && c >= 2 && c <= 4) && inTopLeft ||
              (r >= 2 && r <= 4 && c >= cols - 5 && c <= cols - 3) && inTopRight ||
              (r >= rows - 5 && r <= rows - 3 && c >= 2 && c <= 4) && inBottomLeft;

          if (isBorder || isCenter) {
            canvas.drawRect(
              Rect.fromLTWH(c * blockSize, r * blockSize, blockSize - 0.5, blockSize - 0.5),
              paint,
            );
          }
        } else {
          // Center clearing for logo
          if (r >= rows ~/ 2 - 3 && r <= rows ~/ 2 + 3 && c >= cols ~/ 2 - 3 && c <= cols ~/ 2 + 3) {
            continue;
          }
          // QR noise pattern
          if ((r * 13 + c * 17 + (r ^ c)) % 3 == 0) {
            canvas.drawRect(
              Rect.fromLTWH(c * blockSize, r * blockSize, blockSize - 0.5, blockSize - 0.5),
              paint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}