---
title: "Important Iron Middleware that needs creating"
layout: "post"
excerpt: "Although I love working in Iron, there's still a lot of libraries that need to be written. Here's a few that come to mind."
category: rust
---
Have you already written a Middleware library for [Iron](http://ironframework.io)? Let me know on [twitter](https://twitter.com/BryceAdamFisher) or in the comments. I'd love to update this list and promote your project.

I try to stay in the loop with [reem](https://github.com/reem) about what's coming down the pipe. Under some of these headings, you'll find projects that reem is already planning to tackle, and possibly the relevant github issue to discuss it. 

Here's what Iron already does (not exhaustive):

 * [Routing](https://github.com/iron/router)
 * [Cookie-ing](https://github.com/iron/cookie)
 * [Json decoding](https://github.com/iron/body-parser)
 * [Serving static files](https://github.com/iron/static-file)
 * [Path aliasing](https://github.com/iron/mount)
 * [Console logging](https://github.com/iron/logger) -- this could be substantially more informative and be set to log to predefined system location.
 * [Url decoding](https://github.com/iron/urlendcoded)
 * [Serving default error pages](https://github.com/brycefisher/defaulterrors) -- by moi, needs some more thorough testing and development
 * [Persisting data in memory](https://github.com/iron/persistent)
 * [Mocking HTTP requests](https://github.com/reem/iron-test) -- may be badly out of date

## Templating Engine

**reem is already [thinking hard about this](https://github.com/iron/iron/issues/125).** IMHO, this is really the highest priority for Iron. Without some path toward using a templating engine, there's no reason to use this framework at your day job.

There are already a number of mustache libraries written in rust, so the main thing that blocking this currently is accessing app-wide configuration within a Middleware handler function.

## HTTP Clients

Currently, Rust is very handicapped in the http client department. So that means Iron can't do Oauth or any other kind of API consumption easily. This is a general problem in Rust and not specific to Iron. [Chris Morgan](https://github.com/chris-morgan) is working on a library for both HTTP servers and clients called [Teepee](http://teepee.rs), but it's a long way from done. I recommend reaching out to Chris, sfackler, brson, or other pillars of the Rust community if you're keen to working with HTTP (aka RESTful) APIs.

## Default Cache Headers

For decent performance, you'll want to instruct browsers (or CDNs) how long to cache images, scripts, and static assets. This would be a huge pain to set these HTTP headers inside all the relevant routes, so you'd want a way to examine the request and conditionally set arbitrary expires/max-age/etc headers in bulk.

Also, you want to be able to cache certain routes entirely for the benefits of CDNs. Ideally you'd want to match the route against a glob or regex pattern, and then set the cache headers (or NO cache headers). 

A super simple (and probably overly naive) approach would be to store default cache configuration in some sort of collection:

{% highlight rust %}
enum Time {
  None,
  Seconds(uint),
  Minutes(uint),
  Hours(uint),
  Days(uint),
  Weeks(uint),
  Months(uint),
  Years(uint)
}

enum PatternType {
  Glob(String),
  Extension(String),
  MimeType(String),
}

enum Header {
  MaxAge,
  Expires,
  Etag,
  SMaxAge
}

let mut cache_conf = HashSet<(PatternType, vec<(Header, Time)>)>
{% endhighlight %}

Then, in your middleware, you'd check the request object against the pattern type. If it was a match, you'd iterate through the tuples of headers and their values and set them on the response headers.

## Gzip

In the performance department, there should be a way to gzip/deflate content prior to sending it over HTTP. I'm not aware that anyone is discussing this functionality.

## Redirects

I seriously hate redirects. However, people want them...it may be necessary to build faster horses. Also, I'm not a 100% this doesn't exist, and it would be relative easy to hack something together.

## Basic Auth

Basic remains one of the best way to run a staging server because it blocks search engines, but allows employees, QA, and stakeholders to preview the content/functionality without exposing it to search engines. (You don't really think google cares about robots.txt do you?)

Ideally, this Middleware would be able to read a .htpasswd file from Apache land, or pass off the authentication to a Boolean function. The Boolean function then could connect to LDAP, a database, or perform some kind of stateless logic on the user/password to determination if the request is authorized or not.

## Caching

I would guess that reem is thinking a lot about this, but I haven't asked him about it. I hesitate to put this one up here because I hate working with application level cache. In my ideal world, a CDN proxies requests to any application with requires caching. That way, you can always directly see what the applications output is without fretting that perhaps you're seeing a stale result.

Even in my ideal world, you'd want to consume the API for your CDN to clear all or part of the cache at key moments (such as when content is updated in the database).

## A Fully Fleshed out Example Site

Several attempts have been made to build working sites in Iron. If you've done this, please do let me know and I'll share a link to public repository. I'd also love to hear what challenges you encountered and what other Middleware you had to write (or wished someone else had written).

There are decent Postgres bindings in Rust and there's an Openssl binding as well. However, I have yet to example demonstrating how to build an Iron server that connects to a database or is delivered over HTTPS. Hell, I haven't see an Iron server with a form handler.

A relatively simple example site that would be hugely helpful, would be a site that exposed a RESTful API even for one endpoint. 

## Talk to Us!

If you're interested in working on any of these projects, checkout the [#iron channel in Mozilla's IRC channel](http://client00.chat.mibbit.com/?server=irc.mozilla.org&channel=%23iron).

I've almost certainly missed libraries and other functionality already built. Please send me corrections!
