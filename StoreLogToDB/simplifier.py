#!/usr/bin/env python3

import sys
import json
import csv

if len(sys.argv) != 4:
	print("Usage: ./simplifier.py <LogFile> <JsonFile> <CsvFile>")
	print("test")
	
	exit()

LogFile = sys.argv[1]
JsonFile = sys.argv[2]
CsvFile = sys.argv[3]
input_data_size = ""

lines = [line.rstrip('\n') for line in open(LogFile)]
with open(JsonFile , encoding='utf-8') as jsonFile:
	data = json.loads(jsonFile.read())


appID = data['appInfo']['applicationID']
appDuration = data['appInfo']['endTime'] - data['appInfo']['startTime']
prevStart = data['appInfo']['startTime']

TotalTaskCount = 0
metrics = []
totalHosts						= ""
maxConcurrentHosts				= ""
totalExecutors					= ""
maxConcurrentExecutors			= ""
driverWallClockTime				= ""
executorWallClockTime			= ""
timeWithInfiResource			= ""
minTimeWithPerfectParallelism	= ""
timeWithSingleExecutorCore		= ""
totalCores						= ""

#### CSV PARSING
appName = ""
sparkDriverCores = ""
sparkDriverMemory = ""
sparkExecutorMemory = ""
sparkReducerMaxSizeInFlight = ""
sparkShuffleCompress = ""
sparkShuffleFileBuffer = ""
sparkShuffleSpillCompress = ""
sparkIoCompressionCodec = ""
sparkRddCompress = ""
sparkMemoryFraction = ""
sparkExecutorCores = ""
sparkDefaultParallelism = ""
sparkLocalityWait = ""
sparkTaskCpus = ""
sparkExecutorInstances = ""
sparkMemoryStorageFraction = ""

with open(CsvFile) as csvfile:
	readCSV = csv.reader(csvfile, delimiter=',')
	s = 0
	names = []
	values = []
	for row in readCSV:
		if s==0:
			names = row
		else:
			values = row
		s += 1

	for i in range(len(names)):
		if names[i]=="spark.driver.cores":
			sparkDriverCores = values[i]
		elif names[i]=="spark.driver.memory":
			sparkDriverMemory = values[i]
		elif names[i]=="spark.app.name":
			appName = values[i]
		elif names[i]=="spark.executor.memory":
			sparkExecutorMemory = values[i]
		elif names[i]=="spark.reducer.maxSizeInFlight":
			sparkReducerMaxSizeInFlight = values[i]
		elif names[i]=="spark.shuffle.compress":
			sparkShuffleCompress = values[i]
		elif names[i]=="spark.shuffle.file.buffer":
			sparkShuffleFileBuffer = values[i]
		elif names[i]=="spark.shuffle.spill.compress":
			sparkShuffleSpillCompress = values[i]
		elif names[i]=="spark.io.compression.codec":
			sparkIoCompressionCodec = values[i]
		elif names[i]=="spark.rdd.compress":
			sparkRddCompress = values[i]
		elif names[i]=="spark.memory.fraction":
			sparkMemoryFraction = values[i]
		elif names[i]=="spark.executor.cores":
			sparkExecutorCores = values[i]
		elif names[i]=="spark.default.parallelism":
			sparkDefaultParallelism = values[i]
		elif names[i]=="spark.locality.wait":
			sparkLocalityWait = values[i]
		elif names[i]=="spark.task.cpus":
			sparkTaskCpus = values[i]
		elif names[i]=="spark.executor.instances":
			sparkExecutorInstances = values[i]
		elif names[i]=="spark.memory.storageFraction":
			sparkMemoryStorageFraction = values[i]
		elif names[i]=="input":
			input_file_size = values[i].split('/')[-1].split('-')[-1].split('gb')[0]



### LOG PARSING
i = 0
while i < len(lines):
	lines[i] = lines[i].strip()
	lineVector = lines[i].split()
	if len(lineVector) == 0:
		i += 1
		continue
	if lineVector[0]=="AggregateMetrics":
		TotalTaskCount = int(lineVector[len(lineVector)-1])
		for j in range(i+2, i+19):
			lineVector = lines[j].split()
			if(len(lineVector) == 5):
				metrics.append(lineVector[3])
				metrics.append(lineVector[1])
			else:
				metrics.append(lineVector[5])
				metrics.append(lineVector[1])

		i = i+19
	if lineVector[0]=="Total" and lineVector[1]=="Hosts":
		totalHosts = lineVector[2][:-1]
		maxConcurrentHosts = lineVector[len(lineVector)-1]
	if lineVector[0]=="Total" and lineVector[1]=="Executors":
		totalExecutors =  lineVector[2][:-1]
		maxConcurrentExecutors = lineVector[len(lineVector)-1]
	if(len(lineVector)>3 and lineVector[0]+lineVector[1]+lineVector[2]=="DriverWallClockTime"):
		driverWallClockTime = int(lineVector[3][:-1])*60 + int(lineVector[4][:-1])
	if(len(lineVector)>3 and lineVector[0]+lineVector[1]+lineVector[2]=="ExecutorWallClockTime"):
		executorWallClockTime = int(lineVector[3][:-1])*60 + int(lineVector[4][:-1])
	if(len(lineVector)>3 and lineVector[0]+lineVector[1]+lineVector[2]=="Minimumpossibletime"):
		timeWithInfiResource = int(lineVector[len(lineVector) - 2][:-1])*60 + int(lineVector[len(lineVector) - 1][:-1])
		i = i + 1
		lineVector = lines[i].split()
		minTimeWithPerfectParallelism = int(lineVector[len(lineVector) - 2][:-1])*60 + int(lineVector[len(lineVector) - 1][:-1])
		i = i + 1
		lineVector = lines[i].split()
		timeWithSingleExecutorCore = int(lineVector[len(lineVector) - 2][:-1])*60 + int(lineVector[len(lineVector) - 1][:-1])
	if lineVector[0]=="Total" and lineVector[1]=="cores":
		totalCores =  lineVector[len(lineVector)-1]
	i = i + 1
	

CurrentTaskCount = 0
JobCount = 0
StageCount = 0

while CurrentTaskCount < TotalTaskCount:
	jobStartTime = data['jobMap'][str(JobCount)]['startTime']
	jobEndTime = data['jobMap'][str(JobCount)]['endTime']
	jobStartUp = int(jobStartTime) - int(prevStart)
	jobDuration = jobEndTime - jobStartTime
	prevStart = jobStartTime
	mystages = 0
	for i in data['jobMap'][str(JobCount)]['stageMap']:
		# data['jobMap'][str(JobCount)]['stageMap'][i]
		mystages += 1
		stageStartTime = data['jobMap'][str(JobCount)]['stageMap'][str(StageCount)]['startTime']
		stageEndTime = data['jobMap'][str(JobCount)]['stageMap'][str(StageCount)]['endTime']
		stageDuration = int(stageEndTime) - int(stageStartTime)
		startUpTime = int(stageStartTime) - int(prevStart)
		prevStart = stageEndTime
		NumTask = int(data['jobMap'][str(JobCount)]['stageMap'][str(StageCount)]['numberOfTasks'])
		print("insert into stageTable values ('"
			+ appID + "','" 
			+ str(StageCount) + "','" 
			+ str(JobCount) + "','" 
			+ str(stageDuration) + "','"
			+ str(startUpTime) + "','"
			+ str(NumTask)
			+ "');")
		
		# TASK calculation
		CurrentTaskCount += NumTask
		TaskTimes = data['jobMap'][str(JobCount)]['stageMap'][str(StageCount)]['taskExecutionTimes']
		TaskTimes = (TaskTimes.split('['))[1].split(']')[0]
		TimeArray = list(map(int, TaskTimes.split(',')))
		TaskMem = data['jobMap'][str(JobCount)]['stageMap'][str(StageCount)]['taskPeakMemoryUsage']
		TaskMem = (TaskMem.split('['))[1].split(']')[0]
		MemArray = list(map(int, TaskMem.split(',')))
		task = 0
		for j in MemArray:
			print("insert into taskTable values ('"
				+ appID + "','" 
				+ str(StageCount) + "','" 
				+ str(JobCount) + "','" 
				+ str(task) + "','"
				+ str(TimeArray[task]) + "','"
				+ str(j)
				+ "');")
			task += 1
		StageCount += 1
	prevStart = jobEndTime
	print("insert into jobTable values ('"
		+ appID + "','" 
		+ str(JobCount) + "','" 
		+ str(jobDuration) + "','"
		+ str(jobStartUp) + "','"
		+ str(mystages)
		+ "');")
	JobCount += 1


print("insert into appTable values ('" 
	+ appID + "','" 
	+ appName + "','"
	+ str(appDuration) + "','" 
	+ str(TotalTaskCount) + "','" 
	+ str(StageCount) + "','" 
	+ str(JobCount) + "','" 
	+ input_file_size + "','"
	
	+ metrics[0] + "','" 
	+ metrics[2] + "','" 
	+ metrics[4] + "','" 
	+ metrics[6] + "','" 
	+ metrics[8] + "','" 
	+ metrics[10] + "','" 
	+ metrics[12] + "','" 
	+ metrics[14] + "','" 
	+ metrics[16] + "','" 
	+ metrics[18] + "','" 
	+ metrics[20] + "','" 
	+ metrics[22] + "','" 
	+ metrics[24] + "','" 
	+ metrics[26] + "','" 
	+ metrics[28] + "','" 
	+ metrics[30] + "','" 
	+ metrics[32] + "','" 
	
	+ metrics[0 + 1 ] + "','" 
	+ metrics[2 + 1 ] + "','" 
	+ metrics[4 + 1 ] + "','" 
	+ metrics[6 + 1 ] + "','" 
	+ metrics[8 + 1 ] + "','" 
	+ metrics[10 + 1 ] + "','" 
	+ metrics[12 + 1 ] + "','" 
	+ metrics[14 + 1 ] + "','" 
	+ metrics[16 + 1 ] + "','" 
	+ metrics[18 + 1 ] + "','" 
	+ metrics[20 + 1 ] + "','" 
	+ metrics[22 + 1 ] + "','" 
	+ metrics[24 + 1 ] + "','" 
	+ metrics[26 + 1 ] + "','" 
	+ metrics[28 + 1 ] + "','" 
	+ metrics[30 + 1 ] + "','" 
	+ metrics[32 + 1 ] + "','" 
	
	+ str(totalHosts) + "','"
	+ str(maxConcurrentHosts) + "','"
	+ str(totalExecutors) + "','"
	+ str(maxConcurrentExecutors) + "','"
	+ str(driverWallClockTime) + "','"
	+ str(executorWallClockTime) + "','"
	+ str(timeWithInfiResource) + "','"
	+ str(minTimeWithPerfectParallelism) + "','"
	+ str(timeWithSingleExecutorCore) + "','"
	+ str(totalCores) + "','"

	+ str(sparkDriverCores) + "','"
	+ str(sparkDriverMemory) + "','"
	+ str(sparkExecutorMemory) + "','"
	+ str(sparkReducerMaxSizeInFlight) + "','"
	+ str(sparkShuffleCompress) + "','"
	+ str(sparkShuffleFileBuffer) + "','"
	+ str(sparkShuffleSpillCompress) + "','"
	+ str(sparkIoCompressionCodec) + "','"
	+ str(sparkRddCompress) + "','"
	+ str(sparkMemoryFraction) + "','"
	+ str(sparkExecutorCores) + "','"
	+ str(sparkDefaultParallelism) + "','"
	+ str(sparkLocalityWait) + "','"
	+ str(sparkTaskCpus) + "','"
	+ str(sparkExecutorInstances) + "','"
	+ str(sparkMemoryStorageFraction) 
	+ "');")
