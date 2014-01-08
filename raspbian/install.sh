#!/bin/sh

#
# Installation script for Raspbian on Raspberry Pi.
# This file is part of xrpat. See https://github.com/wolfcw/xrpat
#

# Configuration:
XRPATPATH=$HOME/git/xrpat


# Automated installation:

echo "xrpat: Updating system settings..."
$XRPATPATH/raspbian/pre-install.sh || exit 1


echo "xrpat: Installing software packages..."

if [ -f "$HOME/xrpat.conf" ] ; then
    . "$HOME/xrpat.conf"
else
    DEFSRVPWD="changemerealsoonplz"
    RPIHOSTNAME="newPi"
fi

echo "mysql-server mysql-server/root_password password $DEFSRVPWD" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DEFSRVPWD" | sudo debconf-set-selections

echo 'phpmyadmin phpmyadmin/dbconfig-install boolean false' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password $DEFSRVPWD' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password $DEFSRVPWD' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/password-confirm password $DEFSRVPWD' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/setup-password password $DEFSRVPWD' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/database-type select mysql' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password $DEFSRVPWD' | sudo debconf-set-selections
echo 'dbconfig-common dbconfig-common/mysql/app-pass password $DEFSRVPWD' | sudo debconf-set-selections
echo 'dbconfig-common dbconfig-common/password-confirm password $DEFSRVPWD' | sudo debconf-set-selections
echo 'dbconfig-common dbconfig-common/app-password-confirm password $DEFSRVPWD' | sudo debconf-set-selections
echo 'dbconfig-common dbconfig-common/password-confirm password $DEFSRVPWD' | sudo debconf-set-selections

echo "icecast2 icecast2/icecast-setup boolean true" | sudo debconf-set-selections
echo "icecast2 icecast2/adminpassword string $DEFSRVPWD" | sudo debconf-set-selections
echo "icecast2 icecast2/sourcepassword string $DEFSRVPWD" | sudo debconf-set-selections
echo "icecast2 icecast2/relaypassword string $DEFSRVPWD" | sudo debconf-set-selections
echo "icecast2 icecast2/hostname string $DEFSRVPWD" | sudo debconf-set-selections

echo "proftpd-basic shared/proftpd/inetd_or_standalone select standalone" | sudo debconf-set-selections

sudo apt-get -y update
sudo apt-get -y upgrade
for x in $(cat $XRPATPATH/raspbian/packages.txt | egrep -v '^#') ; do
    echo "xrpat: Installing package $x..."
    sudo apt-get -y install $x
    echo " "
done


# echo "Setting up environment..." # done from bootstrap.sh
# $XRPATPATH/generic/post-install.sh || exit 1


echo "xrpat: Finished."
