#!/bin/sh

# Set correct permissions for Laravel storage and bootstrap cache
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Berechtigungen für Aufnahmeverzeichnis setzen
chown -R www-data:www-data /recordings
chmod -R 775 /recordings

# Erstellen und Berechtigen der PHP-FPM Log-Datei
mkdir -p /var/log/php-fpm
chown www-data:www-data /var/log/php-fpm

# PHP-FPM Log für den 'www' Pool konfigurieren
sed -i 's#;error_log = log/php-fpm.log#error_log = /var/log/php-fpm/error.log#g' /usr/local/etc/php-fpm.d/www.conf

# Warten, bis die Datenbank verfügbar ist
while ! nc -z db 3306; do   
  echo "Warten auf die Datenbank..."
  sleep 1
done

echo "Datenbank ist verfügbar."

# Laravel-Schlüssel generieren, wenn nicht vorhanden
if [ -z "$(grep 'APP_KEY=base64' .env)" ]; then
  echo "App-Schlüssel generieren..."
  php artisan key:generate
fi

# Durchführen der Datenbank-Migrationen
echo "Datenbank-Migrationen durchführen..."
php artisan migrate --force

# start-container.sh
#php artisan reverb:start

#echo "Starten des Laravel Queue Workers..."
#php artisan queue:work --daemon &

#echo "Checking webhooks"
#php artisan twitch:register-all-webhooks

# Starten des Supervisord, der die Hintergrunddienste verwaltet
supervisord -c /etc/supervisor/supervisord.conf

# Nginx-Konfiguration überprüfen und Nginx starten
#nginx -t && service nginx start

# PHP-FPM starten
#php-fpm -D
