#!/bin/bash
set -x

BASE_PATH=$(dirname "${BASH_SOURCE}")
BASE_PATH=$(cd "${BASE_PATH}"; pwd)

# comment line that can be modified to push actual changes for testing CI:
# tag to test: v2.7-gmanipon
# this is another comment

VERSION="v2.0"

if (( $# != 4 ))
then
   echo -e "Usage:\n\t$0 <id> <min-sleep> <max-sleep> <tiff-file>" 1>&2
   exit 1
elif (( $3 <= $2 ))
then
   echo -e "[ERROR] max-sleep must be greater than min-sleep" 1>&2
   echo -e "Usage:\n\t$0 <id> <min-sleep> <max-sleep>" 1>&2
   exit 1
fi

#Get random sleep time
let min_sleep=`expr $2`
let max_sleep=`expr $3`
let sleep=`expr $[ $min_sleep + $[ RANDOM % ( $max_sleep - $min_sleep ) ]]`
#Start cpu work
##for i in $(seq $(nproc) ) 
##do
  (
    let x=0
    while [ 1 ]
    do
        let x=$x+$RANDOM
    done
  ) &
##done
PID=$!
sleep $sleep
kill ${PID}
prod=$1
mkdir $prod
tiff=$4
cp $tiff $prod/
#Remove the landsat input product
rm */*.met.json
rm */*.dataset.json
tiff=`basename ${tiff}`
$BASE_PATH/create_dataset_landsat.py $prod $VERSION
$BASE_PATH/create_metadata.py $prod $prod/$tiff $sleep
# convert -size 500x500 $prod/$tiff $prod/$prod.browse.png
# convert -resize 250x250 $prod/$prod.browse.png $prod/$prod.browse_small.png
