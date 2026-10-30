import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/order_session.dart';
import '../../models/menu_item.dart';
import '../../widgets/hotpay_app_bar.dart';
import '../../widgets/hotpay_logo.dart';
import '../../widgets/app_image.dart';
import '../../widgets/custom_button.dart';

class ReceiptScreen extends StatelessWidget {
  final MenuItem? item;

  const ReceiptScreen({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    final foodItem = item ?? MenuItem.sampleMenuItems[2]; // Mie Sagu default

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const HotPayAppBar(
        showBackButton: true,
        showProfile: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              // Green Success Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDCFCE7), width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
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
                                'Transaksi Berhasil',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF047857),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'LUNAS',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF047857),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Sistem telah mengkonfirmasi pembayaran Anda via QRIS',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF065F46),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Official Receipt Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  children: [
                    // Brand Header
                    const HotPayLogo(
                      iconSize: 22,
                      fontSize: 17,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Vending Mesin Otomatis Makanan Hangat 24 Jam',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Total Paid
                    const Text(
                      'TOTAL PEMBAYARAN BERHASIL',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyFormatter.format(OrderSession.totalFor(foodItem)),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.infoLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_user_rounded, size: 12, color: AppColors.info),
                          SizedBox(width: 4),
                          Text(
                            'Server Resmi Bank Indonesia (QRIS)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Dashed separator
                    _buildDashedLine(),
                    const SizedBox(height: 14),

                    // Meta Details
                    _buildDetailRow('No. Transaksi', '#SB-98284', isCopyable: true),
                    const SizedBox(height: 8),
                    _buildDetailRow('Waktu & Tanggal', '24 Okt 2024, 12:30:15 WIB'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Lokasi Kios', 'Kios VM-01 (Bay A-02)\nPT Jaya Abadi Mukakuning'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Metode', 'QRIS Dinamis'),
                    const SizedBox(height: 8),
                    _buildDetailRow('RRN / TID', '000182746194 / SB-NT-01'),

                    const SizedBox(height: 16),
                    _buildDashedLine(),
                    const SizedBox(height: 14),

                    // Rincian Menu Siap Saji
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'RINCIAN MENU SIAP SAJI',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Food Item Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: AppImage(
                            assetPath: foodItem.imageAsset,
                            placeholderLabel: foodItem.name,
                            width: 52,
                            height: 52,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    foodItem.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.format(OrderSession.totalFor(foodItem)),
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Kuantitas: ${OrderSession.quantity} porsi',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const Text(
                                'Suhu Baki Hangat 85°C | Dispenser Slot: Bay A-02',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Specs subtable
                    _buildSpecSubRow('Porsi Standar: 1 Mangkok (350g)', 'Standar'),
                    const SizedBox(height: 4),
                    _buildSpecSubRow('Suhu Siap Hangat: 85°C Dispenser', 'Optimal'),
                    const SizedBox(height: 4),
                    _buildSpecSubRow('Waktu Siap Otomatis: < 3 Menit', 'Otomatis'),

                    const SizedBox(height: 14),
                    _buildDashedLine(),
                    const SizedBox(height: 12),

                    // Financial Breakdown
                    _buildPriceRow('Subtotal ${OrderSession.quantity} Porsi', CurrencyFormatter.format(OrderSession.totalFor(foodItem))),
                    const SizedBox(height: 6),
                    _buildPriceRow('Biaya Layanan Kios Otomatis', 'GRATIS', valueColor: AppColors.success),
                    const SizedBox(height: 6),
                    _buildPriceRow('Pajak Restoran (PB1 10%)', 'Sudah Termasuk'),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Bersih',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(OrderSession.totalFor(foodItem)),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              CustomButton(
                text: 'Unduh E-Struk Resmi (PDF)',
                leadingIcon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('E-Struk berhasil diunduh ke memori HP!')),
                  );
                },
              ),
              const SizedBox(height: 12),

              CustomButton(
                type: ButtonType.outline,
                text: 'Bagikan ke WhatsApp / Email',
                leadingIcon: const Icon(Icons.share_outlined, size: 18, color: AppColors.textPrimary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka dialog bagikan...')),
                  );
                },
              ),
              const SizedBox(height: 14),

              // Navigation Link to Preparation
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/order-preparing', arguments: foodItem);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text(
                        'Lihat Status Dispenser & Pengambilan Makanan →',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
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
    );
  }

  Widget _buildDetailRow(String title, String val, {bool isCopyable = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11.5,
            color: AppColors.textMuted,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              val,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (isCopyable) ...[
              const SizedBox(width: 4),
              const Icon(Icons.copy_rounded, size: 13, color: AppColors.textMuted),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSpecSubRow(String text, String badge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '• $text',
          style: const TextStyle(fontSize: 10.5, color: AppColors.textLight),
        ),
        Text(
          badge,
          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String title, String val, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
        ),
        Text(
          val,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return Row(
      children: List.generate(
        35,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : AppColors.border,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}