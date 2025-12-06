# Resmi PHP-FPM görüntüsünü kullanın.
FROM php:8.2-fpm

# Gerekli PHP uzantılarını yükleyin
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    git \
    unzip \
    # WordPress indirme ve izin ayarları için gerekli
    curl \
    # Cleanup
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install mysqli zip opcache

# WordPress'in yükleneceği dizin
WORKDIR /var/www/html

# --------------------------------------------------------
# 🚀 WordPress'i İnternetten İndir ve Kur
# --------------------------------------------------------

# WordPress'in en son sürümünü indir ve dizine çıkart
RUN curl -o /tmp/wordpress.tar.gz -fSL https://wordpress.org/latest.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /usr/src/ \
    && mv /usr/src/wordpress/* /var/www/html/ \
    && rm -rf /tmp/wordpress.tar.gz /usr/src/wordpress

# www-data (PHP kullanıcısı) için dosya izinlerini ayarla
RUN chown -R www-data:www-data /var/www/html