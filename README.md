# gotest

## Installation

### Binaries
You can find prebuilt `gotest` binaries on the [releases page](https://github.com/AndriyKalashnykov/gotest/releases).

You can download and install a binary locally like this:

```console
# extract gotest binary to /usr/local/bin
# note: the "tar" command must run with root permissions
$ curl -L -o - "https://github.com/AndriyKalashnykov/gotest/releases/latest/download/govc_$(uname -s)_$(uname -m).tar.gz" | tar -C /usr/local/bin -xvzf - gotest
```

### Source

#### Install via `go get`

To build `gotest` from source, first install the [Go
toolchain](https://golang.org/dl/). You can then install the latest `gotest` from
Github using:

```console
$ go get -u github.com/AndriyKalashnykov/gotest
```

⚠️ Make sure `$GOPATH/bin` is in your `PATH` to use the version installed from
source.

If you've made local modifications to the repository at
`$GOPATH/src/github.com/AndriyKalashnykov/gotest`, you can install using:

```console
$ go install github.com/AndriyKalashnykov/gotest
```