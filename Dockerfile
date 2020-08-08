FROM revollat/sulu-cms:latest

RUN echo "Asia/Ho_Chi_Minh" > /etc/timezone; dpkg-reconfigure tzdata

RUN apt-get update -y

COPY nginx/vhost.conf /etc/nginx/sites-enabled/default
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www/sulu-standard
RUN composer install --prefer-source

COPY webspaces/sulu.io.xml app/Resources/webspaces/sulu.io.xml
RUN cp app/Resources/pages/default.xml.dist app/Resources/pages/default.xml  && \
    cp app/Resources/pages/overview.xml.dist app/Resources/pages/overview.xml && \
    cp app/Resources/snippets/default.xml.dist app/Resources/snippets/default.xml
RUN rm -rf app/cache/* && rm -rf app/logs/*

EXPOSE 80