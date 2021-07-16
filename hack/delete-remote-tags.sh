#!/bin/bash

git fetch

#https://www.computerhope.com/unix/bash/test.htm

#test $(git tag -l | wc -l) -gt 0
#RESULT=$?
#if [ $RESULT -eq 0 ]; then
#  echo success
#  echo "RESULT: $RESULT"
#else
#  echo failed
#fi

if [ $(git tag -l | wc -l) -gt 0 ]; then
  git push origin --delete $(git tag -l)
fi