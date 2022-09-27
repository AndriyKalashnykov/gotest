# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

commitSHA=$(shell git describe --dirty --always)
dateStr=$(shell date +%s)
DATE := $(shell /bin/date +%m-%d-%Y)

VERSION := $(shell cat ./main.go | grep "const Version ="| cut -d"\"" -f2)

deps:
	@go install golang.org/x/lint/golint@latest
	@go get -d github.com/mitchellh/go-homedir@latest
	@go get -d github.com/spf13/viper@latest
	@go get -d github.com/spf13/cobra@latest
	@go get -d go.hein.dev/go-version@latest
	@go get -d github.com/hashicorp/hcl@latest

all: build

lint:
	@golint -set_exit_status ./...

test: deps
	@mkdir -p ./.bin/
	go test -v ./... -cover  -coverprofile=./.bin/coverage.out 

test-coverage-view: test
	go tool cover -html=./.bin/coverage.out

build: test
	go build -ldflags "-X main.commit=${commitSHA} -X main.date=${DATE}" -o ./.bin/gotest

install: build
	cp ./.bin/gotest $(GOPATH)/bin/

install-all: install
	sudo cp ./.bin/gotest /usr/local/bin/

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

clean-all: clean
ifneq (,$(wildcard /usr/local/bin/gotest))
	sudo rm /usr/local/bin/gotest
endif

CNT := $(shell which -a gotest | wc -l)
EXCODE := $(shell which -a gotest | wc -l >/dev/null; echo $$?)
RES := $(shell test $(CNT) -gt 0 && echo $$?)

show:
#	@echo CNT: $(CNT)
#	@echo EXCODE: IS $(EXCODE)
ifeq ($(RES), 0)
	@which -a gotest
endif

run: build
	./.bin/gotest version -s

generate-changelog:
	./hack/generate-changelog.sh

tag:
	./hack/tag-release.sh

push-tags:
	@git push --tags

release: clean
	@echo -n "Are you sure to create and push ${VERSION} tag? [y/N] " && read ans && [ $${ans:-N} = y ]
	@git commit -a -s -m "Cut ${VERSION} release"
	@git tag ${VERSION}
	@git push origin ${VERSION}
	@git push

#update: @ Update dependency packages to latest versions
update:
	@export GOPRIVATE=$(GOPRIVATE); export GOFLAGS=$(GOFLAGS); go get -u; go mod tidy

#version: @ Print current version(tag)
version:
	@echo ${VERSION}

delete-local-tags:
	./hack/delete-local-tags.sh

delete-remote-tags:
	./hack/delete-remote-tags.sh

delete-all-tags: delete-local-tags delete-remote-tags delete-local-tags
	echo "v0.0.0" > VERSION

delete-current-tag:
	git tag -d ${VERSION}
	git push --delete origin ${VERSION}

# get tag v0.0.8
# git tag -d v0.0.8
# git push --delete origin v0.0.8
# git tag -l
# git ls-remote --tags -q
# git ls-remote origin | cut -f 2 | grep -iv head | xargs git push --delete origin
