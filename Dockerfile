## NOTE: This image uses goreleaser to build image
# if building manually please run: go build

# Choose alpine as a base image to make this useful for CI, as many
# CI tools expect an interactive shell inside the container
FROM alpine:latest@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b as production

COPY gotest /usr/bin/gotest
RUN chmod +x /usr/bin/gotest

WORKDIR /workdir

ENTRYPOINT ["/usr/bin/gotest"]
CMD ["--help"]
