#!/bin/sh

#
# Installation script for Raspbian on Raspberry Pi.
# This file is part of xrpat. See https://github.com/wolfcw/xrpat
#

if [ -f "$HOME/xrpat.conf" ] ; then
    . "$HOME/xrpat.conf"
else
cat > "$HOME/xrpat.conf" << EOF
SSIDNAME="changeme"
WLAN0PSK="secret"
RPIHOSTNAME="newPi"
SSHKEY="none"
EOF
echo "Please edit $HOME/xrpat.conf and re-run $0"
exit 1
fi

echo "Configuring network interfaces..."
sudo cat > /etc/network/interfaces << EOF
auto lo
iface lo inet loopback
iface eth0 inet dhcp

auto wlan0
allow-hotplug wlan0
iface wlan0 inet manual
wpa-ap-scan 1
wpa-scan-ssid 1
wpa-ssid "$SSIDNAME"
wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet dhcp
EOF

echo "Configuring WPA supplicant..."
sudo cat > /etc/wpa_supplicant/wpa_supplicant.conf << EOF
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
        ssid="$SSIDNAME"
        psk=$WLAN0PSK
        scan_ssid=1
        key_mgmt=WPA-PSK
        proto=RSN
        pairwise=CCMP
        group=TKIP
}
EOF

echo "Configuring hostname..."
sudo cat > /etc/hostname << EOF
$RPIHOSTNAME
EOF

echo "Configuring SSH authorized_keys..."
cd $HOME && mkdir -p .ssh && cd .ssh && cat > authorized_keys << EOF
$SSHKEY
EOF
cd $HOME && cd .ssh && chmod 400 authorized_keys

echo "Configuring kernel modules..."
sudo /bin/rm -f /etc/modprobe.d/raspi-blacklist.conf
sudo cat >> /etc/modules << EOF
i2c-bcm2708
i2c-dev
EOF
sudo modprobe i2c-bcm2708 && sudo modprobe i2c-dev

echo "Configuring timezone..."
sudo echo 'Europe/Berlin' > /etc/timezone
sudo cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

exit 0
