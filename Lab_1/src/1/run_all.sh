#!/bin/bash

exec=( "phods" "phods_fusion" "phods_unroll"  "phods_data_reuse" )

dir="metrics"

if [ -d "${dir}" ]; then
	rm -rf "${dir}"
	mkdir "${dir}"
else
	mkdir "${dir}"
fi

for e in ${exec[@]};
do
  ./run.sh $e
done
