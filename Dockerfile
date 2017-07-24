# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang:1.8.1-alpine

# Copy the local package files to the container's workspace.
ADD . /go/src/github.com/ahasnaini/gokubedemo/

RUN go install github.com/ahasnaini/gokubedemo/

# Run the gokubedemo command by default when the container starts.
ENTRYPOINT /go/bin/gokubedemo

# Document that the service listens on port 80.
EXPOSE 80
