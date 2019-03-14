#!/bin/sh
#su hduser
echo "./upload_to_db.h <algo> <person>"
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

outPutDirectoryName=logs/"$algo"/"$person"
echo $outPutDirectoryName

for x in `ls "$outPutDirectoryName"`;
do
        pathToXRun="$outPutDirectoryName/$x"
        #echo $x/`ls $pathToXRun`; 
        benchMarkFilePath=$pathToXRun/benchmark-output.csv/*.csv
        sparklensDirPath=$pathToXRun/sparklens
        jsonFilePath=$sparklensDirPath/*.json
        txtFilePath=$sparklensDirPath/*.txt

        test -e $benchMarkFilePath
        if [ $? -ne 0 ]; then
                #echo "file does not exist"      
                continue
        fi

        echo $benchMarkFilePath
        echo $jsonFilePath
        echo $txtFilePath

        #Usage: ./simplifier.py <LogFile> <JsonFile> <CsvFile>
        ./simplifier.py $txtFilePath $jsonFilePath $benchMarkFilePath > insertQueries.sql
        echo "" 

done


