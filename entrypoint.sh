#!/bin/sh

origin=$1
destination=$2

echo "Fetching from latest origin $1"
echo "Fetching from latest origin $2"

git clone $1 origin
git clone $2 destination

echo "Pushing to destination $2"
# pull origin

# push generated proto to dest repo
