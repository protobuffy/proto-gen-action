# Container image that runs your code
# alpine 3.10 lock protobuf to 3.6
FROM alpine:3.10

# ARG GOLANG_VERSION

COPY --from=golang:1.19.10-alpine /usr/local/go/ /usr/local/go/
ARG PROTOBUF_VERSION=3.6.1-r1
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/opt/go/"

RUN apk update; \
  apk add git openssh; \
  # need to versoin lock this or use arg
  # 3.6.1-r1
  apk add "protobuf~=${PROTOBUF_VERSION}";

# RUN go get -u google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
# RUN go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2.0

# Support older proto gen thats deprecated
RUN go install github.com/envoyproxy/protoc-gen-validate@v0.4.0
RUN go install github.com/golang/protobuf/protoc-gen-go@v1.3.1

# Enable option build later
RUN git clone github.com/bufbuild/protoc-gen-validate; \
    # installs PGV into $GOPATH/bin
    cd protoc-gen-validate && make build;

ENV PATH="$PATH:$GOPATH/bin"

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]
