#!/bin/bash
function Usage() {
	echo "Usage: $0"
}

if [[ $# -ge 1 ]]; then
	Usage
	exit 1
fi

source ./PiHealth.conf

if [[ $? -ne 0 ]]; then
	exit 1
fi

NowTime=`date +"%Y-%m-%d__%H:%M:%S"`

eval $(df -T -m -x tmpfs -x devtmpfs | tail -n +2 | \
	awk  '{printf("paramount["NR"]=%d;parleft["NR"]=%d;parname["NR"]=%s;\
	usedperc["NR"]=%s;",$3,$5,$7,$6)} \
	END {printf("parnum=%d\n",NR)}')

for (( i = 1; i <= $parnum; i++ )); do
	echo "$NowTime 1 ${parname[$i]} ${paramount[$i]} ${parleft[$i]}\
	 ${usedperc[$i]}">>$DiskLog
	DiskSum=$[ $DiskSum + ${paramount[$i]} ]
	LeftSum=$[ $LeftSum + ${parleft[$i]} ]
done
UsedPercSum=$[ (100-$LeftSum*100/$DiskSum) ]
echo "$NowTime 0 disk $DiskSum $LeftSum ${UsedPercSum}%" >>$DiskLog



























