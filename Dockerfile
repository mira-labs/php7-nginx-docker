FROM ubuntu:16.04

MAINTAINER RadicalRad <rad@mira-digital.com>

ENV DEBIAN_FRONTEND noninteractive

#Install nginx and php
RUN apt-get update && \
	apt-get install -y \
	curl \
	nginx \
	php \
	php-fpm \
	php-curl \
	php-mysql \
	php-mcrypt \
	supervisor

#Install phalcon
RUN curl -s https://packagecloud.io/install/repositories/phalcon/nightly/script.deb.sh | bash
RUN apt-get install php7.0-phalcon

#Create web folder
RUN mkdir -p /var/www/html/public /var/run/php /var/log/supervisor

#Add supervisord.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#Share web folder
VOLUME ["/var/www/html"]

COPY index.php /var/www/html/public/index.php

#Update nginx config
COPY default /etc/nginx/sites-available/default

#Set port
EXPOSE 80 443

#Start supervisor
CMD ["/usr/bin/supervisord"]
