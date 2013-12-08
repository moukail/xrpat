#!/bin/sh

#
# xrpat bootstrapper.
# This file is part of xrpat. See https://github.com/wolfcw/xrpat
#

#
# Download and run this file; with some luck, everything else runs automatically.
#

# Configuration:
# If you have forked xrpat, adjust this URL:
GITREPO='https://github.com/wolfcw/xrpat.git'


# Initialization for any platform

cd $HOME && mkdir -p git && cd git || exit 1


# Platform-specific steps
if [ -f /etc/debian_version ] ; then                                # Raspian
    # on Raspian, nopasswd sudo is already active and git-core is installed
    # by default so everything can be cloned, not just bootstrap.sh downloaded
    #sudo chmod +w /etc/sudoers
    #echo 'pi ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers > /dev/null
    #sudo chmod -w /etc/sudoers
    for x in 1 2 ; do
        sudo apt-get -y update          # we do it twice because it tends to fail
        sudo apt-get -y upgrade
        sudo apt-get -y dist-upgrade
    done
    sudo apt-get -y vim
    #sudo apt-get -y install git-core
    #git clone $GITREPO
    cd xrpat && raspbian/install.sh || exit 1
else
    echo "This RPi Linux distribution is not yet supported. :-("
    exit 1
fi


# Post-installation steps for any platform
cd $HOME && cd git && cd xrpat || exit 1
generic/post-install.sh || exit 1


exit 0

