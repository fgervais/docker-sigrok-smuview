#!/usr/bin/env bash

INSTALL_DIR=${1:-`pwd`/_install}

if [ ! -d libserialport ]
then
	git clone git://sigrok.org/libserialport
fi
cd libserialport
if [ ! -f configure ]
then
	./autogen.sh
	./configure --prefix=${INSTALL_DIR}
fi
make
make install
cd -

if [ ! -d libsigrok ]
then
	git clone https://github.com/tjko/libsigrok.git
	git checkout itech-it8500-v3
fi
cd libsigrok
if [ ! -f configure ]
then
	./autogen.sh
	PKG_CONFIG_PATH=${INSTALL_DIR}/lib/pkgconfig ./configure --prefix=${INSTALL_DIR}
fi
make -j16
make install
cd -

if [ ! -d smuview ]
then
	git clone https://github.com/knarfS/smuview
fi
cd smuview
mkdir build
cd build
if [ ! -f Makefile ]
then
	PKG_CONFIG_PATH=${INSTALL_DIR}/lib/pkgconfig cmake -DCMAKE_INSTALL_PREFIX:PATH=${INSTALL_DIR} ../
fi
make -j16
make install
cd -
