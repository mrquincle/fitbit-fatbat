#!/bin/sh

#######################################################################################################################
# Very simple script that automates typing username and password after you reinstall the .apk from FitBit
#######################################################################################################################

# Usage:
#  It expects $FITBIT_USERNAME and $FITBIT_PASSWORD set as env. variables
#  Replace by read() commands if you are more comfortable with that, in that case you can get rid of the sleeps as well

# Figure out coordinates beforehand by using adb shell getevent

echo "Click to log in"
./convert.sh login.txt
./login.txt.exec

sleep 1

./convert.sh email.txt
./email.txt.exec

echo "Type in email"
text=$FITBIT_USERNAME
echo "Send text: $text"
perl sendtext.pl "$text"

echo "Wait till done typing"
sleep 2

./convert.sh password.txt
./password.txt.exec

sleep 1

echo "Type in password"
passw=$FITBIT_PASSWORD
echo "Send password: **** (you wish :-))"
perl sendtext.pl "$passw"

echo "Wait till done typing"
sleep 2

./convert.sh login1.txt
./login1.txt.exec
