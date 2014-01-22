---
title: "Ditching Views For SQL, Part 3"
layout: "post"
excerpt: "In this third and final installment, I'll walk you through some basic Drupal theme hooks that you can use to create memorable template names and inject all the data just as you need it into that template."
---
In part one of this series, I discussed [the reasons not to use Views](/blog/ditching-views-sql) including the difficulty in debugging Views and the fact that Views is only in Drupal (whereas SQL is everywhere online). In part two, I walk you through some [simple SQL queries and tools](/blog/ditching-views-sql-part-2) that you'd use to find the data for a sample project. In this post, I'll connect the results of that SQL query to the Drupal theme layer so that we can actually use that dynamic content in our Drupal site without relying on Views. For today's lesson, you should at least be comfortable with some basic Drupal theming already.

## The End Goal

As a quick reminder from last week, this blog post is a record of how I'm planning to replace the view on my homepage with SQL and Drupal theme hooks. So, the end result we want to have is a list of the most recently created blog titles, the body field, and the node id (so we can make links out of the title). We'll be taking the SQL we wrote last time and doing the preprocessing and theming today.

The final markup should look something like this:

    <ol class="blog-articles">
        <li class="article nid-1">
            <a href="http://bryceadamfisher.com/blog/first-post">
                <h3 class="article-title">First Post</h3>
            </a>
            <p ="article-summary">Shortened summary of the post</p>
        </li>
        <!-- More posts go here just like the above post -->
    </ol>

## Hook_theme() 101

After playing around with the Drupal theme layer for a while, I've really fallen in love with the Drupal theme hook. This hook is really powerfully, and I'm only going to show you my favorite way to use it, but you should know that this hook gives you all kinds of flexibility in case you would like to use it a slightly different way. After reading this tutorial, check out the [API docs for hook_theme()](https://api.drupal.org/api/drupal/modules!system!system.api.php/function/hook_theme/7) if I pique your curiosity.

### Some Background on Drupal Hooks

Let's assume you're using a custom theme called `myblog`. In Drupal speak, `myblog` is the "machine name" of your theme. In practice, `myblog` acts as a PHP namespace of sorts. We use this naming convention because PHP itself causes all functions to live in the same global namespace. So, Drupal has adopted a naming convention of starting all functions declared inside a theme or module with the name of the theme (myblog) to avoid namespace collisions. In addition, all the files associated with that theme will live in a folder called `myblog`. 

Some function names are special in Drupal. Functions that use certain names are invoked by Drupal in response to specific conditions. These specially named functions are called "hooks." In the Drupal API docs, we talk about these functions as `hook_theme` (for instance), or `hook_install`, `hook_enable`, `hook_update`, etc., etc. Whenever you see something referenced as hook_whatever, substitute the theme (or module) namespace for the word hook. Thus, `hook_theme` becomes `myblog_theme`.

**A quick note on Drupal 8:** Drupal 8 is a rewrite of Drupal based on the awesome Symfony project. Drupal 8 uses object oriented techniques to replace the hook system found in all earlier versions of Drupal. At time of writing this, Drupal 8 is scheduled to come out sometime late 2014. My hope is that using object oriented techniques will make debugging Drupal easier by providing easier to follow "breadcrumbs" about what order code is executed in.

### Getting Our Hands Dirty with Hook_theme()

Inside your theme folder (/sites/all/themes/myblog), create or edit the file template.php. Inside this file, create a function `myblog_theme()` like this:

    function myblog_theme($existing, $type) {
        return array(
            'front_blog_teasers' => array(
                'template' => 'front-blog-teaser'
            ),
        );
    }

Here's the important points to note:

* This function _must_ return a specially formatted array.
* The array keys ('front_blog_teaser') can be anything we want, as long it hasn't already been used.
* The value for `template` defines which template file will be parsed, but the file extension is automatically set to ".tpl.php"

This function is only invoked during Drupal cron runs, and the results are cached. So, you **must** run cron each time you make changes to this hook.

### What Did We Just Do?

We've done three important things with this hook:

1. Registered new custom theming
2. Connected that custom theming to a specific template in a debug-friendly way
3. Made new preprocess functions available

We'll take advantage of each of these pieces to do everything that Views was doing for us earlier.

## 1. New Custom Theming

Anywhere we want to display our dynamic content, we can invoke:

    <?php
    print theme('front_blog_teaser');
    ?>

If you're accustomed to working with Views, the equivalent code would be something like:

    <?php
    print views_embed_view('name_of_view');
    ?>

In this project for my blog, I'd place this code just under the `$content` region in page--front.tpl.php. 

## 2. Connected that custom theming to a specific template in a debug-friendly way

In my opinion, one of the worst parts of Views is the God-awful template names that it forces you to use. I'm sorry, but views-view-unformatted--blog-article-block-3.tpl.php is a mystery to me. Especially as a site grows in size and complexity, you end with dozens of views templates. The file name for the template does not provide any insight into where you might expect that template to be used in the site.

Views 2 for Drupal 6 tried to help by helping you track the templates being used inside in the Views Admin UI. However if the view templates are nested at all, even the Views Admin can't explain it to you. Kiss your afternoon goodbye trying to untangle the web of views templates.

Using `hook_theme`, we can do a text search for the name of the template across all files in the project. Such a search would show us where this template is registered, and we'd know to look for somewhere `print theme('front_blog_teaser');` was written to see how this code ended up in the browse. There's no equivalent searchable, debuggable way to uncover what's going on in Views.

### What to put inside the template

Let's actually write the template file code now. Inside the directory /sites/all/themes/myblog/, create the file `front-blog-teaser.tpl.php`. Remember, we'll want to display any number of different post teasers on the homepage. Let's take the markup we want to end up with (above), and substitute imaginary variable names into that html. Later, we'll make sure these variables get injected just how we want them, but for now let's focus on the end result. Here's what I would do:

    <ol class="blog-articles">
    <?php foreach($articles as $article) : ?>
        <li class="article nid-<?php print $article->nid; ?>">
            <a href="<?php print url("node/{$article->nid}"); ?>">
                <h3 class="article-title"><?php print $article->title; ?></h3>
            </a>
            <p ="article-summary"><?php print $article->summary; ?></p>
        </li>
    <?php endforeach; ?>
    </ol>

Quick observations:
* An array of objects named `articles` must be injected into this template
* Each object inside `articles` should have the properties, title, nid, and summary.

### A Word On Debugging Templates

I've chosen each and every variable name because it makes sense to me. However, you could change any of these variables. When debugging the equivalent code in a view template, you would have to use the variables that views forced you to use. Normally that might actually be a good thing, because then no matte who is maintaining this code, Views will always use the same variable names in the same situation. 

I often want to see what variables are available using `var_dump()` to print the values and data types of an expression. With Views templates, the variables injected into the template have so much recursion that `var_dump` will cause PHP to run out of memory and crash. This effectively makes me blind and unable to see what variables are available in the template. Simple changes can take days and have unintended consequences because I don't have good insight into the data that's available. 

By using preprocess functions, the data is dead simple. You can inject primitive data types and know exactly what to expect. If you want to change something, there's a trail in `hook_theme` connecting the template, the custom theming name (ex: 'front_blog_teasers') and the template altogether. The time I spend programming, the more I come to rely on these sorts of breadcrumbs to solve the daily grind of problems that fall into my lap.

## 3. Made preprocess functions available for this custom theming

This is the only piece of black magic you need to use. I saw black magic because there's no strong trail of breadcrumbs connecting this function to `hook_theme`. You just have to know about this trick. (Although, if you read carefully through the API docs for hook_theme, you'll see how to explicitly spell out a preprocess function.) 

By default, the name of the preprocess function is `themename_process_HOOK`. So, for our example, the theme name is `myblog` and the HOOK is `front_blog_teasers`. So, the preprocess function must be named `myblog_preprocess_front_blog_teasers`.

### What's a Preprocess Function?

In Drupal, registering a new custom theming in hook_theme automatically makes a "preprocess" function available. This is where you get to do any special logic to gather and prepare any variables needed in the template. You also get to name the variables and inject them into the template using references.

So for our situation, we'll want to put the drupal SQL query we wrote in part 2 inside the preprocess function and then pass those variables back to the template. Here's how we do that:

    <?php
    function myblog_preprocess_front_blog_teasers(&$vars) {
      // Query all the raw blog teaser data
      $query = "SELECT n.nid, n.title, b.body_value
            FROM {node} n
              JOIN {field_data_body} b
                ON n.nid = b.entity_id
         WHERE n.type = \"article\"
          AND n.status = 1
         ORDER BY n.created DESC";
      $result = db_query($query);
      
      // Format the raw data as PHP variables
      $articles = array();
      while ($row = db_fetch_object($result)) {
        $row->summary = mb_substr($row->body_value, 0, 200);
        $articles[] = $row;
      }

      // Inject these variables into the template
      $vars['articles'] = $articles;
    }
    ?>

There's only two changes here. You notice that we queried the database for the whole body value using SQL, but we're displaying the article summary in the template. I added this line of code to create the summary: `$row->summary = mb_substr($row->body_value, 0, 200);`. The reason I did this was to demonstrate how you might prepare some special information for the template. I should point out however that there is a whole field in the database for the summary and you should probably you use that field instead since blog authors might use a different summary than the first 200 characters of their article.

The other thing worth noting is how we injected the data into the templates. We simply use create an array key in the $vars variable. Since we used `&$vars` as the parameter to this method, any changes to the `$vars` variable will automatically be available as if we returned those changes. I don't love that feature of Drupal, but PHP only allows you to return one value for a function, so I understand the reasoning for this confusing convention. Note that every key in $vars array will a variable in the template.

Save the files, clear the freaking Drupal cache, and you should have your html appear just as you wanted it to. I'll leave it to your imagination to setup the proper CSS styling for this project.

## Taking It Farther

We could have done a lot more. We could used SQL to capture the number of comments associated with an article, the date, the author's name, and the image field for each post. Using the tools and techniques in parts 2 and 3, you easily accomplish this on your own. You could also leverage the Drupal caching system to store the final template markup in your preprocess function. The best way to take this farther is to experiment with the other possibilities using hook_theme. We've just barely scratched the surface!

## Conclusion

Although it takes more time to setup, using SQL and hook_theme allowed us to write easily debuggable and understandable code with much less CPU overhead than running Views. You'll thank yourself at 1am when you need to fix something fast on the homepage that you didn't use Views. 

## Extending the conversation

Like this post? Share it on twitter. Feel free to reach out to me @BryceAdamFisher on twitter or email me through the contact form.