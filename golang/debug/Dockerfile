FROM

RUN go get github.com/derekparker/delve/cmd/dlv

WORKDIR /go/src/

CMD [ "dlv", "debug", "main.go", "--listen=0.0.0.0", "--headless=true", "--api-version=2", "--log" ]