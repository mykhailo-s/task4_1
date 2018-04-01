#!/bin/bash

# collect information about hardware

#VERBOSE=true
#clear

# if [ -f "$PWD/task4_1.out" ]; then rm -f "$PWD/task4_1.out" ; fi

# check for root
if [ "$UID" -ne 0 ]
   then echo "Error in ($0): Current user is not the root! Please restart this task under the root" >&2; exit 126;  
fi

# exec 10>&1
exec 1> "$PWD/task4_1.out"

# check if dmidecode is present
if ! [ -x "$(command -v dmidecode)" ];
   then sudo apt update && sudo apt install dmidecode -y;
fi

echo "--- Hardware ---"
echo "CPU:$(cat /proc/cpuinfo | grep 'model name' | uniq | awk -F : '{print $2}')"
echo "RAM: $(grep MemTotal /proc/meminfo | awk '{print $2,toupper($3)}')"

# echo "Motherboard: $(sudo dmidecode -s baseboard-manufacturer)"" ""$(sudo dmidecode -s baseboard-product-name)"
  res1="$(sudo dmidecode -s baseboard-manufacturer 2>/dev/null)"; res1=${res1:-777}
  res2="$(sudo dmidecode -s baseboard-product-name 2>/dev/null)"; res2=${res2:-777}
echo -n "Motherboard: "
   if [ "$res1" == "$res2" ] ; then echo "Unknown"
   elif [ "$res1" == "777" ]; then echo "$res2"
   elif [ "$res2" == "777" ]; then echo "$res1 Unknown"
   else echo "$res1"" $res2" 
   fi

# echo "System Serial Number: $(sudo dmidecode -s system-serial-number)"
  res3="$(sudo dmidecode -s system-serial-number 2>/dev/null)"; res3=${res3:-777}
echo -n "System Serial Number: "
   if [ "$res3" == "777" ] || [ "$res3" == "0" ] ; then echo "Unknown"; else echo "$res3"; fi

echo "--- System ---"
echo "OS Distribution:$(hostnamectl | grep "Operating System" | awk -F: '{print $2}')"
echo "Kernel version: $(uname -r)" 
# echo "Kernel version: $(cat /proc/version | awk  '{print $3}')" 
echo "Installation date: $(ls -ld --time-style=long-iso / | awk '{print $6,$7}')"
echo "Hostname: $(hostname -f)" # echo "$(cat /etc/hostname)" 
echo "Uptime:"\
     "$(awk '{s=int($1);w=int(s/(86400*7));d=int(s / 86400);h=int(s % 86400 / 3600);m=int(s % 3600 / 60); \
          printf "%d weeks, %d days, %02d hours, %02d minutes", w, d, h, m}' /proc/uptime)"
echo "Processes running: $(ps -e --no-headers | wc -l)"
echo "Users logged in: $(users | wc -w)"
echo "--- Network ---"
# only first inet address
ip -br a | awk '{if (length($3) != 0) then "$3"; else $3="-"}{print $1":",$3}'

#echo Where not eq 0
#ip -br a | awk '{if (length($4)!=0) then $4; else $4="-"}{print $1":",$3,$4}'
#echo Where eq 0
#ip -4 -br a | awk '{if (length($4)==0) print $1":",$3" -"; else print $1":",$3,$4}'

# ls -ila /proc/$$/fd
# exec  1>&10 10>&-

exit

