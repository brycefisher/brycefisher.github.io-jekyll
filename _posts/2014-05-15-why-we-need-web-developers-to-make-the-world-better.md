---
title: "How Web Developers Can Make The World a Better Place"
layout: "post"
excerpt: "Web Developers are now the general contractors for the Panopticon we call 'The Internet.' Whether we act as tools of the prison wardens or allies of the inmates is up to us."
category: society
tags: security
---
In some ways, Edward Snowden's revelations were a new 9/11. It's not a perfect analogy -- no one died. But our 
na&iuml;vet&eacute; about the intentions and wide spread surveillance of American citizens by the US government
was irrevocably shattered. We learned that nearly all of our electronic transactions, communications, and even
each of our physical movements are monitored and recorded *en mass*. 

Fortunately, Snowden revealed some useful information about NSA monitoring works, and we can use that 
information to change the game.

## The Panopticon

The famous utilitarian philosopher Jeremy Bentham coined the phrase "Panoptic" for such an all seeing presence
designed. Later, Michel Foucault further refined the idea of the "Panopticon" as an entity that is all seeing, but
rarely seen. Although each prisoner knows that she can not be actively observed at every moment and some deviant
behavior will go unpunished, nevertheless she cannot even guess when the observer is focused on her. Thus, she
must assume that she could be under active monitoring at every moment. Such a fear is a powerful motivator to
conform.

Similar to Foucault's Panopticon, the NSA's monitoring capabilities are virtually without limit, able to gag 
tech companies by making surveillance requests a matter of "National Security." But intelligence agencies can
also tap directly into the "backbones" of the internet in strategic urban locations (like AT&amp;T Park in
San Francisco). Thanks to Snowden, we now know that we are all under constant surveillance, despite the fact that
it's unlikely the NSA will monitor our actions at any particular moment, they have the ability to retroactively
examine our past communications, interactions, and movements if anyone connected to us becomes remotely 
suspicious.

## What Can Meager Web Developers Do?

We can't dismantle the NSA or hack into their datacenters, but we're not powerless. We know that strong
encryption obscures attempts to monitor us, and we are the general contractors of a large fraction of the 
internet we call the "Web." That puts us in a unique position to make warrantless surveillance an expensive
option for the NSA (and othe alphabet soup clandestine agencies).

### Use Encryption in your Projects

If you are serving websites over `http`, bookmark [cheapestssls.com](http://cheapestssls.com/) right now 
and use SSL on your next web project. I've written detailed instructions on how to [setup a static site 
on AWS using S3, CloudFront, and SSL]({% post_url 2014-04-24-setting-up-ssl-on-aws-cloudfront-and-s3 %}).

Once you've setup TLS on your web properties, prevent man-in-the-middle attacks by using HSTS headers.
HSTS headers essentially ask browsers to cache the protocol for a certain period of time, forcing would
be attackers to up their game.

You've setup TLS on your web properties? Great! Now go setup "Perfect Forward Secrecy" or **PFS**. PFS 
basically means that each connection uses different key pairs. This means that even if one connection 
is compromised, the next one will be secure.

### Consider Alternatives to Compromised Services

We know that Google is being compelled to share their user data with the NSA and they have very limited
ability to disclose what they are sharing. Consider alternatives to Google Analytics like Piwik. 

Piwik may not be right for everyone -- you'll have to install and maintain it yourself on your own server.
However, Piwik provides a compelling set of features that probably meet the needs of brochureware, personal
blogs, and general purposes traffic analytics needs. Because Piwik is run on your own servers, NSA will have
to hack into your server or subpoena you to find the traffic stats. This is much harder than just filing 
another request to Google and raises the cost of monitoring your visitors. 

Here's some of the features of Piwik:

 + Mobile app for Android and iPhone
 + Custom event traffic
 + Traffic segmenting
 + Annotations
 + Configurable charts and graphs
 + Multi-domain and multi-user
 + Browser, OS, screen, and other client characteristics detection

### Be Smart About Social Sharing Widgets

Every single Google Plus, Pinterest, LinkedIn, Disqus, and Twitter social sharing widget is an analytics
tool that allows these companies to monitor traffic and user behavior across the web. Because the NSA
regularly requests this data from big companies, these social widgets form a dragnet that we've all opted 
in to. These social sharing widgets slow down our sites load time by as much one to two seconds each, and
slower load time means less visitor engagement.

**Don't install another social sharing widget**. So far as I know, Twitter first innovated the "web intent".
Instead of forcing you to embed a slow and panoptic social plugin, Twitter allows you to format links that
trigger a new follow or new tweet action without embedding any Javascript on your site. This is faster and
more private for your visitors. Facebook and other social networks have followed suit. Look for opportunies
to replace your curent social sharing widgets with non-Javascript alternatives that work like Twitter web
intents.

There are some tradeoffs here. I use Disqus on this site because they offer the easiest way for mobile visitors
to share feedback with having to register with me. However, I could protect your privacy a bit better by
only activating Disqus when users scroll to the bottom, or click on "Discuss", etc.

*If you're interested in fighting the scourge of social sharing widgets, see my article on 
[improving your page load time]({% post_url 2013-06-08-7-steps-to-improving-page-load-time-on-shared-hosting %}).*

### Empower Users to Make Choices about Our Analytics

The EU currently forces sites using Google Analytics (etc) to give users an opt-out widget that uncookies users.
This is awesome because it makes it crystal clear to visitors that A) they are being tracked and B) they can choose
not to be tracked. Even if regulators in the US don't require us to do that, we should consider providing our users 
that option on our sites. People understand that Privacy Policies disguise what kind of monitoring companies 
will do them. What I love about the opt-out widgets is that they don't require legal training to understand. 

A more ambitious and interesting approach to analytics would be to provide users access to the tracking data
that you've collected on them, both personally and in aggregate. This kind of transparency could offers a breathe
of fresh air, empowering users to *know* what we know about them and decide what feels right to them.

## Organize Ourselves

Although the changes I've recommended above will make a little more work for the NSA, these techniques won't make
the NSA Panopticon too expense on it's own. We need to organize ourselves politically.

### HTML5 Meetup in San Francisco

The very next HTML5 meetup is called "Attack, Defend, ....". Join the waitlist to make this **the** most demanded 
tech meetup ever. Watch the live stream. Be on the lookout for other meetups focused on web security.

### Support the EFF

The Electronic Frontier Foundation is our special interest group. They could really use support (pull requests, 
bit coins, or old fashion USD). Subscribing to their mailing list is an easy way to stay up to date on important
legislation and opportunities to contact your legislators.

### Educate your Family

As children of a politically powerful aging population, we have the ears of our parents and
grandparents to educate them about the tax burden both we and they are bearing. This ever increasing tax burden
pays for undemocratic practices which undermine the freedoms that they fought around the world to defend. 

