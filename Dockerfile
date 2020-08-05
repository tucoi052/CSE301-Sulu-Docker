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



# RUN chown -R www-data /var/www/sulu-standard/

# # Allow shell for www-data (to make symfony console and composer commands)
# RUN sed -i -e 's/\/var\/www:\/usr\/sbin\/nologin/\/var\/www:\/bin\/bash/' /etc/passwd
# #RUN sed -i -e 's/^UMASK *[0-9]*.*/UMASK    002/' /etc/login.defs