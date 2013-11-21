# xrpat

eXtreme Raspberry Pi Administration Toolkit
https://github.com/wolfcw/xrpat


## Introduction

xrpat is a set of scripts, tools, and other code that is useful for setting up
a larger number of Raspberry Pis or for reinstalling the same RPis over and
over again. It is intended as a lightweight alternative to obviously more
professional solutions, such as Puppet-based system/configuration
management.


## Target environment

xrpat is currently designed and implemented for a single use case: After a
fresh operating system image has been put onto the RPi's SD card, get all
the needed software and system configuration set up as quick and easy as
possible by scripting/automating the steps that would otherwise have to be done
manually.

xrpat is motivated by the practical experience that RPis

*  sometimes render their SD card file system unusable, crash, and cannot
   reboot, therefore necessitating a new clean installation;

*  have limited computing power and typically limited storage capacity,
   so experimenting with various software packages / RPi projects
   sometimes requires a clean installation as well.

xrpat is intended for home / consumer use and small labs, in which the overhead
of more professional solutions (e.g., creating one's own RPi SD card images or
using a central installation server) should be avoided.

Although xrpat hopefully helps to get RPi projects and Linux teaching
environments running quickly, there are some things xrpat is NOT:

* xrpat is NOT a good example of how Linux system administration should
  be done. It currently is a quick & dirty solution for the annoying
  problem of having to run the same setup steps over and over again.

* xrpat is NOT secure. Although it can be used to set up, e.g., a web
  server quickly, it currently does not perform any server hardening
  or honor other security principles such as removing unused network
  services. In fact, it violates almost all basic paradigms, such as
  security by design, security by default, and security in deployment.

As a consequence, you should NEVER connect any RPi set up by xrpat
directly to the Internet or any other untrusted network unless you have
performed additional configuration steps and know what you are doing.


## Usage

Ideally, using xrpat works like this:

* Prepare a fresh SD card for an RPi, e.g., by downloading Raspian
  from http://www.raspberrypi.org/downloads and following the instructions
  for setting the SD card up.

* Boot the RPi with this new SD card and follow any first-boot setup
  steps that may be required by the installed operating system.

* Create an xrpat.conf in the current user's home directory (see below).

* Download xrpat's bootstrap.sh, make it executable (chmod u+x bootstrap.sh),
  and run it (./bootstrap.sh).

* If everything runs smoothly, the RPi will be fully ready for its
  intended use afterwards.


### Configuration via xrpat.conf

There are a couple of settings, which are either specific for the currently
installed machine (such as its hostname) or should not be uploaded to a public
Git repository (such as your WiFi/WPA2 passwords). Those settings need to
be added to $HOME/xrpat.conf before running ./bootstrap.sh unless you plan to
amend them after xrpat has finished setting up the RPi.

The pre-install script that is run during the bootstrapping process will create
a template for $HOME/xrpat.conf and abort installation if this file does not
yet exist, so the correct values can be filled in and the installation must be
started again. It is recommended that you prepare a default xrpat.conf
for your environment (e.g., same WiFi password for all RPis) and put it into
$HOME just before downloading and running bootstrap.sh.


### Customization via forking the xrpat Github repository

By default, xrpat uses the installation scripts and package lists from
its official Github repository, https://github.com/wolfcw/xrpat

However, most likely you will want to change the list of software packages
xrpat installs on new systems, modify some of the configuration files it
provides (e.g., for vim and tmux) and add some more steps to do automatically
when setting up a new RPi.

The recommended way for customizing xrpat is to fork the xrpat repository on
Github and to modify any files as required in your own, forked xrpat
repository. Ideally, you should not have to modify any of the files in
the xrpat repository that is cloned to each RPi during bootstrapping.


### Updating xrpat files on previously installed RPis

xrpat uses (your fork of) its Git repository to distribute updates to any
xrpat-installed RPis. For example, the .vimrc configuration file provided
by xrpat is installed by linking $HOME/.vimrc to the local clone of the
repository ($HOME/git/xrpat/generic/home_dotfiles/dot_vimrc).

Therefore, to update any xrpat-provided files on a RPi, the following
commands can be used:

cd $HOME/git/xrpat
git pull

These commands can either be run manually or be set up to run automatically
(e.g., using a cronjob or a shell script executed during system boot). Usually,
Git's conflict detection and merge procedures will avoid that local
modifications are overwritten, but it is recommended to update the files in the
(remote) repository and not make any local modifications to these files.


## Packages and code

### Customizing packages.txt

The xrpat repository contains distribution-specific subdirectories, e.g.,
raspian/, which include a text file named packages.txt. Each line in this text
file contains the name of a software package that should be installed
during the bootstrapping process. Feel free to customize.

By default, xrpat installs

* core packages, such as vim, tmux, and git, which typically are needed
  on all RPis independent of the current project or lecture the RPi will
  be used for;

* GPIO-related packages that are required to get GPIO working on the RPi,
  e.g., for connecting LCD displays and buttons to the RPi's GPIO pins;

* webcam-related packages, e.g., for using tools like mjpgstreamer with
  USB webcams;

* web server related packages, i.e., Apache HTTPD including PHP5 and MySQL;

* Arduino-related packages for programming Arduino-like boards via USB.

With a current Raspian OS, this full setup requires less than 3 GB on the SD
card, so there should be enough space for projects when a 4 GB SD card is
used, but you can remove unnecessary packages to save some space and speed up
the installation process.


### Customizing post-install.sh

$HOME/git/xrpat/generic/post-install.sh is run after the distribution-specific
software packages have been installed. It can be used to download (and
install) additional software that is not available as package for the specific
Linux distribution.

By default, xrpat uses Git to download / clone several repositories that are
required for typical RPi-GPIO and Arduino projects, such as LED backpacks, LCD
backplates, and DHT sensors.

post-install.sh is also the script that installs xrpat's default configuration
files (e.g., for vim and tmux) by symlinking them from $HOME and, for
some files, /root or /etc. 


### Tools provided by xrpat

xrpat includes the source code and configuration files of a few small, mostly
GPIO- and Arduino-based projects. The basic intention behind this is to provide
everything needed to perform simple hardware tests, e.g., verifying that
the GPIO ports work properly and all of the required software for own projects
in installed.


## Contributing to xrpat

Contributions (bug fixes, additional scripts, documentation, ...) are highly
welcome and should be submitted via pull requests on Github. Please also use
the Github issue tracker to report any problems or improvement suggestions.

