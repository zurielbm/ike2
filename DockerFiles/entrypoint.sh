#!/bin/bash

set -e

# Read Last commit hash from .git
# This prevents installing git, and allows display of commit
branch=$(ls /var/www/html/ike/.git/refs/heads)
read -r longhash < /var/www/html/ike/.git/refs/heads/$branch
shorthash=$(echo $longhash |cut -c1-7)
target=$(</var/www/html/ike/docker_target)
version=$(head -n 1 /var/www/html/ike/version.md)

echo "
-------------------------------------
ZInvoiceShelf Branch:   $branch ($target)
ZInvoiceShelf Commit:   $shorthash
ZInvoiceShelf Version:  $version
-------------------------------------
Link to commit: https://github.com/zurielbm/ZInvoiceShelf/commit/$longhash
-------------------------------------"

if [ -n "$STARTUP_DELAY" ]
	then echo "**** Delaying startup ($STARTUP_DELAY seconds)... ****"
	sleep $STARTUP_DELAY
fi

echo "**** Make sure the /conf /data folders exist ****"
[ ! -d /conf ] && mkdir -p /conf
[ ! -d /data ] && mkdir -p /data

echo "**** Link storage ****"
[ ! -L /var/www/html/ike/storage ] && \
	cp -r /var/www/html/ike/storage/* /data && \
	rm -r /var/www/html/ike/storage && \
	ln -s /data /var/www/html/ike/storage

echo "**** Expose storage ****"
[ ! -L /var/www/html/ike/public/storage ] && \
	ln -s /data/app/public /var/www/html/ike/public/storage

cd /var/www/html/ike

if [ "$DB_CONNECTION" = "sqlite" ] || [ -z "$DB_CONNECTION" ] ; then
  echo "**** Configure SQLite3 database ****"
  if [ ! -n "$DB_DATABASE" ]; then
    echo "**** DB_DATABSE not defined. Fall back to default /database/database.sqlite location ****"
    DB_DATABASE='/var/www/html/ike/database/database.sqlite'
  fi
  DB_FILENAME=$(basename ${DB_DATABASE});
  if [ ! -e "/conf/$DB_FILENAME" ]; then
    echo "**** Specified sqlite database doesn't exist. Creating it ****"
    echo "**** Please make sure your database is on a persistent volume ****"
    sqlite3 $DB_DATABASE "VACUUM;"
    mv $DB_DATABASE /conf/$DB_FILENAME
  fi
  if [ ! -L $DB_DATABASE ]; then
    echo "**** Create the symbolic link for the database ****"
    ln -s /conf/$DB_FILENAME $DB_DATABASE
  fi
  chown www-data:www-data $DB_DATABASE /conf/$DB_FILENAME
fi

echo "**** Copy the .env to /conf ****" && \
[ ! -e /conf/.env ] && \
	sed 's|^#DB_DATABASE=$|DB_DATABASE='$DB_DATABASE'|' /var/www/html/ike/.env.example > /conf/.env
[ ! -L /var/www/html/ike/.env ] && \
	ln -s /conf/.env /var/www/html/ike/.env
echo "**** Inject .env values ****" && \
	/inject.sh

echo "**** Setting up artisan permissions ****"
chmod +x artisan

if ! grep -q "APP_KEY" /conf/.env
then
    echo "**** Creating empty APP_KEY variable ****"
    echo "$(printf "APP_KEY=\n"; cat /conf/.env)" > /conf/.env
fi
if ! grep -q '^APP_KEY=[^[:space:]]' /conf/.env; then
  echo "**** Generating new APP_KEY variable **** " && \
  ./artisan key:generate -n
fi

if [ -e /data/app/database_created ]; then
    echo "**** Migrating the database ****" && \
    ./artisan migrate --force -n
fi

echo "**** Setting the version ****" && \
./artisan tinker --execute="\Schema::hasTable('settings') && \App\Space\InstallUtils::setCurrentVersion()" -n -q

echo "**** Create user and use PUID/PGID ****"
PUID=${PUID:-1000}
PGID=${PGID:-1000}
if [ ! "$(id -u "$USER")" -eq "$PUID" ]; then usermod -o -u "$PUID" "$USER" ; fi
if [ ! "$(id -g "$USER")" -eq "$PGID" ]; then groupmod -o -g "$PGID" "$USER" ; fi
echo -e " \tUser UID :\t$(id -u "$USER")"
echo -e " \tUser GID :\t$(id -g "$USER")"
usermod -a -G "$USER" www-data

echo "**** Make sure Laravel's log exists ****" && \
touch /data/logs/laravel.log

if [ -n "$SKIP_PERMISSIONS_CHECKS" ] && [ "${SKIP_PERMISSIONS_CHECKS,,}" = "yes" ] ; then
	echo "**** WARNING: Skipping permissions check ****"
else
	echo "**** Set Permissions ****"
	# Set ownership of directories, then files and only when required.
	find /var/www/html/ike/bootstrap -type d \( ! -perm -ug+w -o ! -perm -ugo+rX -o ! -perm -g+s \) -exec chmod -R ug+w,ugo+rX,g+s \{\} \;
	find /conf /data -type d \( ! -user "$USER" -o ! -group "$USER" \) -exec chown -R "$USER":"$USER" \{\} \;
	find /conf /data \( ! -user "$USER" -o ! -group "$USER" \) -exec chown "$USER":"$USER" \{\} \;
	find /conf /data -type d \( ! -perm -ug+w -o ! -perm -ugo+rX -o ! -perm -g+s \) -exec chmod -R ug+w,ugo+rX,g+s \{\} \;
	find /conf /data \( ! -perm -ug+w -o ! -perm -ugo+rX \) -exec chmod ug+w,ugo+rX \{\} \;
fi

# Update CA Certificates if we're using armv7 because armv7 is weird (#76)
if [[ $(uname -a) == *"armv7"* ]]; then
  echo "**** Updating CA certificates ****"
  update-ca-certificates -f
fi

echo "**** Start cron daemon ****"
service cron start

echo "**** Setup complete, starting the server. ****"
php-fpm8.2
exec $@
