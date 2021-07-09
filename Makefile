TEST_PATH ?= /tmp/gotest

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

.PHONY: all
all: test

test:
	@mkdir -p ./.bin/
	go test -v ./... -cover  -coverprofile=./.bin/coverage.out 

test-coverage-view: test
	go tool cover -html=./.bin/coverage.out

build: test
	go build -o ./.bin/gotest

install: build
	cp ./.bin/gotest $(GOPATH)/bin/

install-all: install
	sudo cp ./.bin/gotest /usr/local/bin/

.PHONY: clean
clean:
ifneq (,$(wildcard ./.bin/gotest))
	rm ./.bin/gotest
endif

ifneq (,$(wildcard ./.bin/coverage.out))
	rm ./.bin/coverage.out
endif

ifneq (,$(wildcard $(GOPATH)/bin/gotest))
	rm $(GOPATH)/bin/gotest
endif	

.PHONY: clean-all
clean-all: clean
ifneq (,$(wildcard /usr/local/bin/gotest))
	sudo rm /usr/local/bin/gotest
endif

CNT := $(shell which -a gotest | wc -l)
EXCODE := $(shell which -a gotest | wc -l >/dev/null; echo $$?)
RES := $(shell test $(CNT) -gt 0 && echo $$?)

.PHONY: show
show:
#	@echo CNT: $(CNT)
#	@echo EXCODE: IS $(EXCODE)
ifeq ($(RES), 0)
	@which -a gotest
endif
