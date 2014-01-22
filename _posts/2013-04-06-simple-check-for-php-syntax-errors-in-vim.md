---
title: "Simple Check for PHP Syntax Errors in Vim"
layout: "post"
excerpt: "A simple command (and keyboard shortcut) to use PHP's built-in linting for finding syntax errors "
---
If you have php on your system PATH, it comes with a simple check for syntax errors in your php files without actually executing them. It works on all platforms (Windows, Mac, Linux). While you may want to use a more robust form of code checking from vim plugins on your development box, this command can be really handy when editing php files over SSH.

## Just the Facts

In case you don't want a long explanation, here's how to lint the current file for syntax errors on vim:

   :!php -l %

## Make sure PHP is installed

To see if you have php on the PATH, open up a command prompt or shell, and type:

    php -v

If you see something like this, then you're good to go!

    Zend Engine v2.2.0, Copyright (c) 1998-2010 Zend Technologies
    with the ionCube PHP Loader v4.2.2, Copyright (c) 2002-2012, by ionCube Ltd
    , and
    with Zend Optimizer v3.3.9, Copyright (c) 1998-2009, by Zend Technologies

Setting up php is beyond the scope of this article.

## PHP Syntax checking with *-l* flag

To run the syntax checking on a php file, use php with *l* flag, like this:

    php -l example.php

You can use this command on any shell. You'll see a response like this if all is well: "No syntax errors detected in authorize.php." Otherwise, you'll see the type of error, file and line number displayed on the shell. This won't make sure that you've used framework APIs correctly, but it's a great first line of defense against stray keys and silly mistakes. When running vim sessions over SSH, this can be really handy for checking files quickly for simple mistakes that can easily get past you. For local development this is also handy when you've only got access to part of the project files, and some include files aren't available. 

## Using PHP -l In Vim

So, now we understand how to run this command on the shell. Let's run it from within vim:

   :!php -l %

The only interesting thing here is that **%** refers to the current file, no matter the file extension. This is really handy when working with PHP platforms (like Drupal) that use php files with strange file extensions such as .module, .inc, .install, etc, etc. Obviously the **:** puts us in EX mode, and **!** runs a command on the shell. So this command tells vim to run php -l against the current file. Vim will show the result of the operation and wait until you press a key to continue so that you can read the output from php.

### Map it for Later

I use this so much, I've mapped this to my F1 key and added the map to my vimrc file. Here's how you can do the same:

    :nmap <F1> :! php -l "%"
