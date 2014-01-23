---
title: "Considerations for Multisite Drupal"
layout: "post"
excerpt: "At my day job, we've been using the Domain Access module with Drupal 6 for 5 years. Recently, we've decided it's time to rethink our approach to Drupal multisite. In this article, I'll share some of ideal use cases and pitfalls for the Domain module and some alternatives for you to consider."
category: planet_drupal
---
We've been using [the Domain Access the module](https://drupal.org/project/domain) at my day job for about 5 years with Drupal 6. Recently, we've decided Domain Access is not the right solution for our use case. 

## Domain Access

### Strengths

According to the module's project page, Domain Access (emphasis mine)

> provides tools for running a group of **affiliated sites** from one Drupal installation and a single shared database. The module allows you to share users, **content,** and configurations.

The problem this module aims to solve is allowing multiple domains to have **identical content**. If you're trying to build multiple sites with **substantial amounts of identical content**, definitely use the Domain Access module. It's fantastic at making the very same information available on different subdomains (one.example.com and two.example.com) and different top level domains as well (one.com and two.com). One of the best features of Domain Access is the ability to share users and passwords across different sites using the same Drupal authentication system you already know. Awesome!

### Pitfalls

**Tight Coupling of Dependencies** If you're using Domain Access, the same modules are powering your site. This could be a good thing or a bad thing depending on your perspective. From my point of view, this is more of a problem than a solution. For example, imagine a new version of Views comes out and you have twenty views with heavy customization on each domain of 5 domains. You have to be sure that upgrading the Views module won't break 100 different views before you deploy the new module. Personally, I'd rather test only 20 views at a time rather than 100. 

Any big change to any of the sites (especially contrib modules) means you should really be checking the admin forms and a good sampling of urls and functionality across each domain. It sounds like less work to maintain only one Drupal instance that powers multiple websites. In my experience, it's almost always more work to force one Drupal instance to work across a spectrum of different sites, each with different requirements and stakeholders. It ends up being less work to ship any given piece of code when each site is it's own island.

**SEO Snafus** In the six months I've been at my current job, I've gotten numerous complaints of nodes being indexed at the wrong domain. Domain Access only checks for *permission* of the current user for a given path. This means that you can't have two different nodes at the same path at different domains. Each node must have a unique path across all domains. Additionally, if a user mistakenly accesses a node that exists at a different subdomain, they will get a 403 error (access denied) instead of 404 error (not found). Each site builder must be trained on how to use set the appropriate the domain access settings. If nodes are configured improperly, Google can (and will!) index the wrong domain for that node. Many times, certain content types are only properly themed for one domain, and when they are indexed at a different domain, the content looks horrible.

**Views and Node Access** Unfortunately, Views will mostly respect the user access settings of a given node. At least in Drupal 6 and probably Drupal 7, this means that you can't easily create views with teasers of content from another domain unless that content is accessible on the same domain as the view. For instance, at our main corporate site we have a blog teaser. Unfortunately, we couldn't create a view because each of our blog posts was only allowed on our blog domain. As a workaround, we've created RSS feeds using views on the blog site, then ingested that feed on the corporate site in many instances. For other situations, we've abandoned Views and written SQL directly.

**SEO Penalties** Additionally, when using this module correctly, major [search engines will sometimes penalize urls that showing identical content](https://support.google.com/webmasters/answer/66359?hl=en) at different domains. 

## Use Separate Drupal Databases

Another way to approach a multisite situation is to create new database on a MySQL server, and create another `settings.php` file. The advantage of this technique is that you can share module code across different Drupal instances, but you'll avoid all the issues with duplicate content showing up on the wrong domains. This is a huge win, and could be a much better solution for your multisite needs. However, you'll still run into all the "tightly coupled dependencies" issues that arise whenever you need to upgrade modules or Drupal core.

The biggest problem with this approach to multisite Drupal is that you can't share users and passwords between different Drupal instances. This is actually a nontrivial problem &mdash; you don't want to have different usernames and passwords across affiliated sites. Just imagine if you had a separate account for every stack exchange affiliate! There are several solutions to this problem, but they all involve various trade offs. I plan to discuss this issue more in a future post.

## Don't Do Multisite

This is my preferred solution. **Each domain that is (or could reasonably become) different should have it's own fully independent Drupal instance, code and data.** This approach means that you don't have to review every site after every change, and you won't have problems with content being indexed on the wrong domain. I would guess that for most organizations that want to use multiple domains or subdomains, they do want unique content on unique domains. (It's actually hard to imagine a situation where you'd want the *same* content on *different* domains).

You also avoid the tightly coupled code issues that arise for the separate settings.php file. The "downside" is that you'll have to upgrade each site individually. However, this is feature not a bug in my mind. As I mentioned before, I'd love to do *less* testing and manual QA for each code deployment. I don't mind spending a little extra time testing my changes in exchange for greater confidence that my changes won't break a totally different site.
