#!/bin/bash

# Checks a set of URLs specified in checksites.txt. If any of them return a status code >300,
# send an e-mail with the details.

response=""
while read LINE; do
  code=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' "$LINE")
  if [ "$code" -ge "300" ]
  then
    response="$response URL: $LINE returned status code $code\n"
  fi
done < ./checksites.txt

if [ -n "$response" ]
then
  echo -e "$response" | mail -s "Website Availability Warning" ian
fi
