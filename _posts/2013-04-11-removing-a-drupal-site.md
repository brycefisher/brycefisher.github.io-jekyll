---
title: "Removing a Drupal Site"
layout: "post"
excerpt: "Simple tricks for deleting a drupal site from a Linux server."
---
I run a lot of development sites on my web server, and after the sites launch I remove the development sites. However, running a simple `rm -rf drupal/path/` from the shell never works. There's always a few files that linger. 

During site-install, Drupal 7 protects 4 key files by setting permissions to something like 500. All we have to do is change the permissions and then delete them. Once you've logged in SSH, and changed into your Drupal root directory, follow these steps:

{% highlight bash %}
$ chmod 777 sites/default sites/default/files sites/default/*.php
$ rm -rf sites/
{% endhighlight %}
