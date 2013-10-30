#!/bin/bash
cd submissions/queued/$1
for i in {1..8}; do 
   echo $i
   $2 < ../../../tests/$i.in > $i.out
   diff $i.out ../../../tests/$i.out
done
cd ../../..
