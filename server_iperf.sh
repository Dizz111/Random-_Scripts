#!/bin/bash

serverip=`ifconfig ens160 |grep -w 'inet\|netmask' | cut -d " " -f 10-11`
count=1
start=1024


if [ "$2" == "bg" ] ; then
	declare -a tcpbgports=( "3306" "1194" "1701" "1723" "1521" "3389" "5001" "6699" )
	declare -a udpbgports=( "8222" "1645" "1646" "1812" "1813" "8200" )
elif  [ -z "$2" ]; then
    streams="100"
else 
    streams="$2"

fi

if [ "$1" == "start" ]; then
    if [ "$2" == "bg" ] ; then
        for i in "${tcpbgports[@]}"
            do
                iperf3 -s -D -p "$i"
                #iperf3 -s -D -B "$serverip" -p "$i"
                #echo "$i" "_ " "time"
            done 
        for i in "${udpbgports[@]}"
            do
                iperf3 -s -D -p "$i"
                 #iperf3 -s -D -B "$serverip" -p "$i"
                #echo "$i" "_ " "time"
            done 
        listening=(`ps -aef|grep iperf | grep -v grep | wc -l`)
        echo "$listening ports listening."
    else 
        #echo "default"
        while [ $count -le $streams ]
            do
                port=$(( $count + $start -1))
                #        echo "$port"
                iperf3 -s -D -p "$port"
                #iperf3 -s -D -B $serverip -p "$port"
                count=$(( $count + 1 ))
            done
        listening=(`ps -aef|grep iperf | grep -v grep | wc -l`)
   			echo "$listening ports listening."
    fi



elif [ "$1" == "stop" ]; then
	streams=`ps -aef|grep iperf |grep -v grep  | wc -l`
   while [ $count -le $streams ]
        do
            kill -9 ` ps -ef |grep iperf| grep -v grep |awk '{print $2}' |head -1`  # > /dev/null 2>&1
            count=$(( $count + 1 ))
        done
   listening=(`ps -aef|grep iperf | grep -v grep | wc -l`)
   echo "$listening ports listening."
else 
	echo "options are start or stop and the number of ports from 1001"
	echo "example 
	\"./server-iperf.sh start 10\" to start with port 1001-1010 listening (default is 100)
	\"./server-iperf.sh start bg \" to start listening on the bgroup ports as defined in the header
	\"./server-iperf.sh stop \" "
	
listening=(`ps -aef|grep iperf | wc -l`)-3
echo "$listening ports listening."
echo " the (3)-3 is just because of the search"
fi




