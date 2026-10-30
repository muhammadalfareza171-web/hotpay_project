import 'package:flutter/material.dart';
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