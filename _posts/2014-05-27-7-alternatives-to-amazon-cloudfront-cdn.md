---
title: "7 Alternatives to Amazon CloudFront CDN"
layout: "post"
excerpt: "A comparison of the top content delivery networks for web content in 2014 with my recommendations. I'll be focusing on the needs for encryption and static html content."
category: cdn
tags: optimization, cdn, security, comparison
---
AWS CloudFront has many bizarre quirks:

 + only two invalidations of 1000 paths can run concurrently
 + each invalidation takes about 5-15 minutes to complete
 + there is no "clear all cache"
 + configuring gzip compression is nontrivial

I'm comparing the alternatives to CloudFront for static web content (html, css, js, images), specifically [Azure](http://azure.microsoft.com/en-us/documentation/services/cdn/), [CDNify](https://cdnify.com/learn/api), [CloudFlare](http://cloudflare.com), [CDNSun](http://cdnsun.com/), [Fastly](https://cdnify.com/learn/api), [KeyCDN](http://keycdn.com), and [MaxCDN](http://docs.maxcdn.com/) . I've picked only CDNs that made pricing information available (which eliminated most of the options I could find). Pricing *is* a feature, and typically CDNs without pricing information didn't disclose their feature set online either.

One CDN that looked fantastic but didn't make the cut was [Highwinds](http://highwinds.com/). They provide loads of documentation and a free trial, but no pricing information. 

## Pricing Comparison

| CDN        | Pricing Model            | Costs (US)        | HTTPS Pricing | Free Option |
| ----------:|:------------------------:| -----------------:| ------------- |:----------- |
| CloudFront | Per GB                   | $0.12             | $0 - SNI      | Y - 1 yr    |
| Azure      | Per GB                   | $0.12             | Unknown       | Y           |
| CDNify     | Flat Rate + Over *150*GB | **$10.00** + $0.07| $0            | N           |
| CloudFlare | Flat Rate                | **$20.00**        | $200/mo Plan  | Y           |
| CDNSun     | Per GB                   | $0.45             | $699/yr       | Y - 15 days |
| Fastly     | Per Request + Per GB     | *$0.01* + $0.12   | $1500/mo      | Y - 30 days |
| KeyCDN     | Per GB                   | $0.04             | $0            | N           |
| MaxCDN     | Flat Rate + Over *100*GB | **$9.00** + $0.08 | $39/mo        | N           |

 * "Per GB" (normal font) refers to bandwidth charges
 * **"Flat Rate"** (in bold) is per month fees. "Over ___ GB" specifies the included bandwidth
 * *"Per Request"* (in italics) refers to individual requests between edge and client
 
The standard going rate for CDN bandwith is 12&cent;. KeyCDN is the cheapest option, and CDNSun is priciest.

## Network Comparison

| CDN        | HTTPS | POPs | Latency | Gzip                  | Minification   |
| ----------:|:-----:| ----:| -------:|:----------------------|:-------------- |
| CloudFront | Y     |    50|       47|Y - in origin          | N              |
| Azure      | ?     |    30|       47|Y - in origin          | N              |
| CDNify     | Y     |    20|       77|Y                      | N              |
| CloudFlare | Y     |    25|       49|Y                      | N              |
| CDNSun     | Y     |    85|        ?|?                      | Y              |
| Fastly     | Y     |    20|       58|Y                      | N              |
| KeyCDN     | Y     |    15|        ?|Y                      | Y - images only|
| MaxCDN     | Y     |    15|       44|Y - in origin          | Y              |

 * There is no information about using HTTPS with Azure in the Microsoft documentation or pricing
 * "POPs" or Points of Presence refers to how many geographically separate data centers a CDN has (number of servers per data center can vary)
 * Latency is measured in milliseconds by [Cedexis](http://www.cedexis.com/reports/#?report=cdn_response_time&country=US) as of 5/26/2014
 * A "Y" for Gzip means that the CDN can transparently handle compression during transmission over the network for you. "Y - in origin" means your origin server must handle compression, but the CDN can intelligently serve compressed files

The only big difference between these CDNs IMHO is whether or not the CDN can handle Gzip compression for you without configuring an origin server. Ideally, you could just dump your pre-minified files onto a cloud storage service such as AWS S3 or RackSpace CloudFiles and let the CDN handle this for.

## Caching Behavior Comparison

| CDN        | Headers | Cookies | Query String | Protocol |
| ----------:|---------|---------|--------------|----------|
| CloudFront | Y       | Y       | Y            | N        |
| Azure      | Y       | Y       | Y            | ?        |
| CDNify     | ?       | ?       | ?            | ?        |
| CloudFlare | Y       | N       | Y            | Y        |
| CDNSun     | Y       | Y       | Y            | ?        |
| Fastly     | Y       | Y       | Y            | Y        |
| KeyCDN     | Y       | ?       | Y            | ?        |
| MaxCDN     | Y       | Y       | Y            | ?        |

 * "Headers" refers to respecting the origin's Cache-Control (or other caching specific) headers
 * All columns refer to the ability to vary the cached content served to visitors by examining this information

The winner in this category appears to be Fastly, with CDNify providing virtually no information about how configurable its caching behavior is.

## Configuration Comparison

| CDN        | Latency | Purge All | API|
| ----------:|---------|-----------|----|
| CloudFront | 10 mins | N         | Y  |
| Azure      | mins?   | ?         | N  |
| CDNify     | mins?   | Y         | Y  |
| CloudFlare | secs    | Y         | Y  |
| CDNSun     | mins?   | Y         | Y  |
| Fastly     | 1 sec   | Y         | Y  |
| KeyCDN     | mins    | Y         | N  |
| MaxCDN     | 30 sec  | Y         | Y  |

 * "latency" means the time required to update the edge servers with configuration changes (or purges/invalidations)
 * Except for AWS CloudFront, all latency information is taken from the self-reporting of each company's website
 * "mins?" means that the company did not state how long, and I assume changes will take minutes to propagate across edge servers

Fastly comes out ahead in this category, with MaxCDN and CloudFlare close behind.

## And the Winner Is...

For me, it's a toss up between KeyCDN and MaxCDN. I really like the fast configuration updates that MaxCDN boasts, but I wish the SSL/TLS pricing model was a bit cheaper. If you just want to get a CDN out there and don't want to do much configuration, Key CDN seems like the way to go.

Fastly is my third place runner up. The incredible documentation, low latency, and extreme configurability make it the power house in the group. Sadly, hosting a custom SSL certificate on Fastly costs a small fortune.
