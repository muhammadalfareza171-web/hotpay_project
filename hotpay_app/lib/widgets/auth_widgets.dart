import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import 'hotpay_logo.dart';

// =============================================================================
// Gaya & komponen bersama untuk Login, Register, dan OTP
// Simpan di: lib/widgets/auth_widgets.dart
// =============================================================================

class AuthStyle {
  static const Color bg = Color(0xFFF6F6FD);
  static const Color header = Color(0xFFE8EDFB);
  static const Color field = Color(0xFFF3F3FE);
  static const Color tabBg = Color(0xFFE8ECFC);
  static const Color tabBorder = Color(0xFFDDE2F8);
  static const Color pill = Color(0xFFEEF0FA);
  static const Color icon = Color(0xFF5D4E46);
  static const Color link = Color(0xFFC2410C);
  static const Color muted = Color(0xFF4B5563);
  static const Color hint = Color(0xFFA8A29E);
  static const Color whatsapp = Color(0xFF2F8F6B);

  static const double fieldHeight = 50;
  static const double fieldRadius = 16;
  static const double cardRadius = 22;
  static const double cardPadding = 20;
  static const double buttonHeight = 52;

  static const TextStyle inputText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: hint,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: hintText,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      filled: false,
      isDense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}

// -----------------------------------------------------------------------------
// Helper
// -----------------------------------------------------------------------------

/// Ubah input nomor HP ke bentuk standar tanpa 0 / 62 di depan.
/// "0812-3456-7890" / "+62 812 3456 7890" -> "81234567890"
String normalizePhone(String raw) {
  var digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.startsWith('62')) {
    digits = digits.substring(2);
  } else if (digits.startsWith('0')) {
    digits = digits.substring(1);
  }
  return digits;
}

/// Nomor seluler Indonesia: diawali 8, panjang 9–12 digit (setelah +62).
bool isValidPhone(String normalized) {
  return normalized.startsWith('8') &&
      normalized.length >= 9 &&
      normalized.length <= 12;
}

void showAuthSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

// -----------------------------------------------------------------------------
// Header lavender + tombol kembali + logo
// -----------------------------------------------------------------------------
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AuthStyle.header,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 20, 10),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 22,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
              const HotPayLogo(
                iconSize: 26,
                fontSize: 19,
                showSubtitle: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Judul dua warna dengan glow oranye + subjudul
// -----------------------------------------------------------------------------
class AuthHeading extends StatelessWidget {
  final String dark;
  final String accent;
  final String subtitle;

  const AuthHeading({
    super.key,
    required this.dark,
    required this.accent,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -70,
          right: -70,
          top: -30,
          bottom: -10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 0.75,
                colors: [
                  AppColors.primary.withValues(alpha: 0.16),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dark,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              accent,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Kartu putih
// -----------------------------------------------------------------------------
class AuthCard extends StatelessWidget {
  final Widget child;
  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AuthStyle.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AuthStyle.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

// -----------------------------------------------------------------------------
// Transisi halus Masuk <-> Daftar (fade + geser tipis)
// -----------------------------------------------------------------------------
class AuthPageRoute<T> extends PageRouteBuilder<T> {
  AuthPageRoute({
    required Widget page,
    required String name,
    bool fromRight = true,
  }) : super(
          settings: RouteSettings(name: name),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(fromRight ? 0.06 : -0.06, 0),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
}

// -----------------------------------------------------------------------------
// Tab Masuk / Daftar (pill meluncur halus)
// -----------------------------------------------------------------------------
class AuthTabToggle extends StatefulWidget {
  final bool loginSelected;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  /// true = pill mulai dari tab sebelumnya lalu meluncur ke tab aktif
  /// (dipakai saat berpindah dari layar Masuk <-> Daftar).
  final bool animateIn;

  const AuthTabToggle({
    super.key,
    required this.loginSelected,
    required this.onLoginTap,
    required this.onRegisterTap,
    this.animateIn = false,
  });

  @override
  State<AuthTabToggle> createState() => _AuthTabToggleState();
}

class _AuthTabToggleState extends State<AuthTabToggle> {
  static const Duration _dur = Duration(milliseconds: 380);

  late bool _pillOnLogin;

  @override
  void initState() {
    super.initState();
    _pillOnLogin = widget.animateIn ? !widget.loginSelected : widget.loginSelected;
    if (widget.animateIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _pillOnLogin = widget.loginSelected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AuthStyle.tabBg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AuthStyle.tabBorder, width: 1),
      ),
      child: SizedBox(
        height: 36,
        child: Stack(
          children: [
            AnimatedAlign(
              duration: _dur,
              curve: Curves.easeOutCubic,
              alignment:
                  _pillOnLogin ? Alignment.centerLeft : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border:
                        Border.all(color: const Color(0xFFE3E7FA), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B93E0).withValues(alpha: 0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                _tab('Masuk', _pillOnLogin, widget.onLoginTap),
                _tab('Daftar', !_pillOnLogin, widget.onRegisterTap),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: _dur,
            curve: Curves.easeOutCubic,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: selected ? AppColors.primary : const Color(0xFF4B4038),
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Label & kolom input
// -----------------------------------------------------------------------------
class AuthLabel extends StatelessWidget {
  final String text;
  const AuthLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: AuthStyle.label);
}

class AuthFieldShell extends StatelessWidget {
  final Widget leading;
  final Widget child;
  final Widget? trailing;
  final double gap;

  const AuthFieldShell({
    super.key,
    required this.leading,
    required this.child,
    this.trailing,
    this.gap = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AuthStyle.fieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AuthStyle.field,
        borderRadius: BorderRadius.circular(AuthStyle.fieldRadius),
      ),
      child: Row(
        children: [
          leading,
          SizedBox(width: gap),
          Expanded(child: child),
          ?trailing,
        ],
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool obscureText;
  final Widget? trailing;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.hint,
    this.obscureText = false,
    this.trailing,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AuthFieldShell(
      leading: Icon(icon, size: 19, color: AuthStyle.icon),
      trailing: trailing,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: AuthStyle.inputText,
        decoration: AuthStyle.inputDecoration(hint),
      ),
    );
  }
}

class AuthPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const AuthPhoneField({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return AuthFieldShell(
      gap: 6,
      leading: const Icon(
        Icons.message_rounded,
        size: 18,
        color: AuthStyle.whatsapp,
      ),
      child: Row(
        children: [
          const Text(
            '+62',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\- ]')),
                LengthLimitingTextInputFormatter(16),
              ],
              style: AuthStyle.inputText,
              decoration: AuthStyle.inputDecoration(hint),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthEyeButton extends StatelessWidget {
  final bool obscured;
  final VoidCallback onTap;

  const AuthEyeButton({super.key, required this.obscured, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
          color: AuthStyle.icon,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Tombol utama (gradien oranye)
// -----------------------------------------------------------------------------
class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double height;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = AuthStyle.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final radius = height / 2;
    return Opacity(
      opacity: onTap == null ? 0.5 : 1.0,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF7A00), Color(0xFFFF5C00)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}