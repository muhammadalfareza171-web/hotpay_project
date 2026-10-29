import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import 'guest_sheet.dart';
import 'menu_detail_screen.dart';
import 'profile_screen.dart';
import 'riwayat_screen.dart';
import 'sold_out_sheet.dart';

/// Rute beranda bernama '/home' agar alur pesanan bisa kembali ke sini (popToHome).
Route<void> homeRoute({bool guest = false, int tab = 0}) => MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/home'),
      builder: (_) => DashboardScreen(guest: guest, initialTab: tab),
    );

class DashboardScreen extends StatefulWidget {
  final bool guest;
  final int initialTab;
  const DashboardScreen({super.key, this.guest = false, this.initialTab = 0});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const filters = ['Semua', 'Makanan Berat', 'Camilan'];
  String filter = 'Semua';
  late int tab = widget.initialTab;

  List<MenuItem> get items => filter == 'Semua' ? menus : menus.where((m) => m.category == filter).toList();

  void _open(MenuItem m) {
    if (m.soldOut) {
      showSoldOutSheet(context, m);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => MenuDetailScreen(item: m)));
    }
  }

  Widget _card(MenuItem m) => GestureDetector(
        onTap: () => _open(m),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FoodImage(m.image, width: 84, height: 100, radius: 14),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: m.soldOut ? AppColors.redSoft : AppColors.orangeSoft, borderRadius: BorderRadius.circular(6)),
                    child: Text(m.soldOut ? 'Stok habis' : 'Tersedia ${m.stock} porsi',
                        style: ts(9, w: FontWeight.w800, c: m.soldOut ? AppColors.red : AppColors.brown)),
                  ),
                  const Spacer(),
                  const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                  Text(' ${m.rating}', style: ts(10, w: FontWeight.w800)),
                ]),
                const SizedBox(height: 6),
                Text(m.name, style: ts(14, w: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(m.desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: ts(10, c: AppColors.muted, h: 1.4)),
                const SizedBox(height: 8),
                Row(children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Harga Satuan', style: ts(9, c: AppColors.muted)),
                    Text(rp(m.price), style: ts(13, w: FontWeight.w800)),
                  ]),
                  const Spacer(),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: () => _open(m),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: m.soldOut ? AppColors.field : AppColors.orange,
                        foregroundColor: m.soldOut ? AppColors.muted : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: Icon(m.soldOut ? Icons.block : Icons.add, size: 14),
                      label: Text(m.soldOut ? 'Habis' : 'Pesan', style: ts(11, w: FontWeight.w800, c: m.soldOut ? AppColors.muted : Colors.white)),
                    ),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      );

  void _profile() {
    if (widget.guest) {
      showGuestSheet(context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
    }
  }

  Widget _menuTab() => ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
        BrandHeader(showBack: widget.guest, trailing: AvatarButton(onTap: _profile)),
        Text('OTOMATIS & HIGIENIS', style: ts(9, w: FontWeight.w800, c: AppColors.orange)),
        const SizedBox(height: 4),
        Text('Mau makan apa hari ini?', style: ts(22, w: FontWeight.w800)),
        Text('Pilih hidangan hangat segar otomatis dari vending mesin.', style: ts(12, c: AppColors.muted)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.orange, AppColors.orangeDark]),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ULTRA FAST PREP', style: ts(9, w: FontWeight.w800, c: Colors.white)),
            const SizedBox(height: 6),
            Text('Makanan Hangat Segar dalam < 3 Menit!', style: ts(16, w: FontWeight.w800, c: Colors.white)),
            const SizedBox(height: 4),
            Text('Pesanan dipanaskan di 85°C secara otomatis, siap diambil tanpa antre.', style: ts(10, c: Colors.white, h: 1.4)),
          ]),
        ),
        const SizedBox(height: 18),
        Row(children: [
          Text('Pilihan Menu', style: ts(16, w: FontWeight.w800)),
          const Spacer(),
          Text('Real-time Stok', style: ts(10, w: FontWeight.w700, c: AppColors.orange)),
        ]),
        const SizedBox(height: 10),
        SizedBox(
          height: 34,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            for (final f in filters)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(f, style: ts(11, w: FontWeight.w800, c: filter == f ? Colors.white : AppColors.muted)),
                  selected: filter == f,
                  showCheckmark: false,
                  selectedColor: AppColors.orange,
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                  onSelected: (_) => setState(() => filter = f),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 12),
        for (final m in items) _card(m),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            const Icon(Icons.storefront, color: AppColors.orange),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Kiosk VM-01 Mukakuning', style: ts(12, w: FontWeight.w800)),
                Text('Suhu saat ini 85°C Normal • QRIS Aktif & Siap Saji', style: ts(9, c: AppColors.muted)),
              ]),
            ),
            pill('ONLINE', AppColors.greenSoft, AppColors.green),
          ]),
        ),
      ]);

  Widget _ordersTab() => ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
        BrandHeader(subtitle: 'PESANAN', trailing: AvatarButton(onTap: _profile)),
        ValueListenableBuilder<Order?>(
          valueListenable: OrderStore.active,
          builder: (context, o, _) => o == null
              ? Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(children: [
                    const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.muted),
                    const SizedBox(height: 10),
                    Text('Belum ada pesanan aktif', style: ts(14, w: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('Pilih menu hangat favorit Anda dulu.', style: ts(11, c: AppColors.muted)),
                    const SizedBox(height: 16),
                    SizedBox(width: 200, child: PrimaryButton(label: 'Lihat Menu', onPressed: () => setState(() => tab = 0))),
                  ]),
                )
              : ActiveOrderCard(order: o),
        ),
      ]);

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.orangeSoft,
          onDestinationSelected: (i) {
            if (i == 2 && widget.guest) {
              showGuestSheet(context);
            } else {
              setState(() => tab = i);
            }
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Pesanan'),
            NavigationDestination(icon: Icon(Icons.history), label: 'Riwayat'),
          ],
        ),
        body: SafeArea(child: tab == 0 ? _menuTab() : (tab == 1 ? _ordersTab() : const HistoryView())),
      );
}
