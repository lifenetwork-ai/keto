# Stage 1: Build
FROM golang:1.24.4-bullseye AS builder

WORKDIR /go/src/github.com/ory/keto

RUN apt-get update && apt-get upgrade -y

COPY go.mod go.mod
COPY go.sum go.sum
COPY proto/go.mod proto/go.mod
COPY proto/go.sum proto/go.sum

RUN go mod download

COPY . .

RUN go build -buildvcs=false -o /usr/bin/keto .

# Final minimal image
FROM gcr.io/distroless/base-debian12:nonroot AS runner

COPY --from=builder --chown=nonroot:nonroot /usr/bin/keto /usr/bin/keto
COPY config/keto.yml /etc/config/keto.yml
COPY config/relation-tuples/ /etc/config/relation-tuples/
COPY entrypoint.sh /entrypoint.sh

USER nonroot
ENTRYPOINT ["/entrypoint.sh"]
