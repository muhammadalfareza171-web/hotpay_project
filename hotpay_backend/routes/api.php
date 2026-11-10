<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\OperatorController;

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

Route::prefix('v1')->group(function () {
    // Route sebelumnya (splash)
    Route::post('/auth/login', [AuthController::class, 'login']);
    Route::post('/auth/register', [AuthController::class, 'register']);
});

// Rute Dashboard Operator HotPay
Route::get('/dashboard/operator', [DashboardController::class, 'getOperatorStats']);

Route::prefix('operator')->group(function () {
    Route::get('/alerts', [OperatorController::class, 'getAlerts']);
    Route::post('/restock', [OperatorController::class, 'quickRestock']);
});

Route::prefix('operator')->group(function () {
    Route::get('/alerts', [OperatorController::class, 'getAlerts']);
    Route::post('/restock', [OperatorController::class, 'quickRestock']);
    // Tambahkan baris ini:
    Route::get('/profile', [OperatorController::class, 'getProfile']);
});

Route::prefix('operator')->group(function () {
    // ... rute sebelumnya (alerts, restock, profile) ...
    
    // Tambahkan rute untuk halaman Stok Makanan
    Route::get('/inventory', [OperatorController::class, 'getInventory']);
});

Route::prefix('operator')->group(function () {
    // ... rute sebelumnya ...
    Route::get('/revenue', [OperatorController::class, 'getRevenue']);
});

Route::prefix('operator')->group(function () {
    // ... rute sebelumnya ...
    Route::post('/product/add', [OperatorController::class, 'addProduct']);
});

Route::prefix('operator')->group(function () {
    // ... rute sebelumnya ...
    Route::post('/product/update/{product_id}', [OperatorController::class, 'updateProduct']);
});

