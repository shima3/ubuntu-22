#!/bin/bash
echo "ServerName $(hostname)" > /etc/apache2/sites-available/server-name.conf
a2ensite server-name
service apache2 start
