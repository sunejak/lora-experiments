#!/bin/bash

source ./keys.txt

raw=$(curl -s -XGET https://api.lora.telenor.io/applications/${MODULE}/data?limit=1 -HX-API-Token:${TOKEN} | jq '{ data: .messages[0].data, timestamp: .messages[0].timestamp}' | tr -d "'")

# how to read the JSON directly

stamp=$(echo ${raw} | jq ".timestamp" | tr -d '"' | cut -c 1-10)
now=$(date -d @${stamp})
#
# decode the rest
#
data=$(echo ${raw} | jq ".data" | tr -d '"')
humidity=$(echo ${data} | cut -c 33-40)
temp=$(echo ${data} | cut -c 41-48)
status=$(echo ${data} | cut -c 49-50)
co2=$(echo ${data} | cut -c 51-54)
co2_ppm=$(printf "%d\n" 0x${co2})
tvos=$(echo ${data} | cut -c 55-58)
tvos_ppm=$(printf "%d\n" 0x${tvos})
c_temp=$(gdb --batch -ex "print/f (float *) 0x${temp}" | cut -c 6-)
c_humi=$(gdb --batch -ex "print/f (float *) 0x${humidity}" | cut -c 6-)

# human readable text
# echo Last entry: temperature is ${c_temp} ,humidity ${c_humi} ,CO2 ${co2_ppm} ,TVOS ${tvos_ppm} at ${now}
# or JSON output
# echo "{ \"temp\": ${c_temp} ,\"humidity\": ${c_humi} ,\"CO2\": ${co2_ppm} ,\"TVOS\": ${tvos_ppm} ,\"timestamp\": ${stamp} }"
# or for R readable CSV file
echo "$stamp $c_temp $c_humi $co2_ppm $tvos_ppm $status $now"

