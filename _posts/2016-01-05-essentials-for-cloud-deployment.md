---
title: "Essentials for Cloud Deployment"
excerpt: "A good deployment pipeline can make your team much more productive and nimble. Here's my sage advice on the most crucial overlooked features of a deployment pipeline."
category: deployment
tags: devops, deployment, cloud, aws
layout: post
---

The most critical thing a deployment pipeline can do is instill confidence in your team. Build your pipeline on a bedrock of credible integration tests. Produce those results in an expedient manner, and deliver your software to customers immediately. When your developers believe in their deployment pipeline system, they can achieve great things.

## Credible Integration Tests

Unit tests are not worth very much. Only tests which walk through the exact scenarios your customers will actually use on their actual data in your network can tell you if you've done your work correctly.

In a prior life, my team developed an axiom:

> Master is always deployable

This rule led us inexorably to the following rule:

> Only tested code can be merged to master

But to satisfy this condition, arbitrary branches must be deployable to a "real" environment. Most often, production incidents occurred because our "real" environments were not real enough. For instance, I once personally wrote a feature to validate account data before saving it to the database. However, old customer accounts were "invalid" according to my feature, and we received many complaints from customers unable to login days later.

How could this happen? I had written unit tests, integration tests, test fixtures, code review, and manually QA'd the work in a remote environment. The problem was that I had not tested using the production database. I could tell many similar stories of trying to migrate logs files to new block devices, "optimizing" database queries, or adding load balancers and breaking deployments.

The point is your tests can't save you from catastrophic disasters if you can't 100% trust them.

### 100% Trusting Your Tests

Here's a(n incomplete) list of things that are prerequisites for trusting your integration tests:

 * Remote servers
 * Production traffic
 * Real data
 * Real network topology
 * Happy and sad path testing
 * "Production" mode

#### Remote Servers + Real Network Topology

Docker is the best way to guarrantee the local environment for your application is identical between development and production (and you should use it). However, docker can't guarrantee your DNS is configured correctly or that the VPN connection works properly. It can't guarrantee your changes won't bork the service orchestration nor service discovery, nor any of a thousand other things that _just couldn't matter_ but somehow do.

At least in AWS, different instance types can have radically different features. For example, an m3.medium will only run in a virtual private cloud which requires some serious networking knowledge, whereas a m1.medium works just fine in the stupidly-easy public cloud. A spot instance can disappear at any time or fail to launch if the spot price suddenly spikes, whereas an on-demand instance is guarranteed to boot up and stick around as long as you want it. These are just a few obvious differences. Make sure you use the same instance types to run tests against your feature branches and bug fixes that your production stack uses.

#### Production Traffic + Real Data

Honestly, real data is most important with NoSQL databases where documents can be anything. If you're using Postgres with a Rails App, this may be less important.

Duplicating production traffic is hard, but the kind of confidence it can give is unparallelled. You can instrument optimizations (especially around your database or cache) and _know_ it will make your existing infrastructure more scalable without ending your startup. There's just no other way to get those guarrantees.

#### Happy + Sad Path Testing

Testing failure scenarios is hard and counterintuitive. Which is why it causes so many production incidents. If there is a value to writing unit tests, I would say that seeing code coverage visually present all the code paths we missed is the highest one. Some testing frameworks (like rspec on its own) can make it feel hard to test lots of failure scenarios. 

However, I've personally found that cucumber really makes it easy to create tons of integration tests. The `examples` and tables make it easy to add subtly different versions of the same test. The step definitions decouple specific tests from reusable code blocks in a super elegant fashion. Those and a million other things, make cucumber my new goto tool for less-painful integration testing.

#### "Production" Mode

This is just wrong:

{% highlight js %}
if (environment == "production") {
  // Something untestable that will haunt your dreams
} else {
  // A sirensong luring you into false security
}
{% endhighlight %}

Look, nothing interesting or important should **ever** happen in production that you haven't properly tested before. If you hardcode specific environment detection, you by definition can't test something interesting. This leads to surprising and harmful situations.

Where should this kind of setting go? Anywhere else:

 * Environment Variables
 * Config file
 * Database
 * Cloud-config user-data

I've seen several great examples of a `config` abstraction which can be queried for environment specific variables. So, something like this instead:

{% highlight js %}
var databasePassword = config.get('databasePassword');
{% endhighlight %}

This code snippet is better than the conditional above because it guarrantees similarity between your local machine, your remote test environment, and your production server.

## Only Fast Tests

If your integration tests take more than time than it takes to walk to the water cooler and back, your developers are going stop working and drift to hacker news for the next hour. Wait? What was I working on again...

Every integration test scenario should be able to run in any order so that you can parallelize the shit out of your tests. Write a lot of tests, but run them all at once across multiple machines/containers/vms/whatever. Don't settle for anything less than awesomely fast.

The secret to keeping your tests fast is to chip away at each subsequent bottleneck every sprint.

## Deliver Immediately

Why does it take so long to deploy changes as your cluster gets bigger and bigger? Because you're rolling instances onesy-twosy. Rotating instances individually is slow and error prone. What happens if you get halfway through a deployment and one instance never comes back online? [Gulp.]

There is a right answer here. Bring up all new nodes at once while the old nodes are still running. The new instances will come online at basically the same time. When they do, split production between old and new nodes until your smoke tests pass. Then, drop the all the old instances at once. If some of your new nodes don't come online or fail smoke tests, just abort the automated deployment and then manually back off production traffic. Your old nodes will still be humming along in the background.

This will take you from an O(n) deployment speed to a O(1) deployment speed.

### Deployment Pipelines as Emergency Preparedness

Mistakes happen. Apps break. We can't ever totally eradicate it, but having a fast deployment pipeline means that we can respond more quickly and minimize disruptions to our customers. Moreever, we can delight by spending more time developing fixes and features and less time waiting around.

## Inspiring Deployment

Any time something "just works," it's truly a thing of beauty. If you're a web developer, you need a fast reliable way to get your work into your customers hands. 

Tell me your secrets for getting more out of your deployment pipeline, or tell me why I'm wrong above.
