---
title: "Ditching Views For SQL"
layout: "post"
excerpt: "I've been using Views in Drupal since I first started using Drupal (and so have you!). So what's wrong with Views? In a word, Debugging. Like many parts of the current Drupal 7 (and Drupal 6) ecosystem, Views works like a charm until something goes wrong. The heart of the problem is that Views does too much. Learn about the alternatives and why you should consider them when Views become unwieldy."
---
I've been using Views in Drupal since I first started using Drupal. It's easy to create dynamic content that stays up to date throughout the site, and on, and on, and on. It's the most comprehensive SQL query builder that I've used, and it's a truly magical piece of software. The Drupal community owns a lot to Merlin of Chaos and the legion of Views contributors.

## What's Wrong with Views?

**Debugging.** Like many parts of the current Drupal 7 (and Drupal 6) ecosystem, Views works like a charm until something goes wrong. At my 9 to 5 job today, I ran into a situation where I needed to change my underlying content type and now my template started displaying random fields. No problem? Views creates a whole host of wonderful preprocessed and postprocessed variables available in the template. So, like any good themer, I `var_dump()`&apos;d the $node object in search of the data I wanted. A quick search through the output showed me that the string was available somewhere inside the $node object. Hooray! Problem solved.

Sadly, **this was on line 8907, and I couldn't see how to drill down** to this variable from the $node object. I decided to write a recursive function to search through all properties of the $node object, and when I left work two hours later, I still hadn't gotten this recursive function quite right. Certainly, I could stick with Views and find a way to output the raw field value.

## The Heart of the Problem

However, let's take a step back and think through what I'm doing here. Views is supposed to prevent me from having to deal with the complexity of writing SQL queries and formatting the outputting. Click, click, click, and you're done. The problem is that while I actually understand SQL fairly well, I don't have any idea what's going in Views when things break. And, due to the unusual complexity of the Views module, it's many plugins and API and recursive objects, it would take me days to troubleshoot even a relatively simple problem like this. Don't get me wrong, I *like* learning new things, but this is a not a good use of my employer's time.

The heart of the problem is that Views, while catering to those who are unable to write SQL, is creating overwhelming complexity for everyone. Part of the reason for this is that Views tries to be comprehensive. It features a whole new theme layer, new url routing logic, extra access control, a suite of plugins to format raw field values, live previews, import/export from code, and a whole bunch of other goodies. In a word, **Views is trying to do too much**.

## The Right Way to Approach SQL

With my degree in philosophy, I tend to be shy about using the "R" word, but I think we can safely say the "normal" and sane way to ease the burden of writing SQL is to create Object Relational Mapper (ORM). An ORM is an internal API for accessing the database. In CakePHP, [the ORM is the first thing you learn](http://book.cakephp.org/2.0/en/tutorials-and-examples/blog/part-two.html#create-a-posts-controller), about CakePHP after doing  the installation. Similarly, it's impossible to do much in Code Igniter or Ruby on Rails without leveraging an ORM. Drupal 7 has taken some steps in this direction with the [EntityFieldQuery](https://api.drupal.org/api/drupal/includes!entity.inc/class/EntityFieldQuery/7) class, but it's probably the last thing you learn about in Drupal. Also, it tends to be a little bit confusing.

For my day job, I'm currently stuck with Drupal 6, so I don't even have the EntityFieldQuery class available. Rather than languish in despair, I actually find the SQL quite easy to write. In all honesty, rewriting the code that tripped me up today in SQL is probably faster than figuring what went wrong in my views template. If you don't know SQL yet, consider taking the time to learn it. Unlike Views, you can use your experience with SQL outside the Drupal community and even with other programming languages like Python/Django, or Ruby/Rails. I think you'll find that this is a good investment in your career as a programmer. 

## Up Next

Ready to make the shift? Check out [Ditching Views part 2](http://bryceadamfisher.com/blog/ditching-views-sql-part-2) to learn about how to implement my advice on your own drupal instance.