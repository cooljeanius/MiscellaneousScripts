#!/bin/bash

################################################################################
# copyright Bjarne D Mathiesen
#           København ; Danmark ; Europa
#           macintosh .at. mathiesen .dot. info
# date      04/07-2007
# revised   02/12-2007  implemented automatic patching of Portfiles
#           28/12-2009  fixed the download link
#                       modified source/build directory
#                       removed sudo from commands
#           18/06-2011  added default values for the parameters
#                       updated path values for XCode4
#
# this script is released under the BSD license
# the author welcomes feedback and improvements
# 

usage() {
cat <<EOT
purpose : to automate the whole install process
\${1} : action                 [ install (default) , paths ]
\${2} : install prefix         ( default /macports )
\${3} : macports base version  ( default 1.9.2 )
EOT
}

declare action=${1:-"install"}
declare prefix=${2:-"/macports"}
declare version=${3:-"1.9.2"}

case ${action} in
########################
# setup the system paths
'paths')

mkdir -p  /etc/paths.d
cp    -np /etc/paths /etc/paths.orig
mv    -n  /etc/paths /etc/paths.d/999macosx
touch     /etc/paths

echo "${prefix}/bin"        >  /etc/paths.d/000macports
echo "${prefix}/sbin"       >> /etc/paths.d/000macports

echo "/Developer/usr/bin"   >  /etc/paths.d/888developer
echo "/Developer/usr/sbin"  >> /etc/paths.d/888developer

mkdir -p  /etc/manpaths.d
cp    -np /etc/manpaths /etc/manpaths.orig
mv    -n  /etc/manpaths /etc/manpaths.d/999macosx
touch     /etc/manpaths

echo "${prefix}/share/man"  > /etc/manpaths.d/000macports
echo "/Developer/usr/share/man"     >  /etc/manpaths.d/888developer
echo "/Developer/usr/X11/share/man" >> /etc/manpaths.d/888developer

# path_helper is buggy under 10.5
#cp -npv /usr/libexec/path_helper /usr/libexec/path_helper.orig
#cp   -v path_helper /usr/libexec/

;;
##################
# install macports
'install')

if [ ! -e MacPorts-${version}.tar.gz ]
then
    curl -O --url "http://distfiles.macports.org/MacPorts/MacPorts-${version}.tar.gz"
fi

rm  -rf  ./MacPorts-${version}
tar -zxf   MacPorts-${version}.tar.gz

cd MacPorts-${version}
./configure LDFLAGS=-L/Developer/SDKs/MacOSX10.6.sdk/usr/X11/lib --prefix=${prefix}
make
make install

# update MacPorts itself
${prefix}/bin/port -d selfupdate

# let's get bash
${prefix}/bin/port install bash

;;
# default
*)
usage
esac
