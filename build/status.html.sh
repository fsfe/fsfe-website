#!/bin/sh

exec 2>/dev/null

timestamp(){
  date -d "@$1" +"%F %T (%Z)"
}
duration(){
  printf %s "$(($1 / 60))min $(($1 % 60))s"
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
  sed 's;<;\&lt\;;g;
       s;>;\&gt\;;g;
       s;&;\&amp\;;g;
       s;";\&quot\;;g;
       s;'\'';\&apos\;;g;' $@
}

start_time=$(cat "start_time" || stat -c %Y "$0" || echo 0)
t_svnupdate=$(stat -c %Y "SVNlatest" ||echo 0)
t_premake=$(stat -c %Y "premake" ||echo 0)
t_makefile=$(stat -c %Y "Makefile" ||echo 0)
t_makecopy=$(stat -c %Y "Make_copy" ||echo 0)
t_makesourcecopy=$(stat -c %Y "Make_sourcecopy" ||echo 0)
t_makeglobrules=$(stat -c %Y "Make_globs" ||echo 0)
t_makexslt=$(stat -c %Y "Make_xslt" ||echo 0)
t_makexhtml=$(stat -c %Y "Make_xhtml" ||echo 0)
t_manifest=$(stat -c %Y "manifest" ||echo 0)
t_makerun=$(stat -c %Y "buildlog" ||echo 0)
t_errors=$(stat -c %Y "lasterror" ||echo 0)
t_removed=$(stat -c %Y "removed" ||echo 0)
t_stagesync=$(stat -c %Y "stagesync" ||echo 0)
end_time=$(cat "end_time" || echo 0)
duration=$(($end_time - $start_time))
term_status=$(if [ "$duration" -gt 0 -a lasterror -nt start_time ]; then
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

dl {
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

    <h2>Previous builds</h2>$(
      web_tab prev_tab '' "
      <a href=\"./\">latest</a>
      $(
        ls -t status_*.html |head -n10 |while read stat; do
          t="${stat#status_}"
          t="${t%.html}"
          printf '%s' "<a href=\"$stat\">$(timestamp "$t")</a> - $(sed -rn 's;^.*<dt>Duration:</dt><dd>(.+)</dd>.*$;\1;p;T;q' "$stat")<br>"
        done
      )"
    )

    <h2>SVN changes</h2>$(
    if [ ${start_time} -lt ${t_svnupdate} ]; then
      web_tab SVN_tab "at $(timestamp ${t_svnupdate})" "<pre>$(htmlcat SVNlatest)</pre>" checked
    else
      web_tab SVN_tab "Unconditional build, changes ignored" ""
    fi)

    <h2>Premake</h2>$(
    if [ $start_time -lt $t_premake -a $start_time -lt $t_svnupdate ]; then
      web_tab Premaketab "Premake run time $(duration $(($t_premake - $t_svnupdate)))" "<pre>$(tail premake |htmlcat)</pre><a href="premake">full log</a>"
    elif [ $start_time -lt $t_premake ]; then
      web_tab Premaketab "Premake run time $(duration $(($t_premake - $start_time)))" "<pre>$(tail premake |htmlcat)</pre><a href="premake">full log</a>"
    else
      web_tab Premaketab "waiting..." ""
    fi)

    <h2>Makefile</h2>$(
    if [ $start_time -lt $t_makefile ]; then
      web_tab Makefiletab "Generation time: $(duration $(($t_makefile - $t_premake)) )" "
      <h3>Header</h3>$(web_tab Makeheadertab "" "<pre>$(head Makefile |htmlcat)</pre>")
      <h3>Copy rules</h3>$(web_tab Makecopytab "Generation time: $(duration $(($t_makecopy - $t_premake)))" "<pre>$(tail Make_copy |htmlcat)</pre>")
      <h3>Source copy rules</h3>$(web_tab Makescopytab "Generation time: $(duration $(($t_makesourcecopy - $t_premake)))" "<pre>$(tail Make_sourcecopy |htmlcat)</pre>")
      <h3>Glob rules</h3>$(web_tab Makeglobstab "Generation time: $(duration $(($t_makeglobrules - $t_premake)))" "<pre>$(tail Make_globs |htmlcat)</pre>")
      <h3>XSLT rules</h3>$(web_tab Makexslttab "Generation time: $(duration $(($t_makexslt - $t_premake)))" "<pre>$(tail Make_xslt |htmlcat)</pre>")
      <h3>XHTML rules</h3>$(web_tab Makexhtmltab "Generation time: $(duration $(($t_makexhtml - $t_premake)))" "<pre>$(tail Make_xhtml |htmlcat)</pre>")
      <h3>Full Makefile</h3>$(web_tab Makefilefull "<a href="Makefile">view</a>" "")"
   else
      web_tab Makefiletab "waiting..." ""
   fi)

    <h2>Makerun</h2>$(
    if [ $start_time -lt $t_makerun ]; then
      web_tab Makeruntab "Build time: $(duration $(($t_makerun - $t_makefile)) )" "<pre>$(tail buildlog |htmlcat)</pre><a href=\"buildlog\">view full</a>"
    else
      web_tab Makeruntab "waiting..." ""
    fi)

    <h2>Errors</h2>$(
    if [ $start_time -lt $t_errors ]; then
      web_tab Errortab "There were errors" "<pre>$(htmlcat lasterror)</pre>"
    else
      web_tab Errortab "none" ""
    fi)

    <h2>File Manifest</h2>$(web_tab Manifesttab "Number of files: $(wc -l manifest |cut -d\  -f1)" "<pre>$(tail manifest |htmlcat)</pre><a href=\"manifest\">view full</a>")

    <h2>Files removed</h2>$(
    if [ $start_time -lt $t_removed -a -s "removed" ]; then
      web_tab Removedtab "$(wc -l removed |cut -f1 -d\ )" "<pre>$(htmlcat removed)</pre>"
    elif [ $start_time -lt $t_removed ]; then
      web_tab Removedtab "none" ""
    elif [ -z ${term_status} ]; then
      web_tab Removedtab "waiting..." ""
    else
      web_tab Removedtab "none" ""
    fi)

    <h2>Files updated</h2>$(
    if [ ${start_time} -lt ${t_stagesync} -a -s stagesync ]; then
      web_tab Updatedtab "Updated $(( $(wc -l stagesync |cut -f1 -d\ ) - 4 )) files" "<pre>$(htmlcat stagesync)</pre>"
    elif [ -z ${term_status} ]; then
      web_tab Updatedtab "waiting..." ""
    else
      web_tab Updatedtab "-" ""
    fi)
    
  </body>
</html>

HTML_END

# vi:set filetype=html:
