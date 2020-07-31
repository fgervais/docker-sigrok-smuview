#!/usr/bin/env bash

INSTALL_DIR=${1:-`pwd`/_install}

LD_LIBRARY_PATH=${INSTALL_DIR}/lib ${INSTALL_DIR}/bin/smuview -D
