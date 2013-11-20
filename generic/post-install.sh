#!/bin/sh

#
# Installation script for Raspbian on Raspberry Pi.
# This file is part of xrpat. See https://github.com/wolfcw/xrpat
#

# Configuration:
XRPATPATH=$HOME/git/xrpat


echo "Checking out software source code..."
cd && mkdir -p git && cd git && mkdir -p 3rd_party && cd 3rd_party

git clone http://github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code.git
git clone git://github.com/amperka/ino.git
    cd ino && sudo python2.7 setup.py install --root / --prefix /usr/local --exec-prefix /usr/local && cd ..
git clone https://github.com/Gadgetoid/WiringPi2-Python.git
cvs -z3 -d:pserver:anonymous@lcdproc.cvs.sourceforge.net:/cvsroot/lcdproc checkout -P lcdproc
git clone https://github.com/adafruit/DHT-sensor-library.git
git clone https://github.com/tompreston/MPD-Web-Remote.git


echo "Setting up dotfiles..."

cd $HOME
rm -rf .vimrc     ; ln -s $XRPATPATH/generic/home_dotfiles/dot_vimrc     .vimrc
rm -rf .tmux.conf ; ln -s $XRPATPATH/generic/home_dotfiles/dot_tmux.conf .tmux.conf
rm -rf .bashrc    ; ln -s $XRPATPATH/generic/home_dotfiles/dot_bashrc    .bashrc
sudo rm -rf /root/.vimrc     ; sudo ln -s $XRPATPATH/generic/home_dotfiles/dot_vimrc     /root/.vimrc
sudo rm -rf /root/.tmux.conf ; sudo ln -s $XRPATPATH/generic/home_dotfiles/dot_tmux.conf /root/.tmux.conf
sudo rm -rf /root/.bashrc    ; sudo ln -s $XRPATPATH/generic/home_dotfiles/dot_bashrc    /root/.bashrc

sudo mv /etc/rc.local /etc/rc.local.dist ; ln -s $XRPATPATH/generic/etc/rc.local /etc/rc.local
sudo mkdir -p /root/bin
sudo ln -s $XRPATPATH/generic/pingmonitor.pl /root/bin/pingmonitor.pl


echo "Cleaning up XRPAT configuration file..."
cd $HOME && rm -f xrpat.conf

exit 0
