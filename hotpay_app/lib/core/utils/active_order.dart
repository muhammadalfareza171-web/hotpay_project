import 'package:flutter/foundation.dart';
import '../../models/menu_item.dart';

/// Data pesanan yang sedang diproses mesin.
class ActiveOrderData {
  final MenuItem item;
  final DateTime startedAt;

  const ActiveOrderData({required this.item, required this.startedAt});
}

/// Menyimpan pesanan aktif (yang sedang dimasak).
///
/// - `ActiveOrder.start(item)` dipanggil saat pembayaran berhasil.
/// - `ActiveOrder.clear()` dipanggil saat pengguna menekan "SELESAI"
///   di halaman Pesanan Selesai.
/// - Halaman Pesanan mendengarkan [current] sehingga otomatis berganti antara
///   tampilan "belum ada pesanan" dan tampilan "sedang disiapkan".
class ActiveOrder {
  ActiveOrder._();

  static final ValueNotifier<ActiveOrderData?> current =
      ValueNotifier<ActiveOrderData?>(null);

  static bool get isActive => current.value != null;

  static void start(MenuItem item) {
    current.value = ActiveOrderData(item: item, startedAt: DateTime.now());
  }

  static void clear() {
    current.value = null;
  }
}