<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\SplashController;

Route::prefix('v1')->group(function () {
    Route::get('/splash/carousel', [SplashController::class, 'getCarouselData']);
});
