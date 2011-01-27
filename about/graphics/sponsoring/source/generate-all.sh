#!/usr/bin/env bash


if [ "$#" -eq 0 ];then
    echo "Please specify the year you want to generate logos for, e.g.:"
    echo "    ./generate-all 2012"
    exit
fi


year=$1

mkdir $year

declare -A widths=( [900]="huge" [600]="large" [300]="medium" [200]="small" )

declare -A areas=(
    ["HardwareDonor"]="-232:883:894:1625"
    ["Contributor"]="1061:878:2186:1620"
    ["Supporter"]="-236:116:889:858"
    ["SustainingContributor"]="1038:40:2164:784"
    ["Patron"]="-239:-719:887:24"
)

# Contributor2011_w_huge.png

for type in "${!areas[@]}"
do
    for width in 900 600 300 200
    do
        
        # export with transparent background
        inkscape -z -a=${areas[$type]} -f=sponsoring_buttons.svg -e="$year/$type$year""_t_${widths[$width]}.png" -w=$width
        # export with white background
        inkscape -z -a=${areas[$type]} -f=sponsoring_buttons.svg -e="$year/$type$year""_w_${widths[$width]}.png" -w=$width -b=0
        
    done
done


