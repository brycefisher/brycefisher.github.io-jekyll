---
title: "Avoiding the Duplicate Content Penalty with AWS S3 and CloudFront"
layout: "post"
excerpt: "Google and other search engines penalize content plagiarized from other sources. However, if you're using S3 as an origin server for CloudFront, you may be in danger of the duplicate content penalty! This post explains two strategies to combat this problem."
---
As soon as I setup this blog on CloudFront using S3 as the origin server, my friends immediately started telling me I was at risk of [the duplicate content penalty](https://support.google.com/webmasters/answer/66359?hl=en) Google imposes on sites that have nearly identical content. After many hours of pouring over Stackoverflow to no avail, I found two strategies to protect my blog: canonical urls and user-agent based S3 bucket policies.

If you're hosting your blog or site on S3 without CloudFront, the duplicate content penalty is not an issue for you in the same way. Don't attempt to use the S3 bucket policies described here.

## Strategy 1: User Agent Policies in AWS S3

This strategy actively shields your content from being discoverable by search engine crawlers, so it's likely to be much more effective. Unfortunately, it's not fool proof and it's dependent on AWS CloudFront implementation details that could change without any public notice. In particular, we're relying on the User-Agent string that CloudFront uses for it's GET requests to your S3 bucket. Here's what to do:

 1. Go your AWS Web Console and go to the S3 service
 2. Expand the Permissions tab for your website's bucket
 3. Click "Edit Bucket Policy"
 4. The JSON snippet in the Policy Editor should look like this:

{% highlight json %}
    {
        "Version":"2012-10-17",
        "Statement": [
            {
               "Sid":"PublicReadGetObject",
               "Effect":"Allow",
               "Principal": {
                    "AWS": "*"
                },
                "Action":"s3:GetObject",
                "Resource":"arn:aws:s3:::bryce-fisher-fleig-org/*"
            }
        ]
    }
{% endhighlight %}
 
 5. Underneath the line starting with "Resource", add this:
 
        "Condition": {
				"StringEqualsIgnoreCase": {
					"aws:UserAgent": "Amazon CloudFront"
				}
			}

The whole should probably look something like this:

    {
    	"Version": "2012-10-17",
    	"Statement": [
    		{
    			"Sid": "Allow CloudFront to read from Bucket",
    			"Effect": "Allow",
    			"Principal": {
    				"AWS": "*"
    			},
    			"Action": "s3:GetObject",
    			"Resource": "arn:aws:s3:::bryce-fisher-fleig-org/*",
    			"Condition": {
    				"StringEqualsIgnoreCase": {
    					"aws:UserAgent": "Amazon CloudFront"
    				}
    			}
    		}
    	]
    }

### Did It Work??

If you did everything right, your site should still be accessible through the CloudFront url. Check a url that hasn't been cached in CloudFront yet (or do an invalidation). Go check right now, I'll wait. 

If new urls are coming through CloudFront okay, then make sure that your S3 website endpoint returns 403 Access Denied. Go, look up the website endpoint in your S3 console. If you received some kind of 403 error, Google's crawler shouldn't be able to access your S3 bucket directly. Congrats! No more duplicate content penalty for you.

### Safety First

Obviously, you'll need to change bryce-fisher-fleig-org to the name of your bucket. Also, you'll need to make sure that whatever other permissions you have make sense with this rule, which is beyond the scope of this article.

I recommend setting up S3 to log into a separate bucket so that you can see the access log of what CloudFront is doing to your website bucket.

### Why CloudFront Origin Access Identity Sucks

As a quick aside, CloudFront does provide a mechanism that allows direct access between CloudFront and S3 without all this user agent smoke and mirrors nonsense. It's called Origin Access Identity, but it's incompatible with S3 when you enable the static website hosting mode for your bucket. If AWS gets around to fixing Origin Access Identity, you won't need this hack anymore. Fingers crossed!

## Strategy 2: Canonical Url Links

Let's take a look at the second strategy to avoid duplicate content penalties: canonical urls in a link tag. All you have to do is a link tag with rel canoncial and href `http://your/real/url/here`. You can look at the source code of this page, or do something like the following:

    <link rel="canonical" href="https://bryce.fisher-fleig.org/blog/avoiding-duplicate-content-penalty-with-aws-s3-and-cloudfront">

This technique is much weaker in that we're providing suggestions to Google's crawlers, but we can't force the crawlers to comply. Nevertheless, if your mother always taught you it's not polite to user agent sniff, canonical url links are completely kosher. Also, they won't randomly take your site down when CloudFront gets a new user agent.

This technique can be really handy on Drupal sites (which provide most content at two urls) or [potentially for marketing campaigns with various url parameters or in other situations](https://yoast.com/canonical-url-links/).
