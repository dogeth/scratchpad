#!/bin/bash
if [ $# != 1 ]; then
  echo specify the repository name
else
  pushd ~/Dropbox/git/ > /dev/null
  if [ -f $1 ]; then
    echo $1 repository already exists
  else
    mkdir $1
    cd $1
    git init --bare > /dev/null
    echo created an empty repository called $1, to clone it...
    echo git clone db:$1
  fi
  popd > /dev/null
fi