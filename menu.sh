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
    Install Post Process Script (P)
    Create 1GB Swap space	(M)
    Finnished Installing close ssh port 22 and reboot 	(F)
           (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "1") source ./harden.sh;;

    "2") source ./sabnzb.sh ;;

    "3")  source ./sick.sh ;;

    "P") source ./post.sh ;;

    "5") source ./head.sh ;;

    "6") source ./lazy.sh;;

    "7") source ./squid.sh ;;

    "8") source ./trans.sh ;;

   "9") source ./nzedb.sh ;;
   
    "X") source ./mara.sh ;;
    
    "0") source curlftp.sh ;;
    
    "M");;

    "Q")  exit                      ;;
    "q")  echo "case sensitive!!"   ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
