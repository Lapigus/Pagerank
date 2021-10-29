#!/bin/bash

# ./script.sh <BUCKET_NAME> 

#PIG
rm tempsPIG.tsv
BEFORE=$SECONDS
pig gs://$1/PigPagerank.py gs://$1/data/vertices gs://$1/data/edges 2
ELAPSED=$(($SECONDS-$BEFORE))
echo -e "${ELAPSED}" >> tempsPIG.tsv 
echo "execution PIG terminée"


#spark
rm tempsSPARK.tsv
BEFORE=$SECONDS
spark-submit pagerank.py edges 2
ELAPSED=$(($SECONDS-$BEFORE))
echo -e "${ELAPSED}" >> tempsSPARK.tsv
echo "execution SPARK terminée"