#!/usr/bin/env bash
TAR_NAME=$1
OBJECT_PATH=$2
DIR_TO_TAR=$3

cd $DIR_TO_TAR
tar -cvf "../$TAR_NAME" $(ls)
cd ..
# aws s3 cp $TAR_NAME s3://"$OBJECT_PATH"