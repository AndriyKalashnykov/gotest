.DEFAULT_GOAL := help
SHELL := /bin/bash

# mise provisions pinned dev tools (see .mise.toml). Put its shim dir and the
# user-local bin dir on PATH so recipes resolve the tools deps just installed.
export PATH := $(HOME)/.local/share/mise/shims:$(HOME)/.local/bin:$(PATH)

APP_NAME       := gotest
CURRENTTAG     := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "dev")

commitSHA=$(shell git describe --dirty --always)
dateStr=$(shell date +%s)
DATE := $(shell /bin/date +%m-%d-%Y)

VERSION := $(shell grep 'const Version =' main.go | cut -d'"' -f2)

SEMVER_RE := ^v[0-9]+\.[0-9]+\.[0-9]+$$

#help: @ List available tasks
help:
	@echo "Usage: make COMMAND"
	@echo "Commands :"
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| tr -d '#' | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m - %s\n", $$1, $$2}'

#deps: @ Install pinned dev tools via mise (idempotent)
deps:
	@command -v mise >/dev/null 2>&1 || { echo "mise not found — install from https://mise.run"; exit 1; }
	@mise install

#all: @ Build all
all: build

#lint: @ Run staticcheck linter
lint: deps
	@staticcheck ./...

#vulncheck: @ Scan for known Go vulnerabilities (govulncheck)
vulncheck: deps
	@govulncheck ./...

#trivy-fs: @ Scan filesystem dependencies and secrets for CVEs (Trivy)
trivy-fs: deps
	@trivy fs --scanners vuln,secret --severity HIGH,CRITICAL --exit-code 1 --no-progress .

#secrets: @ Scan the working tree for leaked secrets (gitleaks)
secrets: deps
	@gitleaks dir . --no-banner

#static-check: @ Run all static analysis (lint + vulncheck + secrets + trivy-fs)
static-check: lint vulncheck secrets trivy-fs

#test: @ Run tests with coverage
test:
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
	@rm -rf .bin/ .dist/ ./dist ./completions
	@rm -f gotest
ifneq (,$(wildcard $(GOPATH)/bin/gotest))
	@rm $(GOPATH)/bin/gotest
endif

#clean-all: @ Clean all build artifacts including system-wide installs
clean-all: clean
ifneq (,$(wildcard /usr/local/bin/gotest))
	@sudo rm /usr/local/bin/gotest
endif

#show: @ Show gotest binary locations
show:
	@which -a gotest || true

#run: @ Build and run gotest
run: build
	@gotest version

#image-build: @ Build Docker image
image-build: build
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
	@go get -u; go mod tidy

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
	@goreleaser release --clean --snapshot

#ci: @ Run static analysis, tests, and build (CI pipeline)
ci: static-check test build

#ci-run: @ Run GitHub Actions workflow locally using act
ci-run: deps
	@act push --container-architecture linux/amd64 \
		--artifact-server-path /tmp/act-artifacts

#renovate-validate: @ Validate Renovate configuration
renovate-validate: deps
	@npx --yes renovate --platform=local

.PHONY: help deps all lint vulncheck trivy-fs secrets static-check test \
	test-coverage-view build clean clean-all show run image-build \
	changelog-generate tag tags-push release update version \
	tags-delete-local tags-delete-remote tags-delete-all tags-delete-current \
	release-test-local ci ci-run renovate-validate
