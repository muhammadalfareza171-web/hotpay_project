import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/menu_item.dart';
import '../../widgets/hotpay_app_bar.dart';
import '../../widgets/app_image.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/kiosk_status_card.dart';
import 'menu_detail_sheet.dart';
import 'out_of_stock_dialog.dart';

class MenuScreen extends StatefulWidget {
  final Function(MenuItem item)? onSelectItem;

  const MenuScreen({
    super.key,
    this.onSelectItem,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'Semua';
  final List<String> _categories = ['Semua', 'Makanan Berat', 'Camilan'];
  final List<MenuItem> _allItems = MenuItem.sampleMenuItems;

  List<MenuItem> get _filteredItems {
    if (_selectedCategory == 'Semua') return _allItems;
    return _allItems.where((item) => item.category == _selectedCategory).toList();
  }

  void _onOrderTapped(MenuItem item) {
    if (!item.isAvailable) {
      OutOfStockDialog.show(context, item);
      return;
    }
    MenuDetailSheet.show(context, item);
  }

  @override
  Widget build(BuildContext context) {
    // Batasi skala teks agar layout tidak overflow di HP yang font-nya diperbesar.
    final mq = MediaQuery.of(context);

    return MediaQuery(
      data: mq.copyWith(
        textScaler: mq.textScaler.clamp(
          minScaleFactor: 0.9,
          maxScaleFactor: 1.0,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const HotPayAppBar(
          showBackButton: true,
          showProfile: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kicker Badge
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'OTOMATIS & HIGIENIS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.success,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Title
                    const Text(
                      'Mau makan apa hari ini?',
                      style: AppTextStyles.displayLarge,
                    ),
                    const SizedBox(height: 4),

                    // Subtitle
                    const Text(
                      'Pilih makanan hangat segar otomatis dari vending mesin',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Orange Promo Card
                    _buildPromoCard(),
                    const SizedBox(height: 20),

                    // Section Header: Pilihan Menu & Real-time Stok
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.restaurant_menu_rounded,
                                color: AppColors.primary,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Pilihan Menu',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Real-time Stok',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Category Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((cat) {
                          final isSelected = cat == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (val) {
                                if (val) {
                                  setState(() {
                                    _selectedCategory = cat;
                                  });
                                }
                              },
                              labelStyle: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                              selectedColor: AppColors.primary,
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              showCheckmark: false,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),

            // Menu Items List
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _filteredItems[index];
                    return _buildFoodCard(item);
                  },
                  childCount: _filteredItems.length,
                ),
              ),
            ),

            // Kiosk status: ikut tergulir di akhir daftar (sesuai foto)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
              sliver: SliverToBoxAdapter(
                child: KioskStatusCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // PROMO CARD (tinggi mengikuti isi -> tidak overflow)
  // =====================================================

  Widget _buildPromoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7A00), Color(0xFFFF5200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.orangeShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Watermark jam di kanan
            Positioned(
              right: -15,
              bottom: -15,
              child: Icon(
                Icons.timer_outlined,
                size: 130,
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ultra Fast Prep Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 13),
                        SizedBox(width: 4),
                        Text(
                          'ULTRA FAST PREP',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Makanan Hangat Segar dalam\n< 3 Menit!',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Penyajian otomatis 85°C tanpa sentuhan tangan, higienis dan langsung siap santap.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.88),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // FOOD CARD (disamakan dengan foto)
  // =====================================================

  Widget _buildFoodCard(MenuItem item) {
    final bool available = item.isAvailable;

    return GestureDetector(
      onTap: () => _onOrderTapped(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar + badge suhu / overlay HABIS
            SizedBox(
              width: 104,
              height: 104,
              child: AppImage(
                assetPath: item.imageAsset,
                placeholderLabel: item.name,
                width: 104,
                height: 104,
                borderRadius: BorderRadius.circular(12),
                isDarkOverlay: !available,
                badgeText: available ? item.temperature : null,
              ),
            ),
            const SizedBox(width: 12),

            // Info makanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pill stok + rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (available)
                        StatusBadge.portion(count: item.availablePortions)
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6E4F4),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Text(
                            'Stok kosong',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6B6A85),
                            ),
                          ),
                        ),
                      StatusBadge.rating(rating: item.rating),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Nama
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: available
                          ? AppColors.textPrimary
                          : AppColors.textPrimary.withValues(alpha: 0.75),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  // Deskripsi
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.3,
                      color: available
                          ? AppColors.textLight
                          : AppColors.textLight.withValues(alpha: 0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Harga + tombol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Harga Satuan',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 1),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                CurrencyFormatter.format(item.price),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),

                      if (available)
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () => _onOrderTapped(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE8772E),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: const Color(0xFFE8772E)
                                  .withValues(alpha: 0.45),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              minimumSize: const Size(0, 40),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, size: 16),
                                SizedBox(width: 3),
                                Text(
                                  'Pesan',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9E9F7),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.block_rounded,
                                size: 16,
                                color: Color(0xFF9A9AB5),
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Habis',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF9A9AB5),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}