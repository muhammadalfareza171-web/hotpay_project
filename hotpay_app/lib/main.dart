import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/utils/session.dart';
import 'core/utils/operator_session.dart';
import 'models/menu_item.dart';
import 'screens/splash_screen.dart';
import 'screens/splash/home_splash_screen.dart';
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
import 'screens/operator/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Session.init();
  await OperatorSession.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.header, // #EAEDFF opacity 85% menyatu dengan header
      statusBarIconBrightness: Brightness.dark, // Jam, wifi, sinyal warna gelap
      statusBarBrightness: Brightness.light, // Untuk iOS
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
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
      // Sudah login ΓåÆ ke halaman utama customer; belum ΓåÆ splash home
      home: Session.isLoggedIn
          ? const MainNavigationScreen()
          : const HomeSplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/home-splash':
            return MaterialPageRoute(builder: (_) => const HomeSplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/otp':
            final phoneArg = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (_) => OtpScreen(phone: phoneArg),
              settings: settings,
            );
          case '/main':
            final index = settings.arguments as int? ?? 0;
            return MaterialPageRoute(
              builder: (_) => MainNavigationScreen(initialIndex: index),
            );
          case '/operator-main':
            return MaterialPageRoute(
              builder: (_) => const DashboardScreen(),
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
            return MaterialPageRoute(
              builder: (_) => const MainNavigationScreen(initialIndex: 2),
            );
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/help':
            return MaterialPageRoute(builder: (_) => const HelpScreen());
          default:
            return MaterialPageRoute(builder: (_) => const HomeSplashScreen());
        }
      },
    );
  }
}
