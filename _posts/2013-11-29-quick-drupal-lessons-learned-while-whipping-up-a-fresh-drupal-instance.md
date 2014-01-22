---
title: "Quick Drupal - Lessons Learned While Whipping Up a Fresh Drupal Instance"
layout: "post"
excerpt: "I've recently started experimenting with using drush core-quick-drupal to create drupal sites strictly for creating patches to share on drupal.org. I'll walk you through my several pitfalls on the road to making this command work on Ubuntu 12.04. Hopefully, with this advice in hand, you'll be able to spin up fresh drupal instances in no time!"
---
I've recently migrated to Ubuntu 12.04 from Windows, and I ran into some issues getting the drush core-quick-drupal command. As a quick refresher, the "quick drupal" command will download, install, and even login to a new drupal instance on your local machine. It's really hand for debugging and also contributing patches back to drupal.org because you eliminate any side effects from bizarre customizations. Coming from a Windows background there were quite a few hurdles I had to figure out -- so I thought I'd record my experiences here for other poor souls trying to use quick drupal on Ubuntu. Some of these tips will doubtless be helpful on Mac or Windows as well.

## Problem - Old Drush Installed

Ubuntu uses a package management tool called "apt-get" to install, update, and remove applications from the operating systems. If you've ever used composer for PHP, or npm for NodeJS, it's exactly the same, and it's my favorite feature of linuxy operating systems over Mac and Windows. Conveniently, apt-get has a package for drush!

    $ sudo apt-get install drush

Unfortunately, the apt-get version of Drush is version 4.x, whereas the stable version of Drush is 5.x. Also, the quick drupal command we're insterested in is only added to drush starting somewhere in the 5.x branch. However, drush has it's own self-update command. Hooray!

   $ drush self-update -y

Phew! Now if you run `drush help` in the terminal, you'll see that the command "core-quick-drupal" listed near the top. 

## Problem - RTFM

I *thought* I was an experienced drush ninja, but it turns out I hadn't fully read the documentation carefully for core-quick-drupal command. One reason I love the quick drupal command is that it doesn't require you to setup a mysql database (you can use SQLite which is much simpler for testing patches) and you don't need to configure Apache (more on that later). You just type this one command and everything magically works.

To use quick drupal as I had intended, you actually need to use the first optional parameter. So, the command will look like this:

    $ drush core-quick-drupal patches -y

Notice "patches" in the command above. "patches" is the site name parameter, and you **must** specify this parameter or else drush will try to use mysql for datastore, and if it fails you'll have all kinds of weird errors. The moral of the story here is to always "read the fucking manual" as the old adage goes.

## Problem - SQLite Not Installed

Eventually, I realized that SQLite does not come pre-installed on Ubuntu 12.04 (at least, not in the Desktop distro that I downloaded). I also found some blogs that mentioned PHP5 requires sqlite v3 to work and the php5 sqlite connector. I use apt-get to install these dependencies:

    $ sudo apt-get install sqlite3 
    $ sudo apt-get install php5-sqlite3

If you try the quick drupal command again, you should start to get helpful error messages at this point.

## Problem - Required PHP Extensions Missing

If you've followed along with me so far, you can probably figure the rest of this out on your own just fine. 

However, this next hurdle blocked me for a while because the error message in the terminal had html around it. With my particular setup, I had use apt-get to install php on my machine but certain extensions required by Drupal were not installed as part of apt-get command. In my case, I found that the "gd" graphics library was not installed. Fortunately, a compatible version of gd for php5 can be easily installed:

    $ sudo apt-get install php5-gd

## Use a Compatible PHP Binary

The quick drupal command was intended to be used with PHP 5.4 because this version of PHP has an embedded web server that obviates the need for Apache or Nginx (or whatever). It's very easy to get PHP 5.4 with a full WAMPP stack on Windows using Apache Friends' XAMPP installer. I highly recommend that approach since you won't have to follow any of the steps in this tutorial to get up and running with Drupal.

Ubuntu's apt-get only has PHP 5.3 which doesn't have the php web server built-in. Furthermore, drush core-quick-drupal doesn't like the cli flavor of PHP 5.3 either. So, unless you want to compile PHP and all the necessary extensions from source, I recommend you install the PHP cgi binary:

    $ sudo apt-get install php-cgi


### Emulating the Web Server on PHP 5.3

If you try to run quick drupal now, Drush has a fantastic error message that tells you exactly what to do. You'll need to download a [library from github that runs a pure php httpserver](https://github.com/youngj/httpserver/tarball/41dd2b7160b8cbd25d7b5383e3ffc6d8a9a59478). This is only necessary for php 5.3. You'll need to unpack this tarball in the `/usr/share/drush/lib` directory. When you're done, make sure that this file exists: `/usr/share/drush/lib/youngj-httpserver-41dd2b7/httpserver.php`

Sadly, quick drupal still won't work without one more component.

## Setup A Local Email Server

Quick Drupal is starting to not be so quick, you're probably thinking. But, it will be once you get this command working. You're almost there! The only thing missing at this point is a working email server. Drupal needs to be send out an administrator email when you start the quick drupal instance. There's probably a way around this step, but it's actually easier than I had thought.

### Dummy Mail for Windows

If you're running Windows, just use [SMTP 4 Dev a dummy SMTP server](https://smtp4dev.codeplex.com/). It's so easy... you'll thank yourself a millions times for using this program.

### A "Real" Email Server for Ubuntu

On Ubuntu, we're going to install postfix and mailutils, and then we'll configure them. There's a great [stackoverflow that explains postfix setup nicely](http://serverfault.com/questions/119105/setup-ubuntu-server-to-send-mail), but I'll explain how I did it slightly differently. 

     $ sudo apt-get install postfix

During the install screen in the terminal, I choose "local server" (the last option). This means that postfix will only deliver emails locally to the current machine. The next screen will ask you for a Fully Qualified Doman Name. This doesn't matter -- I entered localhost and it worked fine. 

### Checking Email in the Terminal

Next you'll need to install the command line mail client:

    $ sudo apt-get install mailutils

Try sending yourself a test email now like this:

{% highlight bash %}
$ mail -s "Testing" root@localhost
Cc: [ENTER]
[CTRL-D]
{% endhighlight %}

Pressing CTRL + D ends the message body and sends the message. You should be able to see that message was sent (`Null message body; hope that's ok`). You should be good to go!

### Tell PHP How to Use Postfix to Email You the Admin Password

Then under /etc/php5/conf.d create a file (e.g. mailconfig.ini) with these contents (note you'll need sudo permissions to save the file in this directory):

    sendmail_from = "root@localhost"
    sendmail_path = "/usr/sbin/sendmail -t -i -f root@localhost"

## It Works!

Finally, we can now run the quick drupal command...quickly. Here's how to do it:

    $ cd /path/to/where/drupal/should/be
    $ drush qd my_drupal -y

A few minutes later, you'll have a php server running a Drupal instance on SQLite, and your browser will open and login you in as the admin user. Hooray! Now go make some patches.
