# Container image that runs your code
FROM alpine:3.15

COPY --from=golang:1.18-alpine /usr/local/go/ /usr/local/go/

ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/opt/go/"

RUN apk update; \
  apk add git openssh; \
  # need to versoin lock this
  apk add "protobuf~=3.18.1-r1";

RUN go get -u google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
RUN go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

ENV PATH="$PATH:$GOPATH/bin"

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]
