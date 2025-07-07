# Stage 1: Build
FROM golang:1.24.4-bullseye AS builder

WORKDIR /go/src/github.com/ory/keto
RUN apt-get update && apt-get upgrade -y

COPY go.mod go.sum proto/go.mod proto/go.sum ./
RUN go mod download
COPY . .

RUN go build -buildvcs=false -o /usr/bin/keto .

# Final image with shell
FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl

COPY --from=builder /usr/bin/keto /usr/bin/keto
COPY config/keto.yml /etc/config/keto.yml
COPY config/relation-tuples/ /etc/config/relation-tuples/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 4466 4467

ENTRYPOINT ["/entrypoint.sh"]
