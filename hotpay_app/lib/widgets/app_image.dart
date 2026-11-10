import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AppImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? placeholderLabel;
  final IconData? fallbackIcon;
  final bool isDarkOverlay;
  final String? badgeText;

  const AppImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderLabel,
    this.fallbackIcon,
    this.isDarkOverlay = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallback();
      },
    );

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Stack(
        children: [
          imageWidget,
          if (isDarkOverlay)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.55),
                child: const Center(
                  child: Text(
                    'HABIS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          if (badgeText != null)
            Positioned(
              left: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.thermostat_rounded,
                      size: 11,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      badgeText!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallback() {
    // Generate an attractive placeholder based on food name
    final isNoodle = assetPath.contains('mie') ||
        (placeholderLabel != null && placeholderLabel!.toLowerCase().contains('mie'));
    final isBread = assetPath.contains('luti') ||
        (placeholderLabel != null && placeholderLabel!.toLowerCase().contains('luti'));
    final isQris = assetPath.contains('qris');
    final isOperator = assetPath.contains('operator');

    Gradient gradient;
    IconData icon;
    String label = placeholderLabel ?? 'HotPay Food';

    if (isNoodle) {
      gradient = const LinearGradient(
        colors: [Color(0xFFFF8A00), Color(0xFFE52E71)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      icon = Icons.ramen_dining_rounded;
    } else if (isBread) {
      gradient = const LinearGradient(
        colors: [Color(0xFFF6D365), Color(0xFFFDA085)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      icon = Icons.bakery_dining_rounded;
    } else if (isQris) {
      gradient = const LinearGradient(
        colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      icon = Icons.qr_code_2_rounded;
    } else if (isOperator) {
      gradient = const LinearGradient(
        colors: [Color(0xFF6EE7B7), Color(0xFF3B82F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      icon = Icons.support_agent_rounded;
    } else {
      gradient = const LinearGradient(
        colors: [Color(0xFFFF7A00), Color(0xFFFF0100)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      icon = fallbackIcon ?? Icons.restaurant_rounded;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(gradient: gradient),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              fallbackIcon ?? icon,
              color: isQris ? AppColors.textPrimary : Colors.white,
              size: (height != null && height! < 100) ? 28 : 42,
            ),
            if (height == null || height! >= 100) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isQris ? AppColors.textPrimary : Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
