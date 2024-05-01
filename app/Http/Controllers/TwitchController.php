<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;


class TwitchController extends Controller
{
    public function handleWebhook(Request $request)
    {
        $event = $request->all();
        Log::info('Received Twitch Event', $event);
        // Weitergehende Verarbeitung
    }
}
