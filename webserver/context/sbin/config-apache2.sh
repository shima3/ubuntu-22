#!/bin/bash
echo "ServerName $1" > /etc/apache2/conf-enabled/servername.conf
service apache2 restart
