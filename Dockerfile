# Build
FROM quay.io/projectquay/golang:1.20 as build

WORKDIR /build
COPY . .
RUN make clean && make build


FROM scratch
# FROM alpine
WORKDIR /app
COPY --from=build  /build/dron-go-telebot* .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/app/dron-go-telebot"]
# ENTRYPOINT [ "/bin/sh" ]
EXPOSE 8080

# FROM alpine
# FROM busybox
# WORKDIR /app
# COPY dron-go-telebot* .
# ENTRYPOINT ["/app/dron-go-telebot"]
# ENTRYPOINT [ "/bin/sh" ]