import 'package:shared_preferences/shared_preferences.dart';

/// Status sesi pengguna.
///
/// - `isLoggedIn` -> user sudah login ke akun HotPay. DISIMPAN di HP, jadi
///   setelah aplikasi ditutup lalu dibuka lagi user langsung masuk ke /main.
/// - `isGuest`    -> user masuk sebagai tamu. TIDAK disimpan: setiap aplikasi
///   dibuka ulang, tamu kembali ke halaman awal (splash).
///
/// Method login/logout tetap sinkron (void) sehingga pemanggil lama
/// (login_screen, splash_screen) tidak perlu diubah.
class Session {
  Session._();

  static const String _kLoggedIn = 'is_logged_in';

  static SharedPreferences? _prefs;

  static bool isGuest = false;
  static bool isLoggedIn = false;

  /// Wajib dipanggil sekali di main() sebelum runApp().
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    isLoggedIn = _prefs?.getBool(_kLoggedIn) ?? false;
    isGuest = false;
  }

  static void loginAsGuest() {
    isGuest = true;
    isLoggedIn = false;
    _prefs?.setBool(_kLoggedIn, false);
  }

  /// Panggil setelah login (atau daftar) berhasil.
  /// BACKEND: kalau nanti ada token dari server, simpan token di
  /// flutter_secure_storage (bukan di sini) dan cek validitasnya di init().
  static void loginAsUser() {
    isGuest = false;
    isLoggedIn = true;
    _prefs?.setBool(_kLoggedIn, true);
  }

  static void logout() {
    isGuest = false;
    isLoggedIn = false;
    _prefs?.remove(_kLoggedIn);
  }
}