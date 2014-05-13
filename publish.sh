#!/bin/sh

aws s3 sync --profile=bryce --delete _site/ s3://bryce-fisher-fleig-org
