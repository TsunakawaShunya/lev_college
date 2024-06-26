# ベースイメージ
FROM php:8.1-fpm

# 作業ディレクトリを設定
WORKDIR /var/www

# 必要なPHP拡張をインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd

# Composerをインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# アプリケーションコードをコピー
COPY . /var/www

# Composerの依存関係をインストール
RUN composer install

# Breezeのインストールと設定
RUN php artisan breeze:install
RUN npm install && npm run dev

# パーミッションの設定
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# ポートを公開
EXPOSE 9000

# Laravelのサーバーを起動
CMD ["php-fpm"]
