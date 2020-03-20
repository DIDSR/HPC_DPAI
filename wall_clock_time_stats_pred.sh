# DIR=/scratch/mikem/UserSupport/weizhe.li/runs_process/wnorm_448_400_7689398
# SUBDIRS=`ls -1 $DIR`

DIR=/scratch/mikem/UserSupport/weizhe.li/runs_process_cn_V2_False/testing_wnorm_448_400_7694088

PREFIX=test
SUBDIRS=`ls -1 $DIR | grep $PREFIX`

STAT_FILE=timing_pred.txt
rm -f $STAT_FILE

for SD in $SUBDIRS
do
  echo "Processing $SD subdirectory..."
  echo $SD
  
  PREFIX1=$SD
  find "$DIR"/"$SD"/sysout -name "$PREFIX1"* | xargs grep "seconds" >> $STAT_FILE
done

sort -k2 -n $STAT_FILE > "$STAT_FILE"_sorted.txt 

awk '{ print $2 }' "$STAT_FILE"_sorted.txt > "$STAT_FILE"_sorted_2ndc.txt
