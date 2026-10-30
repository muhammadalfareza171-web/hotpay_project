import 'package:flutter/material.dart';
import '../core/utils/session.dart';
import '../widgets/guest_login_sheet.dart';
import '../widgets/hotpay_bottom_nav.dart';
import 'menu/menu_screen.dart';
import 'order/order_preparing_screen.dart';
import 'history/history_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = const [
    MenuScreen(),
    OrderPreparingScreen(),
    HistoryScreen(),
  ];

  // index 0 = Menu, 1 = Pesanan, 2 = Riwayat
  void _onNavTap(int index) {
    // Tamu (guest) tidak bisa membuka Pesanan & Riwayat lewat tab:
    // munculkan popup ajakan masuk, dan tetap di halaman sekarang.
    if (Session.isGuest && index != 0) {
      GuestLoginSheet.show(
        context,
        feature: index == 1 ? GuestFeature.pesanan : GuestFeature.riwayat,
      );
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Pakai HotPayBottomNav yang sama dengan halaman Konfirmasi, QRIS, dll.
      bottomNavigationBar: HotPayBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}