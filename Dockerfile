FROM php:8.3-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zlib1g-dev \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libicu-dev \
    libsqlite3-dev \
    libcurl4-openssl-dev \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_sqlite \
        gd \
        zip \
        intl \
        ctype \
        mbstring \
        fileinfo \
        curl \
        iconv \
        tokenizer \
        filter

# Enable Apache modules
RUN a2enmod rewrite

# Set Apache document root to public directory
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Configure Apache for Railway
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copy application files
COPY . /var/www/html/

# Install PHP dependencies
RUN cd /var/www/html && composer install --no-dev --optimize-autoloader

# Install JavaScript dependencies and build
RUN cd /var/www/html && yarn install --modules-folder public/packages --production=true --ignore-scripts --ignore-optional

# Create data directory and set permissions
RUN mkdir -p /var/www/html/data && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html/data

# Copy config template and set default configuration
RUN cp /var/www/html/config-dist.php /var/www/html/data/config.php && \
    chown www-data:www-data /var/www/html/data/config.php

# Create startup script
RUN echo '#!/bin/bash\n\
# Ensure data directory is writable\n\
chown -R www-data:www-data /var/www/html/data\n\
chmod -R 755 /var/www/html/data\n\
\n\
# Copy config if it doesn'"'"'t exist\n\
if [ ! -f /var/www/html/data/config.php ]; then\n\
    cp /var/www/html/config-dist.php /var/www/html/data/config.php\n\
    chown www-data:www-data /var/www/html/data/config.php\n\
fi\n\
\n\
# Start Apache\n\
apache2-foreground' > /usr/local/bin/start-grocy.sh && \
    chmod +x /usr/local/bin/start-grocy.sh

# Expose port
EXPOSE 80

# Use Railway's PORT environment variable if available
ENV PORT=80

# Start the application
CMD ["/usr/local/bin/start-grocy.sh"] 