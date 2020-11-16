#!/bin/bash

for i in {1..10}
do
   result+=($(./phods))
done

echo "${result[@]}"

avg=0
max=${result[0]}
min=${result[0]}
echo $min $max $avg

for x in "${result[@]}";
do
  avg=$(echo $avg + $x | bc -l)
  # echo $avg
  if [[ "$max" < "$x" ]]; then
    max=${x}
  fi

  if [[ "$min" > "$x" ]]; then
    min=${x}
  fi
done
avg=$(echo $avg / 10 | bc -l)
echo $min $max $avg
