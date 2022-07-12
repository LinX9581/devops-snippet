package main

import (
    "fmt"
    "net/http"
    "strings"
    "log"
)

// curl 127.0.0.1:9100/?url_long=111\&url_long1=222
func sayhelloName(w http.ResponseWriter, r *http.Request) {
    r.ParseForm()  //解析參數，預設是不會解析的
    fmt.Println(r.Form)  //這些資訊是輸出到伺服器端的列印資訊	output map[url_long:[111] url_long1:[222]]
    fmt.Println("path", r.URL.Path)		// request 路徑
    fmt.Println("scheme", r.URL.Scheme)
    fmt.Println(r.Form["url_long1"])
    for k, v := range r.Form {	
        fmt.Println("key:", k)
        fmt.Println("val:", strings.Join(v, ""))
    }
    fmt.Fprintf(w, "Hello astaxie!") //這個寫入到 w 的是輸出到客戶端的
}

func main() {
    http.HandleFunc("/", sayhelloName) //設定存取的路由
    err := http.ListenAndServe(":9100", nil) //設定監聽的埠
    if err != nil {
        log.Fatal("ListenAndServe: ", err)
    }
}