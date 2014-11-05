#!/bin/bash
echo "##########################"
echo "## installing sickbeard ##"
echo "##########################"
sleep 2
cd /home/$username/temp
git clone https://github.com/midgetspy/Sick-Beard.git sickbeard
echo "backing up sickbeard"
cp sickbeard /home/backups/sickbeard
mv sickbeard /home/$username/.sickbeard
#cp /home/$username/.sickbeard/config.ini /etc/default/sickbeard
#sed -i 's/USER = */USER="$username"/' /etc/init.d/sickbeard

cat > /etc/init.d/sickbeard << EOF
#! /bin/sh
# Author: daemox
# Basis: Parts of the script based on and inspired by work from
# tret (sabnzbd.org), beckstown (xbmc.org),
# and midgetspy (sickbeard.com).
# Fixes: Alek (ainer.org), James (ainer.org), Tophicles (ainer.org),
# croontje (sickbeard.com)
# Contact: http://www.ainer.org
# Version: 3.1
### BEGIN INIT INFO
# Provides: sickbeard
# Required-Start: $local_fs $network $remote_fs
# Required-Stop: $local_fs $network $remote_fs
# Should-Start: $NetworkManager
# Should-Stop: $NetworkManager
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: starts and stops sick beard
# Description: Sick Beard is an Usenet PVR. For more information see:
# http://www.sickbeard.com
### END INIT INFO
#Required -- Must Be Changed!
USER="$username" #Set Linux Mint, Ubuntu, or Debian user name here.

#Required -- Defaults Provided (only change if you know you need to).
HOST="$HOSTIP" #Set Sick Beard address here.
PORT="$SICKPORT" #Set Sick Beard port here.

#Optional -- Unneeded unless you have added a user name and password to Sick Beard.
SBUSR="$WEBUSER" #Set Sick Beard user name (if you use one) here.
SBPWD="$WEBPASS" #Set Sick Beard password (if you use one) here.

#Script -- No changes needed below.
case "$1" in
start)
#Start Sick Beard and send all messages to /dev/null.
cd /home/$USER/.sickbeard
echo "Starting Sick Beard"
sudo -u $USER -EH nohup python /home/$USER/.sickbeard/SickBeard.py -q > /dev/null 2>&1 &
;;
stop)
#Shutdown Sick Beard and delete the index.html files that wget generates.
echo "Stopping Sick Beard"
wget -q --user=$SBUSR --password=$SBPWD "http://$HOST:$PORT/home/shutdown/" --delete-after
sleep 6s
;;
*)
echo "Usage: $0 {start|stop}"
exit 1
esac
exit 0
EOF

chmod +x /etc/init.d/sickbeard
cat > /etc/default/sickbeard << EOF
SB_HOME=/home/$username/.sickbeard/
SB_DATA=/home/$username/.sickbeard/
SB_USER=$username
EOF
chmod +x /etc/default/sickbeard
update-rc.d sickbeard defaults
/etc/init.d/sickbeard stop
/etc/init.d/sickbeard start
