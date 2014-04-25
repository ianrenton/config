#!/bin/bash

# Monitors a CraftBukkit Minecraft server for logins, and sends an email when someone logs in

tail -f /home/ian/bin/craftbukkit/server.log | 
  while read line; do
    if [[ $line == *logged* ]] || [[ $line == *left* ]]
    then
      echo -e "$line" | mail -s "Minecraft server notification" "minecraft@ianrenton.com"
    fi
  done
