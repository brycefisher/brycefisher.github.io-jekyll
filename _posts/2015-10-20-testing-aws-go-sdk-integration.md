---
title: "Testing AWS Go SDK Integrations"
excerpt: "If you're using Testify and Mockery, getting units to work with pagination methods can be hairy. I'll show my (somewhat unconventional) strategy to cover ALL the code paths in your application that uses the SDK."
category: golang
tags: testing, golang
layout: post
---

The infamous Mockery project makes stubbing out arbitrary code nearly painless in your Go unit tests. But sometimes, you run into a situation that Mockery just isn't well equipped to handle. That can leave in a quandry:

 1. Don't write unit tests -- what could wrong?
 2. Embrace the tedium -- hand write ALL the mocks!
 3. Play the field and rewrite the mocks EVERY time your regenerate your mocks.

None of these are great options. What if there was a way to lean on Mockery for the 99% of the time it elegantly stubs your dependencies, but hand write _only_ the special cases it doesn't cover?

## WTF? Show Me This Flaw in Mockery!

Consider the AWS DynamoDB package. Let's say you want to make a Query against one of your DynamoDB tables, but the total amount of data you want to retrieve is greater than 1 MB. According to [the documentation](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/QueryAndScan.html#Pagination):

> If you query or scan for specific attributes that match values that amount to more than 1 MB of data, you'll need to perform another Query or Scan request for the next 1 MB of data.

To ensure that your application retrieves _all_ the data matching your Query, you need to either call `DynamoDB.Query()` repeatedly with different inputs and outputs. That's all very simple, but to unit test this code you'll need a mock implementation of `DynamoDB.Query()` which can return different values each time it is invoked and make assertions about the arguments and return values. Although Mockery shows some examples of this in their README, returning dynamic values seems not to work.

For methods which aren't paginated, we should normally be able to avoid complicated dynamic unit tests so we'll want to have all those methods stubbed by Mockery. But our paginated Queries need something more complicated for really good test coverage.

## Create Separate General Mockery and Query-Specific Interfaces

Our general interface for all the DynamoDB methods we'll use (`DynamoDBer`) can be created by Mockery and used in 99% of our unit tests. But our handcrafted tests of retrieving all query results, we'll create a separate interface (`Queryer`).

### The Queryer Interface

{% highlight go %}
import (
    "github.com/aws/aws-go-sdk/services/dynamodb"
)

type Queryer interface {
    Query(*QueryInput) (*QueryOutput, error)
}

var _ Queryer = (*dynamodb.DynamoDB)(nil)
{% endhighlight %}

`Queryer` only needs to implement the `Query()` method already in the DynamoDB package. For good measure, we create a nil and ignored DynamoDB struct object as a `Queryer` so that the compiler will verify that we have the method signature of `Queryer.Query()` matching `DynamoDB.Query()`. We want to make sure the compiler catches any obvious mistakes (like failing to satisfy an interface) before we ship this code into production. Otherwise, we might some day update the AWS SDK package, have the code compile, and ship this out into production where it fails.

### Wrapping Up Queryer in a Useful Func

If your application always to retrieve all pages of results (like mine normally do) and use the `Query(` method multiple times, we'll want to create a wrapper method to DRY up and encapsulate all the logic necessary to retrieve all the query results.

{% highlight go %}
type Item map[string]*dynamodb.AttributeValue

// Retrieves ALL results from a DynamoDB Query, no matter how many pages.
func PaginatedQuery(q *Queryer, i *QueryInput) ([]Items, error) {
    // The code that makes this func work is left as an exercise to the reader
    // since the primary focus of this article is writing the tests.
}
{% endhighlight %}

The most critial part here is that the `PaginatedQuery()` takes a `Queryer` argument. This allows us topass in either the real `DynamoDB` struct objects or our handcrafted mocks.

The `Item` type is purely syntactical sugar that represents a single item returned from a DynamoDB Query. I find this syntactical sugar a little easier to read than `[]map[string]*dynamodb.AttributeValue`.

### Implementing the Mock

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

The articles from the F# community about [property-based testing](http://fsharpforfunandprofit.com/posts/property-based-testing/) have had a profound impact on my thoughts about testing. Whenever appropriate, I like to include some randomness in my tests to ensure that a whole range of similar but unpredictable values tested to prevent an incomplete implementation from passing.

{% highlight go %}
import (
    "math/rand"
)

func TestPaginateQuery_NQueryResultPages(t *Testing.T) {
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
          if c > 0 && i.ExclusiveStartKey != keys[c-1] {
              t.Errorf("On the %vth invocation of Query(), expected ExclusiveStartKey to be %v but was %v", c, keys[c-1], i.ExclusiveStartKey)
          }

          // Generate the output
          itemValues := make([]Item, itemsPerPage)
          // Set default values inside each item in itemValues...
          lastKey := nil
          if c < totalPages {
              lastKey = keys[c]
          }
          o := QueryOutput {
              Items: itemValues,
              Count: &itemsPerPage,
              LastKeyEvaluated: keys[c],
          }
          c++
          return &o, nil
      }
    }
    items, error := PaginatedQuery(&mq, &dynamodb.QueryInput{})

    if len(items) != totalItems {
      t.Errorf("Expected %v total items returned from Paginated Query, but found %v", totalItems, len(items)
    }

    if error != nil {
      t.Errorf("Expected PaginatedQuery not to error, but this error was returned: %v", error)
    }
}
{% endhighlight %}

The first six lines basically just do some math to pick how many pages of results and total items there should be when this test runs.

The next several lines of code create call counter `c` and create a new `MockQueryer` object `mq`. This object is passed into our the method we want to test `PaginateQuery()`. Now, we have complete control inside the QueryFunc method to calculate whatever return values we want AND to run assertions on the arguments to this method.

My test leaves a lot to be desired (and it probably doesn't even compile as written), but it does give us enormous power to test the `PaginateQuery()` method under every code path and see how this might work.

### Testing Code that Uses PaginateQuery()

The most elegant way to do this is to declare `PaginateQuery()` a package variable and set it equal to a lambda. This allows us to stub replace the func during our tests and gives us unfettered access to control in the innerworkings of our code. The downside of this approach is that any part of your codebase could overwrite the func used in PaginatedQuery() which seems a bit unsafe.

However, `PaginateQuery` itself is a great candidate for Mockery -- it should only need to be called once in any methods that rely on it and it doesn't need to have dynamically calculated return values. Youcan either put this method onto an struct (possible a fieldless struct even) and then create an interface for Mockery to use, OR you can use Mockery to stub the `Query()` method and indirectly control the output of `PaginatedQuery`.

### Conclusion

Golang is great language for writing unit tests, but it sometimes requires some creativity to test all the code paths you care about. Consider using smaller interfaces to mock out isolated complex dependencies that Mockery can't handle well.

_**Special Thanks to Julian Cooper for all the ideas about lambdas and small interfaces presented here, and to Phil Cluff for allowing me to write about my work and his insightful comments on my drafts.**_
