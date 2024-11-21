!/bin/bash

#ARCHITECTURE
arch=$(uname -a)

# uname -a: all info about the system, (kernel name, version, architecture, etc).

#PHYSICAL CPU
cpuf=$(grep "physical id" /proc/cpuinfo | wc -l)

# Looks for "physical id" inside the file cpuinfo and counts lines

#VIRTUAL CPU
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)

# Looks for "processor" inside the file cpuinfo and counts lines

#AVAILABLE RAM & UTILIZATION RATE
ram_usage=$(free --mega | awk '$1 == "Mem:" {printf("%d / %dMB (%.2f%%)\n", $3, $2, $3/$2*100)}')

# looks for  info about RAM memory in mb and prints used mem / total mem (percentage available%)

#AVAILABLE DISK STORAGE & UTILIZATION RATE
disk_usage=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{use += $3} {total += $2} END {printf("%d / >

# looks for info about disk and prints sum of used mem / total memGB (percentage used)

#CPU LOAD (USAGE)
cpu_l=$(vmstat 1 2 | tail -1 | awk '{print $15}')
cpu_p=$(expr 100 - $cpu_l)
cpu_fin=$(printf "%.1f%%" $cpu_p)

# vmstat 1 2 | tail -1 | awk '{print $15}' - collects system info for 2 seconds, finds last line info a>
# cpu_p - calculates the CPU load by subtracting idle time from 100% 

#LAST REBOOT
last_reboot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# displays last system boot time, finds lines that start with "system" and prints 3rd and 4th word

#LVM ACTIVE
lvm_use=$(if [$(lsblk | grep "lvm" | wc -l) -gt 0]; then echo yes; else echo no; fi)

# lists info about all block devices in system (memory and partitions), filters lvm type and counts lin>
# if greater than 0, prints yes: if >= 0, prints no

#TCP CONNECTIONS
tcp_con=$(ss -ta | grep ESTAB | wc -l)

# ss -ta - socket  stats displays info about socket connections and -ta flag specifies TCP connections
# looks for "ESTAB" and counts lines

#USERS
user_log=$(users | wc -w)

# counts the number of words of command users (active users)

#IP & MAC
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# hostname -I returns IP address of the machine
# ip link shows network interface info
# we filter linws with "link/ether" and print the 2nd word

#SUDO COMMANDS
sudo_cmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

# journalctl - shows system logs
# we filter sudo commands with "COMMAND" and count lines

wall "  Architecture : $arch
        CPU physical : $cpuf
        vCPU : $cpuv
        Memory Usage : $ram_usage
        Disk Usage : $disk_usage
        CPU load : $cpu_fin%
        Last boot : $last_reboot
        LVM use : $lvm_use
        Connections TCP : $tcp_con ESTABLISHED
        User log : $user_log
        Network: IP $ip ($mac)
        Sudo : $sudo_cmd cmd"

# wall: Sends a message to all logged-in users. The collected information is formatted and displayed.
