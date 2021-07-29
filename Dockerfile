FROM ubuntu:20.04
MAINTAINER MACROMIND Online <idc@macromind.online>
LABEL description="MACROMIND Online Dev - Ubuntu 20 + Apache2 + PHP 7.4"

ENV DEBIAN_FRONTEND=noninteractive
#COPY sources.list /etc/apt/

RUN apt-get update --fix-missing
RUN apt-get -y install git curl apache2 php php7.4-mysql php7.4-curl php7.4-intl php7.4-json php7.4-imap php7.4-zip php7.4-gd php7.4-xml php7.4-mbstring libapache2-mod-php7.4 php7.4-sqlite3 php7.4-intl php7.4-mongodb php-pear php7.4-dev unzip
RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata && apt-get clean && rm -rf /var/lib/apt/lists/*
#RUN /usr/sbin/a2dismod 'mpm_*' && /usr/sbin/a2enmod mpm_prefork
RUN /usr/bin/pecl install mongodb
RUN /usr/sbin/a2enmod rewrite
RUN chown www-data:www-data /usr/sbin/apachectl && chown www-data:www-data /var/www/html/
RUN /usr/sbin/a2ensite default-ssl
RUN /usr/sbin/a2enmod ssl
RUN /usr/bin/curl -sS https://getcomposer.org/installer |/usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer
RUN chown www-data:www-data /usr/sbin/apachectl && rm -rf /var/www/html

COPY apache2-foreground /usr/local/bin/

ENV APACHE_LOCK_DIR "/var/lock"
ENV APACHE_RUN_DIR "/var/run/apache2"
ENV APACHE_PID_FILE "/var/run/apache2/apache2.pid"
ENV APACHE_RUN_USER "www-data"
ENV APACHE_RUN_GROUP "www-data"
ENV APACHE_LOG_DIR "/var/log/apache2"

EXPOSE 80
EXPOSE 443

CMD ["apache2-foreground"]
