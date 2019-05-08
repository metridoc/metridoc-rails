#!/bin/bash

if [ -z "$1" -o '!' -f "$1" ]
then
  echo "Invalid input file specified"
  echo "Usage: split.sh <infile> [<chunksize:10000>]"
  echo
  exit 1
fi

in_xml=$1
chunksize=${2:-10000}

header=$'<?xml version="1.0" encoding="UTF-8"?>\n\n<collection xmlns="http://www.loc.gov/MARC21/slim">'
footer="</collection>"

chunk=0
begin=0
end=0
prefix=`basename $1 .xml`
file="${prefix}_${chunk}.xml"

while read -r line
do

  begin=$end
  end=$line

  if [ "$begin" -ne "0" ]
  then
    echo -n "$header" > $file
    dd if=$in_xml of=$file skip=$begin count=$((end-begin)) iflag=skip_bytes,count_bytes oflag=append conv=notrunc 2> /dev/null
    echo "$footer" >> $file
    chunk=$((chunk+1))
    file="${prefix}_${chunk}.xml"
  fi

done < <(grep -ob '<record>' $in_xml | sed 's/:.*//' | stdbuf -o0 awk "{if(NR==1 || NR % $((chunksize)) == 1) print}")

echo -n "$header" > $file
dd if=$in_xml of=$file skip=$end iflag=skip_bytes,count_bytes oflag=append conv=notrunc 2> /dev/null
