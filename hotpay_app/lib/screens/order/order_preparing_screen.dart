import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/active_order.dart';
import '../../core/utils/order_session.dart';
import '../../models/menu_item.dart';
import '../../widgets/hotpay_app_bar.dart';

class OrderPreparingScreen extends StatefulWidget {
  final MenuItem? item;

  const OrderPreparingScreen({super.key, this.item});

  @override
  State<OrderPreparingScreen> createState() => _OrderPreparingScreenState();
}

class _OrderPreparingScreenState extends State<OrderPreparingScreen>
    with TickerProviderStateMixin {
  static const _pageBg = Color(0xFFF6F5FC);
  static const _lavender = Color(0xFFE6E5F9);
  static const _peach = Color(0xFFFFE6D8);

  // Total durasi simulasi memasak (detik), dihitung sejak pembayaran berhasil
  static const int _totalSeconds = 15;

  late AnimationController _animController;
  late AnimationController _progressController;
  late AnimationController _stripeController;
  bool _navigated = false;

  ActiveOrderData? get _order => ActiveOrder.current.value;

  // Progress 0.0 - 1.0, bergerak halus mengikuti animasi
  double get _progress => _progressController.value;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Strip oranye di progress bar yang terus bergerak maju (efek loading)
    _stripeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _totalSeconds),
    );
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _onFinished();
    });

    // Dibuka langsung dengan item tapi belum tercatat sebagai pesanan aktif
    if (widget.item != null && ActiveOrder.current.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && ActiveOrder.current.value == null) {
          ActiveOrder.start(widget.item!);
        }
      });
    }

    ActiveOrder.current.addListener(_onOrderChanged);
    _startProgress();
  }

  @override
  void dispose() {
    ActiveOrder.current.removeListener(_onOrderChanged);
    _animController.dispose();
    _progressController.dispose();
    _stripeController.dispose();
    super.dispose();
  }

  void _onOrderChanged() {
    if (!mounted) return;
    setState(_startProgress);
  }

  /// Progress dihitung dari waktu mulai pesanan, jadi kalau pengguna pindah
  /// tab lalu kembali, progres tetap lanjut (tidak mulai dari 0 lagi).
  void _startProgress() {
    _navigated = false;
    final order = _order;
    if (order == null) {
      _progressController.stop();
      _progressController.value = 0;
      return;
    }
    final elapsedMs = DateTime.now().difference(order.startedAt).inMilliseconds;
    final fraction =
        (elapsedMs / (_totalSeconds * 1000)).clamp(0.0, 1.0).toDouble();
    _progressController.forward(from: fraction);
  }

  void _onFinished() {
    if (_navigated || _order == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _navigated) return;
      final route = ModalRoute.of(context);
      if (route != null && !route.isCurrent) return; // sedang tertutup halaman lain
      _openCompleted();
    });
  }

  void _openCompleted() {
    final order = _order;
    if (order == null || _navigated) return;
    _navigated = true;
    Navigator.pushReplacementNamed(
      context,
      '/order-completed',
      arguments: order.item,
    );
  }

  void _goToMain() {
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: const HotPayAppBar(
        showBackButton: false,
        showProfile: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: order == null
              ? _buildEmptyState()
              : Column(
                  children: [
                    _buildItemCard(order.item),
                    const SizedBox(height: 16),
                    _buildStatusCard(),
                    const SizedBox(height: 16),
                    _buildBackButton(),
                  ],
                ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tampilan saat belum ada pesanan aktif
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF1E8), Colors.white],
          stops: [0.0, 0.35],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _animController,
            builder: (context, _) {
              final scale = 1 + 0.05 * _animController.value;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEEE3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.ramen_dining_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _lavender,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_empty_rounded, size: 13, color: AppColors.primaryDark),
                SizedBox(width: 5),
                Text(
                  'MESIN SIAP DIGUNAKAN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum Ada Pesanan Aktif',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pesanan yang sedang dimasak akan muncul di sini lengkap dengan progres real-time. Yuk, pilih menu hangat favoritmu dulu!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: const [
              _InfoChip(icon: Icons.local_fire_department_outlined, label: 'Dimasak 85°C'),
              _InfoChip(icon: Icons.bolt_rounded, label: 'Siap ± 1 menit'),
              _InfoChip(icon: Icons.qr_code_2_rounded, label: 'Bayar QRIS'),
            ],
          ),
          const SizedBox(height: 24),
          _gradientButton(
            label: 'Pesan Sekarang',
            icon: Icons.restaurant_menu_rounded,
            onTap: _goToMain,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Kartu item: Mie Sagu 1x • Memasak
  // ---------------------------------------------------------------------------
  Widget _buildItemCard(MenuItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEE3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.ramen_dining_rounded,
              color: AppColors.primaryDark,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          // FittedBox: nama mengecil, tidak terpotong "Mie ..."
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.name,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _lavender,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${OrderSession.quantity}x',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: _peach,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 7, color: AppColors.primaryDark),
                          SizedBox(width: 4),
                          Text(
                            'Memasak',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Bay A-02 • Pedas Sedang • Telur',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Kartu besar: visual induksi + progress
  // ---------------------------------------------------------------------------
  Widget _buildStatusCard() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, _) => _statusCardContent(),
    );
  }

  Widget _statusCardContent() {
    final percent = (_progress * 100).floor();
    final remaining = (_totalSeconds * (1 - _progress)).ceil();
    final currentTemp = (25 + 60 * _progress).round();
    final finished = _progress >= 1.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF1E8), Colors.white],
          stops: [0.0, 0.22],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Visual induksi
          Container(
            width: double.infinity,
            height: 190,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF9E3D6), Color(0xFFE9E8F7), Color(0xFFF4D6C6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFE0CC), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ikon uap panas (berdenyut)
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, _) {
                    final o = 0.6 + _animController.value * 0.4;
                    return Opacity(
                      opacity: o,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.air_rounded, size: 20, color: AppColors.primary),
                          SizedBox(width: 4),
                          Icon(Icons.waves_rounded, size: 24, color: AppColors.primary),
                          SizedBox(width: 4),
                          Icon(Icons.air_rounded, size: 20, color: AppColors.primary),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),

                // Kartu slot + suhu
                Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sensors_rounded, size: 12, color: AppColors.primaryDark),
                          SizedBox(width: 4),
                          Text(
                            'SLOT 02',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 46,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _peach,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.kitchen_rounded,
                          size: 18,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$currentTemp°C / 85°C',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Garis gelombang panas (bergerak)
                CustomPaint(
                  size: const Size(130, 22),
                  painter: _WavePainter(_animController),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Badge smart induction
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0D0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department_outlined,
                    size: 13, color: AppColors.primaryDark),
                SizedBox(width: 5),
                Text(
                  'SMART INDUCTION ACTIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          const Text(
            'SEDANG DISIAPKAN',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            'Mesin sedang menyiapkan makanan Anda hingga mencapai suhu 85°C secara merata dan higienis.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),

          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Proses Persiapan',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  Container(color: _lavender),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progress,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primaryDark, AppColors.primary],
                            ),
                          ),
                        ),
                        CustomPaint(painter: _StripePainter(_stripeController)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Estimasi (atau tombol jika sudah selesai tapi belum berpindah halaman)
          if (finished)
            _gradientButton(
              label: 'Lihat Pesanan Selesai',
              icon: Icons.check_circle_rounded,
              onTap: _openCompleted,
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: _lavender,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, size: 16, color: AppColors.primaryDark),
                  const SizedBox(width: 6),
                  Text(
                    remaining > 30
                        ? 'Estimasi: ± ${(remaining / 60).ceil()} Menit lagi'
                        : 'Estimasi: ± $remaining Detik lagi',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tombol Kembali ke Menu Utama
  // ---------------------------------------------------------------------------
  Widget _buildBackButton() {
    return InkWell(
      onTap: _goToMain,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFFE0CC), width: 1.2),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_outlined, size: 16, color: AppColors.primaryDark),
            SizedBox(width: 8),
            Text(
              'Kembali ke Menu Utama',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tombol gradasi oranye yang dipakai di beberapa tempat
  Widget _gradientButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8A2B), Color(0xFFFF6A13)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6A13).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EFFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.primaryDark),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// Garis gelombang panas yang bergerak mengikuti animasi.
class _WavePainter extends CustomPainter {
  final Animation<double> animation;

  _WavePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final phase = animation.value * 2 * math.pi;
    for (double x = 0; x <= size.width; x += 2) {
      final y = size.height / 2 +
          math.sin((x / size.width) * 2 * math.pi * 1.5 + phase) * (size.height / 3);
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => false;
}

/// Strip diagonal terang yang bergerak ke kanan di dalam progress bar,
/// memberi efek "loading" yang terus maju.
class _StripePainter extends CustomPainter {
  final Animation<double> animation;

  _StripePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;

    const stripeWidth = 9.0;
    const period = stripeWidth * 2;
    final offset = animation.value * period;

    for (double x = -period * 2 + offset; x < size.width + period; x += period) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + stripeWidth, size.height)
        ..lineTo(x + stripeWidth + size.height, 0)
        ..lineTo(x + size.height, 0)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StripePainter oldDelegate) => false;
}