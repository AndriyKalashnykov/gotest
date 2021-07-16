# gotest
[![Open in Visual Studio Code](https://open.vscode.dev/badges/open-in-vscode.svg)](https://open.vscode.dev/AndriyKalashnykov/gotest)
## Installation

### Binaries
You can find prebuilt `gotest` binaries on the [releases page](https://github.com/AndriyKalashnykov/gotest/releases).

You can download and install a binary locally like this:

```bash
./hack/get-gotest.sh
```

### Source

#### Install via `go get`

To build `gotest` from source, first install the [Go
toolchain](https://golang.org/dl/). You can then install the latest `gotest` from
Github using:

```bash
$ export GO111MODULE=off; go get -u github.com/AndriyKalashnykov/gotest
```

⚠️ Make sure `$GOPATH/bin` is in your `PATH` to use the version installed from
source.

If you've made local modifications to the repository at
`$GOPATH/src/github.com/AndriyKalashnykov/gotest`, you can install using:

```bash
$ export GO111MODULE=off; go install github.com/AndriyKalashnykov/gotest
```

### TODO:

* [random-standup](https://github.com/jidicula/random-standup/tree/main/.github/workflows)
* [create-go-app/cli](https://github.com/create-go-app/cli)