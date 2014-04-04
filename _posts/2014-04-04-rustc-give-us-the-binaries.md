---
title: "rustc: Give Us the Binaries and No One Gets Hurt"
layout: "post"
excerpt: "Rust 0.10 was just released. The biggest change? The Rust community will be distributing binary forms of the compiler, rustc, going forward. Hooray!"
category: rust
---

[Rust 0.10 was just released yesterday](https://mail.mozilla.org/pipermail/rust-dev/2014-April/009387.html), 
and it contains approximately 1500 changes. Included in the list are relatively major changes from the previous
release including the removal of a whole class of memory lifecycle management syntax. Although I hadn't mastered
these points of syntax yet, I'm still a little sad to see so much change. It's nearly impossible to keep up with what
is well formed Rust.

On the flip side, there are a few changes that I'm really, really happy about:

 1. **Binary forms of the compiler are now distributed!** This means, to get up and running, you don't have to 
compile the compiler anymore...which is awesome, because rust was starting too feel a little to post-modern
for a second there. Also, on my old Asus laptop, it takes *over 2 hours* to compile. I think this change alone
will open up the language to much larger set of users.

 2. **Error messages with lifetimes will often suggest how to annotate the function to fix the error.** Great
interfaces aren't just for guis -- cli tools that really explain the problem (and likely solution) make my life
a lot happier. I think Homebrew excels as an interface in this regard. I'm super happy that Rust also takes 
the experience of debugging compile time errors seriously. Already in the 0.9 release, I was already much happier
debugging rust than javascript (which I've been working with for 15 years).

