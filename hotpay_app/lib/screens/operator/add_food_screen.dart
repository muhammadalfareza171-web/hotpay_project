import 'package:flutter/material.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  // State untuk form interaktif
  String _selectedCategory = 'Makanan Berat';
  int _targetTemp = 85; // Default Suhu Panas Maks
  bool _showInMenu = true;
  bool _autoAlert = true;
  String _selectedSlot = 'Slot Baki A1';

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
                    const Icon(Icons.notifications_outlined, color: Color(0xFFD84315), size: 28),
                    const SizedBox(width: 12),
                    const CircleAvatar(backgroundColor: Color(0xFF8D3B00), radius: 16, child: Icon(Icons.person, color: Colors.white, size: 18)),
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
                      Row(
                        children: [
                          const Icon(Icons.important_devices, size: 14, color: Color(0xFF8D3B00)),
                          const SizedBox(width: 4),
                          const Expanded(child: Text('Kios #VM001 • Modul Pemanas & Baki', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF8D3B00)))),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(8)), child: const Text('Mode Registrasi', style: TextStyle(color: Color(0xFFD84315), fontSize: 10, fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Tambah Makanan Baru', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                      const SizedBox(height: 24),

                      // --- BAGIAN FOTO ---
                      _buildSectionCard(
                        title: 'Foto Hidangan Kios',
                        icon: Icons.add_a_photo_outlined,
                        badge: 'Wajib Diisi',
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                          child: Column(
                            children: [
                              Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Color(0xFFE8EEFE), shape: BoxShape.circle), child: const Icon(Icons.image_outlined, size: 32, color: Color(0xFFD84315))),
                              const SizedBox(height: 16),
                              const Text('Unggah Foto Makanan Kios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                              const SizedBox(height: 4),
                              const Text('Format JPG/PNG rasio 1:1, min. 600x600 px.', style: TextStyle(fontSize: 11, color: Colors.black54)),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.upload_file, size: 16, color: Color(0xFF8D3B00)),
                                label: const Text('Pilih dari Galeri / Kamera', style: TextStyle(color: Color(0xFF8D3B00), fontSize: 12, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade300))),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- BAGIAN 1: INFO DASAR ---
                      _buildSectionCard(
                        stepNum: '1',
                        title: 'Informasi Dasar Menu',
                        subtitle: 'Langkah 1 dari 4',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelRow('Nama Menu Hidangan', true, 'Maks. 40 Karakter'),
                            _buildTextField('Contoh: Nasi Goreng Spesial Kios / Mie Ayam'),
                            const SizedBox(height: 16),
                            _buildLabelRow('Kategori Mesin Penyajian', true, ''),
                            Row(
                              children: [
                                Expanded(child: _buildToggleBtn('Makanan Berat', Icons.bento_outlined, _selectedCategory == 'Makanan Berat')),
                                const SizedBox(width: 12),
                                Expanded(child: _buildToggleBtn('Camilan', Icons.bakery_dining_outlined, _selectedCategory == 'Camilan')),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildLabelRow('Deskripsi Singkat untuk Konsumen', false, '0/150'),
                            _buildTextField('Jelaskan cita rasa makanan, bahan utama, dan keistimewaan hidangan....', maxLines: 3),
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
                        stepNum: '2',
                        title: 'Spesifikasi Penyajian Otomatis Mesin Kios',
                        subtitle: 'Langkah 2 dari 4',
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabelRow('Estimasi Waktu Saji', true, ''), _buildTextField('180', suffix: 'Detik')])),
                                const SizedBox(width: 16),
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabelRow('Ukuran Porsi Standar', true, ''), _buildTextField('1 Mangkok (350g)')])),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.verified, color: Colors.green, size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Jaminan Higienis & Suhu Terjaga', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
                                        Text('Menu dikemas kedap udara, dipanaskan otomatis tanpa sentuhan tangan manusia saat pemesanan.', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- BAGIAN 3: HARGA ---
                      _buildSectionCard(
                        stepNum: '3',
                        title: 'Harga & Margin Otomatis',
                        subtitle: 'Langkah 3 dari 4',
                        trailingIcon: Icons.payments,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelRow('Harga Jual Kios', true, ''),
                            _buildTextField('18000', prefix: 'Rp   '),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- BAGIAN 4: ALOKASI SLOT ---
                      _buildSectionCard(
                        stepNum: '4',
                        title: 'Alokasi Slot & Modul Pemanas',
                        subtitle: 'Langkah 4 dari 4',
                        trailingIcon: Icons.dns_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelRow('Slot Baki Internal Kiosk', true, ''),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedSlot,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                  items: ['Slot Baki A1', 'Slot Baki A2', 'Slot Baki B1', 'Slot Baki B2'].map((String value) {
                                    return DropdownMenuItem<String>(value: value, child: Text(value));
                                  }).toList(),
                                  onChanged: (newValue) => setState(() => _selectedSlot = newValue!),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabelRow('Kapasitas Baki', false, ''), _buildTextField('Contoh: 12 Pack')])),
                                const SizedBox(width: 16),
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabelRow('Ambang Restok Kritis', false, ''), _buildTextField('Contoh: 3 Pack')])),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            // ==========================================
                            // KONTROL SLIDER SUHU (TELAH DIPERBAIKI)
                            // ==========================================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(children: [Icon(Icons.thermostat, color: Color(0xFFD84315), size: 18), SizedBox(width: 6), Text('Target Suhu\nPenyajian', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFF0E5), borderRadius: BorderRadius.circular(12)), child: Text('$_targetTemp°C (${_targetTemp == 55 ? 'Sedang' : _targetTemp == 68 ? 'Standar' : 'Panas Maks'})', style: const TextStyle(color: Color(0xFFD84315), fontSize: 11, fontWeight: FontWeight.bold))),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Pembungkus utama untuk menyatukan baris warna dan teks agar keduanya bisa diklik
                            Row(
                              children: [
                                // Kolom 55°C
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => setState(() => _targetTemp = 55),
                                    child: Column(
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: _targetTemp >= 55 ? const Color(0xFFFF6B00) : const Color(0xFFF3F4F6), 
                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6))
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text('55°C (Sedang)', style: TextStyle(fontSize: 10, fontWeight: _targetTemp == 55 ? FontWeight.w900 : FontWeight.bold, color: _targetTemp == 55 ? const Color(0xFF1E1E2C) : Colors.black87), textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                ),
                                // Kolom 68°C (Tanpa spasi di antara baris warnanya agar menyatu lurus)
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => setState(() => _targetTemp = 68),
                                    child: Column(
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: _targetTemp >= 68 ? const Color(0xFFFF6B00) : const Color(0xFFF3F4F6)
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text('68°C (Standar)', style: TextStyle(fontSize: 10, fontWeight: _targetTemp == 68 ? FontWeight.w900 : FontWeight.bold, color: _targetTemp == 68 ? const Color(0xFF1E1E2C) : Colors.black87), textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                ),
                                // Kolom 85°C
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => setState(() => _targetTemp = 85),
                                    child: Column(
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: _targetTemp == 85 ? const Color(0xFFFF6B00) : const Color(0xFFF3F4F6), 
                                            borderRadius: const BorderRadius.only(topRight: Radius.circular(6), bottomRight: Radius.circular(6))
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text('85°C (Panas Maks)', style: TextStyle(fontSize: 10, fontWeight: _targetTemp == 85 ? FontWeight.w900 : FontWeight.bold, color: _targetTemp == 85 ? const Color(0xFF1E1E2C) : Colors.black87), textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                            // ==========================================
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- BAGIAN NOTIFIKASI & SWITCH ---
                      _buildSectionCard(
                        title: 'Ketersediaan & Notifikasi',
                        icon: Icons.visibility_outlined,
                        iconColor: const Color(0xFFD84315),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 16.0), 
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Tampilkan di Menu Konsumen', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
                                        SizedBox(height: 4),
                                        Text('Izinkan pelanggan memilih menu ini di layar sentuh kios', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                      ],
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _showInMenu, 
                                  onChanged: (val) => setState(() => _showInMenu = val), 
                                  activeThumbColor: const Color(0xFFFF6B00),
                                  activeTrackColor: const Color(0xFFFF6B00).withValues(alpha: 0.3),
                                  inactiveThumbColor: Colors.grey.shade400,
                                  inactiveTrackColor: Colors.grey.shade200,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 16.0), 
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Peringatan Stok Menipis Otomatis', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
                                        SizedBox(height: 4),
                                        Text('Kirim peringatan jika tersisa <3 porsi', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                      ],
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _autoAlert, 
                                  onChanged: (val) => setState(() => _autoAlert = val), 
                                  activeThumbColor: const Color(0xFFFF6B00),
                                  activeTrackColor: const Color(0xFFFF6B00).withValues(alpha: 0.3),
                                  inactiveThumbColor: Colors.grey.shade400,
                                  inactiveTrackColor: Colors.grey.shade200,
                                ),
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
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menu Baru Berhasil Diaktifkan di Kios!'), backgroundColor: Colors.green));
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Simpan & Aktifkan Menu di Kios', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.orange.shade200), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
                          child: const Text('Simpan Sebagai Draf', style: TextStyle(color: Color(0xFFD84315), fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batalkan Perubahan', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)))),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER KHUSUS FORM ---
  
  Widget _buildSectionCard({String? stepNum, IconData? icon, Color? iconColor, String? title, String? subtitle, String? badge, IconData? trailingIcon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (stepNum != null) Container(width: 24, height: 24, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xFF8D3B00), shape: BoxShape.circle), child: Text(stepNum, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
              if (icon != null) Icon(icon, color: iconColor ?? const Color(0xFF8D3B00), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                  ],
                ),
              ),
              if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
              if (badge != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFF0E5), borderRadius: BorderRadius.circular(8)), child: Text(badge, style: const TextStyle(color: Color(0xFFD84315), fontSize: 9, fontWeight: FontWeight.bold))),
              if (trailingIcon != null) Icon(trailingIcon, color: const Color(0xFF8D3B00), size: 20),
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
              Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1E2C))),
              if (isRequired) const Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          if (suffix.isNotEmpty) Text(suffix, style: const TextStyle(fontSize: 10, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, {String? prefix, String? suffix, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
        prefixText: prefix,
        prefixStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
        suffixText: suffix,
        suffixStyle: const TextStyle(color: Color(0xFFD84315), fontWeight: FontWeight.bold, fontSize: 12),
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF6B00), width: 1.5)),
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
          color: isSelected ? const Color(0xFFE8EEFE) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blue.shade200 : Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? const Color(0xFFD84315) : Colors.black54),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF1E1E2C) : Colors.black87)),
          ],
        ),
      ),
    );
  }
}