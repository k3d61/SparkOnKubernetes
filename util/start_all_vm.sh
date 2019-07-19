# Author: Kedar
# This script checks whether given V 
# This script creates VMs with static configuration, 
# This script will be called from cron darmon at every 5 min
# TODO: read configuration from external .config file 

declare -a HOST1=("ub" "spark_1" "spark_2" "spark_3_Cloned" "spark_4" "spark_5")
declare -a HOST2=("spark_6" "spark_7" "spark_8" "spark_9" "spark_10" "spark_11" "spark_12")
declare -a HOST4=("spark-13" "spark-14" "spark-15" "spark-16" "spark-17" "spark-18")

if [ "$(whoami)" = "ub-01" ];
then
	VM_NAME=( "${HOST1[@]}" )
elif [ "$(whoami)" = "ub-02" ];
then
	VM_NAME=( "${HOST2[@]}" )
elif [ "$(whoami)" = "ub-04" ];
then
	VM_NAME=( "${HOST4[@]}" )
fi

for i in "${VM_NAME[@]}"
do
	if [ "$(vboxmanage showvminfo ""$i"" | grep "State" | grep "running (since" | wc -l)" -eq 0 ]; 
	then
		echo "Launching $i..."
		VBoxManage startvm "$i" --type headless
	else
		echo "$i already running"
	fi
done
