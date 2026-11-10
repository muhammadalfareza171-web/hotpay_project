import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'revenue_screen.dart';
import 'widgets/notification_sheet.dart';
import 'profile_operator_screen.dart';

class EditFoodScreen extends StatefulWidget {
  const EditFoodScreen({super.key});

  @override
  State<EditFoodScreen> createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  // State tersinkronisasi (Dummy Data untuk form Edit Mie Sagu)
  String _selectedCategory = 'Makanan Berat';
  int _targetTemp = 85; 
  bool _isActive = true;
  String _selectedSlot = 'Slot A2 - Mie Sagu';
  int _capacity = 10;
  int _alertThreshold = 3;

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
            stops: [0.0, 0.1],
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
                      onPressed: () => Navigator.pop(context),
                    ),
                    Image.asset('assets/images/logo.jpeg', height: 32, errorBuilder: (c, e, s) => const Icon(Icons.local_fire_department, color: Colors.orange, size: 32)),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('HotPay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                              SizedBox(width: 4),
                              Icon(Icons.circle, color: Colors.green, size: 8),
                            ],
                          ),
                          Text('STOK MAKANAN', style: TextStyle(fontSize: 9, color: Colors.black54, letterSpacing: 1.2, fontWeight: FontWeight.w800)),
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
              // 2. Konten Form Scroll
              // ==========================================
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Judul
                      const Text('Edit Menu & Harga', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                      const SizedBox(height: 4),
                      const Text('Perbarui detail hidangan, harga jual, dan profil pemanasan kios #VM001', style: TextStyle(fontSize: 12, color: Colors.black54)),
                      const SizedBox(height: 24),

                      // --- HEADER PRODUK & TOGGLE AKTIF ---
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 5))]),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset('assets/images/mie_sagu.jpeg', width: 90, height: 90, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(width: 90, height: 90, color: Colors.grey.shade200))),
                                Container(width: 90, height: 90, decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(16))),
                                const Column(
                                  children: [
                                    Icon(Icons.camera_alt_outlined, color: Colors.white, size: 24),
                                    SizedBox(height: 4),
                                    Text('GANTI', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                )
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
                                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(8)), child: const Row(children: [Icon(Icons.grid_view_rounded, size: 12, color: Color(0xFF8D3B00)), SizedBox(width: 4), Text('Slot A2', style: TextStyle(color: Color(0xFF8D3B00), fontSize: 10, fontWeight: FontWeight.bold))])),
                                      const Row(children: [Icon(Icons.sensors, size: 12, color: Colors.green), SizedBox(width: 4), Text('2 Porsi Sisa', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold))]),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('Mie Sagu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Aktif di Katalog Kios', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
                                      SizedBox(
                                        height: 24,
                                        child: Switch(
                                          value: _isActive, 
                                          onChanged: (val) => setState(() => _isActive = val),
                                          activeThumbColor: Colors.white,
                                          activeTrackColor: const Color(0xFF00C853),
                                          inactiveThumbColor: Colors.grey.shade400,
                                          inactiveTrackColor: Colors.grey.shade200,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- BAGIAN 1: INFO DASAR ---
                      _buildSectionCard(
                        title: 'Bagian 1: Informasi Dasar Menu',
                        icon: Icons.fastfood_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelRow('Nama Menu Hidangan (Tampil di Kios)', false, ''),
                            _buildTextField('Mie Tarempa Nusantara'),
                            const SizedBox(height: 16),
                            _buildLabelRow('Kategori Mesin Penyajian', false, ''),
                            Row(
                              children: [
                                Expanded(child: _buildToggleBtn('Makanan Berat', Icons.bento_outlined, _selectedCategory == 'Makanan Berat')),
                                const SizedBox(width: 12),
                                Expanded(child: _buildToggleBtn('Camilan', Icons.bakery_dining_outlined, _selectedCategory == 'Camilan')),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildLabelRow('Deskripsi Singkat untuk Konsumen', false, '106/150'),
                            _buildTextField('Mie sagu kenyal khas kepulauan yang diolah dari pati sagu murni pilihan, disajikan dengan kaldu ayam kampung gurih berrempah aromatik, suwiran ayam empuk, telur rebus, dan taburan seledri serta bawang goreng renyah.', maxLines: 5),
                            const SizedBox(height: 16),
                            _buildLabelRow('Label Spesial Kios', false, ''),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFFFF0E5), borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(children: List.generate(5, (index) => const Icon(Icons.star, size: 12, color: Colors.orange))),
                                  const SizedBox(width: 6),
                                  const Text('4.9', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFD84315))),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- BAGIAN 2: SPESIFIKASI PENYAJIAN ---
                      _buildSectionCard(
                        title: 'Bagian 2: Spesifikasi Penyajian Otomatis Mesin Kios',
                        icon: Icons.precision_manufacturing_outlined,
                        child: GridView.count(
                          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.2,
                          children: [
                            _buildSpecBox(Icons.timer_outlined, 'Waktu Saji Otomatis', '< 3 Menit Otomatis', 'Proses cepat siap konsumsi'),
                            _buildSpecBox(Icons.soup_kitchen_outlined, 'Ukuran Porsi', '1 Mangkok (350g)', 'Porsi standar higienis'),
                            _buildSpecBox(Icons.sanitizer_outlined, 'Standar Kebersihan', 'Food Grade 100°C', 'Sterilisasi uap mesin'),
                            _buildSpecBox(Icons.local_fire_department_outlined, 'Garansi Panas', 'Saji Hangat 85°C', 'Suhu optimal saji instan'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- BAGIAN 3: HARGA JUAL ---
                      _buildSectionCard(
                        title: 'Bagian 3: Harga Jual',
                        icon: Icons.payments_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelRow('Harga Jual Kios (Rp)', false, ''),
                            _buildTextField('18000', prefix: 'Rp   '),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- BAGIAN 4: ALOKASI SLOT ---
                      _buildSectionCard(
                        title: 'Bagian 4: Alokasi Slot Baki & Pemanas',
                        icon: Icons.dns_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelRow('Slot Baki Internal Kiosk', false, ''),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedSlot,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                  items: ['Slot A2 - Mie Sagu', 'Slot A1', 'Slot B1'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                                  onChanged: (newValue) => setState(() => _selectedSlot = newValue!),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Kapasitas & Threshold (Dengan Plus Minus Interaktif)
                            Row(
                              children: [
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabelRow('Kapasitas Baki Maks', false, ''), _buildCounterBox(_capacity, (val) => setState(() => _capacity = val))])),
                                const SizedBox(width: 16),
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabelRow('Peringatan Restok', false, ''), _buildCounterBox(_alertThreshold, (val) => setState(() => _alertThreshold = val))])),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Kontrol Slider Suhu
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(children: [Icon(Icons.thermostat, color: Color(0xFFD84315), size: 18), SizedBox(width: 6), Text('Target Suhu Penyajian', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
                                Text('$_targetTemp°C Saji Panas', style: const TextStyle(color: Color(0xFFD84315), fontSize: 12, fontWeight: FontWeight.w900)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => setState(() => _targetTemp = 55),
                                    child: Column(
                                      children: [
                                        AnimatedContainer(duration: const Duration(milliseconds: 200), height: 12, decoration: BoxDecoration(color: _targetTemp >= 55 ? const Color(0xFFFF6B00) : const Color(0xFFF3F4F6), borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)))),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => setState(() => _targetTemp = 68),
                                    child: Column(
                                      children: [
                                        AnimatedContainer(duration: const Duration(milliseconds: 200), height: 12, decoration: BoxDecoration(color: _targetTemp >= 68 ? const Color(0xFFFF6B00) : const Color(0xFFF3F4F6))),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => setState(() => _targetTemp = 85),
                                    child: Column(
                                      children: [
                                        AnimatedContainer(duration: const Duration(milliseconds: 200), height: 12, decoration: BoxDecoration(color: _targetTemp == 85 ? const Color(0xFFFF6B00) : const Color(0xFFF3F4F6), borderRadius: const BorderRadius.only(topRight: Radius.circular(6), bottomRight: Radius.circular(6)))),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('55°C (Sedang)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
                                Text('68°C (Standar)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
                                Text('85°C (Panas Maks)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Info Durasi
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [Icon(Icons.timer_outlined, size: 14, color: Colors.black54), SizedBox(width: 6), Text('Durasi Pemanasan Dispenser:', style: TextStyle(fontSize: 11, color: Colors.black87))]),
                                Text('180 Detik (< 3 Menit)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [Icon(Icons.soup_kitchen_outlined, size: 14, color: Colors.black54), SizedBox(width: 6), Text('Ukuran Porsi Standar:', style: TextStyle(fontSize: 11, color: Colors.black87))]),
                                Text('1 Mangkok (350g)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // --- TOMBOL SUBMIT ---
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFFF7A00), Color(0xFFFF5C00)]),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [BoxShadow(color: const Color(0xFFFF6B00).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menu Berhasil Diperbarui!'), backgroundColor: Colors.green));
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text('Simpan & Perbarui Menu', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ==========================================
      // 3. Bottom Navigation Bar Terintegrasi
      // ==========================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, 
        selectedItemColor: const Color(0xFFD84315),
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => const DashboardScreen(), transitionDuration: Duration.zero), (route) => false);
          } else if (index == 1) {
            Navigator.pop(context); // Kembali ke list stok
          } else if (index == 2) {
            Navigator.pushAndRemoveUntil(context, PageRouteBuilder(pageBuilder: (c, a1, a2) => const RevenueScreen(), transitionDuration: Duration.zero), (route) => false);
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
  
  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF8D3B00), size: 22),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C)))),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildLabelRow(String text, bool isRequired, String suffix) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1E1E2C))),
              if (isRequired) const Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          if (suffix.isNotEmpty) Text(suffix, style: const TextStyle(fontSize: 10, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, {String? prefix, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
        prefixText: prefix,
        prefixStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildToggleBtn(String label, IconData icon, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _selectedCategory = label),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF7A00) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.black54),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecBox(IconData icon, String title, String value, String sub) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: const Color(0xFF8D3B00)),
              const SizedBox(width: 4),
              Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 9, color: Colors.black38)),
        ],
      ),
    );
  }

  Widget _buildCounterBox(int value, Function(int) onChanged) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => value > 0 ? onChanged(value - 1) : null,
            child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]), child: const Icon(Icons.remove, size: 16, color: Colors.black54)),
          ),
          Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          InkWell(
            onTap: () => onChanged(value + 1),
            child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFFF6B00), borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: const Color(0xFFFF6B00).withValues(alpha: 0.3), blurRadius: 4)]), child: const Icon(Icons.add, size: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}