# iperf_script

Script to test the performance with different packet sizes.

## server script 
	options are start or stop and the number of ports from 1001 or bg example.
		example 
	"./server-iperf.sh start 10" to start with port 1001-1010 listening (default is 10)
	"./server-iperf.sh start bg"  to start with port defined in the bg list in the header of the file
	"./server-iperf.sh stop "  Kills all iperf deamons running
	
	The line 22/32 can be used to replace line 23/33 if in a multi homed server to listen on a specific IP
	Set the serverip that you want to use in the header.
	            iperf3 -s -D -p "$i"
                #iperf3 -s -D -B "$serverip" -p "$i"
  



##  client script
	options are either Performance tesing or Background traffic generation. 
	perf / bg
	
	When selecting performance you have the option to select the length of time, number of sequental ports and size of packet.
		Time in seconds
		Number of ports to be used
		Mss to control packet size
	
	example 
	"./client-iperf.sh perf 60 10 128" to run for 60 seconds with 10 ports (1001-1010) and Packet size set to 128 bytes.
	"./client-iperf.sh perf 6 10 512" to run for 6 seconds with 10 ports (1001-1010) and Packet size set to 512 bytes. 
  
	Time must be defined but the default for port range is 10 and packet size is 1024 

	For background traffic the header option can be edited.
		maxtime - is a value in seconds, that the script will create a random size between 1 and maxtime for each stream.
		loop - the number of loops you want to run.
		looptime - as generating background traffic, the delay between the next loop run.

	sample values of:
		maxtime=10
		loop=10
		looptime=60
	
	Means carry out 10 loops with each stream being between 1-10 seconds, and 60 seconds apart. 




#  Disclaimer
This software is provided without support, warranty, or guarantee. Use at your own risk.
  