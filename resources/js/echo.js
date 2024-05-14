import axios from 'axios';
import Echo from 'laravel-echo';
import Pusher from 'pusher-js';

window.Pusher = Pusher;
window.axios = axios;

window.Echo = new Echo({
    broadcaster: "reverb",
    key: import.meta.env.VITE_REVERB_APP_KEY,
    wsHost: import.meta.env.VITE_REVERB_HOST,
    wsPort: import.meta.env.VITE_REVERB_PORT ?? 80,
    wssPort: import.meta.env.VITE_REVERB_PORT ?? 443,
    forceTLS: (import.meta.env.VITE_REVERB_SCHEME ?? "https") === "https",
    enabledTransports: ["ws", "wss"],
  });

  window.Echo.channel('streamers')
  .listen('StreamerAdded', (event) => {
      console.log(event);  // Hier kannst du z.B. eine Benachrichtigung anzeigen
      // Aktualisiere die UI hier entsprechend
  });

// Dynamische Abfrage und Event-Subscription
axios.get('/api/streamers').then(response => {
  response.data.forEach(streamer => {
      window.Echo.channel('streamers.' + streamer.id)
          .listen('StreamerStatusUpdated', (event) => {
              console.log('Status update for streamer', streamer.id, ':', event.status);
              // Aktualisiere die UI hier entsprechend
              document.getElementById('status-' + streamer.id).textContent = event.status;
          });
  });
});
  