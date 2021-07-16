#!/bin/bash

#NEXT_TAG=$(cat VERSION)
NEXT_TAG=$(cat VERSION | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')
echo "$NEXT_TAG" > VERSION
git commit -am "Version $NEXT_TAG"

MSG=$(cat CHANGELOG.md | xargs | egrep -o "<\!-- START ${NEXT_TAG} -->.*?<\!-- END ${NEXT_TAG} -->")

git tag -s -m "${NEXT_TAG}" ${NEXT_TAG}
git push