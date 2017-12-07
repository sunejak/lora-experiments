# lora-experiments

Playing around with the LORA module from exploratory engineering.

Generously provided by Telenor Digital

Project depends on curl and jq, install with apt-get

------------------

First: HW module does:

sensor -> lora -> database

------------------

Then: 

crontab -> curl -> decode sensor string -> save in "lora.log"

Crontab entry for samples every 5 minutes:

*/5 * * * * cd /home/USER/lora-experiments &&  ./src/sh/crontab_get_sensordata.sh >> lora.log

------------------
Finally:

create graph with R. 

The curl calls and the lora module have properties and keys, and they are hiding in the keys.txt file.
