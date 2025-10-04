#!/bin/bash
# echo "ServerName $1" > /etc/apache2/conf-enabled/servername.conf
echo "ServerName ${SERVER_NAME}" > /etc/apache2/conf-available/servername.conf
a2enconf servername
service apache2 restart
