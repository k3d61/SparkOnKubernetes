USAGE=0
USAGE=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }')
USAGE="${USAGE//%}"


MEMORY_TOTAL=$(free -m | grep Mem | cut -d " " -f12)
MEMORY_USED=$(free -m | grep Mem | cut -d " " -f20)


echo "$USAGE--$HOSTNAME" >> /tmp/resourceMonitorLog

echo "usage=$USAGE&&hostname=$HOSTNAME&&memtotal=$MEMORY_TOTAL&&memused=$MEMORY_USED"  >> /tmp/resourceMonitorLog

curl --request POST --data "usage=$USAGE&&hostname=$HOSTNAME&&memtotal=$MEMORY_TOTAL&&memused=$MEMORY_USED" http://10.16.23.143:8080/resourceMonitor/myresource


echo "" >> /tmp/resourceMonitorLog
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"  >> /tmp/resourceMonitorLog
