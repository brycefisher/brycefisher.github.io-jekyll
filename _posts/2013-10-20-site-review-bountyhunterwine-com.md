---
title: "Site Review: BountyHunterWine.com"
layout: "post"
excerpt: "BountyHunterWine.com offers a wide selection of wine for purchase online, but their user experience leaves something to be desired. Rather than bailing on their site, I decided to articulate the problems that I encountered and try to suggest constructive alternatives to the current implementations. This post is simply the contents of that letter."
---
BountyHunterWine.com offers a wide selection of wine for purchase online, but their user experience leaves something to be desired. Rather than bailing on their site, I decided to articulate the problems that I encountered and try to suggest constructive alternatives to the current implementations. This post is simply the contents of that letter.

--------------------------------

Dear Bounty Hunter Wine,

I like the look of your elegant website and the prices are also good on your products. My purpose for using your website today is to purchase some wine for three business partners as a thank you gift. I want each business partner to receive one bottle of wine each with a customized "thank you" message. Each partner lives at a separate address. I was able to easily find the wine I wanted at a very reasonable price without any problems. I really like the "Price Range" filter.

However, I've run into several problems trying to place orders on your site that I wanted to make you aware of.

### 1) SSL Certificates

![https woes for bountyhunterwines.com](http://files.bryceadamfisher.com/blog/2013/site-review-bountyhunterwine/https-woes.png)

Your SSL certificates are only valid for www.bountyhunterwine.com which is fine. However, I was not redirected from bountyhunterwine.com to www.bountyhunterwine.com when I went to your site. This caused the "invalid certificate" logo from thawte to appear as well as warning messages that made your site look insecure. I recommend you pay your developers to setup such a redirection to create a trustworthy environment for your customers.

### 2) Adding Products to the Shopping Cart

![difficulty filling up the shopping cart](http://files.bryceadamfisher.com/blog/2013/site-review-bountyhunterwine/quantitative-errors.png)

When I got to this screen I ran into trouble. I was only allowed to add 2 recipients at a time. Adding a third recipient caused the "Remaining Quantity" to read "-1" and I was unable to click "Continue Shopping" or "Viewcart" without triggering an error message.

However, by starting over, I was able to add one wine bottle for 2 of my business partners, then I clicked "Continue Shopping." I returned to the product, and I was able to add a bottle to my shopping cart for my third business partner.

It seems to me that there are more than 2 bottles of "2009 Stag's Leap Wine Cellar's Merlot" in your inventory, and that I ended doing a lot of extra work to place this order for all three of my partners.

There are several ways of improving this part of the shopping experience. I think the best experience for me would have been to indicate the total stock of wine with "Remaining Quantity" and then to allow me to add recipients and quantities of wine ONLY if the actual remaining quantity was >= 0. Using a Javascript alert box if the remaining quantity actually reaches 0 would tell users that there's no more wine to be had. However, I don't understand the benefit of preventing users from ordering as much wine as we want to while additional stocks of wine are on hand.

### 3) Account Creation Form

#### a. Privacy
Once I add managed to add all the wine to the shopping cart, I started the process of creating an account. I would prefer not provide my phone number during this process. I seriously considered finding another wine store that didn't require a phone number.

![lots of problems on the billing forms](http://files.bryceadamfisher.com/blog/2013/site-review-bountyhunterwine/billing-information.png)

#### b. Address Fields
I was very confused by the bottom half of this form. In particular, I would expect the address fields to match the order I write them as an address on an envelope, namely:

    Street 1
    Street 2
    City
    State
    Zip
    Country

It's amazing how difficult I found it to fill in these fields when they were in a surprising order.

#### c. Zip Code & City Fields

Since I was confused by the order of the address fields, I entered the city first then the zip code. Doing so caused some JavaScript on the page to erase the value I provided for city. Also, the city field transformed from a text field into a dropdown list. However, I didn't notice this happen.

#### d. Premature Account Creation

After I pressed submit, the page informed me that I failed to fill in some fields on the form (namely the city field). I had to carefully examine each field to determine where the form needed to be filled in.

Once I fixed the city field, I tried to submit the form again. This time I received the error message that a user on the site already had that email address.

What happened was that the server side code had started processing the information from my first form submission without fully validating it. This is a serious security risk and a poor user experience. The server side code should instead be checking all form fields are:

1. filled in (if they are required)
2. validated so that make sense (ex: zip codes should be 5 digit numbers)
3. sanitized to prevent attacks from hackers and evil internet robots (better known as "bots")

Only once everything is fully validated should the data provided by the user be added to the database or used by the shopping cart.

I imagine other customers have this same problem that I experienced, and I believe that this is the most crucial and (and complicated) problem to address on your site of those that I discovered.

### 4) Adding Shipping Addresses

![unnecessary disclosures](http://files.bryceadamfisher.com/blog/2013/site-review-bountyhunterwine/unnecessary-information.png)

My reason for shopping at bountyhunterwine.com is to purchase wine for my three business partners. I work very closely with only one of them, and unfortunately I don't have all of their phone numbers. I'm not sure if your shipping company requires a phone number for each destination address or not, but making the phone number optional would make it much easier for me to use your website.

Also, I'd prefer not o divulge the personal information of my business associates without their explicit consent, and I was hoping to surprise them.

## CONCLUSION

I hope that you find this feedback constructive. Let me know if you're able to make progress on these user interface and backend suggestions I've provided. Best of luck with your online business venture.

Cheers
Bryce Fisher-Fleig
