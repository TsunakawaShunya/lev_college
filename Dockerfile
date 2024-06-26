# ベースイメージを指定
FROM php:8.1-fpm

# 作業ディレクトリを設定
WORKDIR /var/www

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Composerをインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Laravelプロジェクトのファイルをコピー
COPY . .

# Composerの依存関係をインストール
RUN composer install

# BreezeやTailwind CSSのビルド
RUN npm install && npm run dev

# 権限の設定
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage

EXPOSE 9000
CMD ["php-fpm"]
