import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../auth/login_screen.dart';
import '../../core/utils/session.dart';
import '../../core/utils/guest_mode.dart';
import '../../core/theme/app_colors.dart';

class HomeSplashScreen extends StatefulWidget {
  const HomeSplashScreen({super.key});

  @override
  State<HomeSplashScreen> createState() => _HomeSplashScreenState();
}

class _HomeSplashScreenState extends State<HomeSplashScreen> {
  int _currentSlide = 0;

  final List<String> imgList = [
    'assets/images/luti_gendang.jpeg',
    'assets/images/mie_tarempa.jpeg',
    'assets/images/mie_sagu.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.header, // #EAEDFF opacity 85%
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xD9EAEDFF), // #EAEDFF opacity 85%
                Color(0xFFF8F9FD),
                Colors.white,
              ],
              stops: [0.0, 0.25, 0.45],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 1. Header (Logo & Nama)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/logo.jpeg', height: 42),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'HotPay',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF1E1E2C),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF00C853),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'HOT FOOD VENDING MESIN',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black54,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const Spacer(flex: 2),

                            // 2. Carousel & Indikator Garis
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Stack(
                                      children: [
                                        CarouselSlider(
                                          options: CarouselOptions(
                                            height: size.height * 0.22,
                                            viewportFraction: 1.0,
                                            autoPlay: true,
                                            autoPlayAnimationDuration:
                                                const Duration(milliseconds: 800),
                                            onPageChanged: (index, reason) {
                                              if (mounted) {
                                                setState(() {
                                                  _currentSlide = index;
                                                });
                                              }
                                            },
                                          ),
                                          items: imgList
                                              .map(
                                                (item) => Image.asset(
                                                  item,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                ),
                                              )
                                              .toList(),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          left: 10,
                                          child: Row(
                                            children: [
                                              _buildBadge(
                                                Icons.local_fire_department,
                                                '85°C Freshly Cooked',
                                                Colors.orange,
                                              ),
                                              const SizedBox(width: 6),
                                              _buildBadge(
                                                Icons.health_and_safety,
                                                '100% Higienis',
                                                Colors.green,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: imgList.asMap().entries.map((entry) {
                                      bool isActive = _currentSlide == entry.key;
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        width: isActive ? 20.0 : 6.0,
                                        height: 4.0,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 2.5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: isActive
                                              ? const Color(0xFFFF6B00)
                                              : Colors.orange.withValues(alpha: 0.2),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),

                            const Spacer(flex: 3),

                            // 3. Label Tagline
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0E5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 14,
                                    color: Color(0xFFFF6B00),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'VENDING MESIN KULINER PANAS',
                                    style: TextStyle(
                                      color: Color(0xFFFF6B00),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 4. Judul & Deskripsi Utama
                            const Text(
                              'Makan Enak & Hangat,\nSiap dalam 3 Menit!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                                color: Color(0xFF1E1E2C),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Hidangan hangat cita rasa tradisional khas Kepulauan Riau, siap disajikan kapan saja lewat Vending Mesin terdekat Anda.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const Spacer(flex: 3),

                            // 5. Kartu Fitur (3 Kolom)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildFeatureCard(
                                  Icons.thermostat,
                                  '85°C Presisi',
                                  'Suhu Santap\nIdeal',
                                  Colors.redAccent,
                                ),
                                _buildFeatureCard(
                                  Icons.bolt,
                                  '180 Detik',
                                  'Tanpa Antre\nLama',
                                  Colors.orange,
                                ),
                                _buildFeatureCard(
                                  Icons.clean_hands,
                                  '100% Higienis',
                                  'Zero Contact\nTech',
                                  Colors.teal,
                                ),
                              ],
                            ),

                            const Spacer(flex: 4),

                            // 6. Tombol Aksi (Navigasi ke LoginScreen dengan transisi Fade)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                    ) => const LoginScreen(),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B00),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                                shadowColor: const Color(0xFFFF6B00).withValues(alpha: 0.3),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.restaurant_menu,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mulai Pesan Sekarang',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Masuk / Daftar Akun',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // 7. Tautan Bawah
                            TextButton.icon(
                              onPressed: () {
                                Session.loginAsGuest();
                                GuestMode.enter();
                                Navigator.pushReplacementNamed(context, '/main');
                              },
                              icon: const Icon(
                                Icons.manage_search,
                                color: Colors.black87,
                                size: 20,
                              ),
                              label: const Text(
                                'Jelajahi Menu sebagai Tamu',
                                style: TextStyle(
                                  color: Colors.black87,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 26),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1E2C),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
