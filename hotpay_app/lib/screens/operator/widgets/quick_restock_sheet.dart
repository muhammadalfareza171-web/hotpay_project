import 'package:flutter/material.dart';

class QuickRestockSheet extends StatelessWidget {
  const QuickRestockSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy Tersinkronisasi (Bisa disesuaikan dengan API nantinya)
    int currentStock = 2;
    int maxStock = 12;
    int addedStock = 8; // Default rekomendasi sistem (2 + 8 = 10 porsi)

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        int totalAfterRestock = currentStock + addedStock;

        return Container(
          margin: const EdgeInsets.only(top: 60),
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.vertical(top: Radius.circular(32))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))
              ),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, color: Color(0xFF8D3B00), size: 8),
                        SizedBox(width: 6),
                        Text('AKSI OPERATOR KIOS • #VM001', style: TextStyle(color: Color(0xFF8D3B00), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), shape: BoxShape.circle), child: const Icon(Icons.close, size: 16)),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 8),
              const Text('Aksi Cepat Slot & Restok Makanan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C), height: 1.2)),
              const SizedBox(height: 4),
              const Text('Pilih tindakan cepat untuk pengisian porsi atau perubahan konfigurasi slot baki.', style: TextStyle(color: Colors.black54, fontSize: 12)),
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/images/mie_sagu.jpeg', width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(width: 60, height: 60, color: Colors.grey.shade300))),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF8D3B00), borderRadius: BorderRadius.circular(6)), child: const Text('SLOT A2', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
                              const SizedBox(width: 6),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(6)), child: const Text('Menipis', style: TextStyle(color: Color(0xFFD32F2F), fontSize: 9, fontWeight: FontWeight.bold))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text('Mie Sagu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C))),
                          RichText(text: TextSpan(style: const TextStyle(fontSize: 11, color: Colors.black54), children: [const TextSpan(text: 'Tersisa '), TextSpan(text: '$currentStock', style: const TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.bold)), TextSpan(text: ' dari $maxStock Porsi')])),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                      child: const Column(
                        children: [
                          Row(children: [Icon(Icons.local_fire_department, color: Color(0xFFD84315), size: 14), SizedBox(width: 4), Text('85°C', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8D3B00)))]),
                          Text('Pemanas Aktif', style: TextStyle(fontSize: 8, color: Colors.black38)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Jumlah Tambah Porsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E1E2C))),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)), child: Text('Slot Max $maxStock', style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 10, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCounterButton(Icons.remove, () { if (addedStock > 0) setState(() => addedStock--); }, false),
                  
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    child: Column(
                      key: ValueKey(addedStock),
                      children: [
                        Text('$addedStock', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFFB73B00))),
                        const Text('Porsi Tambahan', style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  
                  _buildCounterButton(Icons.add, () { if (currentStock + addedStock < maxStock) setState(() => addedStock++); }, true),
                ],
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: _buildPresetButton('+2 Porsi', () => setState(() => addedStock = (currentStock + 2 <= maxStock) ? 2 : maxStock - currentStock), addedStock == 2)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildPresetButton('+4 Porsi', () => setState(() => addedStock = (currentStock + 4 <= maxStock) ? 4 : maxStock - currentStock), addedStock == 4)),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _buildPresetButton('+${maxStock - currentStock} (Isi Penuh 100%)', () => setState(() => addedStock = maxStock - currentStock), addedStock == (maxStock - currentStock))),
                ],
              ),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kapasitas Slot Setelah\nRestok', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text('$totalAfterRestock / $maxStock Porsi', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    if (currentStock > 0) Expanded(flex: currentStock, child: Container(height: 14, color: const Color(0xFFC78D71))), 
                    if (addedStock > 0) Expanded(flex: addedStock, child: AnimatedContainer(duration: const Duration(milliseconds: 300), height: 14, color: const Color(0xFFFF7A00))), 
                    if (maxStock - totalAfterRestock > 0) Expanded(flex: maxStock - totalAfterRestock, child: AnimatedContainer(duration: const Duration(milliseconds: 300), height: 14, color: const Color(0xFFF3F4F6))), 
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$currentStock Porsi Eksisting', style: const TextStyle(fontSize: 10, color: Colors.black54)),
                  Text('+$addedStock Porsi Baru', style: const TextStyle(fontSize: 10, color: Color(0xFFB73B00), fontWeight: FontWeight.bold)),
                ],
              ),
              
              const SizedBox(height: 32),
              
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(color: const Color(0xFFB73B00), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: const Color(0xFFB73B00).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))]),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.pop(context); // Tutup sheet
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil menambah $addedStock porsi ke Slot A2!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
                    },
                    child: const Center(
                      child: Text('Konfirmasi Restok', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap, bool isAdd) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: isAdd ? const Color(0xFFFF6B00) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: isAdd ? Colors.transparent : Colors.grey.shade300)),
        child: Icon(icon, color: isAdd ? Colors.white : Colors.black87),
      ),
    );
  }

  Widget _buildPresetButton(String label, VoidCallback onTap, bool isSelected) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: isSelected ? const Color(0xFFFFE0B2) : const Color(0xFFF4F5F7), borderRadius: BorderRadius.circular(12)),
        child: Center(child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF8D3B00) : Colors.black87))),
      ),
    );
  }
}