#!/bin/bash
set -e

if [ "$TIMEZONE" ]; then 
    timezone="$TIMEZONE"
else 
    timezone="Europe/Moscow"
fi
echo "$timezone" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
echo "$1"
echo "$0"
if [ "$1" = 'apache' ]; then
	echo "is apache run "
     python /distr/web/walk.py -p ${DESCRIPTORS} -r /etc/apache2/sites-enabled/ -o /var/www/ -d ${DESCRIPTORS}
    /usr/sbin/apachectl -k start
    watchmedo shell-command --patterns="*.vrd" --recursive --command='python /distr/web/render.py -p ${watch_src_path} -e ${watch_event_type} -r /etc/apache2/sites-enabled/ -o /var/www/ -d ${DESCRIPTORS} && apachectl -k graceful' ${DESCRIPTORS} 
    #gosu www-data /usr/sbin/apache2 -D FOREGROUND
else
    exec "$@"
fi