#!/bin/bash


function validate1 {
  min=$1
  max=$2
  ch=$3
  pw=$4
  declare -A arr
  for ((i = 0 ; i < ${#pw} ; i++)); do
    actual_char=${pw:$i:1}
    arr[(($actual_char))]=${arr[(($actual_char))]-0}
    arr[(($actual_char))]=$((${arr[(($actual_char))]} + 1))
  done

  if [ -z "${arr[(($ch))]}" ]; then
    return 1
  fi
  if [ "${arr[(($ch))]}" -ge "$min" ] && [ "${arr[(($ch))]}" -le "$max" ];
  then 
    return 0
  fi

  return 1
}


function validate2 {
  min=$(($1-1))
  max=$(($2-1))
  ch=$3
  pw=$4

  ch_at_min=${pw:$min:1}
  ch_at_max=${pw:$max:1}
  result=1
  if [ "$ch_at_min" == "$ch" ]
  then
    result=0
  fi

  if [ "$ch_at_max" == "$ch" ]
  then
    result=$((result ^ 1))
  fi

  return $result
}

task1_sum=0
task2_sum=0
while read STR; do
  min=$(echo $STR | cut -f1 -d-)
  max=$(echo $STR | cut -f2 -d- | cut -f1 -d " ")
  ch=$(echo $STR | cut -f2 -d " " | cut -c1)
  pw=$(echo $STR | cut -f3 -d " " | xargs)
  if validate1 $min $max $ch $pw; then
    task1_sum=$((task1_sum+1))
  fi
  if validate2 $min $max $ch $pw; then
    task2_sum=$((task2_sum+1))
  fi
done <../input.txt

echo "Task1 solution: $task1_sum"
echo "Task2 solution: $task2_sum"

