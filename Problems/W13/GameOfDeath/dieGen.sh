#!/bin/bash
 
h=$((RANDOM%15+1))
w=$((RANDOM%15+1))
 
echo "$h" "$w"
for ((i = 0;i != $h;++i)) ; do
   for ((j = 0;j != $w;++j)) ; do
      if ((RANDOM%2 == 0)) ; then
         printf " "
      else
         printf "*"
      fi
   done
   printf "\n"
done
