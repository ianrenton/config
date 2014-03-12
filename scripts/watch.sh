#!/bin/bash
# Monitor key stats and send e-mail alerts.

cpuuser=$(iostat -c | grep -v avg-cpu | grep -v Linux | grep "." | cut -c 10-12 | tr -d ' ')
cpuiowait=$(iostat -c | grep -v avg-cpu | grep -v Linux | grep "." | cut -c 34-36 | tr -d ' ')

if [ $cpuuser -gt 20 ]; then
    top -bn1 | /usr/bin/mail -s "User CPU use on Sparrowhawk is at $cpuuser%!" ian
fi

if [ $cpuiowait -gt 20 ]; then
    iotop -bn1 | /usr/bin/mail -s "IO Wait CPU use on Sparrowhawk is at $cpuiowait%!" ian
fi

