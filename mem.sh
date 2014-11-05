#!/usr/bin/env bash
echo "######################"
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
shutdown -r now
