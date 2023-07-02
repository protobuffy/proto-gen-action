#!/bin/sh

git config --global user.email "mrBot@myemail.com"
git config --global user.name "Mr Bot"

origin_repo=$1
destination_repo=$2
branch_target=$3
access_token=$4

echo "Fetching from latest origin $origin_repo"
echo "Fetching from latest destination $destination_repo"

if [ -z "$access_token" ]; then
  git clone https://github.com/$origin_repo.git ~/origin
  mkdir -p ~/origin/validate
  git clone https://github.com/$destination_repo.git ~/destination
else
  git clone https://$access_token@github.com/$origin_repo.git ~/origin
  git clone https://$access_token@github.com/$destination_repo.git ~/destination
fi
# Enable option build later
# git clone https://github.com/bufbuild/protoc-gen-validate.git ~/protoc-gen-validate --branch v1.0.2
# # installs PGV into $GOPATH/bin
# cd ~/protoc-gen-validate && make build;
ln -s $GOPATH/bin/protoc-gen-validate/validate ~/origin/validate
# cd ../
mkdir -p ~/destination/go

# Switch branch if branch_target is available
if [ ! -z "$branch_target" ]; then
  echo "Checkout branch $branch_target"
  cd ~/origin
  git checkout $branch_target
  cd ~/destination
  git fetch origin $branch_target
  exists=`git rev-parse --verify --quiet origin/$branch_target`
  if [ -n "$exists" ]; then
    echo "Switching into $branch_target"
    git checkout $branch_target
  else
    echo "Creating branch $branch_target"
    git branch -c $branch_target
  fi
fi

echo "Generate Proto"

# Generate proto
protoc \
  --proto_path=~/origin \
  --go_out=~/destination/go/ \
  --go_opt=paths=source_relative \
  --validate_out="lang=go:../generated" \
  ~/origin/**/*.proto

cd ~/origin
commit_hash=`git rev-parse HEAD`
cd ~/destination

echo "Commiting $commit_hash"
git add .
git commit -m "$commit_hash"

if [ ! -z "$branch_target" ]; then
  echo "Pushing to $branch_target branch"
  git push origin $branch_target
else
  echo "Pushing to default branch"
  git push
fi
