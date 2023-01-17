FROM golang

WORKDIR /app

ADD go.* .
RUN go mod download -x

ADD . .

RUN go build ./cmd/server

ENTRYPOINT ["/app/server"]
