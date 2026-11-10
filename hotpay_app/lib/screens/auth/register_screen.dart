import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/session.dart';
import '../../widgets/auth_widgets.dart';
import 'google_auth_dialog.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  /// true saat datang dari layar Masuk (pill tab meluncur)
  final bool animateTab;

  const RegisterScreen({super.key, this.animateTab = false});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

enum _Strength { none, weak, medium, strong }

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Logika
  // ---------------------------------------------------------------------------
  _Strength get _strength {
    final p = _passwordController.text;
    if (p.isEmpty) return _Strength.none;
    if (p.length < 8) return _Strength.weak;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(p);
    final hasDigit = RegExp(r'[0-9]').hasMatch(p);
    final hasOther = RegExp(r'[^A-Za-z0-9]').hasMatch(p);
    if (hasLetter && hasDigit && (hasOther || p.length >= 10)) {
      return _Strength.strong;
    }
    return _Strength.medium;
  }

  void _submit() {
    final name = _nameController.text.trim();
    final phone = normalizePhone(_phoneController.text);
    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    if (name.length < 3) {
      showAuthSnack(context, 'Nama lengkap minimal 3 karakter');
      return;
    }
    if (!isValidPhone(phone)) {
      showAuthSnack(context, 'Masukkan nomor WhatsApp / HP yang valid');
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      showAuthSnack(context, 'Format email tidak valid');
      return;
    }
    if (pass.length < 8) {
      showAuthSnack(context, 'Kata sandi minimal 8 karakter');
      return;
    }
    if (pass != _confirmPasswordController.text) {
      showAuthSnack(context, 'Konfirmasi kata sandi tidak sama');
      return;
    }

    // BACKEND: kirim data pendaftaran + minta server mengirim OTP ke WhatsApp.
    // Hanya alur DAFTAR yang melewati OTP. Nomor dikirim ke layar OTP.
    //
    // Pengguna daftar = pengguna akun (bukan tamu). Jika Anda ingin status
    // ini diset setelah OTP berhasil, pindahkan baris ini ke layar OTP.
    Session.loginAsUser();
    Navigator.pushNamed(context, '/otp', arguments: phone);
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthStyle.bg,
      body: Column(
        children: [
          const AuthHeader(),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Column(
                  children: [
                    const AuthHeading(
                      dark: 'Daftar Akun untuk',
                      accent: 'Akses Lengkap',
                      subtitle:
                          'Simpan riwayat transaksi lengkap, pantau\nstatus pesanan hangat, dan nikmati\nkemudahan pesan kembali kapan saja.',
                    ),
                    const SizedBox(height: 20),
                    _buildFormCard(),
                    const SizedBox(height: 26),
                    const Text(
                      'ATAU DAFTAR LEBIH CEPAT DENGAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AuthStyle.icon,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGoogleButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return AuthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTabToggle(
            loginSelected: false,
            animateIn: widget.animateTab,
            onLoginTap: () => Navigator.pushReplacement(
              context,
              AuthPageRoute(
                page: const LoginScreen(animateTab: true),
                name: '/login',
                fromRight: false,
              ),
            ),
            onRegisterTap: () {},
          ),
          const SizedBox(height: 20),

          const AuthLabel('Nama Lengkap'),
          const SizedBox(height: 6),
          AuthTextField(
            controller: _nameController,
            icon: Icons.badge_outlined,
            hint: 'Ahmad Pratama',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),

          const AuthLabel('Nomor WhatsApp / HP'),
          const SizedBox(height: 6),
          AuthPhoneField(
            controller: _phoneController,
            hint: '812-xxxx-xxxx',
          ),
          const SizedBox(height: 16),

          const AuthLabel('Email Aktif'),
          const SizedBox(height: 6),
          AuthTextField(
            controller: _emailController,
            icon: Icons.mail_outline_rounded,
            hint: 'nama@email.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AuthLabel('Kata Sandi'),
              _buildStrengthIndicator(),
            ],
          ),
          const SizedBox(height: 6),
          AuthTextField(
            controller: _passwordController,
            icon: Icons.lock_outline_rounded,
            hint: 'Minimal 8 karakter',
            obscureText: _obscurePassword,
            onChanged: (_) => setState(() {}),
            trailing: AuthEyeButton(
              obscured: _obscurePassword,
              onTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: 16),

          const AuthLabel('Konfirmasi Kata Sandi'),
          const SizedBox(height: 6),
          AuthTextField(
            controller: _confirmPasswordController,
            icon: Icons.lock_reset_rounded,
            hint: 'Ulangi kata sandi Anda',
            obscureText: _obscureConfirm,
            trailing: AuthEyeButton(
              obscured: _obscureConfirm,
              onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          const SizedBox(height: 16),

          _buildTermsRow(),
          const SizedBox(height: 18),

          AuthPrimaryButton(
            label: 'Daftar Akun Baru',
            onTap: _agreeTerms ? _submit : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthIndicator() {
    final s = _strength;
    if (s == _Strength.none) return const SizedBox(height: 14);

    late final String text;
    late final Color color;
    late final IconData icon;
    switch (s) {
      case _Strength.weak:
        text = 'Lemah';
        color = const Color(0xFFEF4444);
        icon = Icons.error_outline_rounded;
        break;
      case _Strength.medium:
        text = 'Sedang';
        color = const Color(0xFFF59E0B);
        icon = Icons.info_outline_rounded;
        break;
      default:
        text = 'Kuat';
        color = const Color(0xFF10B981);
        icon = Icons.check_circle_outline_rounded;
    }

    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: Checkbox(
            value: _agreeTerms,
            activeColor: AppColors.primary,
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            side: const BorderSide(color: Color(0xFFC9CCEF), width: 1.5),
            onChanged: (val) => setState(() => _agreeTerms = val ?? false),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 11.5,
                color: AuthStyle.muted,
                height: 1.4,
              ),
              children: [
                TextSpan(text: 'Saya menyetujui '),
                TextSpan(
                  text: 'Syarat & Ketentuan',
                  style: TextStyle(
                    color: AuthStyle.link,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' serta '),
                TextSpan(
                  text: 'Kebijakan Privasi',
                  style: TextStyle(
                    color: AuthStyle.link,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' HotPay.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => GoogleAuthDialog.show(context),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const SweepGradient(
                    colors: [
                      Color(0xFF4285F4),
                      Color(0xFF34A853),
                      Color(0xFFFBBC05),
                      Color(0xFFEA4335),
                      Color(0xFF4285F4),
                    ],
                    stops: [0.0, 0.3, 0.5, 0.75, 1.0],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: const Text(
                    'G',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Google',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2B2B3A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}