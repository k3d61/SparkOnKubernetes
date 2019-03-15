import sys
import sobol_seq
import csv

def get_value(vec,i,j,array,temp):
	array_len = len(array)
	index = 0
	while (index < array_len):
		if(vec[i][j] < (index+1.0)/array_len):
			temp.append(array[index])
			return
		index = index + 1
	return

if len(sys.argv) != 2:
	print("Usage: ./sampler.py <noOfSamples>")
	exit()

noOfSamples = int(sys.argv[1])
noOfParameters = 16

vec = sobol_seq.i4_sobol_generate(noOfParameters, noOfSamples)
ans = []

spark_driver_cores = [1, 2, 4]
spark_driver_memory = ['1g', '2g', '4g'] 
spark_executor_memory = ['1g', '2g', '4g', '8g']
spark_reducer_maxSizeInFlight = ['48m']
spark_shuffle_compress = ['true', 'false']
spark_shuffle_file_buffer = ['64k'] # '32k' 
spark_shuffle_spill_compress = ['true']  
spark_io_compression_codec = ['lz4'] # 'snappy', 'lzf', 'lzstd'
spark_rdd_compress = ['false']
spark_memory_fraction = ['0.6']
spark_executor_cores = ['1', '2', '4']
spark_default_parallelism = ['16', '64', '128', '256']
spark_locality_wait = ['3s']
spark_task_cpus = ['1']
spark_executor_instances = ['2', '4', '8']
spark_memory_storageFraction = ['0.3', '0.5']

while i < range(noOfSamples):
	temp = []

	# spark.driver.cores
	get_value(vec, i , 0, spark_driver_cores, temp)

	# spark.driver.memory
	get_value(vec, i , 1, spark_driver_memory, temp)

	# spark.executor.memory
	get_value(vec, i , 2, spark_executor_memory, temp)
	
	# spark.reducer.maxSizeInFlight
	get_value(vec, i , 3, spark_reducer_maxSizeInFlight, temp)

	# spark.shuffle.compress
	get_value(vec, i , 4, spark_shuffle_compress, temp)

	# spark.shuffle.file.buffer
	get_value(vec, i , 5, spark_shuffle_file_buffer, temp)

	# spark.shuffle.spill.compress
	get_value(vec, i , 6, spark_shuffle_spill_compress, temp)

	# spark.io.compression.codec
	get_value(vec, i , 7, spark_io_compression_codec, temp)	

	# spark.rdd.compress
	get_value(vec, i , 8, spark_rdd_compress, temp)

	# spark.memory.fraction
	get_value(vec, i , 9, spark_memory_fraction, temp)

	# spark.executor.cores
	get_value(vec, i , 10, spark_executor_cores, temp)

	# spark.default.parallelism
	get_value(vec, i , 11, spark_default_parallelism, temp)

	# spark.locality.wait
	get_value(vec, i , 12, spark_locality_wait, temp)

	# spark.task.cpus
	get_value(vec, i , 13, spark_task_cpus, temp)

	# spark.executor.instances
	get_value(vec, i , 14, spark_executor_instances, temp)

	# spark.memory.storageFraction
	get_value(vec, i , 15, spark_memory_storageFraction, temp)


	i = i + 1
	ans.append(temp)

print(ans)

with open("configs.csv","w+") as my_csv:
    csvWriter = csv.writer(my_csv,delimiter=',')
    csvWriter.writerows(ans)

