#!/bin/bash

echo "the current setting for your DNS Host name for your VPS is Currently $DYNDNS"
#DYNDNS / noip host name that resolves into your vps ip address
DYNDNS=someplace.dydns-remote.com

echo "Your current username for all web apps is $WEBUSER"
#Please enter a user name for accessing sickbeard, couchpotato ect
WEBUSER=webuser

echo "Your current web app password id $WEBPASS"
#Please enter a password for accessing all the web apps sickbeard, couchpotato ect
WEBPASS=webpass

echo "Squid Proxy User name is $SQUIDUSER"
#Please enter a Username for Squid Proxy Server
SQUIDUSER=squid

echo "Your Squid Proxy password is $SQUIDPASS"
#Please enter a password for Squid Proxy Server
SQUIDPASS=hideme

echo "The IP Port being used by Squid Proxy is $SQUIDPORT"
#squid Proxy please enter the port for web access
SQUIDPORT=7629

echo "the port remote SSH sessions will be set to is $SSHPORT"
#SSH please enter the port for access
SSHPORT=2022

echo "Your DYNDNS host name for your home is set to $FTPHOST"
#FTP server address eith ip address if you have static address or 
#dyn dns / no ip account resolving to your home ip if you are dynamic
FTPHOST=somewhere.dyndns-remote.com

echo "Your local ftp server username is $FTPUSER"
#ftp user
FTPUSER=ftpuser

echo "Your local FTP server password is $FTPPASS"
#ftp password
FTPPASS=ftppass

echo "Your Local FTP directory for Films relative to ftp home directory is $FILMFTPDIR"
#film ftp location - relative to ftp home directory
FILMFTPDIR=films

echo "Your Local FTP directory for TV relative to ftp home directory is $TVFTPDIR"
#TV ftp location
TVFTPDIR=tvseries

echo "Your Local FTP directory for Music relative to ftp home directory is $MUSICFTPDIR"
#Music ftp location
MUSICFTPDIR=music

echo "Your Local FTP directory for Books relative to ftp home directory is $BOOKSFTPDIR"
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

echo "Your VPS film dir mount point is $FILMMNTDIR"
#films mount location
FILMMNTDIR=/home/media/films

echo "Your VPS TV dir mount point is $TVMNTDIR"
#tv series mount location
TVMNTDIR=/home/media/tv

echo "your VPS Music dir mount point is $MUSICMNTDIR"
#music mount location
MUSICMNTDIR=/home/media/music

#books mount location
BOOKSMNTDIR=/home/media/books


## OPTIONAL TO CHANGE BELOW BUT RECOMMENDED ##

#SABNZB Please enter the port for web access
SABPORT=7960

#SICKBEARD Please enter the port for web access
SICKPORT=7961

#COUCHPOTATO Please enter the port for web access
COUCHPORT=7962

#Headphones Please enter the port for web access
HEADPORT=7963

#Lazy Librarian Please enter the port for web access
BOOKPORT=7964

#Mylar Please enter the port for web access
MYLARPORT=7965

#Gamez Please enter the port for web access
GAMESPORT=7966

#Transmission RPC Port (web ui)
TRANPORT=7967

#Transmission peer port
TRANPPORT=61724

#Maraschino Web UI port
MARAPORT=7979


echo "if any of the above information is incorrect please quit this scrpit open it in vi and edit the first section to your requirements"
clear

#### MENU #####

while :
do
    clear
    cat<<EOF
    ==============================
    Install Menu For Sabnzb VPS
    ------------------------------
    Please enter your choice:

    Harden VPS          (1)
    Install SabNZB      (2)
    Install SickBeard   (3)
    Install Couchpotato (4)
    Install Headphones	(5)
    Install NZB indexer (6)
           (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "1")  add-apt-repository ppa:jcfp/ppa
add-apt-repository ppa:transmissionbt/ppa
apt-get update
HOSTIP=`ifconfig|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/'`
echo "i will be using: $HOSTIP as the WAN address"

echo "#######################"
echo "## create a new user ##"
echo "#######################"

echo "we will add a user so we can stop using root, please provide username and password when prompted"
sleep2
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

#just in case we dont have git
apt-get install git -y
#install python now incase sabnzbsplus install fails
apt-get install python-cheetah -y

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
usermod -a -G fuse $username ;;
    
    
    "2")  echo "########################"
echo "## installing sabnzbd ##"
echo "########################"
sleep 2
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

cat > /etc/default/sickbeard << EOF
[General]
config_version = 4
log_dir = Logs
web_port = $SICKPORT
web_host = $HOSTIP
web_ipv6 = 0
web_log = 0
web_root = ""
web_username = $WEBUSER
web_password = $WEBPASS
anon_redirect = http://dereferer.org/?
use_api = 0
api_key = ""
enable_https = 0
https_cert = server.crt
https_key = server.key
use_nzbs = 1
use_torrents = 0
nzb_method = sabnzbd
usenet_retention = 500
search_frequency = 60
download_propers = 1
quality_default = 164
status_default = 5
flatten_folders_default = 0
provider_order = sick_beard_index womble_s_index
version_notify = 1
naming_pattern = Season %0S/%SN %EN S%0SE%0E
naming_custom_abd = 0
naming_abd_pattern = ""
naming_multi_ep = 1
launch_browser = 1
use_banner = 0
use_listview = 0
metadata_xbmc = 0|0|0|0|0|0
metadata_xbmc_12plus = 1|1|1|1|1|1
metadata_mediabrowser = 0|0|0|0|0|0
metadata_ps3 = 0|0|0|0|0|0
metadata_wdtv = 0|0|0|0|0|0
metadata_tivo = 0|0|0|0|0|0
metadata_synology = 0|0|0|0|0|0
cache_dir = cache
root_dirs = 0|/home/tv|
tv_download_dir = ""
keep_processed_dir = 0
move_associated_files = 1
process_automatically = 0
rename_episodes = 1
create_missing_show_dirs = 0
add_shows_wo_dir = 0
extra_scripts = ""
git_path = ""
ignore_words = "german,french,core2hd,dutch,swedish,480p"
[Blackhole]
nzb_dir = ""
torrent_dir = ""
[EZRSS]
ezrss = 0
[HDBITS]
hdbits = 0
hdbits_username = ""
hdbits_passkey = ""
[TVTORRENTS]
tvtorrents = 0
[TVTORRENTS]
tvtorrents = 0
tvtorrents_digest = ""
tvtorrents_hash = ""
[BTN]
btn = 0
btn_api_key = ""
[TorrentLeech]
torrentleech = 0
torrentleech_key = ""
[NZBs]
nzbs = 0
nzbs_uid = ""
nzbs_hash = ""
[Womble]
womble = 1
[omgwtfnzbs]
omgwtfnzbs = 0
omgwtfnzbs_username = ""
omgwtfnzbs_apikey = ""
[SABnzbd]
sab_username = $WEBUSER
sab_password = $WEBPASS
sab_apikey = 
sab_category = tv
sab_host = http://$HOSTIP:$SABPASS/
[NZBget]
nzbget_password = 
nzbget_category = tv
nzbget_host = ""
[XBMC]
use_xbmc = 0
xbmc_notify_onsnatch = 0
xbmc_notify_ondownload = 0
xbmc_update_library = 0
xbmc_update_full = 0
xbmc_update_onlyfirst = 0
xbmc_host = ""
xbmc_username = ""
xbmc_password = ""
[Plex]
use_plex = 0
plex_notify_onsnatch = 0
plex_notify_ondownload = 0
plex_update_library = 0
plex_server_host = ""
plex_host = ""
plex_username = ""
plex_password = ""
[Growl]
use_growl = 0
growl_notify_onsnatch = 0
growl_notify_ondownload = 0
growl_host = ""
growl_password = ""
[Prowl]
use_prowl = 0
prowl_notify_onsnatch = 0
prowl_notify_ondownload = 0
prowl_api = ""
prowl_priority = 0
[Twitter]
use_twitter = 0
twitter_notify_onsnatch = 0
twitter_notify_ondownload = 0
twitter_username = ""
twitter_password = ""
twitter_prefix = Sick Beard
[Boxcar]
use_boxcar = 0
boxcar_notify_onsnatch = 0
boxcar_notify_ondownload = 0
boxcar_username = ""
[Pushover]
use_pushover = 0
pushover_notify_onsnatch = 0
pushover_notify_ondownload = 0
pushover_userkey = ""
[Libnotify]
use_libnotify = 0
libnotify_notify_onsnatch = 0
libnotify_notify_ondownload = 0
[NMJ]
use_nmj = 0
nmj_host = ""
nmj_database = ""
nmj_mount = ""
[Synology]
use_synoindex = 0
[NMJv2]
use_nmjv2 = 0
nmjv2_host = ""
nmjv2_database = ""
nmjv2_dbloc = ""
[Trakt]
use_trakt = 0
trakt_username = ""
trakt_password = ""
trakt_api = ""
[pyTivo]
use_pytivo = 0
pytivo_notify_onsnatch = 0
pytivo_notify_ondownload = 0
pyTivo_update_library = 0
pytivo_host = ""
pytivo_share_name = ""
pytivo_tivo_name = ""
[NMA]
use_nma = 0
nma_notify_onsnatch = 0
nma_notify_ondownload = 0
nma_api = ""
nma_priority = 0
[Newznab]
newznab_data = "Sick Beard Index|http://lolo.sickbeard.com/|0|5030,5040|1!!!NZBs.org|http://nzbs.org/||5030,5040,5070,5090|"
[GUI]
coming_eps_layout = banner
coming_eps_display_paused = 0
coming_eps_sort = date
EOF

mv /home/castro/.sickbeard/config.ini /home/castro/.sickbeard/config.old
cp /etc/default/sickbeard /home/castro/.sickbeard/config.ini
chown $username /etc/init.d/sickbeard
chown $username /home/$username/.sickbeard/*
chmod +x /etc/init.d/sickbeard
sudo update-rc.d sickbeard defaults
chmod 777 /home/$username/.sickbeard/
sudo /etc/init.d/sickbeard stop
sudo /etc/init.d/sickbeard start
echo "sick beard is now running on $HOSTIP:$SICKPORT" ;;


    "4")  echo "#############################"
echo "## installling Couchpotato ##"
echo "#############################"
sleep 2
cd /home/$username/temp
git clone https://github.com/RuudBurger/CouchPotatoServer.git couchpotato
cp couchpotato /home/$username/backups/couchpotato
mv couchpotato /home/$username/.couchpotato
cp /home/$username/.couchpotato/init/ubuntu /etc/init.d/couchpotato

cat > /etc/default/couchpotato << EOF
# COPY THIS FILE TO /etc/default/couchpotato 
# OPTIONS: CP_HOME, CP_USER, CP_DATA, CP_PIDFILE, PYTHON_BIN, CP_OPTS, SSD_OPTS

CP_HOME=/home/$username/.couchpotato
CP_USER=$username
CP_DATA=/home/$username/.config/couchpotato
CP_PIDFILE=/home/$username/.pid/couchpotato.pid
EOF

cat > /home/castro/.pid/couchpotato.pid << EOF
50004
EOF

chmod +x /etc/init.d/couchpotato
update-rc.d couchpotato defaults
chmod 777 /home/$username/.couchpotato/
echo "starting couchpotato"
python /home/$username/.couchpotato/CouchPotato.py --daemon
echo "CouchPotato has been started on port $COUCHPORT" ;;

    "Q")  exit                      ;;
    "q")  echo "case sensitive!!"   ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
