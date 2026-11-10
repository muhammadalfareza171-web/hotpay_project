import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/session.dart';
import '../../widgets/auth_widgets.dart';

/// Data akun Google yang dipilih.
class GoogleAccount {
  final String name;
  final String email;
  final String initials;
  final Color avatarBg;
  final Color avatarFg;
  final bool isPrimary;
  final String note;

  const GoogleAccount({
    required this.name,
    required this.email,
    required this.initials,
    required this.avatarBg,
    required this.avatarFg,
    this.isPrimary = false,
    this.note = '',
  });

  /// Dikirim ke halaman utama lewat arguments.
  Map<String, String> toMap() => {
        'name': name,
        'email': email,
        'provider': 'google',
      };
}

/// Pilih akun Google (alur daftar cepat).
/// Buka dengan: GoogleAuthDialog.show(context);
class GoogleAuthDialog extends StatefulWidget {
  const GoogleAuthDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const GoogleAuthDialog(),
    );
  }

  @override
  State<GoogleAuthDialog> createState() => _GoogleAuthDialogState();
}

class _GoogleAuthDialogState extends State<GoogleAuthDialog> {
  static const List<GoogleAccount> _initialAccounts = [
    GoogleAccount(
      name: 'Ahmad Pratama',
      email: 'ahmad.pratama@gmail.com',
      initials: 'AP',
      avatarBg: Color(0xFFFED7AA),
      avatarFg: Color(0xFFC2410C),
      isPrimary: true,
      note: 'Terhubung di perangkat ini',
    ),
    GoogleAccount(
      name: 'Budi Prasetyo (Work)',
      email: 'budi.prasetyo@techcorp.id',
      initials: 'BP',
      avatarBg: Color(0xFFE0E7FF),
      avatarFg: Color(0xFF4338CA),
      note: 'Akun Google Workspace',
    ),
  ];

  final List<GoogleAccount> _accounts = [..._initialAccounts];

  static const Color _rowBg = Color(0xFFEEF0FF);
  static const Color _green = Color(0xFF047857);

  int _selected = 0;

  late final TapGestureRecognizer _privacyTap;
  late final TapGestureRecognizer _termsTap;

  @override
  void initState() {
    super.initState();
    _privacyTap = TapGestureRecognizer()
      ..onTap = () => showAuthSnack(context, 'Kebijakan Privasi segera hadir');
    _termsTap = TapGestureRecognizer()
      ..onTap = () => showAuthSnack(context, 'Ketentuan Layanan segera hadir');
  }

  @override
  void dispose() {
    _privacyTap.dispose();
    _termsTap.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Logika
  // ---------------------------------------------------------------------------
  GoogleAccount get _current => _accounts[_selected];

  String get _firstName => _current.name.split(' ').first;

  /// Lanjut dengan akun yang dipilih: Ahmad -> Ahmad, Budi -> Budi.
  void _continueWith(GoogleAccount account) {
    final nav = Navigator.of(context);
    // BACKEND: tukar akun Google ini dengan sesi/token dari server.
    Session.loginAsUser();
    nav.pop();
    nav.pushNamedAndRemoveUntil(
      '/main',
      (route) => false,
      arguments: account.toMap(),
    );
  }

  /// "Gunakan akun Google lain" -> TIDAK membuka pop up email.
  /// Nanti dihubungkan ke konfigurasi Google (Google Sign-In) di backend,
  /// sehingga pemilih akun Google resmi yang akan muncul.
  Future<void> _useAnotherGoogleAccount() async {
    // BACKEND: panggil Google Sign-In di sini, contoh (package google_sign_in):
    //
    //   final googleSignIn = GoogleSignIn();
    //   await googleSignIn.signOut();            // paksa tampil pemilih akun
    //   final user = await googleSignIn.signIn();
    //   if (user == null) return;                // pengguna membatalkan
    //
    //   final name = user.displayName ?? user.email;
    //   _continueWith(GoogleAccount(
    //     name: name,
    //     email: user.email,
    //     initials: name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase(),
    //     avatarBg: const Color(0xFFD1FAE5),
    //     avatarFg: const Color(0xFF047857),
    //   ));
    //
    // Sementara belum tersambung, tampilkan info singkat.
    showAuthSnack(
      context,
      'Pemilih akun Google akan tersambung setelah konfigurasi backend selesai',
    );
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomSpace = media.viewInsets.bottom > 0
        ? media.viewInsets.bottom + 12
        : media.viewPadding.bottom + 24;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomSpace),
      child: Container(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              ..._buildAccountList(),
              const SizedBox(height: 16),
              _buildConsent(),
              const SizedBox(height: 18),
              AuthPrimaryButton(
                label: 'Lanjutkan sebagai $_firstName',
                onTap: () => _continueWith(_current),
              ),
              const SizedBox(height: 10),
              _buildCancelButton(),
              const SizedBox(height: 12),
              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        size: 11, color: AuthStyle.icon),
                    SizedBox(width: 4),
                    Text(
                      'DILINDUNGI OLEH GOOGLE IDENTITY SERVICES',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AuthStyle.icon,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _googleG(),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih akun untuk HotPay',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Lanjutkan pendaftaran ke Hot Food Vending Mesin',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
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

  // Logo "G" empat warna (tanpa perlu internet)
  Widget _googleG() {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ShaderMask(
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
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAccountList() {
    return [
      for (int i = 0; i < _accounts.length; i++) ...[
        _accountTile(i),
        const SizedBox(height: 10),
      ],
      // Gunakan akun Google lain (tetap bisa ditekan, tanpa pop up email)
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _useAnotherGoogleAccount,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 19,
                  backgroundColor: _rowBg,
                  child: Icon(Icons.person_add_alt_rounded,
                      size: 18, color: AppColors.textPrimary),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gunakan akun Google lain',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Masuk dengan email baru',
                        style: TextStyle(
                            fontSize: 10.5, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 13, color: AuthStyle.icon.withValues(alpha: 0.7)),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _accountTile(int index) {
    final a = _accounts[index];
    final selected = _selected == index;

    return GestureDetector(
      onTap: () => setState(() => _selected = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _rowBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: a.avatarBg,
                  child: Text(
                    a.initials,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: a.avatarFg,
                    ),
                  ),
                ),
                if (a.isPrimary)
                  Positioned(
                    bottom: -1,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: _rowBg, width: 1.5),
                      ),
                      child: const Icon(Icons.check,
                          size: 8, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          a.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (a.isPrimary) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE4CC),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Utama',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFC2410C),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    a.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11.5, color: AuthStyle.muted),
                  ),
                  if (a.note.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (a.isPrimary) ...[
                          const Icon(Icons.phone_android_rounded,
                              size: 11, color: _green),
                          const SizedBox(width: 3),
                        ],
                        Text(
                          a.note,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: a.isPrimary ? _green : AuthStyle.icon,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            _radio(selected),
          ],
        ),
      ),
    );
  }

  Widget _radio(bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: selected ? AppColors.primary : const Color(0xFFD5D8EE),
          width: selected ? 6 : 1.5,
        ),
      ),
    );
  }

  Widget _buildConsent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AuthStyle.field,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_rounded,
              size: 16, color: Color(0xFF10B981)),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9A3412),
                  height: 1.4,
                ),
                children: [
                  const TextSpan(
                    text:
                        'Google akan membagikan nama, email, dan foto profil ke HotPay. Lihat ',
                  ),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    recognizer: _privacyTap,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' dan '),
                  TextSpan(
                    text: 'Ketentuan Layanan',
                    recognizer: _termsTap,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFEDEEFA),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(23),
          onTap: () => Navigator.pop(context),
          child: const Center(
            child: Text(
              'Batal',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}