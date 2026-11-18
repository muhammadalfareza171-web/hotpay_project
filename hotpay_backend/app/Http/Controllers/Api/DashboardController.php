<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function getOperatorStats()
    {
        // Dalam implementasi nyata, data ini di-query dari tabel transactions, machines, dll.
        return response()->json([
            'status' => 'success',
            'data' => [
                'machine' => [
                    'id' => 'VM001',
                    'status' => 'AKTIF',
                    'location' => 'PT.Jaya Abadi, Mukakuning',
                    'temperature' => '85°C',
                    'network' => '99ms',
                ],
                'summary' => [
                    'revenue_today' => 450000,
                    'total_transactions' => 18,
                    'stock_remaining' => 25,
                    'stock_total' => 60,
                    'top_seller' => 'Mie Sagu',
                ],
                // Data tren dapat ditambahkan di sini...
            ]
        ]);
    }
}