import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/guest_mode.dart';
import '../../core/utils/session.dart';
import '../../core/utils/operator_session.dart';
import '../../widgets/auth_widgets.dart';
import 'forgot_password_dialog.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  /// true saat datang dari layar Daftar (pill tab meluncur)
  final bool animateTab;

  const LoginScreen({super.key, this.animateTab = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToRegister() {
    Navigator.pushReplacement(
      context,
      AuthPageRoute(
        page: const RegisterScreen(animateTab: true),
        name: '/register',
        fromRight: true,
      ),
    );
  }

  /// Cek apakah nomor sudah pernah daftar (disimpan di SharedPreferences saat register)
  Future<bool> _isPhoneRegistered(String normalizedPhone) async {
    final prefs = await SharedPreferences.getInstance();
    final registered = prefs.getStringList('registered_phones') ?? [];
    return registered.contains(normalizedPhone);
  }

  void _submit() async {
    final rawPhone = _phoneController.text.trim();
    final phone = normalizePhone(rawPhone);
    final password = _passwordController.text;

    if (!isValidPhone(phone)) {
      showAuthSnack(context, 'Masukkan nomor WhatsApp / HP yang valid');
      return;
    }
    if (password.isEmpty) {
      showAuthSnack(context, 'Kata sandi tidak boleh kosong');
      return;
    }

    // ΓöÇΓöÇ CEK OPERATOR ΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇ
    if (OperatorSession.validate(phone, password) ||
        OperatorSession.validate(rawPhone, password)) {
      OperatorSession.loginAsOperator();
      GuestMode.exit();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, '/operator-main', (route) => false);
      return;
    }

    // ΓöÇΓöÇ CEK CUSTOMER: harus sudah daftar ΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇΓöÇ
    final registered = await _isPhoneRegistered(phone);
    if (!mounted) return;

    if (!registered) {
      showAuthSnack(
        context,
        'Nomor belum terdaftar. Silakan daftar terlebih dahulu.',
      );
      return;
    }

    // Login customer berhasil
    Session.loginAsUser();
    GuestMode.exit();
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }

  // Masuk sebagai tamu ΓåÆ riwayat & pesanan akan terkunci.
  void _goAsGuest() {
    Session.loginAsGuest();
    GuestMode.enter();
    Navigator.pushReplacementNamed(context, '/main');
  }

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
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  children: [
                    const AuthHeading(
                      dark: 'Sajian\nHangat,',
                      accent: 'Siap 3 Menit!',
                      subtitle:
                          'Nikmati hidangan langsung\ndari vending machine pintar terdekat.',
                    ),
                    const SizedBox(height: 20),
                    AuthCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AuthTabToggle(
                            loginSelected: true,
                            animateIn: widget.animateTab,
                            onLoginTap: () {},
                            onRegisterTap: _goToRegister,
                          ),
                          const SizedBox(height: 20),
                          _buildLoginForm(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildGuestButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLabel('Nomor WhatsApp / HP'),
        const SizedBox(height: 6),
        AuthPhoneField(
          controller: _phoneController,
          hint: '812-3456-7890',
        ),
        const SizedBox(height: 16),
        const AuthLabel('Kata Sandi'),
        const SizedBox(height: 6),
        AuthTextField(
          controller: _passwordController,
          icon: Icons.lock_outline_rounded,
          hint: 'Ketik kata sandi Anda',
          obscureText: _obscurePassword,
          trailing: AuthEyeButton(
            obscured: _obscurePassword,
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => ForgotPasswordDialog.show(context),
            child: const Text(
              'Lupa Kata Sandi?',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: AuthStyle.link,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        AuthPrimaryButton(label: 'Masuk', onTap: _submit),
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Belum punya akun? ',
                style: TextStyle(fontSize: 12, color: AuthStyle.muted),
              ),
              GestureDetector(
                onTap: _goToRegister,
                child: const Text(
                  'Daftar Sekarang →',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuestButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFEDEEFA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: _goAsGuest,
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_bag_outlined,
                    size: 16, color: AppColors.textPrimary),
                SizedBox(width: 8),
                Text(
                  'Pesan Cepat sebagai Tamu',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
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
