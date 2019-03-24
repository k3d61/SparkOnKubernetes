USAGE=0
USAGE=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }')
USAGE="${USAGE//%}"
echo "$USAGE--$HOSTNAME"
echo "usage=$USAGE&&hostname=$HOSTNAME"

MEMORY_TOTAL=$(free -m | grep Mem | cut -d " " -f9)
MEMORY_USED=$(free -m | grep Mem | cut -d " " -f14)

curl --request POST --data "usage=$USAGE&&hostname=$HOSTNAME&&memtotal=$MEMORY_TOTAL&&memused=$MEMORY_USED" http://10.16.23.143:8080/resourceMonitor/myresource
