#!/bin/bash
set -e
[ $# -ge 3 ] || { echo 'check ac wa gen [FILE]'; exit 1; }
d=${4:-FILE}
mkdir -p -- "$d"
for p in ac wa gen; do
  g++ -std=c++20 -O2 "$1" -o "$d/$p"
  shift
done
cd -- "$d"
for ((i=1;;i++)); do
  echo "Test $i"
  ./gen > data.in
  ./ac < data.in > ac.out
  ./wa < data.in > wa.out
  diff -bBqZ ac.out wa.out || break
done
