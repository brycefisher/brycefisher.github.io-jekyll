---
title: "Getting to Done Faster with Drush and PHP"
layout: "post"
excerpt: "Drush and PHP have several commands that let you 'play' with your code much faster than you can traditionally in the browser. I only recently noticed them, and I wanted to summarize how to use three separate but related techniques to write bug free code faster on the command line."
category: planet_drupal
---
If you're like me, you've been using Drush ("DRUsh SHell") for a while to make several tasks less tedious: downloading and enabling modules, running database updates, backing up the database, clearing the drupal cache, running drupal cron, and resetting the admin password. Drush does all those things really well for drupal 6 and 7. It just works!

This post is about using Drush as part of your coding process for theming or module development (or even core contributions). Drush and PHP have several commands that I've come to find invaluable while I write code. These commands let you run small snippets without waiting for a whole page to load in the browser. Simply pop open your shell, and start typing. This can be invaluable to make sure that the code behaves how you think it will. This makes your code faster to write and less prone to error because you'll already know what the code is doing better.

One final argument for using these techniques is isolation. It's often hard to trigger exactly the piece of code that you want to understand. All these commands allow you focus on a specific piece of code without the distractions and complications of a whole site.

## Command 1: Evaluating PHP snippets in Drupal `drush ev`

This command evaluates a single line of PHP code in the context of drupal. I use this all the time to test that various Drupal API functions work as I expect. Here's a quick example. Let's say you're not sure if the `l()` function will return the URL or the anchor tag inside your template function. Here's what do:

{% highlight bash %}
$ cd /path/to/drupal
$ drush ev "print l('node/1');"
http://example.com/node
{% endhighlight %}

Great! We can now see how this particular function will work without doing a bunch of other stuff that takes 10-15 seconds. We now know exactly what to put inside our template file. 

Here's another simple example of `drush ev`. Let's say we've written a helper function in our custom module that takes a nid and returns a field value. However, you wrote this function last month you're sure if the return value is an object or an array or a string.  Let's find out:

{% highlight bash %}
$ cd /path/to/drupal
$ drush ev "var_dump(my_module_helper(1));"
array(1) { 0 => "hello drush" }
{% endhighlight %}

You've just saved yourself several minutes digging through your own code. Well done! There's a million ways to use this code. I often use `drush ev` to test each command I'm interesting in while implementing a function for the first time. This prevents me from running into surprises 99% of the time and has made me much more productive.

### Caveats with `drush ev`

Drush won't print anything to the shell when the command ends, so you'll need to use `print_r()`, `print`, `echo`, or `var_dump()` to see the result of the command in the shell.

The big limitation of `drush ev` is that you can only execute one liners. If the code you want to execute can't be called in one line, see if the next technique is more appropriate. 

## Command 2: Interactive php shell with `php -a`

This command opens an interactive php shell which is really useful for prototyping a sequence of built-in php commands that can't be fit into a one-liner. This is awesome for experimenting with array operations, reflections in PHP, regex functions like `preg_match()`, or other confusing syntax. Any time you're not sure how a php function will work, give this a shot.

### Mac and Linux Examples of interactive PHP Shell

On OSX and Linux, here's how this works:

{% highlight bash %}
$ php -a

interactive shell
php > $x = serialize(array(1 => 'abc'));
php > echo $x;
a:1:{i:1;s:3:"abc";}
{% endhighlight %}

Notice that you still need to issue some sort of print/var_dump command to see the output. However, you can create and manipulate as many variables as you want on as many lines of code as you want.

### Windows Example:

I no longer have a windows machine at home, but this works a little differently on Windows. Here's an example from memory:

{% highlight powershell %}
C:\> php -e

<?php
$x = serialize(array(1 => 'abc'));
echo $x;
?>CTRL-Z
a:1:{i:1;s:3:"abc";}

C:\>
{% endhighlight %}

So, the main thing to note is that php on windows will treat whatever you type as a regular php file which requires the use of <?php and ?> to work. Also, php won't start interpreting until you press CTRL + Z and ENTER after the closing ?>. So, this is less useful on windows, but still really handy when you need it.

## Command 3: Executing SQL Queries with `drush sqlq`

If you've ever found yourself typing SQL on the command through the mysql client, it can be a real pain to look up the user name and password just to execute some simple queries. Drush has your back! It uses it's magic to execute sql queries in the context of the Drupal database with `drush sqlq`.

This command is really useful for figuring out sql querys that **change** the database. For instance, if you want to write a module update that unpublishes all nodes of a certain type, you could try out the query using this command. To see the effects, however you'll still need to look at the live site directly or use a MySQL gui client like Sequel for Mac or Heidi SQL for Windows.

## A Word about Best Practices

The drush commands I've shown you are really powerful. And, as uncle Ben taught us in Spiderman, "with great power comes great responsibility." **Please do not use these commands on a production website.** These commands are awesome at debugging your problems locally, but they can really mess up your website. They are not "sandboxed" in anyway.

Okay, with that said, go out there and write some great code that works the first time you run it!
