## NOTE: This image uses goreleaser to build image
# if building manually please run: go build

# Choose alpine as a base image to make this useful for CI, as many
# CI tools expect an interactive shell inside the container
FROM alpine:latest@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 as production

COPY gotest /usr/bin/gotest
RUN chmod +x /usr/bin/gotest

WORKDIR /workdir

ENTRYPOINT ["/usr/bin/gotest"]
CMD ["--help"]
