---
title: "Running PHP 5.2 and 5.3 on the Same Server"
layout: "post"
excerpt: "A quick tutorial on setting up two versions of php (5.2 and 5.3) on the same HostGator shared hosting account"
---
In this tutorial, I'm going walk you through how to setup PHP 5.3 and PHP 5.2 on the same shared hosting account with HostGator. Obviously, having two separate servers would be the ideal scenario, but when budgets don't allow for that, it is possible to run different PHP versions on the same server and even account. Onward!

##Why???

I'm running [Drupal](http://drupal.org) as the CMS on my personal shared hosting account, and I've been playing with around with (Fat Free Framework)[http://github.com/bcosca/fatfree] for building a lightweight backend and RESTful API to a mobile app. Before dishing out the whopping $50/month to rollout my app on a dedicated server, I just wanted to do some basic user testing early on in the process. So, to save some money, I'm using my personal shared hosting account (with HostGator). 

Unfortunately, Fat Free Framework requires PHP 5.3+ to work it's magic, but HostGator by default uses PHP 5.2. After puttering through their documentation, I discovered that PHP 5.3 comes pre-installed on all shared hosting. Hooray! However, none of the Zend extensions are compatible with HostGator's PHP 5.3 setup, such as PDO, sqlite, pdo_mysql, and others. Here's the rub -- Drupal __depends__ on these modules being loaded. So how can we escape this from this most heart-rending dilemma ever seen???

##Two Php Configurations

Because HostGator uses suPHP by default, we can instruct suPHP to load different php.ini files inside an .htaccess file. So, once we know what directives need to be set for each platform, we can put a custom php.ini and custom .htaccess file in their directories. Since most .htaccess directives apply to all subdirectories, we only need to put these configuration files into the top directories that need PHP 5.3, and everywhere that PHP 5.2 or Zend is needed, we can just leave everything as-is. The end result will be that each project has exactly the environment it needs.

To illustrate, here's how I've structured my home directory:

    /home/user/
        php.ini -- This is the default that comes with shared hosting. No need to change this!
        public_html/ -- Drupal lives in here. Uses PHP 5.2 with Zend modules by default 
            ...
        php53/
             .htaccess -- Tells Apache to use PHP 5.3 in this folder and all sub-folders
             php.ini -- Tells suPHP not to load Zend modules

###Htaccess File for PHP 5.3

So, let's put together the htaccess file for PHP 5.3. First we need to instruct Apache to use PHP 5.3 in this directory and all other subdirectories:

    AddType application/x-httpd-php53 .php

That was easy, right? Okay, now let's tell suPHP where to find our custom php.ini file:

    <IfModule mod_suphp.c>
	suPHP_ConfigPath /home/user/php53
    </IfModule>

__NOTE:__ You'll need to change the path to point to the directory where you're custom php.ini will be. The example above uses the directory structure I've outlined earlier in the article. 

###php.ini File for PHP 5.3

By default, HostGator puts a php.ini for you in your home directory. Copy that file into the directory where you want to use PHP 5.3; for this example that would be `/home/user/php53`. Open this file in your favorite text editor, and comment out all the lines underneath `[Zend]`. For me, this happens starting on line 1125, but it may be different for you. To comment out a line, simply put a semicolon `;` in front of it.  

Also, PHP 5.3 seems to require a timezone to be set in the php.ini file. Simply add this code to the very bottom (substituting the "`America/Los_Angeles`" with your (time zone)[http://php.net/manual/en/timezones.php]):

    [Date]
    date.timezone="America/Los_Angeles"

When you are finished, the end of your custom php.ini file should look like this:

	[Zend]

	;extension=magickwand.so 
	;extension=imagick.so
	;extension=mailparse.so

	;extension=pdo.so
	;extension=pdo_sqlite.so
	;extension=sqlite.so
	;extension=pdo_mysql.so
	;extension=uploadprogress.so
	;extension=gnupg.so
	;extension=mailparse.so
	;extension=fileinfo.so

	;extension=mongo.so
	;extension=http.so
	;extension=phar.so
	;extension="ixed.5.2.lin"
	;zend_extension="/usr/local/Zend/lib/Optimizer-3.3.9/php-5.2.x/ZendOptimizer.so"

	[Date]
	date.timezone="America/Los_Angeles"

## Making Sure It Works

Once you've uploaded your custom .htaccess and php.ini to the proper folder, create a file called phpinfo.php, and add this to it: `<?php phpinfo(); ?>`. Upload this folder to a publicly viewable location inside `/home/user/php53` and open it in your browser. Scanning through the output, you should have PHP 5.3 running, and you should find your custom php.ini mentioned as well. Once you've found this information, remove the phpinfo.php. You should now be ready to upload your PHP 5.3+ code into the folder.

## Further Reading:

* [http://stackoverflow.com/questions/2271910/edit-htaccess-to-load-php-extension]
* [http://support.hostgator.com/articles/specialized-help/technical/what-is-php-ini]
* [http://support.hostgator.com/articles/hosting-guide/hardware-software/php-5-3]
