#!/bin/bash
email="$1"
domain="$2"
if cd "/etc/letsencrypt/live/$domain"
then
    if test -f fullchain.pem -a -f privkey.pem
    then exit 0
    fi
fi
certbot --apache --agree-tos --email "$email" --non-interactive --domain "$domain"
echo 'Include /etc/apache2/conf.d/*.conf' >> /etc/letsencrypt/options-ssl-apache.conf
