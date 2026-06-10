## NOTE: This image uses goreleaser to build image
# if building manually please run: go build

# Choose alpine as a base image to make this useful for CI, as many
# CI tools expect an interactive shell inside the container
FROM alpine:latest@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4 as production

COPY gotest /usr/bin/gotest
RUN chmod +x /usr/bin/gotest

WORKDIR /workdir

ENTRYPOINT ["/usr/bin/gotest"]
CMD ["--help"]
