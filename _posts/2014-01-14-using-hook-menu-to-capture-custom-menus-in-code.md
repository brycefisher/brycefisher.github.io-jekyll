---
title: "Using hook_menu to capture custom menus in code"
layout: "post"
excerpt: "A how-to guide on creating a public-facing menu using hook_menu(). We'll also talk about why hook_menu is so bad, 2 techniques for nesting menu items, and how to put a menu item into the menu of your choosing."
category: planet_drupal
---
Every time I use `hook_menu()`, I get an awful headache. Why? Drupal has overloaded this hook to handle both the menu system and the routing system, which seems like an architectural mistake to me. As a result, `hook_menu()` has many confusing and poorly documented features in the [very lengthy api documentation](https://api.drupal.org/api/drupal/developer!hooks!core.php/function/hook_menu/6). I'm going to walk you through some rather simple steps to using `hook_menu()` to create public-facing menu items. I won't get into the complexities of the routing system.

## Why Would We Want to Use This?

Since it's so easy to create menu items inside the admin pages, why would you ever want to create a custom menu item in code? **Any time you want to create a new path that links to custom functionality**, you'll want to reach for `hook_menu()`. Drupal does a great job of handling url aliases to nodes and other entities (taxonomy, users, etc), but the admin forms don't allow you to trigger custom PHP code at an arbitrary path.

An additional benefit that I'll touch on briefly is **access control**. This hook allows you to specify what permissions a given path will require of the user. So, any time you need really custom roles or permissions, consider using hook_permission() (aka hook_perm in Drupal 6) to create a new permission. Then read the api documentation above, specifically the "access arguments" section. I'll leave this as an exercise for the reader.

## Starting with the Basics

This hook will only be detected by Drupal inside of a module. You can't put it in template.php. 

Also, it's important to know how to trigger this function, since Drupal only runs it rarely. In Drupal 6, you'll have to visit the modules page. In Drupal 7, it seems to be enough to clear all caches (you may have to run cron as well). This is important because it's to be fooled into thinking that your changes to hook_menu were incorrectly done. One commenter suggested [a technique for automatically refreshing hook_menu during development.](https://api.drupal.org/comment/5129#comment-5129)

I should also note that it's good to look at the admin menu page periodically to make sure that your changes worked. In drupal 7, you can find the list of menus at 'admin/structure/menu'. In Drupal 6, check out 'admin/build/menu'. 

## Getting our hands dirty `hook_menu()`

Let's talk about the function signature. Don't accept any arguments into your function. Do return an array, which is by convention named `$items`. The outline of the function will look like this:

{% highlight php %}
<?php
function mymodule_menu() {
    $items = array();

    return $items;
}
{% endhighlight %}

This is correct, but won't do anything yet.

### Creating Menu Items

To actually create some menu items, we'll need to set the paths for the menu items as keys in the `$items` array. Here's a simple example:

{% highlight php %}
<?php
function mymodule_menu() {
    $items = array();

    $items['status'] = array();

    return $items;
}
{% endhighlight %}

The key line above is `$items['status'] = array()`. The array key 'status' tells Drupal to listen for requests at that path or route. (I use the terms "path" and "route" interchangeably throughout this article.) We'll need to fill in some more code to tell Drupal how to respond to requests on that route:

{% highlight php %}
<?php
function mymodule_menu() {
    $items = array();

    $items['status'] = array(
        'title' => 'My Status Page',
        'menu_name' => 'main-menu',
        'page callback' => 'mymodule_status_page',
        'access arguments' => array('access content'),
    );

    return $items;
}
{% endhighlight %}

The nested array takes several different keys. This is where the online documentation gets really hard to read. Some keys are incompatible or nonsensical with other keys, and other keys are required but only in certain situations. The above code is one combination of keys that will work to create a new top level menu item in the Main Menu labelled 'My Status Page'. Here's a detailed explanation:

* **title** - This key allows you to set the text shown to the user on the menu
* **menu_name** - Just what it sounds like. If you omit this, Drupal defaults to the Navigation menu which is only shown to authenticated users. Set this key to whatever menu you want the item to appear in.
* **access arguments** - This array is passed to the function `user_access()` to check if the current user has all those permissions. I always use `access content` so that if the site content needs to be put behind a paywall, or otherwise hidden later on, it will default to whatever the rest of the site content is set to.

### Page Callback Functions

The `'page callback'` specifies a callback function name. So, I would need to write a function mymodule_status_page(). If your custom menu item is outputting html, you'll want to eventually output using the `theme('page', ...)` function. For example:

{% highlight php %}
<?php
function mymodule_status_page() {
    // Do custom stuff here
    $html = ''; //Put the final markup in $html
 
    // theme('page') will wrap your output with a
    // page in the create theme (admin or public).
    print theme('page', $html);
}
{% endhighlight %}

## Hierarchy: Taking it to the next level

What if we wanted to nest a menu item? There are two ways of doing this. 

### 1. Automatic Nesting Based on Route

By default, Drupal will look at the registered paths in the menu/router system, and it will organize them hierarchically. So, if we wanted to add a subpage underneath our 'status' route (defined above), we could create a new route at 'status/us-east-1'. Here's the code we'd need to use to do that:

{% highlight php %}
<?php
function mymodule_menu() {
    $items = array();

    // "Parent" route
    $items['status'] = array(
        // add the keys here
    );

    // "Child" route
    $items['status/us-east-1'] = array(
        // add keys here
    );

    return $items;
}
{% endhighlight %}

I've omitted the keys ('title', etc) for clarity's sake, but all the keys on each route work just as we discussed above. 

I appreciate the fact that adding routes in this manner will work seamlessly with custom menu items created on menu admin form. Neat! For more examples of nesting using this method, I do recommend checking out the [api documentation](https://api.drupal.org/api/drupal/developer!hooks!core.php/function/hook_menu/6).

### 2. Explicitly Specifying a Parent Menu Item

What if you wanted to make 'status/us-east-1' the parent of 'status' in the menu? Unfortunately, there's no safe way to do that across browsers other than manually dragging the menu items around in the admin form. The reason we can't do that safely is that we don't a reliable to figure out what the menu id (called `mlid`) is in the database until *after* `hook_menu()` runs. This is a really unfortunate problem with the existing system that lumps menu and router systems together.

Fortunately, we can rearrange menu items by specifying the parent menu id (called the `plid`) for known items. The `plid` number will almost certainly be specific to the database you're working on, so I wouldn't use it for a contrib module. However, this is perfectly acceptable for your own freelance or agency custom module development.

### Here's how it works:

 1. Create the child menu item in `$items`
 2. Find the parent menu item we want to attach the child to
 3. Find the 'mlid' value of the parent menu item
 4. Add a new key to the child menu item called 'plid' and set the value you found in step 3.

The tricky step here is finding the mlid value of the parent. The simplest way to do that is to use the admin form page and mouse over the parent menu item edit link. Use that number at the end of url:

![Finding the mlid on the Drupal admin forms for menu editing](/img/2014-01-14-mlid-hint.png)

Here's what that code looks like:

{% highlight php %}
<?php
function mymodule_menu() {
    $items = array();

    // "Child" route
    $items['status'] = array(
        // add the other keys here
        'plid' => 218, // mlid of the parent
    );

    return $items;
}
{% endhighlight %}
