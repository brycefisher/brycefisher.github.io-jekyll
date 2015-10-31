#!/bin/sh

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

PROD_BUCKET="bryce-fisher-fleig-org"
PROD_URL="https://bryce.fisher-fleig.org/"
STAGE_BUCKET="bryce-fisher-fleig-org-stage"
STAGE_URL="http://bryce-fisher-fleig-org-stage.s3-website-us-west-1.amazonaws.com/"

OUTPUT_URL=$STAGE_URL
DEST_BUCKET=$STAGE_BUCKET
if [ $1 = "prod" ]; then
    DEST_BUCKET=$PROD_BUCKET
    OUTPUT_URL=$PROD_URL
fi

echo "Publishing files from ./_site/ to S3 Bucket $DEST_BUCKET"
aws s3 sync --delete _site/ "s3://$DEST_BUCKET"
echo "Finished publishing to $DEST_BUCKET"
echo "See $OUTPUT_URL to inspect the results"
