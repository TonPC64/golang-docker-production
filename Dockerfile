FROM golang:1.10-alpine AS build

RUN apk add --no-cache git
COPY Gopkg.lock Gopkg.toml /go/src/github.com/TonPC64/golang-docker-production/
WORKDIR /go/src/github.com/TonPC64/golang-docker-production/

RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure -vendor-only

COPY . /go/src/github.com/TonPC64/golang-docker-production/
RUN CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -ldflags '-w' -o /bin/project

# add ca-cert if you error x509
FROM alpine:3.7 as certs
RUN apk --update add ca-certificates

# This is a docker image production with tiny size.
FROM scratch
ENV GIN_MODE=release
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /bin/project /bin/project
ENTRYPOINT ["/bin/project"]