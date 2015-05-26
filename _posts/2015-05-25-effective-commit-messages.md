---
title: "Effective Commit Messages"
excerpt: "Knowing how to write and retrieve commit messages can make refactoring and debugging much easier. Here's my advice on using commit messages for maximum impact."
category: git
tags: debugging, documentation, git
layout: post
---

There are a variety of ways to include documentation in your project. I want to
focus on commit messages as a vital clue in debugging and refactoring your code.

Although I use git exclusively at this point, similar techniques will work for
mercurial (and svn to a lesser extent).

## Strengths of Commit Messages

The great thing about using git commit messages is that *they persist exactly the
same length of time as the code they describe*. This is a huge advantage compared
to comments in the source code. When that code changes or disappears, so do the
commit messages. Using commit messages as documentation ensures *always* up to date
documentation.

A commit has a timestamp and an author associated with it. Additionally, a commit
has a position in git history. For teams adopting Github (or similar services),
you can often look forward from a particular commit in git history to determine
which pull request and agile story this line of code came from. You can examine
adjacent commits for extra clues about related changes. If you get really confused
by a message, you know exactly who wrote that message and you can talk to that person
if they still work at your company.

In git and mercurial, a commit preserves a context, because it is simply a patch
of the previous commit. You can see all the other changes that happened at the
same time, which can help ask that elusive _why_ question: "Why was this code written?"
Often, simply reading through the other code written at the same time helps me
wrap understand a particular line of code.

You don't have to adopt any new software, database, or programming philosophy.
If you're using version control software already, this information is already there.
Whether or not you leverage all of this metadata is up to you.

## Comparison to Source Comments

The problem with comments is that they can remain in the codebase a long time
after the code they originally described is removed or altered. This means that
the context can be ambiguous. A related problem is that changes to the code are
not always accompanied with changes to the comments, leading to inaccurate or out
of date information.

The main strength of comments versus commit messages is that comments are visible
to readers of the source code.

In my opinion, comments are best for situations in which there is some hack that is
_really_ important to understand and preserve. Any time I include a hack in source
code because it seemed necessary, I leave a comment in the source code. Serious
gotchas also deserve to be included in the source code directly as  well.

However, like any code, comments themselves add a maintenance burden. I tend to
use commit messages anywhere I can.

## Retrieving a Commit Message

Commit messages are harder to find than comments. Let's look at how to find the
commit that a line of code belongs to.

### In Atom

<p><img src="/img/2015/atom-git-blame.png" style="max-width:100%; height:auto !important;"></p>

This screenshot shows using the [git-blame package](https://atom.io/packages/git-blame)
for Atom.

### In Eclipse

<p><img src="/img/2015/eclipse-git-blame.jpg" style="max-width:100%; height:auto !important;"></p>

This screenshot comes from [EclipseGit package](http://www.eclipse.org/egit/).

### In Sublime

<p><img src="/img/2015/sublime-git-blame.png" style="max-width:100%; height:auto !important;"></p>

This image comes from an [ancient forum post](http://www.sublimetext.com/forum/viewtopic.php?f=5&t=2172),
but it gives *some* idea of what to expect.

### In the Shell

<p><img alt="Animation showing git blame and git show together" src="/img/2015/git-blame-show.gif" style="max-width:100%; height:auto !important;"></p>

Use [`git blame`](http://git-scm.com/docs/git-blame), like this:

{% highlight bash %}
$ git blame -L22,25 src/model/resource.js
{% endhighlight %}

 * *-L* stands for lines, in this case lines 22 to 25
 * *src/model/resource.js* is the specific file you want to look into

This code displays the shortened commit hash next to the contents of those lines
from the file. Mercurial has a nearly identical command `hg blame`.  To
actually see the corresponding log message, use:

{% highlight bash %}
$ git show abcde12345
{% endhighlight %}

where `abcde12345` is the actual commit hash from git blame.

*If you know of a way to get the commit message from a specific file and line number in a single
command, please tell me in the comments!*

## Writing the Commit Message Title

If you use Github, you'll also see that Github will use the first 50 characters
of the first line of your commit message as a heading for that commit (the second
line needs to be blank):

<p><img alt="Heading on Github for commit" src="/img/2015/commit-first-line-heading.png" style="max-width:100%; height:auto !important;"></p>

...or as the title for a single commit PR:

<p><img alt="Pull Request title" src="/img/2015/github-first-line-pr-title.png" style="max-width:100%; height:auto !important;"></p>

If you use vim to edit your commit message, the first 50 characters are one color,
and anything beyond 50 will turn another color. Using that visual clue helps you communicate
the purpose of a commit to the rest of the team at a glance.

<p><img alt="VIm commit message visual clue" src="/img/2015/vim-first-line-visual-clue.png" style="max-width:100%; height:auto !important;"></p>

However, if you ignore this 50 character cutoff, commmit messages will be cut up
and difficult to read, like this:

<p><img src="/img/2015/git-commit-first-line-too-long.png" style="max-width:100%; height:auto !important;"></p>

### Categorizing the Commit

Another helpful convention I sometimes follow is starting the commit title with
the kind of change I'm making:

 * (fix) - no new feature, simply a fix for a bug in existing code
 * (feat) - new functionality introduced, possibly tests and documentation as well
 * (refactor) - reimplements internals
 * (doc) - updates to a README or comments
 * (test) - adding or fixing a test
 * (nit) - changes to whitespace, code style, or something else super trivial

## Helpful Commit Message Bodies

I like to use everything after the second line of a commit message to describe:

 * what problem each commit is addressing
 * what subtle gotchas are lurking beneath the surface
 * why I choose this implementation over another way of writing the code
 * the issue number for later cross-referencing

I often use [`git bisect`](http://git-scm.com/docs/git-bisect) to debug tricky but
reproducible errors, and I like to think of commit messages as clues to my future
self during a bug-hunt six months from now. But `git bisect` is a subject for another post.

### Example Commit Message Body

<blockquote>
  <p>change all app.user.getUploadedFilesData() to get files metadata to asynchronous operations</p>
</blockquote>

Not great -- why did we change to asynchronous operations? Also, this message is
too long for github. It will be seen in PR titles or commit summaries as
`change all app.user.getUploadedFilesData() to g...`. That tells me almost
nothing about what change happened or why! Let's see if we can improve things:

<blockquote>
  <p>retrieve user uploads from db for persistence</p>
</blockquote>

This explains, at a glance, _why_ this commit was made. Uploaded files are stored
in the database now, why? For better persistence. Okay, so that's really important,
and it provides me a lot more clues about the bug I'm trying to fix. But this
doesn't mention anything about asynchronous operations... how can we fit that onto
the first line?

We can't. But we can provide more in-depth discussion of the details of the changes
in lines 3 and later in the commit message. Let's take a look:

<blockquote>
  <p>retrieve user uploads from db for persistence</p>
  <p>Because this operation requires db access, all calls to app.user.getUploadedFilesData()
     are now asynchronous calls. We had to start using the database because all
     metadata (like filesize) was lost each time we restart the app.</p>
</blockquote>

Better, but why didn't the author just grab this info from the file system? Let's
try one more improvement:

<blockquote>
  <p>(feat) retrieve user uploads from db for persistence</p>
  <p>Because this operation requires db access, all calls to app.user.getUploadedFilesData()
     are now asynchronous calls. We had to start using the database because all
     metadata (like filesize) was lost each time we restart the app.</p>
  <p>Since we use clusters of machines, not all machines in the cluster have all
     files all the time. We use the database so that whichever machine in the
     cluster handles the request can access the file data.</p>
</blockquote>

Perfect! We have a one line summary in github, we have a detailed explanation of
why app.user.getUploadedFilesData() is now async, and we know why some easier
option wasn't used. There's probably still plenty of room for improvement, but
this is a great foundation.

### Example Trivial Commit Message

Not all commits need extended explanations. Let's look an example for a
change that's relatively trivial:

<blockquote>
  <p>fix colors</p>
</blockquote>

That gives us some idea of what's happening, but it doesn't answer the _why_
question. Let's see if we can improve this message a bit:

<blockquote>
  <p>matched header color to brand guide</p>
</blockquote>

Much better! Now we can tell at a glance _why_ this change was made and which
kinds of colors were changed. But we still don't know where to find more info
in our issue tracker. Let's make another change:

<blockquote>
  <p>(nit) matched header color to brand guide [203]</p>
</blockquote>

This is a great message. We can go to issue 203 if we ever need to learn more
about who wanted this work done, or why this shade of green was chosen instead
of the actual shade specified in the brand guide.

## Summary

Commit messages *can* be a superior form of documentation for a team that adopts
them. There's nothing new or extra you need to do to take advantage of source
control history today, but there's a lot of advantages to carefully describing
the work you do in your commit messages.

_**Special Thanks to [Rex Vokey](http://www.internetsimplicity.net/) for suggesting more images,
[Jeff Ballard](https://www.linkedin.com/in/jeffballardfuzzywaffles) for broadening my horizons,
[Blain Sadler](https://twitter.com/blainsadler) for support,
[Matt McClure](https://twitter.com/matt_mcclure) for the inspiration,
and my stunning wife [Emilie](https://www.linkedin.com/pub/emilie-fisher-fleig/89/499/331) for providing
extensive feedback on this article.**_
