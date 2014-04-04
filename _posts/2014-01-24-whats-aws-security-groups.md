---
title: "What's Up With AWS Security Groups?"
layout: "post"
excerpt: "If you're trying to setup Drupal or another application on Amazon Web Services, aka AWS, you'll need to do quite a bit of setup, and you'll need to learn a whole new vocabulary of platform-specific terminology. This post will focus on one AWS-specific term: Security Groups"
category: AWS
---
If you're trying to setup Drupal or another application on [Amazon Web Services, aka **AWS**](http://aws.amazon.com), you'll need to do quite a bit of setup, and you'll need to learn a whole new vocabulary of AWS-specific terminology. This post will focus on one of those terms: **Security Groups**

## Wrapping Your Head Around EC2

You must have one or more security groups associated with your Elastic Cloud Compute (EC2) instance. If you're as clueless as me, you'll be happy to learn that an EC2 instance is the raw computing power necessary to run dynamic code (such as Drupal, WordPress, Ruby on Rails, GWT, or whatever technology you married in your wild and reckless youth). Without an EC2 instance, you can't do anything interactive at all. As a metaphor back to conventional hardware hosting, I like to think of an EC2 instance as roughly equivalent to a single server.

So, if you're reading this post you probably want to upload some code into the cloud and just get it to run. So, what is a "Security Group" and why does AWS force you to configure it before anything fun happens?

## So WTF Is a Security Group Anyway?

Essentially, an AWS **security group** is a [firewall](https://en.wikipedia.org/wiki/Firewall_%28computing%29) that [whitelists](https://en.wikipedia.org/wiki/Whitelist) access to any number of EC2 instances. The security group is a bouncer that keeps the riff-raff out of a VIP club &mdash; if you&apos;re not on the list, you don&apos;t get into the club. According to the [official AWS documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html), 

> Security group rules are always permissive; you can't create rules that deny access.

Thus, you must allow some points of access to the EC2 instance, otherwise you couldn't upload your code. Furthermore, no one could even visit your site! 

### Why Do You Have To Use Security Groups?

This seems so round about... you've never done this before on HostGator, RackSpace, MediaTemple, or any of the other usual hosting providers you're familiar with.

Arguably, this is a hard thing for first time users to wrap their heads around, but this forces you to think about security before you've written a single line of code. Also, this gives you, the glorious DevOps engineer, the power to allow or deny access to your instance in any way you choose. Imagine, you're building the world's most amazing new web app, and you need to be able to summon a host of computers to handle billions of requests per second from your desperate customers. Probably most of your EC2 instances will handle things completely behind the scenes, without any interaction over HTTP.  This is exactly how services like Dropbox and Zencoder work. You'd probably setup customized channels of communication that make sense for your code. AWS gives you this power.

## How does a Security Group Work?

Each Security group is composed of a number of rules that combine direction (inbound traffic TO the server or outbound traffic back OUT to the internet), a protocol (TCP, UDP, ICMP), a range of ports, and an IP address range using the CIDR format (see [my guide to subnet masks](http://bryceadamfisher.com/blog/missing-guide-subnet-masks)).

### Okay, I get it. Let's Do This!

At time of writing (Jan 2014), [the documentation on this point is actually pretty good](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html) with lots of examples. I highly recommend reading through if you've followed with me so far and want to give it a whirl.

## Just the Beginning

There's a whole lot more to cover, and I plan to write more articles explaining basic AWS concepts as I learn them. If you've made it this deep into AWS, my post should be enough to push you in the right direction and help clear up some confusion. Let me know what you've learned about Security Groups or other tips n' tricks you've learned for getting started with AWS.

