import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/profile_store.dart';

/// Avatar profil: foto jika ada, kalau tidak tampilkan inisial.
class ProfileAvatar extends StatelessWidget {
  final double radius;
  final Uint8List? photo;
  final String initials;

  const ProfileAvatar({
    super.key,
    required this.radius,
    required this.photo,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFFFD7C8),
      backgroundImage: photo != null ? MemoryImage(photo!) : null,
      child: photo == null
          ? Text(
              initials,
              style: TextStyle(
                fontSize: radius * 0.7,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF5B4A44),
              ),
            )
          : null,
    );
  }
}

/// Pop up "Informasi Pribadi": ubah foto, nama, email, dan nomor WhatsApp/HP.
/// Buka dengan: EditProfileDialog.show(context);
class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditProfileDialog(),
    );
  }

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  // Warna sesuai desain
  static const Color _panel = Color(0xFFEEEDFB);
  static const Color _brown = Color(0xFF5B4A44);
  static const Color _ink = Color(0xFF1E1B3A);

  final ProfileStore _store = ProfileStore.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  Uint8List? _photo;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _store.name)
      ..addListener(() => setState(() {}));
    _emailController = TextEditingController(text: _store.email)
      ..addListener(() => setState(() {}));
    _phoneController = TextEditingController(text: _store.phone);
    _photo = _store.photo;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Logika
  // ---------------------------------------------------------------------------
  bool get _emailVerified =>
      _emailController.text.trim().toLowerCase() ==
      _store.verifiedEmail.toLowerCase();

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        imageQuality: 85,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() {
        _photo = bytes;
        _error = null;
      });
    } on MissingPluginException {
      if (!mounted) return;
      setState(() => _error =
          'Fitur foto belum aktif. Hentikan aplikasi lalu jalankan ulang (bukan Hot Reload/Restart).');
    } on PlatformException catch (e) {
      debugPrint('pickImage PlatformException: ${e.code} ${e.message}');
      if (!mounted) return;
      setState(() => _error = e.code.contains('denied')
          ? 'Izin ditolak. Aktifkan izin kamera/galeri di Pengaturan HP.'
          : 'Tidak bisa membuka foto (${e.code}).');
    } catch (e) {
      debugPrint('pickImage error: $e');
      if (!mounted) return;
      setState(() => _error = 'Tidak bisa membuka foto. Coba lagi.');
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 24),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _photoOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Pilih dari Galeri',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickPhoto(ImageSource.gallery);
                  },
                ),
                _photoOption(
                  icon: Icons.photo_camera_outlined,
                  label: 'Ambil Foto',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickPhoto(ImageSource.camera);
                  },
                ),
                if (_photo != null)
                  _photoOption(
                    icon: Icons.delete_outline_rounded,
                    label: 'Hapus Foto',
                    color: AppColors.danger,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      setState(() => _photo = null);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _photoOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = _ink,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.length < 3) {
      setState(() => _error = 'Nama lengkap minimal 3 karakter');
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      setState(() => _error = 'Format email tidak valid');
      return;
    }
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone != _store.phone && (digits.length < 9 || digits.length > 15)) {
      setState(() => _error = 'Nomor WhatsApp / HP tidak valid');
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    // BACKEND: kirim perubahan profil (dan foto) ke server di sini.
    _store.update(
      name: name,
      email: email,
      phone: phone,
      photo: _photo,
    );

    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
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
        : media.viewPadding.bottom + 28;

    return Padding(
      padding: EdgeInsets.fromLTRB(14, 0, 14, bottomSpace),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE3FB),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Isi yang bisa digulir
            Flexible(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 12),
                    _buildPhotoCard(),
                    const SizedBox(height: 14),

                    _label('NAMA LENGKAP'),
                    const SizedBox(height: 6),
                    _field(
                      icon: Icons.person_outline_rounded,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      hint: 'Nama lengkap Anda',
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _label('ALAMAT EMAIL'),
                        _emailBadge(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _field(
                      icon: Icons.mail_outline_rounded,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      hint: 'nama@email.com',
                    ),
                    const SizedBox(height: 14),

                    _label('NOMOR WHATSAPP / HP'),
                    const SizedBox(height: 6),
                    _field(
                      icon: Icons.phone_android_rounded,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      hint: '+62 812-xxxx-xxxx',
                      formatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9+\-\sxX]')),
                        LengthLimitingTextInputFormatter(20),
                      ],
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              size: 14, color: Color(0xFFDC2626)),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Tombol Batal & Simpan
            Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFF0EFFA), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: Material(
                        color: const Color(0xFFE9E9F7),
                        borderRadius: BorderRadius.circular(23),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(23),
                          onTap: () => Navigator.pop(context),
                          child: const Center(
                            child: Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: _brown,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: Material(
                        color: const Color(0xFFF97316),
                        borderRadius: BorderRadius.circular(23),
                        elevation: 3,
                        shadowColor:
                            const Color(0xFFF97316).withValues(alpha: 0.4),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(23),
                          onTap: _save,
                          child: const Center(
                            child: Text(
                              'Simpan Perubahan',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Pribadi',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Kelola data akun & preferensi konsumen SmartBite',
                style: TextStyle(
                  fontSize: 12.5,
                  color: _brown,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () => Navigator.pop(context),
          customBorder: const CircleBorder(),
          child: Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF0FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close_rounded, size: 18, color: _brown),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoCard() {
    final displayName = _nameController.text.trim().isEmpty
        ? _store.name
        : _nameController.text.trim();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ProfileAvatar(
                radius: 27,
                photo: _photo,
                initials: ProfileStore.initialsOf(displayName),
              ),
              Positioned(
                right: -3,
                bottom: -3,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: _panel, width: 2),
                  ),
                  child: const Icon(Icons.check_rounded,
                      size: 11, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              displayName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: _ink,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            elevation: 1,
            shadowColor: Colors.black.withValues(alpha: 0.12),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _showPhotoOptions,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_camera_outlined,
                        size: 15, color: Color(0xFFC2410C)),
                    SizedBox(width: 5),
                    Text(
                      'Ubah Foto',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFC2410C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: _brown,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _emailBadge() {
    final bool verified = _emailVerified;
    final Color bg =
        verified ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7);
    final Color fg =
        verified ? const Color(0xFF047857) : const Color(0xFFB45309);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verified
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
            size: 12,
            color: fg,
          ),
          const SizedBox(width: 4),
          Text(
            verified ? 'Terverifikasi' : 'Perlu verifikasi',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? formatters,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _brown),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              inputFormatters: formatters,
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: _ink,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFFA8A29E),
                ),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}