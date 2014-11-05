#!/bin/bash
echo "########################"
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
sleep 3
