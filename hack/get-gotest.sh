#!/bin/bash

#set -x

LAUNCH_DIR=$(pwd); SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; cd $SCRIPT_DIR; cd ..; SCRIPT_PARENT_DIR=$(pwd);

MP_DIR=/tmp
LOCAL_DIR=/usr/local
BIN_DIR=$LOCAL_DIR/bin
TGZ_EXT=.tgz
TAR_GZ_EXT=.tar.gz

VERSION_TO_INSTALL=${1:-}
VERSION_INSTALLED=""

USER=AndriyKalashnykov
PROJECT=gotest

# ./get-gotest.sh 0.0.1
# curl -sfL  https://raw.githubusercontent.com/AndriyKalashnykov/gotest/master/hack/get-gotest.sh | bash
# or
# curl -sfL  https://raw.githubusercontent.com/AndriyKalashnykov/gotest/master/hack/get-gotest.sh | bash -s 0.0.9

sudo -v

cd $TMP_DIR

OS=$(echo $(uname))
OS_LC=$(echo $(uname))
ARCH=$(uname -m) ;

if [ -z "${VERSION_TO_INSTALL}" ]; then
    VERSION_TO_INSTALL=$(curl -sL https://api.github.com/repos/$USER/$PROJECT/releases/latest  | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^.//')
fi

if [ -f "$BIN_DIR/$PROJECT" ]; then
    VERSION_INSTALLED=$($BIN_DIR/$PROJECT version -s | grep 'Version:' | awk '{printf("%s",$2)}' | sed 's/.*://' | sed 's/[^0-9.]*//g')
fi

# echo "VERSION_TO_INSTALL: $VERSION_TO_INSTALL"
# echo "VERSION_INSTALLED: $VERSION_INSTALLED"

if [ "${VERSION_TO_INSTALL}" != "${VERSION_INSTALLED}" ]; then
    if [ -z $VERSION_INSTALLED ]; then
        echo "Installing $PROJECT: $VERSION_TO_INSTALL"
    else
        echo "Replacing $PROJECT: $VERSION_INSTALLED > $VERSION_TO_INSTALL"
    fi

    curl -sSLf "https://github.com/$USER/$PROJECT/releases/download/v${VERSION_TO_INSTALL}/${PROJECT}_v${VERSION_TO_INSTALL}_${OS_LC}_${ARCH}${TAR_GZ_EXT}" | sudo tar -zx -C $BIN_DIR ${PROJECT}
  else
    echo "$PROJECT $VERSION_TO_INSTALL already installed"
fi

cd $LAUNCH_DIR
