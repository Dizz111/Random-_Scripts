#!/bin/bash
# The server is set up and run to listen on the range of ports starting at 1000 and the number of streams.
# MSS can be set to the small packet sizes 128 is the minimun 
# Stream are unique port, parallel is using the same port default is 1
# set fpr TCP, but can uncomment UDP option




length=8860
parallel=1

declare -a tcpbgports=( "3306" "1194" "1701" "1723" "1521" "5001" "6699" )
declare -a udpbgports=( "8222" "1645" "1646" "1812" "1813" "8200" )
maxtime=2
loop=1000
looptime=180
start=1024

if [ "$1" == "perf" ]; then
    if  [ -z "$2" ]; then
        echo "options are:
        Time in seconds
        Number of ports to be used
        Mss to control packet size"
        echo "example 
        \"./client-iperf.sh perf 60 10 128 <ip>\" to run for 60 seconds with 10 ports (1001-1010) and Packet size set to 128 bytes.
        \"./client-iperf.sh perf 6 10 512 <ip>\" to run for 6 seconds with 10 ports (1001-1010) and Packet size set to 512 bytes. 
 
        Time must be defined but the default for port range is 10 and packet size is 1024 "
        exit 1
    else 
        time="$2"
    
    fi
    
    if  [ -z "$5" ]; then
    	server=192.168.102.6
		else 
    	server="$5"

		fi

    
    if  [ -z "$3" ]; then
        streams=10
    else 
        streams="$3"
    
    fi
    
    if  [ -z "$4" ]; then
        mss=1024
    else
        mss="$4"
    
    fi
    
    echo "Started"
    date
    FILES=`ls /tmp/iperf* | wc -l`
    if  [ $FILES -ge 1 ]; then
    	rm -r /tmp/iperf*
		fi
    
    
    #declare -i count
    #declare -i start
    
    count=1
    while [ $count -le $streams ]
            do
                port=$(( $count + $start ))
                #TCP
    	    iperf3 -c $server -M $mss -p $port -t $time -P $parallel -f m --length $length --logfile /tmp/iperf_server_log_$port &
                #UDP
    #	    iperf3 -c $server -M $mss -p $port -u -t $time -P $parallel -f m --length $length --logfile /tmp/iperf_server_log_$port &
                count=$(( $count + 1 ))
            done
    sleep $time
    echo "Finished"
    date
    sleep 2
    #TCP
    more /tmp/iperf* |grep sender |cut -c 37-50
    #UDP
    #more /tmp/iperf* | grep "0.00-$time.00" |grep "SUM"
    
    
    
elif [ "$1" == "bg" ]; then
		if  [ -z "$2" ]; then
    	server=192.168.102.6
		else 
    	server="$2"

		fi
    count=1
    mss=1024
    echo "Starting $loop Loops"
    date
    while [ $count -le $loop ]
            do
                echo "Starting Loop $count"
                date
                for i in "${tcpbgports[@]}"
                    do
                        rtime=$(( ( RANDOM % $maxtime )  + 1 ))
                        #echo "$rtime $i"
                        #iperf3 -s -D -p "$i"
                        #TCP
                	    iperf3 -c $server -M $mss -p $i -t $rtime -P $parallel -f m --length $length > /dev/null 2>&1 &  # --logfile /tmp/iperf_server_log_$port &
                        #UDP
                #	    iperf3 -c $server -M $mss -p $port -u -t $time -P $parallel -f m --length $length --logfile /tmp/iperf_server_log_$port &
                
                        #echo "$i" "_ " "time"
                    done 
                
                 for i in "${udpbgports[@]}"
                    do
                        rtime=$(( ( RANDOM % $maxtime )  + 1 ))
                        #echo "$rtime $i"
                        #iperf3 -s -D -p "$i"
                        #TCP
                #	    iperf3 -c $server -M $mss -p $i -t $rtime -P $parallel -f m --length $length > /dev/null 2>&1 &  # --logfile /tmp/iperf_server_log_$port &
                        #UDP
                	    iperf3 -c $server -M $mss -u -p $i -t $time -P $parallel -f m --length $length > /dev/null 2>&1 &  # --logfile /tmp/iperf_server_log_$port &
                
                        #echo "$i" "_ " "time"
                    done 
                

                # sleep $rtime
                ltime=$(( ( RANDOM % $looptime )  + 1 ))
                sleep $ltime
                echo "Finished Loop $count"
                date
                count=$(( $count + 1 ))         
                
            done
    
else
        echo "example 
        \"./client-iperf.sh bg <IP>\" to run backgroup traffic based on the header in the file.
        \"./client-iperf.sh perf 60 10 128 <IP>\" to run for 60 seconds with 10 ports (1001-1010) and Packet size set to 128 bytes.
        \"./client-iperf.sh perf 6 10 512 <IP>\" to run for 6 seconds with 10 ports (1001-1010) and Packet size set to 512 bytes. 
    
        Time must be defined but the default for port range is 10 and packet size is 1024 "

fi 
