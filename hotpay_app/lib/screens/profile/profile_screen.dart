import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/guest_mode.dart';
import '../../core/utils/profile_store.dart';
import '../../core/utils/session.dart';
import '../../models/user_profile.dart';
import '../../widgets/hotpay_app_bar.dart';
import '../../widgets/login_required_dialog.dart';
import 'edit_profile_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Warna sesuai desain
  static const Color _bg = Color(0xFFF5F4FF);
  static const Color _panel = Color(0xFFEEEDFB);
  static const Color _ink = Color(0xFF1E1B3A);
  static const Color _brown = Color(0xFF5B4A44);

  final ProfileStore _store = ProfileStore.instance;

  @override
  void initState() {
    super.initState();
    if (GuestMode.isGuest) return; // tamu: tidak ada data profil
    // Isi data awal profil (sekali saja) dari data pengguna contoh / backend.
    final user = UserProfile.sampleUser;
    _store.seed(
      id: user.id.toString(),
      name: user.name.toString(),
      phone: user.phone.toString(),
      email: 'ahmad@gmail.com', // BACKEND: ganti dengan email akun yang login
    );
  }

  void _openEditProfile() {
    if (!LoginRequiredDialog.guard(context)) return;
    EditProfileDialog.show(context);
  }

  void _goToLogin() {
    GuestMode.exit();
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginRequiredDialog.loginRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: const HotPayAppBar(
        showBackButton: true,
        showProfile: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Konten yang bisa digulir
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kartu profil ikut berubah saat data diedit.
                    ListenableBuilder(
                      listenable: _store,
                      builder: (context, _) => _buildProfileCard(),
                    ),
                    const SizedBox(height: 26),

                    _sectionLabel('PENGATURAN & KEAMANAN'),
                    const SizedBox(height: 10),
                    _buildMenuTile(
                      icon: Icons.badge_outlined,
                      title: 'Informasi Pribadi & Edit Profil',
                      subtitle: 'Kelola nama, email, dan tanggal lahir',
                      onTap: _openEditProfile,
                    ),
                    const SizedBox(height: 26),

                    _sectionLabel('BANTUAN & LAYANAN'),
                    const SizedBox(height: 10),
                    _buildMenuTile(
                      icon: Icons.quiz_outlined,
                      title: 'Pusat Bantuan Kios & FAQ Dispensing',
                      subtitle: 'Panduan pengambilan makanan cepat',
                      onTap: () {
                        if (!LoginRequiredDialog.guard(context)) return;
                        Navigator.pushNamed(context, '/help');
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Logout + footer menempel di bawah
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
              child: Column(
                children: [
                  _buildLogoutButton(),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.soup_kitchen_outlined,
                          size: 15, color: _brown),
                      SizedBox(width: 6),
                      Text(
                        'HotPay Vending Mesin',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _brown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Versi 1.0 (Build 202410) • nura Kitchen Integrated',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // KARTU PROFIL
  // =====================================================

  Widget _buildProfileCard() {
    if (GuestMode.isGuest) return _buildGuestCard();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Glow oranye di kanan
            Positioned(
              right: -30,
              top: -20,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.22),
                      AppColors.primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  ProfileAvatar(
                    radius: 29,
                    photo: _store.photo,
                    initials: _store.initials,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _store.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'ID: ${_store.id}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _store.phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Tombol edit (pensil)
                  InkWell(
                    onTap: _openEditProfile,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE9E7FA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 17,
                        color: _ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kartu profil untuk tamu (belum masuk akun)
  Widget _buildGuestCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 29,
            backgroundColor: _panel,
            child: Icon(Icons.person_outline_rounded, size: 30, color: _ink),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tamu HotPay',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Belum masuk akun',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Masuk untuk memesan & lihat riwayat',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // KOMPONEN
  // =====================================================

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: _brown,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _panel,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: _ink, size: 21),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _ink,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: _ink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    final guest = GuestMode.isGuest;
    final Color fg = guest ? AppColors.primary : AppColors.danger;

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: guest ? const Color(0xFFFFE6D8) : const Color(0xFFFFD9DE),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: fg.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            if (guest) {
              _goToLogin();
              return;
            }
            // Hapus sesi tersimpan supaya tidak auto-login lagi.
            Session.logout();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/splash',
              (route) => false,
            );
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  guest ? Icons.login_rounded : Icons.logout_rounded,
                  size: 18,
                  color: fg,
                ),
                const SizedBox(width: 8),
                Text(
                  guest ? 'Masuk ke Akun HotPay' : 'Keluar dari Akun',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: fg,
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