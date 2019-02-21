drop table if exists taskTable cascade;

create table taskTable
	(
		applicationID	varchar(100),
		stageID			varchar(20),
		jobID			varchar(20),
		taskID			varchar(20),
		timeTaken		varchar(20),
		peakMemory		varchar(20),
		primary key(applicationID,stageID,jobID,taskID)
	);

drop table if exists stageTable cascade;

create table stageTable
	(
		applicationID	varchar(100),
		stageID			varchar(20),
		jobID			varchar(20),
		duration		varchar(20),
		startUpTime		varchar(20),
		numberOfTask	varchar(20),
		primary key(applicationID,stageID,jobID)
	);

drop table if exists jobTable cascade;

create table jobTable
	(
		applicationID	varchar(100),
		jobID			varchar(20),
		duration		varchar(20),
		startUpTime		varchar(20),
		numberOfStage	varchar(20),
		primary key(applicationID,jobID)
	);

drop table if exists appTable cascade;

create table appTable
	(
		applicationID					varchar(100),
		appName							varchar(100),
		duration						varchar(20),
		numberOfTask					varchar(20),
		numberOfStage					varchar(20),
		numberOfJob						varchar(20),
		

		diskBytesSpilledMax				varchar(20),
		executorRuntimeMax				varchar(20),
		inputBytesReadMax				varchar(20),
		jvmGCTimeMax					varchar(20),
		memoryBytesSpilledMax			varchar(20),
		outputBytesWrittenMax			varchar(20),
		peakExecutionMemoryMax			varchar(20),
		resultSizeMax					varchar(20),
		shuffleReadBytesReadMax			varchar(20),
		shuffleReadFetchWaitTimeMax		varchar(20),
		shuffleReadLocalBlocksMax		varchar(20),
		shuffleReadRecordsReadMax		varchar(20),
		shuffleReadRemoteBlocksMax		varchar(20),
		shuffleWriteBytesWrittenMax		varchar(20),
		shuffleWriteRecordsWrittenMax	varchar(20),
		shuffleWriteTimeMax				varchar(20),
		taskDurationMax					varchar(20),
		

		diskBytesSpilledSum				varchar(20),
		executorRuntimeSum				varchar(20),
		inputBytesReadSum				varchar(20),
		jvmGCTimeSum					varchar(20),
		memoryBytesSpilledSum			varchar(20),
		outputBytesWrittenSum			varchar(20),
		peakExecutionMemorySum			varchar(20),
		resultSizeSum					varchar(20),
		shuffleReadBytesReadSum			varchar(20),
		shuffleReadFetchWaitTimeSum		varchar(20),
		shuffleReadLocalBlocksSum		varchar(20),
		shuffleReadRecordsReadSum		varchar(20),
		shuffleReadRemoteBlocksSum		varchar(20),
		shuffleWriteBytesWrittenSum		varchar(20),
		shuffleWriteRecordsWrittenSum	varchar(20),
		shuffleWriteTimeSum				varchar(20),
		taskDurationSum					varchar(20),

		
		totalHosts						varchar(20),
		maxConcurrentHosts				varchar(20),
		totalExecutors					varchar(20),
		maxConcurrentExecutors			varchar(20),
		driverWallClockTime				varchar(20),
		executorWallClockTime			varchar(20),
		timeWithInfiResource			varchar(20),
		minTimeWithPerfectParallelism	varchar(20),
		timeWithSingleExecutorCore		varchar(20),
		totalCores						varchar(20),


		sparkDriverCores				varchar(20),
		sparkDriverMemory				varchar(20),
		sparkExecutorMemory				varchar(20),
		sparkReducerMaxSizeInFlight		varchar(20),
		sparkShuffleCompress			varchar(20),
		sparkShuffleFileBuffer			varchar(20),
		sparkShuffleSpillCompress		varchar(20),
		sparkIoCompressionCodec			varchar(20),
		sparkRddCompress				varchar(20),
		sparkMemoryFraction				varchar(20),
		sparkExecutorCores				varchar(20),
		sparkDefaultParallelism			varchar(20),
		sparkLocalityWait				varchar(20),
		sparkTaskCpus					varchar(20),
		sparkExecutorInstances			varchar(20),
		sparkMemoryStorageFraction		varchar(20),


		primary key(applicationID)
	);


