<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class SplashController extends Controller
{
    public function getCarouselData(): JsonResponse
    {
        // Data statis untuk purwarupa, nantinya bisa dihubungkan ke Database (Model)
        $slides = [
            [
                'id' => 1,
                'image_url' => 'https://example.com/images/mie_goreng.jpg', // Ganti dengan URL aset asli Anda
                'badge_primary' => '85°C Freshly Cooked',
                'badge_secondary' => '100% Higienis',
            ],
            [
                'id' => 2,
                'image_url' => 'https://example.com/images/roti_goreng.jpg',
                'badge_primary' => '85°C Freshly Cooked',
                'badge_secondary' => '100% Higienis',
            ],
        ];

        return response()->json([
            'success' => true,
            'data' => $slides,
            'message' => 'Splash carousel data retrieved successfully.'
        ], 200);
    }
}