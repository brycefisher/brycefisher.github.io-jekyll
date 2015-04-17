---
title: "Setting up Istanbul with Jasmine on NodeJS"
layout: "post"
excerpt: "Istanbul is perhaps the best test coverage tool for NodeJS, but it's tough to figure out how to get started. This post explains how to get it setup."
category: js
tags: nodejs,testing,istanbul,jasmine
---
Istanbul is perhaps the best test coverage tool for NodeJS. Istanbul's metrics include lines of code, functions, and branches; and it generates reports that color each line to indicate full, partial, or no coverage. I also love that the reports break down test coverage per directory and file, which I use to identify blind spots.

While Istanbul can work with any testing framework, I focus on NodeJS and Jasmine, but much of the background information is relevant for other configurations.

## How Istanbul Works

Istanbul is **not** a static code analysis tool, but rather it observes running code. It works in two distinct steps which are important to understand:

 * Instrument the code
 * Run the tests against the new code

### Instrument the Code

By "instrument", we mean create a functioning mock of the source code, while still invoking the real implementation. It's much like using Jasmine's `spyOn().andCallThrough()`. Effectively Istanbul is able to check whether or a given unit of code has executed, much like using Jasmine's `expect(spy).toHaveBeenCalled()`. The main difference is that the instrumented code will become files rather than in memory objects.

The configuration for Istanbul must point out which files to instrument. Perhaps the biggest gotcha here is instrumenting the tests. You don't want to do that for reasons that will become clear later on. The main thing to understand is that Istanbul needs to spy on your application, not your tests.

### Run the Tests

Now that you have instrumented code, have Jasmine run it's tests _against the instrumented code._ This means that Istanbul can determine exactly which units of code executed during the test run. Our configuration will also need to specify how to run the tests.

Once the test run is finished, Istanbul will output all the reports and display some summary metrics in the console. Configuration directs Istanbul to use one of several formats for the reports.

## Show Me The Code!

Enough chitter-chatter. Here's how I setup things in my project:

{% highlight bash %}
$ cd /path/to/project
$ npm install --save istanbul jasmine-node
$ mkdir -p test
{% endhighlight %}

Istanbul and Jasmine-node are built as command line tools, thus normally they would be globally installed. Notice I'm not doing that. In my experience, global packages are fundamentally wrong headed and are the biggest disparity between dev and production environments. Fortunately, npm makes using non-global command tools easy. Add something like the following to your package.json file:

{% highlight json %}
{
  "scripts": {
    "test": "istanbul cover --include-all-sources jasmine-node test"
  }
}
{% endhighlight %}

Put all your tests for jasmine-node into the test directory. To run your test suite AND get test coverage do this:

{% highlight bash %}
$ npm test
{% endhighlight %}

Running `npm test` is really a shortcut for `npm run test`, which is the `test` command we created in package.json. Although the `istanbul` executable isn't normally available in the shell (because we didn't install it globally), npm makes it available inside the scripts listed in package.json. None of this should be suprising -- it's not specific to istanbul.

Let's dig into the istanbul specific bits a little more:

 * the `--include-all-sources` flag causes istanbul to recurse through directories for more source files to instrument
 * everything after `istanbul cover [flags]` is the test command (in this case `jasmine-node test`)
 * by default, istanbul ignores the `test` and `tests` directory. If we had used `spec` instead, we'd have to configure istanbul to ignore that directory
 * by default, istanbul creates reports in a directory `coverage` under the current working directory

There's a lot more configuration options which I'm not going into here. If you want to explore them, try this:

{% highlight bash %}
cd /path/to/project
./node_modules/.bin/istanbul help config
{% endhighlight %}

## Design Considerations

There's lots of choices of you can make while setting up Istanbul, and a few problems to avoid.

### Git Ignore Coverage Reports

The coverage reports are generated from your source, but you don't want to ship that into production. Add that directory to your gitingore.

### Gotcha: Instrumenting the Tests

Let's revisit the gotcha mentioned above -- accidentally instrumenting your tests. If only your tests are instrumented, Istanbul will report 100% coverage. You'll slap yourself on the back -- 100%! We did it! Then you'll realize something's off. If you instrument your source code along with the tests, all metrics will skew upwards proportional to size of your tests.

Not to be a broken record, here, but Istanbul is mocking out your entire application to observe what your tests are covering. If you accidentally have Istanbul mock out your tests, Istanbul will notice that all of your tests have run, which is not very helpful.

To help keep tests and source code distinct for Istanbul, I recommend using a separate top level directory for tests and source code in your project.

### Running the Tests Once or Twice

In my limited experience, running Jasmine against the instrumented code produces the same results as running Jasmine against the original source code. If Jasmine fails the test run, its process returns a non-zero exit code. Istanbul's process then passes through a non-zero exit code as well if Jasmine fails. Thus, however you run your tests (npm, grunt, gulp, Circle CI, Travis, etc), you can  run the Jasmine tests once and get the results faster.

If you don't trust the results of the instrumented code, the other choice would be to run the Jasmine tests twice -- once against the source code and once against the instrumented code.

### One or Many Coverages

Not all tests are created equal. You might want to have integration tests as well as unit tests. Think hard about to categorize each kind of test you have (or want to have). You might consider having Istanbul check the unit test coverage separately from the integration test. Here's one way you might do that:

{% highlight json %}
{
  "scripts": {
    "test": "npm run unit && npm run integration",
    "unit": "istanbul cover --include-all-sources jasmine-node test/unit",
    "integration": "istanbul cover --include-all-sources jasmine-node test/integration"
  }
}
{% endhighlight %}

While it could be helpful to setup separate coverage checks, you won't have insight into the overall test coverage on the codebase as a whole. If you do decide to break test coverage into separate catgories, I also recommend having an overall coverage report generated.
