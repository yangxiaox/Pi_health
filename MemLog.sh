#!/bin/bash
#Using for gathering information of Mem

function Usage() {
	echo "Usage: $0 DyAver"
}

if [[ $# -lt 1 ]]; then
	Usage
	exit 1
fi

source ./PiHealth.conf

#$1 is the  dynamic average of the Mem occupancy
DyAver=$1 	

if [[ x"$DyAver" = x ]]; then
	exit 1
fi
if [[ ! -f "$MemLog" ]]; then
	echo "Log file does not exist."
	touch $MemLog
fi
MemValue=(`free -m | head -n 2 | tail -n 1 | awk '{printf("%s %s\n",$2,$3，$7) }'`)
MemAvaPrec=`echo "scale=1;${MemValue[1]}*100/${MemValue[0]}" | bc`
NowAver=`echo "scale=1;0.2*${MemAvaPrec}+0.8*${DyAver}" | bc`
NowTime=`date +"%Y-%m-%d__%H:%M:%S"`
echo "$NowTime ${MemValue[0]}M ${MemValue[2]} ${MemAvaPrec}% ${NowAver}%" >> $MemLog




