import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

enum ButtonType { primary, secondary, outline, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final String? subtitle;
  final VoidCallback? onPressed;
  final ButtonType type;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isFullWidth;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    this.subtitle,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isFullWidth = true,
    this.isLoading = false,
    this.height = 54,
    this.borderRadius = 14,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide borderSide = BorderSide.none;
    List<BoxShadow> shadows = [];

    switch (type) {
      case ButtonType.primary:
        bg = backgroundColor ?? AppColors.primary;
        fg = textColor ?? Colors.white;
        shadows = AppColors.orangeShadow;
        break;
      case ButtonType.secondary:
        bg = backgroundColor ?? AppColors.surfaceSecondary;
        fg = textColor ?? AppColors.textPrimary;
        break;
      case ButtonType.outline:
        bg = backgroundColor ?? Colors.white;
        fg = textColor ?? AppColors.textPrimary;
        borderSide = const BorderSide(color: AppColors.border, width: 1.5);
        break;
      case ButtonType.danger:
        bg = backgroundColor ?? AppColors.dangerLight;
        fg = textColor ?? AppColors.danger;
        break;
    }

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon!,
          const SizedBox(width: 10),
        ],
        if (subtitle != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: fg.withValues(alpha: 0.85),
                ),
              ),
            ],
          )
        else
          Text(
            text,
            style: AppTextStyles.buttonMedium.copyWith(
              color: fg,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 10),
          trailingIcon!,
        ],
      ],
    );

    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderSide != BorderSide.none
            ? Border.fromBorderSide(borderSide)
            : null,
        boxShadow: onPressed != null && type == ButtonType.primary ? shadows : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: fg,
                      ),
                    )
                  : content,
            ),
          ),
        ),
      ),
    );
  }
}
