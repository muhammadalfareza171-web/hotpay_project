import 'package:shared_preferences/shared_preferences.dart';

/// Sesi khusus untuk operator HotPay.
/// Nomor operator: 82171577894 (tanpa angka 0 di depan, sesuai format input +62).
/// Kata sandi: 12345678.
class OperatorSession {
  OperatorSession._();

  static const String operatorPhone = '82171577894';
  static const String operatorPassword = '12345678';
  static const String _kOperator = 'is_operator';

  static SharedPreferences? _prefs;

  static bool isOperator = false;

  /// Panggil sekali sebelum runApp().
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    isOperator = _prefs?.getBool(_kOperator) ?? false;
  }

  /// Validasi kredensial operator.
  /// Menerima format: 82171577894, 082171577894, 6282171577894, +6282171577894.
  static bool validate(String rawPhone, String password) {
    if (password != operatorPassword) return false;
    // Hapus karakter non-angka
    String digits = rawPhone.replaceAll(RegExp(r'\D'), '');
    // Normalisasi awalan: 62 -> hapus, 0 -> hapus
    if (digits.startsWith('62')) {
      digits = digits.substring(2);
    }
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    return digits == operatorPhone;
  }

  /// Set sesi sebagai operator.
  static void loginAsOperator() {
    isOperator = true;
    _prefs?.setBool(_kOperator, true);
  }

  /// Hapus sesi operator.
  static void logout() {
    isOperator = false;
    _prefs?.remove(_kOperator);
  }
}
