FROM golang:1.25.1 as builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -o /app/go-app ./cmd/server/main.go

FROM alpine:3.18

WORKDIR /app

COPY --from=builder /app/go-app /app/

EXPOSE 8080

CMD ["/app/go-app"]