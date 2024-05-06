#!/bin/bash

# Standard .env file path
ENV_PATH="/var/www/.env"

# Create .env if it doesn't exist
if [ ! -f "$ENV_PATH" ]; then
    echo "Creating .env file..."
    cp /var/www/.env.example $ENV_PATH
fi

# Function to set variable in .env file
set_env_var() {
    local var="$1"
    local value="$2"
    sed -i "s/^$var=.*/$var=$value/" $ENV_PATH
}

# Generate random keys for Reverb if not already set
# if ! grep -q "REVERB_APP_KEY" $ENV_PATH; then
#     export REVERB_APP_KEY=$(openssl rand -hex 32)
#     set_env_var "REVERB_APP_KEY" "$REVERB_APP_KEY"
# fi

# if ! grep -q "VITE_REVERB_APP_KEY" $ENV_PATH; then
#     export VITE_REVERB_APP_KEY=$(openssl rand -hex 32)
#     set_env_var "VITE_REVERB_APP_KEY" "$VITE_REVERB_APP_KEY"
# fi

# if ! grep -q "REVERB_APP_SECRET" $ENV_PATH; then
#     export REVERB_APP_SECRET=$(openssl rand -hex 32)
#     set_env_var "REVERB_APP_SECRET" "$REVERB_APP_SECRET"
# fi

# if ! grep -q "REVERB_APP_ID" $ENV_PATH; then
#     export REVERB_APP_ID=$(openssl rand -hex 12)
#     set_env_var "REVERB_APP_ID" "$REVERB_APP_ID"
# fi

# Update .env with variables from Docker environment

# set_env_var "REVERB_SERVER_HOST" "127.0.0.1"
# set_env_var "REVERB_SERVER_PORT" "6050"
# set_env_var "APP_URL" "$APP_URL"
# set_env_var "REVERB_HOST" "127.0.0.1"
# set_env_var "REVERB_PORT" "6050"
# set_env_var "REVERB_SCHEME" "http"
# set_env_var "VITE_APP_NAME" "StreamVault"
# set_env_var "VITE_REVERB_HOST" "$(echo $APP_URL | sed 's|https://||g;s|http://||g')"
# set_env_var "VITE_REVERB_PORT" "443"
# set_env_var "VITE_REVERB_SCHEME" "https"
# set_env_var "VITE_REVERB_PATH" "/ws"

# Update Nginx configuration with APP_URL
sed -i "s/\$APP_URL/$APP_URL/" /etc/nginx/conf.d/default.conf

# Other required settings
set_env_var "REDIS_HOST" "streamvault_redis"
set_env_var "REDIS_PASSWORD" "null"
set_env_var "REDIS_PORT" "6379"
set_env_var "QUEUE_CONNECTION" "redis"
set_env_var "BROADCAST_DRIVER" "reverb"
set_env_var "BROADCAST_CONNECTION" "reverb"
set_env_var "CACHE_STORE" "redis"


# Ensure correct permissions for Laravel
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
chmod -R 775 /var/www/storage /var/www/bootstrap/cache
chown -R www-data:www-data /recordings
chmod -R 775 /recordings

# Configure PHP-FPM
mkdir -p /var/log/php-fpm
chown www-data:www-data /var/log/php-fpm
sed -i 's#;error_log = log/php-fpm.log#error_log = /var/log/php-fpm/error.log#g' /usr/local/etc/php-fpm.d/www.conf

# Wait for database to be ready
while ! nc -z streamvault_db 3306; do
    echo "Waiting for database..."
    sleep 1
done
echo "Database is available."

# Generate Laravel key if not set
if ! grep -q "APP_KEY=base64" $ENV_PATH; then
    echo "Generating Laravel key..."
    php artisan key:generate
fi

# Run database migrations
echo "Running database migrations..."
php artisan migrate --force

# Create log directories for Reverb
mkdir -p /var/log/reverb
chown www-data:www-data /var/log/reverb

# Start supervisord
echo "Starting supervisord..."
supervisord -c /etc/supervisor/supervisord.conf

echo "Running npm build..."
npm run build