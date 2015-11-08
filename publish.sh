#!/bin/sh
set -eu

#######################################################
# Requirements:
# - valid S3 credentials with write permissions
# - the aws cli (http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
#
# Usage:
#
#   ./publish.sh
#
# Publish to production:
#
#   ./publish.sh prod
#######################################################

DEST_BUCKET="bryce-fisher-fleig-org-$TRAVIS_BRANCH"
DEST_URL="http://$DEST_BUCKET.s3-website-us-west-1.amazonaws.com/"

echo "Creating bucket $DEST_BUCKET"
aws s3 mb s3://$DEST_BUCKET --region us-west-1 2> /dev/null \
  || echo "Bucket already exists!"

echo "Publishing files from ./_site/ to S3 Bucket $DEST_BUCKET"
aws s3 website s3://$DEST_BUCKET --index-document "index.html"
aws s3 sync \
    --delete \
    --acl public-read \
    --storage-class REDUCED_REDUNDANCY \
    _site/ "s3://$DEST_BUCKET"
echo "Finished publishing to $DEST_BUCKET. See results at:"
echo $DEST_URL
