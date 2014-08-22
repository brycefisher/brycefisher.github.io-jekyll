---
title: "Introducing DefaultErrors.rs"
layout: "post"
excerpt: "I'm officially unveiling DefaultErrors.rs, a piece of Middleware for IronFramework which provides custom error pages."
category: rust
---
I've recently built a library in Rust that provides default error pages for any HTTP status code. This library integrates with [IronFramework.io](http://ironframework.io), an express style framework with really fast response times.

<video id="default-errors-intro-video" class="video-js vjs-default-skin vjs-big-play-centered video"
  controls preload="auto" width="auto" height="auto"
  data-setup='{"example_option":true}'>
   <source src="/video/default-errors-intro-20140820.mp4" type='video/mp4' />
   <source src="/video/default-errors-intro-20140820.webm" type='video/webm' />
   <p class="vjs-no-js">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a></p>
</video>

## Obligatory Code Examples

**NOTE: This code sample compiles on the latest rust as of 8/20/2014.**

Once you've included defaulterrors as a dependency inside your cargo.toml file, you can set a default error text thusly:

{% highlight rust %}
fn main() {
  // Create the Iron server
  let mut server: Server = Iron::new();

  // Create a new DefaultErrors Middleware, and 
  // add default 404 response as plain text.
  let errors = DefaultErrors::new()
    .set_text(404, "Not Found".to_string());

  // Add errors to server and start responding to 
  // network requests.
  server.chain.link(errors);
  server.listen(Ipv4Addr(127, 0, 0, 1), 3000);
}
{% endhighlight %}

The key line is `set_text(404, "Not Found".to_string())`. This method sets a static text response to a 404 error. This is really really bare bones. In real life you'll probably want to deliver a static file:

{% highlight rust %}
fn main() {
  // Create the Iron server
  let mut server: Server = Iron::new();

  // Create a new DefaultErrors middleware,
  // and add the path to static file as the response.
  let errors = DefaultErrors::new()
    .set_file(404, "examples/404.html".to_string())
    .unwrap();

  // Add DefaultErrors middleware to the server, and
  // away we go!
  server.chain.link(errors);
  server.listen(Ipv4Addr(127, 0, 0, 1), 3000);
}
{% endhighlight %}

Notice that we have to unwrap the result of a call to `set_file()` because the path could fail to exist. More realistically,
you'd want to do `set_file(...).ok().expect("Oopsies! Couldn't get that file :-/");` so that you have some inkling what went wrong
if the file doesn't open for some reason.

## Give Me More

I can hear you saying, "But, Bryce, I want **more** control of my error messages." Never fear developer friend, I bring you a more potent way to respond to errors. Behold `set_function()`:

{% highlight rust %}
fn main() {
  // Create the Iron server.
  let mut server: Server = Iron::new();
  
  // Write a custom, dynamic error handler.
  fn custom_404s(req: &mut Request, _res: &mut Response) -> String {
    format!("404 File not Found - {}", req.url)
  }

  // Set 404's to invoke `custom_404s()` above.
  let errors = DefaultErrors::new()
    .set_function(404, custom_404s);

  // And away we go!
  server.chain.link(errors);
  server.listen(Ipv4Addr(127, 0, 0, 1), 3000);
}
{% endhighlight %}

The key thing to note is that functions must use the signature above: they should accept a borrowed mutable Request and Response object (respectively),
and they should return a String.

## Show Me Everything!

If I've piqued your curiosity, please do fork me on github and hack to your hearts delight: [DefaultErrors](https://github.com/brycefisher/defaulterrors).

<script src="/js/video.js"></script>
<script>
  videojs.options.flash.swf = "https://bryce.fisher-fleig.org/swf/video-js.swf"
</script>
