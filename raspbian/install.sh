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
