---
title: "Securing SSH with Multiple Keys"
layout: "post"
exceprt: "It's a great idea to use specific ssh-key key pairs per service (or per repository even). Even if your keys are compromised, they don't allow your attacker to access any other services. Unfortunately, these services often assume you'll use the default key pair (id_rsa)."
---
It's a great idea to use specific ssh-key key pairs per service (or per repository even). Even if your keys are compromised, they don't allow your attacker to access any other services. Unfortunately, these services often assume you'll use the default key pair (id_rsa).


## 1. Get Organized

I like to make folders inside ~/.ssh for each service (Github, AWS, BitBucket,
DigitalOcean, etc), and place various keypairs. EX:

<div class="highlight"><pre><code>
~/.ssh/
  | - id_rsa
  | - id_rsa.pub
  |
  | - github/
  |   | - workuser
  |   | - workuser.pub
  |   | - other
  |   | - other.pub
  |
  | - bitbucket/
      | - personaluser
      | - personaluser.pub

</code></pre></div>


To actually create the key pairs, use `ssh-keygen` in the terminal.


## 2. Upload your public key

All of these services have a settings page for adding SSH public keys. Add yours, and also include a descriptive label if you can. Usually, I describe which computer this public key came from so that I can revoke with confidence later on, if necessary.

## 3. Find the Git Push endpoint

For bitbucket and github, the endpoint is typically in this format:

`git@github.com:brycefisher/defaulterrors.git`

Let's break that down:

 * _git_ -- everything before '@' is the username for SSH
 * _github.com_ -- the actual hostname
 * _brycefisher/defaulterrors.git_ -- path to the git repository

## 4. Config all the things!

Open up ~/.ssh/config in your favorite text editor. At the end add a new entry (separated by a new line above):

{% highlight bash %}
Host github
    Hostname github.com
    User git
    IdentityFile ~/.ssh/github/brycefisher
{% endhighlight %}

Choose whatever you want for `Host` -- that's an alias you can use in ssh. Notice how all the pieces from 3. above mapped to this new entry in ~/.ssh/config. In particular, we used everything except the path to the git repo.

## 5. Add a git remote

Under the hood, git is using SSH, and it can access the alias we created earlier (github) to reach github. Our git remote will have to know the SSH alias and the path to the git repo.

{% highlight bash %}
$ git remote add origin deferr:brycefisherfleig/defaulterrors.git
{% endhighlight %}

## 6. Make Sure it Works

{% highlight bash %}
$ git push -u origin master
{% endhighlight %}

If the above command succeeds, you'll see something like this:

{% highlight bash %}
Counting objects: 3, done.
Writing objects: 100% (3/3), 262 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To github:brycefisherfleig/defaulterrors.git
{% endhighlight %}

If instead you see:

{% highlight bash %}
Permission denied (publickey).
fatal: Could not read from remote repository.
Please make sure you have the correct access rights
and the repository exists.
{% endhighlight %}

Then re-check the steps above.
