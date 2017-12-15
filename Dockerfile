FROM ubuntu:17.10

MAINTAINER t3kit

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -yq \
    curl \
    # ======= git =====
    git \
    # ======= apache =====
    apache2 \
    # Install php 7
    libapache2-mod-php7.1 \
    php7.1-cli \
    php7.1-json \
    php7.1-curl \
    php7.1-fpm \
    php7.1-gd \
    php7.1-ldap \
    php7.1-mbstring \
    php7.1-mysql \
    php7.1-soap \
    php7.1-sqlite3 \
    php7.1-xml \
    php7.1-zip \
    php7.1-mcrypt \
    php7.1-intl \
    php-imagick \
    php-xdebug \
    # Install tools
    nano \
    graphicsmagick \
    imagemagick \
    ghostscript \
    mysql-client \
    iputils-ping \
    apt-utils \
    locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ======= composer =======
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# ======= nodejs =======
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y nodejs

# Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8

RUN a2enmod rewrite expires

# Configure PHP
ADD typo3.php.ini /etc/php/7.1/apache2/conf.d/

# Configure vhost
ADD typo3.default.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80 443

WORKDIR /var/www/html

RUN rm index.html

CMD ["apache2ctl", "-D", "FOREGROUND"]