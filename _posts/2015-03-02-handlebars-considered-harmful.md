---
title: "Handlebars Considered Harmful"
layout: "post"
excerpt: "Handlebars is a DSL builder in disguise tempting you to create an undebuggable mess."
category: js
---

**TL;DR:** Handlebars is a DSL builder in disguise tempting you to create an
undebuggable mess. If you minimize helpers and keep _all_ procedural code outside handlebars, you can safely keep it in your toolbelt.

## DO try this at home, kids

I've built a [stupidly simple and deliberately buggy handlebars node app](https://github.com/brycefisher/hbs-research) for this blog post. You don't need to run it to follow this post, but all the error messages and code samples come directly from this repo. Feel to clone and run it yourself if you get lost below.

## It all started so innocently...

You're building a nodejs web application to track fitness, so of course you're going to use handlebars. It's what we nodejs developers do. Like all good startups, you move fast and break things. "Red, green, refactor" is your freaking middle name. The code you write may not be poetry, but you make shit happen.

## ...Until everything went terribly wrong

One day, you receive an urgent bug report from the CEO that there's an icky error message every time he logs in. After verifying this issue doesn't happen [for your user](http://localhost:3000/?user=bff), you can reproduce this problem by running the source code on your machine and trying to [login as the CEO](http://localhost:3000/?user=wycats). Here's the error:

{% highlight bash %}
TypeError: Cannot read property 'activityStyle' of undefined
   at Handlebars.registerHelper.(anonymous function) (/var/app/helpers.js:45:47)
   at Object.eval (eval at <anonymous> (/var/app/node_modules/handlebars/dist/cjs/handlebars/compiler/javascript-compiler.js:209:23), <anonymous>:5:125)
   at Object.ret (/var/app/node_modules/handlebars/dist/cjs/handlebars/runtime.js:144:30)
   at Object.ret [as summaryActivity] (/var/app/node_modules/handlebars/dist/cjs/handlebars/compiler/compiler.js:462:21)
    at null.<anonymous> (/var/app/helpers.js:17:52)
    at Object.eval (eval at <anonymous> (/var/app/node_modules/handlebars/dist/cjs/handlebars/compiler/javascript-compiler.js:209:23), <anonymous>:9:76)
    at Object.prog [as fn] (/var/app/node_modules/handlebars/dist/cjs/handlebars/runtime.js:178:15)
    at Handlebars.registerHelper.url (/var/app/helpers.js:22:17)
    at Object.eval (eval at <anonymous> (/var/app/node_modules/handlebars/dist/cjs/handlebars/compiler/javascript-compiler.js:209:23), <anonymous>:4:83)
    at Object.prog [as fn] (/var/app/node_modules/handlebars/dist/cjs/handlebars/runtime.js:178:15)
{% endhighlight %}

### A Useless Stack Trace

The *only* connection between the stack trace above and our code is that first line. Every other line in the stack trace is from Handlebars' compiler or runtime `eval`ing anonymous functions. We have no idea what the context was that triggered the error in helpers.js. Hopefully it's just an obvious syntax error in helper.js line 45.

_It's interesting files names for a template package though, right? Weirdly, "compiler" and "runtime" remind me of something awfully familiar from my computer science classes..._

Enough daydreaming, let's see what's happening in [helpers.js line 45](https://github.com/brycefisher/hbs-research/blob/master/helpers.js#L45):

{% highlight javascript %}
Handlebars.registerHelper('setActivityStyleFromUser', function(user, options) {
  if (this.activityStyle == null && user.prefs.activityStyle) {
    this.activityStyle = user.prefs.activityStyle;
  }
  return options.fn(this);
});
{% endhighlight %}

Damn! There's 2 usages of `activityStyle` on line 45 that look a bit suspect. Never fear -- we have the `{% raw %}{{log}}{% endraw %}` helper to show use what's going on.

Phew! In the console, we see that the `user.prefs.activityStyle` is what's giving us trouble.

### A plethora of confusing grep results

But, how did we get here? Why is only the CEO crashing on login? If we rewrite this helper, what might we break elsewhere?

Time to search through all the code with grep to find where `setActivityStyleFromUser` is being used. Hopefully there's only one code path to this particular helper; otherwise, it's going to be a long night.

{% highlight bash %}{% raw %}
bryce@server:/var/app $ grep -ir setActivityStyleFromUser .
./helpers.js:Handlebars.registerHelper('setActivityStyleFromUser', function(user, options) {
./components/burnIt.hbs:      {{#setActivityStyleFromUser user}}
./components/burnIt.hbs:      {{/setActivityStyleFromUser}}
./components/summaryActivity.hbs:  {{#setActivityStyleFromUser user}}
./components/summaryActivity.hbs:  {{/setActivityStyleFromUser}}
{% endraw %}{% endhighlight %}

We've read through that first result, where the handlebar helper is being registered, so we can ignore that one. Both burnIt.hbs and summmaryActivity.hbs are possible places this is being used. Double damn! Two code paths possibly leading to the original error message, but we don't know which one is giving us trouble for sure. Let's look at burnIt.hbs:

{% highlight handlebars %}{% raw %}
{{#setAsUser (getUsernameFromParams url=../urlParams)}}
  {{#setActivityStyleFromUser user}}
    <h1>Burn those {{activityStyle}}s, {{user.name}}!</h1>
  {{/setActivityStyleFromUser}}
{{/setAsUser}}
{% endraw %}{% endhighlight %}

Hmm... let's try logging `activityStyle` just above `{% raw %}{{#setActivityStyleFromUser}}{% endraw %}`. So the code will now look like this:

{% highlight handlebars %}{% raw %}
{{#setAsUser (getUsernameFromParams url=../urlParams)}}
  {{log activityStyle}}
  {{#setActivityStyleFromUser user}}
    <h1>Burn those {{activityStyle}}s, {{user.name}}!</h1>
  {{/setActivityStyleFromUser}}
{{/setAsUser}}
{% endraw %}{% endhighlight %}

No change! We still get the same error message on the same line.

### Time to call a friend

We could try rooting around like this forever -- but let's not. DuckDuckGo to the rescure:

![Several DuckDuckGo search results -- none look promising](/img/2015/ddg-search-results.png)

Ugh, too many results and after clicking through several of them, there's nothing useful. Looking directly on stackoverflow [doesn't yield anything helpful](http://stackoverflow.com/questions/25555793/typeerror-cannot-read-property-typekey-of-undefined) here either.

### Why is everything so f**ked up?

This question is an opportunity. It's a chance to take stock of what we've just gone through and ask ourselves why. Why is hunting this bug so hard? There's barely any code written in this project, and already:

 + The templates look like a transcript of the delusional ramblings of a crazy person
 + The error messages are really long but tell us nothing
 + The control flow is untraceable

Can we figure it out? Maybe. **But if we keep writing code this way, someday it will paralyze our ability to fix bugs or develop new features**, and in my book that's harmful.

## The Truth about Handlebars

The core of [handlebars is written in Bison/YACC](https://github.com/wycats/handlebars.js/blob/master/src/handlebars.yy), a metalanguage used to create new programming languages like PHP, Ruby, Go, Bash, PostgreSQL. Handlebars itself is a very minimal Domain Specific Language which is why you saw "compiler.js" and "runtime.js" listed in the stacktrace at the top of this post. While implemented in javascript, code written in handlebars is running in its own compiler and runtime, on top of javascript.

Handlebars is extensible through the use of helpers that you register with the compiler. Think of helpers not like functions in javascript, but more like macros in C++. You're literally adding capabilities to the compiler. So, as you write additional helpers for Handlebars, you're _effectively_ extending Handlebars into your own DSL. Surprise!

In my stupid source code used to write this post, you can start to see this happening in the helpers I created:

{% highlight javascript %}{% raw %}
Handlebars.registerHelper('eq', function(a, b, options) {
  if (a == b) {
    return options.fn(this);
  } else {
    return options.inverse(this);
  }
});

Handlebars.registerHelper('set', function(key, value) {
  this[key] = value;
  return '';
});
{% endraw %}{% endhighlight %}

I've re-implemented conditionals and variable assignment operators! Does that sound like the purview of templates to you? It doesn't to me.

## But I'm not just picking on Handlebars

I've seen senior Python developers do exactly the same kind of thing using [Jinja2](http://jinja.pocoo.org/) or even Django templates. If I had done any Ruby on Rails development, I'm quite sure I would find the same defects there as well.

PHP is perhaps the worst offender in this regard because it was explicitly developed to be embedded into html between `<?php` and `?>` tags. WordPress templates in particular suffer from the comingling of application logic and presentational markup leading to total spaghetti code. At least the debugging tools for PHP were built with this comingling in mind. Except that PHP now has [Twig templates](http://twig.sensiolabs.org/) which are Handlebars for PHP...

What all these templating languages have in common is that they split your application logic across multiple contexts, typically without your awareness. The fancier the templating language, the more the temptation to build your application in a blindspot that you can't easily debug. It's like putting your diamonds in the one corner of the jewelry store where there aren't any cameras.

## There must be a better way

There is. Write your application logic in javascript (or whatever your main application language happens to be). Stacktraces will tell you something useful, other people will help you on stackoverflow, and more importantly the your business logic will be expressed in a language that's used by thousands of developers.

But don't throw Handlebars away just yet -- we have to have some way to put data into HTML, and Handlebars (despite my grumblings here) can still be a good tool for that purpose. Here's my ten commandments for safely using Handlebars:

### 1. Thou shalt print static values

Never compute **anything** in a template. Pour only finished data into the template. Lean on `{% raw %}{{var}}{% endraw %}` expressions as much as possible to display values.

### 2. Thou shalt not mutate variables

As data passes between different scopes, the same data should retain the same variable name and the same path. You should never do this:

{% highlight handlebars %}{% raw %}
{{firstName}}
{{#myHelper who=firstName}}
  {{who}}
{{/myHelper}}
{% endraw %}{% endhighlight %}

When variables change names inside handlebars, it becomes exponentially harder to trace them from child scopes to parent scopes. This leads to misunderstandings of how the code works and bugs over time. When these bugs arise, they're very costly to fix because of the effort of tracking them down.

### 3. Thou shalt (cautiously) use `#if` and `#each`

Collections of data are ubiquitous. Handlebars already has a built-in blocker helper for `{% raw %}{{#each}}{% endraw %}` that iterates over an array to produce html. Using `{% raw %}{{#each}}{% endraw %}` as an iterator is an excellent idea. It's documented, has test coverage, and you can find support for it on stackoverflow/irc/etc.

Checking for the presence of a variable can be an acceptable way to structure a template. It's okay to check for a user in the template context before showing  account information, for instance.

### 4. Thou shalt not `switch`

Checking for the presence of a variable is completely different than executing an extended else-if conditional/pattern matching in templates. Your template is too dynamic -- move more logic back into the server.

### 5. Thou shalt not `else`

I'm gonna be stickler on this one. Your code _will_ be clearer without this extra logic. You're building templates, not lambda calculus. Steer clear of any unnecessary conditional logic.

### 6. Thou shalt be LOOSE

The pythonistas have focused on the programming discipline called DRY. The key insight is that application logic works better with a single source of truth. Code that is duplicated often needs to be updated in sync, but can easily get out of sync.

Template logic is governed instead by the need to be loosely coupled. Overly dynamic templates are difficult to reason about because of the many codepaths they are tied to. It's generally much easier to maintain multiple similar templates with isolated responsibilities than a single template with many responsibilities. When these similar template get of sync, they are easy to change because there are few side effects.

### 7. Thou shalt not use more than seven mustaches in a row

I just made up the number seven, but seriously though too many mustaches next to each other are unreadable. If you have that many mustaches consider moving more logic into client or server side javascript.

### 8. Thou shalt the use of minize partials

Partials are there to DRY up your code, which is a bad thing. Sometimes, you will absolutely have to reuse something, like the footer, across different templates. Consider ways to avoid creating a partial if possible, but don't feel too bad doing it.

The real danger is that you'll start passing very different contexts to the partial. By keeping as much of the template in a single file as possible, you avoid switching contexts and the possibility of mutating a variable.

### 9. Thou shalt program declaratively

One of the reasons that the sample code above is _so_ bad is the gratuitous use of procedural logic in the template. If you must use helpers, only use them declaratively, as shown in this Handlebars documentation snippet:

{% highlight handlebars %}{% raw %}
{{{link "See more..." href=story.url class="story"}}}
{% endraw %}{% endhighlight %}

If there's verb used in the handlebars helper **you did it wrong**.

### 10. Thou shalt create an API for client side rendering

If you want templates that can be rendered client side and server side, move all the data generation, templation selection, and other logic into the server and expose an api endpoint for your client side code to consume. This keeps your program logic DRY (as it should be) but keeps logic out of the templates (where it shouldn't be).

## In Conclusion

Handlebars isn't evil, but it can be a siren song luring you to dive overboard into a sea of unrelenting bugs. By keeping your programming logic in your main programming language (javascript in this example), you can keep your code easier to debug, easier to read, and easier to find help when you get stuck. When you do use Handlebars, keep it stupidly simple. You'll thank me later.
