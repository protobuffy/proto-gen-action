#!/bin/sh

origin_repo=$1
destination_repo=$2

echo "Fetching from latest origin $origin_repo"
echo "Fetching from latest destination $destination_repo"

# clean up
rm -rf ./origin
rm -rf ./destination

git clone $origin_repo origin
git clone $destination_repo destination

# Generate proto
mkdir ./destination/go
protoc --proto_path=./origin  --go_out=./destination/go/ --go_opt=paths=source_relative ./origin/*.proto ./origin/**/*.proto

# Push genereted proto to destination
echo "Pushing to destination $2"
cd origin
commit_hash=`git rev-parse HEAD`
cd ../destination

git add .
git commit -m "$commit_hash"
git push

# version/tag generator
