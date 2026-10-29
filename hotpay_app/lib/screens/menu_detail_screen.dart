import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/menu_item.dart';
import 'konfirmasi_screen.dart';

class MenuDetailScreen extends StatefulWidget {
  final MenuItem item;
  const MenuDetailScreen({super.key, required this.item});
  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  int qty = 1;
  MenuItem get item => widget.item;

  Widget _spec(IconData i, String label, String value) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Icon(i, size: 18, color: AppColors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: ts(9, w: FontWeight.w700, c: AppColors.muted)),
              Text(value, style: ts(11, w: FontWeight.w800)),
            ]),
          ),
        ]),
      );

  Widget _stepBtn(IconData i, VoidCallback? onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(color: onTap == null ? AppColors.field : Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Icon(i, size: 16, color: onTap == null ? AppColors.muted : AppColors.orange),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: PrimaryButton(
              label: 'Lanjut ke Konfirmasi  ${rp(item.price * qty)}',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => KonfirmasiScreen(item: item, qty: qty))),
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.only(bottom: 16), children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
              child: Row(children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, size: 20)),
                const Icon(Icons.restaurant_menu, size: 16, color: AppColors.orange),
                const SizedBox(width: 6),
                Text('Ringkasan Menu', style: ts(14, w: FontWeight.w800)),
              ]),
            ),
            FoodImage(item.image, width: double.infinity, height: 200, radius: 0),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Text(item.name, style: ts(20, w: FontWeight.w800))),
                  Text(rp(item.price), style: ts(18, w: FontWeight.w800, c: AppColors.orange)),
                ]),
                const SizedBox(height: 4),
                Text('${item.category} • Siap Saji Otomatis', style: ts(11, w: FontWeight.w700, c: AppColors.brown)),
                const SizedBox(height: 14),
                Panel(
                  color: AppColors.field,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Deskripsi Hidangan', style: ts(12, w: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(item.desc, style: ts(12, c: AppColors.muted, h: 1.5)),
                  ]),
                ),
                const SizedBox(height: 16),
                Text('Spesifikasi Kios Otomatis', style: ts(10, w: FontWeight.w800, c: AppColors.muted)),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.6,
                  children: [
                    _spec(Icons.timer_outlined, 'Waktu Saji', item.time),
                    _spec(Icons.inventory_2_outlined, 'Porsi Standar', item.portion),
                    _spec(Icons.verified_outlined, 'Higienis & Aman', item.pack),
                    _spec(Icons.local_fire_department_outlined, 'Garansi Panas', 'Saji Hangat 85°C'),
                  ],
                ),
                const SizedBox(height: 12),
                Panel(
                  color: AppColors.field,
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    const Icon(Icons.info_outline, size: 16, color: AppColors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Pesanan langsung disiapkan dan dipanaskan otomatis oleh modul dispenser setelah konfirmasi.',
                          style: ts(10, c: AppColors.muted, h: 1.4)),
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
                Panel(
                  color: AppColors.field,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(children: [
                    Text('Jumlah Pesanan', style: ts(12, w: FontWeight.w800)),
                    const Spacer(),
                    _stepBtn(Icons.remove, qty > 1 ? () => setState(() => qty--) : null),
                    SizedBox(width: 36, child: Center(child: Text('$qty', style: ts(14, w: FontWeight.w800)))),
                    _stepBtn(Icons.add, qty < item.stock ? () => setState(() => qty++) : null),
                  ]),
                ),
              ]),
            ),
          ]),
        ),
      );
}
