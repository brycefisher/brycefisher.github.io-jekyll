---
title: "Golang Testing stdlib Errors"
layout: "post"
excerpt: ""
category: golang
---

It can be tough to get anywhere close to 100% code coverage when funcs in the "stdlib" can't be forced to error. This post takes you through several of the common funcs built in to golang and shows you how to trigger an error to help you bump up your code coverage.

## encoding/json.Marshal

Pass any `func`, `chan`, or `complex` into `json.Marshal()`:

```go
serialized, err := json.Marshal(func(){})
```

[See in the playground](http://play.golang.org/p/FuQyHNHYNY)

## net/url.Parse()

Pass invalid hex strings:

```go
u, err := url.Parse("%zzzzz")
```

[See in the playground](http://play.golang.org/p/OJk3B-86c3)

[See unit tests for unescape](https://golang.org/src/net/url/url_test.go#L705)

## net/http.NewRequest()

The url in `NewRequest()` also goes through `url.Parse()`, so we can reuse our url breaking tricks.

```go
r, err := http.NewRequest("GET","/%zz", nil)
```

[See in the playground](http://play.golang.org/p/Xkr8IAYo8S)


## net/http.ListenAndServe()

We can pass an invalid port number to trip up `ListenAndServe()`. Full working example this time since this won't run in the playground.

```go
package main

import (
	"net/http"
	"log"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(`Hello World`))
	})
	log.Fatal(http.ListenAndServe(":9999999", nil))
}
```

If choosing the port is not an option, we can **cheat** on our unit test, and block that port on the host. However, the stdlib doesn't support this in any form, so you'd have to pick a stoppable http server like [tylerb/graceful](https://github.com/tylerb/graceful), like so:

```go
package main

import (
	"net/http"
	"log"

	"gopkg.in/tylerb/graceful.v1"
)

func main() {
	// First block the port we care about
	blockHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Write([]bytes(`Blocked`))
	})
	srv := &graceful.Server{
		Timeout: 5 * time.Second,
		Server: &http.Server{Addr: ":1234", Handler: blockHandler},
	}
	srv.ListenAndServe()

	// Now try to use the blocked port
	testHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Write([]bytes(`Blocked`))
	})
	log.Fatal(http.ListenAndServe(":1234", testHandler))

	// Stop the blocking server
	srv.Stop()
}
```
