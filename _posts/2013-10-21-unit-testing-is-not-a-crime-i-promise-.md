---
title: "Unit Testing is Not a Crime (I promise!)"
layout: "post"
excerpt: "This article is another workplace rant from me about web development best practices, specifically the importance of building tests. I'll try my best to convince myself, my boss, and you that we should all write unit tests for almost any piece of code we write."
---
Each keystroke I make breaks some piece of the code that I touch. In contrast, well written code sends off alarm bells when something is broken, but in every software project I've ever worked on, testing has always been considered a waste of time. The standard reasoning is that we're just building simple websites and that with the size of our teams, it's not a good use of our resources. I've worked at both a small 5 man shop and now at are larger publicly traded company, but the software and the excuses for unusable, brittle, and downright orny code have been same.

I find this situation unacceptable. It's an unacceptable waste of my employer's time for me to produce code that cannot reasonable be understood or fixed even by myself. I recently read an article on Hacker News (that I can't find now), but this article discussed how writing unit tests is not something needs to be justified to one's project's manager. It's simply part of building software like a professional. Likewise, I believe that adding tests is something that I should be doing just as much as rendering the javascript in the browser.

TDD and BDD aside, most days I don't even get error messages when something goes wrong until I start `var_dump()`ing. When software breaks without error messages somewhere, it's tedious and slow to debug. What's worse is that old code always breaks right at a critical time, meaning I lose productivity when I need it most.

## What To Test

In my world, I build websites like [dnaink](http://www.dnaink.com/) that function as glorified brochureware. Typically, if I asked my boss for permission to create tests (unit or otherwise), my boss would respond that there's not enough complexity to justify it, and could it be done yesterday please? However, this website has a myriad of complex functions integrating with the underlying CMS that probably only I will ever fully understand, and most of which I've already forgotten. Let's examine a few real world examples of what I would want to test on this site.

### Anything Functional (not merely cosmetic)

![Text fader component that needs testing](http://files.bryceadamfisher.com/blog/2013/unit-testing-isnt-a-crime/dnaink-text-fader-component-needs-to-be-tested.png)

Let's start on the [About Us page](http://www.dnaink.com/about-us/). Notice the small textbox on the right side of the page. I created this box to operate three different ways depending on the database. 

1. If there's **no** marketing slogan to display, make the box disappear
2. If there's **only one** marketing slogan to display, show it without animation
3. If there's **more than one** slogan, fade between them.

So, what happens if an overeager employee of DNA Ink accidentally changes the name of one of the custom fields which is fed into this function? Or, what happens if the CMS is updated, but one of the required plugins is no longer compatible with the new CMS? It's really quite impossible to say without simulating these events. I would suspect either a nasty error message and premature end of the html markup or a "White Screen of Death" (aka a WSOD) meaning that the server transmitted nothing to the browser.

If you're a new programmer or you've never seen the code for this website, you've immediately got two problems:

+ What's going wrong?
+ What's supposed to even be happening here?

These are hard problems to solve if you have 0 information to start with. When DNA Ink approaches you to fix this problem, the first question will be "How will it take to fix it?" I hate this question, because there is no answer. The reason there's no answer is because you don't yet know what's wrong, and as they say "knowing is half the battle." 

### Just Imagine the Buttery Goodness of an Error Message Right Now

This is where units shine through. A unit test **tells you what's wrong!** Imagine that the client contacted you with a support request, but this time they tell you, "I saw an error message that a plugin was missing on the About Us page. Can you fix it?" Now, you'll still have some work to do to figure out why the plugin is missing, but at least you now have a clue about how to go about fixing the problem. I could probably respond to a request like that by saying "It'll be fixed by EOD most likely." What a relief you and the customer!

Obviously, I'm imagining the greener pasture to be very very green, whereas clearly unit tests don't solve the problems that web developer face every day. However, given a choice between taking more time and building even basic unit tests/error logging/whatever tests, and skipping it, I'd rather write more tests and fix fewer bugs. And a happier me is probably a more productive me.

### You're not really taking about unit tests

You caught me! I'm calling things unit tests when I really mean something else. Strictly speaking, I don't care about unit tests. I just want meaningful feedback from the program about what's wrong with it. I've spent too many years fighting the scourge of code front-end and back that has idea of whether it's working or not. It sucks, and it's time to change that.

### Let's Do This!!

So, how might we go about testing the component from the About Us page? We could write *actual* unit tests, as in validate individual functions. I like this idea, but I have no experience in actually building this sort of thing and getting it working. Honestly, SimpleTest and PHPUNIT don't seem to work well for PHP on Windows.

I'd be happy to just do sanity checking inside various critical PHP functions. For example, check that certain plugins are enabled/exist before using them. Also, make sure the query results are sane before using them. When problems happen, write a meaningful error to the php error log. That's the right way to build software! (Or more towards the right way).

