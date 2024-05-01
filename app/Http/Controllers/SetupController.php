<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use App\Models\Streamer;


class SetupController extends Controller
{
    public function dashboard()
    {
        $streamers = Streamer::all();
        return view('dashboard', compact('streamers'));
    }

    public function index()
    {
        return view('setup.index');
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'email' => 'required|email',
            'password' => 'required|confirmed',
        ]);

        $user = new User();
        $user->name = $request->name;
        $user->email = $request->email;
        $user->password = Hash::make($request->password);
        $user->save();

        // Redirect zum Dashboard oder Login
        return redirect()->route('login');
    }
}
