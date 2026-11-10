import 'package:flutter/foundation.dart';

/// Menyimpan status "mode tamu" (belum masuk akun HotPay).
///
/// - `GuestMode.enter()` dipanggil saat pengguna menekan "Masuk sebagai Tamu".
/// - `GuestMode.exit()` dipanggil saat pengguna memilih masuk/login.
/// - Default `false`, jadi alur pengguna yang sudah login tidak berubah.
class GuestMode {
  GuestMode._();

  static final ValueNotifier<bool> notifier = ValueNotifier<bool>(false);

  static bool get isGuest => notifier.value;

  static void enter() => notifier.value = true;

  static void exit() => notifier.value = false;
}