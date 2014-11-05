menu-test-with-nzb1
===================

This is an install Script for a clean kvm vps install running ubuntu 12.04 minimal it will install any or all of the following Sabnzb, Transmision, Headphones, Sickbeard, Couchpotato, LazyLibrarian, Mylar, Gamez, Maraschino Fail2ban setup for ssh curlftps for mount points back to your local media UFW for easy firewall config squidproxy for anonymous web browsing proxy server useful in the uk and other steps to secure your vps like changing ssh port

This script attempts to install all necessary components and set them up from the information given in the start of the menu.sh.

Before you start you will need  to edit menu.sh things you may need are one ore two dyndns/no-ip name(s) for your home and vps, a newzgroup account or two, access to other nzb indexers, you may also install an ftp server on your file server with port forwarding on your router. With that in place you will be able to run all your nzb downloads on your vps then once the download is complete the post processing  of sickbeard, couchpotato ect will rename and move the files to your media collection on your local storage with the help of curlftps and some mount points this script will create. That then gives you a seemless experience with your VPS and local file storage.


To install get a kvm vps from ramnode https://clientarea.ramnode.com/aff.php?aff=838 reinstall the os with ubuntu 12.04 LTS minimal

log on as root you should change the root password now with "passwd" and then copy paste the following:

apt-get install git -y

git clone https://github.com/Brownster/menu-test-with-nzb1.git menush

cd menush

chmod 777 *.*

vi settings.sh

You will then need to edit the following details:

DYNDNS=someplace.dydns-remote.com (for vps server)

WEBUSER=webuser

WEBPASS=webpass

SQUIDUSER=squid (if you select to have a private proxy running on your vps)

SQUIDPASS=hideme

SQUIDPORT=7629

SSHPORT=2022

FTPHOST=somewhere.dyndns-remote.com (for your home)

FTPUSER=ftpuser (ftp user account accessible from the vps)

FTPPASS=ftppass

FILMFTPDIR=films (all ftp directories are relative to the home directory of the ftp account)

TVFTPDIR=tvseries

MUSICFTPDIR=music

BOOKSFTPDIR=ebooks

FILMMNTDIR=/home/media/films

TVMNTDIR=/home/media/tv

MUSICMNTDIR=/home/media/music

BOOKSMNTDIR=/home/media/books

SABPORT=7960

SICKPORT=7961

COUCHPORT=7962

HEADPORT=7963

BOOKPORT=7964

GAMESPORT=7965

MYLARPORT=7966

MARAPORT=7967

After that save the file by typing Esc :wq and press enter then run the script by typing:

./menu.sh

You will be prompted for a new username and password this script will create a user to stop havingto use root.

You will also be prompted to confirm a couple of steps but apart form that it will take care of the rest. I also recommend you set up the local ftp shares before you start so when we mount the ftp shares it works and doesnt hang for 10 mins

https://camo.githubusercontent.com/452ec59fcc4d6c3472f5729e453c03f4961eca1c/687474703a2f2f7777772e72616d6e6f64652e636f6d2f696d616765732f62616e6e6572732f61666662616e6e65726461726b2e706e67
