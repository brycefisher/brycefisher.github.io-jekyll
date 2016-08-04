---
title: "A Quick Intro to the NERDTree plugin for Vim"
layout: "post"
excerpt: "A concentrated summary of quirks and undocumented config options for the de facto file explorer, NERDTree, in Vim"
category: vim
tags:
- plugin
- nerdtree
---

NERDTree seems to be the _de facto_ file explorer for Vim, but it's hard to find a good introduction to its quirks and some basic configurations without duckduckgo'ing tons of blog posts and reverse engineering individual `.vimrc`s. This post tries to compile all the things I learned over several hours into an easily digestable summary.

## Show Hidden Files

By default, NERDTree hides dot files. For many developers, this is a frustrating default setting that makes it hard to open and edit .gitignore, .travis.yml, and other really important dotfiles. I couldn't find any documentation about how to change the default in my `.vimrc`, but here's how to do it:

```
" .vimrc
let NERDTreeShowHidden=1
```

## Filter Out Custom Files and Directories

The syntax is a little weird, so let's look at an example and then break it down:

```
" .vimrc
let NERDTreeIgnore=['.git$[[dir]]', '.swp']
```

 * Use the variable `NERDTreeIgnore` to configure the filters
 * Specify an array of patterns to ignore, using `[` and `]` to bookend the list of comma delimited patterns
 * Files should be specified as string literals (ex: `'.swp'`)
 * Directories should be specified as string literals with the magic suffix `$[[dir]]`
 
I'm guessing that glob patterns are also supported, but I haven't experimented with that yet. Open a PR on this article if you have experience with globs!

## Update NERDTree's View of Files

**TL;DR**

 * Click on the NERDTree buffer
 * Press `R` or `r`

**Full story** For performance reasons, NERDTree caches its view of the file system. This means that if you add, rename, move, or delete a file outside NERDTree, you won't be able to see that change reflected.

## Adding, Renaming, Moving, and Deleting Files and Directories

 * Click on the NERDTree buffer
 * Press `m`
 * Pick the option you want

## Conclusion

This is all super basic NERDTree stuff, but I couldn't find a good summary elsewhere. What are you advanced tricks to get the most of NERDTree?
