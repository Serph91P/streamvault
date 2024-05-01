FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    curl \
    unzip \
    procps \
    git \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    netcat-openbsd \
    libicu-dev \
    ffmpeg \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean \
    && docker-php-ext-install -j$(nproc) intl \
    && rm -rf /var/lib/apt/lists/*


# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && node --version \
    && npm --version

# Set working directory
WORKDIR /var/www

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install npm dependencies
RUN npm install

# Copy the entire project and build it
COPY . .

# Build the project (assuming you have scripts for it)
RUN npm run build

# PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

RUN pecl install redis && docker-php-ext-enable redis

# Supervisor configuration files
COPY docker/supervisord.conf /etc/supervisor/supervisord.conf
COPY docker/services.conf /etc/supervisor/conf.d/services.conf

# Composer dependencies
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Python virtual environment and Streamlink
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install streamlink
RUN mkdir -p /opt/venv/share/streamlink/plugins && \
    curl -L -o /opt/venv/share/streamlink/plugins/twitch.py 'https://github.com/2bc4/streamlink-ttvlol/releases/latest/download/twitch.py'

# Directories and permissions
RUN mkdir -p /recordings && \
    chown -R www-data:www-data /recordings && \
    chmod -R 775 /recordings

# Nginx configuration
COPY docker/nginx.conf /etc/nginx/sites-available/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

# PHP-FPM configuration adjustments
RUN mkdir -p /var/log/php-fpm && chown www-data:www-data /var/log/php-fpm
RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/' /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/;error_log = log\/php-fpm.log/error_log = \/proc\/self\/fd\/2/' /usr/local/etc/php-fpm.conf

# Start script
COPY docker/start-container.sh /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

# Default command
CMD ["/usr/local/bin/start-container"]
