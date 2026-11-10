import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/auth_widgets.dart';

/// Layar OTP hanya dipakai pada alur DAFTAR.
/// Buka dengan: Navigator.pushNamed(context, '/otp', arguments: nomorHp);
/// (nomorHp tanpa 0 / +62 di depan, mis. "81234567890")
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  static const int _resendSeconds = 60;

  final List<String> _otp = ['', '', '', ''];
  int _activeDigit = 0;

  late final AnimationController _cursorController;
  final FocusNode _keyboardFocusNode = FocusNode();

  Timer? _timer;
  int _secondsLeft = _resendSeconds;

  String _phone = '';
  bool _argsRead = false;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..repeat(reverse: true);
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsRead) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) _phone = args;
      _argsRead = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Logika
  // ---------------------------------------------------------------------------
  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
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

  void _resend() {
    // BACKEND: minta server mengirim ulang OTP ke WhatsApp.
    setState(() {
      for (var i = 0; i < _otp.length; i++) {
        _otp[i] = '';
      }
      _activeDigit = 0;
    });
    _startTimer();
    showAuthSnack(context, 'Kode baru telah dikirim');
  }

  void _onKeyPress(String val) {
    setState(() {
      _otp[_activeDigit] = val;
      if (_activeDigit < 3) _activeDigit++;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_otp[_activeDigit].isNotEmpty) {
        _otp[_activeDigit] = '';
      } else if (_activeDigit > 0) {
        _activeDigit--;
        _otp[_activeDigit] = '';
      }
    });
  }

  void _onSelectBox(int index) => setState(() => _activeDigit = index);

  String get _currentOtpString => _otp.join();

  void _verify() {
    if (_currentOtpString.length != 4) {
      showAuthSnack(context, 'Harap masukkan 4 digit kode OTP');
      return;
    }
    // BACKEND: verifikasi kode ke server; lanjut hanya jika benar.
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }

  String get _maskedPhone {
    if (_phone.isEmpty) return '+62 -';
    if (_phone.length >= 7) {
      return '+62 ${_phone.substring(0, 3)}-xxxx-${_phone.substring(_phone.length - 4)}';
    }
    return '+62 $_phone';
  }

  String get _timerText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
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
              child: KeyboardListener(
                focusNode: _keyboardFocusNode,
                autofocus: true,
                onKeyEvent: (event) {
                  if (event is KeyDownEvent || event is KeyRepeatEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.backspace) {
                      _onBackspace();
                      return;
                    }
                  }
                  if (event is KeyDownEvent) {
                    final keyLabel = event.logicalKey.keyLabel;
                    if (RegExp(r'^[0-9]$').hasMatch(keyLabel)) {
                      _onKeyPress(keyLabel);
                    }
                  }
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final contentWidth = constraints.maxWidth - 32;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Column(
                        children: [
                          // Konten atas: otomatis mengecil jika layar pendek
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                width: contentWidth,
                                child: _buildTopContent(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildKeypad(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 18),

        // Ikon amplop oranye
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF7A00), Color(0xFFFF5C00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFFB27A), width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.mark_email_read_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 14),

        const Text(
          'Verifikasi Kode OTP',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),

        const Text(
          'Masukkan 4–digit kode verifikasi yang telah kami\nkirimkan melalui WhatsApp ke nomor:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textLight,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),

        // Kotak nomor telepon
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 14,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _maskedPhone,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_outlined, size: 13, color: AuthStyle.link),
                    SizedBox(width: 3),
                    Text(
                      'Ubah',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AuthStyle.link,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // 4 kotak OTP
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final isCurrent = index == _activeDigit;
            final hasValue = _otp[index].isNotEmpty;

            return GestureDetector(
              onTap: () => _onSelectBox(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52,
                height: 52,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCurrent
                        ? const Color(0xFFFB923C)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isCurrent
                          ? AppColors.primary.withValues(alpha: 0.18)
                          : Colors.black.withValues(alpha: 0.04),
                      blurRadius: isCurrent ? 8 : 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: hasValue
                      ? Text(
                          _otp[index],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        )
                      : (isCurrent
                          ? FadeTransition(
                              opacity: _cursorController,
                              child: Container(
                                width: 2.5,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            )
                          : const SizedBox()),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),

        // Timer kirim ulang / tombol kirim ulang
        _secondsLeft > 0
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AuthStyle.pill,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined,
                        size: 13, color: Color(0xFF9A3412)),
                    const SizedBox(width: 5),
                    const Text(
                      'Kirim ulang kode dalam ',
                      style: TextStyle(
                        fontSize: 11,
                        color: AuthStyle.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _timerText,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF9A3412),
                      ),
                    ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: _resend,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AuthStyle.pill,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh_rounded,
                          size: 14, color: AuthStyle.link),
                      SizedBox(width: 5),
                      Text(
                        'Kirim ulang kode',
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
        const SizedBox(height: 20),

        AuthPrimaryButton(
          label: 'Verifikasi & Lanjutkan',
          height: 50,
          onTap: _verify,
        ),
        const SizedBox(height: 16),

        // Info keamanan
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: AuthStyle.pill,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lock_rounded, size: 14, color: Color(0xFF047857)),
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
                        text: 'Enkripsi End-to-End Terjamin. ',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF047857),
                        ),
                      ),
                      TextSpan(
                        text:
                            'Jangan berikan 4–digit PIN ini kepada siapa pun, termasuk kru atau staf',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Keypad putih, menempel di bagian bawah layar
  Widget _buildKeypad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildKeyRow(['1', '2', '3']),
        const SizedBox(height: 8),
        _buildKeyRow(['4', '5', '6']),
        const SizedBox(height: 8),
        _buildKeyRow(['7', '8', '9']),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _keyShell(
                child: Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDBA9B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildKey('0'),
            const SizedBox(width: 10),
            Expanded(
              child: _keyShell(
                onTap: _onBackspace,
                child: const Center(
                  child: Icon(
                    Icons.backspace_outlined,
                    size: 18,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyRow(List<String> values) {
    return Row(
      children: [
        for (int i = 0; i < values.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          _buildKey(values[i]),
        ],
      ],
    );
  }

  Widget _buildKey(String value) {
    return Expanded(
      child: _keyShell(
        onTap: () => _onKeyPress(value),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _keyShell({required Widget child, VoidCallback? onTap}) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}