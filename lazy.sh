#!/usr/bin/env bash
echo "##############################"
echo "## installing Lazylibrarian ##"
echo "##############################"
cd /home/$username/temp
git clone https://github.com/Conjuro/LazyLibrarian.git lazylibrarian 
cp /home/$username/temp/lazylibrarian /home/backups/lazylibrarian/
mv /home/$username/temp/lazylibrarian  /home/$username/.lazylibrarian 
cp /home/$username/.lazylibrarian/init/ubuntu.initd /etc/init.d/lazylibrarian

cat > /etc/default/lazylibrarian << EOF
APP_PATH=/home/castro/.lazylibrarian
ENABLE_DAEMON=1
RUN_AS=$user
WEBUPDATE=0
CONFIG=/home/$username/.lazylibrarian/
DATADIR=/home/$username/.lazylibrarian/
PORT=$BOOKPORT
PID_FILE=/home/$username/.pid/lazylibrarian.pid
EOF

cat < /home/$username/.pid/lazylibrarian.pid << EOF
50005
EOF

chown $username /home/$username/.pid/lazylibrarian.pid
chmod 777 /home/$username/.pid/lazylibrarian.pid
chown $username /home/$username/.lazylibrarian
chmod 777 /home/$username/.lazylibrarian
chmod +x /etc/init.d/lazylibrarian  
update-rc.d lazylibrarian  defaults
echo "Lazy Librarian will start on nect boot you can access the ui via http://$HOSTIP:$BOOKPORT"
sleep 3
