#!/bin/bash


/usr/sbin/service php5-fpm start &&
/usr/sbin/service supervisor start &&
/usr/bin/php -r 'echo serialize($_SERVER);' > /tmp/env &&
for i in proc logs analysis/cache; do
	mkdir -p /var/www/html/proc &&
	mkdir -p /var/www/html/logs &&
	mkdir -p /var/www/html/analysis/cache &&
	chown www-data:www-data /var/www/html/$i
done

echo "Starting daemon ..."
/usr/bin/supervisorctl start tcat-"${TCAT_ROLE}"

echo "Starting web server ..."
/usr/sbin/nginx -g "daemon off;"

