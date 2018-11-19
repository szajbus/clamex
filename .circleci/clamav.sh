#!/bin/bash

set -e

# install clamav
apt-get update && apt-get install clamav clamdscan clamav-daemon -y

# update database
wget -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
wget -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
wget -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd

# set permissions
mkdir -p /var/run/clamav && \
chown -R clamav:clamav /var/run/clamav && \
chown -R clamav:clamav /var/lib/clamav

# start
/etc/init.d/clamav-daemon start
