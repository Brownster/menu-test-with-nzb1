#!/bin/bash

############################################################################
######## You must change all the variables below to suit your setup ########
######## alot you can leave default like the port numbers but       ########
######## usernames hostnames ip adresses must be set by you so have ########
######## a look below anything with a = after it generally you can  ########
######## change                              			    ########
############################################################################

#DYNDNS / noip host name that resolves into your vps ip address
DYNDNS=someplace.dydns-remote.com

#Please enter a user name for accessing sickbeard, couchpotato ect (replace "webuser")
WEBUSER=webuser

#Please enter a password for accessing all the web apps sickbeard, couchpotato ect (replace "webpass")
WEBPASS=webpass

#Please enter a Username for Squid Proxy Server
SQUIDUSER=squid

#Please enter a password for Squid Proxy Server
SQUIDPASS=hideme

#squid Proxy please enter the port for web access
SQUIDPORT=7629

#SSH please enter the port for access
SSHPORT=2022

#FTP server address eith ip address if you have static address or 
#dyn dns / no ip account resolving to your home ip if you are dynamic
FTPHOST=somewhere.dyndns-remote.com

#ftp user
FTPUSER=ftpuser

#ftp password
FTPPASS=ftppass

#film ftp location - relative to ftp home directory
FILMFTPDIR=films

#TV ftp location
TVFTPDIR=tvseries

#Music ftp location
MUSICFTPDIR=music

#Books ftp location
BOOKSFTPDIR=ebooks

#Games ftp location
GAMESFTPDIR=games

#Comics ftp location
COMICSFTPDIR=comics

#games mount location
GAMESMNTDIR=/home/media/games

#comics mount location
COMICSMNTDIR=/home/media/comics

#films mount location
FILMMNTDIR=/home/media/films

#tv series mount location
TVMNTDIR=/home/media/tv

#music mount location
MUSICMNTDIR=/home/media/music


#books mount location
BOOKSMNTDIR=/home/media/books


## OPTIONAL TO CHANGE BELOW BUT RECOMMENDED ##

#SABNZB Please enter the port for web access
SABPORT=7960
echo "the port used by SABNZB will be $SABPORT"

#SICKBEARD Please enter the port for web access
SICKPORT=7961
echo "the port used by Sickbeard will be $SICKPORT"

#COUCHPOTATO Please enter the port for web access
COUCHPORT=7962
echo "the port used by Couchpotato will be $COUCHPORT"

#Headphones Please enter the port for web access
HEADPORT=7963
echo "the port used by Headphones will be $HEADPORT"

#Lazy Librarian Please enter the port for web access
BOOKPORT=7964
echo "the port used by Lazy Librarian will be $BOOKPORT"

#Mylar Please enter the port for web access
MYLARPORT=7965
echo "the port used by MYLAR will be $MYLARPORT"

#Gamez Please enter the port for web access
GAMESPORT=7966
echo "the port for Gamez web ui will be $GAMESPORT"

#Transmission RPC Port (web ui)
TRANPORT=7967
echo "the port for transmission web ui is $TRANPORT"

#Transmission peer port
TRANPPORT=61724

#Maraschino Web UI port
MARAPORT=7979

###########################################################################################################################
####################################    DO NOT EDIT ANYTHING BELOW THIS LINE  #############################################
###########################################################################################################################

echo "the current setting for your DNS Host name for your VPS is Currently $DYNDNS"
echo "Your current username for all web apps is                            $WEBUSER"
echo "Your current web app password id 					   $WEBPASS"
echo "Squid Proxy User name is 						   $SQUIDUSER"
echo "Your Squid Proxy password is 					   $SQUIDPASS"
echo "The IP Port being used by Squid Proxy is 				   $SQUIDPORT"
echo "the port remote SSH sessions will be set to is 			   $SSHPORT"
echo "Your DYNDNS host name for your home is set to 			   $FTPHOST"
echo "Your local ftp server username is 				   $FTPUSER"
echo "Your local FTP server password is 				   $FTPPASS"
echo "Your Local FTP directory for Films relative to ftp home directory is $FILMFTPDIR"
echo "Your Local FTP directory for TV relative to ftp home directory is    $TVFTPDIR"
echo "Your Local FTP directory for Music relative to ftp home directory is $MUSICFTPDIR"
echo "Your Local FTP directory for Books relative to ftp home directory is $BOOKSFTPDIR"
echo "Your VPS film dir mount point is 					   $FILMMNTDIR"
echo "Your VPS TV dir mount point is 					   $TVMNTDIR"
echo "your VPS Music dir mount point is 				   $MUSICMNTDIR"




#SET WAN Address
HOSTIP=`ifconfig|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/'`
echo "This script will be using: $HOSTIP as the WAN address of your VPS"

echo "Please check the above information is incorrect" 
echo "If it is not you will need to edit this file. Please exit "
echo "this file when the menu appears shortly."
echo "When you have exited you need to edit this file  in vi"
echo "and edit the first section to meet your requirements"
sleep 10

clear



#### MENU #####

while :
do
    clear
    cat<<EOF
    ==============================
    Marcs VPS install script Menu
    ------------------------------
    Please enter your choice:

    Harden VPS (see readme)     (1)
    Install SabNZB      	(2)
    Install SickBeard   	(3)
    Install Couchpotato 	(4)
    Install Headphones		(5)
    Install Lazy Librarian	(6)
    Install Squid Proxy 	(7)
    Install Transmission	(8)
    Install nZEDb indexer	(9)
    Install Maraschino		(X)
    Create 1GB Swap space	(M)
    Finnished Installing close ssh port 22 and reboot 	(F)
           (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "1")  add-apt-repository ppa:jcfp/ppa
add-apt-repository ppa:transmissionbt/ppa
apt-get update


echo "#######################"
echo "## create a new user ##"
echo "#######################"

echo "we will add a user so we can stop using root, please provide username and password when prompted"
sleep 2
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p $pass $username
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
	fi

echo "username is $username"
sleep 10



#just in case we dont have git
apt-get install git -y

echo "####################"
echo "## installing ufw ##"
echo "####################"
sleep 2
apt-get install ufw -y


echo "###############################"
echo "## opening ports on firewall ##"
echo "###############################"
ufw allow $SSHPORT
echo "opening old ssh port just for now to make sure we dont lose our connetcion"
ufw allow ssh
echo "opening new Sab web UI port"
ufw allow $SABPORT
echo "opening new Sickbeard web UI port"
ufw allow $SICKPORT
echo "opening new Couchpotato web UI port"
ufw allow $COUCHPORT
echo "opening new Headphones web UI port"
ufw allow $HEADPORT
echo "opening new Lazy Librarian web UI port"
ufw allow $BOOKPORT
echo "opening new Squid Proxy server Port"
ufw allow $SQUIDPORT
echo "opening new Transmission web UI Port"
ufw allow $TRANPORT
echo "opening port for Maraschino"
ufw allow $MARAPORT
echo "nZEDb web port"
ufw allow 80
echo "editing sshd config"
sed -i "s/port 22/port $sshport/" /etc/ssh/sshd_config
sed -i "s/protocol 3,2/protocol 2/" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i "s/DebianBanner yes/DebianBanner no/" /etc/ssh/sshd_config
echo "restarting ssh"
sleep 2
/etc/init.d/ssh restart -y
echo "enabling firewall"
sleep 2
ufw enable -y


echo "##########################"
echo "## secure shared memory ##"
echo "##########################"
sleep 2
echo "tmpfs     /run/shm     tmpfs     defaults,noexec,nosuid     0     0" >> /etc/fstab
echo "adding admin group"
sleep 2
groupadd admin
usermod -a -G admin $username
echo "protect su by limiting access to admin group only"
dpkg-statoverride --update --add $username admin 4750 /bin/su


echo "############################################"
echo "# adding $username to sudo and fuse groups #"
echo "############################################"
sleep 3
usermod -a -G sudo $username
usermod -a -G fuse $username 

echo "############################"
echo "## ip spoofing protection ##"
echo "############################"
cat > /etc/host.conf << EOF
order bind,hosts
nospoof on
EOF

echo "##############################"
echo "# Harden Network with sysctl #"
echo "##############################"
sleep 3

cat > /etc/sysctl.conf << EOF
# IP Spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP broadcast requests
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0 
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Block SYN attacks
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5

# Log Martians
net.ipv4.conf.all.log_martians = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0 
net.ipv6.conf.default.accept_redirects = 0

# Ignore Directed pings
net.ipv4.icmp_echo_ignore_all = 1
EOF

sysctl -p


echo "#######################"
echo "# installing fail2ban #"
echo "#######################"
sleep 2
sudo apt-get install fail2ban -y
echo "setting up fail2ban"
sed -i 's/enabled = false/enabled = true/' /etc/fail2ban/jail.conf
sed -i 's/port = sshd/port = $SSHPORT/' /etc/fail2ban/jail.conf
sed -i 's/port = sshd/port = $SSHPORT/' /etc/fail2ban/jail.conf
sed -i 's/maxretry = 5/maxretry = 3/' /etc/fail2ban/jail.conf

echo "##########################"
echo "## creating Diretcories ##"
echo "##########################"
sleep 1
mkdir /home/$username/.pid/
mkdir /home/$username/temp
mkdir /home/downloads
mkdir /home/downloads/completed
mkdir /home/downloads/completed/tv
mkdir /home/downloads/completed/films
mkdir /home/downloads/completed/books
mkdir /home/downloads/completed/music
mkdir /home/downloads/completed/games
mkdir /home/downloads/completed/comics
mkdir /home/downloads/ongoing
mkdir /home/media/
mkdir /home/media/films
mkdir /home/media/tv
mkdir /home/media/music
mkdir /home/media/books
mkdir /home/media/games
mkdir /home/media/comics
mkdir /home/backups/
mkdir /home/backups/sickbeard
mkdir /home/backups/couchpotato
mkdir /home/backups/headphones
mkdir /home/backups/lazylibrarian
mkdir /home/backups/sabnzbd
mkdir /home/backups/comics
mkdir /home/backups/games
chown $username /home/*/*/
chown $username /home/*/*/*
chmod 777  /home/*/*;;
    
    
    "2")  echo "########################"
echo "## installing sabnzbd ##"
echo "########################"
sleep 2
#install python now incase sabnzbsplus install fails
apt-get install python-cheetah -y
apt-get install sabnzbdplus -y
mv /etc/default/sabnzbdplus /home/backups/sabnzbd/sabnzbdplus.orig
echo "change sab config"

cat > /etc/default/sabnzbdplus << EOF
USER=$username
CONFIG=
HOST=$HOSTIP
PORT=$SABPORT
EOF

chmod +x /etc/init.d/sabnzbdplus
echo "starting sabnzbplus"
/etc/init.d/sabnzbdplus start
echo "sabnzbdplus is now running on $HOSTIP:$SABPORT" ;;

    "3")  echo "##########################"
echo "## installing sickbeard ##"
echo "##########################"
sleep 2
cd /home/$username/temp
git clone https://github.com/midgetspy/Sick-Beard.git sickbeard
echo "backing up sickbeard"
cp sickbeard /home/backups/sickbeard
mv sickbeard /home/$username/.sickbeard
#cp /home/$username/.sickbeard/config.ini /etc/default/sickbeard
cp /home/$username/.sickbeard/init.ubuntu /etc/init.d/sickbeard
sudo chmod +x /etc/init.d/sickbeard
cat > /etc/default/sickbeard << EOF
SB_HOME=/home/user/.sickbeard/
SB_DATA=/home/user/.sickbeard/
SB_USER=user
EOF
chmod +x /etc/default/sickbeard
update-rc.d sickbeard defaults
service sickbeard start
echo "CouchPotato has been started on port $COUCHPORT" ;;


    "5") echo "###########################"
echo "## installing Headphones ##"
echo "###########################"
sleep 2
cd /home/$username/temp
git clone https://github.com/rembo10/headphones.git  headphones
cp /home/$username/temp/headphones /home/backups/headphones/
mv /home/$username/temp/headphones /home/$username/.headphones
sudo cp /home/$username/.headphones/init.ubuntu /etc/init.d/headphones
mv /home/$username/.headphones/config.ini /home/$username/.headphones/config.orig
touch /home/$username/.headphones/config.ini
chown $username /home/$username/.headphones/*
chown $username /home/$username/.headphones/*/*
echo "will try and move config probably wont be there"
mv /home/$username/.headphones/config.ini /home/$username/.headphones/config.old
cat > /home/$username/.headphones/config.ini << EOF
[General]
config_version = 5
http_port = $HEADPORT
http_host = $HOSTIP
http_username = $WEBUSER
http_password = $WEBPASS
http_root = /
http_proxy = 0
enable_https = 0
https_cert = /home/$username/.headphones/server.crt
https_key = /home/$username/.headphones/server.key
launch_browser = 1
api_enabled = 0
api_key = ""
log_dir = /home/$username/.headphones/logs
cache_dir = /home/$username/.headphones/cache
git_path = ""
git_user = rembo10
git_branch = master
check_github = 1
check_github_on_startup = 1
check_github_interval = 360
music_dir = /home/music
destination_dir = /home/music
lossless_destination_dir = ""
preferred_quality = 0
preferred_bitrate = ""
preferred_bitrate_high_buffer = ""
preferred_bitrate_low_buffer = ""
preferred_bitrate_allow_lossless = 0
detect_bitrate = 0
auto_add_artists = 1
correct_metadata = 1
move_files = 1
rename_files = 1
folder_format = $Artist/$Album [$Year]
file_format = $Track $Artist - $Album ($Year) - $Title
file_underscores = 0
cleanup_files = 1
add_album_art = 1
album_art_format = folder
embed_album_art = 1
embed_lyrics = 0
nzb_downloader = 0
torrent_downloader = 1
download_dir = /home/completed/music
blackhole_dir = ""
usenet_retention = 1200
include_extras = 0
extras = ""
autowant_upcoming = 1
autowant_all = 0
keep_torrent_files = 0
numberofseeders = 10
torrentblackhole_dir = /home/torrents
isohunt = 0
kat = 1
mininova = 0
piratebay = 1
piratebay_proxy_url = ""
download_torrent_dir = /home/completed/music
search_interval = 360
libraryscan = 1
libraryscan_interval = 1800
download_scan_interval = 5
update_db_interval = 24
mb_ignore_age = 365
preferred_words = ""
ignored_words = ""
required_words = ""
lastfm_username = ""
interface = default
folder_permissions = 0755
file_permissions = 0644
music_encoder = 0
encoder = ffmpeg
xldprofile = ""
bitrate = 192
samplingfrequency = 44100
encoder_path = ""
advancedencoder = ""
encoderoutputformat = mp3
encoderquality = 2
encodervbrcbr = cbr
encoderlossless = 1
delete_lossless_files = 1
mirror = headphones
customhost = localhost
customport = 5000
customsleep = 1
hpuser = 
hppass = 
[Waffles]
waffles = 0
waffles_uid = ""
waffles_passkey = ""
[Rutracker]
rutracker = 0
rutracker_user = ""
rutracker_password = ""
[What.cd]
whatcd = 0
whatcd_username = ""
whatcd_password = ""
[SABnzbd]
sab_host = http://$HOSTIP:$SABPORT/sabnzbd
sab_username = $WEBUSER
sab_password = $WEBPASS
sab_apikey = 
sab_category = Music
[NZBget]
nzbget_username = nzbget
nzbget_password = ""
nzbget_category = ""
nzbget_host = ""
[Headphones]
headphones_indexer = 1
[Transmission]
transmission_host = http://$HOSTIP:$TRANPORT
transmission_username = $WEBUSER
transmission_password = $WEBPASS
[uTorrent]
utorrent_host = ""
utorrent_username = ""
utorrent_password = ""
[Newznab]
newznab = 1
newznab_host = http://
newznab_apikey = 
newznab_enabled = 1
extra_newznabs = 
[NZBsorg]
nzbsorg = 0
nzbsorg_uid = None
nzbsorg_hash = ""
[NZBsRus]
nzbsrus = 0
nzbsrus_uid = ""
nzbsrus_apikey = ""
[omgwtfnzbs]
omgwtfnzbs = 0
omgwtfnzbs_uid = ""
omgwtfnzbs_apikey = ""
[Prowl]
prowl_enabled = 0
prowl_keys = ""
prowl_onsnatch = 0
prowl_priority = 0
[XBMC]
xbmc_enabled = 0
xbmc_host = ""
xbmc_username = ""
xbmc_password = ""
xbmc_update = 0
xbmc_notify = 0
[NMA]
nma_enabled = 0
nma_apikey = ""
nma_priority = 0
nma_onsnatch = 0
[Pushover]
pushover_enabled = 0
pushover_keys = ""
pushover_onsnatch = 0
pushover_priority = 0
[Synoindex]
synoindex_enabled = 0
[Advanced]
album_completion_pct = 80
cache_sizemb = 32
journal_mode = wal
EOF


cp /home/$username/.headphones/config.ini /etc/default/headphones
chown $username /home/$username/.headphones/
chown $username /home/$username/.headphones/*
chown $username /home/$username/.headphones/*/*
chmod 777 /home/$username/.headphones/*
chmod 777 /home/$username/.headphones/logs/headphones.log
chown $username /home/$userna
chmod +x /etc/init.d/headphones  
update-rc.d headphones defaults
echo "starting Headphones on port $HEADPORT"   
python /home/$username/.headphones/Headphones.py --daemon
echo "Headphones has started you can try http://$HOSTIP:$HEADPORT"
sleep 3;;


    "6") echo "##############################"
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
sleep 3;;

    "7") echo "###################################"
echo "## installing squid proxy server ##"
echo "###################################"
sleep 2
sudo apt-get install squid3 squid3-common -y

cat > /etc/squid3/squid.conf << EOF
http_port $SQUIDPORT
via off
forwarded_for off
request_header_access Allow allow all
request_header_access Authorization allow all 
request_header_access WWW-Authenticate allow all 
request_header_access Proxy-Authorization allow all 
request_header_access Proxy-Authenticate allow all 
request_header_access Cache-Control allow all 
request_header_access Content-Encoding allow all 
request_header_access Content-Length allow all 
request_header_access Content-Type allow all 
request_header_access Date allow all 
request_header_access Expires allow all 
request_header_access Host allow all 
request_header_access If-Modified-Since allow all
request_header_access Last-Modified allow all 
request_header_access Location allow all 
request_header_access Pragma allow all 
request_header_access Accept allow all 
request_header_access Accept-Charset allow all 
request_header_access Accept-Encoding allow all 
request_header_access Accept-Language allow all 
request_header_access Content-Language allow all 
request_header_access Mime-Version allow all 
request_header_access Retry-After allow all 
request_header_access Title allow all 
request_header_access Connetcion allow all 
request_header_access Proxy-Connetcion allow all 
request_header_access User-Agent allow all 
request_header_access Cookie allow all 
request_header_access All deny all
http_access allow ncsa_auth
EOF

apt-get install apache2-utils -y
echo "" >> /etc/squid3/squid_passwd
touch /etc/squid3/squid_passwd
chmod 777 /etc/squid3/squid_passwd
htpasswd -b -c /etc/squid3/squid_user $SQUIDUSER $SQUIDPASS
service squid3 stop
service squid3 start
echo "squid started on port $SQUIDPORT #"
sleep 3;;

    "8") echo "##########################"
echo "## install teansmission ##"
echo "##########################"
apt-get install transmission-daemon
mv /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.old

cat > /etc/transmission-daemon/settings.json << EOF
{
 "alt-speed-down": 50,
 "alt-speed-enabled": false,
 "alt-speed-time-begin": 540,
 "alt-speed-time-day": 127,
 "alt-speed-time-enabled": false,
 "alt-speed-time-end": 1020,
 "alt-speed-up": 50,
 "bind-address-ipv4": "$HOSTIP",
 "bind-address-ipv6": "::",
 "blocklist-enabled": true,
 "blocklist-url": "http://list.iblocklist.com/?list=bt_level1&amp;fileformat=p2p&amp;archiveformat=gz",
 "cache-size-mb": 4,
 "dht-enabled": true,
 "download-dir": "/home/$username/complete/",
 "download-limit": 100,
 "download-limit-enabled": 0,
 "encryption": 2,
 "idle-seeding-limit": 30,
 "idle-seeding-limit-enabled": false,
 "incomplete-dir": "/home/$username/ongoing/",
 "incomplete-dir-enabled": true,
 "lpd-enabled": false,
 "max-peers-global": 200,
 "message-level": 2,
 "peer-congestion-algorithm": "",
 "peer-limit-global": 240,
 "peer-limit-per-torrent": 60,
 "peer-port": $TRANPPORT,
 "peer-port-random-high": 65535,
 "peer-port-random-low": 49152,
 "peer-port-random-on-start": false,
 "peer-socket-tos": "default",
 "pex-enabled": true,
 "port-forwarding-enabled": true,
 "preallocation": 1,
 "prefetch-enabled": 1,
 "ratio-limit": 2,
 "ratio-limit-enabled": false,
 "rename-partial-files": true,
 "rpc-authentication-required": true,
 "rpc-bind-address": "0.0.0.0",
 "rpc-enabled": true,
 "rpc-password": "$WEBPASS",
 "rpc-port": "$TRANPORT",
 "rpc-url": "/transmission/",
 "rpc-username": "$WEBUSER",
 "rpc-whitelist": "127.0.0.1",
 "rpc-whitelist-enabled": false,
 "script-torrent-done-enabled": false,
 "script-torrent-done-filename": "",
 "speed-limit-down": 100,
 "speed-limit-down-enabled": false,
 "speed-limit-up": 100,
 "speed-limit-up-enabled": false,
 "start-added-torrents": true,
 "trash-original-torrent-files": false,
 "umask": 18,
 "upload-limit": 100,
 "upload-limit-enabled": 0,
 "upload-slots-per-torrent": 14,
 "utp-enabled": true
}
EOF

service transmission-daemon reload
echo "transmission is now installed and running on $HOSTIP : $TRANPORT"
sleep 3;;

   "9") echo "######################"
echo "## Installing nzedb ##"
echo "######################"
/etc/init.d/apparmor stop
/etc/init.d/apparmor teardown
update-rc.d -f apparmor remove
apt-get install python-setuptools
python -m easy_install
easy_install cymysql
apt-get install -y php5 php5-dev php-pear php5-gd php5-mysqlnd php5-curl
cp /etc/php5/cli/php.ini /home/backup/nzedb/php.ini.back

cat > /etc/php5/cli/php.ini << EOF

EOF

apt-get install mysql-server mysql-client libmysqlclient-dev
sudo apt-get install apache2

cat > /etc/php5/apache2/php.ini << EOF

EOF

cat > /etc/apache2/sites-available/nZEDb << EOF
<VirtualHost *:80>
     ServerName xxxx
     ServerAdmin xxxxx
     ServerAlias xxxx
     DocumentRoot "/var/www/nZEDb/www"
     ErrorLog /var/log/apache2/error.log
     LogLevel warn
     ServerSignature Off

  <Directory "/var/www/nZEDb/www">
         Options FollowSymLinks
         AllowOverride All
         Order allow,deny
         allow from all
  </Directory>

</VirtualHost>
EOF

a2dissite default
a2ensite nZEDb
a2enmod rewrite
service apache2 restart
add-apt-repository ppa:shiki/mediainfo
apt-get update
apt-get install mediainfo
apt-get install lame
git clone https://github.com/nZEDb/nZEDb.git /var/www/
chmod 777 /var/www/nZEDb
cd /var/www/nZEDb
chmod -R 755
sudo chmod 777 /var/www/nZEDb/www/lib/smarty/templates_c
sudo chmod -R 777 /var/www/nZEDb/www/covers
sudo chmod 777 /var/www/nZEDb/www
sudo chmod 777 /var/www/nZEDb/www/install
sudo chmod -R 777 /var/www/nZEDb/nzbfiles
echo "nZEDb is now installed goto $HOSTIP:80 to finnish off install"
sleep 3;;
   
    "X")echo "###########################"
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
echo "Maraschino has been started on $HOSTIP : $MARAPORT";;
    
    
    "0") echo "########################"
echo "# installing curlftpfs #"
echo "########################"
sleep 1
sudo apt-get install curlftpfs


echo "########################"
echo "#   add mount points   #"
echo "########################"
echo "curlftpfs#$FTPUSER:$FTPPASS@$FTPHOST/$FILMFTPDIR /home/media/films fuse auto,user,uid=1000,allow_other,_netdev 0 0" >> /etc/fstab
echo "curlftpfs#$FTPUSER:$FTPPASS@$FTPHOST/$TVFTPDIR /home/media/tv fuse auto,user,uid=1000,allow_other,_netdev 0 0" >> /etc/fstab
echo "curlftpfs#$FTPUSER:$FTPPASS@$FTPHOST/$MUSICFTPDIR /home/media/music fuse auto,user,uid=1000,allow_other,_netdev 0 0" >> /etc/fstab
echo "curlftpfs#$FTPUSER:$FTPPASS@$FTPHOST/$BOOKFTPDIR /home/media/books fuse auto,user,uid=1000,allow_other,_netdev 0 0" >> /etc/fstab
echo "curlftpfs#$FTPUSER:$FTPPASS@$FTPHOST/$GAMEFTPDIR /home/media/games fuse auto,user,uid=1000,allow_other,_netdev 0 0" >> /etc/fstab
echo "curlftpfs#$FTPUSER:$FTPPASS@$FTPHOST/$COMICSFTPDIR /home/media/comics fuse auto,user,uid=1000,allow_other,_netdev 0 0" >> /etc/fstab
echo "Curlftpfs has been installed check /etc/fstab for settings"
sleep 3;;


    "M")echo "######################"
echo "# add 1GB swap space #"
echo "######################"
sleep 1
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024k
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile       none    swap    sw      0       0" >> /etc/fstab
echo 0 | sudo tee /proc/sys/vm/swappiness
echo vm.swappiness = 0 | sudo tee -a /etc/sysctl.conf
echo "Your 1gb swap space has been created"
sleep 3;;

    "F") ufw deny 22
echo "SSH port is now closed please use $SSHPORT for SSH connection from now on"
sleep 3
echo "Rebooting"
sleep 2
shutdown -r now;;

    "Q")  exit                      ;;
    "q")  echo "case sensitive!!"   ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
