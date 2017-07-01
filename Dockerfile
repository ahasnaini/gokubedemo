FROM golang:1.8.1-alpine as Builder
ADD . /go/src/github.com/ahasnaini/gokubedemo/
RUN go install github.com/ahasnaini/gokubedemo/

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/bin/gokubedemo .
EXPOSE 80
CMD ["./gokubedemo"]
