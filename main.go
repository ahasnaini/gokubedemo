package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
	"log"
)

func main() {

	http.HandleFunc("/", GetIP) // set router
	err := http.ListenAndServe(":80", nil) // set listen port
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

func GetIP(w http.ResponseWriter, r *http.Request) {

	resp, err := http.Get("https://canhazip.com/")
	if err != nil {
		fmt.Println(err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	fmt.Fprintf(w, "v2 - " + string(body) ) // send data to client side
	fmt.Fprintf(w, time.Now().Format(time.RFC850)) // send data to client side
}