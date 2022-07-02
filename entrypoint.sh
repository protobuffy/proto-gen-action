#!/bin/sh

git config --global user.email "mrBot@myemail.com"
git config --global user.name "Mr Bot"

origin_repo=$1
destination_repo=$2
branch_target=$3
access_token=$4

echo "Fetching from latest origin $origin_repo"
echo "Fetching from latest destination $destination_repo"

# clean up
rm -rf ./origin
rm -rf ./destination

if [ -z "$access_token" ]; then
    git clone https://github.com/$origin_repo.git origin
    git clone https://github.com/$destination_repo.git destination
else
    git clone https://$access_token@github.com/$origin_repo.git origin
    git clone https://$access_token@github.com/$destination_repo.git destination
fi

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
