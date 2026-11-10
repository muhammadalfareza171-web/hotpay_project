import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Widget? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const StatusBadge({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor = AppColors.primaryLight,
    this.textColor = AppColors.primary,
    this.borderColor,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.borderRadius = 20,
  });

  // Factory constructor for success (green) badge
  factory StatusBadge.success({
    required String text,
    Widget? icon,
    double fontSize = 11,
  }) {
    return StatusBadge(
      text: text,
      icon: icon,
      backgroundColor: AppColors.successLight,
      textColor: AppColors.success,
      borderColor: AppColors.successBorder,
      fontSize: fontSize,
    );
  }

  // Factory constructor for orange badge
  factory StatusBadge.orange({
    required String text,
    Widget? icon,
    double fontSize = 11,
  }) {
    return StatusBadge(
      text: text,
      icon: icon,
      backgroundColor: AppColors.primaryLight,
      textColor: AppColors.primary,
      borderColor: const Color(0xFFFFD8BF),
      fontSize: fontSize,
    );
  }

  // Factory constructor for portion count (peach)
  factory StatusBadge.portion({
    required int count,
  }) {
    return StatusBadge(
      text: 'Tersedia $count porsi',
      backgroundColor: const Color(0xFFFFF2E8),
      textColor: const Color(0xFFD4380D),
      fontSize: 10.5,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    );
  }

  // Factory constructor for rating
  factory StatusBadge.rating({
    required double rating,
  }) {
    return StatusBadge(
      text: '★ $rating',
      backgroundColor: Colors.transparent,
      textColor: const Color(0xFFD97706),
      fontSize: 12,
      padding: EdgeInsets.zero,
    );
  }

  // Factory constructor for temperature badge
  factory StatusBadge.temp({
    required String temp,
  }) {
    return StatusBadge(
      text: '🌡️ $temp',
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      textColor: AppColors.textPrimary,
      fontSize: 10.5,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      borderRadius: 6,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
