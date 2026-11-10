import 'package:flutter/material.dart';

class ProfileOperatorScreen extends StatelessWidget {
  const ProfileOperatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Container(
        // Gradient background biru lembut ke putih seperti di Figma
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF2F4FE), Color(0xFFF8F9FA)],
            stops: [0.0, 0.3],
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
                          const Text('PROFILE OPERATOR', style: TextStyle(fontSize: 9, color: Colors.black54, letterSpacing: 1.2, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    const Icon(Icons.notifications_outlined, color: Color(0xFFD84315), size: 28),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                      backgroundColor: Color(0xFF8D3B00),
                      radius: 16,
                      child: Icon(Icons.person, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ),

              // ==========================================
              // 2. Konten Utama
              // ==========================================
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- KARTU PROFIL UTAMA ---
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Color(0xFFFFF6EE)], // Gradien putih ke krem/orange lembut
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 5))],
                        ),
                        child: Row(
                          children: [
                            // Avatar dengan indikator online
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 70, height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                                    image: const DecorationImage(
                                      // Ganti dengan foto asli jika ada
                                      image: AssetImage('assets/images/profile_siti.jpeg'), 
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Fallback icon jika image tidak ditemukan
                                  child: const Icon(Icons.person, color: Colors.transparent), 
                                ),
                                Container(
                                  width: 18, height: 18,
                                  decoration: BoxDecoration(color: const Color(0xFF00C853), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                                )
                              ],
                            ),
                            const SizedBox(width: 16),
                            // Info Profil
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(color: const Color(0xFF69FFA0), borderRadius: BorderRadius.circular(20)),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.circle, color: Color(0xFF008940), size: 6),
                                            SizedBox(width: 4),
                                            Text('ON DUTY', style: TextStyle(color: Color(0xFF008940), fontSize: 9, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('ID #OP-88219', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  const Text('Siti Rahmawati', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                                  const Text('Operator', style: TextStyle(color: Colors.black54, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  const Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF8D3B00)),
                                      SizedBox(width: 4),
                                      Text('Batam', style: TextStyle(color: Color(0xFF8D3B00), fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // --- PERANGKAT & KIOS TERHUBUNG ---
                      const Text('Perangkat & Kios Terhubung', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFFE8EEFE), borderRadius: BorderRadius.circular(6)),
                                  child: const Text('VM-01', style: TextStyle(color: Color(0xFF1E293B), fontSize: 11, fontWeight: FontWeight.w900)),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(child: Text('PT.Jaya abadi, Mukakuning', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E1E2C)))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFF69FFA0), borderRadius: BorderRadius.circular(12)),
                                  child: const Text('Normal', style: TextStyle(color: Color(0xFF008940), fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [const Icon(Icons.thermostat, color: Color(0xFFD84315), size: 16), const SizedBox(width: 6), Text('Suhu: 84°C', style: TextStyle(fontSize: 12, color: Colors.grey.shade800))]),
                                  Row(children: [const Icon(Icons.inventory_2_outlined, color: Color(0xFFD84315), size: 16), const SizedBox(width: 6), Text('Kapasitas: 25/60', style: TextStyle(fontSize: 12, color: Colors.grey.shade800))]),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // --- ALAT & MANAJEMEN OPERATOR ---
                      const Text('Alat & Manajemen Operator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          children: [
                            _buildListMenu(
                              icon: Icons.assignment_outlined,
                              iconColor: const Color(0xFFD84315),
                              iconBg: const Color(0xFFFFF0E5),
                              title: 'Form Edit & Tambah Menu',
                              subtitle: 'Edit dan tambah menu baru',
                              onTap: () {},
                            ),
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6))),
                            _buildListMenu(
                              icon: Icons.receipt_long_outlined,
                              iconColor: const Color(0xFF1E293B),
                              iconBg: const Color(0xFFE8EEFE),
                              title: 'Laporan Pendapatan',
                              subtitle: 'pembayaran QRIS & status dispense gagal',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // --- TOMBOL LOGOUT ---
                      ElevatedButton(
                        onPressed: () {
                          // Aksi Keluar Akun
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFEBEE), // Background merah muda
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded, color: Color(0xFF9B0000), size: 20), // Ikon merah tua
                            SizedBox(width: 8),
                            Text('Keluar dari Akun', style: TextStyle(color: Color(0xFF9B0000), fontSize: 16, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      // --- FOOTER INFO ---
                      const Center(
                        child: Column(
                          children: [
                            Text('HotPay Operator • v1.0 (Operator Edition)', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Enkripsi Hardware AES-256 Terhubung', style: TextStyle(color: Color(0xFF8D3B00), fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
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

  // Widget Helper untuk List Menu (Alat & Manajemen)
  Widget _buildListMenu({
    required IconData icon, 
    required Color iconColor, 
    required Color iconBg, 
    required String title, 
    required String subtitle, 
    required VoidCallback onTap
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}