# Container image that runs your code
FROM alpine:3.15

COPY --from=golang:1.18-alpine /usr/local/go/ /usr/local/go/

ENV PATH="/usr/local/go/bin:${PATH}"

RUN apk add git; \
  # need to versoin lock this
  apk add "protobuf~=3.18.1-r1";

# version set later
RUN  go install google.golang.org/protobuf/cmd/protoc-gen-go@latest; \
  go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest;

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]