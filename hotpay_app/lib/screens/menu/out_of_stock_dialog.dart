import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/menu_item.dart';
import '../../widgets/app_image.dart';
import '../../widgets/login_required_dialog.dart';
import 'menu_detail_sheet.dart';

class OutOfStockDialog extends StatelessWidget {
  final MenuItem item;
  final ValueChanged<MenuItem> onPickRecommendation;

  const OutOfStockDialog({
    super.key,
    required this.item,
    required this.onPickRecommendation,
  });

  static const Color _brown = Color(0xFFB45309);
  static const Color _lavender = Color(0xFFF0EFFB);
  static const Color _lavenderDark = Color(0xFFE6E5F6);
  static const Color _red = Color(0xFFDC2626);

  static Future<void> show(BuildContext context, MenuItem item) {
    if (!LoginRequiredDialog.guard(context)) return Future<void>.value();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => OutOfStockDialog(
        item: item,
        onPickRecommendation: (rec) {
          Navigator.pop(sheetContext);
          MenuDetailSheet.show(context, rec);
        },
      ),
    );
  }

  /// Menu rekomendasi: menu tersedia selain item ini (Mie Sagu & Luti Gendang Ikan diutamakan).
  List<MenuItem> get _recommendations {
    final available = MenuItem.sampleMenuItems
        .where((m) => m.isAvailable && m.id != item.id)
        .toList();

    final preferred = available
        .where((m) => m.id == 'm3' || m.id == 'm4')
        .toList();
    final others = available.where((m) => !preferred.contains(m)).toList();

    return [...preferred, ...others].take(2).toList();
  }

  String _prepTime(MenuItem m) {
    final t = m.cookTime.replaceAll(' Otomatis', '').replaceAll(' Cepat', '');
    return 'Siap $t';
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final double bottomInset = mq.viewPadding.bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: mq.size.height * 0.92),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        // Minimal 32px jarak bawah agar tombol tidak mepet tombol navigasi HP
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          16 + (bottomInset > 16 ? bottomInset : 16) + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Badge sold out + tombol close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 14, color: _red),
                      SizedBox(width: 5),
                      Text(
                        'Porsi Terjual Habis (Sold Out)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _red,
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
                      color: _lavenderDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Judul
            const Text(
              'Yah, Porsi Hidangan Ini Sedang Habis!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.2,
                color: AppColors.textPrimary,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Maaf, ${item.name} di Kios VM-01 sedang dalam proses restok oleh operator kios kami.',
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),

            // Kartu item habis
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _lavender,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1D5DB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.soup_kitchen_outlined,
                          size: 24,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textMuted,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: _red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Flexible(
                                  child: Text(
                                    '0 Porsi Tersedia',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: _red,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Flexible(
                                  child: Text(
                                    '• Slot Baki B1 Kosong',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        CurrencyFormatter.format(item.price),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _lavenderDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Menu ini terkunci otomatis demi menjaga kepuasan Anda dan tidak dapat dimasukkan ke keranjang.',
                            style: TextStyle(
                              fontSize: 10.5,
                              height: 1.35,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Rekomendasi
            const Row(
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6),
                Text(
                  'Rekomendasi Menu Lainnya',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Coba hidangan lezat berkuah hangat yang siap santap sekarang:',
              style: TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            ..._recommendations.map(_buildRecommendationRow),

            const SizedBox(height: 6),

            // Tombol bawah
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.restaurant_menu_rounded, size: 18),
                label: const Text(
                  'Lihat Menu Tersedia Lainnya',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8772E),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor:
                      const Color(0xFFE8772E).withValues(alpha: 0.40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationRow(MenuItem rec) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          AppImage(
            assetPath: rec.imageAsset,
            placeholderLabel: rec.name,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatter.format(rec.price),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _brown,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${rec.availablePortions} porsi',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '• ${_prepTime(rec)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => onPickRecommendation(rec),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE8772E),
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: const Color(0xFFE8772E).withValues(alpha: 0.40),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pilih',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}