import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';

class HelpScreen extends StatelessWidget {
  /// Nomor pesanan untuk draf pesan otomatis (opsional).
  final String? orderNo;
  const HelpScreen({super.key, this.orderNo});

  Widget _channel(IconData i, String title, String value) => Expanded(
        child: Panel(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: AppColors.orangeSoft, borderRadius: BorderRadius.circular(10)),
              child: Icon(i, size: 16, color: AppColors.orange),
            ),
            const SizedBox(height: 8),
            Text(title, style: ts(10, w: FontWeight.w800)),
            Text(value, style: ts(10, w: FontWeight.w700, c: AppColors.brown)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final ref = orderNo ?? 'SB-98284';
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
          BrandHeader(showBack: true, subtitle: 'BANTUAN', trailing: AvatarButton(onTap: () {})),
          Align(alignment: Alignment.centerLeft, child: pill('LAYANAN DARURAT KIOS', AppColors.orangeSoft, AppColors.brown)),
          const SizedBox(height: 8),
          Text('Ada Kendala Saat Mengambil Makanan?', style: ts(22, w: FontWeight.w800, h: 1.2)),
          const SizedBox(height: 4),
          Text('Tim operasional HotPay siap merespons langsung.', style: ts(12, c: AppColors.muted)),
          const SizedBox(height: 14),
          Panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.circle, size: 8, color: AppColors.green),
                const SizedBox(width: 6),
                Text('Operator Lapangan Online', style: ts(11, w: FontWeight.w800, c: AppColors.green)),
                const Spacer(),
                pill('ID #OP-88219', AppColors.field, AppColors.muted),
              ]),
              const SizedBox(height: 10),
              Center(
                child: ClipOval(
                  child: Image.asset('assets/images/operator.jpg', width: 180, height: 180, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                            width: 180,
                            height: 180,
                            color: AppColors.orangeSoft,
                            child: const Icon(Icons.support_agent, size: 72, color: AppColors.orange),
                          )),
                ),
              ),
              const SizedBox(height: 10),
              Text('Kirim pesan instan dengan ID mesin, ID pesanan, dan detail kompartemen untuk penanganan langsung.',
                  style: ts(11, c: AppColors.muted, h: 1.4)),
              const SizedBox(height: 10),
              Panel(
                color: AppColors.field,
                padding: const EdgeInsets.all(10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text('Draf Pesan Otomatis:', style: ts(9, w: FontWeight.w800, c: AppColors.muted)),
                    const Spacer(),
                    Text('Siap Kirim', style: ts(9, w: FontWeight.w800, c: AppColors.orange)),
                  ]),
                  const SizedBox(height: 4),
                  Text('"Halo Operator HotPay, saya mengalami kendala dispenser di Kios VM-01 Bay A-02 untuk Order #$ref..."',
                      style: ts(10, c: AppColors.text, h: 1.4)),
                ]),
              ),
              const SizedBox(height: 10),
              // TODO: buka WhatsApp dengan paket url_launcher (wa.me/<nomor>?text=...).
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: const Size.fromHeight(46),
                  backgroundColor: AppColors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => comingSoon(context, 'Hubungkan ke WhatsApp dengan url_launcher'),
                icon: const Icon(Icons.chat, size: 16, color: Colors.white),
                label: Text('Chat WhatsApp Operator (Respon < 2 Mnt)', style: ts(12, w: FontWeight.w800, c: Colors.white)),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Text('Kanal Bantuan Tambahan', style: ts(12, w: FontWeight.w800)),
          const SizedBox(height: 8),
          Row(children: [
            _channel(Icons.phone, 'Bebas Pulsa 24 Jam', '0812-xxxx-xxxx'),
            const SizedBox(width: 10),
            _channel(Icons.alternate_email, 'Email Dukungan', 'support@hotpay.id'),
          ]),
        ]),
      ),
    );
  }
}
