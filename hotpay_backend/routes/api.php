<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;

// T10a: Menampilkan Katalog
Route::get('/products', function () {
    return DB::table('products')->get();
});

// T10b: Checkout
Route::post('/transactions', function () {
    DB::table('transactions')->insert([
        'order_code' => 'TRX-TEST-001',
        'machine_id' => 1,
        'total_amount' => 25000,
        'status' => 'pending',
        'expired_at' => now()->addMinutes(5)
    ]);
    return response()->json(['message' => 'Checkout berhasil, QRIS dibuat']);
});

// T10c: Callback Pembayaran
Route::post('/payments/callback', function () {
    DB::table('transactions')->where('order_code', 'TRX-TEST-001')->update(['status' => 'paid']);
    DB::table('payment_callbacks')->insert(['payload' => json_encode(['status' => 'settlement']), 'verification_status' => 'verified']);
    return response()->json(['message' => 'Pembayaran terverifikasi']);
});

// T10d: Operator ubah stok
Route::put('/machine-slots/{id}', function ($id) {
    DB::table('machine_slots')->where('slot_id', $id)->update(['stock_qty' => 10]);
    DB::table('stock_movements')->insert([
        'slot_id' => $id, 'movement_type' => 'restock', 'qty_change' => 10, 'stock_before' => 0, 'stock_after' => 10
    ]);
    return response()->json(['message' => 'Stok berhasil ditambah']);
});