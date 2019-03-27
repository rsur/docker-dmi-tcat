#!/bin/bash

/usr/sbin/service php5-fpm start &&
/usr/sbin/service supervisor start &>/dev/null &&
for i in proc logs analysis/cache; do
	chown www-data:www-data /var/www/html/$i
done
/usr/sbin/nginx -g "daemon off;"

