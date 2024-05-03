<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Models\User;

class FirstUser
{
    public function handle($request, Closure $next)
    {
        // Überprüfe, ob bereits Benutzer existieren
        if (User::count() == 0) {
            // Keine Benutzer vorhanden, leite zur Setup-Seite weiter
            return redirect('/register');
        }

        return $next($request);
    }
}
