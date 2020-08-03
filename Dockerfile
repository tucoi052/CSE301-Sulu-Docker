FROM php:7.4-fpm


ENV DEBIAN_FRONTEND noninteractive
RUN echo "Asia/Ho_Chi_Minh" > /etc/timezone; dpkg-reconfigure tzdata

RUN apt-get update 
RUN apt-get install -y git ca-certificates curl  supervisor zip unzip

# COPY config/php.ini /usr/local/etc/php/

# Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# CONF Nginx
# ADD vhost.conf /etc/nginx/sites-enabled/default

# SUPERVISOR
ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# Install Sulu CMS
WORKDIR /var/www
RUN git clone https://github.com/sulu/sulu.git
WORKDIR /var/www/sulu
RUN composer update
RUN composer install --prefer-source
COPY webspaces/sulu.io.xml config/webspaces/sulu.io.xml
# RUN cp app/Resources/pages/default.xml.dist app/Resources/pages/default.xml  && \
#     cp app/Resources/pages/overview.xml.dist app/Resources/pages/overview.xml && \
#     cp app/Resources/snippets/default.xml.dist app/Resources/snippets/default.xml
# RUN rm -rf app/cache/* && rm -rf app/logs/*
RUN docker-php-ext-install pdo_mysql pdo
COPY config/.env /var/www/sulu
COPY config/doctrine.yaml config/packages/

# RUN chown -R www-data /var/www/sulu/
# RUN bin/adminconsole sulu:build dev



# Allow shell for www-data (to make symfony console and composer commands)
RUN sed -i -e 's/\/var\/www:\/usr\/sbin\/nologin/\/var\/www:\/bin\/bash/' /etc/passwd
#RUN sed -i -e 's/^UMASK *[0-9]*.*/UMASK    002/' /etc/login.defs

# RUN su - www-data  sulu/bin/adminconsole sulu:build dev

EXPOSE 80



# RUN php -S localhost:80 -t public/ config/router.php

CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisor/supervisord.conf"]