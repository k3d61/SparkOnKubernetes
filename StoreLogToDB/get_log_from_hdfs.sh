#!/bin/sh
#su hduser
echo "./get_log_from_hdfs.h <algo> <person>"
algo=$1
person=$2
if [ -z $algo ] 
then
echo "algo required"
exit
fi

if [ -z $person ]
then
echo "person required"
exit 
fi

#runids=$3
#echo $runids
#for runid in runids do
outPutDirectoryName=$algo
mkdir -p "logs/$outPutDirectoryName/"

#hdfs dfs -ls /logs/$algo/$person/
hdfs dfs -get /logs/$algo/$person/ logs/$outPutDirectoryName/
#done
