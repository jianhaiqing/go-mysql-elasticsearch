GO        := GO111MODULE=on go
GOBUILD   := CGO_ENABLED=0 $(GO) build $(BUILD_FLAG)

all: build

build: build-elasticsearch

build-elasticsearch:
	@for GOOS in darwin linux; do \
                for GOARCH in amd64; do \
                        echo "Building $${GOOS}-$${GOARCH} ..."; \
                        GOOS=$${GOOS} GOARCH=amd64 $(GOBUILD) -o bin/go-mysql-elasticsearch.$${GOOS} ./cmd/go-mysql-elasticsearch; \
                done ;\
        done

test:
	GO111MODULE=on go test -timeout 1m --race ./...

clean:
	GO111MODULE=on go clean -i ./...
	@rm -rf bin
