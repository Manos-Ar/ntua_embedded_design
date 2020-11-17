#!/bin/bash

for file in outputs/*;
do
  # echo $file
  diff "$file" "output_phods_0_16_16.txt"
done
