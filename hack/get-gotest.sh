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
# wget https://github.com/AndriyKalashnykov/gotest/releases/download/v0.0.9/gotest_v0.0.9_Linux_x86_64.tar.gz
# curl -sfL  https://raw.githubusercontent.com/AndriyKalashnykov/gotest/master/hack/get-gotest.sh | bash -s 0.0.9

sudo -v

cd $TMP_DIR

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

    echo "https://github.com/$USER/$PROJECT/releases/download/v${VERSION_TO_INSTALL}/${PROJECT}-v${VERSION_TO_INSTALL}-${OS_LC}-${ARCH}${TAR_GZ_EXT}"
    curl -sSLf "https://github.com/$USER/$PROJECT/releases/download/v${VERSION_TO_INSTALL}/${PROJECT}-v${VERSION_TO_INSTALL}-${OS_LC}-${ARCH}${TAR_GZ_EXT}" | sudo tar -zx -C $BIN_DIR ${PROJECT}
  else
    echo "$PROJECT $VERSION_TO_INSTALL already installed"
fi

cd $LAUNCH_DIR
