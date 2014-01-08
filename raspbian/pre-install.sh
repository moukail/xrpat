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
DEFSRVPWD="secret"
EOF
echo "xrpat: Please edit $HOME/xrpat.conf and re-run $0"
exit 1
fi

echo "xrpat: Configuring network interfaces..."
cat << EOF | sudo tee /etc/network/interfaces > /dev/null
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

echo "xrpat: Configuring WPA supplicant..."
cat << EOF | sudo tee /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null
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

echo "xrpat: Configuring hostname..."
cat << EOF | sudo tee /etc/hostname > /dev/null
$RPIHOSTNAME
EOF

echo "xrpat: Configuring SSH authorized_keys..."
cd $HOME && mkdir -p .ssh && cd .ssh && cat > authorized_keys << EOF
$SSHKEY
EOF
cd $HOME && cd .ssh && chmod 400 authorized_keys

echo "xrpat: Configuring kernel modules..."
sudo /bin/rm -f /etc/modprobe.d/raspi-blacklist.conf
cat << EOF | sudo tee /etc/modules > /dev/null
i2c-bcm2708
i2c-dev
EOF
sudo modprobe i2c-bcm2708 && sudo modprobe i2c-dev

echo "xrpat: Configuring timezone..."
echo 'Europe/Berlin' | sudo tee /etc/timezone > /dev/null
sudo cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

exit 0
