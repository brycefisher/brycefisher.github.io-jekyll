#!/bin/sh

aws s3 sync --profile=God --delete _site/ s3://bryce-fisher-fleig-org
