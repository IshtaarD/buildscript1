#!/bin/bash

# Ishtaar Desravines
# autoUpdate_Ishtaar.sh
# 2022-08-05
# Bash script to automatically update the server and generate a file with the upgrades to the system. This file is to run weekly on Fridays at 11:00pm.
# Add to crontab file: 0 23 * * 5 root /home/ishtaar/bin/autoUpdate.sh 


modDate=$(date --rfc-3339=date) #retrieves the date in RFC 3339 format and assigns it to the variable modDate.
modDatesec=$(date --rfc-3339=seconds) #retrieves the date in RFC 3339 format to the seconds and assigns it to the variable modDatesec.
modDatemin=$(echo $modDatesec | awk -F ":" '{print $1":"$2}') #takes the string assigned to the modDatesec variable and prints the 1st and 2nd field with a colon in between. Gives the date to the minutes.  

apt -y update #runs an update in the system to see what is available to upgrade.
apt -y upgrade #runs an upgrade on the packages that are available for the system.

sed 's/  / /g' /var/log/apt/history.log | sed -n  "/$modDatemin/, /$modDatemin/p" >> /home/ishtaar/Desktop/systemUpdates_"$modDate".txt #replaces every instance of 2 spaces in the file history.log with 1 space and then prints all lines including and in between the string given to modDatemin.

echo "-----------------------------------------------------------------" >> /home/ishtaar/Desktop/systemUpdates_"$modDate".txt
echo "For more information about the updates, see below:" >> /home/ishtaar/Desktop/systemUpdates_"$modDate".txt
echo "-----------------------------------------------------------------" >> /home/ishtaar/Desktop/systemUpdates_"$modDate".txt

grep "$modDate" /var/log/dpkg.log >> /home/ishtaar/Desktop/systemUpdates_"$modDate".txt #searches for the date in RFC 3339 format in the dpkg.log file and outputs all the upgrades from that date into another file with its current date.  