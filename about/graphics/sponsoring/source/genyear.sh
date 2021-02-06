#!/bin/sh

#shells may bring different implementations of echo :-(
alias echo='/bin/echo -e'

year=$1
odir=$2
template="$(dirname "$0")/button_template.svg"
tempfile="$(mktemp --suffix '.svg')"

if [ -z "$year" ]; then
  echo "Usage: $0 year [outputdir]"
  exit 1
fi
[ -z "$odir" ] && odir=.

for type in Donor BronzeDonor SilverDonor GoldDonor; do

  for size in huge=900 large=600 medium=300 small=200; do
    s_nam=$(echo $size |cut -d= -f1)
    s_num=$(echo $size |cut -d= -f2)
    sed -r "s:#DONORTYPE#:${type}:;s:#YEAR#:${year}:" "$template" >"${tempfile}"

    fname="${odir}/${type}${year}_w_${s_nam}.png"
    inkscape -C -o "${fname}" -d 300 -w $s_num -b "#FFFFFF" "$tempfile"
  done

  for size in huge=900 large=600 medium=300 small=200; do
    s_nam=$(echo $size |cut -d= -f1)
    s_num=$(echo $size |cut -d= -f2)
    sed -r "s:#DONORTYPE#:${type}:;s:#YEAR#:${year}:" "$template" >"${tempfile}"

    fname="${odir}/${type}${year}_t_${s_nam}.png"
    inkscape -C -o "${fname}" -d 300 -w $s_num "$tempfile"
  done
done

rm "${tempfile}"
