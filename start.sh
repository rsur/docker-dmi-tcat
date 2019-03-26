#!/bin/bash

/usr/sbin/service php5-fpm start &&
/usr/sbin/service supervisor start &>/dev/null &&
/usr/sbin/nginx -g "daemon off;"

