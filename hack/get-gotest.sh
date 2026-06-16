#!/bin/bash
set -euo pipefail

# Install the latest (or a specific) gotest release binary into /usr/local/bin.
#
#   ./get-gotest.sh                 # latest release
#   ./get-gotest.sh 0.0.14          # a specific version
#   curl -sfL https://raw.githubusercontent.com/AndriyKalashnykov/gotest/master/hack/get-gotest.sh | bash
#   curl -sfL https://raw.githubusercontent.com/AndriyKalashnykov/gotest/master/hack/get-gotest.sh | bash -s 0.0.14

OWNER=AndriyKalashnykov
PROJECT=gotest
BIN_DIR=/usr/local/bin

VERSION_TO_INSTALL=${1:-}

# goreleaser archive names use a capitalized OS (Linux/Darwin/Windows) and
# x86_64 for amd64; map uname's machine values to goreleaser's arch names.
OS=$(uname)
ARCH=$(uname -m)
case "$ARCH" in
	aarch64) ARCH=arm64 ;;
	armv*)   ARCH=arm ;;
esac

# Resolve the latest release tag when no version was given.
if [ -z "$VERSION_TO_INSTALL" ]; then
	VERSION_TO_INSTALL=$(curl -sL "https://api.github.com/repos/$OWNER/$PROJECT/releases/latest" |
		grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//')
fi

VERSION_INSTALLED=""
if [ -x "$BIN_DIR/$PROJECT" ]; then
	VERSION_INSTALLED=$("$BIN_DIR/$PROJECT" version -s | grep 'Version:' | awk '{print $2}' | sed 's/[^0-9.]//g')
fi

if [ "$VERSION_TO_INSTALL" = "$VERSION_INSTALLED" ]; then
	echo "$PROJECT $VERSION_TO_INSTALL already installed"
	exit 0
fi

if [ -z "$VERSION_INSTALLED" ]; then
	echo "Installing $PROJECT $VERSION_TO_INSTALL"
else
	echo "Replacing $PROJECT $VERSION_INSTALLED -> $VERSION_TO_INSTALL"
fi

sudo -v
url="https://github.com/$OWNER/$PROJECT/releases/download/v${VERSION_TO_INSTALL}/${PROJECT}_v${VERSION_TO_INSTALL}_${OS}_${ARCH}.tar.gz"
curl -sSLf "$url" | sudo tar -zx -C "$BIN_DIR" "$PROJECT"
echo "Installed $PROJECT $VERSION_TO_INSTALL to $BIN_DIR/$PROJECT"
