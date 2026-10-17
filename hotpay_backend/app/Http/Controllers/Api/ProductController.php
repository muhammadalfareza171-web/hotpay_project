<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB; // Pastikan ini di-import

class ProductController extends Controller
{
    public function index()
    {
        // Pastikan tabel 'products' sudah ada di database MySQL Anda
        $products = DB::table('products')->get();

        return response()->json([
            'status' => 'success',
            'data' => $products
        ]);
    }
}