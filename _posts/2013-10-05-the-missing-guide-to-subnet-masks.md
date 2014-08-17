---
title: "The Missing Guide to Subnet Masks"
layout: "post"
excerpt: "This post aims to make it a little easier to understand how to read and specify ranges of IP addresses using subnet masks."
---
Recently, I tried to understand what was going on in terms of IP ranges in my firewall configuration, and I had an impossible time trying to find a succinct and clear explanation. This post aims to make it a little easier to understand how to read and specify ranges of IP addresses using subnet masks. 

Sexy Subnet Masks in Binary
-------------------------------------------

Subnet masks are often used by system administrators to specify ranges of IP addresses in a compact format. In this context, the word _mask_ means a binary number used to transform an IP Address using boolean algebra (AND, OR, XOR operations). While subnet masks might not be sexy, seeing the binary form of a subnet mask is the only way to visualize what's going on. Let's start with an example subnet mask:

> 11111111 . 11111111 . 11111111 . 11110000

Notice that the subnet mask consists of 4 octets of bits. This mask is used to transform an IP address. So let's take an imaginary IP address, 50.122.34.21, to play with. We'll need to convert this address into 4 octets of bits so that we can easily visualize what's going on:

> 00110010 . 01111010 . 00100010 . 00010101 (**IP Address**)

Straight Up Boolean, Baby
--------------------------------------

All subnet masks use boolean AND to combine the IP Address and the mask. Let's review how boolean AND works:

> 1 AND 1 = 1.<br>
> 0 AND 1 = 0.<br>
> 1 AND 0 = 0.<br>
> 0 AND 0 = 0.<br>

Okay, now putting that altogether, let's AND the IP address and the subnet mask together:

<div class="scroll">
  <table>
    <thead>
      <tr>
        <th>First Octect</th>
        <th>Second Octect</th>
        <th>Third Octet</th>
        <th>Fourth Octect</th>
        <th>Name</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>00110010</td>   
        <td>01111010</td>   
        <td>00100010</td>  
        <td>00010101</td>
        <td><strong>IP Address</strong></td>
      </tr>
      <tr>
        <td>11111111</td>   
        <td>11111111</td>   
        <td>11111111</td>  
        <td>11110000</td>
        <td><strong>Subnet Masks</strong></td>
      </tr>
      <tr>
        <td>00110010</td>   
        <td>01111010</td>   
        <td>00100010</td>  
        <td>00010000</td>
        <td><strong>Result</strong></td>
      </tr>
    </tbody>
  </table>
</div>

Notice how all the ones on the left side of the subnet mask allow the starting IP address to trickle down into the result. Only the rightmost bits (where the mask has 0's) are altered. At the end of the process, we get 50.122.34.16 converting the binary result back into decimal.

A Subnet Mask By Any Other Name
-----------------------------------------------------

So, why would we care about getting out 50.122.34.16? We care because we now have a way of saying "do something to all the IP addresses between 50.122.34.21 and 50.122.34.16". Let's take this a little farther and make subnet masks more useful. Look at the binary form of the subnet mask once more:

> 11111111 . 11111111 . 11111111 . 11110000

Notice, that all the 1's are on the left and all the 0's are on the right. This is no accident. Subnet masks are not allowed to put ones and zeros anywhere you like. Some number of 1's must go on the left side, and the rest of the bits will be zero. Since this is the case, you could abbreviate the subnet mask by just counting the number of 1's. For instance the above subnet masks could just as easily written as:

> /28

Likewise, these two notations are also equivalent:

> /8<br>
> 11111111 . 00000000 . 00000000 . 00000000

So, combining this short form of the subnet mask and the original IP address could also be written like:

> 50.122.34.21**/28**

While this form is harder for mere mortals like myself to read, I suspect that this format is much much faster for networking devices to compute and store. It also has the advantage of being much shorter than writing out the full version of two IP addresses. In the literature on this topic, you often find the decimal notation for subnet masks as well. For instance, /28 would be written out as 255 . 255 . 255 . 240. Personally, I find this notation unhelpful, so I've avoided it in this article, but you should expect to see it written this way sometimes.

The Gotcha
------------------

You knew it was coming, didn't you? Notice that our transformed IP address from the example above (50.122.34.16) ends in 16. This too is no accident. Since our subnet mask uses binary numbers, the transformed result will nearly always end in a power of two. This makes starting or ending an IP range on an arbitrary number between powers of two hard, because you'll need to break down the range into a series of more binary friendly sub-ranges. I'll leave you play around with the math yourself.

There are some great [subnet mask calculators online](http://www.subnetmask.info/) that can help play with the examples above or your own firewall configuration to better understand the concepts in this article. 

Conclusion
----------------

Firewalls often use subnet masks in the compact form IP/number of 1's to specify a range of IP addresses. Understanding the boolean AND operation is the key to understanding how these subnet masks work.
