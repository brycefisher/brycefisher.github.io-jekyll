---
title: "How to Kill Email: Why startups will always fail to displace email"
layout: "post"
excerpt: "It's painful to watch startup after startup brand themselves the \"email killer.\" This post is the real story of how to kill email."
category: startup
---
It's painful to watch startup after startup brand themselves the "email killer." This post is the real story of how to kill email.

## Make It Backwards Compatible

Email is so well entrenched in both business and personal communications that it cannot simply be "killed" outright. According to [Experian](http://en.wikipedia.org/wiki/Experian) Marketing Services (a scary treasure trove of voting records, email marketing, credit history, rental history, etc.), the volume of [email traffic year over year continues to grow](http://www.experian.com/marketing-services/email-marketing-quarterly-benchmark-study-q2-2013.html) by double digits. Radicati predicts continued [double digit growth in email volume](http://www.radicati.com/wp/wp-content/uploads/2014/10/Email-Market-2014-2018-Executive-Summary.pdf) over the next four years. In the face of growing email volume, whatever replaces email must also be backwards compatible with it.

This is how git largely replaced svn -- developers could keep all their existing commit history when making the switch. Similarly, HTML5 was able to easily replace HTML4 because it mostly added tags and APIs on top of HTML4. Perhaps supporting POP3 (which was not built for the smartphone era) should be optional, but whatever kills email must support IMAP and SMTP.

<p class="responsive-image"><a href="https://www.flickr.com/photos/flattop341/212276638">
<img alt="Row of standardized XLR inputs from a recording studio" src="/img/2014/11/xlr-standard-inputs.jpg">
</a></p>

## Create a New Email Standard

In a word, we need standards not apps to kill email. This is why so-called email killers such as Slack and Yammer are failing to dislodge email.

### What Do You Mean, "Email Standard"?

Roughly, I mean a protocol such as SMTP + IMAP. We need a clearly defined technical specification that has been hashed out by the Internet Enginerring TaskForce (IETF) or some other standards body with representatives from spam filtering companies, networking experts, systems administrators, government agencies, and email client vendors.

### Why Consensus Is So Important

Without consensus, broad adoption is impossible. HTML5, CSS3, and ES5 (to name a few) could not have come about without a consensus between browser makers and web developers. Today, it's tough to find a website made in the last 3 years that doesn't use some aspects of HTML5 or CSS3.

To take a parallel case from the online video technology industry (currently mine), MPEG-DASH has relatively strong consensus between video transcoding and CDN companies, but it seems that web developers were not given enough voice in the process. Ask any web developer about their experience with MPEG-DASH, and you'll hear about the horrors of trying to parse XML in the browser, among other complaints. For this reason, MPEG-DASH hasn't gotten much traction at this point in November 2014.

### Other Reasons Why Apps Won't Kill Email

 * Battle-tested ideas not subject to whims of a few charismatic founders
 * Zero cost experimentation allowing a critical mass of technical innovation
 * Stability of APIs
 * Resilience to disappearing funding or acquisition
 * Competition from a variety of implementations
 * Protection against one company selling ALL user data

Each of these could almost justify it's own blog post -- if you're curious about these, the comments at the bottom are the perfect place for a flame war. Game on!

<p class="responsive-image"><a href="https://www.flickr.com/photos/pulpolux/8773281/in/photolist-prR16B-CU2dB-f5sapZ-7yUnsk-dfZKru-99QG3B-94SntC-LXZt-4zSncV-4AxFbj-64prpn-dDUZiW-8wMxfK-7HHnxL-7FyKFj-8XY5Aa-ebV5vf-ebPqii-ebPA2T-aobYSE-inYagg-9cnwcz-ammwhv-ebPqfx-ebPqcB-ebVfC1-ebVfyf-ebPA6t-ebVfpo-e9bKmj-e965ut-e9bKpC-e965BH-e965xg-5LG7d-dbrJue-93yjzd-b8EDHc-5VtiJY-9UCYvF-brB7Ek-9TkQ12-dkYpsw-aQ43c6-9Xdpgh-9XawGP-9YUuaf-8KZuNr-7N9DAS-FRVqY">
<img src="/img/2014/11/irresistible-chocolate.jpg" alt="Five chocolate eclairs seen closeup">
</a></p>

## Make It Irrestible

The benefits to this new email standard must be compelling and obvious. Without bells and whistles for all parties from sysadmins to email client vendors to end users, there's no way to get traction.

If you've read this far, you know that my opinions alone are woefully inadequate for a standard. I imagine that whatever replaces email must at least provide the following features (nearly all of them relate to the problem of bad actors).

### Feature: Impostors, Begone!

Phishing attacks are devastating and nearly unpreventable using the current email protocols. In particular, high profile targets like CEOs are often the victims of carefully researched and planned phishing attacks. This has to stop. A Russian hacker must not be able to convince my Grandma that she is me.

### Feature: Want to Spam? Make it Rain

Sending lots and lots of physical mail is expensive. Email should also be computationally expensive to send (perhaps using something analogous to mining for bitcoins?). I believe that shifting costs onto spammers would solve the spam epidemic we face today.

#### Caveat: Never Miss Your Friends Updates

The danger here is that if sending emails is too "expensive", no one will use it. Spam mitigation must take into account the needs for legitimate notifications. For instance, Facebook really does need to send emails almost every time a user posts a comment. Perhaps some mechanism of trust (modeled on keybase.io or perhaps on the block chain) could be used to allow trusted, verified senders' messages to always be delivered. Admittedly, this is a hard problem, and it will require the experise of Facebook and serious cryptologists.

### Feature: Keep Your Viruses to Yourself

Malware transmitted via email is a huge problem. If we could "sanitize" email so that viruses could not be transmitted via attachments, I would force my brother-in-law to sign up in a heart beat.

### Feature: Make The Conversation Stick Together

Let's use a UUID to bind together messages on a thread. We could eliminate resending the entire thread, and make all clients present a time ordered sequence of emails grouped by the thread UUID.

### Feature: Tie Message Format to HTML5/CSS3

The bad actor here is Microsoft Outlook (and every web based mail client like Gmail and Yahoo!). It's still like 1995 for marketers and nonprofits sending pretty emails. It sucks and it has to end.

## Concluding Thoughts

Postal mail is more sophiscated than email these days. That's a shame. It's time for the tech community to stop talking about killing email and actually do it. However, we can't do it alone. We need a shiny new standard with bells and whistels that's broadly agreed upon, widely adopted, and backwards compatible. That's how to kill email.
