#!/bin/sh

aws s3 sync --delete _site/ s3://bryce-fisher-fleig-org
