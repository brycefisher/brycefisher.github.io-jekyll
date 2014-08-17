---
title: "PHP Composer VS NodeJS NPM - Fight!"
layout: "post"
excerpt: "I recently had a rare opportunity to pit two popular open source package managers against each other. And, yes, there is a winner!"
category: society
tags: php, javascript, packaging, open source
---
As web developers, we suddenly have a lot of options for building our own open source tools. I recently pitted [PHP's Composer](http://getcomposer.org/) against [Node's package manager](http://npmjs.org/). Composer is deliberately copying the wildly successfully techniques utilized by NPM, and the Composer pacakage directory [Packagist](http://packagist.org) now boasts near 31,000 projects compared to 75,000 on Npmjs.org. Both systems have matured considerably.

While historical statistics about NPM in aggregate are unavailable, [Packagist provides several charts](https://packagist.org/statistics) about user activity going back to September of 2011. The number of projects on Packagist has more than doubled in roughly the last 9 months. Not bad for the most hated programming language on Hacker News.

![Packagist usage](/img/2014-05-25-Packagist-charts.png)

## The Challenge

My aim was to create a tool to streamline my design QA work for several urls at once using CrossBrowserTesting.com. The requirements for this project:

 + Cli application
 + Consume RESTful API

I decided to call this tool "Medusa".

## PHP Composer

Since PHP is my specialization, and I like working with Composer for dependency management, I decided to start building a tool using Composer. Several popular packages immediately came to mind:

 + Guzzle - a popular http REST api client
 + Symfony Console - a standalone component for building command line tools

I started a new project using composer:

{% highlight bash %}
$ composer init
$ composer require guzzle/guzzle
$ composer require symfony/console
{% endhighlight %}

Since I hadn't worked with either Guzzle or Symfony seriously before, I had some manual reading to do. Fortunately, the documentation was excellent, and I was able to put together a script in about a day of effort. Well done, PHP!

However, Composer doesn't have an easy mechanism to install a shell script into the path. Apparently, to do so requires subclassing Composer and overriding certain methods. While object oriented paradigms are possibly the best thing to ever happen to PHP, writing a custom installer class shouldn't be necessary for a bare-bones cli tool. **Ideally, we should be able to install an executable script to the path with minimal configuration**. Perhaps I'm too inexperienced here, but really really it should not be hard. Fail, Composer.

***UPDATE August, 2014** - As I suspected originally, there is actually a way to install packages globally (thanks readers!). This information is not readily forthcoming however unless you already know where to find it (for instance it can't be found in the cli help information provided with composer).*

## NodeJS NPM

Having used Uglify-Js on the command line, I knew it had to be easier with NodeJS's NPM. I was able to identify a couple of packages on npmjs.org  quickly for my two requirements:

 + Commander - a command line parser
 + Restler - an HTTP client library

Having more experience with exactly what I wanted to do, I hacked something together in a few hours versus the day I spent playing with PHP. I would have been finished even faster, but the documentation for Commander is not great. For instance, it's not clear how to create a prompt or what a minimal "Hello World" example would look like. Fortunately, other blogs provide samples to reference.

Setting a cli tool on the path was a snap using NPM. Inside package.json, add something like this:

{% highlight js %}
//...
"bin": {
    "medusajs" : "medusa.js"
},
//...
{% endhighlight %}

Then simply `npm link` in the directory of your package.json file. Npm will notify you it's symlinked *medusa.js* into the global path. To execute medusa.js, simply invoke `medusajs` in the shell. Easy! This is how writing a shell script in your favorite programming language should be.

## And the Winner is...

Although the particular packages I used from PHP had better documentation, I'm awarding second place to PHP Composer because of the difficulty in installing packages. For my situation, NodeJS's NPM was the superior tool.
