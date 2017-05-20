package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
)

func main() {

	resp, err := http.Get("https://canhazip.com/")
	if err != nil {
		fmt.Println(err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	fmt.Print("v1 - " + string(body) )
	fmt.Println(time.Now().Format(time.RFC850))
}