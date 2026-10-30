import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/order_model.dart';
import '../../widgets/hotpay_app_bar.dart';
import '../../widgets/app_image.dart';
import '../menu/menu_detail_sheet.dart';
import '../menu/out_of_stock_dialog.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Warna sesuai desain
  static const Color _bg = Color(0xFFF5F4FF);
  static const Color _panel = Color(0xFFEEEDFB);
  static const Color _ink = Color(0xFF1E1B3A);
  static const Color _peach = Color(0xFFFFDCC8);
  static const Color _brown = Color(0xFF7A3E1D);
  static const Color _mint = Color(0xFFD7F7E5);
  static const Color _mintText = Color(0xFF047857);

  /// Nama menu yang sedang dimasak (sama dengan banner "Sedang Dipanaskan").
  static const String _activeItemName = 'Mie Sagu';

  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Selesai', 'Diproses'];
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Penentu pesanan yang masih diproses.
  /// GANTI dengan `order.status` kalau OrderModel kamu punya field status.
  bool _isInProgress(OrderModel order) {
    return order.items.first.item.name == _activeItemName;
  }

  List<OrderModel> get _filteredOrders {
    final query = _searchController.text.trim().toLowerCase();
    return OrderModel.sampleHistory.where((order) {
      final inProgress = _isInProgress(order);
      if (_selectedFilter == 'Selesai' && inProgress) return false;
      if (_selectedFilter == 'Diproses' && !inProgress) return false;
      if (query.isEmpty) return true;
      final name = order.items.first.item.name.toString().toLowerCase();
      return name.contains(query) ||
          order.orderId.toString().toLowerCase().contains(query);
    }).toList();
  }

  List<BoxShadow> get _cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final orders = _filteredOrders;

    return Scaffold(
      backgroundColor: _bg,
      appBar: const HotPayAppBar(
        showBackButton: false,
        showProfile: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(),
              const SizedBox(height: 16),
              _buildActiveBanner(),
              const SizedBox(height: 18),
              _buildSearchBar(),
              const SizedBox(height: 14),
              _buildFilters(),
              const SizedBox(height: 18),
              const Text(
                'Riwayat Pesanan',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 12),
              if (orders.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'Tidak ada riwayat yang cocok.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                )
              else
                ...orders.map(_buildOrderCard),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // KARTU RINGKASAN USER
  // =====================================================

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: _cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: _panel,
                child: Text(
                  'AP',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, Ahmad Pratama',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'ID: #SB-98421',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // SESUAIKAN nama route profil dengan MaterialApp kamu.
              Material(
                color: _panel,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.manage_accounts_outlined,
                      size: 20,
                      color: _ink,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Total Pesanan',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '12',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Menu Favorit',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Mie Sagu',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // BANNER PESANAN AKTIF
  // =====================================================

  Widget _buildActiveBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _peach,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Flexible(
                      child: Text(
                        'SEDANG DIPANASKAN (85°C)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: _brown,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 12, color: _brown),
                    SizedBox(width: 4),
                    Text(
                      '1 Menit Lagi',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: _brown,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _activeItemName,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.storefront_outlined,
                            size: 13, color: AppColors.textLight),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Slot Dispenser A2 • Kios VM-01',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.soup_kitchen_rounded,
                  size: 28,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.8,
              minHeight: 6,
              color: AppColors.primary,
              backgroundColor: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/order-preparing'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pantau Live Status',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 17),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // SEARCH & FILTER
  // =====================================================

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(fontSize: 13.5, color: _ink),
      decoration: InputDecoration(
        hintText: 'Cari riwayat transaksi atau menu...',
        hintStyle: const TextStyle(
          fontSize: 13.5,
          color: AppColors.textMuted,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 20,
          color: AppColors.textMuted,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        for (int i = 0; i < _filters.length; i++) ...[
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = _filters[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _filters[i] == _selectedFilter ? _ink : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _filters[i],
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: _filters[i] == _selectedFilter
                        ? Colors.white
                        : _ink,
                  ),
                ),
              ),
            ),
          ),
          if (i != _filters.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }

  // =====================================================
  // KARTU RIWAYAT
  // =====================================================

  Widget _buildOrderCard(OrderModel order) {
    final item = order.items.first.item;
    final inProgress = _isInProgress(order);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: _cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: id + waktu + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: order.orderId,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: _ink,
                            ),
                          ),
                          TextSpan(
                            text: ' • ${order.orderTime}',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.storefront_outlined,
                            size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${order.kioskName} • ${order.kioskLocation}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusPill(inProgress),
            ],
          ),
          const SizedBox(height: 12),

          // Panel item
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        '${item.name} (${order.items.first.quantity}x)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _ink,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _mint,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: const Color(0xFFA7E6C4),
                            width: 0.8,
                          ),
                        ),
                        child: const Text(
                          'QRIS • Lunas',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: _mintText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    CurrencyFormatter.format(order.totalAmount),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tombol aksi
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  label: 'Unduh E-Struk',
                  icon: Icons.receipt_long_outlined,
                  background: _panel,
                  foreground: _ink,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/receipt',
                    arguments: item,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: inProgress
                    ? _actionButton(
                        label: 'Pantau Status',
                        icon: Icons.arrow_forward_rounded,
                        iconAtEnd: true,
                        background: const Color(0xFF9A3F00),
                        foreground: Colors.white,
                        onTap: () =>
                            Navigator.pushNamed(context, '/order-preparing'),
                      )
                    : _actionButton(
                        label: 'Pesan Lagi',
                        icon: Icons.replay_rounded,
                        background: AppColors.primary,
                        foreground: Colors.white,
                        onTap: () {
                          if (!item.isAvailable) {
                            OutOfStockDialog.show(context, item);
                            return;
                          }
                          MenuDetailSheet.show(context, item);
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(bool inProgress) {
    if (inProgress) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.35),
          ),
        ),
        child: const Text(
          'Sedang Disiapkan',
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _mint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF86DDB0), width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline_rounded,
              size: 12, color: _mintText),
          SizedBox(width: 4),
          Text(
            'Selesai',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: _mintText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
    bool iconAtEnd = false,
  }) {
    final iconWidget = Icon(icon, size: 16);
    final text = Flexible(
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
      ),
    );

    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconAtEnd
              ? [text, const SizedBox(width: 6), iconWidget]
              : [iconWidget, const SizedBox(width: 6), text],
        ),
      ),
    );
  }
}