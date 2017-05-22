# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang:1.8.1-alpine

# Copy the local package files to the container's workspace.
ADD . /gokubedemo/

# Build the outyet command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
#RUN go install github.com/golang/example/outyet

# Run the outyet command by default when the container starts.
ENTRYPOINT ["./main"]gi