import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/auth_widgets.dart';

/// Bottom sheet pemulihan kata sandi (4 langkah):
/// 1. Nomor WhatsApp  2. Verifikasi OTP  3. Sandi baru  4. Berhasil
/// Buka dengan: ForgotPasswordDialog.show(context);
class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ForgotPasswordDialog(),
    );
  }

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  static const int _otpSeconds = 60;
  static const Color _green = Color(0xFF047857);
  static const Color _greenBg = Color(0xFFDCFCE7);
  static const Color _red = Color(0xFFDC2626);

  int _step = 1; // 1: nomor, 2: otp, 3: sandi baru, 4: berhasil

  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _otpFocus = FocusNode();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  Timer? _timer;
  int _secondsLeft = _otpSeconds;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    _otpFocus.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Logika
  // ---------------------------------------------------------------------------
  String get _phoneNormalized => normalizePhone(_phoneController.text);

  String get _phoneDisplay {
    final n = _phoneNormalized;
    if (n.length >= 8) {
      return '${n.substring(0, 3)}-${n.substring(3, 7)}-${n.substring(7)}';
    }
    return n;
  }

  String get _timerText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _otpSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _sendOtp() {
    if (!isValidPhone(_phoneNormalized)) {
      showAuthSnack(context, 'Masukkan nomor WhatsApp yang valid');
      return;
    }
    // BACKEND: minta server mengirim OTP pemulihan ke WhatsApp.
    _otpController.clear();
    setState(() => _step = 2);
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _otpFocus.requestFocus();
    });
  }

  // Fokuskan input OTP dan paksa keyboard muncul, juga saat fokus masih
  // tersisa setelah keyboard ditutup dengan tombol back.
  void _focusOtp() {
    if (!_otpFocus.hasFocus) _otpFocus.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  void _resendOtp() {
    // BACKEND: panggil API kirim ulang OTP via WhatsApp (belum diimplementasi).
    _otpController.clear();
    _startTimer();
    _focusOtp();
    showAuthSnack(context, 'Kode baru telah dikirim');
  }

  void _verifyOtp() {
    if (_otpController.text.length != 4) {
      showAuthSnack(context, 'Harap masukkan 4 digit kode OTP');
      return;
    }
    if (_secondsLeft == 0) {
      showAuthSnack(context, 'Kode sudah kedaluwarsa, kirim ulang kode');
      return;
    }
    // BACKEND: verifikasi OTP ke server.
    _timer?.cancel();
    FocusScope.of(context).unfocus();
    setState(() => _step = 3);
  }

  // Syarat sandi
  bool get _hasLength => _passwordController.text.length >= 8;
  bool get _hasCase =>
      RegExp(r'[A-Z]').hasMatch(_passwordController.text) &&
      RegExp(r'[a-z]').hasMatch(_passwordController.text);
  bool get _hasDigit => RegExp(r'[0-9]').hasMatch(_passwordController.text);
  bool get _hasSymbol =>
      RegExp(r'[^A-Za-z0-9]').hasMatch(_passwordController.text);

  void _savePassword() {
    if (!(_hasLength && _hasCase && _hasDigit)) {
      showAuthSnack(context, 'Kata sandi belum memenuhi syarat');
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      showAuthSnack(context, 'Konfirmasi kata sandi tidak sama');
      return;
    }
    // BACKEND: kirim sandi baru ke server.
    setState(() => _step = 4);
  }

  // ---------------------------------------------------------------------------
  // UI utama
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    // Saat keyboard terbuka ikuti tinggi keyboard; saat tertutup beri jarak
    // dari tombol navigasi HP (gesture bar / tombol keluar) + ruang ekstra.
    final bottomSpace = media.viewInsets.bottom > 0
        ? media.viewInsets.bottom + 16
        : media.viewPadding.bottom + 36;
    return Container(
      constraints: BoxConstraints(maxHeight: media.size.height * 0.94),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(
          top: 12,
          left: 20,
          right: 20,
          bottom: bottomSpace,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_step == 1) _buildStep1(),
            if (_step == 2) _buildStep2(),
            if (_step == 3) _buildStep3(),
            if (_step == 4) _buildStep4(),
          ],
        ),
      ),
    );
  }

  // Baris atas: badge + tombol tutup
  Widget _topRow(Widget badge, {bool center = false}) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: center ? Alignment.center : Alignment.centerLeft,
            child: badge,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AuthStyle.tabBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close_rounded,
                size: 16, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _badge(String text,
      {required Color bg,
      required Color fg,
      IconData? icon,
      Color? border}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: border != null ? Border.all(color: border, width: 1) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: fg,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _title(String text, {TextAlign align = TextAlign.start}) => Text(
        text,
        textAlign: align,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
      );

  Widget _desc(String text, {TextAlign align = TextAlign.start}) => Text(
        text,
        textAlign: align,
        style: const TextStyle(
          fontSize: 12.5,
          color: AppColors.textLight,
          height: 1.45,
        ),
      );

  // ---------------------------------------------------------------------------
  // LANGKAH 1: nomor WhatsApp
  // ---------------------------------------------------------------------------
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _topRow(_badge(
          'PEMULIHAN AKUN CEPAT',
          bg: const Color(0xFFFFF2E8),
          fg: AppColors.primary,
          icon: Icons.shield_outlined,
          border: const Color(0xFFFFD8BF),
        )),
        const SizedBox(height: 12),
        _title('Lupa Kata Sandi Anda?'),
        const SizedBox(height: 6),
        _desc(
          'Masukkan nomor WhatsApp yang terdaftar untuk menerima 4 digit kode OTP verifikasi pemulihan sandi',
        ),
        const SizedBox(height: 18),
        const AuthLabel('Nomor WhatsApp Terdaftar'),
        const SizedBox(height: 6),
        AuthFieldShell(
          gap: 8,
          leading: _flag(),
          trailing: _phoneController.text.isEmpty
              ? null
              : GestureDetector(
                  onTap: _phoneController.clear,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Color(0xFFDDE0F2),
                      child: Icon(Icons.close_rounded,
                          size: 12, color: AppColors.textPrimary),
                    ),
                  ),
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
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\- ]')),
                    LengthLimitingTextInputFormatter(16),
                  ],
                  style: AuthStyle.inputText,
                  decoration: AuthStyle.inputDecoration('812-xxxx-xxxx'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFF9A3412),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.bolt_rounded, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Kode OTP 4 digit akan dikirimkan otomatis',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9A3412),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        AuthPrimaryButton(label: 'Kirim Kode OTP Pemulihan', onTap: _sendOtp),
        const SizedBox(height: 14),
        const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_rounded, size: 12, color: _green),
              SizedBox(width: 4),
              Text(
                'Dilindungi enkripsi data 256-bit HotPay ID',
                style: TextStyle(fontSize: 10.5, color: AuthStyle.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 12, color: AuthStyle.muted),
                children: [
                  TextSpan(text: 'Ingat kata sandi? '),
                  TextSpan(
                    text: 'Masuk Sekarang',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _flag() {
    return ClipOval(
      child: SizedBox(
        width: 18,
        height: 18,
        child: Column(
          children: [
            Expanded(child: Container(color: const Color(0xFFE11D2E))),
            Expanded(child: Container(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LANGKAH 2: verifikasi OTP
  // ---------------------------------------------------------------------------
  Widget _buildStep2() {
    final code = _otpController.text;
    final active = code.length.clamp(0, 3);
    final expired = _secondsLeft == 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _topRow(_badge(
          'KODE TERKIRIM • ENKRIPSI 256-BIT',
          bg: _greenBg,
          fg: _green,
          icon: Icons.shield_outlined,
        )),
        const SizedBox(height: 12),
        _title('Verifikasi Identitas Anda'),
        const SizedBox(height: 6),
        _desc(
          'Masukkan 4 digit kode keamanan yang telah dikirimkan ke WhatsApp resmi HotPay ke nomor:',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AuthStyle.field,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _greenBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chat_bubble_outline_rounded,
                    size: 14, color: Color(0xFF10B981)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WhatsApp Terdaftar',
                      style: TextStyle(fontSize: 10, color: AuthStyle.muted),
                    ),
                    Text(
                      '+62 $_phoneDisplay',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _timer?.cancel();
                  setState(() => _step = 1);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined,
                          size: 13, color: AuthStyle.link),
                      SizedBox(width: 4),
                      Text(
                        'Ubah',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: AuthStyle.link,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Kotak OTP + input tersembunyi
        Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: _focusOtp,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: List.generate(4, (i) {
                  final hasValue = i < code.length;
                  final isCurrent = i == active && code.length < 4;
                  return Expanded(
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? Colors.white
                            : AuthStyle.field,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 1.6,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 28,
                            child: Center(
                              child: hasValue
                                  ? Text(
                                      code[i],
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    )
                                  : (isCurrent
                                      ? Container(
                                          width: 2.5,
                                          height: 26,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        )
                                      : const SizedBox()),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 14,
                            height: 2.5,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(
                                  alpha: hasValue || isCurrent ? 0.9 : 0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              width: 1,
              height: 1,
              child: TextField(
                controller: _otpController,
                focusNode: _otpFocus,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                showCursor: false,
                enableInteractiveSelection: false,
                style: const TextStyle(color: Colors.transparent, fontSize: 1),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.hourglass_bottom_rounded,
                    size: 13, color: _red),
                const SizedBox(width: 5),
                Text(
                  expired
                      ? 'Kode kedaluwarsa'
                      : 'Masa Berlaku Kode: $_timerText detik',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _red,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: AuthStyle.field,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Belum menerima kode? ',
                style: TextStyle(fontSize: 11.5, color: AuthStyle.muted),
              ),
              GestureDetector(
                onTap: _resendOtp,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Kirim Ulang via WhatsApp',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: AuthStyle.link,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.refresh_rounded,
                      size: 14,
                      color: AuthStyle.link,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.verified_user_outlined,
                  size: 16, color: Color(0xFF9A3412)),
              SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 10.5,
                      color: AuthStyle.muted,
                      height: 1.35,
                    ),
                    children: [
                      TextSpan(
                        text: 'Tips Keamanan: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Jangan bagikan kode OTP ini kepada siapa pun termasuk staf operasional atau teknisi Vending Mesin HotPay.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        AuthPrimaryButton(label: 'Verifikasi & Lanjutkan', onTap: _verifyOtp),
        const SizedBox(height: 6),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batalkan Pemulihan',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AuthStyle.muted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // LANGKAH 3: sandi baru
  // ---------------------------------------------------------------------------
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _topRow(_badge(
          'LANGKAH 3 DARI 3 • ATUR SANDI BARU',
          bg: const Color(0xFFFFF2E8),
          fg: AppColors.primary,
          icon: Icons.lock_outline_rounded,
          border: const Color(0xFFFFD8BF),
        )),
        const SizedBox(height: 12),
        _title('Buat Kata Sandi Baru'),
        const SizedBox(height: 6),
        _desc(
          'Pastikan kata sandi baru Anda kuat dan aman untuk melindungi akun Anda',
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AuthLabel('Kata Sandi Baru'),
            Text(
              'Sangat Disarankan',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: _green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        AuthTextField(
          controller: _passwordController,
          icon: Icons.lock_rounded,
          hint: 'Kata Sandi Baru',
          obscureText: _obscureNew,
          onChanged: (_) => setState(() {}),
          trailing: AuthEyeButton(
            obscured: _obscureNew,
            onTap: () => setState(() => _obscureNew = !_obscureNew),
          ),
        ),
        const SizedBox(height: 10),
        _checkItem('Minimal 8 karakter', _hasLength),
        _checkItem('Mengandung huruf besar & kecil', _hasCase),
        _checkItem('Mengandung minimal 1 angka', _hasDigit),
        _checkItem('Simbol khusus (@#\$)', _hasSymbol, optional: true),
        const SizedBox(height: 14),
        const AuthLabel('Konfirmasi Kata Sandi'),
        const SizedBox(height: 6),
        AuthTextField(
          controller: _confirmController,
          icon: Icons.lock_rounded,
          hint: 'Konfirmasi Kata Sandi',
          obscureText: _obscureConfirm,
          trailing: AuthEyeButton(
            obscured: _obscureConfirm,
            onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),
        const SizedBox(height: 28),
        AuthPrimaryButton(
          label: 'Simpan Sandi Baru & Masuk',
          onTap: _savePassword,
        ),
        const SizedBox(height: 6),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AuthStyle.muted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _checkItem(String text, bool ok, {bool optional = false}) {
    final color = ok
        ? _green
        : (optional ? const Color(0xFF8B5CF6) : const Color(0xFF9CA3AF));
    final suffix = ok ? ' (Terpenuhi)' : (optional ? ' (Opsional)' : '');
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            '$text$suffix',
            style: TextStyle(
              fontSize: 11,
              color: ok ? _green : AuthStyle.muted,
              fontWeight: ok ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LANGKAH 4: berhasil
  // ---------------------------------------------------------------------------
  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _topRow(
          _badge(
            'STATUS: AKUN TELAH DIPULIHKAN',
            bg: const Color(0xFF86EFAC),
            fg: const Color(0xFF064E3B),
            icon: Icons.check_circle_rounded,
          ),
          center: true,
        ),
        const SizedBox(height: 22),
        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: Color(0xFFE6FBEF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 74,
              height: 74,
              decoration: const BoxDecoration(
                color: Color(0xFFBBF7D0),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Color(0xFF059669),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_user_rounded,
                      color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        _title('Kata Sandi Berhasil Diperbarui!', align: TextAlign.center),
        const SizedBox(height: 8),
        _desc(
          'Kata sandi akun HotPay Anda telah berhasil diubah. Sekarang Anda dapat masuk kembali dan menikmati sajian makanan hangat favorit di vending mesin',
          align: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AuthPrimaryButton(
          label: 'Masuk',
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}