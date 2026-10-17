<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;

// T10a: Menampilkan Katalog
Route::get('/products', function () {
    return response()->json([
        'message' => 'Ini adalah data percobaan dari Closure API',
        'data' => []
    ]);
});

// T10b: Checkout
Route::post('/transactions', function () {
    return response()->json(['message' => 'Checkout berhasil, QRIS dibuat']);
});

// T10c: Callback Pembayaran
Route::post('/payments/callback', function () {
    return response()->json(['message' => 'Pembayaran terverifikasi']);
});

// T10d: Operator ubah stok
Route::put('/machine-slots/{id}', function ($id) {
    return response()->json(['message' => "Stok untuk slot $id berhasil ditambah"]);
});