TEST_PATH ?= /tmp/gotest

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

all: build

build: test
	go build -o ./bin/gotest

test: build
	go test -v -cover  -coverprofile=./bin/coverage.out ./...

test-coverage-view: test
	go tool cover -html=./bin/coverage.out

install: build
	sudo cp ./bin/gotest /usr/local/bin/

clean:
	rm -rf ./bin/gotest
	rm -rf ./bin/coverage.out
	rm $(GOPATH)/bin/gotest
	sudo rm /usr/local/bin/gotest