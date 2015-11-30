#!/bin/bash
rm out.csv > /dev/null  2>&1 
rm out/* > /dev/null  2>&1 
mkdir out > /dev/null  2>&1
mkdir res > /dev/null  2>&1

#convert input file to right dates
while IFS='' read -r line || [[ -n "$line" ]]; do
    IFS=';' read -r -a array <<< "$line"
    line_date=$(date '+%d.%m.%Y %T' --date="$2 GMT+1 + ${array[0]} seconds")
    current_day=$(date '+%Y-%m-%d' --date="$2 GMT+1 + ${array[0]} seconds")
    echo -e "\t${line_date}\t${array[1]}\t${array[2]}" >> out/all.csv
    echo -e "\t${line_date}\t${array[1]}\t${array[2]}" >> out/$current_day.csv
done < "$1"
cd out
find . -type f -exec gnuplot -e "filename='{}'; outFile='../res/{}.png'; title='{}'" ../plot.plg \;
cd ../res
convert *.png _res.pdf
