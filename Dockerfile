## NOTE: This image uses goreleaser to build image
# if building manually please run: go build

# Choose alpine as a base image to make this useful for CI, as many
# CI tools expect an interactive shell inside the container
FROM alpine:latest@sha256:51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375 as production

COPY gotest /usr/bin/gotest
RUN chmod +x /usr/bin/gotest

WORKDIR /workdir

ENTRYPOINT ["/usr/bin/gotest"]
CMD ["--help"]
