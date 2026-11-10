namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class OperatorController extends Controller
{
    public function getAlerts()
    {
        // Menarik data slot yang stoknya <= ambang batas (low_stock_threshold)
        $alerts = DB::table('machine_slots')
            ->join('products', 'machine_slots.product_id', '=', 'products.product_id')
            ->whereColumn('machine_slots.stock_qty', '<=', 'machine_slots.low_stock_threshold')
            ->select('machine_slots.slot_id', 'machine_slots.slot_code', 'machine_slots.stock_qty', 'machine_slots.capacity', 'products.product_name', 'products.image_url')
            ->get();

        return response()->json(['status' => 'success', 'data' => $alerts]);
    }

    public function quickRestock(Request $request)
    {
        $request->validate([
            'slot_id' => 'required|integer',
            'added_qty' => 'required|integer|min:1'
        ]);

        DB::transaction(function () use ($request) {
            $slot = DB::table('machine_slots')->where('slot_id', $request->slot_id)->lockForUpdate()->first();
            
            $newStock = $slot->stock_qty + $request->added_qty;
            if ($newStock > $slot->capacity) {
                throw new \Exception("Stok melebihi kapasitas maksimal slot.");
            }

            DB::table('machine_slots')
                ->where('slot_id', $request->slot_id)
                ->update(['stock_qty' => $newStock]);

            // Pencatatan aktivitas di stock_movements
            DB::table('stock_movements')->insert([
                'slot_id' => $slot->slot_id,
                'movement_type' => 'restock',
                'qty_change' => $request->added_qty,
                'stock_before' => $slot->stock_qty,
                'stock_after' => $newStock,
                'note' => 'Restok Cepat Operator'
            ]);
        });

        return response()->json(['status' => 'success', 'message' => 'Restok berhasil diproses.']);
    }
}

// Menarik data profil operator dan kios yang terhubung
    public function getProfile(Request $request)
    {
        // Dalam implementasi nyata, data ini diambil dari $request->user() 
        // dan relasinya ke tabel 'machines' atau 'kiosks'.
        // Berikut adalah struktur respon JSON yang disesuaikan dengan UI Figma Anda:
        $profileData = [
            'id_operator' => '#OP-88219',
            'name' => 'Siti Rahmawati',
            'role' => 'Operator',
            'location' => 'Batam',
            'status' => 'ON DUTY',
            'avatar_url' => 'assets/images/profile.jpeg',
            'assigned_kiosks' => [
                [
                    'kiosk_id' => 'VM-01',
                    'location' => 'PT.Jaya abadi, Mukakuning',
                    'status' => 'Normal',
                    'temperature' => '84°C',
                    'capacity_current' => 25,
                    'capacity_max' => 60
                ]
            ]
        ];

        return response()->json([
            'status' => 'success',
            'data' => $profileData
        ]);
    }

    public function getInventory(Request $request)
    {
        // 1. Mengambil Rekapitulasi Statistik
        $totalVariants = DB::table('products')->where('is_active', 1)->count();
        $totalStock = DB::table('machine_slots')->sum('stock_qty');
        $maxStockCapacity = DB::table('machine_slots')->sum('capacity');
        
        $hampirHabis = DB::table('machine_slots')
            ->whereColumn('stock_qty', '<=', 'low_stock_threshold')
            ->where('stock_qty', '>', 0)->count();
            
        $habisKosong = DB::table('machine_slots')->where('stock_qty', 0)->count();

        // 2. Mengambil Daftar Katalog Aktif
        $catalog = DB::table('machine_slots')
            ->join('products', 'machine_slots.product_id', '=', 'products.product_id')
            ->select(
                'products.product_name', 'products.price', 'products.description', 'products.image_url',
                'machine_slots.slot_code', 'machine_slots.stock_qty', 'machine_slots.capacity',
                'machine_slots.temperature'
            )
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => [
                'stats' => [
                    'total_variants' => $totalVariants,
                    'total_stock' => $totalStock,
                    'max_stock' => $maxStockCapacity,
                    'almost_empty' => $hampirHabis,
                    'out_of_stock' => $habisKosong
                ],
                'catalog' => $catalog
            ]
        ]);
    }

    public function getRevenue(Request $request)
    {
        // 1. Data Ringkasan Pendapatan (Berdasarkan Transaksi 'paid')
        $todayRevenue = DB::table('transactions')->whereDate('created_at', today())->where('status', 'paid')->sum('total_amount');
        $weekRevenue = DB::table('transactions')->whereBetween('created_at', [now()->startOfWeek(), now()->endOfWeek()])->where('status', 'paid')->sum('total_amount');
        $monthRevenue = DB::table('transactions')->whereMonth('created_at', now()->month)->whereYear('created_at', now()->year)->where('status', 'paid')->sum('total_amount');

        // 2. Daftar Makanan Terlaris (Top 3)
        $topProducts = DB::table('transaction_items')
            ->join('transactions', 'transaction_items.transaction_id', '=', 'transactions.transaction_id')
            ->join('products', 'transaction_items.product_id', '=', 'products.product_id')
            ->where('transactions.status', 'paid')
            ->whereMonth('transactions.created_at', now()->month)
            ->select('products.product_name', 'products.price', 'products.image_url', DB::raw('SUM(transaction_items.quantity) as total_sold'), DB::raw('SUM(transaction_items.subtotal) as total_revenue'))
            ->groupBy('products.product_id', 'products.product_name', 'products.price', 'products.image_url')
            ->orderByDesc('total_revenue')
            ->take(3)->get();

        return response()->json([
            'status' => 'success',
            'data' => [
                'summary' => [
                    'today' => $todayRevenue,
                    'this_week' => $weekRevenue,
                    'this_month' => $monthRevenue
                ],
                'top_products' => $topProducts
            ]
        ]);
    }

    public function addProduct(Request $request)
    {
        $request->validate([
            'product_name' => 'required|string|max:40',
            'category' => 'required|string',
            'description' => 'nullable|string|max:150',
            'prep_time_sec' => 'required|integer',
            'portion_size' => 'required|string',
            'price' => 'required|numeric',
            'slot_id' => 'required|integer', // ID dari slot baki (A1, A2, dll)
            'target_temp' => 'required|integer', // 55, 68, atau 85
            'image' => 'nullable|image|mimes:jpeg,png|max:2048'
        ]);

        DB::transaction(function () use ($request) {
            // 1. Upload Gambar (Jika ada)
            $imageUrl = null;
            if ($request->hasFile('image')) {
                $path = $request->file('image')->store('public/products');
                $imageUrl = str_replace('public/', 'storage/', $path);
            }

            // 2. Simpan Produk Baru
            $productId = DB::table('products')->insertGetId([
                'product_name' => $request->product_name,
                'category' => $request->category,
                'description' => $request->description,
                'price' => $request->price,
                'image_url' => $imageUrl,
                'prep_time_sec' => $request->prep_time_sec,
                'portion_size' => $request->portion_size,
                'is_active' => $request->show_in_menu ?? true, // Toggle Tampilkan di Menu
                'created_at' => now(),
                'updated_at' => now()
            ]);

            // 3. Alokasikan ke Slot Baki Mesin
            // Update machine_slots yang dipilih agar terhubung dengan produk baru
            DB::table('machine_slots')->where('slot_id', $request->slot_id)->update([
                'product_id' => $productId,
                'temperature' => $request->target_temp,
                'stock_qty' => 0, // Awal tambah stok adalah 0, nanti di-restok
                // 'capacity' dan 'low_stock_threshold' dapat diupdate jika disertakan
            ]);
        });

        return response()->json(['status' => 'success', 'message' => 'Menu baru berhasil ditambahkan.']);
    }

    public function updateProduct(Request $request, $productId)
    {
        $request->validate([
            'product_name' => 'required|string|max:40',
            'category' => 'required|string',
            'description' => 'nullable|string|max:150',
            'price' => 'required|numeric',
            'slot_id' => 'required|integer', 
            'capacity' => 'required|integer',
            'low_stock_threshold' => 'required|integer',
            'target_temp' => 'required|integer', // 55, 68, atau 85
            'is_active' => 'required|boolean',
            'image' => 'nullable|image|mimes:jpeg,png|max:2048' // Opsional jika foto diganti
        ]);

        DB::transaction(function () use ($request, $productId) {
            // 1. Update Tabel Products
            $productData = [
                'product_name' => $request->product_name,
                'category' => $request->category,
                'description' => $request->description,
                'price' => $request->price,
                'is_active' => $request->is_active,
                'updated_at' => now()
            ];

            // Jika ada upload foto baru, simpan dan perbarui path-nya
            if ($request->hasFile('image')) {
                $path = $request->file('image')->store('public/products');
                $productData['image_url'] = str_replace('public/', 'storage/', $path);
            }

            DB::table('products')->where('product_id', $productId)->update($productData);

            // 2. Update Alokasi Slot Baki dan Suhu
            DB::table('machine_slots')->where('slot_id', $request->slot_id)->update([
                'product_id' => $productId, // Memastikan slot ini dialokasikan untuk produk ini
                'capacity' => $request->capacity,
                'low_stock_threshold' => $request->low_stock_threshold,
                'temperature' => $request->target_temp,
            ]);
        });

        return response()->json(['status' => 'success', 'message' => 'Menu dan Harga berhasil diperbarui.']);
    }

    public function quickRestock(Request $request)
    {
        // Validasi input dari Flutter
        $request->validate([
            'slot_id' => 'required|integer',
            'added_qty' => 'required|integer|min:1'
        ]);

        DB::transaction(function () use ($request) {
            // Gunakan lockForUpdate() agar data aman jika ada admin lain yang restok bersamaan
            $slot = DB::table('machine_slots')->where('slot_id', $request->slot_id)->lockForUpdate()->first();
            
            $newStock = $slot->stock_qty + $request->added_qty;
            
            // Validasi agar tidak melebihi kapasitas baki
            if ($newStock > $slot->capacity) {
                throw new \Exception("Gagal: Stok melebihi kapasitas maksimal slot.");
            }

            // Update stok di mesin
            DB::table('machine_slots')
                ->where('slot_id', $request->slot_id)
                ->update(['stock_qty' => $newStock, 'updated_at' => now()]);

            // Catat ke riwayat pergerakan stok
            DB::table('stock_movements')->insert([
                'slot_id' => $slot->slot_id,
                'movement_type' => 'restock',
                'qty_change' => $request->added_qty,
                'stock_before' => $slot->stock_qty,
                'stock_after' => $newStock,
                'note' => 'Restok Cepat dari Aplikasi Operator',
                'created_at' => now()
            ]);
        });

        return response()->json(['status' => 'success', 'message' => 'Restok berhasil diproses dan disinkronkan ke mesin.']);
    }