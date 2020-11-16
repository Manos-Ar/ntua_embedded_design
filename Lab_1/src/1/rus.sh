#!/bin/bash
FILE="metrics.txt"

if [ -f $FILE ]; then
  rm $FILE
fi

for i in {1..10}
do
   result+=($(./phods))
done


avg=0
max=${result[0]}
min=${result[0]}

for x in ${result[@]};
do
  avg=$(echo $avg + $x | bc -l)
  if [ "$max" -lt "$x" ]; then
    max=${x}
  fi

  if [ "$min" -gt "$x" ]; then
    min=${x}
  fi

done
avg=$(echo $avg / 10 | bc -l)
echo "min: " ${min} >> $FILE
echo "max: " ${max} >> $FILE
echo "avg: " ${avg} >> $FILE
cat $FILE
