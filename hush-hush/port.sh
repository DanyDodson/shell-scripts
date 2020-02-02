#!/bin/bash
 
#Global variables
MIN=5000
MAX=5500
 
# Help print function
function printHelp {
	echo "Find out which inbound ports are available for use."
	echo ""
	echo "Options:"
	echo "	-h		Print this help"
	echo "	-a		List available ports"
	echo "	-u		List ports in use"
	echo "	-s port		Check the state of a specific port"
	echo ""
}
 
# Function to list available ports
function getAvailable {
	echo "Available ports:"
 
	RET=`netstat -nplA inet,inet6`
 
	for ((c=$MIN; c<=$MAX; c++))
	do
		INST=`echo "${RET}" | grep ":${c} "`
		if [ "$INST" == "" ]; then
			echo "$c"
		fi
	done
	echo ""
 
}
 
# Function to list used ports
function getUsed {
	echo "Used ports:"
 
	RET=`netstat -nplA inet,inet6`
 
	for ((c=$MIN; c<=$MAX; c++))
	do
		INST=`echo "${RET}" | grep ":${c} "`
		if [ "$INST" != "" ]; then
			echo "$c"
		fi
	done
	echo ""
 
}
 
# Function to check port state
function getPortState {
	if [ "$1" -le "$MAX" ] && [ "$1" -ge "$MIN" ]; then 
		RET=`netstat -nplA inet,inet6 | grep ":${1} " | awk '{print $7}'`
		if [ "$RET" != "" ]; then
			echo "State for port ${1}: In use"
			echo "Process info:"
			echo "${RET}"
		else
			echo "State for port ${1}: Available"
		fi
 
	else
		echo "Port outof range. (${MIN} - ${MAX})"
	fi
}
 
 
 
 
if [ "$1" == "-h" ]; then
	printHelp
elif [ "$1" == "-a" ]; then
	getAvailable
elif [ "$1" == "-u" ]; then
	getUsed
elif [ "$1" == "-s" ]; then
	getPortState $2
else
	printHelp
fi
 
echo "Done."
 