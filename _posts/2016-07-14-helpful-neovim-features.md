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

I found myself perpetually confused by the key notation I'd see everywhere online and in the builtin docs. Finally, I determined to search until I found an explanation. Here's a [semi-official wikia entry](http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_2)#Key_notation) which does a great job of explaining. Here's the major takeaways:

 * `<C-...>` means CTRL and ... at the same time. Ex: `<C-k>` = CTRL+k
 * `<S-...>` means Shift and ... at the same time.
 * `<A-...>` means Alt and ... at the same time.
 * `<BS>` is backspace (not profanity...silly I know).
 * `<F1>` is the F1 key. No shocker there, just mentioning it in case you can't easily access your function keys.
 * `<ENTER>` is the enter key.

Additionally, you can always escape a single key stroke in insert or normal mode (and possibly other modes too) by pressing CTRL-V first. For example, CTRL-V and ENTER becomes  which is the same as `<ENTER>` but a lot fewer keystrokes.

## Ctags & Tags

_TODO_

## Vim's Visual Blockwise Edit

Seriously...how did I not know about this? How?! Basically, you can _visually_ select a rectangular region of the current buffer and make the same change to all of them simultaneously. This is a really fast way to change a list of items that start with a single quote into a list of items that start with double quotes, or other tedious tasks which are difficult to change by using regex. Here's a quick example of visual blockwise edit in action:

![Visual blockwise edit in vim](/img/2016/vim-blockwise-edit.gif)

In that gif, I pressed `CTRL-V` (sorry, using the mouse doesn't work by default) in insert mode to start visually selecting. Next I pressed `l` three times. Then I pressed `j` repeatedly to select down several rows. Instead of the selection wrapping around the end of the current line, a "block" of text is selected straight down. Any operator will be previewed on the first line but applied to all lines of the block selection. I pressed `x` to delete the entire selection.

Another idea that you might try is changing the whole selection with `c` followed by `ESC` after your changes.

## Search and Replace Within a Selection

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

A "jump" can be triggered by using `/`, `}`, `]]` and other forms of movement. See `:help jumps`.
