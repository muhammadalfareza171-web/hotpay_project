import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'menu_item.dart';

enum OrderStatus { preparing, done }

class Order {
  final String no;
  final MenuItem item;
  final int qty;
  final DateTime time;
  OrderStatus status;
  double progress = 0.05;

  Order({required this.no, required this.item, required this.qty, DateTime? time, this.status = OrderStatus.preparing})
      : time = time ?? DateTime.now();

  int get total => item.price * qty;
  String get slot => '#02';
  String get bay => 'A-02';
}

String newOrderNo() => 'SB-${(DateTime.now().millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}';

const _bln = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
String two(int n) => n.toString().padLeft(2, '0');
String fmtDate(DateTime d) => '${d.day} ${_bln[d.month - 1]} ${d.year}, ${two(d.hour)}:${two(d.minute)}:${two(d.second)} WIB';
String fmtClock(DateTime d) => '${two(d.hour)}.${two(d.minute)} WIB';
String fmtDay(DateTime d) {
  final n = DateTime.now();
  if (d.year == n.year && d.month == n.month && d.day == n.day) return 'Hari ini';
  return '${d.day} ${_bln[d.month - 1]} ${d.year}';
}

/// Penyimpanan sementara di memori. Ganti dengan API / database lokal.
class OrderStore {
  static final active = ValueNotifier<Order?>(null);
  static final history = ValueNotifier<List<Order>>([
    Order(no: 'SB-98284', item: menus[2], qty: 1, time: DateTime.now().subtract(const Duration(hours: 2)), status: OrderStatus.done),
  ]);

  /// Menandai perubahan progres agar layar yang mendengarkan ikut diperbarui.
  static final tick = ValueNotifier<int>(0);
  static Timer? _timer;

  /// Simulasi progres mesin. TODO: ganti dengan status real-time dari server (WebSocket/polling).
  static void start(Order o) {
    active.value = o;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 250), (t) {
      o.progress = math.min(1.0, o.progress + 0.02);
      if (o.progress >= 1.0) {
        t.cancel();
        finish(o);
      }
      tick.value++;
    });
  }

  static void finish(Order o) {
    o.status = OrderStatus.done;
    history.value = [o, ...history.value.where((e) => e.no != o.no)];
    if (active.value?.no == o.no) active.value = null;
  }
}

class UserProfile {
  final String name, email, phone;
  const UserProfile({required this.name, required this.email, required this.phone});

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    return parts.length == 1 ? parts.first[0].toUpperCase() : (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class UserStore {
  static final profile = ValueNotifier<UserProfile>(
      const UserProfile(name: 'Ahmad Pratama', email: 'ahmad@gmail.com', phone: '812-xxxx-xxxx'));
}
