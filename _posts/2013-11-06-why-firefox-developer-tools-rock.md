---
title: "Why Firefox Developer Tools Rock"
layout: "post"
excerpt: "I use Firefox as my browser of choice for web development and casual use alike. For years, I've relied on Firebug extension to inspect the html on the page and get my CSS pixel perfect. However, I had totally missed the built in developer tools that the Firefox team has put together in the past six months or so. At the same time, Firebug has become really sluggish. I've recently discovered how to do *almost* everything that Firebug does using the Firefox Developer Tools and several things it doesn't, but the interface is quite a bit different. Read this article to learn how to start using Firefox Developer Tools today."
---
As a security concerned netizen, I use Firefox as my browser of choice for web development and casual use of the interwebz. For years, I've relied on the venerable Firebug extension to inspect the html on the page, find networking issues that affect the front end, debug javascript, and get my CSS pixel perfect. However, like most developers, I had totally missed the built in developer tools that the Firefox team has put together in the past six months or so. At the same time, [Firebug has become really sluggish](https://hacks.mozilla.org/2013/10/firefox-developer-tools-and-firebug/) due to the way it integrates with Firefox's JavaScript Debugger (JSD) API. I've recently discovered how to do *almost* everything that Firebug does using the Firefox Developer Tools and several things it doesn't, but the interface is quite a bit different. I'm writing this article to show you how to start using some of the more important and hard to find Firefox Developer Tools today. 

## Use the Aurora Build of Firefox

Mozilla maintains three separate <term title="A build is a specific compiled version program with distinct features and flaws">builds</term> of Firefox: Firefox stable, Firefox Beta, and Firefox Aurora (Aurora as in "Alpha"). Firefox Aurora isn't as well tested and patched as the other two builds, but it does all the latest cutting edge features that the Mozilla team has already built weeks or months ahead of time. It's basically like the pre-release screening of a major motion picture. The Mozilla team has baked a lot of new Developer Tools goodies into the Aurora release of Firefox that aren't available in the current stable release, such as support for CSS pseudoelements in the inspector.

I've used the Aurora release for a couple of days now on both Windows and OSX without any issues. However, I've heard that Flash may not work in Aurora. One really awesome feature of Aurora is that it uses the same plugins, bookmarks, preferences, and other configurations that you've already created in Firefox automatically. So, once you install Aurora you'll everything just how it was in Firefox stable. Nice!

Enough talking &mdash; [go get Firefox Aurora right now](https://www.mozilla.org/en-US/firefox/aurora/)! Then come back here and learn how to use the Dev Tools.

## In the Beginning, There Was the Inspector

![Context menu in Firefox showing how to launch Developer Tools](http://files.bryceadamfisher.com/blog/2013/why-ff-dev-tools-rock/aurora-context-menu-for-inspector.jpg)

To inspect an HTML element using the Developer Tools, right click (or Ctrl click for Mac users) on the element, and then choose **Inspect Element (Q)** right below the "View Source" option. 

![First Peak of FIrefox Developer Tools Inspector](http://files.bryceadamfisher.com/blog/2013/why-ff-dev-tools-rock/aurora-inspector-first-look.jpg)

Once you do so, you'll be greeted by the inspector that shows up at the bottom of the screen.

## Let There Be Light (Theme)

![Context menu in Firefox showing how to launch Developer Tools](http://files.bryceadamfisher.com/blog/2013/why-ff-dev-tools-rock/aurora-settings-screen.jpg)

The first thing you'll notice is that everything looks really dark. No worries! We can make it light by clicking on the gear icon in the upper left (1 in the screenshot) and switching to the "Light Theme" (2 in the screenshot). Personally, I don't know what the "Scratchpad" is good for and I don't do enough optimization to need the Profiler, so I uncheck both of those boxes to unclutter the Developer Tools a bit. 

## Triggering Hover, Active, and Focus Pseudo Classes

![Context menu for triggering pseudo classes in Firefox Developer Tools](http://files.bryceadamfisher.com/blog/2013/why-ff-dev-tools-rock/aurora-pseudo-class.jpg)

It took me ages to figure this feature out, but it's actually a great experience once you know how it works. First, inspect the link, input, or other element you want to trigger a hover state on. Notice that a little black balloon has appeared near the the element you inspected. Click the down arrow to expose a new context menu. From this menu, click "hover" to toggle the hover state. You can also delete the element, edit it's source, or trigger any other pseudo class supported by Dev Tools. I like that these features don't clutter up the Inspector pane, although it's a bit annoying to move the mouse out of Dev Tools.

## Responsive Design Mode

<iframe width="550" height="416" src="//www.youtube.com/embed/PiVizmO90wc" frameborder="0">  </iframe>

Okay, now it's time for the best feature of all: The Responsive Design mode! I haven't seen this feature in any other Developer Tools or plugin out there (although to be fair I haven't really looked). However, the fact that this is baked into Firefox makes it really really easy to test various breakpoints and screen sizes all from the comfort of my favorite browser.

## Learn More From Mozilla

The [hacks.mozilla.org developer blog](https://hacks.mozilla.org/2013/11/firefox-developer-tools-episode-27-edit-as-html-codemirror-more/) has a lot of [great material](https://hacks.mozilla.org/2013/09/new-features-in-the-firefox-developer-tools-episode-26/) going into way more detail.
