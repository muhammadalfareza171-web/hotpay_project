import 'package:flutter/material.dart';
import 'services/api_service.dart';
// 1. Tambahkan import untuk memanggil halaman splash screen yang baru dibuat
import 'screens/splash/home_splash_screen.dart'; 
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/session.dart';
import 'models/menu_item.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/order/order_confirmation_screen.dart';
import 'screens/order/qris_payment_screen.dart';
import 'screens/order/receipt_screen.dart';
import 'screens/order/order_preparing_screen.dart';
import 'screens/order/order_completed_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/help/help_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Baca status login yang tersimpan sebelum aplikasi tampil.
  await Session.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const HotPayApp());
}

class HotPayApp extends StatelessWidget {
  const HotPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'HotPay App',
      debugShowCheckedModeBanner: false, // Menghilangkan pita "DEBUG" di pojok kanan atas
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      // 2. UBAH BAGIAN INI: Jadikan HomeSplashScreen sebagai halaman awal
      home: const HomeSplashScreen(), 
    );
  }
}

// ============================================================================
// Kode CatalogScreen Anda tetap dipertahankan di bawah sini.
// Nantinya ini akan digunakan saat user menekan tombol "Mulai Pesan Sekarang"
// ============================================================================

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _apiService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Makanan HotPay'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gagal terhubung ke Server Laravel:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
=======
      title: 'HotPay - Hot Food Vending Mesin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Sudah login sebelumnya -> langsung ke halaman utama, tanpa login lagi.
      // Belum login / tamu -> mulai dari splash.
      home: Session.isLoggedIn
          ? const MainNavigationScreen()
          : const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/otp':
            return MaterialPageRoute(builder: (_) => const OtpScreen());
          case '/main':
            final index = settings.arguments as int? ?? 0;
            return MaterialPageRoute(
              builder: (_) => MainNavigationScreen(initialIndex: index),
>>>>>>> 0c823a3594a1f1f87a67cb42923f696c53fa512c
            );
          case '/order-confirmation':
            final item = settings.arguments as MenuItem?;
            return MaterialPageRoute(
              builder: (_) => OrderConfirmationScreen(item: item),
            );
          case '/qris-payment':
            final item = settings.arguments as MenuItem?;
            return MaterialPageRoute(
              builder: (_) => QrisPaymentScreen(item: item),
            );
          case '/receipt':
            final item = settings.arguments as MenuItem?;
            return MaterialPageRoute(
              builder: (_) => ReceiptScreen(item: item),
            );
          case '/order-preparing':
            final item = settings.arguments as MenuItem?;
            return MaterialPageRoute(
              builder: (_) => OrderPreparingScreen(item: item),
            );
          case '/order-completed':
            final item = settings.arguments as MenuItem?;
            return MaterialPageRoute(
              builder: (_) => OrderCompletedScreen(item: item),
            );
          case '/history':
            // Tab Riwayat di dalam shell /main (bukan halaman terpisah),
            // supaya bottom nav tetap konsisten dan sesi login tidak hilang.
            return MaterialPageRoute(
              builder: (_) => const MainNavigationScreen(initialIndex: 2),
            );
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/help':
            return MaterialPageRoute(builder: (_) => const HelpScreen());
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}