<?php

namespace App\Http\Controllers;

use App\Models\Streamer;
use Illuminate\Http\Request;

class StreamerController extends Controller
{
    /**
     * Zeige eine Liste aller Streamer.
     */
    public function dashboard()
    {
        $streamers = Streamer::all();
        return view('dashboard', compact('streamers'));
    }

    /**
     * Zeige das Formular zum Erstellen eines neuen Streamers.
     */
    public function create()
    {
        return view('streamers.create');
    }

    /**
     * Speichere einen neu erstellten Streamer in der Datenbank.
     */

     public function store(Request $request)
     {
         $request->validate([
             'name' => 'required|string|max:255',
         ]);
 
         $name = strtolower(trim($request->name));
         $url = "https://twitch.tv/{$name}";
 
         $streamer = new Streamer();
         $streamer->name = $request->name;
         $streamer->stream_url = $url;
         $streamer->save();
 
         return redirect()->route('dashboard');
     }

    /**
     * Zeige die Daten eines spezifischen Streamers.
     */
    public function show(Streamer $streamer)
    {
        return view('streamers.show', compact('streamer'));
    }

    /**
     * Zeige das Formular zur Bearbeitung eines Streamers.
     */
    public function edit(Streamer $streamer)
    {
        return view('streamers.edit', compact('streamer'));
    }

    /**
     * Aktualisiere die Daten eines Streamers in der Datenbank.
     */
    public function update(Request $request, Streamer $streamer)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'stream_url' => 'required|url'
        ]);

        $streamer->update($request->all());
        return redirect()->route('streamers.index');
    }

    /**
     * Lösche einen Streamer aus der Datenbank.
     */
    public function destroy(Streamer $streamer)
    {
        $streamer->delete();
        return redirect()->route('streamers.index');
    }
}
