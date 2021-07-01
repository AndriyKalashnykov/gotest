TEST_PATH ?= /tmp/hello

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

all: build

build:
	go build -o ./bin/hello

test: build
	go test -v -cover  -coverprofile=./bin/coverage.out ./...

test-coverage-view: test
	go tool cover -html=./bin/coverage.out

install:
	go install github.com/AndriyKalashnykov/hello

clean:
	rm -rf ./bin/hello
	rm -rf ./bin/coverage.out
	rm $(GOPATH)/bin/hello