#!/bin/bash

############################################################################
######## You must change all the variables below to suit your setup ########
######## alot you can leave default like the port numbers but       ########
######## usernames hostnames ip adresses must be set by you so have ########
######## a look below...                                  			    ########
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
