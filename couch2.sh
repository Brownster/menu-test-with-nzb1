#!/bin/bash
# Script Name: AtoMiC CouchPotato installer
# Author: Anand Subramanian
# Publisher: http://www.htpcBeginner.com
# Version: 1.0 (March 29, 2013) - Initial release
# Version: 1.1 (October 03, 2013) - Bugfixes
# Version: 2.0 (April 13, 2014) - Updated script to work with Trusty Tahr
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

# DO NOT EDIT ANYTHING UNLESS YOU KNOW WHAT YOU ARE DOING.
clear
echo 'Version: 2.0 (April 13, 2014)'
echo '--->CouchPotato installation will start soon. Please read the following carefully.'
echo '1. The script has been confirmed to work on Ubuntu and other Ubuntu based distros, including Mint, Kubuntu, Lubuntu, and Xubuntu.'
echo '2. While several testing runs identified no known issues, www.htpcBeginner.com or the author cannot be held accountable for any problems that might occur due to the script.'
echo '3. If you did not run this script with sudo, you maybe asked for your root password during installation.'
echo '4. If git and python are not installed they will be installed during the process. These packages are required for CouchPotato to run.'

echo

read -p "Press y/Y and enter to AGREE and continue with the installation or any other key to exit: "
RESP=${REPLY,,}
if [ "$RESP" != "y" ]
then
	echo 'So you chickened out. May be you will try again later.'
	echo
	exit 0
fi

echo 

read -p "Enter the username of the user you want to run CouchPotato as. Typically, this is your username (IMPORTANT! Ensure correct spelling and case): "
UNAME=${REPLY,,}

if [ ! -d "/home/$UNAME" ]; then
  echo 'Bummer! You may not have entered your username correctly. Exiting now. Please rerun script.'
  echo
  exit 0
fi

echo

echo '--->Updating Packages...'
sudo apt-get update
echo

echo '--->Installing git and python...'
sudo apt-get -y install git-core python python-cheetah
echo

echo '--->Checking for previous versions of CouchPotato...'
sleep 2
sudo /etc/init.d/couchpotato* stop >/dev/null 2>&1
sudo killall couchpotato* >/dev/null 2>&1
echo '--->Any running CouchPotato processes killed'
sudo update-rc.d -f couchpotato remove >/dev/null 2>&1
sudo rm /etc/init.d/couchpotato >/dev/null 2>&1
sudo rm /etc/default/couchpotato >/dev/null 2>&1
echo '--->Existing CouchPotato init scripts removed'
sudo update-rc.d -f couchpotato remove >/dev/null 2>&1
mv /home/$UNAME/.couchpotato /home/$UNAME/.couchpotato_`date '+%m-%d-%Y_%H-%M'` >/dev/null 2>&1
echo '--->Any existing CouchPotato files were moved to /home/'$UNAME'/.couchpotato_'`date '+%m-%d-%Y_%H-%M'`
echo

echo '--->Downloading latest CouchPotato...'
sleep 2
cd /home/$UNAME
git clone git://github.com/RuudBurger/CouchPotatoServer.git .couchpotato
chmod 775 -R /home/$UNAME/.couchpotato >/dev/null 2>&1
sudo chown $UNAME: /home/$UNAME/.couchpotato >/dev/null 2>&1
echo

echo '--->Creating new default and init scripts...'
sleep 2
cd /home/$UNAME/.couchpotato/init
echo

echo "# COPY THIS FILE TO /etc/default/couchpotato" >> couchpotato
echo "# OPTIONS: CP_HOME, CP_USER, CP_DATA, CP_PIDFILE, PYTHON_BIN, CP_OPTS, SSD_OPTS" >> couchpotato
echo '--->Replacing CouchPotato APP_PATH and DATA_DIR...'
sleep 1
echo "CP_HOME=/home/"$UNAME"/.couchpotato/" >> couchpotato
echo "CP_DATA=/home/"$UNAME"/.couchpotato/" >> couchpotato
echo '--->Enabling current user ('$UNAME') to run CouchPotato...'
echo "CP_USER="$UNAME >> couchpotato
sudo mv couchpotato /etc/default/
sudo chmod +x /etc/default/couchpotato

echo
echo '--->Copying init script...'
sleep 1
sudo cp ubuntu /etc/init.d/couchpotato
sudo chown $UNAME: /etc/init.d/couchpotato
sudo chmod +x /etc/init.d/couchpotato

echo '--->Updating rc.d to start CouchPotato at boot time...'
sudo update-rc.d couchpotato defaults
echo
echo '--->All done.'
echo 'CouchPotato should start within 10-20 seconds and your browser should open.'
echo 'If not you can start it using "sudo /etc/init.d/couchpotato start" command.'
echo 'Then open http://localhost:5050 in your browser.'
echo
echo '***If this script worked for you, please visit http://www.htpcBeginner.com and like/follow us.'
echo 'Thank you for using the CouchPotato installer script from www.htpcBeginner.com.***'
echo
/etc/init.d/couchpotato start
