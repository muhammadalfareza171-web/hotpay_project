import 'package:flutter/foundation.dart';

/// Menyimpan data profil yang bisa diedit (nama, email, nomor HP, foto).
/// Halaman profil ikut diperbarui otomatis saat data berubah.
///
/// Letakkan di: lib/core/utils/profile_store.dart
class ProfileStore extends ChangeNotifier {
  ProfileStore._();

  static final ProfileStore instance = ProfileStore._();

  bool _seeded = false;

  String id = '';
  String name = '';
  String email = '';
  String phone = '';

  /// Email yang sudah terverifikasi (untuk lencana "Terverifikasi").
  String verifiedEmail = '';

  /// Foto profil (null = tampilkan inisial).
  Uint8List? photo;

  /// Isi data awal sekali saja (dari UserProfile.sampleUser / backend).
  void seed({
    required String id,
    required String name,
    required String phone,
    required String email,
  }) {
    if (_seeded) return;
    _seeded = true;
    this.id = id;
    this.name = name;
    this.phone = phone;
    this.email = email;
    verifiedEmail = email;
  }

  String get initials => initialsOf(name);

  static String initialsOf(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      final w = words.first;
      return w.substring(0, w.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  /// Simpan perubahan dari form edit profil.
  /// BACKEND: panggil API update profil di sini sebelum menyimpan.
  void update({
    required String name,
    required String email,
    required String phone,
    required Uint8List? photo,
  }) {
    this.name = name;
    this.email = email;
    this.phone = phone;
    this.photo = photo;
    notifyListeners();
  }
}