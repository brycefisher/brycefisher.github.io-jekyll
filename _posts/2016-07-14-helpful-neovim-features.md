---
title: "Helpful Neovim Features"
layout: "post"
excerpt: "I've been using vim and now neovim for several years, but I've never felt like I was taking full advantage of even the basic feature set. Here's my attempt to learn and record some really useful features of (neo)vim that I should have picked up ages ago."
category: vim
---

For longtime (Neo)Vim enthusiasts, nothing here will blow your mind. However, if you've always felt like there are more builtin features of vim you're missing out on, here's a handful of useful features I'd overlooked for years which don't require any plugins.

## Neovim's Builtin Terminal Emulator

This is probably the most killer built-in upgrade that Neovim offers over standard Vim. Basically, Neovim exposes a new "terminal" mode that forwards all your keystrokes to an underlying terminal (which is handled by a cross-platform terminal emulator library).

### Starting Terminal Mode in the Current Buffer

```sh
:terminal
```

And then type anything that will put you into insert mode (`a`, `o`, `i` etc).

### Start Terminal Mode in a New Buffer

If you'd rather split the current buffer and start a terminal in that, type this:

```sh
:sp term://bash
```

Then click or `<C-W>h` into the new terminal buffer and use insert mode.

### Exiting Terminal Mode

```sh
<C-\><C-n>
```

Personally, I find that a bit too cumbersome, so I'm definitely going to remap that to something else.

### Learn More about Terminal Mode

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
