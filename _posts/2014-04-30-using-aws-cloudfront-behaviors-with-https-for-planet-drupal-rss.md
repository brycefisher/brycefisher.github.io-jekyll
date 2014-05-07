---
title: "Using AWS CloudFront Behaviors with HTTPS for Planet Drupal RSS"
layout: "post"
excerpt: "Many RSS validators and aggregators (including Planet Drupal) do NOT work over HTTPS. If you're using CloudFront to serve your site exclusively over HTTPS, I'll show you how to configure an additional behavior to switch specific URL patterns back to HTTP."
category: planet_drupal
tags: aws, cloudfront
---
After all the relevations of Snowden last year, I've been wanting to be more security focused. A small but obvious change is providing this blog over HTTPS. Disqus powers the comments, and if you login via Disqus I'd like to protect my visitors session cookies or authentication information. I felt so proud [to have setup a CDN powered, encrypted blog]({{ site.url }}{% post_url 2014-04-24-setting-up-ssl-on-aws-cloudfront-and-s3 %}).

Unfortunately, I discovered that [RSS feed aggregators](http://feedvalidator.org/check.cgi?url=https%3A%2F%2Fbryce.fisher-fleig.org%2Fcategories%2Fplanet-drupal%2Ffeed.xml) and [validators are incompatible with HTTPS](http://validator.w3.org/feed/check.cgi?url=https%3A%2F%2Fbryce.fisher-fleig.org%2Fcategories%2Fplanet-drupal%2Ffeed.xml). Based on my experience, it seems that the Drupal.org aggregators that power the illustrious Planet Drupal also fail in the face of HTTPS.

## Oh, Behave - a CloudFront workaround with Behaviors

If you're using CloudFront, it's actually very simple to serve your feeds over HTTP and redirect everything else to HTTPS. Let's assume you already direct all your traffic to HTTPS. Here's how to add an exception:


 1. Open CloudFront in Web Console
 2. Edit the Distribution
 3. Click on "Behaviors"
 4. Add a new behavior, setting the following settings:
    * <strong>Path Pattern</strong> - setup a regex that matches your RSS feeds. I set all my RSS feeds as feed.xml, so for me this value was "*/feed.xml"
    * <strong>Origin</strong> - choose your existing Origin from the dropdown list
    * <strong>Viewer Protocol Policy</strong> - use the default setting here (this setting is the important one)
 5. Save it!
 
Once your distribution finishes updating the edge servers, you should be able to access your feed over HTTP (and HTTPS), but everything else should redirect to HTTPS. Tada!

## Why Would RSS Aggregators Not Be  HTTPS Compatible?

Dave Winer, one of the creators of feedvalidator.org, writes that switching the aggregator to HTTPS 
has a huge potential downside of losing parts of your audience with software that doesn't support HTTPS. 

Furthermore, he writes:

> ... All aggregators will support HTTPS if enough developers of feeds require it.
> 
> If it should turn out that way, ... I'll do it. And I'll be pissed because it's time I'd rather spend
> doing something creative. ... I can't see for the life of me why you need to push 
> RSS over a secure connection. :-)

(See [blog post Dec 3, 2012](http://threads2.scripting.com/2012/december/shouldFeedsUseHttps)).

### Dave has a point

It does seem unnecessary, actually, to encrypt connections between RSS feeds and aggregators. If the feed is meant
to be public, then hopefully no sensitive information is being transmitted in the feed. Also, I hate the drudgery
of meaningless work and would be loathe to impose it on anyone else.

### Maybe we should do it anyway.

Since December 2012, the new [HSTS HTTP headers](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security) have taken hold in browser-land. These headers allow servers to instruct browsers to only access the server over HTTPS for a certain period of time. It's like a cache TTL.

HSTS headers are designed to prevent certain kinds of man-in-the-middle attacks. If a website is following the best practice of using HSTS headers in response to the pervasive threat that the NSA, GCHQ, China, Russia, and roving bands of hackers, then that site won't be able to syndicate a feed from the HSTS domain.

Finally, what about private RSS feeds? Shouldn't we be able to leverage run of the mill aggregators for use cases such as for UPS package delivery? What about notification from the government that our new passport has been approved and will be shipped Monday? I can also imagine private feeds from Etrade notifying customers that an automated transaction occurred. The possibilities for private feeds are really endless, especially once one starts considering the coming Internet of Things.
