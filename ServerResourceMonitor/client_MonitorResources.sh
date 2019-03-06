USAGE=0
USAGE=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }')
echo "$USAGE--$HOSTNAME"
curl --request POST   --data "usage=$USAGE&&hostname=$HOSTNAME" http://192.168.1.33:8088/resourceMonitor_war/myresource
