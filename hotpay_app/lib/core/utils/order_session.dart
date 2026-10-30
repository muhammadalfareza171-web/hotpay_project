import '../../models/menu_item.dart';

/// Menyimpan jumlah porsi yang dipesan selama alur pemesanan berlangsung:
/// Detail Menu -> Konfirmasi -> QRIS -> Berhasil -> Diproses -> Selesai -> E-Struk.
///
/// Letakkan di: lib/core/utils/order_session.dart
class OrderSession {
  OrderSession._();

  /// Jumlah porsi yang dipilih di halaman detail menu.
  static int quantity = 1;

  /// Total harga = harga satuan x jumlah porsi.
  static int totalFor(MenuItem item) => item.price * quantity;

  /// Panggil saat pesanan selesai agar pesanan berikutnya mulai dari 1.
  static void reset() => quantity = 1;
}