[![Go Build](https://github.com/AndriyKalashnykov/gotest/actions/workflows/go.yml/badge.svg)](https://github.com/AndriyKalashnykov/gotest/actions/workflows/go.yml)
[![Release Go project](https://github.com/AndriyKalashnykov/gotest/actions/workflows/release.yml/badge.svg)](https://github.com/AndriyKalashnykov/gotest/actions/workflows/release.yml)
[![codecov](https://codecov.io/gh/AndriyKalashnykov/gotest/branch/master/graph/badge.svg?token=Q12E11KJ74)](https://codecov.io/gh/AndriyKalashnykov/gotest)
[![Open in Visual Studio Code](https://img.shields.io/static/v1?logo=visualstudiocode&label=&message=Open%20in%20Visual%20Studio%20Code&labelColor=2c2c32&color=007acc&logoColor=007acc)](https://open.vscode.dev/AndriyKalashnykov/gotest)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FAndriyKalashnykov%2Fgotest&count_bg=%2333CD56&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
# Test project in Go

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

### Build from sources

```bash
git clone git@github.com:AndriyKalashnykov/gotest.git
cd gotest
docker run --rm -v `pwd`:/host golang:1.17 bash -c "cd /host && go build ."
```

### Create release

Create incremental release

```bash
make release
```

### TODO:

* [random-standup](https://github.com/jidicula/random-standup/tree/main/.github/workflows)
* [create-go-app/cli](https://github.com/create-go-app/cli)