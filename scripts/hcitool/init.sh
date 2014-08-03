#!/bin/sh

if=hci1
addr=C5:D5:CB:80:70:9E

sudo hcitool -i $if lecc --random $addr 
