import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'inventory_screen.dart';
import 'widgets/notification_sheet.dart';
import 'profile_operator_screen.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  int _selectedTrend = 0; // 0: Hari, 1: Minggu, 2: Bulan
  String _selectedExportPeriod = 'Hari Ini';
  
  // Data Grafik (Menyesuaikan dengan Figma & Video)
  final Map<int, Map<String, dynamic>> _trendData = {
    0: { 
      'title': 'Harian (Bulan Oktober)',
      'avg': 'Rp470.000/hari',
      'target': 'Rp550.000',
      'labels': ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
      'values': [0.5, 0.6, 0.4, 0.7, 0.6, 1.0, 0.8], 
      'peak': 'Sabtu (Rp610k)',
      'current': 'Rp450k',
    },
    1: { 
      'title': 'Bulan Oktober 2026',
      'avg': 'Rp2.95jt/mgg',
      'target': 'Rp3.50jt',
      'labels': ['Mgg 1', 'Mgg 2', 'Mgg 3', 'Mgg 4'],
      'values': [0.7, 0.85, 1.0, 0.95],
      'peak': 'Mgg 3 (Rp3.4jt)',
      'current': 'Rp3.1jt',
    },
    2: { 
      'title': 'Tahun 2026',
      'avg': 'Rp11.2 jt/bln',
      'target': 'Rp13.5jt',
      'labels': ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun'],
      'values': [0.7, 0.75, 0.85, 0.8, 1.0, 0.95],
      'peak': 'Mei (Rp13.2jt)',
      'current': 'Rp12.85 jt',
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF2F4FE), Color(0xFFF8F9FA)],
            stops: [0.0, 0.15],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ==========================================
              // 1. App Bar
              // ==========================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
                      onPressed: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => const DashboardScreen(), transitionDuration: Duration.zero)),
                    ),
                    Image.asset('assets/images/logo.jpeg', height: 32, errorBuilder: (c, e, s) => const Icon(Icons.local_fire_department, color: Colors.orange, size: 32)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('HotPay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                              const SizedBox(width: 4),
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF00C853), shape: BoxShape.circle)),
                            ],
                          ),
                          const Text('PENDAPATAN', style: TextStyle(fontSize: 9, color: Colors.black54, letterSpacing: 1.2, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Color(0xFFD84315), size: 28),
                      onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (c) => const NotificationSheet()),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => const ProfileOperatorScreen(), transitionsBuilder: (c, anim, a2, child) => SlideTransition(position: anim.drive(Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut))), child: child))),
                      child: const CircleAvatar(backgroundColor: Color(0xFF8D3B00), radius: 16, child: Icon(Icons.person, color: Colors.white, size: 18)),
                    ),
                  ],
                ),
              ),

              // ==========================================
              // 2. Konten Scroll
              // ==========================================
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- HEADER & SINKRONISASI ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                            child: const Row(
                              children: [
                                Icon(Icons.circle, color: Color(0xFF00C853), size: 6),
                                SizedBox(width: 6),
                                Text('SINKRONISASI REAL-TIME', style: TextStyle(color: Color(0xFF00C853), fontSize: 9, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.access_time, color: Color(0xFF8D3B00), size: 14),
                              SizedBox(width: 4),
                              Text('Update: 10:20 WIB', style: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Laporan Pendapatan', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Icon(Icons.storefront, size: 16, color: Color(0xFF8D3B00)),
                          SizedBox(width: 6),
                          Text('Penjualan #VM001', style: TextStyle(color: Colors.black54, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // --- KARTU PENDAPATAN HARI INI ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, Color(0xFFFFF6EE)]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 6))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.payments_outlined, color: Color(0xFFD84315), size: 20),
                                SizedBox(width: 8),
                                Text('Pendapatan Hari Ini', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8D3B00))),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text('Rp450.000', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- KARTU MINGGU & BULAN ---
                      Row(
                        children: [
                          Expanded(child: _buildSubRevenueCard('Minggu Ini', 'Rp2.100.000', Icons.date_range_outlined)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildSubRevenueCard('Bulan Ini', 'Rp8.450.000', Icons.calendar_month_outlined)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // --- GRAFIK TREN PENJUALAN ---
                      _buildSalesChartSection(),
                      const SizedBox(height: 32),

                      // --- DAFTAR MAKANAN TERLARIS ---
                      const Text('Makanan Terlaris Bulan Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                      const SizedBox(height: 4),
                      const Text('Berdasarkan total volume penjualan September', style: TextStyle(color: Colors.black54, fontSize: 11)),
                      const SizedBox(height: 16),
                      
                      _buildTopProductItem('Mie Tarempa Ori', '25 porsi • Rp20.000/porsi', 'Rp500.000', 0.45, '45% total', 'assets/images/mie_tarempa.jpeg'),
                      _buildTopProductItem('Mie Sagu', '18 porsi • Rp18.000/porsi', 'Rp324.000', 0.30, '30% total', 'assets/images/mie_sagu.jpeg'),
                      _buildTopProductItem('Luti Gendang Ikan', '14 porsi • Rp15.000/porsi', 'Rp210.000', 0.18, '18% total', 'assets/images/luti_gendang.jpeg', progressColor: Colors.green),
                      const SizedBox(height: 32),

                      // --- KOTAK EKSPOR EXCEL ---
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 6))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(Icons.calculate_outlined, color: Color(0xFF2E7D32)),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Export Laporan ke Excel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                                      SizedBox(height: 4),
                                      Text('Format berkas .xlsx atau .csv sertifikasi pembukuan lengkap', style: TextStyle(fontSize: 10, color: Colors.black54)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text('PILIHAN PERIODE EKSPOR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8D3B00), letterSpacing: 0.5)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: _buildExportPeriodButton('Hari Ini')),
                                const SizedBox(width: 12),
                                Expanded(child: _buildExportPeriodButton('Minggu Ini')),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: _buildExportPeriodButton('Bulan Ini')),
                                const SizedBox(width: 12),
                                Expanded(child: _buildExportPeriodButton('Tahun Ini')),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Tombol Download Gradient
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mengunduh Laporan Periode $_selectedExportPeriod...'), backgroundColor: const Color(0xFFD84315)));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B00),
                                minimumSize: const Size(double.infinity, 54),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.download_rounded, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text('Download File Excel Sekarang', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // ==========================================
      // 3. Bottom Navigation Bar
      // ==========================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // 2 Menandakan Tab "Pendapatan" aktif
        selectedItemColor: const Color(0xFFD84315),
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => const DashboardScreen(), transitionDuration: Duration.zero));
          } else if (index == 1) {
            Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => const InventoryScreen(), transitionDuration: Duration.zero));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Stok'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Pendapatan'),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildSubRevenueCard(String title, String amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFD84315), size: 16),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF8D3B00))),
            ],
          ),
          const SizedBox(height: 8),
          Text(amount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
        ],
      ),
    );
  }

  Widget _buildTopProductItem(String title, String sub, String revenue, double progress, String percentage, String imgPath, {Color progressColor = const Color(0xFFFF6B00)}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(imgPath, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(width: 60, height: 60, color: Colors.grey.shade200))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    Text(revenue, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(sub, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                    Text(percentage, style: TextStyle(color: progressColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFFE8EEFE), valueColor: AlwaysStoppedAnimation(progressColor), minHeight: 4),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExportPeriodButton(String label) {
    bool isSelected = _selectedExportPeriod == label;
    return InkWell(
      onTap: () => setState(() => _selectedExportPeriod = label),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE0B2) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFFFF6B00) : Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.calendar_today_outlined, size: 16, color: isSelected ? const Color(0xFFD84315) : Colors.black54),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFFD84315) : Colors.black87)),
          ],
        ),
      ),
    );
  }

  // --- WIDGET CHART (Sama persis dengan animasi di Dashboard) ---
  Widget _buildSalesChartSection() {
    final currentData = _trendData[_selectedTrend]!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 6))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tren Penjualan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: Text(currentData['title'], key: ValueKey(currentData['title']), style: const TextStyle(fontSize: 11, color: Colors.black54))),
                ],
              ),
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    _buildTrendTab('Hari', 0),
                    _buildTrendTab('Minggu', 1),
                    _buildTrendTab('Bulan', 2),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: Text('Rata-rata: ${currentData['avg']}', key: ValueKey(currentData['avg']), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
              AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: Text('Target: ${currentData['target']}', key: ValueKey(currentData['target']), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
              child: Row(
                key: ValueKey(_selectedTrend),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate((currentData['labels'] as List).length, (index) {
                  final labels = currentData['labels'] as List<String>;
                  final values = currentData['values'] as List<double>;
                  final isLast = index == labels.length - 1;
                  final isPeak = index == labels.length - 2; 
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if(isLast) Text(currentData['current'].split(' ').first, style: const TextStyle(fontSize: 10, color: Color(0xFFD84315), fontWeight: FontWeight.bold)),
                      if(isPeak && _selectedTrend == 0) const Text('610k', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)), 
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        width: 30,
                        height: 100 * values[index], 
                        decoration: BoxDecoration(color: isLast ? const Color(0xFFFF6B00) : (isPeak ? const Color(0xFF1E293B) : const Color(0xFFD6E4FF)), borderRadius: BorderRadius.circular(6)),
                      ),
                      const SizedBox(height: 8),
                      Text(labels[index], style: TextStyle(fontSize: 10, fontWeight: isLast ? FontWeight.bold : FontWeight.normal, color: isLast ? const Color(0xFFFF6B00) : Colors.black54)),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Row(
              key: ValueKey(_selectedTrend),
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(children: [const Icon(Icons.circle, size: 10, color: Color(0xFF1E293B)), const SizedBox(width: 4), Text('Puncak: ${currentData['peak']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]),
                Row(children: [const Icon(Icons.circle, size: 10, color: Color(0xFFFF6B00)), const SizedBox(width: 4), Text('${_selectedTrend==0?'Hari':'Mgg/Bln'} ini: ${currentData['current']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD84315)))]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTrendTab(String title, int index) {
    bool isSelected = _selectedTrend == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTrend = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: isSelected ? const Color(0xFF1E293B) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
        child: Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black54)),
      ),
    );
  }
}