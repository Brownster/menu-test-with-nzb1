#!/bin/bash
echo "######################"
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
sleep 3
