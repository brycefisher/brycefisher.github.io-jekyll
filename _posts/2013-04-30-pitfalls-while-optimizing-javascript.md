---
title: "Pitfalls while Optimizing JavaScript"
layout: "post"
excerpt: "I've tried to incorporate some best practices from <em>JavaScript Patterns</em> by Stoyan Stefanov of Yahoo! Press. Here's some pitfalls I've run into and some simple fixes."
---
I've tried to incorporate some best practices from <em>JavaScript Patterns</em> by Stoyan Stefanov of Yahoo! Press. Here's some pitfalls I've run into and some simple fixes. The examples are straight JavaScript, no libraries used at all. However, the concepts and techniques could easily be applied to jQuery, Dojo, or other libraries, especially the for-loop section.

## Variable Hoisting

JavaScript essentially moves any variable declarations into the top of the current function (or global namespace), regardless of it's placement in the source code. There are some edge cases where this makes variables be undefined or have confusing values. There's some possible value in having all variables defined in the same place in your code (from a readbility perspective). If you're working with hundreds of lines of code, or you have a very complex app you're building, this is definitely a best practice. For short snippets of code, this is probably more optional. However, I'll be following this practice in the sections to follow. There's no real pitfall here, just an FYI!

## Optimizing For-Loops

### Cache the `length` property

An easy way to speed up JavaScript code is to optimize for loops. The `length` property of arrays is actually more like a function call in that the browser will have to rexamine the array each time your script accesses the `length`. The way to optimize this situation is to read the length of the array once, store it in a local variable, and then compare the iterator to the local variable. Here's an example:

{% highlight javascript %}
var myArray = [1,2,3,4,5,6,7,8,9],
max = myArray.length;
for(var i=0; i<max; i++){
   console.log(myArray[i])
}
{% endhighlight %}

Simple, right? Using `max` prevents the browser from reexamining `myArray`'s contents on every iteration of the loop, thus avoiding unnecessary work. This effect becomes more pronounced on larger arrays. 

### Count Down, Not Up

While the first example above is all well and good, we could go a step farther. All else being equal, it's faster to compare a number to 0 than to another number. So, we can (in theory) speed up this for-loop just a little bit by starting `i` at the length, and comparing to 0 and decrementing `i` instead. The added bonus is that we get to remove an extra variable. Here's an example:

{% highlight javascript %}
//antipattern
var myArray = [1,2,3,4,5,6,7,8,9],
i = myArray.length;
for(; i>0; i--){
   console.log(myArray[i])
}
{% endhighlight %}

Notice that we're still caching the `length` inside a variable. The odd thing about this syntax is that we set `i` outside the for-loop and thus the first statement is just a semicolon. While strange to see, you'd have to admit that the code inside in the for loop couldn't get much shorter.

### Zero-Relative Issues with Arrays

If you try to run the second example above, it won't work. Why not? The length property is 1 relative, but the array indices are zero relative. So, for instance `myArray[1]` would be `2`. The very first iteration of the loop, the script tries access a non-existent element in the array since it uses the `length`.

The solution is simple. Set `i` to length - 1, and then inside the for loop update the conditional to include 0. Here's final code:

{% highlight javascript %}
var myArray = [1,2,3,4,5,6,7,8,9],
i = myArray.length - 1;
for(; i>=0; i--){
   console.log(myArray[i])
}
{% endhighlight %}

## Optimizing DOM Lookups

### The Ethics of Cloning

You can speed up your script to updating larger swathes of the DOM at a time whenever the nodes you're changing share a common `parentNode`. It may not be appropriate for all situations, but I feel like I'm always iterating over a list tag and updating each of the list items.

To implement this "pattern," grab the element you want, clone it, modify it, and swap out the original with the clone. Let's look at an example:

{% highlight javascript %}
//antipattern
var old_node = document.getElementById('product-list'),
new_node = old_node.cloneNode(),
lis = new_node.getElementsByTagName('li'),
i = lis.length - 1;
for(; i>=0; i--) {
  lis[i].style.color = "red";
}
old_node.parentNode.replaceChild(new_node, old_node);
{% endhighlight %}

### Copy the DOM Subtree Separately

Unfortunately the above snippet doesn't work as you'd expect. The problem is that the W3C specifies that `cloneNode` will only copy the dom object and it's attributes. However, the innerHTML, any text inside or nodes underneath are **NOT** copied. Thus, you'd get an exact copy of that node but nothing else.

The solution is to copy the innerHTML property as well. Here's my example (you're welcome to improve upon it):

{% highlight javascript %}
var old_node = document.getElementById('product-list'),
new_node = old_node.cloneNode(),
lis = [],
i = 0;

new_node.innerHTML = old_node.innerHTML;
lis = new_node.getElementsByTagName('li');
i = lis.length - 1;
for(; i>=0; i--) {
  lis[i].style.color = "red";
}
old_node.parentNode.replaceChild(new_node, old_node);
{% endhighlight %}

Feel free to share your thoughts!
