# Utilizamos una imagen base de PHP
FROM php:7.4-apache

# Actualizamos los paquetes e instalamos dependencias necesarias
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install zip pdo pdo_mysql

# Habilitamos el módulo de reescritura de Apache
RUN a2enmod rewrite

# Creamos un directorio de trabajo
WORKDIR /var/www/html

COPY . /var/www/html

# Clonamos el repositorio de Laravel
#RUN git clone -b 5.7 --single-branch https://github.com/laravel/laravel.git .

# Instalamos las dependencias de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev

# Copiamos el archivo de configuración de ejemplo
#RUN cp .env.example .env

# Generamos una nueva clave de aplicación
#RUN php artisan key:generate

# Establecemos los permisos adecuados
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exponemos el puerto 80
EXPOSE 80

# Comando para iniciar Apache
CMD ["apache2-foreground"]