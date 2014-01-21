---
title: "Settings.php Hack: Keep Credentials out of Your Code"
layout: post
---

Over my three year Drupal career, I've seen several interesting server setups for running Drupal. One technique I've been gravitating toward is storing the environment specific configuration settings **in the environment**.

## Motivation For This Hack

As the web moves more and more into cloud computing, we developers need to get comfortable letting our code run in a new and unforeseen range of contexts. I believe that building our software to depend on environment variables is an excellent way to build more portable code that is flexible enough to thrive in these changing conditions.

Currently as I write this post in November, 2013, I've been running this site on shared hosting through HostGator — not the most exciting choice these days, but it is an affordable option. On many shared hosts including HostGator, databases must be prefixed by your username. However, I like to run my databases using different credentials locally. Also, to setup a staging environment on the same server, you'd need to create a separate database with separate credentials.

My final argument for this particular technique is transparency. I store the code for several side projects on Github as open source projects, but I really don't want the credentials stored there for all to see. By removing credentials from the code, I feel much more confident about using Github this way. Conveniently, Github does not charge for storing open source projects (but they do charge for hosting private repositories).

## Playing with Environment Variables

The trick to getting credentials out of your settings.php file is to use **environment variables**. The shells for Windows, Mac, and Linux are able to store small pieces of information in the environment. It's really easy to temporarily set an environmental variable in a bash shell:

{% highlight php %}
$ set x='y'
$ echo $x
y
{% endhighlight %}

Here's how it looks in a Windows command prompt:

{% highlight php %}
> set x='y'
> echo %x%
'y'
{% endhighlight %}

However, these environment variables will poof out of existence as soon as your restart your computer (or close that terminal session!). In order for Drupal to work, we need a "set it and forget it" approach to these environment variables, so that they persistent indefinitely.

### Long Lived Environment Variables in Windows

In Windows Vista, Windows 7, or WIndows 8, you can set a persistent environment variable by right clicking on "My Computer" > "Properties", then clicking on "Advanced system settings" and clicking "Environment Variables" at the bottom of the dialog box. Then click "New..." and you'll be able to name and set your variable. This variable will be available system wide. Restart Apache and you'll be good to go!

If you're following along on Windows, try setting an environment variable called MY_ENVVAR and set the value to helloWeb. Then skip down to the section on "Testing"

### Persistent Environment Variables for Apache on Mac and Linux

There are at least two different ways to accomplish this. If you're more experienced in this department, please chime in the comments and I'll update this section of the post.

#### 1) Root Acces, Baby!

If you do have root access to your Mac/Linux machine, then you should be able to edit the file **/etc/apache2/envvars**. You can set an environment variable for Apache inside this file like this:

{% highlight php %}
export MY_ENVVAR="helloWeb"
{% endhighlight %}

Using Ubuntu, I had to restart the machine before MY_ENVAR was picked up by Apache. I also needed to restart apache after making a change:

{% highlight php %}
$ sudo apachectl restart 
{% endhighlight %}

#### 2) Using Htaccess

If you don't have root access, never fear! You can still set an environment variable for Apache inside an htaccess file. Create or edit a file named **.htaccess** in the directory above your public root, and add the following code to it:

{% highlight php %}
SetEnv MY_ENVVAR "helloWeb"
{% endhighlight %}

For this to work, you may need to have IT set Apache's AllowOverride directive to "All" or "FileInfo" for your virtual host. Try it out first, then contact support at your hosting company if this doesn't work (see the testing section next).

### Testing Your New Environment Variable

No matter how you set it, we need to make sure that php picks up the environment variable you set. This is super easy. Just a make a file called envvars.php and put it the top directory of your drupal site. Put this inside your file:

{% highlight php %}
<?php var_dump(getenv('MY_ENVVAR')); ?>
{% endhighlight %}

We'll use the <a href="http://php.net/getenv">`getenv()` function</a> to retrieve the environment variable. During debugging, I use `var_dump()` so that I can see what type of variable php is returning. Now go to your drupal site's url and add '/envvars.php' to the end. If you see:

{% highlight php %}
string(8) "helloWeb"
{% endhighlight %}

It worked! You're ready to go on to the rest of this article. If you see:

> bool(0) FALSE

Then, php didn't pick up this variable. First try restarting Apache on that machine. If that doesn't give you the expected result, then try contacting your hosting company's support for assistance or leave me a comment on this post.

## Using an Environment Variable in Settings.php on Drupal 6

**Drupal 6** uses a single *connection string* to store the database credentials. This string contains the user name, the database name and password, the host, and port. Here's an example:

{% highlight php %}
mysql://user:password@localhost/database
{% endhighlight %}

Simply replace 'user' with your database username, and so on. Then set an environment variable with this string for Drupal 6 and the <a href="http://us2.php.net/getenv">php function `getenv`</a> to retrieve the value. Easy!

## Setting and Retrieving Database Credentials on Drupal 7

Drupal 7 uses an array to store the database credentials. Although you could store separate parts of the credentials in separate environment variables, I prefer to use the <a href="http://us2.php.net/serialize">`serialize()` function</a> to convert an array into a string ahead of time. I typically do this by opening an interactive php shell and copying the result:

{% highlight php %}
$ php -a
Interactive shell

php > $creds = array();
php > $creds['driver'] = 'mysql';
php > $creds['database'] = 'databasename';
php > $creds['username'] = 'username';
php > $creds['password'] = 'password';
php > $creds['host'] = 'localhost';
php > $creds['prefix'] = '';
php > print serialize($creds);
a:5:{s:6:"driver";s:5:"mysql";s:8:"database";s:12:"databasename";s:8:"password";s:8:"password";s:4:"host";s:9:"localhost";s:6:"prefix";s:0:"";}
{% endhighlight %}

You'll want to replace all the dummy values above with your actual database credentials, and then copy and paste that last line **exactly** as it appears into an environment variable. Inside my settings.php, I use the following code to retrieve the environment variable:

## Potential Pitfalls

One downside of this approach is that when you set up Drupal on a new environment, you'll have to remember what all the environment variables are that need to be set, and you'll need to set them up appropriately. One way of addressing this problem is to make sure that your project is structured so that the directory above your webroot (public_html, html, www or whatever) is also in source control. Then make a text file documenting these environmental variables above the public root. I would probably call this file INSTALL.TXT since that's a fairly accurate description of the information you want to convey others and future you. If you're using github, create a wiki page to document this information.

## Alternative Means to the Same End

An alternative approach that sometimes works well in practice is to create a single file that contains all the different variables that change based on environment, and then add in detection logic inside that file to set variables appropriately.

While this is a really transparent, centralized way to store all this information for a small number of environments, it quickly gets out of hand for any large number of environments or contexts that you want to account for. Theoretically, this also adds some overhead to each page request that Drupal handles as well (probably even Drupal native cache hits), although this is probably neglible in practice.

You shouldn't be mixing code and configuration any more than you have to. Configuration (like database credentials) should be changeable without forcing your code to be rewritten. By separating the code and configuration as I've done above, you have an elegant scalable solution that can make Drupal work for an infinite number of environments in a more flexible way.

## Just the Beginning

Anything that differs by environment can and arguably should be set as an environmental variable. If there's anything else you want to be different in your development environment than your production or staging environment (such as API credentials), consider creating a new environmental variable.

Drop me a line in your comments to tell me how using environment variables is working for you and what you're using environment variables on your site!  
