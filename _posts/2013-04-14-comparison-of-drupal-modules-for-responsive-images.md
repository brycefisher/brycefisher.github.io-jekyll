---
title: "Comparison of Drupal Modules for Responsive Images"
layout: "post"
excerpt: "A table that walks through the features of several Drupal modules for creating responsive images."
---
Drupal has a whole host of modules that are designed to make it easier for Drupal themers and site builders to create responsive images. In other words, these Drupal modules aim to make mobile browsers download smaller images (and load more quickly) while still serving up full sized images to laptops. The feature chart below is based on descriptions from the drupal responsive image module pages, and my own investigations. **All modules are Drupal 7, unless otherwise noted.**

## Responsive Image Features Explanation

* **Module Name** - links to the module's project page on Drupal.org.
* **Fallback?** - What happens when JavaScript is disabled on the browser?
* **Affects Image Types** - Descibes how images must be stored and retrieved from Drupal for this module to work on them. Does this module work on inline image tags, only image fields, or other types of images?
* **3rd Party Libraries** - Does this module require you to download and install code outside of Drupal.org?
* **Ease of Installation** - "Easy" means simply turn on the module and possibly configure a few settings.
* **Integrates with** - Lists key modules that tie into this module.
* **Maintenance Concerns** - Issues to think about after initial setup of the module.
* **Reported Installs** - How many sites report using this module accoding Drupal.org project page.

## Comparison of Features

<table>
  <thead>
    <tr>
       <th>Module Name</th>
       <th title="What happens when JavaScript is disabled">Fallback?</th>
       <th title="Can this module make img tags inside responsive in node bodies? Or, only image fields?">Affects Image Types</th>
       <th title="Denotes any non-Drupal code that is required to run this module">3rd Party Libraries</th>
       <th>Ease of Installation</th>
       <th title="Other Modules that this module is intended to work with">Integrates with</th>
       <th>Maintenance Concerns</th>
       <th title="Number of sites that report using this module on Drupal.org at time of writing">Reported Installs</th>
    </tr>
  </thead>
  <tbody>
  <tr>
    <td><a href="http://drupal.org/project/adaptive_image">Adaptive Image</a></td>
    <td>??</td>
    <td>Fields only</td>
    <td>None</td>
    <td>Easy</td>
    <td>Image Styles</td>
    <td>None</td>
   <td>4000ish</td>
  </tr>

  <tr>
    <td><a href="http://drupal.org/project/cs_adaptive_image">Client Side Adaptive Image</a></td>
    <td>noscript tag sets a fallback image</td>
    <td>Fields only</td>
    <td>None</td>
    <td>Easy</td>
    <td>Image Field</td>
    <td>None</td>
    <td>1500</td>
  </tr>

  <tr>
    <td><a href="http://drupal.org/project/ais">Adaptive Image Styles</a></td>
    <td>Original image</td>
    <td>Fields, and Inline Img tags</td>
    <td>None</td>
    <td>Hard</td>
    <td>Image Styles, Media, WYSIWYG</td>
    <td>Patching .htaccess module after drupal core updates!</td>
    <td>1700</td>
  </tr>

  <tr>
    <td><a href="http://drupal.org/project/resp_img">Responsive Images</a></td>
    <td>??</td>
    <td>Fields only</td>
    <td><a href="https://github.com/filamentgroup/Responsive-Images/tree/cookie-driven">Responsive Image library</a></td>
    <td>Moderate</td>
    <td>Image Styles</td>
    <td><strong>NOT ACTIVELY MAINTAINED</strong></td>
    <td>106</td>
  </tr>

  <tr>
    <td><a href="http://drupal.org/project/resp_img">Responsive Images and Styles</a></td>
    <td>CSS Based / JS independent</td>
    <td>Fields, Blocks, Entities textfields, Inline img tags, and more</td>
    <td>None</td>
    <td>Easy to Moderate</td>
    <td>Image Styles, Context, Media, Picture, field_slideshow, colorbox, expire</td>
    <td>Will be part of D8 Core, but breaks on Drupal 7.20+ without some TLC (see project page)</td>
    <td>1811</td>
  </tr>
</tbody>
</table>

## Concluding thoughts on Responsive Images and Drupal

Given the set of features and integration with Drupal 8, I highly recommend going with the Responsive Images and Styles module listed above. It appears that it can do everything the other modules do and more, plus it's not much harder to configure (depending on if you use the Media module). However, if you want something simple with a larger set of users, Adapative Image would be my second choice. 

I would absolutely avoid Adaptive Image Styles given the hassle of potentially fixing the htaccess file every time you update Drupal core. I would also avoid the Responsive Images module since it is no longer maintained. 