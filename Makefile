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
	cp ./bin/gotest $(GOPATH)/bin/gotest

clean:
ifneq (,$(wildcard ./bin/gotest))
	rm ./bin/gotest
endif

ifneq (,$(wildcard ./bin/coverage.out))
	rm ./bin/coverage.out
endif

ifneq (,$(wildcard $(GOPATH)/bin/gotest))
	rm $(GOPATH)/bin/gotest
endif	

clean-all: clean
	sudo rm /usr/local/bin/gotest