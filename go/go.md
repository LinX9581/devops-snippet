go version
ubuntu 20.04 go1.13.8

sudo apt-get install golang

# 安裝最新版
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go

# 指定版本
sudo add-apt-repository ppa:gophers/archive
sudo apt update
sudo apt install golang-1.13.8-go


vim ~/.profile

export GOROOT=/usr/lib/go-1.13
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

source ~/.profile

sudo apt-get install build-essential

# var
var vname1, vname2, vname3 type= v1, v2, v3
no, yes, maybe := "no", "yes", "maybe"    //簡化寫法 系統自動判定型別 只能在func內運作

# hello world
mkdir go
cd go
go mod init example/hello
cat>/go/hello.go<<EOF
package main

import "fmt"
import "rsc.io/quote"

func main() {
    fmt.Println("Hello, World!")
    fmt.Println(quote.Go())
}
EOF
go run hello.go
go mod tidy