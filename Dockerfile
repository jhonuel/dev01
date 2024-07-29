FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y apache2 rsync cron ssl-cert-check certbot curl iproute2 python3-certbot-apache unzip && \
    apt-get clean

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN mkdir /var/www/html/balancer-manager
RUN mkdir /etc/apache2/maintenance-pages

RUN echo 'AuthType Basic'                   > /var/www/html/balancer-manager/.htaccess && \
    echo 'AuthName "Members Only"'          >> /var/www/html/balancer-manager/.htaccess && \
    echo 'AuthUserFile /var/.htpasswd'      >> /var/www/html/balancer-manager/.htaccess && \
    echo '<limit GET PUT POST>'             >> /var/www/html/balancer-manager/.htaccess && \
    echo 'require valid-user'               >> /var/www/html/balancer-manager/.htaccess && \
    echo '</limit>'                         >> /var/www/html/balancer-manager/.htaccess

RUN rm -rf /etc/apache2/sites-available/* && \
    mkdir -p /tmp/crontab

COPY sites-available/* /etc/apache2/sites-available/
COPY sites-template/* /etc/apache2/sites-template/
COPY conf-available/* /etc/apache2/conf-available/
COPY conf-loadbalancer /etc/apache2/conf-loadbalancer/
COPY script/* /usr/local/bin/
COPY maintenance-pages/* /etc/apache2/maintenance-pages/
COPY cron/* /tmp/crontab/

RUN mkdir -p /var/log/letsencrypt && \
    crontab /tmp/crontab/letsencrypt

RUN rm -f /etc/apache2/conf-available/proxy.conf && \
    cp /etc/apache2/conf-available/proxy.conf.dist /etc/apache2/conf-available/proxy.conf

RUN a2enmod proxy proxy_balancer proxy_http proxy_wstunnel status lbmethod_byrequests rewrite headers remoteip ssl && \
    a2enconf proxy proxy-balancer-manager

RUN cp -r /etc/apache2 /tmp/apache2 && \
    cp -r /etc/letsencrypt /tmp/letsencrypt

ENV TIME_ZONE=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && echo ${TIME_ZONE} > /etc/timezone



COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
