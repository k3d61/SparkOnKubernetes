#!/bin/sh

echo "Command: ./sed-config-generator.sh <template-file> <algo> <person> <start-run-id>\n"
template=$1
algo=$2
person=$3
runid=$4
echo "Template: $template\nAlgo: $algo\nPerson: $person\nStartRunID: $runid\n"
if [ -z $template ]; then
    echo "template-file required"
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
if [ -z $runid ]; then
    echo "start-run-id required"
    exit
fi
echo "Script running!!"

outputdir="generated-configs/$algo-$person"
mkdir -p $outputdir"/configs"
csv_file=$outputdir"/_metadata-$algo-$person.csv"

echo algo"\t"person"\t"runid"\t"spark_driver_cores"\t"spark_driver_memory"\t"spark_executor_memory"\t"spark_reducer_maxSizeInFlight"\t"spark_shuffle_compress"\t"spark_shuffle_file_buffer"\t"spark_shuffle_spill_compress"\t"spark_io_compression_codec"\t"spark_rdd_compress"\t"spark_memory_fraction"\t"spark_executor_cores"\t"spark_default_parallelism"\t"spark_locality_wait"\t"spark_task_cpus"\t"spark_executor_instances_i > $csv_file
for spark_driver_cores_i in "1" "2" # "4"
do
for spark_driver_memory_i in "1g" "2g"
do
for spark_executor_memory_i in "2g" "4g" # "8g" "1g" 
do
for spark_reducer_maxSizeInFlight_i in "48m"
do
for spark_shuffle_compress_i in "true" "false"
do
for spark_shuffle_file_buffer_i in "64k" # "128k" "32k" 
do
for spark_shuffle_spill_compress_i in "true" "false"
do
for spark_io_compression_codec_i in  "snappy" "lzf" "zstd" "lz4" 
do
for spark_rdd_compress_i in "false"  "true"
do
for spark_memory_fraction_i in "0.4" "0.6"
do
for spark_executor_cores_i in "2" "4" # "1" 
do
for spark_default_parallelism_i in  "64" # "128" "256" "16"
do
for spark_locality_wait_i in "3s"
do
for spark_task_cpus_i in "1"  "2"
do
for spark_executor_instances_i in "2" "4" # "8"
do
for spark_memory_storageFraction_i in "0.3" # "0.5" "0.7"
do
echo $algo"\t"$person"\t"$runid"\t"$spark_driver_cores_i"\t"$spark_driver_memory_i"\t"$spark_executor_memory_i"\t"$spark_reducer_maxSizeInFlight_i"\t"$spark_shuffle_compress_i"\t"$spark_shuffle_file_buffer_i"\t"$spark_shuffle_spill_compress_i"\t"$spark_io_compression_codec_i"\t"$spark_rdd_compress_i"\t"$spark_memory_fraction_i"\t"$spark_executor_cores_i"\t"$spark_default_parallelism_i"\t"$spark_locality_wait_i"\t"$spark_task_cpus_i"\t"$spark_executor_instances_i >> $csv_file
spark_driver_cores="s/@@spark_driver_cores@@/$spark_driver_cores_i/g"
spark_driver_memory="s/@@spark_driver_memory@@/$spark_driver_memory_i/g"
spark_executor_memory="s/@@spark_executor_memory@@/$spark_executor_memory_i/g"
spark_reducer_maxSizeInFlight="s/@@spark_reducer_maxSizeInFlight@@/$spark_reducer_maxSizeInFlight_i/g"
spark_shuffle_compress="s/@@spark_shuffle_compress@@/$spark_shuffle_compress_i/g"
spark_shuffle_file_buffer="s/@@spark_shuffle_file_buffer@@/$spark_shuffle_file_buffer_i/g"
spark_shuffle_spill_compress="s/@@spark_shuffle_spill_compress@@/$spark_shuffle_spill_compress_i/g"
spark_io_compression_codec="s/@@spark_io_compression_codec@@/$spark_io_compression_codec_i/g"
spark_rdd_compress="s/@@spark_rdd_compress@@/$spark_rdd_compress_i/g"
spark_memory_fraction="s/@@spark_memory_fraction@@/$spark_memory_fraction_i/g"
spark_executor_cores="s/@@spark_executor_cores@@/$spark_executor_cores_i/g"
spark_default_parallelism="s/@@spark_default_parallelism@@/$spark_default_parallelism_i/g"
spark_locality_wait="s/@@spark_locality_wait@@/$spark_locality_wait_i/g"
spark_task_cpus="s/@@spark_task_cpus@@/$spark_task_cpus_i/g"
spark_executor_instances="s/@@spark_executor_instances@@/$spark_executor_instances_i/g"
spark_memory_storageFraction="s/@@spark_memory_storageFraction@@/$spark_memory_storageFraction_i/g"

algo_script="s/@@ALGO@@/$algo/g"
person_script="s/@@PERSON@@/$person/g"
runid_script="s/@@RUNID@@/$runid/g"

 sed -e $algo_script -e $person_script -e $runid_script -e $spark_driver_cores -e $spark_driver_memory -e $spark_executor_memory\
  -e $spark_reducer_maxSizeInFlight -e $spark_shuffle_compress -e $spark_shuffle_file_buffer\
   -e $spark_shuffle_spill_compress -e $spark_io_compression_codec -e $spark_rdd_compress\
    -e $spark_memory_fraction -e $spark_executor_cores -e $spark_default_parallelism -e $spark_locality_wait\
     -e $spark_task_cpus -e $spark_executor_instances\
     -e $spark_memory_storageFraction  $template > "$outputdir/configs/$algo-$person-$runid.conf"
echo "Config generated: $outputdir/configs/$algo-$person-$runid.conf"
runid=$((runid+1))

done
done
done
done
done
done
done
done
done
done
done
done
done
done
done
done
echo "Script finished!!"
