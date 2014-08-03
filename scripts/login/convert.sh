#!/bin/sh

file=${1:? "$0 requires \"file\" as first argument"}

< "$file" sed 's/://g' | sed 's/\/dev/adb shell sendevent \/dev/g' > $file.log

head -n5 $file.log
echo
echo "Print command"
< $file.log cut -f1-5 -d' ' > conv_event0.log

echo "Print click event type"
< $file.log cut -f6 -d' ' | tr '[:lower:]' '[:upper:]' > test.tmp
( echo "ibase=16" ; cat test.tmp ) | bc > conv_event1.log

echo "Print event parameters"
< $file.log cut -f7 -d' ' | tr '[:lower:]' '[:upper:]' > test.tmp
( echo "ibase=16" ; cat test.tmp ) | bc > conv_event2.log

echo "Paste together"
paste -d ' ' conv_event0.log conv_event1.log conv_event2.log > $file.exec

chmod a+x $file.exec
