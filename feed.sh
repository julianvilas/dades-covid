#!/bin/bash

set -e

url="https://dadescovid.cat/static/csv/catalunya_setmanal_total_pob.zip"
csv="catalunya_setmanal_total_pob.csv"

curl -sSLo data.zip ${url}

unzip -o data.zip

# Present fields in the CSV (delimiter ';'):
#	NOM
#	CODI
#	DATA_INI
#	DATA_FI
#	IEPG_CONFIRMAT
#	R0_CONFIRMAT_M
#	IA14
#	TAXA_CASOS_CONFIRMAT
#	CASOS_CONFIRMAT
#	TAXA_PCR_TAR
#	PCR
#	TAR
#	PERC_PCR_TAR_POSITIVES
#	INGRESSOS_TOTAL
#	INGRESSOS_CRITIC
#	EXITUS

# Remove header
data=$(tail -n +2  "$csv")

# Wait for Graphite
sleep 10

# Send metrics to Graphite
while IFS=';' read -r -a array
do
	ts=$(date --date=${array[3]} +%s)
	echo "outbreak ${array[4]} $ts" | nc graphite 2003
	echo "rt ${array[5]} $ts" | nc graphite 2003
	echo "ci14 ${array[6]} $ts" | nc graphite 2003
	echo "hospitalized ${array[13]} $ts" | nc graphite 2003
	echo "icu ${array[14]} $ts" | nc graphite 2003

	# Below values are aggregated from the last 7 days. Dividing by 7 as an
	# approximation
	c=$(echo "scale=1; ${array[8]}/7" | bc -l); echo "cases $c $ts" | nc graphite 2003
	p=$(echo "scale=1; ${array[10]}/7" | bc -l); echo "pcr $p $ts" | nc graphite 2003
	r=$(echo "scale=1; ${array[11]}/7" | bc -l); echo "rat $r $ts" | nc graphite 2003
	d=$(echo "scale=1; ${array[15]}/7" | bc -l); echo "deaths $d $ts" | nc graphite 2003
done <<< "$data"
