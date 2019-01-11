# build from latest go image
FROM golang:latest as build

WORKDIR /go/src/github.com/mchmarny/kueue/
COPY . /src/

# build gauther
WORKDIR /src/
ENV GO111MODULE=on
RUN go mod download
RUN CGO_ENABLED=0 go build -o /kueue



# run image
FROM alpine as release
RUN apk add --no-cache ca-certificates

# app executable
COPY --from=build /kueue /app/

# static dependancies
COPY --from=build /src/templates /app/templates/
COPY --from=build /src/static /app/static/

# start server
WORKDIR /app
ENTRYPOINT ["./kueue"]