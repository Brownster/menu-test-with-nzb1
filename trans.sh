#!/usr/bin/env bash
echo "##########################"
echo "## install teansmission ##"
echo "##########################"
apt-get install transmission-daemon
mv /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.old

cat > /etc/transmission-daemon/settings.json << EOF
{
 "alt-speed-down": 50,
 "alt-speed-enabled": false,
 "alt-speed-time-begin": 540,
 "alt-speed-time-day": 127,
 "alt-speed-time-enabled": false,
 "alt-speed-time-end": 1020,
 "alt-speed-up": 50,
 "bind-address-ipv4": "$HOSTIP",
 "bind-address-ipv6": "::",
 "blocklist-enabled": true,
 "blocklist-url": "http://list.iblocklist.com/?list=bt_level1&amp;fileformat=p2p&amp;archiveformat=gz",
 "cache-size-mb": 4,
 "dht-enabled": true,
 "download-dir": "/home/$username/complete/",
 "download-limit": 100,
 "download-limit-enabled": 0,
 "encryption": 2,
 "idle-seeding-limit": 30,
 "idle-seeding-limit-enabled": false,
 "incomplete-dir": "/home/$username/ongoing/",
 "incomplete-dir-enabled": true,
 "lpd-enabled": false,
 "max-peers-global": 200,
 "message-level": 2,
 "peer-congestion-algorithm": "",
 "peer-limit-global": 240,
 "peer-limit-per-torrent": 60,
 "peer-port": $TRANPPORT,
 "peer-port-random-high": 65535,
 "peer-port-random-low": 49152,
 "peer-port-random-on-start": false,
 "peer-socket-tos": "default",
 "pex-enabled": true,
 "port-forwarding-enabled": true,
 "preallocation": 1,
 "prefetch-enabled": 1,
 "ratio-limit": 2,
 "ratio-limit-enabled": false,
 "rename-partial-files": true,
 "rpc-authentication-required": true,
 "rpc-bind-address": "0.0.0.0",
 "rpc-enabled": true,
 "rpc-password": "$WEBPASS",
 "rpc-port": "$TRANPORT",
 "rpc-url": "/transmission/",
 "rpc-username": "$WEBUSER",
 "rpc-whitelist": "127.0.0.1",
 "rpc-whitelist-enabled": false,
 "script-torrent-done-enabled": false,
 "script-torrent-done-filename": "",
 "speed-limit-down": 100,
 "speed-limit-down-enabled": false,
 "speed-limit-up": 100,
 "speed-limit-up-enabled": false,
 "start-added-torrents": true,
 "trash-original-torrent-files": false,
 "umask": 18,
 "upload-limit": 100,
 "upload-limit-enabled": 0,
 "upload-slots-per-torrent": 14,
 "utp-enabled": true
}
EOF

service transmission-daemon reload
echo "transmission is now installed and running on $HOSTIP : $TRANPORT"
sleep 3
