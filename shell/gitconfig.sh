#!/bin/bash

if [ $# -lt 2 ] ; then
  echo "Usage: $0 name email"
  exit -1
fi

git config user.name $1 --local
git config user.email $2 --local
