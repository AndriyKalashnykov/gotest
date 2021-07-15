#!/bin/bash

# https://github.com/kubermatic/kubermatic
# https://github.com/open-cluster-management/clusterlifecycle-state-metrics
# https://github.com/open-cluster-management/clusterlifecycle-state-metrics/blob/main/build/install-dependencies.sh

export GO111MODULE=off

# Go tools
_OS=$(go env GOOS)
_ARCH=$(go env GOARCH)

if ! which patter > /dev/null; then      echo "Installing patter ..."; go get -u github.com/apg/patter; fi
if ! which gocovmerge > /dev/null; then  echo "Installing gocovmerge..."; go get -u github.com/wadey/gocovmerge; fi
if ! which golangci-lint > /dev/null; then
   curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.23.6
fi
if ! which go-bindata > /dev/null; then
	echo "Installing go-bindata..."
	cd $(mktemp -d) && GOSUMDB=off go get -u github.com/go-bindata/go-bindata/...
fi
go-bindata --version

# Build tools
if ! which kubebuilder > /dev/null; then
   # Install kubebuilder for unit test
   echo "Install Kubebuilder components for test framework usage!"

   # download kubebuilder and extract it to /usr/local/bin
fi
# Image tools

# Check tools