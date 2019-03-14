#!/bin/sh

config_runid_file=$1
algo=$2
person=$3
echo "Command: ./create-spark-bench-config.sh <copy_config_runids> <algo> <person>\n"
if [ -z $config_runid_file ]; then
echo "config_runid_file required"
exit
fi
if [ -z $algo ]; then
    echo "algo required"
    exit
fi
if [ -z $person ]; then
    echo "person required"
    exit
fi

echo "Removing copied-configs/$algo-$person directory and its files"
rm -r copied-configs/$algo-$person
echo "Creating copied-configs/$algo-$person directory"
mkdir -p copied-configs/$algo-$person
merged_conf_file="copied-configs/$algo-$person/_merged-$algo-$person.conf"
echo "Script running!!"
# sed 's/\t/-/g' $config_runid_file | while read -r line; do cp "generated-configs/kmeans-sapan/configs/$line.conf" "copied-configs/$line.conf"; done
echo "spark-bench = {
  spark-submit-parallel = false
  spark-submit-config = [" > $merged_conf_file
cat $config_runid_file | while read -r line; do \
 cat "generated-configs/$algo-$person/configs/$algo-$person-$line.conf" >> $merged_conf_file;\
 echo "," >> $merged_conf_file;\
 cp "generated-configs/$algo-$person/configs/$algo-$person-$line.conf" "copied-configs/$algo-$person/$algo-$person-$line.conf";\
 echo "copied-configs/$algo-$person/$algo-$person-$line.conf"; done
# cat copied-configs/$algo-$person/* > copied-configs/$algo-$person/_merged-config.conf
echo "]}" >> $merged_conf_file
echo "Script finished!!"
