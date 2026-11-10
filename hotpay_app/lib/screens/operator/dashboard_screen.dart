import 'package:flutter/material.dart';
import 'widgets/notification_sheet.dart'; 
import 'profile_operator_screen.dart'; 
import 'inventory_screen.dart'; 
import 'revenue_screen.dart'; // Tambahan Import Pendapatan

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTrend = 0; 
  
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFFF8F9FA),
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Image.asset('assets/images/logo.jpeg', height: 32, errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_fire_department, color: Colors.orange, size: 32)),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('HotPay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                        SizedBox(width: 4),
                        Icon(Icons.circle, color: Colors.green, size: 8),
                      ],
                    ),
                    Text('DASHBOARD OPERATOR', style: TextStyle(fontSize: 9, color: Colors.black54, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            actions: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Color(0xFFD84315), size: 28), 
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const NotificationSheet(),
                      );
                    }
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const ProfileOperatorScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: animation.drive(Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut))),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                  padding: EdgeInsets.only(right: 16.0, left: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF8D3B00),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              )
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Halo Siti! 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.storefront, size: 16, color: Colors.orange.shade800),
                              const SizedBox(width: 4),
                              const Text('Mitra Dapur Rasa • Mukakuning', style: TextStyle(color: Colors.black54, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
                        child: Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('Online', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildMachineStatusCard(),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard('Pendapatan Hari Ini', 'Rp450.000', Icons.payments, Colors.orange.shade50, Colors.orange.shade800),
                      _buildStatCard('Total Transaksi', '18 Trx', Icons.receipt_long, Colors.blue.shade50, Colors.blue.shade800),
                      _buildStatCard('Stok Tersisa', '25/60 Porsi', Icons.inventory_2, Colors.purple.shade50, Colors.purple.shade800),
                      _buildStatCard('Terlaris Hari ini', 'Mie Sagu', Icons.fastfood, Colors.green.shade50, Colors.green.shade800, subtitle: '/12 Porsi'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Color(0xFFE65100), size: 32),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('STOK MENIPIS   Slot A2', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFE65100))),
                              Text('Mie Sagu tersisa 2 porsi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3E2723), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                          child: const Text('Lihat Stok', style: TextStyle(color: Colors.white, fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSalesChartSection(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Makanan Terjual Hari Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                        child: const Text('6 Menu Aktif', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFoodItem('Mie Tarempa Ori', '10 porsi terjual • Slot A1', 'Rp250.000', 'assets/images/mie_tarempa.jpeg', true, 'Sisa 6 porsi'),
                  _buildFoodItem('Mie Sagu', '5 porsi terjual • Slot A2', 'Rp100.000', 'assets/images/mie_sagu.jpeg', false, 'Perlu Restok'),
                  _buildFoodItem('Luti Gendang Ikan', '3 porsi terjual • Slot B1', 'Rp45.000', 'assets/images/luti_gendang.jpeg', true, 'Sisa 7 porsi'),
                  const SizedBox(height: 80), 
                ],
              ),
            ),
          ),
        ],
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, 
        selectedItemColor: const Color(0xFFD84315),
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, anim1, anim2) => const InventoryScreen(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero));
          } else if (index == 2) {
            Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, anim1, anim2) => const RevenueScreen(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Stok'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Pendapatan'),
        ],
      ),
    );
  }

  // --- WIDGET HELPER BAWAH ---

  Widget _buildMachineStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), spreadRadius: 0, blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('Kios #VM001', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.greenAccent.shade100, borderRadius: BorderRadius.circular(8)), child: const Text('AKTIF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)))
                ],
              ),
              const Icon(Icons.sync, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 4),
          const Text('PT.Jaya Abadi, Mukakuning', style: TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMiniStatus(Icons.thermostat, 'SUHU RUANG', '85°C', 'Panas', Colors.orange.shade50, Colors.orange.shade800)),
              const SizedBox(width: 12),
              Expanded(child: _buildMiniStatus(Icons.wifi, 'JARINGAN', '99ms', 'Stabil', Colors.blue.shade50, Colors.blue.shade800)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Terakhir diperbarui: 2 menit lalu', style: TextStyle(fontSize: 10, color: Colors.black38)),
        ],
      ),
    );
  }

  Widget _buildMiniStatus(IconData icon, String title, String value, String sub, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: iconColor, size: 20)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black54)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  Text(sub, style: TextStyle(fontSize: 10, color: iconColor, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color bgColor, Color iconColor, {String subtitle = ''}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), spreadRadius: 0, blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold)),
              Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle), child: Icon(icon, size: 14, color: iconColor)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.black54)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSalesChartSection() {
    final currentData = _trendData[_selectedTrend]!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), spreadRadius: 0, blurRadius: 12, offset: const Offset(0, 4))]),
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
                        decoration: BoxDecoration(color: isLast ? const Color(0xFFFF6B00) : (isPeak ? const Color(0xFF1E293B) : Colors.blue.shade100), borderRadius: BorderRadius.circular(6)),
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

  Widget _buildFoodItem(String title, String sub, String price, String imgPath, bool isReady, String note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), spreadRadius: 0, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(imgPath, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(width: 60, height: 60, color: Colors.grey.shade300, child: const Icon(Icons.fastfood)))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(sub, style: const TextStyle(color: Colors.black54, fontSize: 10)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: isReady ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        children: [
                          Icon(isReady ? Icons.circle : Icons.warning_amber, size: 8, color: isReady ? Colors.green : Colors.red),
                          const SizedBox(width: 4),
                          Text(isReady ? 'Siap Saji' : 'Sisa 2 Porsi', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isReady ? Colors.green : Colors.red)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(note, style: TextStyle(fontSize: 9, color: isReady ? Colors.black54 : Colors.red, fontWeight: isReady ? FontWeight.normal : FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
        ],
      ),
    );
  }
}