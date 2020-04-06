#!/bin/bash
# Authored by Insolent.Binary
red=$'\e[1;31m'
grn=$'\e[1;32m'
ylw=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

clear
cat title.txt | lolcat
echo ""
echo ""
echo "----------------------------------"
echo $red "Starting Submissions To URLSCAN.IO" $white
echo "----------------------------------"

#retrieve raw json from URLSCAN.io and send to Raw Output List
cat list.txt | tr -d "\r" | while read url; do 
curl -s https://urlscan.io/api/v1/search/?q=domain:$url | jq -r > covid19out.json 

#parse total values out of raw.output.txt for decision making (submit / move on)
cat covid19out.json | jq -r '.total' > total.txt

#write uuid log file
cat covid19out.json | jq -r '.results[]._id' > searchuuid.txt

#Send data to overall json
cat covid19out.json >> covidmaster.json

#set searchurl variable
totalcount=$(cat total.txt)
#set uuid
uuid=$(cat searchuuid.txt)

#capture search uuid screen shot 
echo "$url $uuid" >> uuidsearch.log

#decision process (submit / move on)
echo " $totalcount $url "
	if [ "$totalcount" -eq "0" ];
		then
			echo ""
			echo "NO RECORD FOR $url. $red SUBMITTING TO URLSCAN.";
			echo ""
	   
	   curl -sS -X POST "https://urlscan.io/api/v1/scan/" \
      		-H "Content-Type: application/json" \
      		-H "API-Key: 4cfee606-4f28-4be5-a947-6f92b633912a" \
       		-d "{\"url\": \"$url\", \"public\": \"on\"}" >> covid19outsubs.json
                        
                        echo $grn "$url has been SUBMITTED!" $white
                        echo ""
			sleep 2.5;
			fi
done
