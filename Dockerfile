# Build
FROM quay.io/projectquay/golang:1.20 as build

WORKDIR /build

COPY . .

RUN make clean && make build

# App
FROM scratch

WORKDIR /app

COPY --from=build  /build/go-telebot* .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT ["/app/go-telebot"]
EXPOSE 8080