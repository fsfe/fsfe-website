#!/bin/sh

#shells may bring different implementations of echo :-(
alias echo='/bin/echo -e'

year=$1
odir=$2
template="$(dirname "$0")/button_template.svg"
tempfile="$(tempfile -s '.svg')"

if [ -z "$year" ]; then
  echo "Usage: $0 year [outputdir]"
  exit 1
fi
[ -z "$odir" ] && odir=.

xhtml="${odir}/xhtml"

echo "<h2>$year Buttons</h2>" >"$xhtml"

for type in Donor BronzeDonor SilverDonor GoldDonor; do
  echo "  <h3>$type $year</h3>\n"\
       "   <p class=\"indent\">\n"\
       "     <img src=\"${odir}/${type}${year}_w_medium.png\" border=\"0\" alt=\"$type $year button\"/><br />"\
	>>"$xhtml"

  echo "      white background:" >>"$xhtml"
  for size in huge=900 large=600 medium=300 small=200; do
    s_nam=$(echo $size |cut -d= -f1)
    s_num=$(echo $size |cut -d= -f2)
    sed -r "s:#DONORTYPE#:${type}:;s:#YEAR#:${year}:" "$template" >"${tempfile}"

    fname="${odir}/${type}${year}_w_${s_nam}.png"
    inkscape -z -C -e "${fname}" -d 300 -w $s_num -b "#FFFFFF" "$tempfile"

    echo "      [<a href=\"${fname}\">${s_nam}; png; $(( $(stat -c %s "${fname}") / 1024 ))kb</a>]" >>"$xhtml"
  done

  echo "      transparent background:" >>"$xhtml"
  for size in huge=900 large=600 medium=300 small=200; do
    s_nam=$(echo $size |cut -d= -f1)
    s_num=$(echo $size |cut -d= -f2)
    sed -r "s:#DONORTYPE#:${type}:;s:#YEAR#:${year}:" "$template" >"${tempfile}"

    fname="${odir}/${type}${year}_t_${s_nam}.png"
    inkscape -z -C -e "${fname}" -d 300 -w $s_num "$tempfile"

    echo "      [<a href=\"${fname}\">${s_nam}; png; $(( $(stat -c %s "${fname}") / 1024 ))kb</a>]" >>"$xhtml"
  done

  echo "    </p>" >>"$xhtml"
done

rm "${tempfile}"
