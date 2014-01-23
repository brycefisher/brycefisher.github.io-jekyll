---
title: "Best Practices for Translation in Drupal"
layout: "post"
excerpt: "I'm sharing lessons learned from my experience using Drupal 6 and i18n for translation. The long story short: Make translation easier by keeping things simple. Don't use the t() when you can keep translatable strings fully in the database, and don't break up individual strings into multiple t()."
category: planet_drupal
---
One of the biggest reasons my company decided to use Drupal for their [marketing website](http://www.brightcove.com/) is the capacity to translate and "localize" content. Drupal has a series of APIs going back at least to Drupal 4.6 that make it possible to have different paths for various pieces content. Drupal also has the ability to import and export translations of strings stored in code as well as content stored in nodes, taxonomy terms, and more. Most translation vendors can accommodate the exported content into their software and ship back a "localized" version of that content.

Recently, as I've been involved in this process, I've discovered several pitfalls and how best to avoid them. I'll be focusing this post on Drupal 6 since that's what I use most often, but I'll also try to mention some things about Drupal 7 as we go. I won't tell you [how to get started localizing your website](https://drupal.org/node/275705) -- that's a whole book in and of itself. These are more guidelines for how to minimize friction between themers, site builders, and translators.

## Block Level Elements and the t() function

The [t() function](https://api.drupal.org/api/drupal/includes!common.inc/function/t/6) takes English strings that are used in PHP and exposes them to Drupal for translation. Drupal takes care of the hard part of figuring out which language to display on the current page, but Drupal won't know to translate your string unless you've first wrapped it in the t(). The [API documentation for t()]((https://api.drupal.org/api/drupal/includes!common.inc/function/t/6) has lots of great examples of correct and incorrect usage of t(). The bottom line is inline elements should go inside t() and block level elements outside.

    <!-- Correct! -->
    <p><?php print t('Your new <strong>BFF</strong> in web development'); ?></p>
    <!-- Incorrect -->
    <?php print t('<p>Your new <strong>BFF</strong> in web development</p>'); ?>

Notice that paragraph tags are block level elements in CSS, and therefore should not be included in t(). However, inline elements like `a`, `strong`, `em`, and `br` should definitely go inside t().

NOTE: There's lots of ways to get translation strings out of Drupal and expose English text for translation inside Drupal. You only need to use `t()` for English text inside PHP code. You don't need it inside nodes (for instance). More on this later.

## Escaping Values Inside t()

Often times, you'll want to pass a value that shouldn't be translated into `t()`, such as a URL, the number of users currently signed in, etc. However, it's **really, really important NOT to get fancy**. Each use of `t()` creates a separate string for a translator to figure out. You'll often have to make judgment calls about how to break up the strings into meaningful bits. Always, step back and ask yourself, "What does the translator need to see to understand this text the way the use will see it?" 

### Example 1: Don't Use Unnecessary Plurals

Again here's some examples:

    <!-- Correct -->
   <?php print t('Providing <strong>!visitors+</strong> visitors with outrageously awesome Drupal advice', array('!visitors' => $num_visitors)); ?>

   <!-- Yikes! Confusing -->
   <?php print t('Providing !visitors with outrageously awesome Drupal advice', array('!visitors' => format_plural($num_visitors, '1 visitor', '@count visitors'))); ?>

Let's unpack that a bit. You can tell `t()` to insert variables into your strings using a special escape syntax. Use ! or @ or % to tell Drupal where to insert your variable. Then pass `t()` an array of values. So, the above examples are just inserting the value of `$num_visitors` into each string above.

Technically speaking, the above "confusing" example is not wrong. However, the translator won't see the plural translation strings ('1 visitor' and '@count visitors') strings alongside of the main string. The first string is better because it keeps the whole sentence in one single string that the translator can figure out much more easily.

There may be situations where you could one or multiple numbers inside `t()` variables. It's perfectly appropriate to use the `format_plural` function in those situations, but you may want to give your translation vendor a heads up about that string. I've seen translators consistently unable to figure out this sort of problem &mdash; and I don't blame them. It's our responsibility to make sure translators eceive content they can understand. Going the extra for your translators will save you time and money by not having to send back strings for re-translation over and over again. 

### Example 2: Don't Use Abstraction

I've seen some programmers try to separate repeated strings into different `t()` invokations. Let's look at an example HTML output in English:

    <!-- This how the final HTML should look in English -->
    <ul>
        <li>BryceAdamFisher - Astounding Drupal Insights</li>
        <li>BryceAdamFisher - Jaw Dropping Coding Skillz</li>
        <li>BryceAdamFisher - Oh, snap! He did it again</li>
    </li>

We're working in PHP and we see a pattern, so why not DRY up the code a little bit? So, trying to use "abstraction" on these strings turns into this PHP code:

    <!-- Do NOT do this at home, kids! -->
    <ul>
        <li><?php print t('BryceAdamFisher - !description', array('!description' => t('Astounding Drupal Insights'))); ?></li>
        <li>BryceAdamFisher - !description', array('!description' => t('Jaw Dropping Coding Skillz'))); ?></li>
        <li>BryceAdamFisher - !description', array('!description' => t('Oh, snap! He did it again'))); ?></li>
    </li>

This is an antipattern because the translator might need to reorder these strings, or they might translate the text different having known the strings appear next to each other. Here's an example of how that might need to appear in Japanese:

    <!-- Thank you google translate! -->
    <ul>
        <li>驚異Drupalの洞察 - BryceAdamFisher</li>
        <li>顎落としたりするスキルコーディング - BryceAdamFisher</li>
        <li>ああ、スナップ！彼は再びそれをやった - BryceAdamFisher</li>
    </li>

If you break the string into pieces, translators won't be able to see that the strings belong together and you'll have wasted your money on the translation effort. **Always keep strings together for the translator just like you would for the end user**. I promise you the translators will be thoroughly confused if you try to separate the repeated strings. Let the experst make the call on whether or not a given phrase should be translated the same way in different contexts. Just keep the strings together, as much as possible so the translators can have at least full sentence context, like so:

    <!-- This is the right way -->
    <ul>
        <li><?php print t('BryceAdamFisher - Astounding Drupal Insights'); ?></li>
        <li><?php print t('BryceAdamFisher - Jaw Dropping Coding Skillz'); ?></li>
        <li><?php print t('BryceAdamFisher - Oh, snap! He did it again'); ?></li>
    </li>

## Preparing to Export Strings from `t()`

If you do use escaped values inside `t()`, you'll need to notify the translators that words starting with ! @ or % need to left as is because they will be replaced by strings automatically inside Drupal. Each time you start translating fresh content, it might be wise to notify your vendor just in case they've forgotten or changed some settings in their translation software.

I'd also highly recommend grooming through your templates for fancy usage of `t()` that could be simplified or made clearer. Doing so will save you time and money, and make the whole process smoother.

## Other Ways to Make Strings Translatable

In Drupal 6, using the the [i18n module](https://drupal.org/project/i18n) and related modules allows you to translate blocks, taxonomy terms, node titles, node url aliases (which is awesome!), and node body fields. However, there's no good way to translate custom CCK fields. Menus are easier to simply create multiple versions of that are only visible for a specific language. 

In Drupal 7, you can also leverage the [entity translation module](https://drupal.org/project/entity_translation) to translate custom fields.

## Content Lifecycle

One final best practice I want to make special note of is **never manually edit translation files**. Your project manager wants to ship code (and so do you!) but if you playing God with your Korean text, bad things will happen. Never never ever edit the import or export files directly. These files are designed to be used in conjunction with automatic processes so you don't have to mess with translation. That's also why you're paying good money to language experts. So why would you screw it up at the last minute? Do your due diligence to prepare your templates by properly using the `t()` in clear, unambiguous ways, and stay out of the import/export files. You'll thank yourself.
