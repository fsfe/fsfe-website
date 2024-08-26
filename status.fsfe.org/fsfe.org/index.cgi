#!/usr/bin/env bash

exec 2>/dev/null

DATADIR="data"
readonly DATADIR

if [ "$QUERY_STRING" = "full_build" ]; then
    if printf %s "$HTTP_REFERER" | grep -qE '^https?://([^/]+\.)?fsfe\.org/'; then
        touch ./"$DATADIR"/full_build
    fi
    printf 'Location: ./\n\n'
    exit 0
fi

timestamp() {
    date -d "@$1" +"%F %T (%Z)"
}

DATADIR="data"
readonly DATADIR

duration() {
    minutes=$(($1 / 60))
    if [ "${minutes}" == "1" ]; then
        minutes="${minutes} minute"
    else
        minutes="${minutes} minutes"
    fi

    seconds=$(($1 % 60))
    if [ "${seconds}" == "1" ]; then
        seconds="${seconds} second"
    else
        seconds="${seconds} seconds"
    fi
    echo "${minutes} ${seconds}"
}

htmlcat() {
    sed 's;&;\&amp\;;g;
 s;<;\&lt\;;g;
 s;>;\&gt\;;g;
 s;";\&quot\;;g;
 s;'\'';\&apos\;;g;' $@
}

start_time=$(cat "$DATADIR/start_time" || stat -c %Y "$0" || echo 0)
t_gitupdate=$(stat -c %Y "$DATADIR/GITlatest" || echo 0)
t_phase_1=$(stat -c %Y "$DATADIR/phase_1" || echo 0)
t_makefile=$(stat -c %Y "$DATADIR/Makefile" || echo 0)
t_phase_2=$(stat -c %Y "$DATADIR/phase_2" || echo 0)
t_manifest=$(stat -c %Y "$DATADIR/manifest" || echo 0)
t_stagesync=$(stat -c %Y "$DATADIR/stagesync" || echo 0)
end_time=$(cat "$DATADIR/end_time" || echo 0)
duration=$(($end_time - $start_time))
term_status=$(if [ "$duration" -gt 0 -a -f "$DATADIR"/lasterror ]; then
    echo Error
elif [ "$duration" -gt 0 ]; then
    echo Success
fi)

printf %s\\n\\n "Content-Type: text/html;charset=utf-8"
sed -e '/<!--\ spacing-comment\ -->/,$d' template.en.html
cat <<-HTML_END
<h1>Build report</h1>
<dl class="buildinfo">
<dt>Start time:</dt><dd>$(timestamp ${start_time})</dd>
<dt>End time:</dt><dd>$([ "$duration" -gt 0 ] && timestamp ${end_time})</dd>
<dt>Duration:</dt><dd>$([ "$duration" -gt 0 ] && duration ${duration})</dd>
<dt>Termination Status:</dt><dd>${term_status:-running...}</dd>
</dl>
$(if [ -f ./$DATADIR/full_build ]; then
    printf '<span class="fullbuild">Full rebuild will be started within next minute.</span>'
else
    printf '<a class="fullbuild" href="./?full_build">Schedule full rebuild</a>'
fi)
<details>
<summary>Previous builds</summary>
<div class="scrollbox">
$(
    find "$DATADIR" -name "status_*.html" -type f -printf "%f\n" | sort -r | head -n10 | while read stat; do
        t="${stat#status_}"
        t="${t%.html}"
        printf '<a href="%s">%s</a> - %s<br>' \
            "data/$stat" "$(timestamp "$t")" "$(sed -rn 's;^.*<dt>Duration:</dt><dd>(.+)</dd>.*$;\1;p;T;q' "$stat")"
        printf $'\n'
    done
)
</div>
</details>
<details>
<summary>GIT changes: 
$(
    if [ ${start_time} -le ${t_gitupdate} ]; then
        echo "at $(timestamp ${t_gitupdate})" "</summary>" \
            "<div class=\"scrollbox\">" \
            "<pre>$(htmlcat "$DATADIR"/GITlatest)</pre>" \
            "checked"
    else
        echo "Unconditional build, changes ignored" \
            "</summary>" \
            "<div class=\"scrollbox\">"
    fi
)
</div>
</details>
<details>
<summary>Phase 1: 
$(
    if [ $start_time -lt $t_phase_1 -a $start_time -lt $t_gitupdate ]; then
        echo "$(duration $(($t_phase_1 - $t_gitupdate)))" "</summary>" \
            "<div class=\"scrollbox\">" \
            "<pre>$(htmlcat "$DATADIR"/phase_1)</pre>"
    elif [ $start_time -lt $t_phase_1 ]; then
        echo "$(duration $(($t_phase_1 - $start_time)))" "</summary>" \
            "<div class=\"scrollbox\">" \
            "<pre>$(htmlcat "$DATADIR"/phase_1)</pre>"
    else
        echo "waiting" "</summary>" \
            "<div class=\"scrollbox\">"
    fi
)
</div>
</details>

<details>
<summary>Phase 2 Makefile: 
$(
    if [ $start_time -lt $t_makefile ]; then
        echo "$(duration $(($t_makefile - $t_phase_1)))" "</summary>" \
            "<div class=\"scrollbox\">" \
            "<pre>$(htmlcat "$DATADIR"/Makefile)</pre>"
    else
        echo "waiting" "</summary>" \
            "<div class=\"scrollbox\">"
    fi
)
</div>
</details>
<details>
<summary>Phase 2: 
$(
    if [ $start_time -lt $t_phase_2 ]; then
        echo "$(duration $(($t_phase_2 - $t_makefile)))" "</summary>" \
            "<div class=\"scrollbox\">" \
            "<pre>$(htmlcat "$DATADIR"/phase_2)</pre>"
    else
        echo "waiting" "</summary>" \
            "<div class=\"scrollbox\">"
    fi
)
</div>
</details>
<details>
<summary>Target update: 
$(
    if [ ${start_time} -lt ${t_stagesync} -a -s "$DATADIR"/stagesync ]; then
        echo "$(($(wc -l "$DATADIR"/stagesync | cut -f1 -d\ ) - 4)) updated files" "</summary>" \
            "<div class=\"scrollbox\">" \
            "<pre>$(htmlcat "$DATADIR"/stagesync)</pre>"
    elif [ -z ${term_status} ]; then
        echo "waiting" "</summary>" \
            "<div class=\"scrollbox\">"
    else
        echo "-" "</summary>" \
            "<div class=\"scrollbox\">"
    fi
)
</div>
</details>
<details>
<summary>Errors: 
$(
    if [ -f lasterror ]; then
        echo "There were errors" "</summary>" \
            "<div class=\"scrollbox\">" \
            "<pre>$(htmlcat "$DATADIR"/lasterror)</pre>" \
            "checked"
    else
        echo "none" "</summary>" \
            "<div class=\"scrollbox\">"
    fi
)
</div>
</details>
<details>
<summary>File Manifest: 
$(
    if [ $start_time -lt $t_manifest ]; then
        echo "$(wc -l < "$DATADIR"/manifest) files" "</summary>" \
            "<div class=\"scrollbox\">" \
            "<a href=\"$DATADIR/manifest\">view</a>"
    else
        echo "waiting" "</summary>" \
            "<div class=\"scrollbox\">"
    fi
)
</div>
</details>
HTML_END
sed -n -e '/<\/body>/,$p' template.en.html
