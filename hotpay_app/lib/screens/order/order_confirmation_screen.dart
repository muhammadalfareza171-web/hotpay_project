import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/order_session.dart';
import '../../models/menu_item.dart';
import '../../widgets/hotpay_app_bar.dart';
import '../../widgets/hotpay_bottom_nav.dart';
import '../../widgets/app_image.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/error_notification_popup.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final MenuItem? item;

  const OrderConfirmationScreen({super.key, this.item});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  late MenuItem _item;
  bool _isQrisSelected = true;

  @override
  void initState() {
    super.initState();
    _item = widget.item ?? MenuItem.sampleMenuItems[2]; // Default Mie Sagu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: const HotPayAppBar(
        showBackButton: true,
        showProfile: true,
      ),
      bottomNavigationBar: const HotPayBottomNav(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Konfirmasi Pesanan',
                      style: AppTextStyles.displayMedium,
                    ),
                    const SizedBox(height: 14),

                    // Vending Machine Location Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.store_mall_directory_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Vending Machine #VM-01',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              StatusBadge.success(text: '● Siap Masak'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'PT Jaya Abadi Mukakuning',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.thermostat_rounded, size: 13, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text(
                                'Status: 85°C Aktif • ± 180s Dispense',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section: Ringkasan Makanan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.receipt_long_rounded, size: 18, color: AppColors.primary),
                            SizedBox(width: 6),
                            Text(
                              'Ringkasan Makanan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Text(
                            '${OrderSession.quantity} Porsi',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Food Item Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 1),
                        boxShadow: AppColors.softShadow,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: AppImage(
                                  assetPath: _item.imageAsset,
                                  placeholderLabel: _item.name,
                                  width: 70,
                                  height: 70,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${OrderSession.quantity}x ${_item.name}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      CurrencyFormatter.format(OrderSession.totalFor(_item)),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceSecondary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        '🍽️ Siap Santap Cepat',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(),
                          const SizedBox(height: 6),

                          // Spec lines
                          _buildSpecLine('Porsi & Ukuran', _item.portionWeight),
                          const SizedBox(height: 6),
                          _buildSpecLine('Pemanasan OTOMATIS', '< 3 Menit'),
                          const SizedBox(height: 6),
                          _buildSpecLine('Suhu Penyajian', 'Garansi Panas 85°C'),

                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 6),

                          // Subtotal
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal Ringkasan\n(${OrderSession.quantity} Menu Siap Saji Kios)',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(OrderSession.totalFor(_item)),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section: Metode Pembayaran
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.payment_rounded, size: 18, color: AppColors.primary),
                            SizedBox(width: 6),
                            Text(
                              'Metode Pembayaran',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        StatusBadge.success(text: 'Otomatis Terverifikasi'),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // QRIS Payment Option (Interaktif: berubah outline & warna saat dipencet)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isQrisSelected = !_isQrisSelected;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _isQrisSelected ? const Color(0xFFFFF9F5) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isQrisSelected ? AppColors.primary : AppColors.border,
                            width: _isQrisSelected ? 2.0 : 1.2,
                          ),
                          boxShadow: _isQrisSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.16),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : AppColors.softShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _isQrisSelected
                                        ? const Color(0xFFFFECE0)
                                        : const Color(0xFFFFF2E8),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.qr_code_scanner_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'QRIS Terpadu',
                                            style: TextStyle(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFDCFCE7),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'Instan',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF047857),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        'Semua E-Wallet & Mobile Banking',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _isQrisSelected
                                    ? const Color(0xFFFFF2E6)
                                    : AppColors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 14,
                                    color: _isQrisSelected ? AppColors.primary : AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 6),
                                  const Expanded(
                                    child: Text(
                                      'Kode QRIS dinamis akan dibuat otomatis setelah konfirmasi dan terhubung langsung ke sistem dispenser mesin.',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: AppColors.textSecondary,
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: CustomButton(
                text: 'Lanjut ke Pembayaran QRIS',
                trailingIcon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                onPressed: () {
                  if (!_isQrisSelected) {
                    ErrorNotificationPopup.showNotification(
                      context,
                      title: 'Pilih Metode Pembayaran',
                      message: 'Silakan klik dan aktifkan pembayaran QRIS terlebih dahulu.',
                    );
                    return;
                  }
                  Navigator.pushNamed(context, '/qris-payment', arguments: _item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecLine(String title, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '• $title',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          val,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}