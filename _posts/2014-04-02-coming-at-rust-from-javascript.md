---
title: "Coming at Rust From JavaScript"
layout: "post"
excerpt: "My explorations in Rust and having to wrestle with a statically typed language"
category: rust
---

Two months ago, I watched [a very inspiring talk about Servo](http://paulrouget.com/e/servopres/), Mozilla's experimental new layout engine written in Rust. 

<video controls src="http://mirrors.dotsrc.org/fosdem/2014/UD2218A/Saturday/Servo_building_a_parallel_web_browser.webm">
    http://mirrors.dotsrc.org/fosdem/2014/UD2218A/Saturday/Servo_building_a_parallel_web_browser.webm
</video>

I started playing but having no formal background in computer science, I shied away from such a low level language especially since I'm a web developer by day. A few days ago, Jared Forsyth [wrote](http://jaredly.github.io/2014/03/22/rust-vs-go/index.html),

> Conclusion: I'm betting on Rust. ...once Rust settles down and matures a bit its superior design will shine through and it will become really popular.


## Betting on Rust

Rust is still changing rapidly, so it's probably not yet a good idea to build anything too serious with it. However, I'd like to think that Rust might become a good replacement language one day to power cloud-hosted, stateless web services and APIs. Having some experience with Rust now seems like a good bet for the future. Since Mozilla is investing heavily in building an new experimental layout enging, Servo, Rust is seems likely that a lot of the code created by the Servo project will be generally useful to the web development community once Rust matures.

So to teach myself Rust, I've been trying to write a simple cli tool that can scan Craigslist RSS feeds for interesting items in my price range. I'm web developer, so I'm really interested in the networking features of the language. Once you've built the rustc compiler, check out my github repo, [Iron Santa](https://github.com/brycefisher/iron-santa).

## Struggles with Types

There are two  main problems I'm running into from my background in JavaScript.

Firstly, there is no automatic type conversion. So, for example there's no "truthy" or "falsy" values in Rust. Also, strings are kind of a pain to work with. Fortunately, I can usually work around this problem easily by using functions in the standard library that have a different signature (and I thought PHP had a lot of built-in functions!), but it requires a lot more thinking about types. Also, wrapping my head around the [Option enum](http://static.rust-lang.org/doc/0.9/std/option/enum.Option.html) is something I'm still working on.

Secondly, pointers and dereferencing is totally foreign concept. I just found this [very helpful explanation of "ownership"](http://words.steveklabnik.com/a-30-minute-introduction-to-rust), but passing values between functions requires a lot more attention to detail.

## The Good Parts

I have to say, match syntax are my favorite thing about Rust so far. With structs, it's fabulously easy to create class-like objects that simply contain data in logically named fields. I love how many great structs are already built in to the standard library and the extra crate.

Another benefit of playing Rust is that I'm relearning HTTP concepts by writing the nuts of bolts of my own HTTP client for my Iron Santa project. 
