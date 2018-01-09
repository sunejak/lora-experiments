#!/bin/bash
#
# read the datafile and convert it to JSON
#
# curl -s -XGET https://api.lora.telenor.io/applications/<module>/data?limit=2000 -HX-API-Token:<token> > lots_of_data.json
#
# cat lots_of_data.json | jq '{ data: .messages[].data, timestamp: .messages[].timestamp}' > lots_of_pretty_print.txt
#

input_file=$1

if [[ -f $input_file ]]

then
    while IFS= read -r var
    do
        if [[ ${var:0:1} == '{' ]] ; then
        timestamp=""
        fi
        if [[ ${var:3:4} == "time" ]] ; then
        timestamp=${var:15:10}
        now=$(date -d @${timestamp})
        fi
        if [[ ${var:3:4} == "data" ]] ; then
        data=$var
        humi=$(echo ${var} | cut -c 42-49)
        temp=$(echo ${var} | cut -c 50-57)
        stat=$(echo ${var} | cut -c 58-59)
        co2=$(echo ${var} | cut -c 60-63)
        tvos=$(echo ${var} | cut -c 64-67)
        co2_ppm=$(printf "%d\n" 0x${co2})
        tvos_ppm=$(printf "%d\n" 0x${tvos})
        c_temp=$(gdb --batch -ex "print/f (float *) 0x${temp}" | cut -c 6-)
        c_humi=$(gdb --batch -ex "print/f (float *) 0x${humi}" | cut -c 6-)

        fi
        if [[ ${var:0:1} == '}' ]] ; then
        echo "$timestamp $c_temp $c_humi $co2_ppm $tvos_ppm $stat $now"
        fi
    done < "$input_file"

    else
    echo "Bad input file $1"
fi
exit 0
