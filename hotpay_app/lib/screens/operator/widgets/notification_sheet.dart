import 'package:flutter/material.dart';
import 'quick_restock_sheet.dart'; // Import sheet aksi cepat

class NotificationSheet extends StatelessWidget {
  const NotificationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Garis Handle atas
          Center(
            child: Container(
              width: 40, height: 4, 
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))
            )
          ),
          const SizedBox(height: 20),
          
          // Header Badge & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  children: [
                    Icon(Icons.circle, color: Colors.red, size: 8),
                    SizedBox(width: 6),
                    Text('PERINGATAN INVENTARIS KIOS', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(4), 
                  decoration: BoxDecoration(color: const Color(0xFFF3F4F6), shape: BoxShape.circle), 
                  child: const Icon(Icons.close, size: 16, color: Colors.black87)
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 16),
          
          // Judul Utama
          Row(
            children: [
              const Text('Stok Kritis!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(8)), 
                child: const Text('2 Slot Bermasalah', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold))
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Kios #VM001 • PT.Jaya Abadi, Mukakuning', style: TextStyle(color: Colors.black87, fontSize: 13)),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.black54), 
              SizedBox(width: 4), 
              Text('Terdeteksi: 11:28 WIB (2 menit lalu)', style: TextStyle(color: Colors.black54, fontSize: 12))
            ]
          ),
          const SizedBox(height: 24),
          
          // List Item Bermasalah
          _buildAlertItem('Mie Sagu', 'SLOT B2', 'HABIS (0 / 10)', true, 'assets/images/mie_sagu.jpeg', 0, 10),
          const SizedBox(height: 12),
          _buildAlertItem('Mie Tarempa Ori', 'SLOT A2', 'SISA 2 PORSI', false, 'assets/images/mie_tarempa.jpeg', 2, 12, alertText: 'Ambang alarm: ≤ 3 Porsi'),
          
          const SizedBox(height: 32),
          
          // Tombol Restok Cepat (Gradient Orange)
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFF7A00), Color(0xFFFF5C00)]),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFF6B00).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () {
                  Navigator.pop(context); // Menutup sheet notifikasi
                  // Membuka sheet Restok Cepat
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const QuickRestockSheet(),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Restok Cepat', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Tombol Tunda
          SizedBox(
            width: double.infinity,
            height: 54,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEEF0FF), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))
              ),
              icon: const Icon(Icons.snooze, color: Color(0xFF1E1E2C), size: 18),
              label: const Text('Tunda 15 Menit', style: TextStyle(color: Color(0xFF1E1E2C), fontSize: 14, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String title, String slot, String statusBadge, bool isHabis, String imgPath, int current, int max, {String alertText = ''}) {
    double progress = current / max;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F5), 
        borderRadius: BorderRadius.circular(20), 
        border: Border.all(color: const Color(0xFFFF6B00).withValues(alpha: 0.1))
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12), 
                    child: Image.asset(imgPath, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(width: 60, height: 60, color: Colors.grey.shade300))
                  ),
                  if (isHabis) 
                    Container(
                      width: 60, height: 60, 
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)), 
                      child: const Icon(Icons.block, color: Colors.white)
                    ),
                  if (!isHabis) 
                    Positioned(
                      top: 4, left: 4, 
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), 
                        decoration: BoxDecoration(color: const Color(0xFFFF6B00), borderRadius: BorderRadius.circular(4)), 
                        child: const Text('85°C', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))
                      )
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), 
                          decoration: BoxDecoration(color: const Color(0xFF2C3E50), borderRadius: BorderRadius.circular(6)), 
                          child: Text(slot, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                          decoration: BoxDecoration(color: isHabis ? const Color(0xFFD32F2F) : const Color(0xFFFF6B00), borderRadius: BorderRadius.circular(12)), 
                          child: Text(statusBadge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
                    if (alertText.isNotEmpty) Text(alertText, style: const TextStyle(color: Color(0xFFC75B00), fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            ],
          ),
          if (!isHabis) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sisa Kapasitas Baki', style: TextStyle(color: Colors.black54, fontSize: 12)),
                Text('${(progress * 100).toInt()}% ($current/$max)', style: const TextStyle(color: Color(0xFFC75B00), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress, 
                backgroundColor: const Color(0xFFFFE0B2), 
                valueColor: const AlwaysStoppedAnimation(Color(0xFFFF6B00)), 
                minHeight: 8
              ),
            )
          ]
        ],
      ),
    );
  }
}