---
title: "Testing AWS Go SDK Integrations"
excerpt: "If you're using Testify and Mockery, getting units to work with some AWS Go SDK pagination methods can be hairy. I'll show my (somewhat unconventional) strategy to cover ALL the code paths in your application."
category: golang
tags: testing, golang
layout: post
---

When programming in Golang, the Mockery project painlessly generates Testify mocks from any interface. But very rarely (and specifically in the AWS Go SDK), you run into situations that Mockery + Testify doesn't handle well. If you're sure that Testify has failed you, you must then navigate a minefield of horrors.

<p class="responsive-image"><a href="https://www.flickr.com/photos/andyandorla/362709263/">
<img alt="A sign labeled Minefield hangs on a forlorn barbed wire fence" src="/img/2015/minefield.jpg">
</a></p>

## The Post-Testify Minefield of Horrors

The post-Testify Minefield of Horrors is a trilemma:

 1. Don't unit test this code -- what could go wrong?
 2. Abandon Testify for this package -- hand write ALL the mocks!
 3. Keep using Testify -- rewrite the mocks EVERY time your regenerate your mocks.

None of these are great options. What if there was a way to use Testify mocks 99.99999% of the time, but handcraft _only_ the special cases it doesn't cover? That's what I aim to offer you by the end of this post -- a way through this minefield.

### You Lie! Testify Is All I Need

![Elf says 'You sit on a throne of lies!'](/img/2015/throne-of-lies.gif)

Consider the AWS DynamoDB package. Let's say you want to query one of your DynamoDB tables, but the total amount of data you want to retrieve could become greater than 1 MB. According to [the documentation](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/QueryAndScan.html#Pagination):

> If you query or scan for specific attributes that match values that amount to more than 1 MB of data, you'll need to perform another Query or Scan request for the next 1 MB of data.

To ensure that your application retrieves _all_ the query results, you need to call `DynamoDB.Query()` repeatedly with different inputs and outputs. That's all very simple, but to unit test this code you'll need a mock implementation of `DynamoDB.Query()` which can **return different values on each call**. Although Mockery shows some examples of this in their README, returning dynamic values seems not to work at time of writing (late October 2015).

For API responses which aren't paginated, we should be able to have unchanging return values in our unit tests, so we want Mockery to generate all those Testify mocks.

## The Solution: Separate Interfaces

<p class="responsive-image"><a href="http://imgur.com/gallery/wpont">
<img alt="The starship Enterprise separating the saucer from the ship" src="/img/2015/separate-starship.jpg">
</a></p><br>

If we have a dedicated interface for the handcrafted mocks, we can choose to generate mocks for only one interface. Furthermore, since Mockery puts its generated code in a subdirectory `./mocks`, we can ensure our handcrafted mocks will survive by keeping them out of `./mocks`.

### The Small, Handcrafted Queryer Interface

{% highlight go %}
import (
    "github.com/aws/aws-go-sdk/services/dynamodb"
)

type Queryer interface {
    Query(*QueryInput) (*QueryOutput, error)
}

var _ Queryer = (*dynamodb.DynamoDB)(nil)
{% endhighlight %}

A `Queryer` only needs to implement the `Query()` method already in the DynamoDB package. For good measure, we create a nil and ignored DynamoDB struct object as a `Queryer` so that the compiler will verify that we have the method signature of `Queryer.Query()` matching `DynamoDB.Query()`. We want to make sure the compiler catches any obvious mistakes (like failing to satisfy an interface) before we ship this code into production. Otherwise, we might theoretically some day update the AWS Go SDK package, have the code compile, and ship this out into production only to discover failures too late.

### Wrapping Up Queryer in a Useful Func

Let's assume your application should always retrieve all the results, we'll want to create a wrapper method to DRY up and encapsulate all the logic necessary to retrieve all pages of results.

{% highlight go %}
func paginatedQueryImpl(q *Queryer, i *QueryInput) ([]items, error) {
    // ...
}

var paginatedQuery = paginatedQueryImpl
{% endhighlight %}

Let's unpack this a bit. Why both a `paginatedQueryImpl()` and `paginatedQuery()`? The idea here is that we want to easily mock out the method that our application will actually use, so I've created a mutable variable `paginatedQueryImpl()`. This allows me to change the implementation on the fly in unit tests by just assigning a new lambda function.

However, for my unit tests on `paginatedQuery()` itself, I need to ensure that I'm testing the actual implementation. For that kind of assurance, I need to declare a function with the real implementation. Then, in my unit tests I can simply reassign the real implementation to my `paginatedQuery` variable as a setup step.

Then, I need a way to test the interaction between `paginatedQueryImpl` and DynamoDB, and that's precisely why it takes a `Queryer` argument. This allows us to pass in either real `DynamoDB` objects or our handcrafted mocks. The handcrafted mock will simulate all the various test cases that we care about without needing to send any requests over the wire or even have an AWS account.

The implementation of `paginatedQuery()` is left as an exercise to the reader, since testing is the primary focus of this post.

### Handcrafting the Mock Queryer

{% highlight go %}
import (
    "github.com/aws/aws-go-sdk/services/dynamodb"
)

type MockQueryer struct {
    QueryFunc func(*QueryInput) (*QueryOutput, error)
}

func (m *MockQueryer) Query(i *QueryInput) (*QueryOutput, error) {
    return m.QueryFunc(i)
}
{% endhighlight %}

There's a few salient points to discuss here:

 * We _need_ the `QueryFunc` field to be a lambda function, because we want to replace it with different implementations in each test case. We don't want to define a different struct type for every test -- that's just too much boilerplate code.
 * Because the `QueryFunc()` and `Query()` both have the same signature, we can simply passthrough the arguments and return values from the `Query()` to `QueryFunc()` and get compile-time checks that we defined our lambdas correctly in the tests.

### Let's Write Some Example Unit Tests

The F# community's writings about [property-based testing](http://fsharpforfunandprofit.com/posts/property-based-testing/) have had a profound impact on me. Whenever appropriate, I like to include some randomness in my tests to ensure that a whole range of similar but unpredictable values are tested to prevent an incomplete implementation from passing.

{% highlight go %}
import (
    "math/rand"
    "github.com/stretchr/testify/suite"
)

// Define a Testify suite `MySuite` here and run it.

func (s *MySuite) TestPaginateQuery_NQueryResultPages(t *Testing.T) {
    minPages := 3
    maxPages := 50
    itemsPerPage := 10
    totalPages := rand.Int31n(maxPages - minPages) + minPages
    totalItems := totalPages * itemsPerPage

    c := 0
    keys := rand.Perm(int(totalPages))
    mq := &MockQueryer {
      QueryFunc: func(i *QueryInput) (*QueryOutput, error) {
          // Run assertions on the arguments to QueryFunc()
          actual := i.ExclusiveStartKey
          expected := keys[c-1]
          if c > 0  {
              s.Equal(i.ExclusiveStartKey, keys[c-1])
          }

          // Generate the QueryOutput with correct LastKeyEvaluated
          output := makeQueryOutput(c, itemsPerPage, totalPages)
          c++
          return &output, nil
      }
    }
    items, err := paginatedQuery(&mq, &dynamodb.QueryInput{})

    s.Len(items, totalItems)
    s.Nil(err)
}
{% endhighlight %}

In our test method `TestPaginateQuery_NQueryResultPages`, the first five lines randomly pick how many pages of results and total items should exist when this test runs.

The next several lines of code create call counter `c` and create a new `MockQueryer` object `mq`. This object is passed into our the method we want to test `PaginateQuery()`. Now, we have complete control inside the QueryFunc method to calculate whatever return values we want AND to run assertions on the arguments to this method.

My test leaves a lot to be desired (and probably doesn't even compile), but hopefully it can serve as an inspiration.

## Testing Code that Uses PaginateQuery()

I believe the clearest and easiest way to test code that invokes `paginateQuery()` is using the mutable/immutable functions I've defined earlier. This allows us to stub replace the func during our tests and gives us unfettered access to control in the innerworkings of our code. Let's see a short example:

{% highlight go %}
// retrieve_everything.go
func RetrieveEverything() ([]item, error) {
    dynamo := dynamodb.NewDynamoDB()
    return paginatedQuery(&dynamo, &QueryInput{})
}

// retrieve_everything_test.go
func (s *MySuite) TestRetrieveEverytingPropagatesErrors() {
    paginatedQuery = func(_ *Queryer, _ *QueryInput) ([]item, error) {
        return nil, errors.New("Dynamo Broke")
    }
    items, err := RetrieveEverything()

    s.EqualError(err, "Dynamo Broke")
    s.Nil(items)
}
{% endhighlight %}

In a similar fashion, we can replace `paginatedQuery()` with mocks that will return nil errors, improperly formatted data, a slice of results, an empty slice, or any other scenario that could conceivable happen.

### Damn Your Smoke and Mirrors!

![Why Do you want to annoy me when things are going so well?](/img/2015/why-annoy-me.gif)

The downside of this approach is that any part of your codebase could overwrite the func pointed to by `paginatedQuery()` which seems a bit unsafe. If any unit tests replace it with a mock, you'll need to reset it to `paginatedQueryImpl()` as discussed earlier.

However if global mutable lambdas makes you uncomfortable, you can use Mockery to generate a mock for `DynamoDB.Query()` and indirectly control the output of `paginatedQuery()`. If you go that route, just don't use a package variable. Instead, make `paginatedQuery` a proper immutable func in its own right. As far as I can tell, which strategy you use is entirely a matter of preference.

## Taking it Further

 * The [Mockery Project](https://github.com/vektra/mockery) is well worth a look if you haven't seen it before.
 * Nearly everything I've said here applies equally to any other paginated function in the AWS Go SDK (and that's a lot of functions). If you use this sort of technique a lot, it might make sense to write a code generator that can DRY up repeated logic and tests around this functions.
 * Consider using AWS's [DynamoDB QueryPages() method](http://docs.aws.amazon.com/sdk-for-go/api/service/dynamodb/DynamoDB.html#QueryPages-instance_method) instead of `Query()` in your own code since it handles lots of pagination messiness for you.
 * I omitted the definition of the `MySuite` struct in one of the examples above for brevity. See the [Testify suites godoc](https://godoc.org/github.com/stretchr/testify/suite) if you need a refresher.
 * If you need to rerun just one test several times while you're debugging or writing tests, use `go test ./path/to/package -run TestFunc` where "TestFunc" is the name of the test that go knows how to run (ex: the func that starts your Testify suite).
 * For integration tests, I recommend trying AWS's [local-dynamo jar](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.DynamoDBLocal.html). It seems to be maintained and reasonably performant as a drop-in replacement for dynamodb that runs on your own machine or CI build environment.

## Conclusion

Golang is a fantastic language for writing unit tests, but it sometimes requires some creativity to test all the code paths you care about. Consider using smaller interfaces to mock out isolated complex dependencies that Testify can't handle well.

_**Special Thanks to Julian Cooper for all the ideas about lambdas and small interfaces presented here, to Phil Cluff for allowing me to write about my work, and my wife Emilie Fisher-Fleig for the insightful comments on my drafts.**_
