FROM golang:latest AS builder
ADD . $GOPATH/src/github.com/atlassian/jec
WORKDIR $GOPATH/src/github.com/atlassian/jec/main
RUN export GIT_COMMIT=$(git rev-list -1 HEAD) && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo \
        -ldflags "-X main.JECCommitVersion=$GIT_COMMIT -X main.JECVersion=1.0.5" -o nocgo -o /jec .
FROM astral/uv:python3.14-bookworm AS base
RUN addgroup --system jec && \
    adduser --system jec --group && \
    apt update && \
    apt install git ca-certificates && \
    update-ca-certificates
COPY --from=builder /jec /opt/jec
RUN mkdir -p /var/log/jec && \
    chown -R jec:jec /var/log/jec && \
    chown -R jec:jec /opt/jec && \
    mkdir -p /var/tmp/jec && \
    chown -R jec:jec /var/tmp/jec
USER jec
ENV UV_CACHE_DIR=/var/tmp/jec/.cache/uv
ENTRYPOINT ["/opt/jec"]