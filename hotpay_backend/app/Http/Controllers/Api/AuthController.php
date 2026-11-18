<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class AuthController extends Controller
{
    public function login(Request $request): JsonResponse
    {
        // Validasi input
        $request->validate([
            'phone' => 'required|string',
            'password' => 'required|string',
        ]);

        // TODO: Implementasi logika autentikasi (Sanctum/Passport)
        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'token' => 'dummy_token_123',
            'user' => ['name' => 'Ahmad Pratama', 'phone' => $request->phone]
        ], 200);
    }

    public function register(Request $request): JsonResponse
    {
        // Validasi input
        $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|unique:users',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:8|confirmed',
        ]);

        // TODO: Implementasi logika simpan user ke database
        return response()->json([
            'success' => true,
            'message' => 'Registrasi berhasil, OTP telah dikirim',
        ], 201);
    }
}