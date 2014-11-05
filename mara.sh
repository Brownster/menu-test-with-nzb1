#!/usr/bin/env bash
echo "###########################"
echo "## installing Maraschino ##"
echo "###########################"
cd /home/$username/temp
git clone https://github.com/mrkipling/maraschino.git maraschino
cp /home/$username/temp/maraschino /home/backups/maraschino/
mv /home/$username/temp/maraschino  /home/$username/.maraschino
cp /home/$username/maraschino/initd /etc/init.d/maraschino

cat >/etc/default/maraschino << EOF
# This file is sourced by /etc/init.d/maraschino
#
# When maraschino is started using the init script
# is started under the account of $USER, as set below.
#
# Each setting is marked either "required" or "optional";
# leaving any required setting unconfigured will cause
# the service to not start.

# [required] set path where maraschino is installed:
APP_PATH=/home/$username/.maraschino

# [optional] change to 1 to enable daemon
ENABLE_DAEMON=1

# [required] user or uid of account to run the program as:
RUN_AS=$username

# [optional] full path for the pidfile
# otherwise, the default location /var/run/maraschino/maraschino.pid is used:
PID_FILE=

# [required] port to listen on (defaults to 7000)
PORT=$MARAPORT
EOF

chmod a+x /etc/init.d/maraschino
update-rc.d maraschino defaults
chown $username /home/$username/.maraschino/
chmod 777 /home/$username/.maraschino/
/etc/init.d/maraschino start
echo "Maraschino has been started on $HOSTIP : $MARAPORT"
