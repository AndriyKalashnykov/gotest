#!/bin/bash

NEXT_TAG=$(cat VERSION)
MSG=$(cat CHANGELOG.md | xargs | egrep -o "<\!-- START ${NEXT_TAG} -->.*?<\!-- END ${NEXT_TAG} -->")

git tag -s -m "${NEXT_TAG}" ${NEXT_TAG}