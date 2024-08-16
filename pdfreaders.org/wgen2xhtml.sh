#!/bin/sh
sed -rn '
/---/,/---/{
  s:^HeaderTitle\: *(.+)$:<?xml version="1.0" encoding="utf-8" ?>\
<html> <head>\
  <title>\1</title>\
</head> <body>\
  :p;d
};
1,${
  s:\{link\: *\{path\: *([^,]+), *attr\: *\{\:link_text\: *([^\}]+)\}\}\}:<a href="\1">\2</a>:g
  s:href="index.html":href="pdfreaders.html":g
  s:\{relocatable\: *(.+)\}:.\1:g
  s:^.*$:  &:p
};
$a</body> </html>
'
