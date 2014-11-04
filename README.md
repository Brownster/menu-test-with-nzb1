menu-test-with-nzb1
===================
To install get a kvm vps from ramnode https://clientarea.ramnode.com/aff.php?aff=838 reinstall the os with ubuntu 12.04 LTS minimal

log on as root you should change the root password now with "passwd" and then copy paste the following:

apt-get install git -y

git clone https://github.com/Brownster/menu-test-with-nzb1.git menush

cd menush

chmod 777 menu.sh

vi menu.sh

You will then need to edit the following details:

DYNDNS=someplace.dydns-remote.com

WEBUSER=webuser

WEBPASS=webpass

SQUIDUSER=squid

SQUIDPASS=hideme

SQUIDPORT=7629

SSHPORT=2022

FTPHOST=somewhere.dyndns-remote.com

FTPUSER=ftpuser

FTPPASS=ftppass

FILMFTPDIR=films

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

After that save the file by typing :wq and press enter then run the script by typing:

./menu.sh

You will be prompted for a new username and password this script will create a user to stop havingto use root.

You will also be prompted to confirm a couple of steps but apart form that it will take care of the rest. I also recommend you set up the local ftp shares before you start so when we mount the ftp shares it works and doesnt hang for 10 mins

https://camo.githubusercontent.com/452ec59fcc4d6c3472f5729e453c03f4961eca1c/687474703a2f2f7777772e72616d6e6f64652e636f6d2f696d616765732f62616e6e6572732f61666662616e6e65726461726b2e706e67
