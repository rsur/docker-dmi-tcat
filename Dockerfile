FROM debian:jessie-backports

MAINTAINER rs@cogsci.bandungfe.net

ENV DEBIAN_FRONTEND=noninteractive

RUN \
	grep -v jessie-updates /etc/apt/sources.list > \
		/tmp/sources.list && \
	mv -f /tmp/sources.list /etc/apt && \
	echo '#' > /etc/apt/sources.list.d/backports.list && \
	\
	sed -i 's:deb.debian.org:kartolo.sby.datautama.net.id:g;' \
		/etc/apt/sources.list && \
	\
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
		php5-cli \
		php5-fpm \
 		php5-curl \
 		php5-geos \
		php5-mysqlnd \
		supervisor \
		nginx \
		&& \
	apt-get -y autoremove && \
	apt-get clean && \
	\
	mkdir -p /var/www/html/proc && \
	mkdir -p /var/www/html/logs && \
	mkdir -p /var/www/html/analysis/cache

COPY src/dmi-tcat /var/www/html/
COPY src/dmi-tcat/config.php.example /var/www/html/config.php
COPY nginx/default /etc/nginx/sites-available/
COPY supervisor/dmit_track.conf /etc/supervisor/conf.d/
COPY start.sh /usr/local/bin/

EXPOSE 80
CMD ["/usr/local/bin/start.sh"]

