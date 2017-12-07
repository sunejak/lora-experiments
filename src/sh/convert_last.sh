#!/bin/bash
#
# decode the raw data from lora
#
raw=$(tail -4 lora.log | tr -d "'")
stamp=$(echo ${raw} | jq ".timestamp" | tr -d '"' | cut -c 1-10)
now=$(date -d @${stamp})
humidity=$(echo ${raw} | jq ".data" | tr -d '"' | cut -c 33-40)
temp=$(echo ${raw} | jq ".data" | tr -d '"' | cut -c 41-48)
co2=$(echo ${raw} | jq ".data" | tr -d '"' | cut -c 51-54)
co2_ppm=$(printf "%d\n" 0x${co2})
tvos=$(echo ${raw} | jq ".data" | tr -d '"' | cut -c 55-58)
tvos_ppm=$(printf "%d\n" 0x${tvos})
c_temp=$(gdb --batch -ex "print/f (float *) 0x${temp}" | cut -c 6-)
c_humi=$(gdb --batch -ex "print/f (float *) 0x${humidity}" | cut -c 6-)

# human readable text
echo Last entry: temperature is ${c_temp} ,humidity ${c_humi} ,CO2 ${co2_ppm} ,TVOS ${tvos_ppm} at ${now}
# JSON output
echo "{ \"temp\": ${c_temp} ,\"humidity\": ${c_humi} ,\"CO2\": ${co2_ppm} ,\"TVOS\": ${tvos_ppm} ,\"timestamp\": ${stamp} }"

