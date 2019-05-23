#!/usr/bin/env bash

exec 2>/dev/null

if [ "$QUERY_STRING" = "full_build" ]; then
  if printf %s "$HTTP_REFERER" | grep -qE '^https?://([^/]+\.)?fsfe\.org/'; then
    touch ./full_build
  fi
  printf 'Location: ./\n\n'
  exit 0
fi

timestamp(){
  date -d "@$1" +"%F %T (%Z)"
}

duration(){
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

web_tab(){
  tabname="$1"
  tablabel="$2"
  tabcontent="$3"
  [ -n "$4" ] && checked='checked="checked"' || checked=''

  cat <<EOF
<input type="checkbox" class="tabhandle" id="$tabname" ${checked}
><label class="$([ -n "$tabcontent" ] && echo filled)" for="$tabname">${tablabel}</label>
<div class="tabcontent">${tabcontent}</div>
EOF
}

htmlcat(){
  sed 's;&;\&amp\;;g;
       s;<;\&lt\;;g;
       s;>;\&gt\;;g;
       s;";\&quot\;;g;
       s;'\'';\&apos\;;g;' $@
}

start_time=$(cat "start_time" || stat -c %Y "$0" || echo 0)
t_gitupdate=$(stat -c %Y "GITlatest" ||echo 0)
t_phase_1=$(stat -c %Y "phase_1" ||echo 0)
t_makefile=$(stat -c %Y "Makefile" ||echo 0)
t_phase_2=$(stat -c %Y "phase_2" ||echo 0)
t_manifest=$(stat -c %Y "manifest" ||echo 0)
t_stagesync=$(stat -c %Y "stagesync" ||echo 0)
end_time=$(cat "end_time" || echo 0)
duration=$(($end_time - $start_time))
term_status=$(if [ "$duration" -gt 0 -a -f lasterror ]; then
                echo Error
              elif [ "$duration" -gt 0 ]; then
                echo Success
              fi)

printf %s\\n\\n "Content-Type: text/html;charset=utf-8"
cat <<HTML_END
<!DOCTYPE HTML>
<html>
  <head>
    <title>Build status</title>
    <style type="text/css">
    <!--
body { width: 100%; margin: 0; padding: 1ex; }
* {
  margin: auto auto;
  box-sizing: border-box;
  transition: all .2s linear;
}

dl, .fullbuild {
  display: block;
  width: 60%;
  min-width: 320px;
}
dt, dd {
  display: inline-block;
  padding: 0 1ex .5ex 0;
  margin: 0;
  border-width: 1px;
  border-style: solid none none none;
  vertical-align: top;
}
dt {
  width: 40%;
  font-weight: bold;
}
dd { width: 60%; }

input.tabhandle { display: none;}
input.tabhandle + label + .tabcontent {
  width: 75%; min-width: 300px;
  min-height: 1px; max-height: 1px;
  overflow: hidden;
  padding-top: 0; padding-bottom: 0;
  margin-top: 0; margin-bottom: 0;
  border-style: none none solid none;
}
input.tabhandle:checked + label.filled + .tabcontent {
  width: 100%;
  min-height: 1px; max-height: 110em;
  border-style: dashed solid solid solid;
  overflow: auto;
}
input.tabhandle + label.filled { color: #008;}
input.tabhandle + label::before { content: '\25b9 \00a0';}
input.tabhandle + label.filled::before { content: '\25b8 \00a0'; color: initial;}
input.tabhandle + label.filled::after { content: ', more...';}
input.tabhandle:checked + label::before { content: '\25b9 \00a0';}
input.tabhandle:checked + label.filled::before { content: '\25be \00a0'; color: initial;}
input.tabhandle:checked + label.filled::after { content: ', less...';}

.fullbuild {
  text-align: center;
  padding: 1ex;
  border: 1px solid black;
  border-radius: 1ex;
}
span.fullbuild { color: #000; background-color: #AAA;}
a.fullbuild {
  font-weight: bold; 
  color: #FFF;
  background-color: #66D;
  border-width: 2px;
  border-color: #008;
}

h1 {
  text-align: center;
  border-width: 1px;
  border-style: none none solid none;
  margin-bottom: 1ex;
}
h2, h3, label {
  display: inline-block;
  font-size: 1em;
  line-height: 1em;
  color: #000;
  background-color: #DDF;
  border-color: #000; border-width: 1px;
  padding: .5ex 1ex 1ex 1ex;
  margin: .5em 0 0 0;
}
h2, h3 {
  width: 15%; min-width: 150px;
  font-weight: bold;
  border-style: solid none none solid;
  border-radius: 1ex 0 0 0;
}
label  {
  width: 50%; min-width: 100px;
  border-style: solid solid none none;
  background-color: #EEF;
  border-radius: 0 1ex 0 0;
}

.tabcontent {
  color: #000;
  background-color: #EEF;
  border-color: #000;
  border-width: 1px;
  border-radius: 0 1ex 1ex 1ex;
  margin: 0;
  padding: 1ex 1ex;
}
.tabcontent pre { margin: 1em 0;}
    -->
    </style>
  </head><body>
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

    <h2>Previous builds</h2>$(
      web_tab 'tab-prev' '' "
      <a href=\"./\">latest</a><br>
      $(
        ls -t status_*.html |head -n10 |while read stat; do
          t="${stat#status_}"
          t="${t%.html}"
          printf '<a href="%s">%s</a> - %s<br>' \
                 "$stat" "$(timestamp "$t")" "$(sed -rn 's;^.*<dt>Duration:</dt><dd>(.+)</dd>.*$;\1;p;T;q' "$stat")"
        done
      )"
    )

    <h2>GIT changes</h2>$(
    if [ ${start_time} -le ${t_gitupdate} ]; then
      web_tab "tab-git" \
              "at $(timestamp ${t_gitupdate})" \
              "<pre>$(htmlcat GITlatest)</pre>" \
              "checked"
    else
      web_tab "tab-git" \
              "Unconditional build, changes ignored"
    fi)

    <h2>Phase 1</h2>$(
    if [ $start_time -lt $t_phase_1 -a $start_time -lt $t_gitupdate ]; then
      web_tab "tab-phase-1" \
              "$(duration $(($t_phase_1 - $t_gitupdate)))" \
              "<pre>$(htmlcat  phase_1)</pre>"
    elif [ $start_time -lt $t_phase_1 ]; then
      web_tab "tab-phase-1" \
              "$(duration $(($t_phase_1 - $start_time)))" \
              "<pre>$(htmlcat phase_1)</pre>"
    else
      web_tab "tab-phase-1" \
              "waiting..."
    fi)

    <h2>Phase 2 Makefile</h2>$(
    if [ $start_time -lt $t_makefile ]; then
      web_tab "tab-makefile" \
              "$(duration $(($t_makefile - $t_phase_1)) )" \
              "<pre>$(htmlcat Makefile)</pre>"
   else
      web_tab "tab-makefile" \
              "waiting..."
   fi)

    <h2>Phase 2</h2>$(
    if [ $start_time -lt $t_phase_2 ]; then
      web_tab "tab-phase-2" \
              "$(duration $(($t_phase_2 - $t_makefile)) )" \
              "<pre>$(htmlcat phase_2)</pre>"
    else
      web_tab "tab-phase-2" \
              "waiting..."
    fi)

    <h2>Target update</h2>$(
    if [ ${start_time} -lt ${t_stagesync} -a -s stagesync ]; then
      web_tab "tab-sync" \
              "$(($(wc -l stagesync |cut -f1 -d\ ) - 4)) updated files" \
              "<pre>$(htmlcat stagesync)</pre>"
    elif [ -z ${term_status} ]; then
      web_tab "tab-sync" \
              "waiting..."
    else
      web_tab "tab-sync" \
              "-"
    fi)
    
    <h2>Errors</h2>$(
    if [ -f lasterror ]; then
      web_tab "tab-errors" \
              "There were errors" \
              "<pre>$(htmlcat lasterror)</pre>" \
              "checked"
    else
      web_tab "tab-errors" \
              "none"
    fi)

    <h2>File Manifest</h2>$(
    if [ $start_time -lt $t_manifest ]; then
      web_tab "tab-manifest" \
              "$(wc -l manifest | cut -d\  -f1) files" \
              "<a href=\"manifest\">view</a>"
    else
      web_tab "tab-manifest" \
              "waiting..."
    fi)
  </body>
</html>
HTML_END
