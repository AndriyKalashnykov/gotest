.DEFAULT_GOAL := help

commitSHA=$(shell git describe --dirty --always)
dateStr=$(shell date +%s)
DATE := $(shell /bin/date +%m-%d-%Y)

VERSION := $(shell cat ./main.go | grep "const Version ="| cut -d"\"" -f2)

SEMVER_RE := ^v[0-9]+\.[0-9]+\.[0-9]+$$

.PHONY: help deps all lint test test-coverage-view build clean clean-all show run image changelog-generate tag tags-push release update version tags-delete-local tags-delete-remote tags-delete-all tags-delete-current release-test-local ci

#help: @ Show available make targets with descriptions
help:
	@grep -E '^#[a-zA-Z_-]+:.* @' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = "#|: @"}; {printf "\033[36m%-30s\033[0m %s\n", $$2, $$3}'

#deps: @ Install dependency tools (idempotent)
deps:
	@command -v staticcheck >/dev/null 2>&1 || go install honnef.co/go/tools/cmd/staticcheck@v0.6.0

#all: @ Build all
all: build

#lint: @ Run linter
lint:
	@staticcheck ./...

#test: @ Run tests with coverage
test: deps
	@mkdir -p ./.bin/
	@go test -v ./... -cover -coverprofile=./.bin/coverage.out

#test-coverage-view: @ Run tests and open coverage report in browser
test-coverage-view: test
	@go tool cover -html=./.bin/coverage.out

#build: @ Build binary
build: clean
	@go build -ldflags "-X main.commit=${commitSHA} -X main.date=${DATE}"

#clean: @ Clean build artifacts
clean:
ifneq (,$(wildcard ./.bin/gotest))
	@rm ./.bin/gotest
endif
	@rm -rf .bin/ .dist/

ifneq (,$(wildcard .bin/coverage.out))
	@rm -rf .bin/coverage.out
endif

ifneq (,$(wildcard $(GOPATH)/bin/gotest))
	@rm $(GOPATH)/bin/gotest
endif
	@rm -rf ./dist
	@rm -rf ./completions
	@rm -f gotest

#clean-all: @ Clean all build artifacts including system-wide installs
clean-all: clean
ifneq (,$(wildcard /usr/local/bin/gotest))
	@sudo rm /usr/local/bin/gotest
endif

CNT := $(shell which -a gotest | wc -l)
EXCODE := $(shell which -a gotest | wc -l >/dev/null; echo $$?)
RES := $(shell test $(CNT) -gt 0 && echo $$?)

#show: @ Show gotest binary locations
show:
#	@echo CNT: $(CNT)
#	@echo EXCODE: IS $(EXCODE)
ifeq ($(RES), 0)
	@which -a gotest
endif

#run: @ Build and run gotest
run: build
	@gotest version

#image: @ Build Docker image
image: build
	@docker build -t gotest .

#changelog-generate: @ Generate changelog
changelog-generate:
	@./hack/generate-changelog.sh

#tag: @ Create a release tag
tag:
	@./hack/tag-release.sh

#tags-push: @ Push all tags to remote
tags-push:
	@git push --tags

#release: @ Create and push a release (validates semver)
release: clean
	@if ! echo "$(VERSION)" | grep -qE '$(SEMVER_RE)'; then \
		echo "ERROR: VERSION '$(VERSION)' is not valid semver (expected vMAJOR.MINOR.PATCH)"; \
		exit 1; \
	fi
	@echo -n "Are you sure to create and push ${VERSION} tag? [y/N] " && read ans && [ $${ans:-N} = y ]
	@git commit -a -s -m "Cut ${VERSION} release"
	@git tag ${VERSION}
	@git push origin ${VERSION}
	@git push

#update: @ Update dependency packages to latest versions
update:
	@export GOPRIVATE=$(GOPRIVATE); go get -u; go mod tidy

#version: @ Print current version(tag)
version:
	@echo ${VERSION}

#tags-delete-local: @ Delete all local tags
tags-delete-local:
	@./hack/delete-local-tags.sh

#tags-delete-remote: @ Delete all remote tags
tags-delete-remote:
	@./hack/delete-remote-tags.sh

#tags-delete-all: @ Delete all local and remote tags
tags-delete-all: tags-delete-local tags-delete-remote tags-delete-local
	@echo "v0.0.0" > VERSION

#tags-delete-current: @ Delete current version tag locally and remotely
tags-delete-current:
	@git tag -d ${VERSION}
	@git push --delete origin ${VERSION}

#release-test-local: @ Build binaries locally without publishing
release-test-local: build
	@goreleaser check
	@goreleaser release --rm-dist --snapshot

#ci: @ Run lint and tests (CI pipeline)
ci: lint test build

# get tag v0.0.9
# git tag -d v0.0.9
# git push --delete origin v0.0.9
# git tag -l
# git ls-remote --tags -q
# git ls-remote origin | cut -f 2 | grep -iv head | xargs git push --delete origin
