import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const HotPayApp());

class HotPayApp extends StatelessWidget {
  const HotPayApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'HotPay',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const SplashScreen(),
      );
}
