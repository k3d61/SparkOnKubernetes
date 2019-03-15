import sys
import sobol_seq
import csv

if len(sys.argv) != 2:
	print("Usage: ./sampler.py <noOfSamples>")
	exit()

noOfSamples = int(sys.argv[1])
noOfParameters = 16

vec = sobol_seq.i4_sobol_generate(noOfParameters, noOfSamples)
ans = []

while i < range(noOfSamples):
	temp = []

	# spark.driver.cores
	if(vec[i][0]<1.0/3): temp.append(1)
	elif(vec[i][0]<2.0/3): temp.append(2)
	else: temp.append(4)

	# spark.driver.memory
	if(vec[i][1]<1.0/2): temp.append('1g')
	else: temp.append('2g')

	# spark.executor.memory
	if(vec[i][2]<1.0/4): temp.append('1g')
	elif(vec[i][2]<2.0/4): temp.append('2g')
	elif(vec[i][2]<3.0/4): temp.append('4g')
	else: temp.append('8g')

	# spark.reducer.maxSizeInFlight
	temp.append('48m')

	# spark.shuffle.compress
	if(vec[i][4]<1.0/2): temp.append('true')
	else: temp.append('false')

	# spark.shuffle.file.buffer
	if(vec[i][5]<1.0/3): temp.append('32k')
	elif(vec[i][5]<2.0/3): temp.append('64k')
	else: temp.append('128k')

	# spark.shuffle.spill.compress
	if(vec[i][6]<1.0/2): temp.append('true')
	else: temp.append('false')

	# spark.io.compression.codec
	if(vec[i][7]<1.0/4): temp.append('lz4')
	elif(vec[i][7]<2.0/4): temp.append('snappy')
	elif(vec[i][7]<3.0/4): temp.append('lzf')
	else: temp.append('zstd')

	# spark.rdd.compress
	if(vec[i][8]<1.0/2): temp.append('false')
	else: temp.append('true')

	# spark.memory.fraction
	if(vec[i][9]<1.0/3): temp.append(0.4)
	elif(vec[i][9]<2.0/3): temp.append(0.6)
	else: temp.append(0.8)

	# spark.executor.cores
	if(vec[i][10]<1.0/3): temp.append(1)
	elif(vec[i][10]<2.0/3): temp.append(2)
	else: temp.append(4)

	# spark.default.parallelism
	if(vec[i][11]<1.0/4): temp.append(16)
	elif(vec[i][11]<2.0/4): temp.append(64)
	elif(vec[i][11]<3.0/4): temp.append(128)
	else: temp.append(256)

	# spark.locality.wait
	temp.append('3s')

	# spark.task.cpus
	if(vec[i][13]<1.0/2): temp.append(1)
	else: temp.append(2)

	# spark.executor.instances
	if(vec[i][14]<1.0/3): temp.append(2)
	elif(vec[i][14]<2.0/3): temp.append(4)
	else: temp.append(8)

	# spark.memory.storageFraction
	if(vec[i][15]<1.0/3): temp.append(0.3)
	elif(vec[i][15]<2.0/3): temp.append(0.5)
	else: temp.append(0.7)

	if 

	i = i + 1
	ans.append(temp)

print(ans)

with open("configs.csv","w+") as my_csv:
    csvWriter = csv.writer(my_csv,delimiter=',')
    csvWriter.writerows(ans)

