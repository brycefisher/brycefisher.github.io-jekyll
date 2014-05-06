---
title: "How to Write a Craigslist Scraper in Rust (for Web Developers)"
layout: "post"
excerpt: "A walkthrough of how I built a cli tool in Rust that does some basic scraping of Craigslist. My background is JavaScript and PHP, so if you're not super familiar with compiled languages, this post is for you."
category: rust
tags: rust, rss
---
I'm a PHP/JavaScript developer by day, and rust dabbler by night. I've recently managed to build a working tool I call ["Iron Santa"](https://github.com/brycefisher/iron-santa) that scrapes Craigslist in search of whatever keyword you enter. My Rust is definitely not idiomatic or well written, but it does compile (and run). I'll walk you through some high level points and explore a few code samples and pitfalls of interest to a developer accustomed to working with dynamically typed, interpretted languages.

## A Quick Background on Craigslist

Craigslist does not have a publicly available API, despite repeated requests from their community. Also, they frown upon web scraping of their generally. 

<!-- Insert a photo of a conversation about an API -->

Fortunately, Craigslist does make every search result available as a well formatted RSS feed at predictable urls. We can control the search results using query parameters. Hooray!

<!-- Graphic showing query parameters -->

Although Craigslist allows users to post items for sale from anywhere, all items are siloed by geographic region and it's impossible to do a global search. Somehow, we'll need to get the user's geographic location during the applications runtime.

## Iron Santa's MVP

 1. Determine user's location
 2. Find the closest Craigslist region to the user
 3. Ask the user what to look for on Craigslist
 4. Format the url for the search
 5. Parse the XML in the response
 6. Display the results to the user
 
For the rest of this post we'll walk through I tackled each of these six steps.

## 1. Determine User's Location

[Telize.com](http://www.telize.com/) providing unfettered access to their GeoIP API in Json. Simply `GET http://www.telize.com/geoip`, and you'll see a result like

{% highlight json %}
{
  ...
  "region_code":"CA",
  "region":"California",
  "city":"San Francisco",
  "longitude":-122.4156,
  "latitude":37.7484,
  "country_code":"US",
  ...
}
{% endhighlight %}

Theoretically, we could just check to see if the city field matched one of our Craigslist regions, but then we'd have to know the name of every city. Some cities have the same name but are in different states (like Springfield, Illinois and Springfield, Massachussetts). Let's keep it simple and extract the longitude and latitude fields. Then we'll use some trigonometry to determine the distance from a list of predefined Craigslist regions.

There's two parts to actually implementing step 1: A) make an HTTP request, and B) parse the JSON in the response.

### 1.A Make an HTTP Request

It turns out, making an HTTP request is nontrivial in Rust. Fortunately, Chris Morgan built and maintains a wonderful library called [rust-http](https://github.com/chris-morgan/rust-http). Unfortunately, I felt compelled to reinvent the wheel, and Chris Morgan was kind enough to help me debug it. Here's what my http client code eventually looked like in Rust:

{% highlight rust %}
use std::io::net::ip::SocketAddr;
use std::io::net::tcp::TcpStream;
use std::io::net::addrinfo::get_host_addresses;
use serialize::json;

fn make_request(host: ~str, port: u16, path: ~str) -> Response {
    // Attempt to convert host to IP address
    let ip_lookup = get_host_addresses(host).unwrap();
  	
    // Open socket connection
    let addr = SocketAddr { ip: ip_lookup[0].clone(), port: port.clone() };
    let mut socket = TcpStream::connect(addr).unwrap();

    // Format HTTP request
    let header = format!("GET {} HTTP/1.0\r\nHost: {}\r\n\r\n", path.clone(), host.clone());
    
    // Make request and return response as string
    let raw_response = match socket.write_str(header) {
    	Ok(_) => { socket.read_to_str().unwrap() }
    	Err(e) => { fail!("No bueno! Error: {}", e); }
    };
    Response::from_str(raw_response)
}
{% endhighlight %}

I've defined a function `make_request` that takes a host name (string), a port number (unsigned 16 bit int), and a path (string). It then returns a `Response` struct (which is like an object in PHP or Java). Internally, this function tries to resolve the host name to an IP address, and then opens an internet socket connection using the first IP address and the specified port number.

Then I format a multiline HTTP header string that specifies the host name and the path, and then I send this HTTP request over the socket connection. I then do some useless error handling on the response and return a Response created from the raw HTTP response string.

Some quick observations on the code above:

 * **.unwrap()**: Rust doesn't allow null pointers or uninitialized variables. So, whenever you do something that might not work (like resolve a host to an IP address), Rust returns a special data type called an `enum` which has two or more `variants`. Any operations that could fail returns a `Result` enum with either the `Ok` or `Err` variant. `unwrap()` grabs the data you actually want (namely the IP address) out of the Ok variant, or causes the program fail on an Err variant. Apparently, this is a big win over C++, but it makes really ugly code IMHO. Fortunately, there's lots of sugar in Rust.
 * **.clone()**: Rust is super strict about memory management, to the point we can't easily pass strings between functions in Rust. Honestly, strings suck in Rust. We have to mentally keep track of which type of string we have all the time (there's four by my count). Because strings are so fragmented, there are always two or three identical methods in the standard library that use or return a different type of string.

Below, I define a struct (like a class in PHP or Java) called Response to contain some metadata about the result of our HTTP request. I'm only parsing out two properties, status (an integer) and the content (a string).

{% highlight rust %}
struct Response {
  status: int,
  content: ~str
}
{% endhighlight %}

However, I need to "add" a function called `from_str()` to the Response struct so that my `make_request()` function will work. Here it is:

{% highlight rust %}
impl Response {
  fn from_str(raw_response: ~str) -> Response {
    // ...
    let lines: ~[&str] = raw_response.lines().collect();
    let mut start_content: uint = lines.len();
    let mut c: uint = 0;
    for &l in lines.iter() {
      if c < start_content && l.starts_with("HTTP/") {
        status = std::from_str::from_str(l.slice_chars(9,12)).unwrap();
      }
      if c >= start_content {
      	content.push_str(format!("{}\n", l));
      }
      if c < start_content && l.starts_with("\r") {
        start_content = c;
      }
      c = c+1;
    }
    Response{ status: status, content: content.into_owned() }
  }
}
{% endhighlight %}

Apparently, the HTTP protocol demands that the HTTP headers are separated from the content by two conseqecutive CRLF's. So, I basically, iterate over each line of the raw response string looking for the first line with only the CR. Then, everything else goes into the content field. Also, the HTTP status code will appear in the first line like so:

    HTTP/1.1 200 OK

The status code is always 3 digits long and always appears in the 9-11 positions in that line, so this functions converts that string slice into a integer.

Any line of Rust that doesn't end in a semicolon is the value of the whole block. So my last line `Response { ... }` is returned from the function, somewhat similar to Ruby, but not quite.

### 1.B Parse the Json Response

Rust does ship with Json encoder/decoder functions in it's serialization crate. However, this part was not super obvious to me. Also during my development time (several weeks), the function names changed and were moved into a different crate. Rust is still really unstable, so you have update the compiler daily and stay on top of the changes in the mailing list.

Here's how I was able to eventually parse the Json response from telize.com:



## 2. Find the Closest Craigslist Region to the User

## 3. Ask the User What to Look for on Craigslist

## 4. Format the URL for the Search

## 5. Parse the XML in the Response

## 6. Display the Results to the User
