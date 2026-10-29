import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/order.dart';
import 'order_done_screen.dart';

class PreparingScreen extends StatefulWidget {
  final Order order;
  const PreparingScreen({super.key, required this.order});
  @override
  State<PreparingScreen> createState() => _PreparingScreenState();
}

class _PreparingScreenState extends State<PreparingScreen> {
  Order get o => widget.order;

  @override
  void initState() {
    super.initState();
    OrderStore.tick.addListener(_onTick);
  }

  void _onTick() {
    if (!mounted) return;
    if (o.status == OrderStatus.done) {
      OrderStore.tick.removeListener(_onTick);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderDoneScreen(order: o)));
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    OrderStore.tick.removeListener(_onTick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = o.progress;
    final minutes = math.max(1, ((1 - p) * 3).ceil());
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
          BrandHeader(subtitle: 'PESANAN DI PROSES', trailing: AvatarButton(onTap: () {})),
          Panel(
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.orangeSoft, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.ramen_dining, color: AppColors.orange, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Flexible(child: Text(o.item.name, overflow: TextOverflow.ellipsis, style: ts(13, w: FontWeight.w800))),
                    Text('  ${o.qty}x', style: ts(10, c: AppColors.muted)),
                  ]),
                  Text('Bay ${o.bay} • Pedas Sedang • Telur', style: ts(9, c: AppColors.muted)),
                ]),
              ),
              pill('Memasak', AppColors.orangeSoft, AppColors.brown),
            ]),
          ),
          const SizedBox(height: 12),
          Panel(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.orangeSoft, Colors.white]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.orangeSoft)),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('SLOT ${o.slot.replaceAll('#', '')}', style: ts(9, w: FontWeight.w800, c: AppColors.muted)),
                      const SizedBox(height: 6),
                      const Icon(Icons.microwave, color: AppColors.orange, size: 30),
                      const SizedBox(height: 6),
                      Text('85°C / 85°C', style: ts(10, w: FontWeight.w800, c: AppColors.brown)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              pill('SMART INDUCTION ACTIVE', AppColors.orangeSoft, AppColors.brown),
              const SizedBox(height: 8),
              Text('SEDANG DISIAPKAN', style: ts(18, w: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Mesin sedang menyiapkan hidangan Anda hingga mencapai suhu 85°C secara merata dan higienis.',
                  textAlign: TextAlign.center, style: ts(10, c: AppColors.muted, h: 1.4)),
              const SizedBox(height: 14),
              Row(children: [
                Text('Proses Persiapan', style: ts(10, w: FontWeight.w700, c: AppColors.muted)),
                const Spacer(),
                Text('${(p * 100).round()}%', style: ts(11, w: FontWeight.w800, c: AppColors.brown)),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(value: p, minHeight: 8, color: AppColors.orange, backgroundColor: AppColors.field),
              ),
              const SizedBox(height: 12),
              pill('Estimasi: ± $minutes Menit lagi', AppColors.field, AppColors.text, size: 10),
            ]),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              side: const BorderSide(color: AppColors.orangeSoft),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => popToHome(context),
            icon: const Icon(Icons.home_outlined, size: 16, color: AppColors.brown),
            label: Text('Kembali ke Menu Utama', style: ts(12, w: FontWeight.w800, c: AppColors.brown)),
          ),
        ]),
      ),
    );
  }
}
