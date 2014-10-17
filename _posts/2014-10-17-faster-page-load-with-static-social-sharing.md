---
title: "Faster (and more private) page load with Static Social Sharing"
layout: "post"
excerpt: "Although it's tempting to use the default social sharing widgets from Facebook, Google Plus, etc., you can speed up your page load times by creating custom sharing widgets that are Javascript-free (\"static\")."
category: security
---
The internet was made for sharing. It's a way of saying, "I found this cat video interesting, and I think you will too." Most of your websites visitors understand that when they share cat videos on Facebook, they're also signaling to Facebook that they like cat videos too. It's very convenient and helpful of Facebook to help users find more cat videos.

## The Problem

In a word, transparency. What isn't obvious is that when users visit WebMD for advice on a swollen ankle, the **facebook widgets on the page track them even without the user sharing anything**. This is the dark side of prepackaged sharing widgets -- they spy on us even when we don't use them. Using these social sharing widgets, major tech companies are able to build rich profiles of your users on your site.

### Oh, Google

Google in particular has been working on using medical data to sell their new-ish service [Helpouts](https://helpouts.google.com/). The premise of Helpouts is that Google will be a matchmaker between users and an expert (such as a doctor) with whom users can pay to video conference. By combining data about users from Google Analytics, Google Custom Search Engine, Google Plus sharing widgets, and Gmail, Google already knows what kind of medical attention each user is looking for. Meanwhile, in hospital waiting rooms, nurses are unable to call patients by name for fear of HIPAA violations.

### A Red Herring

I don't believe that sharing personal data with a corporation is a bad thing at all, *however* using web developers to secretly spy on their users is not the right way to go about collecting potential sensitive, personal information. Our users deserve to know when their personal information is being collected. (And no, terms of service is NOT what I mean.) While social sharing widgets are not to blame for the entirety of corporate dragnet surveillance, they represent the easiest way to bring about immediate change.

## A Win-Win-Win-Win Kind of Situation

Social sharing widgets are slow. Slow websites mean less brand awareness, fewer page views, and fewer sales. It's especially galling social sharing widgets are giving Google and Facebook insight into your visitors at your expense.

By using Javascript-free ("static") social sharing widgets, you can decrease page load time and provide greater privacy to your users who choose not to share. Each company provides some documentation on how to do this. Checkout the links below to start working on your own static sharing widgets.

To be clear, when users do share content, they provide detailed metrics to the tech companies. However, by using static social widgets, you can increase the transparency about data collection to your users while speeding up your site.

## Documentation

* Twitter - [Web Intents](https://dev.twitter.com/docs/intents) _(simply discard the Javascript)_
* Facebook - [Url Redirection](https://developers.facebook.com/docs/sharing/reference/share-dialog) _(get a [Facebook App ID](https://developers.facebook.com/quickstarts/?platform=web) to use url redirection without Javascript)_
* Google Plus: [Sharelink](https://developers.google.com/+/web/share/#shar elink)
* Pinterest - [Pin It Button](https://business.pinterest.com/en/widget-builder#do_pin_it_button) _(simply discard the Javascript)_

*A Quick Footnote on Google:* In the documentation above for Google Plus, you'll see that Google denies tracking you across the web (for more than two weeks). However, there's no way to confirm this.
