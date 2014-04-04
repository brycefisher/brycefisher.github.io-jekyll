---
title: A Super Handy Translation Checklist
layout: "post"
excerpt: "I've put together a checklist of some DO's and DON'Ts that I've learned that help me review someone else's code or even my own code before forking over the big bucks to a translation company."
category: planet_drupal
---

I've been bitten time after time during (what I wrongly assumed) would be the last phase of a project because of translation issues. So, I've put together a checklist of some DO's and DON'Ts that I've learned that help me review someone else's code or even my own code before forking over the big bucks to a translation company.

This checklist will be most helpful if you use Drupal as your CMS, and you send your translation vendor XLIFF and POT files. Also, this checklist assumes you have i18n already setup on your Drupal instance, and you're looking to deploy a new feature or set of content. Enjoy!

## Drupal/PHP

<ol>
<li> Proper use of t()
 <ol>
 <li>All text wrapped in t()</li>
 <li>All t() strings contain a coherent thought for translators to work with
  <ul>
  <li>rule of thumb, make sure each t() is fed at least 3 words</li>
  <li>No t() invocations wrapped within another t()</li>
  <li>Include FontAwesome or other image font tags into t() where it is a semantic part of the text content. (For instance, in Korean, it might be correct to place the glyph in the middle of a string, or at the beginning, whereas in English it must come last)</li>
  </ul>
 </li>
 <li>Avoid line breaks in t()
  <ul>
  <li>All text must flow naturally. Line breaking is something you must let go of (embrace the Zen)</li>
  </ul>
 </li>
 </ol>
</li>
<li>All links to localized content will localize (ex: lookup the nid of node translations and use url() or l() )</li>
<li>For multibyte text that needs to be used by JS, render text inside tags with explicit IDs</li>
<li>All public facing pages are attached to nodes (ajax urls are an exception)</li>
<li>No public facing pages use hook_menu</li>
</ol>

## JS

 1. Avoid language specific paths in Ajax requests wherever possible
 2. Avoid passing strings around in JS when working with multibyte strings (Asian characters)
 3. Do use JS polyfills to support CSS powered buttons, etc in old browsers (progressive enhancement)

## CSS

 1. All elements containing visible text can expand 2X vertically (or horizontally) without breaking the layout
 2. Background images on all expandable boxes gracefully stretch or contract (good use of `background-size` or gradients)
 3. No side-by-side floated divs suddenly wrap to next line (unexpectedly) when content grows or shrinks
 4. Avoid narrow columns (less than 300px) as much as possible
 5. No textual string content inside pseudo-element `content` rules -- use t() instead
 6. Use HTC polyfills (css3pie, etc) if your project requires you to support old versions of IE

## IMGs

 1. Check that NO images referenced in HTML have text
 2. Checked that NO background images referenced in CSS contain text
 3. Avoid image based buttons (use CSS instead wherever possible)
 4. Avoid image based gradients (use CSS wherever possible)

## Architecture

 1. All public facing pages are use nodes to exploit url aliases (except for ajax urls)
 2. No public facing pages use hook_menu

## Communication

 1. Prepared a list of nodes that need aliases and (re)translation for translation team
 2. Prepared a list of tokens (ex: !token, @token, %token) that must NOT be translated to give to translation team
 3. Prepared a list of other quirks that the translation team needs to know about
 4. Prepared some "next steps" for the translation team once they've finished 
