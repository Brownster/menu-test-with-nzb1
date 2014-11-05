#!/bin/bash
source settings.sh

echo "the current setting for your DNS Host name for your VPS is Currently  $DYNDNS"
echo "Your current username for all web apps is                             $WEBUSER"
echo "Your current web app password id 					                    $WEBPASS"
echo "Squid Proxy User name is 						                        $SQUIDUSER"
echo "Your Squid Proxy password is 					                        $SQUIDPASS"
echo "The IP Port being used by Squid Proxy is 				                $SQUIDPORT"
echo "the port remote SSH sessions will be set to is 			            $SSHPORT"
echo "Your DYNDNS host name for your home is set to 			            $FTPHOST"
echo "Your local ftp server username is 				                    $FTPUSER"
echo "Your local FTP server password is 				                    $FTPPASS"
echo "Your Local FTP directory for Films relative to ftp home directory is  $FILMFTPDIR"
echo "Your Local FTP directory for TV relative to ftp home directory is    `$TVFTPDIR"
echo "Your Local FTP directory for Music relative to ftp home directory is  $MUSICFTPDIR"
echo "Your Local FTP directory for Books relative to ftp home directory is  $BOOKSFTPDIR"
echo "Your VPS film dir mount point is 					                    $FILMMNTDIR"
echo "Your VPS TV dir mount point is 					                    $TVMNTDIR"
echo "your VPS Music dir mount point is 				                    $MUSICMNTDIR"
echo "the port used by SABNZB will be                                       $SABPORT"                   
echo "the port used by Sickbeard will be                                    $SICKPORT"
echo "the port used by Couchpotato will be                                  $COUCHPORT"
echo "the port used by Headphones will be                                   $HEADPORT"
echo "the port used by Lazy Librarian will be                               $BOOKPORT"
echo "the port used by MYLAR will be                                        $MYLARPORT"
echo "the port for Gamez web ui will be                                     $GAMESPORT"
echo "the port for transmission web ui is                                   $TRANPORT"

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
    Install Sick atomic     (S)
    Install Jonnyboy nzedb  (N)
           (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "1") source ./harden.sh ;;

    "2") source ./sabnzb.sh ;;

    "3")  source ./sick.sh ;;

    "P") source ./post.sh ;;

    "5") source ./head.sh ;;

    "6") source ./lazy.sh ;;

    "7") source ./squid.sh ;;

    "8") source ./trans.sh ;;

    "9") source ./nzedb.sh ;;
   
    "M") source ./mara.sh ;;
    
    "0") source ./curlftp.sh ;;
    
    "M") source ./mara.sh ;;
    
    "S") source ./sick2.sh ;;
    
    "N" source ./nzb2.sh ;;
    "Q")  exit                      ;;
    "q")  echo "case sensitive!!"   ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
