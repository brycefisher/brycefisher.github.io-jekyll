#!/bin/bash
echo Printing Unique Categories in alphanumeric order:
egrep -ho "category: .*" _posts/* | sort -u | uniq -i

