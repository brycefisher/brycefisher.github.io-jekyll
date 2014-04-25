---
title: "Setting Up SSL on AWS CloudFront and S3"
layout: "post"
excerpt: "I've just setup this blog using an S3 bucket as the origin server, CloudFront as my CDN, and SSL for under $10. Since there were so many articles to read along the way, I'm gathering up what worked for me all in one place."
category: aws
---

I've just setup this blog using an S3 bucket as the origin server, CloudFront as my CDN, and SSL for under $10. Since there were so many articles to read along the way, I'm gathering up what worked for me all in one place.

I'll assume you're already using Jekyll or another static site generator to create HTML files that you want hosted on S3 instead of Github pages (which are awesome if you don't want to use SSL).

Throughout this tutorial I'll use the domain name of this blog to help you understand what files are what as we go.

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

## Step 3: Purchase an SSL Certificate on the Cheap

The cheapest place I can find legit certs is from [cheapestssls.com](http://www.cheapestssls.com/) (Ironically, they don't serve their marketing pages over SSL.) 

I chose the Comodo Positive SSL certificate for this domain because I only want to serve one domain using this certificate, and the price was $6.50.

Once you've paid for a certificate, you'll need to generate two cryptographic files: a private key, and a certificate signing request (CSR).

### Step 3.A: Make a private key

    $ mkdir bff-certs && cd bff-certs
    $ openssl genrsa 2048 > bryce-fisher-fleig-org.key

### Step 3.B: Make a CSR

    $ openssl req -new -key bryce-fisher-fleig-org.key -out bryce-fisher-fleig-org.csr

Openssl will ask you a series of questions once you enter the command above:

 1. **Country Name** - two letter [ISO 3166-1 code for your country](http://en.wikipedia.org/wiki/ISO_country_codes#Officially_assigned_code_elements) (e.g. "US")
 2. **State or Province** - e.g. "California" 
 3. **Locality Name** - e.g. "San Francisco"
 4. **Organization Name** - your DBA, LLC, corp, or personal name. E.g. "Bryce Fisher-Fleig"
 5. **Organizational Unit** - optional, type "." to leave blank
 6. **Common Name** - This is the one you MUST get right. Use the domain name you want to serve over HTTPS. E.g. "bryce.fisher-fleig.org"
 7. **Email address** - This is the email that will be exposed to spammers on the public certificate. You must have it, but consider creating a dedicated email address here for spam to collect in. E.g. "bff.dns.spam@gmail.com"

### Step 3.C: Upload the CSR to your Certificate Authority

I chose Comodo, and this part was very simple. I did have to re-enter some details that I entered on the CSR such as the domain name.

### Step 3.D: Get verified!

Honestly, verifying that I owned the domain was the worst part of this whole experience. I can't complain about price or customer service, but the process seemed to drag on for a while.

Eventually, Comodo required me to upload a file to the root domain (fisher-fleig.org) despite the fact that I wanted a cert only for a subdomain (bryce.fisher-fleig.org). I logged into their online portal to download a file. I recommend uploading this file both to the subdomain and root domain from the beginning. Make sure that all line breaks and whitespace in your file match exactly (no trailing whitespace or CRLFs). Then click the button inside their portal to verify your domain.

If you don't hear anything right away, you failed the verification. Don't wait! Contact customer support immediately to help you resolve the issue. I found support helpful, but the turn around time was slow.

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

    $ brew up
    $ brew install aws-cfn-tools aws-iam-tools

On Debian/Ubuntu, just apt-get:

    $ sudo apt-get install python python-pip
    $ sudo pip install awscli

For other platforms, see the [official AWS documentation](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html)

**Configure the AWS Cli:**

    $ aws configure

The only tricky part here is to make sure you enter the IAM credentials for our SslKingPin user. The other settings are a matter of preference.

**Finally! Upload the Damn Certificate:**

 1. Download the zip file from Comodo containing your new SSL certificate.
 2. Unzip all the files into the same directory you have the CSR and private key files.
 3. Follow these steps to upload your ssl certificate to IAM:

{% highlight bash %}
    $ cd /path/to/certificate/files/
    $ aws iam upload-server-certificate \
    --server-certificate-name BryceFisherFleigOrg \
    --certificate-body file://bryce_fisher-fleig_org.crt \
    --private-key file://bryce-fisher-fleig-org.key \
    --certificate-chain file://PostivieSSLCA2.crt \
    --path /cloudfront/bryce-fisher-fleig/
{% endhighlight %}

This command is REALLY tricky to get right. So, lets break it down a bit:

 * **server-certificate-name** This is just an alpha-numeric label you see inside AWS consoles. It doesn't matter to anyone except you.
 * **certificate-body** The certificate from Comodo
 * **private-key** This is the very first crypto file we made in Step 3.A. 
 * **certificate-chain** Using Comodo, this turned out to be the PositiveSSLCA2.crt file. It's basically any files between but not including the trusted root certificate and the certificate with your domain name on it. Please reach out in the comments or StackOverflow if you have questions about this.
 * **path** This ends in a slash, and it must start with /cloudfront/. Choose anything alpha-numeric-dashes you want where I put "bryce-fisher-fleig".

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
