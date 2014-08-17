---
title: "A Script to Keep the Rust Compiler Updated"
layout: "post"
excerpt: "Rust is still a bit unstable, but the community is now providely nightly builds of the compiler (rustc and rustdoc) and package manager (cargo) binaries for most platforms, and a shell script that will automatically install the latest nightly build for your platform."
category: rust
---
I'm very excited about Rust, the safe concurrent language from Mozilla. Like Golang, it's positioned to be a general purpose replacement for C++ and C. The language is still in development, although Rust 1.0 is rumored to be coming along soon(ish).

## Introducing rustup.sh

TL;DR - this is the now the best way to quickly update the global installation of rust on Travis or your developmentn environment:

{% highlight bash %}
$ curl https://static.rust-lang.org/rustup.sh | sudo sh
{% endhighlight %}

**If you're on Windows, don't use the above script.** You should probably download the latest installer from [www.rust-lang.org](http://www.rust-lang.org). 

## Preparing for Disaster

Using a virtualbox, I highly recommend you create snapshots of your running instance prior to running the shell script. That way, if something goes apocalyptically wrong with your rust source code or the nightly build has a serious defect, you can quickly revert to the snapshot.

## Update August 17, 2014

For over a month now, the rust community has provided a shell script called `rustup.sh` for updating all major *nix platforms. If you previously used the shell script here, you should instead use `rustup.sh` going forward. `rustup.sh` installs the compiler (rustc), documentation builder (rustdoc), and package manager (cargo). 

The old script on this page (and older versions of `rustup.sh`) insecurely downloaded files over HTTP without SSL and then immediately executed that script with root permissions -- a fantastic recipe for hijacking your machine.

I'm very proud of the Rust community for making a commitment to security and using an encrypted connection to deliver both `rustup.sh` and the binaries, despite initial worries about the CDN costs.
