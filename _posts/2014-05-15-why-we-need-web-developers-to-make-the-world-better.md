---
title: "How Web Developers Can Make The World a Better Place"
layout: "post"
excerpt: "Web Developers are now the general contractors for the Panopticon we call 'The Internet.' Whether we act as tools of the prison wardens or allies of the inmates is up to us."
category: society
tags: security
---
In some ways, Edward Snowden's revelations were a new 9/11. It's not a perfect analogy -- no one died. But our 
na&iuml;vet&eacute; about the surveillance of American citizens by the US government
was irrevocably shattered. We learned that nearly all of our electronic transactions, communications, and even
each of our physical movements are monitored and recorded *at scale*, placing us into a situation that resembles the 
"Panoptic" prison system devised by Jeremy Bentham.

Fortunately, Snowden revealed some useful information about how NSA monitoring works. Armed with an understanding of
what makes the Panopticon work, we can begin to resist ceaseless surveillance and make the world a better place.

## The Panopticon

![The Presidio Modelo prison in Cuba](/img/2014-05-14-panopticon-prison-cuba.jpg)
{:.responsive-image}

> The architecture incorporates a tower central to a circular building that is divided into cells, each cell extending the entire thickness of the building to allow inner and outer windows. The occupants of the cells are thus backlit, isolated from one another by walls, and subject to scrutiny both collectively and individually by an observer in the tower who remains unseen. Toward this end, Bentham envisioned not only venetian blinds on the tower observation ports but also maze-like connections among tower rooms to avoid glints of light or noise that might betray the presence of an observer.
>
> &mdash; <cite>Barton, Ben F.; Barton, Marthalee S. (1993). "Modes of Power in Technical and Professional Visuals". <em>Journal of Business and Technical Communication</em> 7 (1): 138–62. </cite>

The utilitarian philosopher Jeremy Bentham devised the ["Panopticon"](http://en.wikipedia.org/wiki/Panopticon) as an economical
alternative to the existing prisons of his time. The idea was to build a guard tower in the center of the prison with individual cells 
in a giant circle around the tower but closed off from each other. The Panopticon is about a privileged person that is all seeing but never herself seen. Each prisoner knows that he can not be actively observed at every moment, he cannot tell when the prison guards are watching him and when they are not. He feels the eyes of the guards on him at every moment. Such a fear is a powerful motivator to conform to the rules of the 
system, especially when the punishments for misconduct are harsh.

Similar to Bentham's Panopticon, the NSA's monitoring capabilities are virtually without limit. Gag orders 
silence tech companies by making surveillance requests a matter of "National Security." But intelligence agencies can
also tap directly into the "backbones" of the internet in strategic urban locations (such as AT&amp;T Park in
San Francisco). Thanks to Snowden, we now know that we are all under constant surveillance, but we are unable to perceive
whether or not we are being monitored. Furthermore, our actions can be scrutinized retroactively if anyone connected to us becomes remotely 
suspicious.

### What Powers the Panopticon

 * **Constancy** - If the warden can always see into your cell, you're fucked.
 * **Uni-directionality** - The prisoners can't see the warden.
 * **Isolation** - The prisoners can't congregate to overthrow the warden.

## What Can Meager Web Developers Do?

> Trust the math
>
> <cite>&mdash; <a href="https://www.schneier.com/blog/archives/2013/10/trust_the_math.html" target="_blank">Bruce Schneier</a>

We can't dismantle the NSA or hack into their datacenters, but we're not powerless. We know that strong
encryption obscures attempts to monitor us, and we are the general contractors of a large fraction of the 
internet we call the "Web." That puts us in a unique position to make warrantless surveillance a more expensive
option for the NSA. Using the Panopticon as a guiding metaphor, we should pursue techniques which:

 * Interrupt surveillance
 * Create transparency
 * Unify inmates

### Use Encryption in your Projects

Encryption *interrupts surveillance*. It's a powerful tool, and it's 
[never been easier](https://www.eff.org/https-everywhere/deploying-https) to implement on the web. If you are serving
websites over http, bookmark [cheapestssls.com](http://cheapestssls.com/) right now and start using SSL
on your next web project. I've written detailed instructions on how to [setup a static site 
on AWS using S3, CloudFront, and SSL]({% post_url 2014-04-24-setting-up-ssl-on-aws-cloudfront-and-s3 %}).

Once you've setup SSL on your web properties, prevent man-in-the-middle attacks by
[using HSTS headers](https://en.wikipedia.org/wiki/Strict_Transport_Security). HSTS headers essentially ask
browsers to cache the protocol for a certain period of time, making non-SSL attacks impossible. 

Once you've setup SSL on your web properties, setup Perfect Forward Secrecy (PFS). PFS 
basically means that each connection uses different key pairs. This means that even if one connection 
is compromised, the next connection isn't necessarily.

### Consider Alternatives to Compromised Services

We know that Google is being compelled to share their user data with the NSA and they have very limited
ability to disclose what they are sharing. Consider alternatives to Google Analytics like [Piwik](http://piwik.org/).
Again, the idea is to *interrupt surveillance* as with using encryption, but there are other good
reasons to consider Piwik as well.

Piwik may not be right for everyone -- you'll have to install and maintain it yourself on your own server.
However, Piwik provides a compelling set of features that probably meet the needs of brochureware, personal
blogs, and general purpose web analytics. Because Piwik is run on your own servers, NSA will have
to hack into your server or subpoena you specifically to seize your traffic data. This is much harder for the NSA
than filing another request to Google, thus using Piwik raises the cost of monitoring your visitors.

Here's some of the features of Piwik:

 + Open source, forkable [github repo](https://github.com/piwik/piwik)
 + Mobile app for Android and iPhone
 + Custom event traffic
 + Traffic segmentation
 + Annotations
 + Configurable charts and graphs
 + Multi-domain and multi-user
 + Browser, OS, screen, and other client attribute detection
 
Perhaps the most compelling feature of all is that Piwik is open source and can be forked and modified
to suit your unique analytics needs.

### Be Smart About Social Sharing Widgets

Every single Google Plus, Pinterest, LinkedIn, Disqus, and Twitter social sharing widget is an analytics
tool that allows these companies to monitor traffic and user behavior across the web. Because the NSA
regularly requests this data from big companies, these social widgets form a dragnet that we web developers
have eagerly drooled over. These social sharing widgets slow down our sites load time by as much one to two
seconds apiece, and slower load times means less visitor engagement. 

**Don't install another social sharing widget**. So far as I know, Twitter first innovated the
[web intent](https://dev.twitter.com/docs/intents). Instead of forcing you to embed a slow and panoptic social
plugin, Twitter allows you to use links that trigger a new follow or new tweet action, all without embedding 
any Javascript on your site. This is faster and more private for your visitors. Facebook and other social networks
have followed suit. Look for opportunies to replace your curent social sharing widgets with non-Javascript
alternatives that work like Twitter web intents.

There are some tradeoffs here. I use Disqus on this site because they offer the easiest way for mobile visitors
to share feedback without having to register with me. However, I could protect your privacy a bit better by
only activating Disqus when users scroll to the bottom, or click on "Discuss", etc. Let me know how your comments...in 
the comments!

*If you're interested in fighting the scourge of social sharing widgets, see my article on 
[improving your page load time]({% post_url 2013-06-08-7-steps-to-improving-page-load-time-on-shared-hosting %}).*

### Empower Users to Make Choices about Our Analytics

The EU currently forces sites using Google Analytics (etc) to give users an opt-out widget that uncookies users.
This is awesome because it makes it crystal clear to visitors that A) they are being tracked (which *creates transparency*)
and B) they can choose not to be tracked (*interrupting surveillance*). Even if regulators in the US don't require web 
developers to do that, we should consider providing our users that option on our sites. People understand that privacy
policies provide legal justification for corporates web sites usurp any right to privacy they may have otherwise had. 
What I love about the opt-out widgets is that they don't require legal training to understand, and they shift the power dynamic.

A more ambitious and interesting approach to analytics would be to provide users access to the tracking data
that you've collected on them, both personally and in aggregate. This kind of transparency could offer a breath
of fresh air, empowering users to *know* what we know about them and decide what feels right to them.

## Organize Ourselves

Although the changes I've recommended above will make a little more work for the NSA, these techniques won't make
the NSA Panopticon prohibitively expensive on their own. We need to organize ourselves politically. All of this advice
is focused on *unifying the inmates*.

### HTML5 Web Security Meetup in San Francisco

The very next HTML5 meetup is called ["Web Security: Attack, Defend, and Profit"](http://www.meetup.com/sfhtml5/events/179713932/).
Join the waitlist to make this **the** most demanded tech meetup ever. Watch the live stream. Be on the lookout for other meetups
focused on web security.

### Support the EFF

The [Electronic Frontier Foundation](https://www.eff.org/) is *our* special interest group. They could really use support (pull requests, 
bitcoins, or old fashion USD). Subscribing to their mailing list is an easy way to stay up to date on best practices in web
security, important legislation, and opportunities to contact your legislators.

### Educate your Parents

As children of a politically powerful aging population, we have the ears of our parents and
grandparents to educate them about the tax burden both we and they are bearing. This ever increasing tax burden
pays for undemocratic practices which undermine the freedoms that our elders fought around the world to defend.

## Conclusion

I'm really just scratching the surface of what we can do as web developers. If my metaphor is fitting, we should try to interrupt surveillance, create transparency, and unify inmates in as many ways as we can imagine. When web developers take these kinds of small actions, we crack holes in the Panopticon, and we make the world a freer and better place to live.
