---
title: "Setting Up SSL on AWS CloudFront and S3"
layout: "post"
excerpt: "I've just setup this blog using an S3 bucket as the origin server, CloudFront as my CDN, and SSL for under $10. Since there were so many articles to read along the way, I'm gathering up what worked for me all in one place."
category: aws
---

I've just setup this blog using an S3 bucket as the origin server, CloudFront as my CDN, and SSL for under $10. Since there were so many articles to read along the way, I'm gathering up what worked for me all in one place.

I'll assume you're already using Jekyll or another static site generator to create HTML files that you want hosted on S3 instead of Github pages (which are awesome if you don't want to use SSL).

Throughout this tutorial I'll use the domain name of this blog to help you understand what files are what as we go.

_**UPDATE**: CloudFront now offers HTTPS at no additional charge in certain situations. CloudFront takes advantage of an extension to the TLS protocol called Server Name Indication ("SNI"). SNI allows servers on a single IPv4 address to serve HTTPS content for multiple domains. It's a huge cost savings for Amazon, and they've decided to pass on the savings to you. Pay attention to step 5 below to take advantage of SNI._

## Step 1: Create an S3 Bucket

**Bucket Name:** Your bucket name must be like *bryce-fisher-fleig-org* to work with CloudFront (bryce.fisher-fleig.org won't work).

**Permissions:** Grant everyone read access to this bucket so that CloudFront can read out the content. Here's how:

 1. Open the Change the Permissions tab on your shiney new bucket
 2. Click "Edit bucket policy"
 3. Copy and paste this JSON snippet into the policy editor:

{% highlight json %}
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadGetObject",
    "Effect":"Allow",
    "Principal": {
      "AWS": "*"
    },
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::bryce-fisher-fleig-org/*"]
  }]
}
{% endhighlight %}

 4. Change "bryce-fisher-fleig-org" above to your bucket name
 5. Click Save

**Static Website Hosting** Open this tab and select "Enable website hosting". Make sure to set your *Index document* to index.html so that folders work right. Keep the "Endpoint" url handy for later.

This would be a great time to start uploading all the things to your new bucket, and try clicking on the Endpoint url to make sure things are groovy.

## Step 2: Setup a CloudFront Distribution

 1. Choose "Web"
 2. **Origin Domain Name** - Paste the "Endpoint" from S3's Static Website Hosting tab here
 3. **Minimum TTL** - Click "Customize". Keep this at 5 minutes (360 seconds). Once everything is groovy, change it to something higher (for instance, 24 hours).
 4. **Price Class** - I use US, Europe, and Asia. Choose whatever you're comfortable paying for.
 5. **Alternate Domain Names** - Enter "bryce.fisher-fleig.org" (or whatever your subdomain is). You'll have to [use Route53 if you want to use a root domain](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingNewDNS.html) with CloudFront.
 6. **Default Root Object** enter "index.html". Otherwise, http://bryce.fisher-fleig.org/ wouldn't display the root index.html file.

Don't worry about the various HTTPS settings yet, we'll come back to that later. None of the other settings need to be changed either.

## Step 3: Obtain an SSL Certificate

This step walks you through paying a company called a Certificate Authority ("CA") to verify your identity and issue an SSL certificate with their name on it. No matter which CA you pick, you'll have to create a Certificate Signing Request (CSR) which you will upload to the CA. You'll also need to generate a matching file called a private key.

The CA's act as a kind of notary public for the internet. Anyone can generate an SSL certificate for free, but if your certificate isn't signed by an official CA, then Chrome, Firefox, Safari, etc will not allow visitors to access your site over HTTPS. There's a limited number of these Certificate Authorities around, thus they can and do charge obscene prices. Resellers, like the two I mention below, offer much better prices.

Different CA's offer different kinds of certificates with various degrees of verification and encryption. For a personal blog, choose a single domain certificate verified using Domain Validation ("DV"). If you're doing e-commerce, you probably want the more complicated and expensive process called Extended Validation ("EV").

### Step 3.A: Buy an SSL Certificate on the Cheap

The best place I can find legit certs is from [ClickSSL.com](https://www.clickssl.com/?post_type=product). They provide an awesome search filter, and their certificates are all signed using SHA-2 (more on this below). All certificates have 2048-bit key length meaning that your certificate has reasonable encryption strength for the near future.

Previously, I advocated using CheapestSSLs.com, but I've discovered that they can have slow customer service and weaker encryption. It's unclear if they support SHA-2. CheapestSSLs.com can be a little cheaper than ClickSSL.com if that's important.

With either reseller, the main criteria for a certificate are:

 1. **SHA-2** (sometimes also called "SHA-256") -- Chrome and Firefox have pledged to start showing really scary security warnings to users for sites using the older SHA-1 signing algorithm by 2017. They already print warnings in the console today.
 2. **Domain Validation** (aka "DV") -- this means you can get the certificate right away through a self-service process. This option is only available for single domain certificates.
 3. **Price**

At my renewal time, I chose the RapidSSL certificate for this domain because I only want to serve one domain using this certificate, and the price was only $27 for two years. I highly recommend buying a two year certificate so that you don't have to go through this process every single year.

### Step 3.B: Generate a matching private key and CSR

Once you've paid for a certificate, you'll need to generate two cryptographic files: a private key, and a certificate signing request (CSR).

{% highlight bash %}
$ openssl req \
    -sha256 \
    -new -newkey \
    rsa:2048 -nodes \
    -keyout bryce_fisher-fleig_org.key \
    -out bryce_fisher-fleig_org.csr
{% endhighlight %}

_(There's a great article on what this command is doing at [entrust.net](http://www.entrust.net/knowledge-base/technote.cfm?tn=8231), but don't worry too much about it.)_

Openssl will ask you a series of questions once you enter the command above:

 1. **Country Name** - two letter [ISO 3166-1 code for your country](http://en.wikipedia.org/wiki/ISO_country_codes#Officially_assigned_code_elements) (e.g. "US")
 2. **State or Province** - e.g. "California"
 3. **Locality Name** - e.g. "San Francisco"
 4. **Organization Name** - your DBA, LLC, corp, or personal name. E.g. "Bryce Fisher-Fleig"
 5. **Organizational Unit** - optional, type "." to leave blank
 6. **Common Name** - This is the one you MUST get right. Use the domain name you want to serve over HTTPS. E.g. "bryce.fisher-fleig.org"
 7. **Email address** - This is the email that will be exposed to spammers on the public certificate. You must have it, but consider creating a dedicated email address here for spam to collect in. E.g. "bff.dns.spam@gmail.com"

Later on, we'll provide this private key to CloudFront, but it's vital that you keep the private key very, very private. The security of your website depends on the private key being accessible only to you and CloudFront. You should never email or share this file with anyone for any reason, and you shouldn't store this file Dropbox or Google Drive. If the key is ever compromised, many CA's will provide allow you regenerate your certificate from a new key for free.

### Step 3.C: Upload the CSR to your Certificate Authority

This part was very simple for me with both Comodo and RapidSSL. I did have to re-enter some details that I entered on the CSR such as the domain name.

### Step 3.D: Get validated!

Honestly, verifying that I owned the domain is the worst part every time I've done this. I can't complain about price or customer service, but the process seemed to take forever. Thank yourself for choosing Domain Validation now, because you've saved yourself a week of effort.

There's three ways to complete the DV process:

 1. Click a link sent to a special **email address** (usually administrator@fisher-fleig.org). This seems the hardest to me, because you have to setup the email server ahead of time, add MX records, create email accounts, and possibly setup anti-spam measures. I try never to do this, but this is only option for RapidSSL. If you have to go this route, I highly recommend using [gandi.net](https://www.gandi.net/). They provide all the email setup for you as part of all domain name purchases, and their prices are very reasonable.
 2. Host a **file** at a special url on that domain. This is tricky, but usually easier than email. Comodo supports this option. If you use S3, just upload the file they give you to S3.
 3. Set a dns **TXT Record**. This is easiest possible way. Unfortunately, I've never used a CA that supported this option. If you find one, please tell me in the comments!

If you don't hear anything right away, you failed the domain validation. Don't wait! Contact customer support immediately to help you resolve the issue. I've found support helpful, but the response time was unbearably slow (24hrs or more).

## Step 4: Upload the Certificate to IAM

Amazon stores all of the SSL certificates used by any of the AWS services inside it's Identity Access and Management (IAM) service. In order to upload an SSL certificate you **must create an IAM user with sufficient permissions**. The root account user will not work.


**Create an admin IAM user:**

 1. On the AWS Web Console, go to the IAM service
 2. Click on the "Users" tab
 3. Click "Create New Users"
 4. Enter the first user name. E.g. "SslKingPin"
 5. Click "Create"
 6. Show or download the credentials -- we'll need them a little bit later.
 7. Click on the newly created user
 8. In the user console at the bottom of the page, choose the "Permissions" tab
 9. Click "Attach User Policy"
 10. Copy and paste this JSON snippet into the Policy Editor and click save:

{% highlight json %}
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["*"],
    "Resource": ["*"]
  }]
}
{% endhighlight %}

The JSON snippet above gives this user all privileges, so be careful!

**Setup AWS Cli** For Mac just use homebrew:

{% highlight bash %}
$ brew up
$ brew install aws-cfn-tools awscli
{% endhighlight %}

On Debian/Ubuntu, just apt-get:

{% highlight bash %}
$ sudo apt-get install python python-pip
$ sudo pip install awscli
{% endhighlight %}

For other platforms, see the [official AWS documentation](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html)

**Configure the AWS Cli:**

{% highlight bash %}
$ aws configure
{% endhighlight %}

The only tricky part here is to make sure you enter the IAM credentials for our SslKingPin user. The other settings are a matter of preference.

**Finally! Upload the Damn Certificate:**

 1. Download the zip file from Comodo containing your new SSL certificate.
 2. Unzip all the files into the same directory you have the CSR and private key files.
 3. Follow these steps to upload your ssl certificate to IAM:

{% highlight bash %}
$ cd /path/to/certificate/files/
$ aws iam upload-server-certificate \
  --server-certificate-name bryce_fisher-fleig_org \
  --certificate-body file://bryce_fisher-fleig_org.crt \
  --private-key file://bryce_fisher-fleig_org.key \
  --certificate-chain file://PostivieSSLCA2.crt \
  --path /cloudfront/
{% endhighlight %}

This command is REALLY tricky to get right. So, lets break it down a bit:

 * **server-certificate-name** This is just an alpha-numeric label you see inside AWS consoles. It doesn't matter to anyone except you.
 * **certificate-body** The certificate from Comodo
 * **private-key** This is the very first crypto file we made in Step 3.B.
 * **certificate-chain** Using Comodo, this turned out to be the PositiveSSLCA2.crt file. For RapidSSL, it's [this intermediate certificate chain](https://knowledge.rapidssl.com/support/ssl-certificate-support/index?page=content&actp=CROSSLINK&id=SO26459). It's basically any files between but not including the trusted root certificate and the certificate with your domain name on it.
 * **path** This ends in a slash, and it must start with /cloudfront/.

## Step 5: Configure CloudFront to use SSL

 1. Inside the CloudFront dashboard, edit the distribution you created in step 2.
 2. On the General tab, click "edit"
 3. **SSL Certificate** - choose "Custom SSL Certificate (stored in AWS IAM)" and choose the certificate name from step 4 in the drop down (e.g. "BryceFisherFleigOrg").
 4. **Custom SSL Client Support** - choose "Only Clients that Support Server Name Indication (SNI)". This saves you tons and tons of money, but means older versions of IE and Android can't use the SSL.
 5. Click "Yes, Edit"
 6. Click the "Behaviors" tab
 7. Edit the behavior there.
 8. **Viewer Protocol Policy** - choose "redirect HTTP to HTTPS" to force everyone to use SSL when viewing your site.
 9. Click "Yes, Edit"
 10. Go "back to distributions". You'll see that the status is "In Progress" until the change takes effect all over the world.

## Step 6: Point your DNS to CloudFront

From the CloudFront distribution screen, copy the "Domain Name" value. It will be something like zxy9qwnududu7.cloudfront.net. Go to your DNS nameservers and create a CNAME for this value. These changes will take some time to propagate fully (for me about 10-15 minutes, but your mileage may vary).

## Conclusion

Did you find an error in my tutorial? Did something not make sense? Tweet or comment below and I'd love to help you figure this out. Happy blogging!
