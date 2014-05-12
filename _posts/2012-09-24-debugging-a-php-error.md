---
title: Debugging A PHP Error
layout: "post"
excerpt: "Guide to understanding and fixing many a common php error, and php tools that help."
category: php
tags:
- debugging
- xdebug
---
I classify any PHP error in two flavors: coding errors and design errors. Firstly, I'll discuss what a coding error is, why it might occur, how to find the error, and common fixes. Secondly, I'll compare and contrast with design errors, since they can be more subtle and complex.

##Coding Errors

Coding errors involved a problem with the actual code written -- for example a misspelled word, a missing semicolon at the end of a line, etc. When configured to do so, PHP can provide error messages when it encounters a coding error, but often times error messages are turned off. However, in order to solve coding errors, you will need to configure PHP to provide you with these error messages.

### Why Are Error Messages Turned Off?

For security. PHP error messages often display part of the PHP code used to operate your website, or provide detailed information about the inner workings of your code or your webserver. Online predators could use this information to infect your server, gain unauthorized access, do other unpleasant things. You can make your website considerable more secure from these kinds of risks by keeping PHP error messages hidden from view on any publicly available websites. 

### Finding Error Messages

There are two ways to keep these error messages private, while still being able see the error messages yourself:

#### 1. Only Display Errors on a Private Server

Typically, you'll have a "development" server on your personal computer or a company server. This server should not be reachable by the general public online. If you're working alone, you'll want to setup a development server on your computer using Apache, MySQL, and PHP. There are easy to install preconfigured webservers for Mac OSX (mamp) and Windows (xampp) available free online. Usually, php developers will do the early phases of programming on a development server before they are ready to show their website to the world. Then they move all the code to a public webserver once they are done with the initial programming.

To display error messages for a single file, include this code at the beginning of your code, right after &lt;?php 

{% highlight php %}
ini_set('display_errors','On');

// Your existing code below here
{% endhighlight %}

#### 2. Log Error Messages on a Public Website

PHP can be configured to write error messages to a file named error_log. It does not have a file name extension -- the full file name is error_log. Typically, this file will be created in the same directory that error occurred in. Error logs are usually hidden from public view, but they can be downloaded through FTP so that you can still read the error message. This way, you can keep your server a little more secure and still be able to know where PHP encountered an error.

To turn on error logging for your server, find your php.ini file (use phpinfo() to help you locate this file), and make sure there is a line in php.ini that has

    log_errors=On

If you see a line:

    log_errors=Off

Change it to "log_errors=On", and restart Apache.

### Understanding Error Messages

There are several kinds of errors that you will run into if you work with PHP for any length of time.

#### Syntax Errors

The most common errors are syntax errors, and the most common among these are missing semicolons from the end of the previous line, or missing brackets, or missing parentheses. Here is a list of [all tokens that might occur in an error message](http://php.net/tokens).

##### Fixing Common Syntax Errors

PHP error messages always include a file name and a line number. Syntax usually occur on the previous line. Open the file name in error message, go to the line number, and look carefully at the previous line, making sure:

* There is a semicolon at the end of the line (if necessary)
* All parentheses and brackets open and close properly
* All single quotes and double quotes have a matching pair
* Every if statement has a closing bracket
* Every function has a closing bracket
* Every class has a closing bracket
* Every for, while, foreach, and switch statement has a closing bracket
* Every part of an if statement has an opening and closing parenthesis

If that list didn't solve your problem, try commenting out the entire file, and uncomment line by line until you figure where the error is occurring.

##### Preventing Syntax Errors

Over time, you are unlikely to stop making this mistake. Therefore, most programmers like to use a text editor that has syntax highlighting so that you'll see visual cues about syntax problems as you type. This way, you can notice these problems right away, instead of spending minutes or hours looking for them on your own. This kind of help will save you hours and hours of time, and make your coding experience much more enjoyable. Some tools automatically create matching pairs of brackets, parentheses, and quotation marks for you as you type. Other programs beep if you type a syntax error. 

Personally, I've been VIm for years because it's free to download and use, it's crossplatform, it's on every linux machine ever, and it has a very healthy ecosystem of users and plugins. Have a look at [my php syntax checking trick for vim]({% post_url 2013-04-06-simple-check-for-php-syntax-errors-in-vim %}) if you decide to give VIm a spin. No tool is perfect, but most text editors will help you spot 99% of these kind of syntax errors.

## Design Errors

Design errors occur when the code simply does not behave as expected, but no error message comes from PHP. Typically this occurs when the programmer (you!) has a wrong understanding of how some piece of software works. This can be a much harder to problem to solve. I use three different tactics to overcome a design error. 

### 1. Reread the documentation carefully

Often, I've not read the documentation slowly that explains the php code I'm using, or I've missed an important concept on how this software is supposed to work, or what feature it offers. All native php functions can be found by going to http://php.net/function. For instance, the var_dump function's documentation can be found at <a href="http://php.net/var_dump">http://php.net/var_dump</a>. Also, googling "how to do ____ using ____" can uncover unofficial documentation, or posting questions on Stack Exchange can uncover help from the community.

Sometimes, documentation is out of date, incomplete, or just plain wrong. In these cases, it's time to try something else. 

### 2. Try Another Approach

Most of the time, you just want to accomplish some task and it doesn't make sense to spend too much time figuring why something isn't working, or how something new is supposed to work. If you've worked with PHP before, use an easier or simpler solution. Better yet use a technique or piece of software with which you're more familiar. Playing to your strengths is a great way to increase your own productivity. 

Sometimes you just have to get something very specific to work a certain way. In these cases try the next technique.

#### 3. Verify each step of your code

Use the `var_dump()` or `exit()` function to see what's happening at critical moments in your code, such as checking what arguments were passed to your function, or if a function is being called at all. This is best way to get familiar with a small section of code that is doing something strange. The trick is to _figure out where you STOP understanding_ what's going on, and try to test different variables and values in the code to understand what's happening there. **Don't assume anything!** Keep finding and figuring out roadblocks _one at a time_ until you've worked through the problem.

There are several tools that can help you "step" through the code to check variables at point in the execution of a script. Perhaps the most popular tool is [xdebug](http://xdebug.org/index.php).

While this is a great way to understand code, it's very time consuming if you're working with a large piece of software like WordPress, Joomla, or Drupal. However, if you're a novice programmer or a PHP newbie, this is the best guide to learning PHP there is.
