---
title: "Helpful Neovim Features"
layout: "post"
excerpt: "I've been using vim and now neovim for several years, but I've never felt like I was taking full advantage of even the basic feature set. Here's my attempt to learn and record some really useful features of (neo)vim that I should have picked ages ago."
category: vim
---

## Neovim's Builtin Terminal Emulator

[Official Docs](https://neovim.io/doc/user/nvim_terminal_emulator.html)

## Deciphering Vim's Key Notation

[Semi-official Wikia Entry](http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_2)#Key_notation)

## Vim's Ctags, Tags

_TODO_

## Neovim's Visual Mode

 * Block edit (_TODO_ -- find the correct name)
 * Search & replace within a selection:
   * Use the cursor to select (or press `v` and use motion commands) to select a block of text
   * Press `:`. You should the statusline show `:'<,'>` which simply means the selection
   * Type `:s/old/new/g` and press `<ENTER>`

## Vim's Ways of Moving

 * Go to line (normal mode). Type the line number then capital G. Ex: `200G`
 * Ignore case for only one search. Add `\c` to the end (for "case"). Ex: `/FOOBAR\c`
 * Jump a paragraph forward `}`
 * Jump a section forward `]]`
 * Jump back to a previous jump - `CTRL-O`
 * Jump forward to a previous jump - `CTRL-I`
