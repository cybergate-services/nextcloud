#!/usr/bin/env bash

if [ -f nextcloud.conf ]; then
  read -r -p "A config file exists and will be overwritten, are you sure you want to contine? [y/N] " response
  case $response in
    [yY][eE][sS]|[yY])
      mv nextcloud.conf nextcloud.conf_backup
      ;;
    *)
      exit 1
    ;;
  esac
fi

if [ -f ./.env ]; then
  rm -f  ./.env
fi

echo "Press enter to confirm the detected value '[value]' where applicable or enter a custom value."
while [ -z "${NEXTCLOUD_HOSTNAME}" ]; do
  read -p "Hostname (FQDN): " -e NEXTCLOUD_HOSTNAME
  DOTS=${NEXTCLOUD_HOSTNAME//[^.]};
  if [ ${#DOTS} -lt 2 ] && [ ! -z ${NEXTCLOUD_HOSTNAME} ]; then
    echo "${NEXTCLOUD_HOSTNAME} is not a FQDN"
    NEXTCLOUD_HOSTNAME=
  fi
done

if [ -a /etc/timezone ]; then
  DETECTED_TZ=$(cat /etc/timezone)
elif [ -a /etc/localtime ]; then
  DETECTED_TZ=$(readlink /etc/localtime|sed -n 's|^.*zoneinfo/||p')
fi

while [ -z "${NEXTCLOUD_TZ}" ]; do
  if [ -z "${NEXTCLOUD_TZ}" ]; then
    read -p "Timezone: " -e NEXTCLOUD_TZ
  else
    read -p "Timezone [${DETECTED_TZ}]: " -e NEXTCLOUD_TZ
    [ -z "${NEXTCLOUD_TZ}" ] && CYBERERP_TZ=${NEXTCLOUD_TZ}
  fi
done

DBNAME=nextcloud
DBUSER=nextcloud
DBPASS=$(LC_ALL=C </dev/urandom tr -dc A-Za-z0-9 | head -c 28)
DBROOTPASS=$(LC_ALL=C </dev/urandom tr -dc A-Za-z0-9 | head -c 28)
PUID=1002
PGID=1002
URL=$(echo ${NEXTCLOUD_HOSTNAME} | cut -n -f 1  -d . --complement)
SUBDOMAIN=cloud,backup
VALIDATION=http
DHLEVEL=2048 
ONLY_SUBDOMAINS=true 
STAGING=false

cat << EOF > nextcloud.conf
# -------------------------------------
# Nextcloud docker-compose Environment
# -------------------------------------
NEXTCLOUD_HOSTNAME=${NEXTCLOUD_HOSTNAME}

# ----------------------------------
# MariaDB Database Environment
# ----------------------------------
DBNAME=${DBNAME}
DBUSER=${DBUSER}
DBROOTPASS=${DBROOTPASS}

# --------------------
# PGADMIN Environment
# --------------------
PGADMIN_PASSWORD=${PGADMIN_PASSWORD}
PGADMIN_EMAIL=${EMAIL}

#-------------------------
# LETSENCRYPT Environment
#-------------------------
PUID=${PUID}
PGID=${PGID}
URL=${URL}
SUBDOMAINS=${SUBDOMAINS}
VALIDATION=${VALIDATION}
EMAIL=${EMAIL}
DHLEVEL=${DHLEVEL}
ONLY_SUBDOMAINS=${ONLY_SUBDOMAINS}
STAGING=${STAGING}
TZ=${NEXTCLOUD_TZ}
EOF

ln ./nextcloud.conf ./.env
