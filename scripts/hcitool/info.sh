#!/bin/sh

if=hci1
addr=C5:D5:CB:80:70:9E

echo "I have to figure out how to do this interative... For now type"

echo "connect $addr"
echo "primary"

sudo gatttool -i $if -b $addr -I 
#sudo gatttool -i $if -b $addr -I <<< "connect $addr"
#sudo gatttool -i $if -b $addr -I <<< "primary"
