#!/bin/sh

echo "baen"
message=$1

if [ ! -z "$1" ]
then
   git add * 
   git commit -m "$message"
   git push origin main
else
   echo  "Commit message is not provided"
fi