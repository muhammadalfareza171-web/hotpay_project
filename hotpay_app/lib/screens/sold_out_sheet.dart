import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/menu_item.dart';
import 'menu_detail_screen.dart';

void showSoldOutSheet(BuildContext context, MenuItem sold) {
  final recs = menus.where((m) => !m.soldOut).take(2).toList();
  showAppSheet(
    context,
    Builder(
      builder: (ctx) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppColors.redSoft, borderRadius: BorderRadius.circular(8)),
          child: Text('Porsi Terjual Habis (Sold Out)', style: ts(10, w: FontWeight.w800, c: AppColors.red)),
        ),
        const SizedBox(height: 10),
        Text('Yah, Porsi Hidangan Ini Sedang Habis!', style: ts(20, w: FontWeight.w800, h: 1.2)),
        const SizedBox(height: 6),
        Text('Maaf, ${sold.name} di Kios VM-01 sedang dalam proses restok oleh operator kiosk kami.',
            style: ts(12, c: AppColors.muted, h: 1.5)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.field, borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            FoodImage(sold.image, width: 44, height: 44, radius: 10),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(sold.name, style: ts(13, w: FontWeight.w800, c: AppColors.muted).copyWith(decoration: TextDecoration.lineThrough)),
                Text('0 Porsi Tersedia', style: ts(10, w: FontWeight.w700, c: AppColors.red)),
              ]),
            ),
            Text(rp(sold.price), style: ts(12, w: FontWeight.w700, c: AppColors.muted)),
          ]),
        ),
        const SizedBox(height: 16),
        Text('Rekomendasi Menu Lainnya', style: ts(13, w: FontWeight.w800)),
        const SizedBox(height: 8),
        for (final r in recs)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(border: Border.all(color: AppColors.field), borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              FoodImage(r.image, width: 48, height: 48, radius: 10),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.name, style: ts(12, w: FontWeight.w800)),
                  Text(rp(r.price), style: ts(13, w: FontWeight.w800, c: AppColors.orange)),
                  Text('${r.stock} porsi • ${r.time}', style: ts(9, c: AppColors.muted)),
                ]),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0, backgroundColor: AppColors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MenuDetailScreen(item: r)));
                },
                child: Text('Pilih', style: ts(11, w: FontWeight.w800, c: Colors.white)),
              ),
            ]),
          ),
        const SizedBox(height: 8),
        PrimaryButton(label: 'Lihat Menu Tersedia Lainnya', icon: Icons.restaurant_menu, onPressed: () => Navigator.pop(ctx)),
      ]),
    ),
  );
}
