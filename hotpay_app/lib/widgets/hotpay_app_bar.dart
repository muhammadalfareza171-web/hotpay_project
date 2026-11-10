import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'hotpay_logo.dart';

class HotPayAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool showProfile;
  final VoidCallback? onProfileTap;
  final String? titleText;
  final String? subtitleText;

  const HotPayAppBar({
    super.key,
    this.showBackButton = true,
    this.onBack,
    this.showProfile = true,
    this.onProfileTap,
    this.titleText,
    this.subtitleText,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return SafeArea(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F7FB), // Warna seragam menyatu dengan seluruh halaman
        ),
        child: Row(
          children: [
            // Back Button
            if (showBackButton && canPop) ...[
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 24,
                  color: AppColors.textPrimary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onBack ?? () => Navigator.maybePop(context),
              ),
              const SizedBox(width: 12),
            ],

            // Logo or Custom Title
            Expanded(
              child: titleText != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleText!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitleText != null)
                          Text(
                            subtitleText!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    )
                  : const HotPayLogo(
                      iconSize: 24,
                      fontSize: 18,
                      showSubtitle: true,
                    ),
            ),

            // Profile Avatar
            if (showProfile)
              GestureDetector(
                onTap: onProfileTap ??
                    () {
                      Navigator.pushNamed(context, '/profile');
                    },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC27838).withValues(alpha: 0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
