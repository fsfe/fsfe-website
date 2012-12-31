#!/bin/sh

year=$1
odir=$2
template=button_template.svg
tempfile="$(tempfile -s '.svg')"

if [ -z "$year" ]; then
  echo "Usage: $0 year [outputdir]"
  exit 1
fi
[ -z "$odir" ] && odir=.

for type in Donor BronzeDonor SilverDonor GoldDonor; do
  for size in huge=900 large=600 medium=300 small=200; do
    s_nam=$(echo $size |cut -d= -f1)
    s_num=$(echo $size |cut -d= -f2)

    w_name="${type}${year}_w_${s_nam}"
    t_name="${type}${year}_t_${s_nam}"

    sed -r "s:#DONORTYPE#:${type}:;s:#YEAR#:${year}:" "$template" >"${tempfile}"

    inkscape -z -C -e "${odir}/${t_name}.png" -d 300 -w $s_num "$tempfile"
    inkscape -z -C -e "${odir}/${w_name}.png" -d 300 -w $s_num -b "#FFFFFF" "$tempfile"

  done
done

rm "${tempfile}"
