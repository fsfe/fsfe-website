#!/usr/bin/env bash

exec 2>/dev/null

if [ "$QUERY_STRING" = "full_build" ]; then
    if printf %s "$HTTP_REFERER" | grep -qE '^https?://([^/]+\.)?fsfe\.org/'; then
        touch ./full_build
    fi
    printf 'Location: ./\n\n'
    exit 0
fi

timestamp() {
    date -d "@$1" +"%F %T (%Z)"
}

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

start_time=$(cat "start_time" || stat -c %Y "$0" || echo 0)
t_gitupdate=$(stat -c %Y "GITlatest" || echo 0)
t_phase_1=$(stat -c %Y "phase_1" || echo 0)
t_makefile=$(stat -c %Y "Makefile" || echo 0)
t_phase_2=$(stat -c %Y "phase_2" || echo 0)
t_manifest=$(stat -c %Y "manifest" || echo 0)
t_stagesync=$(stat -c %Y "stagesync" || echo 0)
end_time=$(cat "end_time" || echo 0)
duration=$(($end_time - $start_time))
term_status=$(if [ "$duration" -gt 0 -a -f lasterror ]; then
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
$(if [ ./full_build -nt ./index.cgi ]; then
    printf '<span class="fullbuild">Full rebuild will be started within next minute.</span>'
else
    printf '<a class="fullbuild" href="./?full_build">Schedule full rebuild</a>'
fi)
<details>
<summary>Previous builds</summary>
<div class="scrollbox">
<a href="./">latest</a><br>
$(
    ls -t status_*.html | head -n10 | while read stat; do
        t="${stat#status_}"
        t="${t%.html}"
        printf '<a href="%s">%s</a> - %s<br>' \
            "$stat" "$(timestamp "$t")" "$(sed -rn 's;^.*<dt>Duration:</dt><dd>(.+)</dd>.*$;\1;p;T;q' "$stat")"
        printf $'\n'
    done
)
</div>
</details>
<details>
<summary>GIT changes</summary>
<div class="scrollbox">
$(
    if [ ${start_time} -le ${t_gitupdate} ]; then
        echo "at $(timestamp ${t_gitupdate})" \
            "<pre>$(htmlcat GITlatest)</pre>" \
            "checked"
    else
        echo "Unconditional build, changes ignored"
    fi
)
</div>
</details>
<details>
<summary>Phase 1</summary>
<div class="scrollbox">
$(
    if [ $start_time -lt $t_phase_1 -a $start_time -lt $t_gitupdate ]; then
        echo "$(duration $(($t_phase_1 - $t_gitupdate)))" \
            "<pre>$(htmlcat phase_1)</pre>"
    elif [ $start_time -lt $t_phase_1 ]; then
        echo "$(duration $(($t_phase_1 - $start_time)))" \
            "<pre>$(htmlcat phase_1)</pre>"
    else
        echo "waiting"
    fi
)
</div>
</details>

<details>
<summary>Phase 2 Makefile</summary>
<div class="scrollbox">
$(
    if [ $start_time -lt $t_makefile ]; then
        echo "$(duration $(($t_makefile - $t_phase_1)))" \
            "<pre>$(htmlcat Makefile)</pre>"
    else
        echo "waiting"
    fi
)
</div>
</details>
<details>
<summary>Phase 2</summary>
<div class="scrollbox">
$(
    if [ $start_time -lt $t_phase_2 ]; then
        echo "$(duration $(($t_phase_2 - $t_makefile)))" \
            "<pre>$(htmlcat phase_2)</pre>"
    else
        echo "waiting"
    fi
)
</div>
</details>
<details>
<summary>Target update</summary>
<div class="scrollbox">
$(
    if [ ${start_time} -lt ${t_stagesync} -a -s stagesync ]; then
        echo "$(($(wc -l stagesync | cut -f1 -d\ ) - 4)) updated files" \
            "<pre>$(htmlcat stagesync)</pre>"
    elif [ -z ${term_status} ]; then
        echo "waiting"
    else
        echo "-"
    fi
)
</div>
</details>
<details>
<summary>Errors</summary>
<div class="scrollbox">
$(
    if [ -f lasterror ]; then
        echo "There were errors" \
            "<pre>$(htmlcat lasterror)</pre>" \
            "checked"
    else
        echo "none"
    fi
)
</div>
</details>
<details>
<summary>File Manifest</summary>
<div class="scrollbox">
$(
    if [ $start_time -lt $t_manifest ]; then
        echo "$(wc -l manifest | cut -d\-f1) files" \
            "<a href=\"manifest\">view</a>"
    else
        echo "waiting"
    fi
)
</div>
</details>
HTML_END
sed -n -e '/<\/body>/,$p' template.en.html
