import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'revenue_screen.dart'; 
import 'widgets/notification_sheet.dart';
import 'profile_operator_screen.dart';
import 'widgets/quick_restock_sheet.dart'; 
import 'add_food_screen.dart'; 
import 'edit_food_screen.dart'; 

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF2F4FE), Color(0xFFF8F9FA)], stops: [0.0, 0.2]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ==========================================
              // 1. APP BAR
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
                          const Text('STOK MAKANAN', style: TextStyle(fontSize: 9, color: Colors.black54, letterSpacing: 1.2, fontWeight: FontWeight.w800)),
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
              // 2. KONTEN UTAMA
              // ==========================================
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Manajemen Stok', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                                  child: const Row(children: [Icon(Icons.circle, color: Color(0xFF00C853), size: 6), SizedBox(width: 4), Text('Live Sync', style: TextStyle(color: Color(0xFF00C853), fontSize: 9, fontWeight: FontWeight.bold))]),
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text('Monitoring porsi makanan hangat & riwayat slot vending', style: TextStyle(color: Colors.black54, fontSize: 12)),
                            const SizedBox(height: 24),
                            GridView.count(
                              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.6,
                              children: [
                                _buildStatCard('Total Varian', '6', ' Menu', Icons.restaurant, const Color(0xFFFFF3E0), const Color(0xFFD84315), Colors.white),
                                _buildStatCard('Total Stok', '45', ' / 75 porsi', Icons.inventory_2_outlined, const Color(0xFFE8EEFE), const Color(0xFF1E293B), Colors.white),
                                _buildStatCard('Hampir Habis', '2', ' Varian (<3)', Icons.warning_amber_rounded, const Color(0xFFFFF0E5), const Color(0xFFD84315), const Color(0xFFFFF9F5), isAlert: true),
                                _buildStatCard('Habis Kosong', '1', ' Slot Kosong', Icons.shopping_cart_outlined, const Color(0xFFFFEBEE), const Color(0xFFD32F2F), const Color(0xFFFFF5F5), isAlert: true, isDanger: true),
                              ],
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const AddFoodScreen(), transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return SlideTransition(position: animation.drive(Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut))), child: child);
                                }));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C3545), minimumSize: const Size(double.infinity, 54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_circle_outline, color: Colors.white, size: 20), SizedBox(width: 8), Text('+ Tambah Makanan Baru', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))]),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                const Text('Katalog Aktif', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                                const SizedBox(width: 8),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFE8EEFE), borderRadius: BorderRadius.circular(12)), child: const Text('6 Menu', style: TextStyle(color: Color(0xFF1E293B), fontSize: 10, fontWeight: FontWeight.bold)))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildInventoryItem(title: 'Mie Tarempa Seafood', price: 'Rp18.000', slot: 'SLOT A2', currentStock: 2, maxStock: 10, temp: '85°C', status: 'Stock terbatas', statusColor: const Color(0xFFD84315), desc: 'Mie sagu kenyal khas dengan kaldu gurih dan bumbu rempah.', imgPath: 'assets/images/mie_tarempa.jpeg', isRestockCepat: true),
                          _buildInventoryItem(title: 'Mie Sagu', price: 'Rp18.000', slot: 'SLOT A2', currentStock: 2, maxStock: 10, temp: '85°C', status: 'Stock terbatas', statusColor: const Color(0xFFD84315), desc: 'Mie sagu kenyal khas dengan kaldu gurih dan bumbu rempah.', imgPath: 'assets/images/mie_sagu.jpeg', isRestockCepat: true),
                          _buildInventoryItem(title: 'Mie Tarempa Ayam', price: 'Rp15.000', slot: 'SLOT B1', currentStock: 15, maxStock: 20, temp: '72°C', status: 'Tersedia', statusColor: const Color(0xFF00C853), desc: 'Roti dengan isian abon ikan atau Ayam', imgPath: 'assets/images/mie_tarempa.jpeg'),
                          _buildInventoryItem(title: 'Luti Gendang Ikan', price: 'Rp16.000', slot: 'SLOT B1', currentStock: 15, maxStock: 20, temp: '72°C', status: 'Tersedia', statusColor: const Color(0xFF00C853), desc: 'Roti dengan isian abon ikan atau Ayam', imgPath: 'assets/images/luti_gendang.jpeg'),
                          _buildInventoryItem(title: 'Luti Gendang Ayam', price: 'Rp10.000', slot: 'SLOT B1', currentStock: 15, maxStock: 20, temp: '72°C', status: 'Tersedia', statusColor: const Color(0xFF00C853), desc: 'Roti dengan isian abon ikan atau Ayam', imgPath: 'assets/images/luti_gendang.jpeg'),
                          _buildInventoryItem(title: 'Mie Tarempa Ori', price: 'Rp20.000', slot: 'SLOT B2', currentStock: 0, maxStock: 15, temp: '85°C', status: 'Habis', statusColor: const Color(0xFFD32F2F), desc: 'Mie kuning pipih bertekstur kenyal khas Kepulauan Riau', imgPath: 'assets/images/mie_tarempa.jpeg', isHabis: true),
                          const SizedBox(height: 80), 
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      // ==========================================
      // 3. BOTTOM NAVIGATION
      // ==========================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, 
        selectedItemColor: const Color(0xFFD84315),
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => const DashboardScreen(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero));
          } else if (index == 2) {
            Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => const RevenueScreen(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Stok'), 
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Pendapatan'),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildStatCard(String title, String value, String unit, IconData icon, Color iconBg, Color iconColor, Color cardBg, {bool isAlert = false, bool isDanger = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 10, color: isAlert ? (isDanger ? const Color(0xFFD32F2F) : const Color(0xFFD84315)) : Colors.black87, fontWeight: FontWeight.bold)),
              Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle), child: Icon(icon, size: 14, color: iconColor)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isAlert ? (isDanger ? const Color(0xFFD32F2F) : const Color(0xFFD84315)) : const Color(0xFF1E1E2C))),
              Text(unit, style: TextStyle(fontSize: 10, color: isAlert ? (isDanger ? const Color(0xFFD32F2F) : const Color(0xFFD84315)) : Colors.black54, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInventoryItem({required String title, required String price, required String slot, required int currentStock, required int maxStock, required String temp, required String status, required Color statusColor, required String desc, required String imgPath, bool isRestockCepat = false, bool isHabis = false}) {
    double progress = isHabis ? 0 : currentStock / maxStock;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(imgPath, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 80, height: 80, color: Colors.grey.shade200, child: const Icon(Icons.fastfood, color: Colors.grey)))),
                  if (isHabis) Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)), child: Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)), child: const Text('HABIS', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))))),
                  if (!isHabis) Positioned(bottom: 4, right: 4, child: Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: const Color(0x99000000), borderRadius: BorderRadius.circular(4)), child: Row(children: [const Icon(Icons.local_fire_department, color: Color(0xFFFF6B00), size: 10), const SizedBox(width: 2), Text(temp, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))]))),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C), height: 1.2))),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(Icons.circle, color: statusColor, size: 6), const SizedBox(width: 4), Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold))])),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF8D3B00))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFFFF0E5), borderRadius: BorderRadius.circular(6)), child: Text(slot, style: const TextStyle(color: Color(0xFFD84315), fontSize: 9, fontWeight: FontWeight.bold))),
                        const SizedBox(width: 8),
                        const Icon(Icons.circle, size: 4, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text('$currentStock dari $maxStock porsi', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isHabis ? const Color(0xFFD32F2F) : (isRestockCepat ? const Color(0xFFD84315) : Colors.black54))),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFFE8EEFE), valueColor: AlwaysStoppedAnimation(statusColor), minHeight: 6)),
          const SizedBox(height: 12),
          Text(desc, style: const TextStyle(color: Colors.black54, fontSize: 11, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    // Navigasi ke EditFoodScreen
                    Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const EditFoodScreen(), transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(position: animation.drive(Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut))), child: child);
                    }));
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF1E293B)),
                  label: const Text('Edit', style: TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(backgroundColor: const Color(0xFFEEF0FF), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Membuka Bottom Sheet Restok Cepat
                    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (c) => const QuickRestockSheet());
                  },
                  icon: Icon(isHabis ? Icons.inventory_2_outlined : (isRestockCepat ? Icons.bolt : Icons.dashboard_customize_outlined), size: 16, color: isHabis ? Colors.white : (isRestockCepat ? Colors.white : const Color(0xFF1E1E2C))),
                  label: Text(isHabis ? 'Isi Ulang' : (isRestockCepat ? 'Restock Cepat' : 'Restok'), style: TextStyle(color: isHabis ? Colors.white : (isRestockCepat ? Colors.white : const Color(0xFF1E1E2C)), fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: isHabis ? const Color(0xFF2C3545) : (isRestockCepat ? const Color(0xFFFF6B00) : const Color(0xFFFFE0B2)), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}