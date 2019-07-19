# Author: Kedar
# This script checks whether given V 
# This script creates VMs with static configuration, 
# This script will be called from cron darmon at every 5 min
# TODO: read configuration from external .config file 

declare -a VM_NAME=("ub" "spark_1" "spark_2" "spark_3_Cloned" "spark_4" "spark_5")

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
