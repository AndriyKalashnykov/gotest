FROM golang:1.18 as builder

ARG GH_ACCESS_TOKEN

WORKDIR /source
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# Cache deps before building and copying source so that we don't need to re-download
# as much and so that source changes don't invalidate our downloaded layer
RUN GOCACHE=OFF
RUN go mod download

# Copy source code
COPY main.go main.go
COPY internal/ internal/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o gotest main.go

FROM scratch
COPY --from=builder /source/gotest /gotest
CMD ["/gotest"]
