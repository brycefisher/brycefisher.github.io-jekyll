---
title: "Golang Testing stdlib Errors"
layout: "post"
excerpt: "Getting 100% test coverage in golang can be tricky when using the stdlib. Here's a list of ways to error several commonly used builtin funcs."
category: golang
---

It can be tough to get anywhere close to 100% code coverage when funcs in the "stdlib" can't be forced to error. This post takes you through several of the common funcs built in to golang and shows you how to trigger an error to help you bump up your code coverage. This list is short and skews heavily toward http, where I spend most of my time.

## encoding/json.Marshal

Marshal any `func`, `chan`, or `complex`:

{% highlight golang %}
serialized, err := json.Marshal(func(){})
{% endhighlight %}

[See in the playground](http://play.golang.org/p/FuQyHNHYNY)

## net/url.Parse()

Pass invalid hex strings:

{% highlight golang %}
u, err := url.Parse("%zzzzz")
{% endhighlight %}

[See in the playground](http://play.golang.org/p/OJk3B-86c3)

[See unit tests for unescape](https://golang.org/src/net/url/url_test.go#L705)

## net/http.NewRequest()

The url in `NewRequest()` also goes through `url.Parse()`, so we can reuse our url breaking tricks.

{% highlight golang %}
r, err := http.NewRequest("GET","/%zz", nil)
{% endhighlight %}

[See in the playground](http://play.golang.org/p/Xkr8IAYo8S)


## net/http.ListenAndServe()

We can pass an invalid port number to trip up `ListenAndServe()`. Full working example this time since this won't run in the playground.

{% highlight golang %}
package main

import (
  "net/http"
  "log"
)

func main() {
  h := func(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte(`Hello World`))
  }
  http.HandleFunc("/", h)
  log.Fatal(http.ListenAndServe(":9999999", nil))
}
{% endhighlight %}

If choosing the port is not an option, we can **cheat** on our unit test, and block that port on the host. However, the stdlib doesn't support this in any form, so you'd have to pick a stoppable http server like [tylerb/graceful](https://github.com/tylerb/graceful), like so:

{% highlight golang %}
package main

import (
  "fmt"
  "net/http"

  "gopkg.in/tylerb/graceful.v1"
)

func main() {
  // First block the port we care about
  h1 := func(w http.ResponseWriter, r *http.Request) {
    w.Write([]bytes(`Blocked`))
  }
  srv := &graceful.Server{
    Timeout: 5 * time.Second,
    Server: &http.Server{
      Addr: ":1234",
      Handler: http.HandlerFunc(h1)
    },
  }
  srv.ListenAndServe()

  // Now try to use the blocked port
  h2 := func(w http.ResponseWriter, r *http.Request) {
    w.Write([]bytes(`Blocked`))
  }
  fmt.Println(http.ListenAndServe(":1234", http.HandlerFunc(h2))

  // Stop the blocking server
  srv.Stop()
}
{% endhighlight %}

## net/http.Client

Often, you want a way to force a connection error to simulate problems with some API you're consuming as part of your service. Golang's stdlib provides the `RoundTripper` interface to allow us to customize interaction with the network.

{% highlight golang %}
package main

import (
  "errors"
  "fmt"
  "net/http"
)

// Force errors or responses of our choosing to be returned
type mock struct {}
func (s *mock) RoundTrip(r *http.Request) (*http.Response, error) {
  return nil, errors.New("Unable to connect")
}

func main() {
  client := &http.Client{ &mockRoundTripper{}, nil, nil, 0 }
  resp, err := client.Get("https://www.google.com")
  fmt.Println("resp=", resp)
  fmt.Println("err=", err)
}
{% endhighlight %}

## What Else?

If you run into a golang func that you can't break, post it in the comments here or tweet it to me.
