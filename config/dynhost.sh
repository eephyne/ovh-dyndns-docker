#! /bin/bash
# Mainly inspired by DynHost script given by OVH
# New version by zwindler (zwindler.fr/wordpress)
#
# Initial version was doing  nasty grep/cut on local ppp0 interface
#
# This coulnd't work in a NATed environnement like on ISP boxes
# on private networks.
#
# Also got rid of ipcheck.py thanks to mafiaman42
#
# This script uses curl to get the public IP, and then uses wget
# to update DynHost entry in OVH DNS
#
# Logfile: dynhost.log
#
# CHANGE: "HOSTX", "LOGINX" and "PASSWORDX" to reflect YOUR accounts variables where X is a number starting from 0
# you can use LOGIN and PASSWORD for setting one account for all hosts
SCRIPT_PATH='/srv/dyndns'

variable_exists() {
    local var_name=$1
    [[ ${!var_name} ]]
}

getip() {
    IP=`curl http://ifconfig.me/ip`
    OLDIP=`dig +short $HOST1 @$NSSERVER`
}

echo "[`date '+%Y-%m-%d %H:%M:%S'`] ============================================================="
echo "[`date '+%Y-%m-%d %H:%M:%S'`] Begining new dyndns check"
getip 

if [ "$IP" ]; then
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] Old IP is ${OLDIP}"
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] New IP is ${IP}"
    
    if [ "$OLDIP" != "$IP" ]; then
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] Update is needed…"
        index=1
        while true; do
            var_name="HOST$index"
            
            if variable_exists "$var_name"; then
                current_login=LOGIN
                current_password=PASSWORD
                echo "[`date '+%Y-%m-%d %H:%M:%S'`] Host $var_name exists with value: ${!var_name}"
                if variable_exists "LOGIN$index"; then
                    current_login="LOGIN$index"
                    current_password="PASSWORD$index"
                fi
                wget "${ENTRYPOINT}?system=dyndns&hostname=${!var_name}&myip=${IP}" --user="${!current_login}" --password="${!current_password}"
                ((index++))
            else
                echo "[`date '+%Y-%m-%d %H:%M:%S'`] No more hosts found."
                break
            fi
        done
        echo -n "$IP" > $SCRIPT_PATH/old.ip
    else
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] No update required."
    fi
else
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] WAN IP not found. Exiting!"
fi