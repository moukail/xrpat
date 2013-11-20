#!/bin/sh

#
# Installation script for Raspbian on Raspberry Pi.
# This file is part of xrpat. See https://github.com/wolfcw/xrpat
#

# Configuration:
XRPATPATH=$HOME/git/xrpat


# Automated installation:

echo "Updating system settings..."
$XRPATPATH/raspbian/pre-install.sh || exit 1


echo "Installing software packages..."
sudo apt-get update
sudo apt-get upgrade
for x in $(cat $XRPATPATH/raspbian/packages.txt | egrep -v '^#') ; do
    sudo apt-get -y install $x
done


echo "Setting up environment..."
$XRPATPATH/generic/post-install.sh || exit 1


echo "Finished."
