---
title: "A Script to Keep the Rust Compiler Updated"
layout: "post"
excerpt: "Rust is still a bit unstable, but the community is now providely nightly builds of the compiler binary for most platforms. Here's a quick shell script to help keep your compiler up to date."
category: rust
---
I'm very excited about Rust, the safe concurrent language from Mozilla. Like Golang, it's positioned to be a general purpose replacement for C++ and C. The language is still very much in development, and syntax and crate names are changing pretty regularly, although Rust 1.0 is rumored to be coming along soon(ish).

## For Ubuntu

Currently, rust is not stored in apt-get. Here's a shell script for Ubuntu to help you stay up to date:

{% highlight bash %}
#!/bin/sh
 
curl http://static.rust-lang.org/dist/rust-nightly-x86_64-unknown-linux-gnu.tar.gz >> rust-nightly.tar.gz
tar xvf rust-nightly.tar.gz
cd rust-nightly-x86_64-unknown-linux-gnu
./install.sh
cd ..
rm -rf rust-nightly-x86_64-unknown-linux-gnu
rm rust-nightly.tar.gz
{% endhighlight %}

You'll need to make this script executable (`chmod +x update-rust.sh`) and run it using `sudo ./update-rust.sh`.

## For Other Platforms

If you're on a Mac, homebrew has a recipe for rust already, although I'm not sure how up to date it is.

Even on OSX, I recommend setting up a virtualbox instance running Ubuntu. In my experience, OSX can be tricky to keep up to date, especially if you need particular build dependencies. Ubuntu (or any other flavor of Linux) will be easier to manage.

## Preparing for Disaster

Using a virtualbox, I highly recommend you create snapshots of your running instance prior to running the shell script. That way, if something goes apocalyptically wrong with your rust source code or the nightly build has a serious defect, you can quickly revert to the snapshot.
