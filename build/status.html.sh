#!/bin/sh

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
  cat <<EOF
<input type="checkbox" class="tabhandle" id="$tabname"><label class="$([ -n "$tabcontent" ] && echo filled)" for="$tabname">${tablabel}</label>
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

start_time=$(stat -c %Y "SVNchanges" ||echo 0)
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
end_time=$(stat -c %Y stagesync removed lasterror buildlog |sort -n |tail -n1)
duration=$(($end_time - $start_time))
term_status=$([ "$duration" -gt 0 -a lasterror -nt buildlog ] && echo Error || [ "$duration" -gt 0 ] && echo Success)

printf %s\\n\\n "Content-Type: text/html;charset=utf-8"
cat <<HTML_END
<html>
  <head>
    <title>Build status</title>
    <style type="text/css">
    <!--
body { width: 100%; margin: 0; padding: 1ex; }
* {
  box-sizing: border-box;
  transition: all .3s linear;
}

dl {
  display: block;
  width: 30%;
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
  width: 30%;
  font-weight: bold;
}
dd { width: 70%; }

input.tabhandle { display: none;}
input.tabhandle + label + .tabcontent {
  width: 70%; min-width: 300px;
  height: 1px;
  overflow: hidden;
  padding-top: 0; padding-bottom: 0;
  margin-top: 0; margin-bottom: 0;
  border-style: none none solid none;
}
input.tabhandle:checked + label.filled + .tabcontent {
  width: auto;
  height: auto;
  border-style: dashed solid solid solid;
}
input.tabhandle + label::before { content: '\25b9 \00a0';}
input.tabhandle + label.filled::before { content: '\25b8 \00a0';}
input.tabhandle + label.filled::after { content: ', more...';}
input.tabhandle:checked + label::before { content: '\25b9 \00a0';}
input.tabhandle:checked + label.filled::before { content: '\25be \00a0';}
input.tabhandle:checked + label.filled::after { content: ', less...';}

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

    <h2>SVN changes</h2>$(
    if [ ${start_time} -lt ${t_svnupdate} ]; then
      web_tab SVN_tab "Update at $(timestamp ${t_svnupdate})" "<pre>$(htmlcat SVNlatest)</pre>"
    else
      web_tab SVN_tab "Unconditional build, changes ignored" ""
    fi)

    <h2>Premake</h2>$(
    if [ $start_time -lt $t_premake -a $start_time -lt $t_svnupdate ]; then
      web_tab Premaketab "Premake run time $(duration $(($t_premake - $t_svnupdate)))" "$(htmlcat premake)"
    elif [ $start_time -lt $t_premake ]; then
      web_tab Premaketab "Premake run time $(duration $(($t_premake - $start_time)))" "$(htmlcat premake)"
    else
      web_tab Premaketab "waiting..." ""
    fi)

    <h2>Makefile</h2>$(
    if [ $start_time -lt $t_makefile ]; then
      web_tab Makefiletab "Generation time: $(duration $(($t_makefile - $t_premake)) )" "
      <pre>$(head Makefile |htmlcat)</pre>
      <h3>Copy rules</h3>$(web_tab Makecopytab "Generation time: $(duration $(($t_makecopy - $t_premake)))" "$(tail Make_copy |htmlcat)")
      <h3>Source copy rules</h3>$(web_tab Makescopytab "Generation time: $(duration $(($t_makesourcecopy - $t_premake)))" "$(tail Make_sourcecopy |htmlcat)")
      <h3>Glob rules</h3>$(web_tab Makeglobstab "Generation time: $(duration $(($t_makeglobrules - $t_premake)))" "$(tail Make_globs |htmlcat)")
      <h3>XSLT rules</h3>$(web_tab Makexslttab "Generation time: $(duration $(($t_makexslt - $t_premake)))" "$(tail Make_xslt |htmlcat)")
      <h3>XHTML rules</h3>$(web_tab Makexhtmltab "Generation time: $(duration $(($t_makexhtml - $t_premake)))" "$(tail Make_xhtml |htmlcat)")
      <a href="Makefile">Makefile</a>"
   else
      web_tab Makefiletab "waiting..." ""
   fi)

    <h2>File Manifest</h2>$(web_tab Manifesttab "Number of files: $(wc -l manifest |cut -d\  -f1), <a href=\"manifest\">view</a>" "")

    <h2>Makerun</h2>$(
    if [ $start_time -lt $t_makerun ]; then
      web_tab Makeruntab "Build time: $(duration $(($t_makerun - $t_makefile)) )" "<pre>$(tail buildlog |htmlcat)</pre>"
    else
      web_tab Makeruntab "waiting..." ""
    fi)

    <h2>Errors</h2>$(
    if [ $start_time -lt $t_errors ]; then
      web_tab Errortab "There were errors" "<pre>$(htmlcat lasterror)</pre>"
    else
      web_tab Errortab "none" ""
    fi)

    <h2>Files removed</h2>$(
    if [ $start_time -lt $t_removed ]; then
      web_tab Removedtab "$(wc -l removed |cut -f1 -d\ )" "<pre>$(htmlcat removed)</pre>"
    elif [ -z ${term_status} ]; then
      web_tab Removedtab "waiting..." ""
    else
      web_tab Removedtab "none" ""
    fi)

    <h2>Files updated</h2>$(
    if [ ${start_time} -lt ${t_stagesync} ]; then
      web_tab Updatedtab "$(wc -l stagesync)" "<pre>$(htmlcat stagesync)</pre>"
    elif [ -z ${term_status} ]; then
      web_tab Updatedtab "waiting..." ""
    else
      web_tab Updatedtab "-" ""
    fi)
    
  </body>
</html>

HTML_END

# vi:set filetype=html:
