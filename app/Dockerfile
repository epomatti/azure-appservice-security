FROM golang:1.22-alpine AS builder

WORKDIR /build
COPY . .
RUN go build .

FROM golang:1.22-alpine

# Installing curl for healthcheck
RUN apk update
RUN apk upgrade
RUN apk --no-cache add curl

WORKDIR /app
COPY --from=builder /build/main .

ENTRYPOINT ["/app/main"]
