#!/usr/bin/ksh
# SCRIPT:       /usr/local/bin/check_iostat
# VERSION:      1.0
# CREATED:      26/05/08
# LAST UPDATED: 26/05/08
# AUTHOR:       Adrian Wood
# DECRIPTION:   Check the iowait value returned by the iostat command.  A high value for iowait indicates
#               that the disk io subsystem is spending too much time waiting to service requests
#               i.e. the system is io bound.# PARAMS:       None
#
# Inspired by examples at: http://www.weborial.com/how-to/iowait.shtml
#
# CHANGES:

IOSTAT="/usr/bin/iostat -c"     #The iostat command to run
THRESHOLD=40                    #The threshold that is considered dangerous (in whole numbers)

# function to extract the fourth token of the last line of the
get_iowait() {
   $IOSTAT  grep -v avg-cpu  grep -v Linux  grep "."  {
        while read line; do
                iowait=(` echo $line  cut -d ' ' -f4 `)
        done
   }
}

#Get the current iowait value from iostatget_iowait
#if the value returned is greater than the defined threshold, flag an alarm.
if [ $iowait -gt $THRESHOLD ] ; then
        echo WARNING: The iowait value of $iowait has exceeded the defined threshold of $IOWAIT_THRESHOLD.
        echo Some investigation into the performance of the disk i/o subsystem is required to
        echo determine if this condition should and/or can be corrected.
        exit 1
else
        echo iowait $iowait is fine.
        exit 0
fi
