import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import 'preparing_screen.dart';
import 'struk_screen.dart';

/// Kartu pesanan yang sedang dipanaskan (dipakai di tab Pesanan & Riwayat).
class ActiveOrderCard extends StatelessWidget {
  final Order order;
  const ActiveOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
      valueListenable: OrderStore.tick,
      builder: (context, _, __) => _card(context));

  Widget _card(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.orangeSoft, borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.circle, size: 8, color: AppColors.orange),
            const SizedBox(width: 6),
            Text('SEDANG DIPANASKAN (85°C)', style: ts(9, w: FontWeight.w800, c: AppColors.brown)),
            const Spacer(),
            pill('${((1 - order.progress) * 3).ceil().clamp(1, 3)} Menit Lagi', Colors.white, AppColors.brown),
          ]),
          const SizedBox(height: 8),
          Text(order.item.name, style: ts(16, w: FontWeight.w800)),
          Text('Slot Dispenser A2 • Kios VM-01', style: ts(10, c: AppColors.muted)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: order.progress, minHeight: 6, color: AppColors.orange, backgroundColor: Colors.white),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Pantau Live Status',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PreparingScreen(order: order))),
          ),
        ]),
      );
}

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});
  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  static const filters = ['Semua', 'Selesai', 'Diproses'];
  String filter = 'Semua';
  String query = '';

  bool _match(Order o) {
    if (filter == 'Selesai' && o.status != OrderStatus.done) return false;
    if (filter == 'Diproses' && o.status != OrderStatus.preparing) return false;
    final q = query.trim().toLowerCase();
    return q.isEmpty || o.item.name.toLowerCase().contains(q) || o.no.toLowerCase().contains(q);
  }

  String _favorite(List<Order> list) {
    if (list.isEmpty) return '-';
    final count = <String, int>{};
    for (final o in list) {
      count[o.item.name] = (count[o.item.name] ?? 0) + o.qty;
    }
    return (count.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key;
  }

  Widget _tile(Order o) => GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StrukScreen(order: o))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('#${o.no}', style: ts(11, w: FontWeight.w800)),
              Text('  •  ${fmtDay(o.time)}, ${fmtClock(o.time)}', style: ts(9, c: AppColors.muted)),
              const Spacer(),
              o.status == OrderStatus.done
                  ? pill('Selesai Disajikan', AppColors.greenSoft, AppColors.green, size: 8)
                  : pill('Sedang Diproses', AppColors.orangeSoft, AppColors.brown, size: 8),
            ]),
            const SizedBox(height: 4),
            Text('Kios VM-01 • PT. Jaya Abadi, Mukakuning', style: ts(9, c: AppColors.muted)),
            const SizedBox(height: 8),
            Panel(
              color: AppColors.field,
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                FoodImage(o.item.image, width: 40, height: 40, radius: 8),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${o.item.name} (${o.qty}x)', style: ts(12, w: FontWeight.w800)),
                    pill('QRIS • Lunas', AppColors.greenSoft, AppColors.green, size: 8),
                  ]),
                ),
                Text(rp(o.total), style: ts(12, w: FontWeight.w800)),
              ]),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<UserProfile>(
        valueListenable: UserStore.profile,
        builder: (context, user, _) => ValueListenableBuilder<Order?>(
          valueListenable: OrderStore.active,
          builder: (context, active, _) => ValueListenableBuilder<List<Order>>(
            valueListenable: OrderStore.history,
            builder: (context, history, _) {
              final all = [if (active != null) active, ...history];
              final shown = all.where(_match).toList();
              return ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
                const BrandHeader(subtitle: 'RIWAYAT PESANAN'),
                Panel(
                  child: Column(children: [
                    Row(children: [
                      CircleAvatar(backgroundColor: AppColors.orangeSoft, child: Text(user.initials, style: ts(12, w: FontWeight.w800, c: AppColors.brown))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Halo, ${user.name}', style: ts(14, w: FontWeight.w800)),
                          pill('Akun Konsumen AKTIF', AppColors.orangeSoft, AppColors.brown, size: 8),
                        ]),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Panel(
                      color: AppColors.field,
                      padding: const EdgeInsets.all(10),
                      child: Row(children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Total Pesanan', style: ts(9, c: AppColors.muted)),
                          Text('${all.length}', style: ts(16, w: FontWeight.w800)),
                        ]),
                        const Spacer(),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text('Menu Favorit', style: ts(9, c: AppColors.muted)),
                          Text(_favorite(all), style: ts(12, w: FontWeight.w800, c: AppColors.brown)),
                        ]),
                      ]),
                    ),
                  ]),
                ),
                if (active != null) ...[const SizedBox(height: 12), ActiveOrderCard(order: active)],
                const SizedBox(height: 12),
                TextField(
                  onChanged: (v) => setState(() => query = v),
                  style: ts(12),
                  decoration: InputDecoration(
                    hintText: 'Cari riwayat transaksi atau menu...',
                    hintStyle: ts(12, c: AppColors.muted),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Riwayat Pesanan', style: ts(15, w: FontWeight.w800)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  for (final f in filters)
                    ChoiceChip(
                      label: Text(f, style: ts(11, w: FontWeight.w800, c: filter == f ? Colors.white : AppColors.muted)),
                      selected: filter == f,
                      showCheckmark: false,
                      selectedColor: AppColors.text,
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                      onSelected: (_) => setState(() => filter = f),
                    ),
                ]),
                const SizedBox(height: 10),
                if (shown.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(child: Text('Belum ada transaksi yang cocok.', style: ts(12, c: AppColors.muted))),
                  ),
                for (final o in shown) _tile(o),
              ]);
            },
          ),
        ),
      );
}
