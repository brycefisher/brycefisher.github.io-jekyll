---
title: "7 Steps to Improving Page Load Time on Shared Hosting"
layout: "post"
excerpt: "I recently optimized page load time for the Spelling Word’s Well homepage as part of a redesign. Using the YSlow Add-on helped, but I still had a learning curve to face, and I also uncovered some other tricks. Here’s a summary of the most important steps I took."
---
I recently optimized page load time for the <a href="http://spelling-words-well.com">Spelling Word's Well homepage</a> as part of a redesign. Using the <a href="http://yslow.org">YSlow Add-on</a> helped, but I still had a learning curve to face, and I also uncovered some other tricks. Here's a summary of the most important steps I took:

## 1. Make a DIY, Cookie-free Content Delivery Network

The key ingredient here is to use a subdomain that delivers **all** your static content: images, css, static json files, xml dumps, javascript, etc. So, you'll need to assemble all those assets if they are scattered around. I often have cPanel available on my shared hosting sites. Log into cPanel and click **Subdomains** in the Domains box. <!--You'll see something like this:-->

<!--![cPanel form for creating a subdomain](/sites/default/files/field/image/cPanel-make-subdomain.png)-->

Choose a subdomain name that makes sense to you. I like to store these files outside of the public directory of the main domain (hence /subdomains/static instead of /public_html/static in the screenshot). Once this directory is created, be ruthless about putting everything you can on this subdomain, and update your html to use this subdomain.

**UPDATE:** Finally, make your DIY CDN real [using CloudFlare for free](https://www.cloudflare.com/features-cdn). I'll be covering this in detail in a future post. Stay tuned!

## 2. Supercharge Your Subdomain

Create an htaccess file in the root directory of your subdomain (in my example, /subdomains/static/.htaccess). The following .htaccess file asks browsers to store images and other static assets in it's cache longer for better repeat traffic. It utilizes mod_deflate to compress all kinds of text files (js, xml, html, css, ajax, etc.) over the netwok. It also blocks access to directory listings and sensitive batch files for security.

[See this as a gist](https://gist.github.com/brycefisher/5734403)

## 3. Fight the Scourge of Social Sharing Widgets

Seriously, this is the most important thing. Each facebook like and google sharing widget REALLY slows down the page. To use these widgets, the browser has to look up the IP address of the domain, contact the real server, ask for the javascript, run the javascript, lookup another domain's IP address for the images, ask for the images, download the images, and then display them. It's all horribly inefficient. It's important to weight the lost conversions on your site against the possible the sharing benefits of showing the widget. Not everyone will share your page, but everyone will have to suffer through another agonizing second of page load time for every widget on every page.

So, how do you fight back?

* __Reduce unnecessary social widgets__ On Spelling Words Well, I removed a facebook badge that was hiding down the page, and saved almost a second in page load time.
* __Load Widgets using AJAX__ Many widgets do this already, but check the documentation for more info.
* __Look for simpler alternatives__ Twitter offers nice, simple ["Web Intent"](https://dev.twitter.com/docs/intents#follow-intent) that is an alternative to their following widget. Best of all, you can download the images, javascript, and html and server from your own CDN and avoid a lot of the overhead of googleplus and facebook widgets without sacrificing the ability to share. Thank you Twitter!!! (Also, your designers can go to town on the sharing widgets).

**UPDATE:** In a future post, I'll walk you through using twitter web intents in a more detailed way, and I'd like to discuss creating customized performance focused google plus sharing widgets that function similarly to the twitter web intents. Follow [me on twitter](https://twitter.com/BryceAdamFisher) to find out when I write this follow up article!

## 4. Optimize Images

There's two parts to optimizing your images. The (more) obvious part is that you should use the lowest quality settings for JPGs that you can bear to look at. This makes the filesize smaller without shrinking the image's display size on screen. PNG files can be compressed using the free [GIMP](http://gimp.org/) photo editing wonderland software. Don't use gifs. Just don't.

**UPDATE October, 2013**: I now recommend the incredible (and currently free) service from [kraken.io](http://kraken.io) to shrink images an exta 10-25% on average. Kraken does this without sacrificing any image quality. You can drag and drop dozens of files and download the optimized images as a single zip file once Kraken has worked it's magic.

The somewhat less obvious part is to crop your images in your photo-editing software (or in Drupal or Wordpress) so that the browser won't have to resize the image on fly. Setting a size in the `<img />` tag that is different the size of image stored in the server will force the browser to do extra work to resize the image. While is this really cool, it is slower. Of course, if you're using a responsive design, you'll have to weigh this carefully, and probably disregard my advice. Responsive images have a whole host of other puzzles to untangle that requires several posts to tease out.

## 5. Make the Page Beautiful Without JavaScript

First of all, Google is your biggest fan, and Google doesn't use javascript when it's examining your site. Also, a small percentage of your visitors will not be using JavaScript either, so you want to make sure those folks have a nice experience. The main thing to do is to place something simpler but useful where the JavaScript content was. Make sure all links work, and everything makes sense with JavaScript disabled on your page. This could also be the subject of a whole post.

## 6. Make JavaScript Run Last

JavaScript is the single slowest part of any page, and while it's loading in the browser it "blocks" the browser from doing anything else. Therefore, if you've made a website that already works without JavaScript, just make JavaScript run last. This way, your users can start interacting with the page right away, and the page will get better once it's fully loaded. Here's what to do:

* Move all JavaScript code to the bottom of the page, right before the closing `</body>` tag.
* Move all that code into a separate JS file, and point a `<script>` tag at the new JS file
* Surround all your JavaScript with an onload callback function (such as jQuery's `$(document).ready()` or the built in javascript `window.onload=function(){}`.
* Combine all javascript files into one file if possible (jQuery and plugins, facebook, googleplus, your own code, etc). Be careful about the order of things! For example, make sure that jQuery is added before any jQuery plugins.
* Experiment with different orders to see what feels the fastest

If you did steps 5 and 6, you'll start to notice your page *feels* much much more responsive already. Well done! This is the hardest part.

## 7. Minify CSS and JS

I've used [YUI CSS Compressor](http://refresh-sf.com/yui/#output) and been happy with my compressed css. Once you're happy, upload it to your own CDN from step 1. Alternatively, if you've started using LESS, SASS, or Stylus, these all can minify the css they produce for you easily. Consult the appropriate documentation for details.

Personally, I like using Google Closure Compiler to minify my JS. I've setup a batch script that includes all my JS files in a specific order and compresses it into a slightly smaller output file. That should be the subject of a whole separate post later, but suffice it to say that you can minify using [closure compiler online](http://closure-compiler.appspot.com/home) too.

## Just the Beginning

There's a lot that could be said about [image sprites using Compass](http://compass-style.org/help/tutorials/spriting/), and I've only scratched the surface of JavaScript optimizations that can be made with social media. YSlow also offers plenty of other advice which is likely to help you a lot.
