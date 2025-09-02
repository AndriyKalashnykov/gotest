## NOTE: This image uses goreleaser to build image
# if building manually please run: go build

# Choose alpine as a base image to make this useful for CI, as many
# CI tools expect an interactive shell inside the container
FROM alpine:latest@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 as production

COPY gotest /usr/bin/gotest
RUN chmod +x /usr/bin/gotest

WORKDIR /workdir

ENTRYPOINT ["/usr/bin/gotest"]
CMD ["--help"]
