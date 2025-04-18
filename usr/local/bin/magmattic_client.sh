#!/bin/bash

check_internet() {
  # Try to ping Google's DNS
  if ping -q -c 1 -W 1 8.8.8.8 > /dev/null; then
    return 0  # Internet is available
  else
    return 1  # No internet connection
  fi
}

WEBAPP_DIR="/opt/magmattic_frontend"
NGINX_HTML_DIR="/var/www/html"

mkdir -p $WEBAPP_DIR
cd $WEBAPP_DIR

if check_internet; then
        # Pull latest changes to webapp
        git pull || git clone git@github-client:mbocsi/magmattic_frontend.git .
        # Deploy
        cp -r dist/* $NGINX_HTML_DIR
else
        echo "No internet connection -- skipping frontend update"
fi
