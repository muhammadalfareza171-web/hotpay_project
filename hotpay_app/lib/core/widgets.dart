import 'dart:async';
import 'package:flutter/material.dart';
import 'theme.dart';

TextStyle ts(double size, {FontWeight w = FontWeight.w500, Color c = AppColors.text, double? h}) =>
    TextStyle(fontSize: size, fontWeight: w, color: c, height: h);

/// Logo + nama aplikasi di bagian atas halaman.
class BrandHeader extends StatelessWidget {
  final bool showBack;
  final Widget? trailing;
  final String subtitle;
  const BrandHeader({super.key, this.showBack = false, this.trailing, this.subtitle = 'HOT FOOD VENDING MESIN'});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
        child: Row(children: [
          if (showBack)
            IconButton(onPressed: () => Navigator.maybePop(context), icon: const Icon(Icons.arrow_back, size: 20))
          else
            const SizedBox(width: 8),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.local_fire_department, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('HotPay', style: ts(14, w: FontWeight.w800)),
            Text(subtitle, style: ts(8, w: FontWeight.w700, c: AppColors.muted)),
          ]),
          const Spacer(),
          if (trailing != null) trailing!,
        ]),
      );
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const PrimaryButton({super.key, required this.label, this.onPressed, this.icon = Icons.arrow_forward});

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: onPressed == null ? 0.5 : 1,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.orange, AppColors.orangeDark]),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: Color(0x40FF6A13), blurRadius: 12, offset: Offset(0, 5))],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onPressed,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                alignment: Alignment.center,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Flexible(child: Text(label, textAlign: TextAlign.center, style: ts(14, w: FontWeight.w800, c: Colors.white))),
                  if (icon != null) ...[const SizedBox(width: 8), Icon(icon, color: Colors.white, size: 16)],
                ]),
              ),
            ),
          ),
        ),
      );
}

class SoftButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  const SoftButton({super.key, required this.label, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: AppColors.field,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: onPressed,
          icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 16, color: AppColors.muted),
          label: Text(label, style: ts(13, w: FontWeight.w700, c: AppColors.muted)),
        ),
      );
}

class AuthTabs extends StatelessWidget {
  final bool loginSelected;
  final VoidCallback onLogin, onRegister;
  const AuthTabs({super.key, required this.loginSelected, required this.onLogin, required this.onRegister});

  Widget _tab(String t, bool sel, VoidCallback onTap) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: sel ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10)),
            child: Text(t, style: ts(13, w: FontWeight.w800, c: sel ? AppColors.orange : AppColors.muted)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [_tab('Masuk', loginSelected, onLogin), _tab('Daftar', !loginSelected, onRegister)]),
      );
}

class AppField extends StatefulWidget {
  final String label, hint;
  final IconData icon;
  final bool password;
  final String? prefixText;
  final TextEditingController? controller;
  final TextInputType? keyboard;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const AppField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.password = false,
    this.prefixText,
    this.controller,
    this.keyboard,
    this.onChanged,
    this.validator,
  });

  @override
  State<AppField> createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  bool hide = true;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.label, style: ts(11, w: FontWeight.w700, c: AppColors.muted)),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboard,
          obscureText: widget.password && hide,
          onChanged: widget.onChanged,
          validator: widget.validator,
          style: ts(13),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: ts(13, c: AppColors.muted),
            filled: true,
            fillColor: AppColors.field,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            prefixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(width: 12),
              Icon(widget.icon, size: 18, color: AppColors.muted),
              if (widget.prefixText != null) ...[
                const SizedBox(width: 6),
                Text(widget.prefixText!, style: ts(13, w: FontWeight.w700)),
              ],
              const SizedBox(width: 8),
            ]),
            suffixIcon: widget.password
                ? IconButton(
                    onPressed: () => setState(() => hide = !hide),
                    icon: Icon(hide ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: AppColors.muted))
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.red)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.orange)),
          ),
        ),
      ]);
}

/// 4 kotak OTP + hitung mundur + keypad angka.
class OtpInput extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const OtpInput({super.key, required this.onChanged});

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  String code = '';
  int seconds = 44;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) setState(() => seconds--);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _set(String v) {
    setState(() => code = v);
    widget.onChanged(code);
  }

  Widget _key(Widget child, VoidCallback? onTap) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: onTap == null ? Colors.transparent : Colors.white, borderRadius: BorderRadius.circular(12)),
              child: child,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final rows = [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9']];
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var i = 0; i < 4; i++)
          Container(
            width: 56,
            height: 64,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: i < code.length ? AppColors.orangeSoft : AppColors.field,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: i == code.length ? AppColors.orange : Colors.transparent, width: 1.5),
            ),
            child: Text(i < code.length ? code[i] : '', style: ts(26, w: FontWeight.w800)),
          ),
      ]),
      const SizedBox(height: 12),
      seconds > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppColors.redSoft, borderRadius: BorderRadius.circular(8)),
              child: Text('Masa berlaku kode: 00:${seconds.toString().padLeft(2, '0')}', style: ts(10, w: FontWeight.w700, c: AppColors.red)),
            )
          : TextButton(
              onPressed: () => setState(() {
                    seconds = 44;
                    code = '';
                    widget.onChanged('');
                  }),
              child: Text('Kirim ulang kode', style: ts(12, w: FontWeight.w800, c: AppColors.orange))),
      const SizedBox(height: 12),
      for (final r in rows)
        Row(children: [for (final d in r) _key(Text(d, style: ts(18, w: FontWeight.w700)), code.length < 4 ? () => _set(code + d) : null)]),
      Row(children: [
        _key(const SizedBox.shrink(), null),
        _key(Text('0', style: ts(18, w: FontWeight.w700)), code.length < 4 ? () => _set('${code}0') : null),
        _key(const Icon(Icons.backspace_outlined, size: 20), code.isNotEmpty ? () => _set(code.substring(0, code.length - 1)) : null),
      ]),
    ]);
  }
}

/// Gambar makanan; jika asset belum ada, tampil placeholder.
class FoodImage extends StatelessWidget {
  final String path;
  final double? width, height;
  final double radius;
  const FoodImage(this.path, {super.key, this.width, this.height, this.radius = 14});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(path, width: width, height: height, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
                  width: width,
                  height: height,
                  color: AppColors.orangeSoft,
                  child: const Icon(Icons.ramen_dining, color: AppColors.orange, size: 32),
                )),
      );
}

Future<T?> showAppSheet<T>(BuildContext context, Widget child, {bool dismissible = true}) => showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: dismissible,
      enableDrag: dismissible,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 16),
              child,
            ]),
          ),
        ),
      ),
    );

Widget pill(String t, Color bg, Color fg, {double size = 9}) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(t, style: ts(size, w: FontWeight.w800, c: fg)),
    );

/// Kartu putih standar.
class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  const Panel({super.key, required this.child, this.padding = const EdgeInsets.all(14), this.color = Colors.white});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: child,
      );
}

class AvatarButton extends StatelessWidget {
  final VoidCallback onTap;
  const AvatarButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: const CircleAvatar(radius: 14, backgroundColor: AppColors.brown, child: Icon(Icons.person, size: 16, color: Colors.white)),
      );
}

void popToHome(BuildContext context) => Navigator.popUntil(context, (r) => r.settings.name == '/home' || r.isFirst);

void comingSoon(BuildContext context, [String msg = 'Fitur ini segera hadir']) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
