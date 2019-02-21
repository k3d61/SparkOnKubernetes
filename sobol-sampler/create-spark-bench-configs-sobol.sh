#!/bin/sh


echo "Command: ./create-spark-bench-configs-sobol.sh <configs_csv> <template-file> <algo> <person> <start-run-id>\n"
configs_csv=$1
template=$2
algo=$3
person=$4
runid=$5
echo "Configs_csv: $configs_csv\nTemplate: $template\nAlgo: $algo\nPerson: $person\nStartRunID: $runid\n"
if [ -z $configs_csv ]; then
    echo "configs-csv-file required"
    exit
fi
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

outputdir="generated-configs/$algo-$person-sobol-$runid"

echo "Removing generated-configs/$algo-$person-sobol-$runid directory and its files"
rm -r $outputdir
echo "Creating generated-configs/$algo-$person-sobol-$runid/configs directory"
mkdir -p $outputdir"/configs"

csv_file=$outputdir"/_metadata-$algo-$person-sobol.csv"
merged_conf_file="$outputdir/_merged-$algo-$person-sobol.conf"

echo "spark-bench = {
  spark-submit-parallel = false
  spark-submit-config = [" > $merged_conf_file

sed 's/\r//' $configs_csv > $configs_csv".bak"
mv $configs_csv".bak" $configs_csv

cat $configs_csv | while IFS=',' read \
spark_driver_cores_i spark_driver_memory_i spark_executor_memory_i spark_reducer_maxSizeInFlight_i spark_shuffle_compress_i spark_shuffle_file_buffer_i spark_shuffle_spill_compress_i spark_io_compression_codec_i spark_rdd_compress_i spark_memory_fraction_i spark_executor_cores_i spark_default_parallelism_i spark_locality_wait_i spark_task_cpus_i spark_executor_instances_i spark_memory_storageFraction_i; \
do
echo $algo"\t"$person"\t"$runid"\t"$spark_driver_cores_i"\t"$spark_driver_memory_i"\t"$spark_executor_memory_i"\t"$spark_reducer_maxSizeInFlight_i"\t"$spark_shuffle_compress_i"\t"$spark_shuffle_file_buffer_i"\t"$spark_shuffle_spill_compress_i"\t"$spark_io_compression_codec_i"\t"$spark_rdd_compress_i"\t"$spark_memory_fraction_i"\t"$spark_executor_cores_i"\t"$spark_default_parallelism_i"\t"$spark_locality_wait_i"\t"$spark_task_cpus_i"\t"$spark_executor_instances_i"\t"$spark_memory_storageFraction_i >> $csv_file
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
runid_script="s/@@RUNID@@/sobol-$runid/g"

 sed -e $algo_script -e $person_script -e $runid_script -e $spark_driver_cores -e $spark_driver_memory -e $spark_executor_memory\
  -e $spark_reducer_maxSizeInFlight -e $spark_shuffle_compress -e $spark_shuffle_file_buffer\
   -e $spark_shuffle_spill_compress -e $spark_io_compression_codec -e $spark_rdd_compress\
    -e $spark_memory_fraction -e $spark_executor_cores -e $spark_default_parallelism -e $spark_locality_wait\
     -e $spark_task_cpus -e $spark_executor_instances\
     -e $spark_memory_storageFraction  $template > "$outputdir/configs/$algo-$person-sobol-$runid.conf"
echo "Config generated: $outputdir/configs/$algo-$person-sobol-$runid.conf"
cat "$outputdir/configs/$algo-$person-sobol-$runid.conf"  >> $merged_conf_file
echo "," >> $merged_conf_file
runid=$((runid+1))
done
echo "]}" >> $merged_conf_file
echo "Script finished!!"
echo "Merged sobol config generated @ $merged_conf_file"
