#!/bin/bash
email="$1"
# domain="$2"
domain="$SERVER_NAME"
live="/etc/letsencrypt/live/$domain"
conf="000-default-le-ssl.conf"
sites="/etc/apache2/sites-available"
if [ ! -d "$live" ]
then
    certbot --apache --agree-tos --email "$email" --non-interactive --domain "$domain"
    echo 'Include /etc/apache2/conf.d/*.conf' >> /etc/letsencrypt/options-ssl-apache.conf
    cp "$sites/$conf" "$live"
fi
if [ ! -f "$sites/$conf" ]
then
    cp "$live/$conf" "$sites"
    a2ensite 000-default-le-ssl
    service apache2 reload
fi
